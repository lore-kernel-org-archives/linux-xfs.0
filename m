Return-Path: <SRS0=i/dn=4D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C6BC35242
	for <linux-xfs@archiver.kernel.org>; Sat, 15 Feb 2020 01:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EACC42073A
	for <linux-xfs@archiver.kernel.org>; Sat, 15 Feb 2020 01:38:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kfkLpRUf";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bY0+ISY5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgBOBiI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Feb 2020 20:38:08 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:30072 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbgBOBiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Feb 2020 20:38:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1581730688; x=1613266688;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=MkqYpaqrbCygOSIf59ishWw0kIMCJ1qXkGRXNihve7Q=;
  b=kfkLpRUfhtYusUJGIx2jca0MlKcVFSp3AI15uqcw4IfXZDwD/42Fdhga
   6iECdNrL7+2SBC28iCFD8V/kgipgcif6bJVC0XMalfEfM2WZMfsgVEYo3
   +D7JaqT3nsrHy1QM4Zmj7SOhO9I0fxx9g8r7xQJuvuwX/m8U9Rs9Qf7bH
   UJCGJ6Cpq94NZad3wRNh8tyUHAOYr1gixNh+6BcB2jiPIdwGoik0QzXyd
   eIpsu/gcXn6XrU+abCcKAyvo7H6dCpKmINur/o5hdD4Zuvxjjkbjdg3V7
   kBHew7FzNaXd4nIq352+QTA4aPXizzlo6jg4I7zKpHmsrOeiH13BSZCo0
   Q==;
IronPort-SDR: oufyciip3huUOf4aUMrWoaLMxwoNDuAQsIlpV91tOYRPhdJhMuYpnCOvU9L5v6V7BaRQVflZu1
 t/f5rzk++m6mI/saeMCqxkWUB//pV6DMBNvtQeG6kqrE+uAE2JvBu5Bg2oK00gBICogAZNT7vG
 SNvXXi1cnsodGDYFck3m+oTXR44whBwzwPFFrd+1BftqAam6vwKFjtskQqDHXn6tPDwPxSSV7c
 tnDBvEP3QCWz2kwNqopMbWWDy3Zsn7GPYf+z0HuTxZdp29wcTfc0jvc8ppsE4+hfQwYNcNmKpz
 RgY=
X-IronPort-AV: E=Sophos;i="5.70,442,1574092800"; 
   d="scan'208";a="131347632"
Received: from mail-bn3nam04lp2053.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.53])
  by ob1.hgst.iphmx.com with ESMTP; 15 Feb 2020 09:38:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDBh16W39d2m/ne/PX2Tt5M90eU1oKIHMrSrIgcdBQkSetvYN7XejylLbyWQK6AGBcfuSN2wDRWRs8occmWOOaGSR2vjxu1EgUC+q9WEMpr4/0NgWaJCHd78PA7yf11kO/NcXaqHNVSkFh/0Iy1Ac336QUGKXfxEHklLMaHuQQtYBlpcmtGC42wOthjqLOarEeyN9iw3QS5iWKdq36bl4JqYBqaQq5C0fRq831FexQuRXQ9hJ9UAKwrXSQHIqMVniOfOx6C+uPIBKvHvuOE/4oMukNB03CNK3GfVsRlJSzojTFftHxXZ6nx57+HmVAS+1go8qHg8Kr+LuJ6CoVg78Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MkqYpaqrbCygOSIf59ishWw0kIMCJ1qXkGRXNihve7Q=;
 b=mh1DeTMWPQtiCFz2Qb4/BCL3yWsSCr2EloAuWcu6xEM/l40jnfHlhlaTasHJeGXzfRPnkwdBX1r8lTk9jCtdOdaq3Fh93aG6ZZlB9S6yS7iHR8cIlaRGfk3/ZLb/vI21ukBF5f4MSFb9qG0i1d6XeOmmqVeFptrsCVARveCmn/DSPCWBKkl4FS5yBdTBMeSkzh72iZWq5iEg1yMBKaEJYG0vP2MLM+XSRbf6zVF6njBDuLP2su3pbjOgQIKiNHkh6+kMEFgVqnCsgqbrTBYFC3iWGHnhOlIEFQVbxhD4+OBROlccfCcKuMeDsy3UOicFCeFgItgZJsNfQ5TgcHaXkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MkqYpaqrbCygOSIf59ishWw0kIMCJ1qXkGRXNihve7Q=;
 b=bY0+ISY5nY38hRZuqiJlfhXpM2RfDMKNuSLJUZ9aYJ7CjxDbMXLvm9dD30lXhOjb21owCrGDZw0hpF+CFcEFsRNQesK7KFOgavgLFfdtKRsua+ycV+xxbnPrpA1sCRdq3fOR7PG0RRD1S3wCOa/uCfscS8iNmOPxiZ/L9JWHSwk=
Received: from DM6PR04MB5754.namprd04.prod.outlook.com (20.179.51.24) by
 DM6PR04MB4170.namprd04.prod.outlook.com (20.176.78.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Sat, 15 Feb 2020 01:38:04 +0000
Received: from DM6PR04MB5754.namprd04.prod.outlook.com
 ([fe80::c0fb:7c35:bcd2:fd28]) by DM6PR04MB5754.namprd04.prod.outlook.com
 ([fe80::c0fb:7c35:bcd2:fd28%2]) with mapi id 15.20.2729.025; Sat, 15 Feb 2020
 01:38:04 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Pavel Reichl <preichl@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v5 1/4] xfs: Refactor xfs_isilocked()
Thread-Topic: [PATCH v5 1/4] xfs: Refactor xfs_isilocked()
Thread-Index: AQHV42kEDs8e/WrrJU6iifDPQ+S/cQ==
Date:   Sat, 15 Feb 2020 01:38:04 +0000
Message-ID: <DM6PR04MB57544CDC68D9DFAB48B61F1386140@DM6PR04MB5754.namprd04.prod.outlook.com>
References: <20200214185942.1147742-1-preichl@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 67115e9e-cf69-4b53-8a53-08d7b1b7b3a7
x-ms-traffictypediagnostic: DM6PR04MB4170:
x-microsoft-antispam-prvs: <DM6PR04MB417073F0BB4FF08E1CD4E41B86140@DM6PR04MB4170.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 03142412E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(189003)(199004)(6506007)(53546011)(26005)(4744005)(186003)(66556008)(55016002)(66446008)(478600001)(66946007)(76116006)(9686003)(52536014)(66476007)(5660300002)(316002)(91956017)(64756008)(71200400001)(81166006)(33656002)(86362001)(7696005)(81156014)(8676002)(8936002)(110136005)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR04MB4170;H:DM6PR04MB5754.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lGwMxIHcdhyLmUwZitfiCNGQaRvGvOHi48LIQW0DlaRB01avbzvaiTjMAgSQrU5nxq+chcMabfrebIc5CdoIRHaK35bDq0773YYocIRJtGYUUZhLkkC6A5oP42bUgz3bL3cv6UPv9VH3uzURW0JbFdDWNgTkKYDkXMy7WcbVduryy+zQplBmyzqx0+r3YyV/OebnGq397rTjQTMW5YAj1pGxz5h/PrLlGyaWQ5eNU3Fv6t/ZEcBi8h5bv0U9Z5iQEjLXGOlvXw9gsWvRGUbmaJkoFPyglxWtZgL/qDU1zjWshoYv5YpXH9KyXETU2x0I65jRjcA5N4XAO37kFdZ5diUJJTNFBN6Lm87Q544hyPmceWLrhaPh/3UX2nt7zp4eEFcb0aeIJZiklUYFDp5ursAs3LBptvwpERa2TVIiKfh2G3uEgBQ07p0AsKmS3ZbT
x-ms-exchange-antispam-messagedata: KSF5l2uYCXnjnrcdzqjb7CTQCUtifa3gvSQVzVnjSQxB8rU8C3G3Z9MQHM/hmCFLqCMWkMngaDMyia4I+3swwV1wPqU6Zk7Rpwm3Ai4eaSrU17RNJWf/gVK36Mc/mO3xy85ta94mUFSGlF7KEgFk0A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67115e9e-cf69-4b53-8a53-08d7b1b7b3a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2020 01:38:04.6228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RIVC10Tl0gB+RTK34uKg0KiItXHFipozTXkQCKMNCW8q+sCSz1Ns+TU82Bok4ipc6GFRrRK5S7EulkbdHEum5JfsrUd1PrKsmb2j/VYa3Ms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since it has more than one patch and version 5,=0A=
I couldn't find the cover-letter and a change log for this=0A=
series, is there a particular reason why it is not present or I=0A=
missed it?=0A=
=0A=
On 02/14/2020 11:00 AM, Pavel Reichl wrote:=0A=
> Refactor xfs_isilocked() to use newly introduced __xfs_rwsem_islocked().=
=0A=
> __xfs_rwsem_islocked() is a helper function which encapsulates checking=
=0A=
> state of rw_semaphores hold by inode.=0A=
>=0A=
>=0A=
