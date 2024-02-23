namespace riskmanagement;

using {
    managed,
    cuid,
    User,
    sap.common.CodeList
} from '@sap/cds/common';

entity Risks : cuid, managed {
    key ID                      : UUID @(Core.Computed: true);
        title                   : String(100);
        owner                   : String;
        prio_code               : String(5);
        descr                   : String;
        miti                    : Association to Mitigations;
        impact                  : Integer;
        bp : Association to BusinessPartners; // You will need this definition in a later step
        virtual criticality     : Integer;
        virtual PrioCriticality : Integer;
}

entity Mitigations : cuid, managed {
    key ID       : UUID @(Core.Computed: true);
        descr    : String;
        owner    : String;
        timeline : String;
        risks    : Association to many Risks
                       on risks.miti = $self;
}

entity Priority : CodeList {
    key code : String enum {
            high   = 'High';
            medium = 'Medium';
            low    = 'Low';
        };
}

// using an external service from SAP S/4HANA Cloud
using { API_BUSINESS_PARTNER as external } from '../srv/external/API_BUSINESS_PARTNER.csn';

entity BusinessPartners as projection on external.A_BusinessPartner {
    key BusinessPartner,
    BusinessPartnerFullName as FullName,
}
