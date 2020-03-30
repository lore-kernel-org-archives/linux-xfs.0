Return-Path: <SRS0=hGtO=5P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD96DC43331
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Mar 2020 18:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B35A20714
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Mar 2020 18:37:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="E0pXyDEI";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="lutsHAI0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgC3ShJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Mar 2020 14:37:09 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:49643 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgC3ShJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Mar 2020 14:37:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585593428; x=1617129428;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=bTzGRNjOb07/kcmtY9lElwg73NuUKTR8W2HiY7Af0x8=;
  b=E0pXyDEIk/EdDkK16ywr18UZ6gkcySfJczogQJJBDRPEzuJBc6+eI54j
   rtI4GD5u4jrUXuoGhwIGqgNv81YjoXvvM9gbhBPBDW6V24VHWmHTMurpQ
   BfvrlvztLWtNeM1AqzwvV+yOAOH9pJuARfpGNaetAUijM8XA97JpM9RbN
   RVulI569z5wQRrY/yxSyU6DE8Bcd4NLpP8GL+fbXTqcUpDPg+dh38VlYE
   ozGpUVw3LpsCRk9TWpaZZegIIP+CRnYgDrJ2wJBSPpD9bnMO6r6S5eS6Q
   oBDke9/nL5gdswFWqFwmS1Xdo2ZEgLlPbmuAtntNTqDK7MynM8idKAWVX
   Q==;
IronPort-SDR: wdkBwS0325teqv4igHkWG/XOiQQcvHC22M0WO8Rg64b2aUbpB3W/Jwub4QU4VqdVRCluWeOsEp
 7ZB6eQm5fZ2qFvij1TigFhILUzA0xcjCnUUrBcXg8btLSidYE2zlLGLU1Sn0ReUdbzO+oFJ3a7
 mFXDgq2lctPzveQnqXqiBLJ8jAcvpFr2fbAoCfNQG7DfmtK2oll5kOHNIiBnBECwvKQUdt5uZq
 9yPDckH8Rs3b2uUePwmkQ58dAXHQhdCHDbBAUVRvsHGPs7YCAhlqNUJ1ksnE6jLgIGj4wzHK2J
 78k=
X-IronPort-AV: E=Sophos;i="5.72,325,1580745600"; 
   d="scan'208";a="133897586"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2020 02:37:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TeR/SEFuUu0vhSUyZGYBB2Fwi5U4469SxCqO7GivZ7tbrLAEGS2E4VpMuGtbTQwA9eraqPPY/TkH5dchBB9CdNEKHr3sC4ARxUjxD/Cq+Ig3PFC9X3xSTD+G0m4QorMrHB9ylgK1cVUCCboNdn9IkyV0TMNUNZzDgucg5A8qdsf4U1s3TBzr6xRao0vVe2vl+6lMX5z/82D0PORB3J8U5TSDx/LXTvhIJX3A9Kou0WX+qyKZTwfX3xtxcdzjchTk4fRSMbNAdqn52MItlN7oihSmKphGG+3lgFcWfLB7x/UBy06vHqxFfwuF/5lVpBo2OFlYx7YfevzWKh12Ln6SYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBCMc7CtbjFoObGpKkzQZDQHiOLRHDMSde3SWUm61Rg=;
 b=VJS11cVmGzy0T+RqSMvXSics90MzxE0Bs8pXRkg8j8JmzqCBAi3HwBELeyc8/g59gRO+C7RT/47xrUkHyvMxQmP4OK2SFzhdtspv5g9kFf6aJKACaTvmxmdm4wgYLGqt6sJXWyYWPR5fWBAPU/5QLl4qxkXzx8AjS5mNIc+01YEsgQDsnNKgkixwSqggTK+kLr3sedIOwHGB5LRi6m/CsWxnJqkSOEeBdvbQcIHjELqRed8i6Qf/rPABPeJIgaoVv3sdWdcF8XqoLgAtMO2/HxNy4LqzEPqOXXjsVeTxkjZLCUmxlXWODYCZ+zgU8fclucz6muiF4eNSi+KlNHUvuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBCMc7CtbjFoObGpKkzQZDQHiOLRHDMSde3SWUm61Rg=;
 b=lutsHAI0lgmjA2te3O9Cew4Jd/mldZr8b0i+a+GtD5N7yx6ds0D8vMTMDuqyfU9oCk9+4OqrNm1owezhFCJvttdOfEXIV+K3I+CrnJ4+qFVxb7IsEHHtSSr94OgugMjK3sJOySiY6E7Fu7wfXLjpESohUp1McuhgywODez8JC2k=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYASPR01MB0021.namprd04.prod.outlook.com (2603:10b6:a03:72::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Mon, 30 Mar
 2020 18:37:05 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::d826:82b2:764f:9733]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::d826:82b2:764f:9733%7]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 18:37:05 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "xiakaixu1987@gmail.com" <xiakaixu1987@gmail.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: remove redundant variable assignment in
 xfs_symlink()
Thread-Topic: [PATCH] xfs: remove redundant variable assignment in
 xfs_symlink()
Thread-Index: AQHWBbm5myoRDDsX+Uq/dTeZMyt4zw==
Date:   Mon, 30 Mar 2020 18:37:05 +0000
Message-ID: <BYAPR04MB496586227D823C4A77225A7186CB0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <1585479815-13459-1-git-send-email-kaixuxia@tencent.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e13a7f47-1c42-490c-646b-08d7d4d958c7
x-ms-traffictypediagnostic: BYASPR01MB0021:
x-microsoft-antispam-prvs: <BYASPR01MB0021561E3BD84FF3A34DC5BF86CB0@BYASPR01MB0021.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 0358535363
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(9686003)(55016002)(71200400001)(33656002)(86362001)(4744005)(26005)(478600001)(4326008)(2906002)(186003)(66946007)(81166006)(8676002)(5660300002)(66556008)(66446008)(81156014)(8936002)(66476007)(64756008)(54906003)(6506007)(110136005)(53546011)(52536014)(7696005)(316002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J6shvYQhf3QoyFBdLF8C/TmbIqe7SFi/XgMibwpB2l6l3uagV+/kB5cbPagPSeCUk+pDqPJ+ktwIN3z5IFMa0oz6hFYraZu4xtfeA7+Up/zqY3ybh4bUDzlOcgFbEH2WST/flqmAb94VA43HjnFXtEPWVM7bZKdSw4tSG1p0LiYHQ8RH+SA8ntScpEToCuaYpCnWqCVa9Xx5LSdb+SSJJ7cFcNxHewlwJ+eDaHKOG/XSV9cEE/sO9aT4DDIiu/dO3NXPi78/AxfMwaMZv2iy8IoiFcMi76XNvG/7pXiK0nBiS9XyH14ekrz8fPehADf8RMXZlRIS7DtazK8cI1LWG4h2+5RVL7qKaVIzY/U7wtxOgbJs9Fx5r9xrgp45MmE15/h/4grjuphgYOfsTEkIxDiynggJBV5DhFThFGFOwGOod2GORR7Sje8azNg0k978
x-ms-exchange-antispam-messagedata: 1O81u11b4IhPt9sATxzyB0D3/Qi50ojDwtkvGl5QeDsA+YYEfHyi3+eqyldloBSYqhXP3HWtEb3MfSsUrX2BbUNJlbEvxjqrf1D6PIWHxbCWH2C4i1ffbC1e6+Kw8gKPgRTEHByiY77ErgVAtXmhuQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e13a7f47-1c42-490c-646b-08d7d4d958c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2020 18:37:05.7859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0LKPfmQgxeUOJx54KXhlNiJCOvzWsLpQPYGc5X1nuVXZiKupPNcBTFd+bgNTJ7LBiCWZRXhZmrXpoAT+DG1rOL2yMEPGgRACRBlDKO7BmbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYASPR01MB0021
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 03/29/2020 04:03 AM, xiakaixu1987@gmail.com wrote:=0A=
> ---=0A=
>   fs/xfs/xfs_symlink.c | 1 -=0A=
>   1 file changed, 1 deletion(-)=0A=
>=0A=
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c=0A=
> index d762d42..3ad82c3 100644=0A=
> --- a/fs/xfs/xfs_symlink.c=0A=
> +++ b/fs/xfs/xfs_symlink.c=0A=
> @@ -176,7 +176,6 @@=0A=
>   		return -ENAMETOOLONG;=0A=
>   	ASSERT(pathlen > 0);=0A=
>=0A=
> -	udqp =3D gdqp =3D NULL;=0A=
>   	prid =3D xfs_get_initial_prid(dp);=0A=
>=0A=
>   	/*=0A=
> -- 1.8.3.1=0A=
=0A=
Since these two variables are initialized at the time of declaration=0A=
it make sense to remove this. Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
