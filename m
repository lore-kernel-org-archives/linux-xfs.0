Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B04C4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 17:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70B522173E
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 17:47:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="ZLzcqoJZ";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="DQY61f/3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbgEARrz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 13:47:55 -0400
Received: from rcdn-iport-6.cisco.com ([173.37.86.77]:15106 "EHLO
        rcdn-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729393AbgEARry (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 13:47:54 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 May 2020 13:47:52 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1742; q=dns/txt; s=iport;
  t=1588355272; x=1589564872;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=zOtkAFfTRplF10f07yqfbQJdSSqD7dymlhMOHlhWYs4=;
  b=ZLzcqoJZP9qn4YAFe/WiRN9if1RqckoNvKtOrXE0J7q60zx9PMD4DN4r
   in6flrN9KNyb4Nbk6PtVo2XTf35cmPTbfaXo2QMOexAUpTornAQHa8p3u
   7bBZwrYijO5TwAfA8tKNnivXkDqEoEY+tOA7mPVht2X06/0Muq2tRorIc
   I=;
IronPort-PHdr: =?us-ascii?q?9a23=3Aov0hgR9MNZn9ef9uRHGN82YQeigqvan1NQcJ65?=
 =?us-ascii?q?0hzqhDabmn44+7ZhKN+/pglhnKUJ/d5vYCjPDZ4OjsWm0FtJCGtn1KMJlBTA?=
 =?us-ascii?q?QMhshemQs8SNWEBkv2IL+PDWQ6Ec1OWUUj8yS9Nk5YS9jxakeUoXCo6zMWXB?=
 =?us-ascii?q?LlOlk9KuH8AIWHicOx2qi78IHSZAMdgj27bPtyIRy6oB+XuNMRhN5pK706zV?=
 =?us-ascii?q?3CpX4bdg=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BlDABq1qte/4MNJK1mgQmBR4FUUQW?=
 =?us-ascii?q?BRi8qhCKDRgOLNIFsmFeCUgNUCwEBAQwBAS0CBAEBgVCDDYIZJDcGDgIDAQE?=
 =?us-ascii?q?LAQEFAQEBAgEFBG2FVgELhgoREQwBATgRASICJgIEMBUSBDWDBIJMAy4BqH4?=
 =?us-ascii?q?CgTmIYXaBMoMAAQEFgkmDBhiCDgmBDiqCY4leGoIAgTgMEIprM4ILIpFFoQM?=
 =?us-ascii?q?KgkaYCh2dFJAPnRYCBAIEBQIOAQEFgWgjgVZwFWUBgj5QGA2QeoM6ilZ0NgI?=
 =?us-ascii?q?GAQcBAQMJfI4/AQE?=
X-IronPort-AV: E=Sophos;i="5.73,339,1583193600"; 
   d="scan'208";a="762840084"
Received: from alln-core-1.cisco.com ([173.36.13.131])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 01 May 2020 17:40:47 +0000
Received: from XCH-RCD-005.cisco.com (xch-rcd-005.cisco.com [173.37.102.15])
        by alln-core-1.cisco.com (8.15.2/8.15.2) with ESMTPS id 041HelT0025470
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 1 May 2020 17:40:47 GMT
Received: from xhs-aln-003.cisco.com (173.37.135.120) by XCH-RCD-005.cisco.com
 (173.37.102.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 1 May
 2020 12:40:47 -0500
Received: from xhs-aln-002.cisco.com (173.37.135.119) by xhs-aln-003.cisco.com
 (173.37.135.120) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 1 May
 2020 12:40:46 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-002.cisco.com (173.37.135.119) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 1 May 2020 12:40:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SMdHoV5fkTuKFRbjRJvQH0Q6BsBe6TKAmZiYtnrRvG6fjMKek0+4dSdQjzgOPY6jO/REExLml++dazgIDcI1jdl10Rs5k1Ysv/QRaO/yWS7CzjmjkNFtPFkXm12EhfCjmVPrt8z2kQ7s2xrcGb7KpQ9IitQJ+s1PxEVzoRkRuoxLebMhOOWzMgDvnAcJ7QTCWrH3tOsusRzSXijlcGqB5yPrMBwnEiDSkNoceTlPE+6SJXkCzjf0P9lbZdHFecYRl5R2Ez/nFd30O0M16G1XnSxZ5kZOxWx0s5IjSgejCSS/tvI16p7omUikXMb7Z8WYLsC/Ua249KyaHp4+hnOZVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOtkAFfTRplF10f07yqfbQJdSSqD7dymlhMOHlhWYs4=;
 b=GlknsVF/gDLImqUFWm+gKifEHTha7jMfzoIDTE1BZHqh0r6WPpw0lxOgj/a/EE9o1WiEoBRfLXqIDj8dtMa95gwzVOZbZnc99KTXEKikiylxps5HEruLhZrGjSyLjsYcDvDWQH8EOSyp15CoTIpNTlBVAyHfy1Ai9/yhfaegf86lt8mUYT6U3Z3RUop5mic4Uk2wUTT4LKxk9+/YsSA0lLvOJVsh25h1V8Qupb0pLIaOyZZ/O7HXzqzh+RQyEIjyPYRnYqDHwDv/pYZyFfn3mRDOEGR2WMS3yPyxhDzxPmG/RHY1H1Kf4QZom18numPMcVSWg3eRtlHUuK/asQFcuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOtkAFfTRplF10f07yqfbQJdSSqD7dymlhMOHlhWYs4=;
 b=DQY61f/3g/HzQ7Mq8ZCxkVq7VynRBBL2NY586E0mDaWMt64MUt08zBwp2v2rHV5jWij+WcSk+pYmTFu7BbCI8ju9KsITyWtI1EqMLscsLY1HYlwzpse+fWx/cv8wDZaueJFWu46GxQEfPElRUp7QXL38SZl8PcIbw3GAHiA8wJ4=
Received: from BYAPR11MB2694.namprd11.prod.outlook.com (2603:10b6:a02:c7::20)
 by BYAPR11MB3157.namprd11.prod.outlook.com (2603:10b6:a03:75::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Fri, 1 May
 2020 17:40:45 +0000
Received: from BYAPR11MB2694.namprd11.prod.outlook.com
 ([fe80::459e:e317:d860:200d]) by BYAPR11MB2694.namprd11.prod.outlook.com
 ([fe80::459e:e317:d860:200d%4]) with mapi id 15.20.2937.028; Fri, 1 May 2020
 17:40:45 +0000
From:   "Saravanan Shanmugham (sarvi)" <sarvi@cisco.com>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Snapshot/Cloned workspace with changed file/directory ownership for
 all files in clone
Thread-Topic: Snapshot/Cloned workspace with changed file/directory ownership
 for all files in clone
Thread-Index: AQHWH9+kZtdwjHZCmUSoDvwFvK4wJQ==
Date:   Fri, 1 May 2020 17:40:45 +0000
Message-ID: <DE682B09-7215-41EB-9D1F-25BFB41410E5@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.35.20030802
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [2601:647:4900:b0:e866:5b5f:d77d:4110]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ab7360e-eb80-43c2-cfcd-08d7edf6c724
x-ms-traffictypediagnostic: BYAPR11MB3157:
x-microsoft-antispam-prvs: <BYAPR11MB3157926A6B0181A9C713CB84BFAB0@BYAPR11MB3157.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0390DB4BDA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2694.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(39860400002)(376002)(396003)(366004)(8676002)(66946007)(76116006)(66476007)(6512007)(6916009)(33656002)(66446008)(64756008)(186003)(478600001)(86362001)(2906002)(71200400001)(66556008)(2616005)(36756003)(6486002)(8936002)(316002)(5660300002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TqpUYiRhHwqJ4G3wwwKX5RH7oS1Ce5G528puTGuf+KErYZrUnSH+piK0S9yQN/5cwoRlXK5damcwg5v8Cypnc6JPwlWo+M/AN/OZIuC5nmsWWYMze8JVZk4JaaYDjVJ2vKWrgfjqbKkmKPkTbvoDEvDyFa91ryXLAyCIQRWd26NRu6/j9QLmCou4Vl0UQYPofAlynPk7ghD2sodlL4zW1HQpdbe3IIylwWMipY6XugTcbvRoruKotJoGXXtkG1eJDTd9ud8ziW+XrNZM2tRLKvaVa7sLwsDFbOhI/6LJMBCm5p6fFfvxuv6jgbfoiVnIm/d9HisKEVYaFRclvaVNiJFk5Sj5wuY+8cB5uKefaBunqjyjyVUDz/jQnhqS4pAPdswhnO9Xx3iy9Jm7zLLJMV5exf12RxDNZ4DJwA+T/EL6ltNIOC1gzkXu+VyCEV2D
x-ms-exchange-antispam-messagedata: mjl/RJPasWfy6VJwLJ39LEmhk0q7cPVHl7QCi8UBPQYUgcCeaEtaeJs3Xb6eoVjYmf4mY4S7jfU3LFtdWl09sPNon6k08siiv+X5F3Y/exCTyczzxdh4B873gRcLhFoAKc+esR27QD8fSyc8fRruq6rz+zg+2ZMvoEY2C6ixOkIaa4FL3areg+8Ue/ouAM6z6mcU6xJtxcPaeg67sHGAxgvVvnNspKxtTeXITZe/QNlOBplmf+F1kLYSeQ1YfAND3LSdgFwRjZLcvE75BNRgyOuhPWf79pUQNoszfUQ2TmMS9jvlEzKKXiaTF5p5Zd2hbzxIrBWagFqwZzfVW0+Ewf4g4j+1d2c0W9CiVZ1gdhCqN6u/XrUYXtcsi0RAMn4yCkGhXsOzuK29N/s0O2RtCR+S4xlYAzjoAUKt2s80RF/mXjkMvpQojoD/rLKJKr8v/mgaNe3TvZtXKb04/fYmcwJKm5Vyk2Ml9c0gRZgmJRcbRXTnuryHc2Z2Wgukde0Sc5MfW9wobPhc0z8Rci6Jq03z0dn0UwetFV1uI+T5i14eT01P6kOnxtbXaH3hTtf4QRyeoJJm3bjcyB3gWeVZEAFLW/I8e+woPtns9W47KHE5GgnjhcyiASqC+Uc89/qA9BZLhy8wOgNHy8ISZmhPBtIVKq/YStb25fpsTQe6BVxAGtVXg5FTZ1fE9Rdvt2BaHofLewIFnyPUIkVLx/Nif5FxKI1rvpqvmlWgYdD0Rky+7YDH5Qfo6lkLicxVNo+wCiSsz7fuJW6bYjWkh7kJrQSdHN61e2EQ5OxpTHvlo0YvEOsgOR57lZw5nvmCgem2Q3/3JIjpjvwXhUWBqs4c4LTCga5OCBViKWGWnC/8ArE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B4B46BE6AE0464491A92F8740094948@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ab7360e-eb80-43c2-cfcd-08d7edf6c724
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2020 17:40:45.4141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qHXX+CYYj8v+ZfZVs8odYcTKCo10Vxij50Y5Kll70eAuNGA4IiGo+3qKkFb4orDO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3157
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.15, xch-rcd-005.cisco.com
X-Outbound-Node: alln-core-1.cisco.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T25lIHVzZSBjYXNlIGZvciAiY2xvbmVkIiB3b3Jrc3BhY2VzIG9yICJzZWVkZWQiIHdvcmtzcGFj
ZXMsIGlzICJwcmVidWlsdCB3b3Jrc3BhY2VzIiBmb3IgdmVyeSBsYXJnZSBidWlsZHMuDQoNCldo
YXQgd291bGQgaXQgdGFrZSB0byBhZGQgdGhpcyBjYXBhYmlsaXR5IHRvIHRoZSB4ZnMgcm9hZG1h
cD8gVGhpcyB3b3VsZCBiZSB2ZXJ5IHVzZWZ1bGwuDQoNCk91ciB1c2UgY2FzZSBpcyBhcyBmb2xs
b3dpbmcNCsKgwqAgMS4gT3VyIGZ1bGx5IGJ1aWx0IHNvZnR3YXJlIGJ1aWxkIHdvcmtzcGFjZXMg
Y2FuIGJlIDgwMEdCKw0KwqDCoCAyLiBXZSBoYXZlIGEgbmlnaHRseSBidWlsZCB0aGF0IGJ1aWxk
cyB0aGUgd2hvbGUgd29ya3NwYWNlIDgwMEdCLCBkb25lIGJ5IGEgZ2VuZXJpYyB1c2VyICJidWls
ZHVzciINCsKgwqAgMy4gV2UgdGhlbiBzbmFwc2hvdCB0aGF0IHdvcmtzcGFjZSB3aXRoIHhmcyBz
bmFwc2hvdHRpbmcgY2FwYWJpbGl0eS4NCsKgwqAgMy4gV2Ugd2FudCB0aGUgZGV2ZWxvcGVyLCAi
c2FydmkiLCB0byBiZSBhYmxlIHRvIGNsb25lIGZyb20gdGhhdCBzbmFwc2hvdCBhbmQgYmUgYWJs
ZSB0byBpbmNyZW1lbnRhbCBzb2Z0d2FyZSBidWlsZCBhbmQgZGV2ZWxvcG1lbnQgaW4gdGhlIGNs
b25lZCB3b3Jrc3BhY2Ugb3IgdGhlIHNlZWRlZCBmaWxlc3lzdGVtL3dvcmtzcGFjZS4NCg0KUHJv
YmxlbTrCoA0KQWxsIHRoZSBjb250ZW50LCBmaWxlcywgZGlyZWN0b3JpZXMgaW4gdGhlIGNsb25l
ZCB3b3Jrc3BhY2UgYXJlIHN0aWxsIG93bmVkIGJ5ICJidWlsZHVzciIgYW5kIG5vdCAic2Fydmki
LCB3aGljaCBjYXVzZXMgbXkgYnVpbGRzIHRvIGZhaWwgd2l0aCBwZXJtaXNzaW9uIHByb2JsZW1z
Lg0KSXMgdGhlcmUgYW55dGhpbmcgaW4geGZzIHRoYXQgY2FuIGhlbHAuwqANCkZvciB0aGF0IG1h
dHRlciBhbnkgb2YgdGhlIG9wZW4gc291cmNlIGZpbGVzeXN0ZW1zIHN1cHBvcnQgc2VlZGluZyBv
ciBzbmFwc2hvdC9jbG9uaW5nIHRoYXQgeW91IG1pZ2h0IGJlIGF3YXJlIG9mLg0KDQpTbyBmYXIg
dGhlIG9ubHkgZmlsZXN5c3RlbSB0aGF0IHNlZW1zIGhhdmUgdGhlIGNhcGFiaWxpdHkgbWFwL2No
YW5nZSB0aGUgZmlsZSBvd25lcnNoaXAgYXMgcGFydCBvZiB0aGUgY2xvbmUgb3BlcmF0aW9uIGlz
IE5ldGFwcC7CoA0KQW5kIHVuZm9ydHVuYXRlbHkgdGhhdCBpc27igJl0IG9wZW4gc291cmNlIGFu
ZCB3b250IHNlcnZlIG91ciBwdXJwb3NlLg0KDQogDQpUaGFua3MsDQpTYXJ2aQ0KT2NjYW3igJlz
IFJhem9yIFJ1bGVzDQoNCg==
