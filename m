Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 586CBC43381
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 02:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35E3C206C0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 02:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394726AbhASC4m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 21:56:42 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:49074 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394640AbhASC4f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 21:56:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611024995; x=1642560995;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=uEaud6sJZLgGzkr5T8UAI0aGvbWRxE9MxsCLnRuveqY=;
  b=FiLyilTWsQBnMH8gGlGRBc5r80RGCSje+2BoRQgwe8NCCqhCnaBcI69R
   Vntqd6b1iYNgF/Ofx+Ce7mIllhurKq0VWVLk6pRAcZmyAK2sENzKetIbT
   UD/PUGCihW8W+Py2myPjVJ3eZwrnPzffTvyGKb1nSt2JLJ0cKAqmYGctb
   U3jQSzAD8CU9WriON7V90RukV0AKUI2GKxSwiP0Fv0B9IgH/93bIZAW3n
   +QMFNPkac4uScOUeXqDVC3TXXyHkZdWWw3DuW8KvWUAviodKnjKlWRgMw
   nuUiDyQG2NTkG0audhi1QKDdc2Dbx+58BSpk9g/outJDUHv5CTHmU6onb
   g==;
IronPort-SDR: XuvnlRuE7ztu1EGApuFexHYdM7++fitqK9xcsmgB2HJEJyCcgS7AL7WpsPekmWaOgfB3/CMGuV
 tXSKBEwrYUPk+ycXXrinvNHxz54mssRAHx/fipq5ISTLgNg2onwpKUuFFOW/LTz0L9ZJi4UYw3
 Uxw2Ta9e9d5V/oTZo90os/iJXpUUHXiY3oL/O7+e4pinGLLDWxF+Tjc/m3lMeQhaLELJAMsoyl
 GM06+0yytliC1DggBq4rbnHDn1Io5N/vrA+Hhc942kZUl46hheWzJquXV7xis+Ed4BPXz0fop0
 +xI=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; 
   d="scan'208";a="158932720"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 10:55:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RUqwMykVS4njVavIbMxkb15GssS0yYvLVMhZDwR56s0peZbuiX68mJ+VSCMVQ52eHNiQyRhgVqCnxn+VNckFOusExjyMBh9G6TKiy34+Q0bKPqT/993p6AOPzROfpH+kROYj9MGMtV88Ph6utjuq24Odt385AJMmm2XLHKTe/WrYD3KZXWvHWO1a7f9t04LnZpbUCc5FnRxUvUFStd5c/FOlsryw7lCJTmfuaCyf80eLaSiVt4an0IQ+53aQXne9j7JVoeaG9O3IxcSztv7LfqOB+RxO7W+WaiBQX+KILySkYVju2y+8vp8ptxJsXtFNiBx5Vk1kc3ljWUk4qHauFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ng6R03au+IPb0mK4n+c3zBv/QuiUZQTpmMED5JfKmUE=;
 b=iVPky4rh90oPW1PFkOrABZdm92wjDmk4YRkFHcF3e95rXzDp+L6EpfUQrrPQQhh1k/l0HRW71AIhVab9ih1/gibCQiI4zZq3Vev2ZweqytuSo6SBhSlDwggkN4fDg1FLvELGZ2+2+AR4vVEzUYSFl/jANf0R/XRZApwAknwYhn3+isqJ9a4armTnG3Jm4k1cnzP2u2vWmKRUlcPsIpySvoGnkr7Lz0fHv6wfIez7FFIb+Jj7U3LwvZxEBRQZnkuoj9hOHQ4GGK4KxPQbkwUz43dJWruXtcxhauaGZKsh0SnGS6aViw3dLUtHnNHjyY1daMMO0ywakE0YwJEJda2aOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ng6R03au+IPb0mK4n+c3zBv/QuiUZQTpmMED5JfKmUE=;
 b=xO7e8PiVfYSvHIjm95gOIuQFXhqpu61G6EuNtz5Vt4NVuWmnsPZ+Xm4Z17n4E2H1Hglo2haqpvfyLfGbWgGNCsj11ip7zwNsSpR5NK1F/lAmA0ohpt1CreQGFhClRBfyjmO7INZwlnHIrLdLDtAfSI3YTFYL9fAgC7XPeZ05Nwg=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB4517.namprd04.prod.outlook.com (2603:10b6:a03:5a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 19 Jan
 2021 02:55:17 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::716c:4e0c:c6d1:298a]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::716c:4e0c:c6d1:298a%6]) with mapi id 15.20.3742.012; Tue, 19 Jan 2021
 02:55:17 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        "sandeen@sandeen.net" <sandeen@sandeen.net>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] misc: fix valgrind complaints
Thread-Topic: [PATCH 1/4] misc: fix valgrind complaints
Thread-Index: AQHW66bU/H+yhzP9UU+mxxiZW6ebZQ==
Date:   Tue, 19 Jan 2021 02:55:17 +0000
Message-ID: <BYAPR04MB4965E56F3FC571B7799088B386A30@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <161076031261.3386689.3320804567045193864.stgit@magnolia>
 <161076031855.3386689.6419632333068855983.stgit@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2600:1700:31ee:290:eccb:a9ff:3ff5:aa06]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 173d6ead-813f-4abf-8fc6-08d8bc25a721
x-ms-traffictypediagnostic: BYAPR04MB4517:
x-microsoft-antispam-prvs: <BYAPR04MB4517DF624C47C64C0228DAAC86A30@BYAPR04MB4517.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:185;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ebwm6Lfr6MhAfJ3jxiHpAHp2D2jNOj42jG5HzmhBr3sshhJVqcq2zuFBVXU8VjyMH0nz8kP/nHVaA4UC1A+bW9N9T11aAkVKdDdNjwWMdGuUyGk/i/PErs9BLOU04JkCD+ffb3AokHpO5j5y3KQfNJVkGFppL2NWx4Qsk11CHsm31idAGU/8Pu6ZW2zfEQOILD8amFbC++pXCcEyQtUe/67PyL6u9gbvwojBjG3sYA0Z0uMZNn09b+EwgMzl2JNFuBWc1+GmYXioARM0Gp5fb+VojTdGL5sP8FqiDB0pb19x56PNkatfl5pFNWHjgcbnzE/WYK94ka8/uVMG15ThZ4F3qxshdHJwmxTtCbsMWo2VBKG9LZbtyCOoii6/KlE4cd19/9kQ05+2oYZuteSiDgF0gEJ3HLRPsZ+YM2u1fbaJj6gPfgc6SUj+QABpUMKdzJ675L+kNGJysxM6ukQVuX6FXu0myWu/5nkciLb344DvKtNliVs9E/2CAKROjbGUi6RGIkE17UqDRBuSt7BEgA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(366004)(376002)(316002)(53546011)(7696005)(52536014)(186003)(66446008)(66946007)(8936002)(86362001)(33656002)(6506007)(71200400001)(478600001)(4326008)(2906002)(4744005)(8676002)(5660300002)(55016002)(64756008)(9686003)(66476007)(110136005)(66556008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?N3oWNfQzzdCAlftnKXEzXPe897UPxbs6SkVt/jBEfHeZ3MRxqGC/2c/4zliq?=
 =?us-ascii?Q?dbvkcFshHr5co/6zyVqNevTLvY3qKUAX+8BPJ4GJ/LQI/IMtnK9ZAHiq3AoM?=
 =?us-ascii?Q?8WJFKTG/2wfJwrflubS74HUhwymXMdsL4tYoKungox6FYu54i1MJM2DhsI89?=
 =?us-ascii?Q?mnNFMR8W/TrH09sv5PdGLDYGq/5rrO8FhFZovcnJqnJv9cBchEBzU1MTKdm9?=
 =?us-ascii?Q?fUJ/wL1qRYkZZHG+KgswiljrNCMPgdD1HHCuQPB2HW39lWL35SyUYCJyE5cA?=
 =?us-ascii?Q?sOHsua3FgSoKv/zHFzhLQy0Yze6CxWwTxATCRmxP5eB/OfEG4h6yi+rLjfH9?=
 =?us-ascii?Q?nau2nP6Fd8o8uGPybyNKEvD2GWv+COswBF8i4yo17EG43++VA3CUqiKTtthj?=
 =?us-ascii?Q?AV3FHqvQOmuPeVbzPvfpPBESuCFHGaZYJqXjp+p2Efg1MIiIx3ECk0CsgLdk?=
 =?us-ascii?Q?neUTRRL7RoDU4BnfJ+R8boXguf+UXOxCmBtnkuvYhQRNlLvWDgtfpl5iKn2+?=
 =?us-ascii?Q?ll51W/cdbMdujF/cIYkpoYb9vajrfTOhQL/BzBu0DQ+XjPnnByL9XRsIk96s?=
 =?us-ascii?Q?QTVypzgbN42vKtbBfwMa106qEcHsWWSxI4UWzSGpECTzEZelCZPHrmuDt1gz?=
 =?us-ascii?Q?7WawLIfgsdKnB7S13OeknSFkPL4Qt2Hlq6aTETqrZMAbw+OjqtvK4VMp71xc?=
 =?us-ascii?Q?LVsFvSimdm3JAx6pwCZ1i/wQdstwx2MFmALYIxz9ot38Kr8iNPcmTT+ugnuM?=
 =?us-ascii?Q?FddO24KKExFMCN0APptTq8lJ/WL+afrCqagBFNkUUtPirt/KfTNw20JCuui+?=
 =?us-ascii?Q?Wbe3uLm2mQ+rRVWZwbyyJYZBkaUDjoslHOFsWUGZdvF0+9jnN3X15xzNIs5O?=
 =?us-ascii?Q?0yvqznNGsB5ohI5XU8gXVWjz316z6UHp6bkKu+4QLCCs4KrMHt026TngsCy+?=
 =?us-ascii?Q?5e2JxlGejWNcj36fE5Dil9xTr43/Ls5ZklnQvdC7NRwaKMwoTdI/zU5qUsTy?=
 =?us-ascii?Q?u3DeYa0PpL1KLsGOC1yg0VOnYDYCNVhazYMbZgXoM1YvY+3B12UbwHaTqRLf?=
 =?us-ascii?Q?pQJJujJR?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 173d6ead-813f-4abf-8fc6-08d8bc25a721
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2021 02:55:17.5009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O9jM+yBw+M1Jmx3sCI7DAF8FbKkNC2hTcGLasIBT4xrjCB7Tg1ucqtAoDrXHYoNube0gpXeklVZPzBVwqtzVprzWdeFDLXQ6OWEVUG9Ma0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4517
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/15/21 5:28 PM, Darrick J. Wong wrote:=0A=
> From: Darrick J. Wong <djwong@kernel.org>=0A=
>=0A=
> Zero the memory that we pass to the kernel via ioctls so that we never=0A=
> pass userspace heap/stack garbage around.  This silences valgrind=0A=
> complaints about uninitialized padding areas.=0A=
>=0A=
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
