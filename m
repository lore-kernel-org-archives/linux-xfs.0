Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BB4CDB474
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Oct 2023 13:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377360AbjJTNh1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Oct 2023 09:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377212AbjJTNh0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2023 09:37:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077C2D61
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2023 06:37:22 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KD86uP031478;
        Fri, 20 Oct 2023 13:37:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=pCqzkHjbUJc3rFY58+BUFnGHcvMGt5fo0ziIp57TwpU=;
 b=buKgW1GBdYVobhqQm4ubeNzuopL4HlWEU6skQiGIJuXR1LB+ghblJkTBMUmpNSNc7wZh
 GDP+eEYLs4Z/8mGi6sOwqJNa87dHO8F8Z66bN2me6NfkfYgtq1+f7PwcNrOJ0+ocoNPs
 ZF45sSdFHKxPyV4o7LYcNCrAUz0E9VIPM7USl1pZpPY4bdFCR1kZ/Amac5MHq09jl60x
 4uwQbrFuTn4d2alh1u81qnIgFdgSlWAOcDoNeQh+wIhl2DztItUioH/XG1MzQNCdBZ+z
 Yj6z+Syp8qiSbKqOXDil15iAw6SBuyjMyyCN5ugnGotF+Rkj4h4J4G2NeEgvh+cZKghL jQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubwdhu22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 13:37:10 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39KD9cCj025749;
        Fri, 20 Oct 2023 13:37:09 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tubwdap0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 13:37:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1LQhbiu3iWTqomVk1bx/XZrEc28aHweP8As3wRc682L6AZDI8ax0ACAaB2S6wuGtznR674hNldVxaYXQPNTE/w9qmmqzRaaBvNXtfZ8nOvFKfHMPAiIKGCmxYaiKzhu04xDTTDzZJaLvCCBeYGJ8pElaVtVPAE3nGUU3QsCDsp1hitk0EiQMfOsR37JvQVMvm3vBazCPkQdsca1ABemjJhtAH/i/WxJRmNgqX9i0eFa5qHbBDbZeodeBTTE30rPwyw90kPdUgftJc1nWOHird4fuFF0vG/ivDDVZbNnTqxeLGo/4KmYhQ8TDSFpuMacswxIh180OlswG2IXgqZB3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pCqzkHjbUJc3rFY58+BUFnGHcvMGt5fo0ziIp57TwpU=;
 b=DG3AT8A6YsB4wOMs54elH7JHLbwnWyLNHqvDe3SRV73DVpifzE1kDsXGvkcmyMtgNkG8hv4YcDWRd1xa9n4fMt1CQo3Rf/A4dyg9gZA8FeIwkyO/LMsqxmJJjbbMXbGGOPTaiOBAU7AdueowhBlNEB4HvVKlQoCM4BMWTQMbVngIN1RQ4h8kzTB5tRV0UUqe62hPMAEVK5Y8NlHA82sKHzi2/inFL7EFsK2AL9PnWUwt7ME3aY4fiPyyMLomNhEeJ1/9j/Dc284SQsvL3T5Kk+2UNPLtNCGCsqCbHcg9NNpwQOmy1Ha0BjE9Oh9Td0oqZj5O77BcAc/9X9NUgzN64g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pCqzkHjbUJc3rFY58+BUFnGHcvMGt5fo0ziIp57TwpU=;
 b=gE9kKN2sbCu0ELnbeFVAwC3jje7yc+SEjF+vysZEvs1GH6NggKmUo8UfeqOObtcCFAIj9Tsf/H9PhQ1Yje/f99X6A8nmWP3ZiIaWlgldKvnldBnsvAMpkxOz9UoqWtTjtWMvUiWOd/m3KdVa+eHboHOASBrts2T5K0toSRtXhxA=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA1PR10MB6711.namprd10.prod.outlook.com (2603:10b6:208:418::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 13:37:07 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::7747:3fe:bfb4:80f1]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::7747:3fe:bfb4:80f1%3]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 13:37:06 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     Christoph Hellwig <hch@infradead.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCH] generic: test reads racing with slow reflink
 operations
Thread-Topic: [RFC PATCH] generic: test reads racing with slow reflink
 operations
Thread-Index: AQHaA1qE1x/J8eeqKUmezbwcZX8E+A==
Date:   Fri, 20 Oct 2023 13:37:06 +0000
Message-ID: <54CAA7FE-26AA-46E0-A93D-36987657803B@oracle.com>
References: <20231019200913.GO3195650@frogsfrogsfrogs>
In-Reply-To: <20231019200913.GO3195650@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|IA1PR10MB6711:EE_
x-ms-office365-filtering-correlation-id: 72939dab-4984-4d51-b1c9-08dbd171a732
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TLVSGBABCtI6iaXfwxF+cM6XEnmj+OdlwgfRj+H174i645/L0uUfH1TFE4T2WAq5n9/B1qPhhiNinagf+Vw9xesHfyoTM2cIafxiLgnE6h7ZUnPHzfO4YV5yxDRJtavJJRO/z6xDpG8FBOK5Rjfc5cnm2C96AGU8yDbHtSuE4emH6TFhRg68yEjgewdcSjYZs3+MxJ/6AhuEe9TD2OgmEv9yIjsH8Jo+TkfL1IXbJeE0qY/QyOX7XKgzQVWp+a0QhEZbo5ZbetFtH6uYqsY5RuoRhBP0oaTB5ftBpap28NajEAd67px7JMQtDxkbp4dtDYMxgVFYRXk1aGcO4ey64XiPqgBj0+F4O1+HCPYSLSJNsK0Pc8cV2UB7UYMyXqUkJF95S86WX322s0RbVyZ363yYU06dnVuKPLiUK1kGWAUnujmClewOD019fLi+rAWJGwCpIpsH9wg9ESP41XTMgDV9RSDEYf5DwKCuj1AzjsU4zq4DBSQCQjA3ZFn02zQlVeryYcRHdDmcEGlnN3NoGVsaOySUXP5gdnV79IDOIuLD+VoFbSvpD9uXapEVyxHdhJvXznuf4k6dLJLawIku14m9cr54eJ9TqBmGFj67F0U9dBttH32Marj7E7h5kqSwOaOhcZ1626tveROcZM7zwUEv0GxAr2qzY1Izqf1A5PM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(396003)(376002)(136003)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(30864003)(2906002)(6486002)(478600001)(5660300002)(41300700001)(4326008)(44832011)(8936002)(8676002)(91956017)(76116006)(316002)(6916009)(54906003)(66946007)(64756008)(66556008)(66446008)(66476007)(83380400001)(86362001)(36756003)(33656002)(38070700009)(38100700002)(122000001)(53546011)(2616005)(6506007)(6512007)(71200400001)(41533002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aqpS0YgZFTKceWMcIxZXk/glKX5NYs+Fr0ipH9HiAqFotZ2l3lwO1tWuFjA1?=
 =?us-ascii?Q?GYtNCykfeC3du/C98AhL6sZvwtYtRyVB3ma1PJ+d1rffwvF9HfhUMGKZk3np?=
 =?us-ascii?Q?i67gtkQ+xwQsOQLFWF0M3FkIzWeOEFPhi15B46dgKDb4aTsQRoVoEBTt111V?=
 =?us-ascii?Q?S4FZewKpevYcfizRdfPTQnGYhq9y87Y0rwBPL23j4F9Elrdz3dg9/1vzZx8j?=
 =?us-ascii?Q?44UHVxkuLPYCPcIulJX0kzEhqjzCTPQAH8R3T5wgqjGIi7DXeVuZwLWoNEWn?=
 =?us-ascii?Q?hBdVJPSGHjXOSY0uMJ1vRebFF5Cm/+g7IChxOQImDYElbZRJ8iWr/YVS3rfQ?=
 =?us-ascii?Q?JO9NUsDbVn+FQhM8fnEQTVX3KugAoN6RxessO4c48vaHL6USvjaFt+t+cqZI?=
 =?us-ascii?Q?wFkpxfSbunLh4U04JI4t+JhdpThEbfGxlzDjnrVmOo9OxDq3iPK7/EeBSdtQ?=
 =?us-ascii?Q?dn7pRk47YUscBsLO8jxRVB56hPBBkrBlbORGlpgyR7hzZ4b89hA+dU4L2gLh?=
 =?us-ascii?Q?X+5nhMwqz2h/B/5US2vi1SmhHR7Buntl+wOwiz8qVMJbNUd7+G7wVclEVqRY?=
 =?us-ascii?Q?ufwtz3NseCcolmqQZHcvV453ycel8Eppg+yu9PlTGc7PVD4STiYP4qzQjTOl?=
 =?us-ascii?Q?4yuSLMSvTun49ABZHSmINy/sed1H9Yv+5cLY8PkQCGqqwaxjl965UqB3VLXc?=
 =?us-ascii?Q?VXa6dsV6RXC6uzzHadXo+iYvebWXNDMyGDWNqLjKuvWPdTw2UD8rphszMiAl?=
 =?us-ascii?Q?MY0K/6qx/CR79j3yhaf0s8jdbyQROfpV68+d5nz4uWsAqvMzbWMQpm7+9m2V?=
 =?us-ascii?Q?s+sFqdMVFl6bSbhCWQ/BhVC7Fb0RsJyoa2k8NfPvvzf+ThZzdDKgKGUNo7Bl?=
 =?us-ascii?Q?7C+wXWgyyO6We+PQapo5f+iRxBf0ZSExB6Sv27BkLLZR5JY0Ul+eaeJXVG9x?=
 =?us-ascii?Q?MctFsmcVG6mlCiT9MW1z68b6bvWRVxJOBMHFBdIf/thpTaPIt9rT5yz5xXUn?=
 =?us-ascii?Q?AACnnLZlvROsPNcJvPCDMZ1Cshcr7fcKyW2LmSdP3Oindb9KngUXPB5rbICx?=
 =?us-ascii?Q?K8e4TNWvM9+n1YgTTGNfl/JJBt9h6uLkecU+DYdencuM0IXnRgHxVmeg942T?=
 =?us-ascii?Q?hAjBjNL18wgr0Vo1kNEM5kbfHeATYH+FSjqbN1I2t6yQC8t5rLiximjTpa2S?=
 =?us-ascii?Q?gG9ikIjfqBVDsphmpkk3mgoifgA1c3GhsFT60REn6doiQ/FAtPLKWMc0x2qA?=
 =?us-ascii?Q?vmoDLBddPDbPpqMiCkVXKvHW89P0mFfbCAQbO+GWTerogJUTf+BH9CYPpBRX?=
 =?us-ascii?Q?S61G3u1xIORrQtvgQsbmG5VQ9WOSb739mVjjtcCLYEgtbJInr7o6sJCEdwQ8?=
 =?us-ascii?Q?YnKQnU8b63YAVIllc9yrV8Mw+ym43SYYqnij7F9Q+7LizmQ7TaXf6MtYJVQ1?=
 =?us-ascii?Q?g4EGCj6/8T2VwqpBn/V96hSFgvV8No+dlj9s7JNEzT0IbdLkEBn4aL6laKUL?=
 =?us-ascii?Q?AxaUzqe2hnfsNsfLwVr4m454gHjM69FQdoGPqQhObC/qIUP19qdBwhr5tX31?=
 =?us-ascii?Q?NeV6E9RWCBvVezaiintJZbEaX45NoDMIF/LK5SA6KqgIZH4jwNpSMeLuiy6N?=
 =?us-ascii?Q?WFsefQ4pq8aZBZxlfDz/bSQmmxMQuyHjhUr1zx7R2/nWPWJxrJM8El2hkDUh?=
 =?us-ascii?Q?qm5img=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5745B2492B643946A58E5509DFBDC359@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wfmFD2NEaursm1gGBw7bMZZDPQYS3bgZ0plrGw6rtwCxLLCczevEaYL5E125fugKgYLfrRWVeZi3juNgY/lpdvOHeWLPOmxnDGVKGjYnYuOUs2CqNLFVAUfTDmXA2/vFxPirNa40AIl8x45W0J6QVcbETWVY7wkbqNxdB8qtIdV4eFr4caOYxn5ldEhtVsesc6BYbtjEXH6NSI9rQSAWlIRU0/AfpIbg+OCAYEGM7BMrrPvsyHbiQQzD3V4c0MLYB65LZHZkVCzha/l+6H0g3DKEs+CV7X4bIGcFiQ3veLoQZH5uxySkqr6eaPKP5bW9Q+TONHGuRXF6azkTGNAwzVw53bUPLE0d8fDqdDW7mMlDiyv5R494dmkDDTNzfJvoKnICWQGRycyspj+ZT2YA7BoJY9/3oiAGQGBVmUlFmi0XGU9Sboo5ExIt+5KfSoXmVeE+JAJNmwycXoqn8GvakECSwNJPcrEXRVgcjvPJan1+ww3QR97xZ9ndgyYz6gzoFkrCg/IEZ8mSlUl3gf50gDCXMKFZlq2FNP1ttn/T3YSa4Xqnycpri05brQDGTYq96JufPwrG3ryhsD6JTJrHhnb6BeH9/QaXhv35o2M0HG9Kqp1wrmMb+BGMdhkmyBWp+8ZNILv121+76xGzmFZmek+ih8s/TSxCy+2o3embh8chKP1m5XG+/Ao/8mQljLqHAXZlKQg8jdX5YpR01SH8LFLc7uWQmSX8tgkCO8FxPnZ6DWX0wdRK1k+4dnwqUh6jfBOYd9wrSMFavVWp/bzpdKRtEpopLIQ/onkZ8jPMdNoyCTjK+sIhsCfFyeKl3XKNp9fIi7GaS41WkPHiQP4XZg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72939dab-4984-4d51-b1c9-08dbd171a732
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2023 13:37:06.9592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CYywuNnu0qcM1t/H9EIUuZsFccAeG3rMvIF2fBrYwg3PMENfdtqOyUlroiZVfkeaRlshFSf+S9R73WtCUtqm6/Qt6vt01bgrzg0PV3TVnlM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6711
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310200111
X-Proofpoint-ORIG-GUID: X_aAstF_ZrEcFx_-bY1frO9xQnZjgZ6g
X-Proofpoint-GUID: X_aAstF_ZrEcFx_-bY1frO9xQnZjgZ6g
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Oct 19, 2023, at 1:09 PM, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> From: Darrick J. Wong <djwong@kernel.org>
>=20
> XFS has a rather slow reflink operation.  While a reflink operation is
> running, other programs cannot read the contents of the source file,
> which is causing latency spikes.  Catherine Hoang wrote a patch to
> permit reads, since the source file contents do  not change.  This is a
> functionality test for that patch.
>=20
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
> src/Makefile              |    2=20
> src/t_reflink_read_race.c |  343 ++++++++++++++++++++++++++++++++++++++++=
+++++
> tests/generic/1953        |   74 ++++++++++
> tests/generic/1953.out    |    6 +
> 4 files changed, 424 insertions(+), 1 deletion(-)
> create mode 100644 src/t_reflink_read_race.c
> create mode 100755 tests/generic/1953
> create mode 100644 tests/generic/1953.out
>=20
> diff --git a/src/Makefile b/src/Makefile
> index 72c8a13007..b5e2b84dae 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -33,7 +33,7 @@ LINUX_TARGETS =3D xfsctl bstat t_mtab getdevicesize pre=
allo_rw_pattern_reader \
> attr_replace_test swapon mkswap t_attr_corruption t_open_tmpfiles \
> fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
> detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
> - uuid_ioctl usemem_and_swapoff
> + uuid_ioctl usemem_and_swapoff t_reflink_read_race
>=20
> EXTRA_EXECS =3D dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
>      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
> diff --git a/src/t_reflink_read_race.c b/src/t_reflink_read_race.c
> new file mode 100644
> index 0000000000..acf8f8f73c
> --- /dev/null
> +++ b/src/t_reflink_read_race.c
> @@ -0,0 +1,343 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Race reads with reflink to see if reads continue while we're cloning.
> + * Copyright 2023 Oracle.  All rights reserved.
> + */
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <sys/ioctl.h>
> +#include <linux/fs.h>
> +#include <time.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <signal.h>
> +#include <fcntl.h>
> +#include <pthread.h>
> +#include <stdio.h>
> +#include <errno.h>
> +#include <string.h>
> +
> +#ifndef FICLONE
> +# define FICLONE _IOW(0x94, 9, int)
> +#endif
> +
> +static pid_t mypid;
> +
> +static FILE *outcome_fp;
> +
> +/* Significant timestamps.  Initialized to zero */
> +static double program_start, clone_start, clone_end;
> +
> +/* Coordinates access to timestamps */
> +static pthread_mutex_t lock =3D PTHREAD_MUTEX_INITIALIZER;
> +
> +struct readinfo {
> + int fd;
> + unsigned int blocksize;
> + char *descr;
> +};
> +
> +struct cloneinfo {
> + int src_fd, dst_fd;
> +};
> +
> +#define MSEC_PER_SEC 1000
> +#define NSEC_PER_MSEC 1000000
> +
> +/*
> + * Assume that it shouldn't take longer than 100ms for the FICLONE ioctl=
 to
> + * enter the kernel and take locks on an uncontended file.  This is also=
 the
> + * required CLOCK_MONOTONIC granularity.
> + */
> +#define EARLIEST_READ_MS (MSEC_PER_SEC / 10)
> +
> +/*
> + * We want to be reasonably sure that the FICLONE takes long enough that=
 any
> + * read initiated after clone operation locked the source file could hav=
e
> + * completed a disk IO before the clone finishes.  Therefore, we require=
 that
> + * the clone operation must take at least 4x the maximum setup time.
> + */
> +#define MINIMUM_CLONE_MS (EARLIEST_READ_MS * 5)
> +
> +static double timespec_to_msec(const struct timespec *ts)
> +{
> + return (ts->tv_sec * (double)MSEC_PER_SEC) +
> +       (ts->tv_nsec / (double)NSEC_PER_MSEC);
> +}
> +
> +static void sleep_ms(unsigned int len)
> +{
> + struct timespec time =3D {
> + .tv_nsec =3D len * NSEC_PER_MSEC,
> + };
> +
> + nanosleep(&time, NULL);
> +}
> +
> +static void outcome(const char *str)
> +{
> + fprintf(outcome_fp, "%s\n", str);
> + fflush(outcome_fp);
> +}
> +
> +static void *reader_fn(void *arg)
> +{
> + struct timespec now;
> + struct readinfo *ri =3D arg;
> + char *buf =3D malloc(ri->blocksize);
> + loff_t pos =3D 0;
> + ssize_t copied;
> + int ret;
> +
> + if (!buf) {
> + perror("alloc buffer");
> + goto kill_error;
> + }
> +
> + /* Wait for the FICLONE to start */
> + pthread_mutex_lock(&lock);
> + while (clone_start < program_start) {
> + pthread_mutex_unlock(&lock);
> +#ifdef DEBUG
> + printf("%s read waiting for clone to start; cs=3D%.2f ps=3D%.2f\n",
> + ri->descr, clone_start, program_start);
> + fflush(stdout);
> +#endif
> + sleep_ms(1);
> + pthread_mutex_lock(&lock);
> + }
> + pthread_mutex_unlock(&lock);
> + sleep_ms(EARLIEST_READ_MS);
> +
> + /* Read from the file... */
> + while ((copied =3D read(ri->fd, buf, ri->blocksize)) > 0) {
> + double read_completion;
> +
> + ret =3D clock_gettime(CLOCK_MONOTONIC, &now);
> + if (ret) {
> + perror("clock_gettime");
> + goto kill_error;
> + }
> + read_completion =3D timespec_to_msec(&now);
> +
> + /*
> + * If clone_end is still zero, the FICLONE is still running.
> + * If the read completion occurred a safe duration after the
> + * start of the ioctl, then report that as an early read
> + * completion.
> + */
> + pthread_mutex_lock(&lock);
> + if (clone_end < program_start &&
> +    read_completion > clone_start + EARLIEST_READ_MS) {
> + pthread_mutex_unlock(&lock);
> +
> + /* clone still running... */
> + printf("finished %s read early at %.2fms\n",
> + ri->descr,
> + read_completion - program_start);
> + fflush(stdout);
> + outcome("finished read early");
> + goto kill_done;
> + }
> + pthread_mutex_unlock(&lock);
> +
> + sleep_ms(1);
> + pos +=3D copied;
> + }
> + if (copied < 0) {
> + perror("read");
> + goto kill_error;
> + }
> +
> + return NULL;
> +kill_error:
> + outcome("reader error");
> +kill_done:
> + kill(mypid, SIGTERM);
> + return NULL;
> +}
> +
> +static void *clone_fn(void *arg)
> +{
> + struct timespec now;
> + struct cloneinfo *ci =3D arg;
> + int ret;
> +
> + /* Record the approximate start time of this thread */
> + ret =3D clock_gettime(CLOCK_MONOTONIC, &now);
> + if (ret) {
> + perror("clock_gettime clone start");
> + goto kill_error;
> + }
> + pthread_mutex_lock(&lock);
> + clone_start =3D timespec_to_msec(&now);
> + pthread_mutex_unlock(&lock);
> +
> + printf("started clone at %.2fms\n", clone_start - program_start);
> + fflush(stdout);
> +
> + /* Kernel call, only killable with a fatal signal */
> + ret =3D ioctl(ci->dst_fd, FICLONE, ci->src_fd);
> + if (ret) {
> + perror("FICLONE");
> + goto kill_error;
> + }
> +
> + /* If the ioctl completes, note the completion time */
> + ret =3D clock_gettime(CLOCK_MONOTONIC, &now);
> + if (ret) {
> + perror("clock_gettime clone end");
> + goto kill_error;
> + }
> +
> + pthread_mutex_lock(&lock);
> + clone_end =3D timespec_to_msec(&now);
> + pthread_mutex_unlock(&lock);
> +
> + printf("finished clone at %.2fms\n",
> + clone_end - program_start);
> + fflush(stdout);
> +
> + /* Complain if we didn't take long enough to clone. */
> + if (clone_end < clone_start + MINIMUM_CLONE_MS) {
> + printf("clone did not take enough time (%.2fms)\n",
> + clone_end - clone_start);
> + fflush(stdout);
> + outcome("clone too fast");
> + goto kill_done;
> + }
> +
> + outcome("clone finished before any reads");
> + goto kill_done;
> +
> +kill_error:
> + outcome("clone error");
> +kill_done:
> + kill(mypid, SIGTERM);
> + return NULL;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> + struct cloneinfo ci;
> + struct readinfo bufio =3D { .descr =3D "buffered" };
> + struct readinfo directio =3D { .descr =3D "directio" };
> + struct timespec now;
> + pthread_t clone_thread, bufio_thread, directio_thread;
> + double clockres;
> + int ret;
> +
> + if (argc !=3D 4) {
> + printf("Usage: %s src_file dst_file outcome_file\n", argv[0]);
> + return 1;
> + }
> +
> + mypid =3D getpid();
> +
> + /* Check for sufficient clock precision. */
> + ret =3D clock_getres(CLOCK_MONOTONIC, &now);
> + if (ret) {
> + perror("clock_getres MONOTONIC");
> + return 2;
> + }
> + printf("CLOCK_MONOTONIC resolution: %llus %luns\n",
> + (unsigned long long)now.tv_sec,
> + (unsigned long)now.tv_nsec);
> + fflush(stdout);
> +
> + clockres =3D timespec_to_msec(&now);
> + if (clockres > EARLIEST_READ_MS) {
> + fprintf(stderr, "insufficient CLOCK_MONOTONIC resolution\n");
> + return 2;
> + }
> +
> + /*
> + * Measure program start time since the MONOTONIC time base is not
> + * all that well defined.
> + */
> + ret =3D clock_gettime(CLOCK_MONOTONIC, &now);
> + if (ret) {
> + perror("clock_gettime MONOTONIC");
> + return 2;
> + }
> + if (now.tv_sec =3D=3D 0 && now.tv_nsec =3D=3D 0) {
> + fprintf(stderr, "Uhoh, start time is zero?!\n");
> + return 2;
> + }
> + program_start =3D timespec_to_msec(&now);
> +
> + outcome_fp =3D fopen(argv[3], "w");
> + if (!outcome_fp) {
> + perror(argv[3]);
> + return 2;
> + }
> +
> + /* Open separate fds for each thread */
> + ci.src_fd =3D open(argv[1], O_RDONLY);
> + if (ci.src_fd < 0) {
> + perror(argv[1]);
> + return 2;
> + }
> +
> + ci.dst_fd =3D open(argv[2], O_RDWR | O_CREAT, 0600);
> + if (ci.dst_fd < 0) {
> + perror(argv[2]);
> + return 2;
> + }
> +
> + bufio.fd =3D open(argv[1], O_RDONLY);
> + if (bufio.fd < 0) {
> + perror(argv[1]);
> + return 2;
> + }
> + bufio.blocksize =3D 37;
> +
> + directio.fd =3D open(argv[1], O_RDONLY | O_DIRECT);
> + if (directio.fd < 0) {
> + perror(argv[1]);
> + return 2;
> + }
> + directio.blocksize =3D 512;
> +
> + /* Start threads */
> + ret =3D pthread_create(&clone_thread, NULL, clone_fn, &ci);
> + if (ret) {
> + fprintf(stderr, "create clone thread: %s\n", strerror(ret));
> + return 2;
> + }
> +
> + ret =3D pthread_create(&bufio_thread, NULL, reader_fn, &bufio);
> + if (ret) {
> + fprintf(stderr, "create bufio thread: %s\n", strerror(ret));
> + return 2;
> + }
> +
> + ret =3D pthread_create(&directio_thread, NULL, reader_fn, &directio);
> + if (ret) {
> + fprintf(stderr, "create directio thread: %s\n", strerror(ret));
> + return 2;
> + }
> +
> + /* Wait for threads */
> + ret =3D pthread_join(clone_thread, NULL);
> + if (ret) {
> + fprintf(stderr, "join clone thread: %s\n", strerror(ret));
> + return 2;
> + }
> +
> + ret =3D pthread_join(bufio_thread, NULL);
> + if (ret) {
> + fprintf(stderr, "join bufio thread: %s\n", strerror(ret));
> + return 2;
> + }
> +
> + ret =3D pthread_join(directio_thread, NULL);
> + if (ret) {
> + fprintf(stderr, "join directio thread: %s\n", strerror(ret));
> + return 2;
> + }
> +
> + printf("Program should have killed itself?\n");
> + outcome("program failed to end early");
> + return 0;
> +}
> diff --git a/tests/generic/1953 b/tests/generic/1953
> new file mode 100755
> index 0000000000..058538e6fe
> --- /dev/null
> +++ b/tests/generic/1953
> @@ -0,0 +1,74 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2023, Oracle and/or its affiliates.  All Rights Reserved=
.
> +#
> +# FS QA Test No. 1953
> +#
> +# Race file reads with a very slow reflink operation to see if the reads
> +# actually complete while the reflink is ongoing.  This is a functionali=
ty
> +# test for XFS commit f3ba4762fa56 "xfs: allow read IO and FICLONE to ru=
n
> +# concurrently".
> +#
> +. ./common/preamble
> +_begin_fstest auto clone punch
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/attr
> +. ./common/reflink
> +
> +# real QA test starts here
> +_require_scratch_reflink
> +_require_cp_reflink
> +_require_xfs_io_command "fpunch"
> +_require_test_program "punch-alternating"
> +_require_test_program "t_reflink_read_race"
> +
> +rm -f "$seqres.full"
> +
> +echo "Format and mount"
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount >> "$seqres.full" 2>&1
> +
> +testdir=3D"$SCRATCH_MNT/test-$seq"
> +mkdir "$testdir"
> +
> +calc_space() {
> + blocks_needed=3D$(( 2 ** (fnr + 1) ))
> + space_needed=3D$((blocks_needed * blksz * 5 / 4))
> +}
> +
> +# Figure out the number of blocks that we need to get the reflink runtim=
e above
> +# 1 seconds
> +echo "Create a many-block file"
> +for ((fnr =3D 1; fnr < 40; fnr++)); do
> + free_blocks=3D$(stat -f -c '%a' "$testdir")
> + blksz=3D$(_get_file_block_size "$testdir")
> + space_avail=3D$((free_blocks * blksz))
> + calc_space
> + test $space_needed -gt $space_avail && \
> + _notrun "Insufficient space for stress test; would only create $blocks_=
needed extents."
> +
> + off=3D$(( (2 ** fnr) * blksz))
> + $XFS_IO_PROG -f -c "pwrite -S 0x61 -b 4194304 $off $off" "$testdir/file=
1" >> "$seqres.full"
> + "$here/src/punch-alternating" "$testdir/file1" >> "$seqres.full"
> +
> + timeout 1s cp --reflink=3Dalways "$testdir/file1" "$testdir/garbage" ||=
 break
> +done
> +echo "fnr=3D$fnr" >> $seqres.full
> +
> +echo "Reflink the big file"
> +$here/src/t_reflink_read_race "$testdir/file1" "$testdir/file2" \
> + "$testdir/outcome" &>> $seqres.full
> +
> +if [ ! -e "$testdir/outcome" ]; then
> + echo "Could not set up program"
> +elif grep -q "finished read early" "$testdir/outcome"; then
> + echo "test completed successfully"
> +else
> + cat "$testdir/outcome"
> +fi
> +
> +# success, all done
> +status=3D0
> +exit
> diff --git a/tests/generic/1953.out b/tests/generic/1953.out
> new file mode 100644
> index 0000000000..8eaacb7ff0
> --- /dev/null
> +++ b/tests/generic/1953.out
> @@ -0,0 +1,6 @@
> +QA output created by 1953
> +Format and mount
> +Create a many-block file
> +Reflink the big file
> +Terminated
> +test completed successfully

