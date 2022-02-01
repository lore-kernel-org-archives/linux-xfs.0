Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E4E8C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 21:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbiBAV67 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:58:59 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18842 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236439AbiBAV65 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 16:58:57 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211KSwjE026641;
        Tue, 1 Feb 2022 21:58:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=yH9IUZdYaFTFfsVoH3DNsnM5+okdm05KpDgv/oB6a7o=;
 b=v/hmE0hCajgWhnBfgdHaLKTQfPSTuh4CxeD8JDIcLjovx5lCl2Y4KhR845agGAoN6IcQ
 /wWQ6hEKtwNgONz70J2LgK8A4/wyZlliXuTWQffZljWofJM3Mj3q0NrFyTYMbab9Zv2l
 Ob+9OjuycyV4RQ/6L0xRvFdDgm1qrbJfdBLTbd6Fjx1v0DUfKRGEpx9SlnP1fr0D42fp
 FkvfO9bVXA7spJheckcd7Hx7mTklFc/yAbm/n0T0k7SYx1Y31tbVpk5fbhE7wkyjMvJ5
 poxPKQ+Eo0y8kxI8LtdxdnkRPKprPYn6FGwTfjJiMYyfrOZ7EuDqgb7UvOtw0qYzZQF+ 2A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9vcc2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 21:58:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 211LvAgx076624;
        Tue, 1 Feb 2022 21:58:47 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42])
        by aserp3020.oracle.com with ESMTP id 3dvwd6y3dk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 21:58:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAw1DJz6QyGV5rHcTOiru87w9rz9Ncm+yhkP9wbejD7yicA+kjpQVoOW3ysgcx9w7P5XjvAYUnONVGF41KrU3zHuxkSX1we4zMNQjXXaQLwqBkhzUv0y19kwbxVEilsj9B2XG3v77HjI0bzCL09rD4X5DQktfalefZIWq5bfzQFN7avGmjzfAAFhc6gNFFWjYJPSXNi36TaHvulry/aGH36QiGHPqcFICoP8A6M5/fvmSF2Vhxkt1Pd1tiHTK6OkWS01024AGhX+YVGmuZLbQDg0v6VHbc9XwFYJtatXKfDecg+eORPxWpFBQEmc+CzAHR6fi0Cc+70fYsU/jB30tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yH9IUZdYaFTFfsVoH3DNsnM5+okdm05KpDgv/oB6a7o=;
 b=mXDgiXvvz3WS7oxcwEhzxNGOJbrsxAYYgbWkotlU4YKQLZD86udaIfnVppsLvRnZ5LL0ngj8Ue0mLsRGpDxr0yv9RkAFnhi2V41Zyp796JOaFsuLlIS2BkihJBlRSU4WxNoQ2Hv9iTk8A8+cKCVXXpFEYWuav1XmzvH3NGhU+VLL1oujvirfN+H46v/WonaLXGeuwox4lUSii5Br5zGcEoZuOLPLfAVZfkKms7CDRsovPLPJ62QQM3jDS7ezc7l+9au4DAaYWZldjrYJg2Kn74V/xe8UjJ9hb6nxs2mvxAu4X6X2njCP0rToR9A9qMCOpPq6qu6p8YYssU38Pw6w/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yH9IUZdYaFTFfsVoH3DNsnM5+okdm05KpDgv/oB6a7o=;
 b=EipsjalJUofs2BQ3IL7ZnmdPHev3WT1Dz2PuvouL8ahwfXz2XtGaLY9sWnSREJwHHybxCeQRuI0MVdpG+kHR3SPp5aR08nwYal5EklKeuE2U7dOrXHeRW6hEvUYk/B8II3MjStq8xQyNTiYdDo2UhSIxMyzhS862junL+bubVrQ=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 BN8PR10MB3506.namprd10.prod.outlook.com (2603:10b6:408:ad::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.17; Tue, 1 Feb 2022 21:58:45 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b%3]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 21:58:45 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/1] xfs: reject crazy array sizes being fed to
 XFS_IOC_GETBMAP*
Thread-Topic: [PATCH 1/1] xfs: reject crazy array sizes being fed to
 XFS_IOC_GETBMAP*
Thread-Index: AQHYElsO+Eh2UNY6KUeIIXhVRZP7wqx/SQwA
Date:   Tue, 1 Feb 2022 21:58:45 +0000
Message-ID: <DB7EE8C6-6EB8-4F85-815F-B9A831E30BAC@oracle.com>
References: <164316351504.2600306.5900193386929839795.stgit@magnolia>
 <164316352054.2600306.4346155831671217356.stgit@magnolia>
In-Reply-To: <164316352054.2600306.4346155831671217356.stgit@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36273443-c535-4bbd-64aa-08d9e5ce04a8
x-ms-traffictypediagnostic: BN8PR10MB3506:EE_
x-microsoft-antispam-prvs: <BN8PR10MB350678BB0960EF3E2163B22189269@BN8PR10MB3506.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:983;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yGBi6voISmgLZOaz1uKWAjP7FPbzltae2gI0qLNWuVZ07xXQ6O9xD6T41kkr4rS6Sla7aSIV0HMYvWfRlZwP1JYCbJKnjfkz+kNFUUzL/9pbZTvskJQumguKzBvppl6dk3mfTviQB2h9/KjbaZ7COrGAb+l36R6RzWonEIWh8Ytktc7+/bp0EA4tx2OOA78qq56bPnyyFCZDLI9hFgPgkl5O1R6fCP6D8P3/OH5zHwSF3A6PPdax0aNU21R6ugOswGr5IWPDRSqF5MAPv2V69gqJmasQLEzmubjkL4IVvzkOZkTAJhdi7bh6t1wNDQMvc/Lu1lG5UXqMZPlesXTvhokC4lY1FC0XH4QITkPS08kfdpjtfI8xMys7CRCkeh0ARddd/u0MQv3PhtULCVOW91jRzd4p/yskp0UwgUwrHJk/3/kUn4yRR3V/M4xCvwxYz1LRRPu6Dj/j+JMH1zxlFykXBLLkp75rki84o9jwrqBAnOsHSeI4Ds2QMTr/i/fI1iDE95GP70KhUvBXxhlD87UyA3a/MA8LNvrxmhUF2ILz3r3TG9SL6EqWqMbQwEkSWsMICdroxr8Ebkc8GHgxEBX2unmrJka11zq+Sq+cYNDLko65Oce2PfpR0v7OUfnd6EWiZ+YdDS1Qj6JgA7VqsOHUsNZ8AtJSUXm9D4K1vkBp58wd4pK+wGOhDr/kpLFKGL3MR4lwb0DDseDy6HG7vBdWzJsYRLja+YNtEnR8uT4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(8676002)(53546011)(66446008)(66476007)(71200400001)(6506007)(6916009)(4326008)(2616005)(76116006)(66946007)(2906002)(66556008)(64756008)(186003)(508600001)(44832011)(6486002)(91956017)(83380400001)(36756003)(38070700005)(38100700002)(33656002)(6512007)(5660300002)(316002)(86362001)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?V65VYjveIMBNtzTiPpUMKw5yNti9T0YIz43pKvxOBX8EAhbpcG9bPju9ATwU?=
 =?us-ascii?Q?gw4SiW/eeTzfFqgsiKDRSqO3orAw11jo3nr1Mt2Jq1satUEg+NoiABAkQhER?=
 =?us-ascii?Q?5/p2CPKMjOpvhbCLFYhZ1oyLoXvMmzUxzhOxXBETfemV2IrpxyvJ5f3ww+Zr?=
 =?us-ascii?Q?qQlgl9kGqm3IbXC0aseI/li6MbStUlFrR3wV189gBdUrTChy+tI9tUAQ4b4C?=
 =?us-ascii?Q?iL2W/sfi+tUPeTGaykwlzCP6GZo1dgc06M/uPzKrr36zm17HL0EIUUzw7q6J?=
 =?us-ascii?Q?TW4VbbXq4MwRDTNdwLdyf/gc0V4nFEHeVYl/177AMtJ2BbU6DktSDEEJtal5?=
 =?us-ascii?Q?bHgiGggsyOIrYOqWqDgPKvxdpJhVw4MrVDeN8usqyAM6PgTn+voBszpOAaPv?=
 =?us-ascii?Q?pEw8/Yb4/nN1u6wWDVcqYOlYlVg4dplSrb0a+k0wdAeSOcDiAmHM5SN7oz5I?=
 =?us-ascii?Q?j1rND3/+CkyyPZmsGQqeTzZcgqh7jRqYAT1EPPiuKFTguO0Y9I9e2vcMQtiS?=
 =?us-ascii?Q?GNf7Vaiumr4BhDdzS0B1kk71F9ZIVDuhC+OVu7jUbbJGHOM3LqYqr0eXWpoy?=
 =?us-ascii?Q?j5pTYhvz+AJrXBN1XT3fF1PQJtZW58c0egILLOr/sjCJOm+3SUHvqjx2TYW3?=
 =?us-ascii?Q?guLvHW/2YsMutiNdElILTgTB6qLATcP5DxrBwVm9O2LcG8mjJFN77M9EmeHq?=
 =?us-ascii?Q?Op1MfI8YT1u+QzdQwKea/c1GJPIUaWT0NwpMXcia3gdkrRTl8063ja6Mjhak?=
 =?us-ascii?Q?X1+c5KQdRrRXUaAEIfHa1zdQkNVS8GstfWswCMqlbwgAU9BvIAciPceuv5zZ?=
 =?us-ascii?Q?VZupMqTheWyRCv5XWQRSjhSHSm1I1eBId8CdA1gytkDlYZI64gO9ekI2oMUo?=
 =?us-ascii?Q?Saqu/wt1SYIH45evPIdfTmq6v/5qAbN3IhkqXdwUapkdXP177LaRzuH/f7CI?=
 =?us-ascii?Q?2p6EKMlIfiid2q1/0rT3tOxVLJDvclyqifsgMJH0MbfejYhpfxIwcr+WpEVU?=
 =?us-ascii?Q?vdXpCPfEYxXv4in34uSEMnvW00TOZn0txFsi3aCFxs2LresPdG1VXDjZduDX?=
 =?us-ascii?Q?GNvZ3FHkzBcbFoYGDtNSUC5IWbI+lx0jmj5Q0XMtbwx8yn6McNf+Qfd+XLX8?=
 =?us-ascii?Q?dILtS2F8Hcvzy6dYB/3Vf7ZqjkGORILeDjcMJllAXj1KpVVSIulwJiAcGp3b?=
 =?us-ascii?Q?fHLKl+dqOW6lY4f6KQGAP0Z+OonoZRZk4cYNg7h+wLkFvfq00xrayCAkzHaV?=
 =?us-ascii?Q?3p7BccpCXcHvIHL+jDqCPYlBG/TMmzoOoOl+sChhB5iTDPcEqWkHaazFHsyQ?=
 =?us-ascii?Q?LHkoXFMr/FckAmu4FcXDNTowHGbUMaObAdknxgP8+JEH0a3iG9jAQmmj+jkl?=
 =?us-ascii?Q?59jFfyn/ek51BWWBtV/5QGFXIgvsUx9tOgn3aY6lcLF1pwO5fQul/bHEy5Ak?=
 =?us-ascii?Q?8B+ID6axN9gEdlScjoSxWsOMbgLStGCDsWb/XczOIwI//mzQLBFbG5id+Nbm?=
 =?us-ascii?Q?vMOzP8DkehxGQVoltjR18mH5OKA3zL7c+qurn7cGFe+TFQUfaTv+VgGBnP4T?=
 =?us-ascii?Q?mMLdjXafMNItmoyKEfVJj+xtECF6B3q5Jd8pejsTj07vIC/9zfZhSawST3XS?=
 =?us-ascii?Q?k7BYeo80QkXYMZkU3fymTAxt6SftwMJWOlOeQrbi5XhGeLN0yqd1lGg4kTva?=
 =?us-ascii?Q?5f4nDpB2OW16PI/L35lIrVBstreMuOqUEh/y+8rbRqY4GT/WnaNBjNYJehDH?=
 =?us-ascii?Q?MNBJCvNBfoYiexJLX7oxUQceBL5B5Yk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <75A9593B23215E41B6163DAE7BCD6029@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36273443-c535-4bbd-64aa-08d9e5ce04a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2022 21:58:45.3179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dMoYfuOjajFe6tGhMMQ+giuEyAE8mFz/1sb6O/UFJ9vCv0rhvX6j519ttwSj11pSmt+yaolYlE3zHIl1tlB3DTIQ6s1biSiyWXXC7dxCIIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3506
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10245 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202010120
X-Proofpoint-ORIG-GUID: VQIB6p2CYTxSNvYum7jsW8t4ET-OXvWE
X-Proofpoint-GUID: VQIB6p2CYTxSNvYum7jsW8t4ET-OXvWE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Jan 25, 2022, at 6:18 PM, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> From: Darrick J. Wong <djwong@kernel.org>
>=20
> Syzbot tripped over the following complaint from the kernel:
>=20
> WARNING: CPU: 2 PID: 15402 at mm/util.c:597 kvmalloc_node+0x11e/0x125 mm/=
util.c:597
>=20
> While trying to run XFS_IOC_GETBMAP against the following structure:
>=20
> struct getbmap fubar =3D {
> 	.bmv_count	=3D 0x22dae649,
> };
>=20
> Obviously, this is a crazy huge value since the next thing that the
> ioctl would do is allocate 37GB of memory.  This is enough to make
> kvmalloc mad, but isn't large enough to trip the validation functions.
> In other words, I'm fussing with checks that were **already sufficient**
> because that's easier than dealing with 644 internal bug reports.  Yes,
> that's right, six hundred and forty-four.
>=20
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> fs/xfs/xfs_ioctl.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20

Looks good,
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
>=20
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 03a6198c97f6..2515fe8299e1 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1464,7 +1464,7 @@ xfs_ioc_getbmap(
>=20
> 	if (bmx.bmv_count < 2)
> 		return -EINVAL;
> -	if (bmx.bmv_count > ULONG_MAX / recsize)
> +	if (bmx.bmv_count >=3D INT_MAX / recsize)
> 		return -ENOMEM;
>=20
> 	buf =3D kvcalloc(bmx.bmv_count, sizeof(*buf), GFP_KERNEL);
>=20

