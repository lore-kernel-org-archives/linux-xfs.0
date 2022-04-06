Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B7F7C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 09:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237066AbiDFJjz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585392AbiDFJgZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:36:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0111A2AA19A
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:27 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235NpcNm006381;
        Wed, 6 Apr 2022 06:20:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=YI9uTlgftHQapQkHM+BKBXSvRHA3lg8HUvrdzjsWu1w=;
 b=D4uRqMGSzfZ+Ohff6twCdhdC8wA50xe2cxGYKvMzVU/i1dbbCDu388eWEfpeW07IIOFy
 k05JRkAhwQCIoOCNfWHU6mrbWl1kGVXjyB0/y6LoRk92dlu20/pC1Tt3mctTkQg6wg/O
 7SRI1VtKWsLUGQK0Qig62lWZ5Ulruff9jn9wRzJ2BPqenN1Hz5GNaey8lOUfMVxp/Nyh
 Xsl5KMLTMi9p2RCiXIOyofaj4z016Z7qfdX4zvMBl9qWKg6LsjAd7VZzrxLXU/xD0CgT
 wdztKI5cr9qOAVXUh9soh+yixHWxCmrtaQluqiDVXIWotlBIFc+nu9V5JFNP7oElreLS dA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d31fyev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:25 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366AsBq037250;
        Wed, 6 Apr 2022 06:20:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx47t7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HDW91clnupD7POE1Hjczkm2N1+3d/VDBCR5ZuH4W1HRjivRzitbWw3a/heDsw5A03iMP7Rd0Qj5t0dHKHe3XJKtIfe8I6XuOn/Z9I3TbGmErmOZTEP2rQdfTQCgYG7oVqy0VpfksA/3QQVlNB+KxHgPXGPmKUDXefrbcjmxZOtpuSlQoUJvCRuGgTiTmjT2wTUM+lP542gPavqhycBwVUMF9REEV7A902j6Hsea9HFC4bcCUlzcgAhAqa+D3gAQlm2R1Z9eVNOqAk+agT7CDMkv1Cg1ZfM5IIwrlC3j3L/PNbvh9y7kEWwBFvvnU50as3NGd7+iL6yFAKxYi9KKGng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YI9uTlgftHQapQkHM+BKBXSvRHA3lg8HUvrdzjsWu1w=;
 b=Kf9V1Yaa3x1PfcXLY3TYHuzqqRD5OYI8jvIb0rOvkzzBHAjfnE5oAHKXd1f8rHbJGrh44Sb2CszGegjR1Mpt1TKFIewl843W0P7yg6mzuz19CXTWLbd0QhgmdETb9dBQerpH0buDqHhRdcPNCVDMcQ+pYzJVCu6IuNWO8fyvYwNE7qCblvSZdgVXPvbh5DG7rEfI1MiMy+NW4+YZg7+ntnlZfEYl4mdJkqg3ulCKyMh49/f9nrck2wM6L7vM1ih3s/3qIfIoqnr74VhmpKQTJiLfdsTlREA6KJy2yADYBHVLpCzSVHLMwc02sjcpiAK54hUabwvFi5UOsWoHWfQH2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YI9uTlgftHQapQkHM+BKBXSvRHA3lg8HUvrdzjsWu1w=;
 b=clvINIJlEnsNkWWqaslyuLic8SC+rtVC/7fkot8HC4TFjYSZJZaC9eBKysUVCgH8UH17ye2MgEh3VEb9SXseuxqcTIBnbyP00V4Eaoxclr8jO5DxyoLOw4mX2gKfVHxtIhs9L9j3K4HG7KZSzCxZKm+qCk5Nhds9hLhWEk4aVdg=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:21 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:21 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V9 08/19] xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs feature bit
Date:   Wed,  6 Apr 2022 11:48:52 +0530
Message-Id: <20220406061904.595597-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061904.595597-1-chandan.babu@oracle.com>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0047.jpnprd01.prod.outlook.com
 (2603:1096:405:1::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc3395d1-1773-44c4-87a5-08da17958742
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB55646AAEE32872004316716EF6E79@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: khMHSnGe19nyTZd2ZGlx+Q7pdO0Ch6UURVR7lBT3+s7/kmJKR1IqXiirzLtJ1xKIFDdViaV3/eHD0unvyTj1NVdMEk3wOWMtLhICmVJFGiBynomyFYfmd8m/MZ/Wa/EwYEoGN/rHiIihRkvBKIkPn0NP0Ijm1Ck/o31mwn/e/ri77QNukpM2v1R/wcvv07/4rNgaDsutUwSoNwKMrCmMdqIYXj4Qw0Bp7aeVAnEq+LqmazxjsDEhT/+iL9DgfruneeXKQgdLOcKn2LhIVOo9BzSQlHzIEUKHn0iJa6gZjzzjoBkPzwXxS5q2ksVhSPkDC7udOz3tWwesR4XYz/M9kYfoRpDY0u4FH3LCDyTwsVdXr+k/yv2r7Dp4vlhnEkNGyJd6EbDm4j6v5ec0F1K/mljyMeijmlQ5YMQ+yz4/lH6StjrakWMV3t2MTKZJ9R69uzeVOaO+q/0ErRR7F7jqjJ40PUyJYKJUhMLh3z+R0Yrz/0u+F0PdMLMeIOhCliZatz1BbBsKw+ErD2rAuCw8A5I/LhbnjoMDKc8FKkFtpz8S7qV50x9KJVrdarTX4pxAIichyPv6j3nKqvXFVG0eCxDpEPfz6EWdlVNOoF7oIJ+DacGRHXhoY5qmQDa2Wqegfj/4AwCUm6MP09bVwdo2/jcRPqGhH94EVW3MiOMUYysPbH1y25ufzsk058VECpdggMko7Nq8y8Yu3k0mmiBiRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66476007)(66946007)(6506007)(66556008)(52116002)(6512007)(6486002)(6916009)(4326008)(8676002)(6666004)(316002)(5660300002)(1076003)(8936002)(2616005)(83380400001)(86362001)(38350700002)(38100700002)(2906002)(26005)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c1SN+ttsSrDlvReofvmzaUMTVuXrE0nrHvA3z5PzwDWqqgBj53Sgwp2/p6Ur?=
 =?us-ascii?Q?l2KvBN5Id5+31BNSkc74nGsFQT5nxeZFiiuCLTNGH4mo6wMgWuBTunarO7mu?=
 =?us-ascii?Q?Zi3f1Y4f3UsS6idAS3IHtlJcRoh3ixGZdWVKZkNkQ/sw+zzQOAtBGpvrZh+4?=
 =?us-ascii?Q?U51iWIOe7ypVoqKPdwRMMvfIDjtcWObItKnxONGtxgUFKRsd5EJU9hCC5HPJ?=
 =?us-ascii?Q?WzvAldIJ7LhPiupH5Rg8WAuIx4MmcwejHskgYXJNs4cifFK1RC0Lufd937MU?=
 =?us-ascii?Q?GHH4cC3ZdYK2vIqmOVktreKnIrKFzG6Nsy7anhYY+PYU7xGbUYsXqt2csol5?=
 =?us-ascii?Q?qGGfRJ1K0kJlnok4IyXdLbV7G9629WDZdfs9PWeAfPV6rQbRdsUgHDAKjVJd?=
 =?us-ascii?Q?cGGVCfvvhUxDchCabngu5PYKgPQrTSFY5ce9e+mdtmsPLY11ArMGO1XSNF6x?=
 =?us-ascii?Q?mdoWPmJOp7sjwwgCROij19+gpyu7QcnckCHLdfYWTsb6Yq6w5pEpkCis/F0J?=
 =?us-ascii?Q?QbqY0uMOimk12Bcije2mRep1R+I0nzHR1ZG0nK3qCNP5EcYd6+Nj2P0N9e+y?=
 =?us-ascii?Q?vy8uNPCgzjHJNNWm+uAx0BpkAhqrZ41L+JugbKJpmzOQPK2vol2KERrZiqL+?=
 =?us-ascii?Q?WwQ+5A3Tkyep1hNhAyHxzYj6gTaqFCj0ni634xT7RP97StLiW3NtQlT26ZwX?=
 =?us-ascii?Q?Ws8p5/Q4NxY0rytBV4pI0URaIWLxyZ7fL+caWIhqMyAzlsNVLomYDblvOV8l?=
 =?us-ascii?Q?7orwnpO8Q1J/kO8Kw8tfaMsWTM1dKlX0xuQDP3mWSj/u0HCJOAIjeT0CVuF0?=
 =?us-ascii?Q?oUOp/cSodrvTBhdbbHAVF/l/MoDRFfEvnTEFtr+BPioNockwAAWTkKo9Czb6?=
 =?us-ascii?Q?BTZz5cUD8LNSzI0MFSOXfE+Cyz2j1/7t/lFu55xezyU5XwTNzskV3sb0WDTE?=
 =?us-ascii?Q?1f7l+ZsF2QMGVrX4c8dH9n+gllcRNhPqv5/4I/ArqqBloNySi+UI13l+TfIj?=
 =?us-ascii?Q?tYj7EfxZEkSqEMVjjB0Hx2JBkuswEG6kgE/zpCUABZvz7xY04/+R8c1V9zX8?=
 =?us-ascii?Q?udImCDrhXhP6Ws6+IVmx4M7VHhhYL+rZxklpswgssRmwlT4Ulr7TSS+NKLIG?=
 =?us-ascii?Q?0ezrpsjk/usI/0F7is8uktBezV9r6lgnn8U6z3HMhdZiUv7RRRAXPAyirrQK?=
 =?us-ascii?Q?LB63+Ulyjt6URoCNlLedXyI2N0GZHV/MlFXHuN8odmILB+ON5l9tLKoMsd1X?=
 =?us-ascii?Q?dZM052kridXycDCCsZil/xk8zN2DQIKPC3w7Q7YqSxE+aU0wTjlI1uO4G04i?=
 =?us-ascii?Q?pFWAuy4OZWQ+19gf6HSJSqAlasFROiwehX5vgHGxi2Ck0ZSvIMRwsok0Sf+l?=
 =?us-ascii?Q?oK9yS6x6Cj925qebPS8gkLYoiZiz6VkA6RjbgPjbdCaiP7V2CwPB9le9WJ5p?=
 =?us-ascii?Q?7o4brPKrakTGwytgV/eWGXWwjeHBd6pj6dC98fAuBi7DztL06qsEXS8hr8A2?=
 =?us-ascii?Q?XchpCxk5faYEkH53kc8itnchtogndIOrGfKeC90/4GPpXOcxgxo055Z/bap+?=
 =?us-ascii?Q?9GOo920R8F2qVPIY+m0nHZ+GIVmIl1DlJe3LSI1P5bD+CaQ9ciF1kvzoYg85?=
 =?us-ascii?Q?ku5KyMnmNS8s2IBhJ3GLYsOoA3wS9pCT5mXN0JZwhllM432G8uoZ0+QT8pQY?=
 =?us-ascii?Q?kNtGBtNlzCAvSbYoUuAHmM4mtk4k6wE/udxeFJWIEJKuxYBVEG6U0U4dBCSy?=
 =?us-ascii?Q?A9MQnXzgxjnQXOGk4Tjooa9oA7jMWo4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc3395d1-1773-44c4-87a5-08da17958742
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:21.4914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2GqcmFx8/GzyJPDj/U3z0z4wad2CTQ6DbdjHGwqxJ1H7ua2IzltHv+F+10IGoH06MqJYaj5GZOcd8U8oz/rBXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204060027
X-Proofpoint-GUID: HXDioyjyYooVKqucyxCAZnSivaxVOSol
X-Proofpoint-ORIG-GUID: HXDioyjyYooVKqucyxCAZnSivaxVOSol
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_SB_FEAT_INCOMPAT_NREXT64 incompat feature bit will be set on filesystems
which support large per-inode extent counters. This commit defines the new
incompat feature bit and the corresponding per-fs feature bit (along with
inline functions to work on it).

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 3 +++
 fs/xfs/xfs_mount.h         | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index b5e9256d6d32..64ff0c310696 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -372,6 +372,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
+#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
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
index f6dc19de8322..98ceccdbcf51 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -276,6 +276,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_INOBTCNT	(1ULL << 23)	/* inobt block counts */
 #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
+#define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
 
 /* Mount features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
@@ -338,6 +339,7 @@ __XFS_HAS_FEAT(realtime, REALTIME)
 __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
+__XFS_HAS_FEAT(large_extent_counts, NREXT64)
 
 /*
  * Mount features
-- 
2.30.2

