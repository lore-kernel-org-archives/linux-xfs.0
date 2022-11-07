Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB342C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiKGJDj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiKGJDi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:38 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CC9120A5
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:37 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A75QkQ9023463
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=1ieI1iTrpNarEUnG+jSK38Wg14D8S1+qMAX5zDTLx7w=;
 b=qdWyukvA4b/JMpKDqmPjAc2dhqywGvmhKTccte9xmyrSDxlYKkIqMXcWq+XPIR1bouMG
 GU00byZDNrsvwUgceN5NEBghmF3wc1tQbjMWVrZIqScRGUo+jN7XnpN1FEJyhkenH1bO
 AZAT2yNzbT/VQj9Y4U7hT0l9uc6DQIirHZGOUCScFMXQfO2Ndx4PsgFF6en1RLKGoEV9
 ERqG1oLcfxz2BYeHF6b3FweNQi3Wwp0zJLCfBRMfJNg76NTdL4KaQIddCfGYf/0mAlUS
 7f20yLlK9DlTjJGrEaenHWl7uHyGdCl4r0apEE+P0TEpbsw29219iTKTMpKoQG3Kko3H rQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngrek5fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:36 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77JXo9025146
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqek6ua-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=odteA2I5aTOhLJDUvLUjcqwMLi+BgtY16JUEtHWy8RqGpkIXXlFBqN0AsKmVCyz4MhEQLa2cQ2umACvQgHp/02lC/Wh5gvq+tt82BD+cVcduwNMQF97qlwPdQ0P6S2knpfzu3Q/xccBmo3/6bsdvX+P3h8VrrJyyo1bzF/Ek3BL9VZPbApEVzvetBU5ggyHf3CctgaeM9elUhRJWP0NCcXAx4ZxJPg7xo98PoV4f5CDm/XUstlIJ2oktVGoSRItHQDPfHlkZ18llxQbn9IMrtkgs/CTFQdWFlme/5mBEeMNEDVNGUh8NhDzV/fweWTEVLhbU2wT614O4vVbHxcUqVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ieI1iTrpNarEUnG+jSK38Wg14D8S1+qMAX5zDTLx7w=;
 b=mNGIrJUqa+Rm9p/d9aKgrI7VtLlybv/6aOsbfHCQ6AjWPVnQ9abYEGViwgVPmjcQTHh17TFJq7kyXbCH18eXAu6Dr5fQuionyGWTm6rreF9/w7Vw+nTX8jfo2DY28PAAXZcnAGiqnh5WAuG0ZbXTh4UNoto2nu3fe0I1zu+6PHOwRP8RfZ4uk6dfJvGHaLts/vFOpPqFaIwObFPGeOn3aODSJ1VdrY8wGwU5RzmTMBVNDtGlxZP3QwbEn2Lw4pNgXyGjDjQsZpYyop/r/En6O9OIfDB53nuDn/unuNB5PayOmUZw2Ny9AjMi2G7/yGYSoY729QzrLVIX+uRvdOOPhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ieI1iTrpNarEUnG+jSK38Wg14D8S1+qMAX5zDTLx7w=;
 b=Q8DJr672xTPxosNkzCpXNynB1ChBh5hoztO4pv5ESk+7+7BOz/aiF0TAAGaiViC+PuwN4Cpj1ifBO/aB1tNFY1n9gVZVQVH3P2VEraLRhEr57FRoEgu/obR2yU/Z3B60IgsgkMNVYnF7r8hJ9BvIDf7UtWbPiZdLuszoZO8QZSI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MW4PR10MB6346.namprd10.prod.outlook.com (2603:10b6:303:1ec::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 09:03:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:03:26 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 21/26] xfs: Add the parent pointer support to the  superblock version 5.
Date:   Mon,  7 Nov 2022 02:01:51 -0700
Message-Id: <20221107090156.299319-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0152.namprd05.prod.outlook.com
 (2603:10b6:a03:339::7) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|MW4PR10MB6346:EE_
X-MS-Office365-Filtering-Correlation-Id: ea3ae1e1-aa1b-4561-6c61-08dac09eee47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eW8LCAMuCdbt1/oMHj66niwFVl85YNAB9Ed5vhQJD4bIfiMQVLNBJfKtud4uNIf9gw5vKqcOd1O2Giys6HclDQ70mXc304gfYuYQIKq+Utc133tZTGZqeprTpr4mDMIyL3xfnzFSbTJKme2Pi1uGmbFDTTdiePfsvwRRxIy3Rh7SMNOu4tlQwODmZjuA0xPlFifPwwsMAWxWkHs7dlyMBAHln9xv6fk6bG1o+wAAqiROZ41lysQGFaYPWaN0yaTkJvErymjti/TDvl6o3Sh8AwFaEU6da6Hn8/lQxCHlcXhU0ziJ2ySyhvQUYpIoPHjRKTOntiV0UBdZdq68UsOaC7og0bNN3xznISyY3A/tRDnxcmnGu8ha8PnHMLzL4XFTZb87OBf+NYwtJna7NUVvvp5pUnxReaMKCtoq/7SQCuUveRpuNA6pGBkPNsyBXPUtaDK2LBqsC7STbm9noO0S1SUDy2sNJSkYGgNQFqjAey/au2cg1ZH+RYKMiuWAg52/K/GsxyO9avBdgs/xcJ9whqqrGGxPNJDeRr0e8oan/li5J/dDOY5DWOQ5N0Mk92fR1WC4i8J2fMyZCwhud2mfbPdeXIwbHC1KgJrnrH4vI8M+GYHK89Gb6GN4IRAzakzto6o1FQz+mtmBy1Ck+GzBZu4w4XDL3a7x4brv9Bdd7WGgjjVoK0228nrEWMfpM1tYDnCT3ZU9+XzkzH9EDvHLPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199015)(38100700002)(6506007)(36756003)(478600001)(316002)(66946007)(66556008)(8676002)(41300700001)(6916009)(8936002)(1076003)(5660300002)(6486002)(2906002)(86362001)(66476007)(83380400001)(2616005)(6666004)(9686003)(6512007)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S/tYMiYQgdYHP5vJQHm9e2D7WaVeYju+C7cxe/7ObjKxVnk1+PetBgmj1Wxj?=
 =?us-ascii?Q?eMuk+pG3XiNPka6oeMwPln30Ch6sZMAKtrPuYAX3AvZrqTV7+Tj2Zi/IKzqa?=
 =?us-ascii?Q?jdZg3EvQ0ZucI5sk6iw2dV2wCbXqbYTf2lubCyu2CD7TIQ8iydrDBuABuGeO?=
 =?us-ascii?Q?U2t9YEjqIFTo7/UoGZRybmVwGDYr4PNw8qiL/Dkqu0ODLldKNYCVRVtptyP/?=
 =?us-ascii?Q?eje5AckwkPpfqesiNO14K8dCSN6/9CT+Dtd+4Xm/1Ch2UfadsKBhP5l/Zwrt?=
 =?us-ascii?Q?5vFRL1gFRnW8TCnAgG0+SF00TP2I6ZWRStaHNMJnkOgujU5lpAG8nJXxknf0?=
 =?us-ascii?Q?tYz04Haup0YLf6Nsav+hBCbKNZLH/ibWXNtl/AKNA+0YMSWdvhShMbbcBrOu?=
 =?us-ascii?Q?Stssxg8zXmFdo4uGAX75wn15acc1RwMJ7WVZOli/yGUPavJnaRRhsPmDaV6U?=
 =?us-ascii?Q?CMR7jHjTe1QKM3TYyejrtbJ6TYwyIxIB8OQOj8BRtqIhn5pPzESKllQ3EcMT?=
 =?us-ascii?Q?FMGsIevPIXeW9y0HbP5msTGR9+Sy7ZQ4MJz3FQxQeHTSfPVnQA/8ClZw5xbz?=
 =?us-ascii?Q?mB49Jzy/CQgfqVqQoGH0jO0rxM2/LqodqZX5N7LqQAw4xSpNsq5ZSzb9EEOW?=
 =?us-ascii?Q?Nu1yJ2gwr7SF0N2bEEzM1SoHzXsFVWJEV3JRxPlxvp2IKyeA+Zerf8Xh+yoL?=
 =?us-ascii?Q?T8lkRrIiZ3xd2PPxrEUjHy/nqOU2gTCzbE6TVYRLBZNZk1afXHue9lLBfWE+?=
 =?us-ascii?Q?30ro9lpEi7BkyPF8trbq+BWkyQeF7NRVI69TzZZ7loyxnMdBdUOx19QDljhf?=
 =?us-ascii?Q?aCcXdbMCc5tdLoPs2m+9whyC/umT988/R5NvNvuPdnAcke3oW0no0NdQ3QNR?=
 =?us-ascii?Q?VtUo8iXUU8n6EfxoiyS7xplYk4cgvfV1lgEgQbujNSRI8T8gjij8owI86Fbp?=
 =?us-ascii?Q?DF2r7ZPfAaQLwpJYIz6ox+0jaR3X9tWY8gbjvja7a9IE6BSFoJRzd6bA/l9R?=
 =?us-ascii?Q?yN+o2h+1cdY3gH+tdTQVZfp0JFOpmvxAnlF5Cs1LZFX7ju5tOHvICCEo0hyU?=
 =?us-ascii?Q?PLJyIUonypvFM52j6wIaDa5GF3xDeqU76a2eUmjLSsIZI/KZG9/JI3fRoC9N?=
 =?us-ascii?Q?cRUOtQRlt0W20hsfW1H0KIvizBF1tFRGVnf4XNZc85tWd6lDD0jxdia4o5Hf?=
 =?us-ascii?Q?PmkfYueSEpyaIcR3/uhqIAe7SXqXNAMbSQZFd3XzJRlnbh8Cn5KEprwRk/jU?=
 =?us-ascii?Q?fFmP139SZP3WTuvp137qM/FvyaG06wBHxQRyoEWQ9y3InlZ2ZzE2MoPKQyL0?=
 =?us-ascii?Q?GiWkjU4jsfAeuyU1kAHVxRGTVKMOJU9hpqr1hfN6x4ihndMIVT6SzaJCMAfX?=
 =?us-ascii?Q?nefv5GDp9MwlOATTiLQsmKKND3emQnlOIvbqrWhpmQGX9hkzWeA9gTLZi3nl?=
 =?us-ascii?Q?XXOJatGXm4X59BhYn717zUJGsq7RomN6us+i/pLK3Wd33rw56eF14USEXLWK?=
 =?us-ascii?Q?6JBmB2Rbvn6US68n/f5CKc4CtlxGA+xP7oNNpzsDvmemNwoLwjKu28hCC17E?=
 =?us-ascii?Q?pOwzyD394wf3mf77CSZ52eRKnXfe/t6j5f2bFAovejKpmaYfcIdoO4fISrZh?=
 =?us-ascii?Q?4Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea3ae1e1-aa1b-4561-6c61-08dac09eee47
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:03:26.2151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TEV3dysIQwwsXPl1iODOJSFDuIUbpX4otNgmR272gTBZVjS2Z11Aff/ZfYxA4q1kxAqsAI99tVOOXmVI+Cy2NUj8zQkFwgaToC6XW26C24M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6346
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070077
X-Proofpoint-ORIG-GUID: 2HsHLAg6tQKTtusaZH1xCpEcyP44wQc8
X-Proofpoint-GUID: 2HsHLAg6tQKTtusaZH1xCpEcyP44wQc8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 4 +++-
 fs/xfs/libxfs/xfs_fs.h     | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 4 ++++
 fs/xfs/xfs_super.c         | 4 ++++
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 371dc07233e0..f413819b2a8a 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -373,13 +373,15 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
+#define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 6)	/* parent pointers */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
-		 XFS_SB_FEAT_INCOMPAT_NREXT64)
+		 XFS_SB_FEAT_INCOMPAT_NREXT64| \
+		 XFS_SB_FEAT_INCOMPAT_PARENT)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 1cfd5bc6520a..b0b4d7a3aa15 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -237,6 +237,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
+#define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 24) /* parent pointers 	    */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a20cade590e9..75e893e93629 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -173,6 +173,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NEEDSREPAIR;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
 		features |= XFS_FEAT_NREXT64;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_PARENT)
+		features |= XFS_FEAT_PARENT;
 
 	return features;
 }
@@ -1187,6 +1189,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
 	if (xfs_has_inobtcounts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
+	if (xfs_has_parent(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
 	if (xfs_has_sector(mp)) {
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
 		geo->logsectsize = sbp->sb_logsectsize;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ee4b429a2f2c..664d01bf29ec 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1663,6 +1663,10 @@ xfs_fs_fill_super(
 		xfs_warn(mp,
 	"EXPERIMENTAL Large extent counts feature in use. Use at your own risk!");
 
+	if (xfs_has_parent(mp))
+		xfs_alert(mp,
+	"EXPERIMENTAL parent pointer feature enabled. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
-- 
2.25.1

