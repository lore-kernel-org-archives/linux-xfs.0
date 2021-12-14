Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15022C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbhLNIrR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:47:17 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:6278 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231742AbhLNIrR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:47:17 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE74QUc021566;
        Tue, 14 Dec 2021 08:47:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=DvtgW30n2Ht22QmIUNF20buE1KvnlTh+ebiYPN/J/cc=;
 b=iReDRtbejCZmeo935VadzR2MtBqx1jggNO5ZoD6OtHMybnfjxlhpIMM2OFqwulPWjfv6
 JMBjQlrHenXtMc9jWdHgyRxTmqi6Z9p2CjJw0//aBMVo6Oikm5MIOKTMAgikTZFZAakw
 GcYPYrW7E+FAY9z1uOkWmN6tqRElfV/nbxExj2xM34w2YobLS/EqRwtIvsp1Ope1bGah
 GhE0GSMgjKPb6BrtEPxsNQxHMCMXGfYYbHTmPNbuPUQksXrqbxaYnwKGPzXEo2lIvXlm
 NL0LwmSMNSeCBvHo7hXNX4Up+7qHm16U9OwXIgeoeAmza/0KDU5d3ugRYDpuTCKqClLo uQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3ukb2sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8fYbZ156468;
        Tue, 14 Dec 2021 08:47:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by userp3030.oracle.com with ESMTP id 3cvh3wy53h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTKR6Ka1iq02j9H+I0OfOdH/UCfEPgUdAEiqe4HDHLTU8Jxu3NBh9lXRexpF+YM22AJeAZ1BG2HcXO4jNKF8zGp1dNujVii5E9tEq+tqO6WgzxFZybfOA5lu3TIEST9M2efe6AdWaO/6Sm5YPKCqMkQx/s8HHva9XlKfUjUysicetCDLtQuxFg47XfPjHNeCXvoqlf86HGVNuA3cmrSRsDzAzbLQW0LprsHr5Z7zXKsLXNg5+2hB14vx3tXV2mfrQbXZ9L9UTca5cMTJb1MHvxcRe/lxrPg8j4QFfD/0nq+a3xCpguu2JZ032ajK0MSNtZpP0d4ARTaN/OdyTlsEkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DvtgW30n2Ht22QmIUNF20buE1KvnlTh+ebiYPN/J/cc=;
 b=mc3BPdVemkAwuBVJ38rbl6teEQui7RaEoOKl5lqvZdEunFK382RF/AWWtBvT1GOCvcjt+jbo4vqqnrDXjX0Efx2jAv9LcbxtTRvRz/AHP1Y0Y6+F731BLNxFpYuOt0YMVA2XiaN7GZ+uWJNPQ4oVkdq39JqR9yNajmPxxbAz4RtFSeZ1Cj6/Trh2Z3HRLVA3QvjFZflxJGlHiz5EoJ47/9yzonCmEScQUgqKiEUx6hhEMo7278HyHi6HLe262rgKLSnUjym7ydD2kKcUSdZk0uLV9mzxuSWgy4HJZv9vWrNuFwYqzvP1pqGG/dm1WN5YCmQ/1D/Q2mwMut26Dp2Osw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DvtgW30n2Ht22QmIUNF20buE1KvnlTh+ebiYPN/J/cc=;
 b=0F14fhuMH8rt549s8McZ3WnwNLHx7aF/QY4gbbfrsxDaEBbyr9uTjYzIsvh3fe16Uzb81ChL8yIuzlBdp8DmtoP9k0C4IE++Ya29VO5g+scghJ9Rjl3gkJSAucWCcISO5dmRrbmBALSmnlKDGmsnNPJenFt1sa2LCmf6jDoK93A=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3054.namprd10.prod.outlook.com (2603:10b6:805:d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:47:11 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:47:11 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 07/16] xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs feature bit
Date:   Tue, 14 Dec 2021 14:15:10 +0530
Message-Id: <20211214084519.759272-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084519.759272-1-chandan.babu@oracle.com>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0052.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d904d44d-d7d6-4604-8f06-08d9bede51d3
X-MS-TrafficTypeDiagnostic: SN6PR10MB3054:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB30544D8DFD9C5F5ED0DA30FEF6759@SN6PR10MB3054.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:186;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QK51y/3Re3RvXMIQJviBAlPzd+vo/RadhpPZhTjKOxMwfhnDiiStcIIfuOaGrm/l9M7xzwxq7iV50Vd0bAbHdx/4TNgA8zUIfk2FTiuo0mFSo6tBLVVz0tTPboO3y6dWueypr+SfNK+hIMDKyY1fUNoc87S37eFxeCIVC6UZOTW6hA4saK5bQ6b79iEp3wuvDOjuPuyhG5GKa/TYdmeR9uVbgZPVpFwNkvvMFMV51zV6Ed4xcsF7jBh9plhud336DVklF24hEDMrTtg6Xb9TDgAZIGxYdcgZo/A6HMJCLJzWI+cPiWSEsunw041adhVd12mfCREBeSfSrPb3xZWyOEhB2bnc6/+yOv8yhN8vRfVbKuaQo3Jbsx2NNF4mjij5S2YGHW1+qMhVTP0vhE5Di5hhMqAA024HkaEjTXNrAwPsLVE6vE81tYBX339vgOP4GXrU3XAbPUxd49Yixefvb4do1wKy1kSJgk0vdopzUlh8h3uaYVfP3MphPXjINHHmpCGrrDew/2NKyFDIE7TU3+kCZ6DG4ht8CecHe12OhfJuNYfbK7ZDIWVAtOA8TPjPGSCUdM61MoGVnpLHw2MLbHQZqHZGm1+GLvkb/4iNaCesznOcpJy6sTwLJl0UfK18jU36vNSEXpyDacPQGEZ1k+3l2AD4yMNxxsCl2VFeiUH4jrEvLY2kyYoGnmVuAuBA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(66556008)(66476007)(6486002)(316002)(6916009)(6512007)(186003)(5660300002)(2906002)(36756003)(83380400001)(26005)(66946007)(2616005)(1076003)(4326008)(6506007)(508600001)(52116002)(38350700002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XyR/kXV6mcLHe0d8kYdUdfqC9RH9/RhqMxgQ830jPHBVbSkh7MDWn/XHQGXa?=
 =?us-ascii?Q?njM/YVaa3FgMBaCaVWmkumaqSqFKs/Z7RTeofa81GBiAfQoIXaJh6Jju/hxW?=
 =?us-ascii?Q?Cibj2UO5tGJlvlFAHCgzsPFAGoqhJhPoxXDWqYeOY5UTnnhUvHbtPAn3IbWt?=
 =?us-ascii?Q?d1kNJdc/TK5lCHkwFJ45rfzNW/fXFWWb78vWP0BOGEM9Jshd2uVXwg9O1PlZ?=
 =?us-ascii?Q?vNYYW4XzHoPUKIsA6OdLWrPlqX6JhVNUk63BU9sYVS78yNv3zzfvA2yvKXrq?=
 =?us-ascii?Q?DC48pIqxkYL4PBUAa+5mnQ7NuNWd6zxfxoKmaY1e4ca2UkGgfHTWctK22LNm?=
 =?us-ascii?Q?GN8HgAP59UPRx5vH5ljHTj4TXhvcKyNSyyiBl+sh3VEPaaR07lWDkZyKuwEN?=
 =?us-ascii?Q?9awbCOuitOb3ddOySUayJAV8p7ZHpKeAxd4xhvHUF6j9W+j+c6dn9YyP3s7N?=
 =?us-ascii?Q?6ih3VEEWV+wlei+1wR4E47zQopLNw2skI2imvaoj6DOs5IZazVoz6IHXuGH0?=
 =?us-ascii?Q?4wBIcbajOGkLrX+ffz8Wk2N7LR1uRv1H9K+HC6hdLvcdSa6qOmC7d+MKBRRP?=
 =?us-ascii?Q?qkB76ry8iViQBtx0iuhDcG6bg/HAqRteVuHtuvQgHCa48jr/NLUcv0LxwiZM?=
 =?us-ascii?Q?KQZffp4d0+i8uCag45OrCyVXupLYhzPIJHyl9RKS7jWusQR0CU9D5ufZKN18?=
 =?us-ascii?Q?aORG7tFC7X1SXfcFo01DDa/FXyT03MsWbGBmuXpJkLUQEwfhxt1QFgNdvVMO?=
 =?us-ascii?Q?AtKVUROKv9UCCEmhhP1rEckgvOz8I/mrLc2bbPfKrur4wdAtqsKSqnFsX8K+?=
 =?us-ascii?Q?GgDiicaa8PgMT2QkRfzu291qXX+rOo2lhBVWSLf5qFVnnPez/BLJvX1uRvvo?=
 =?us-ascii?Q?zeuCY76RMOUO1g+dxWZxkFhyhoX+2rXdJ7WtVm+Hm4UHJR61lWQLHwWdpjbV?=
 =?us-ascii?Q?Owq0Qo63naqYvcLBztWFAoU64cPK74tE1eKC0/XQ8OdJMSvWMdGqpIuY17by?=
 =?us-ascii?Q?Nw3pboR0acCCNbkiuisNkzBnGcLnN34yYmwTOkNch76AcHFyqIIk8TNRecYI?=
 =?us-ascii?Q?LY7+Nez5T542dPkmhT4Rhb7OmCja5GFESai0gfyL+LwS1LlxC13KBdGtjCFq?=
 =?us-ascii?Q?7+JY3l0w8bWbVStTIjjdODmxgz0l6bSiTjAAWI2UfThQtJH9OYSY4PcSi0IV?=
 =?us-ascii?Q?Tm3l5Y0qrtx3p/nKwvF6xXxz/j9Iu6NSlxjsFqMqC3Sb9si3m0IkyKZGMid5?=
 =?us-ascii?Q?SjmJAEw0CzQOSQ2MVFRoCxtvvxWxOyoYshODOP/JMrajV7+K/1bWsEFtsTbe?=
 =?us-ascii?Q?lou2a1G1Ec8hy5KIHTrIfgleb+EKO7vjF5lyNFC2q/TzvR5IfTewz0DbJu6i?=
 =?us-ascii?Q?9rleUeVRzmhCP4yhWF6P/01RGi2zg1LXsuFR2FXyACdFQpRoNjSPUGa4HfJK?=
 =?us-ascii?Q?yRtEzwAjilZv5s5Hv70gcPTBwpvVPmvDIax8CHITVsF1BP2BHodHSm4nlBjb?=
 =?us-ascii?Q?VungY2ZylnsF+lkEZ9Auna3LtG4H6DiikdUGW9uh2r20ugJpV5QVPPZoYPSn?=
 =?us-ascii?Q?Ob0z9j1gobIaCQb9Tt5y3vW1Kx0PEzyaB0GAO4AmhrNmRr5BsaJtGbSTshgK?=
 =?us-ascii?Q?BqXIxSWCZV9Lmopahu6BBA8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d904d44d-d7d6-4604-8f06-08d9bede51d3
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:47:11.7936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pNxUMoEqlOsr13P9hGGEBtJ6vEOeiap9NcvKU/nZhtxNkHdO5E/ymM8iYVOdYWyQJgltJouqMumc7LAyusVH8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3054
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140049
X-Proofpoint-GUID: HMe0gI77JWJc4jsadsVdJ0QO3QOlYEoZ
X-Proofpoint-ORIG-GUID: HMe0gI77JWJc4jsadsVdJ0QO3QOlYEoZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_SB_FEAT_INCOMPAT_NREXT64 incompat feature bit will be set on filesystems
which support large per-inode extent counters. This commit defines the new
incompat feature bit and the corresponding per-fs feature bit (along with
inline functions to work on it).

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 3 +++
 fs/xfs/xfs_mount.h         | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e5654b578ec0..7972cbc22608 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -372,6 +372,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
+#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* 64-bit data fork extent counter */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f4e84aa1d50a..bd632389ae92 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -124,6 +124,9 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_BIGTIME;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
 		features |= XFS_FEAT_NEEDSREPAIR;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
+		features |= XFS_FEAT_NREXT64;
+
 	return features;
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 00720a02e761..10941481f7e6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -276,6 +276,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_INOBTCNT	(1ULL << 23)	/* inobt block counts */
 #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
+#define XFS_FEAT_NREXT64	(1ULL << 26)	/* 64-bit inode extent counters */
 
 /* Mount features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
@@ -338,6 +339,7 @@ __XFS_HAS_FEAT(realtime, REALTIME)
 __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
+__XFS_HAS_FEAT(nrext64, NREXT64)
 
 /*
  * Mount features
-- 
2.30.2

