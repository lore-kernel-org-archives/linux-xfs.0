Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D72C38A2D
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJUWaF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiJUW37 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:29:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7697111879F
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:29:54 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDrSR001722
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=MkNysDklpupZtYyw8lG3//I9iChQdYOxNGGcNmyUXKk=;
 b=PQF5HYCwypUSljPSluq1YJ904v7OvwW16KMa5sCtz1AI9Wqhf+DKZL1vWEGXvyq7q0L9
 pHlWYPZ/rwxK9qD8LsZgqjlnB+r5YHI1la/vYfbeCzzrNpwOH3EyzDysMlQWBG+gNK1l
 rhdS3y2RJlvrep3chaMoTltijQ27Z0j2LNgu3l4ihwtWQLtuMxxQUynmKbttnSIrLSIt
 Uza+dSL8/cwSVPsPO0gmLUvIJzgEk3WRiFqUjaZP6h4ffzcicdSlOKPihu8ynggTxvFu
 hPW3PG6RLpo/YjLS4GuILJaNTzqFSNJwJBmap09b5FxD1YsyLP1p8k3YTrI/xnABdijd iw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k9awwdjnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LL7rdn027463
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htm00dm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eB+mf/6CfWosJ/LT+YAlnkHEISN89RbUNiCuZP3JhMf5xUL36gzR4+ItvZapB9rksW1Yzz5EYW0GAMdbOUdqL+78jarHPse5CrPhLuE3A0+N/rDJKwF6i2VgZhoowxwA8ihgFiW/0eSL9ZUd9YS5XJtbBPnz1b8zDZt287GBy9ql31/+ujohkgQJ70SE2GrgRCy+49sdK6f4r9scHKkb1nAhan1y6rFddXfcLpIsPeC9aNepYOtymGOaiX8LxionBtooh2J9QY2gYWuI2rUQ0SRu49TM9SwDtt3cGWmkRVZbTJV0Wc+N+fyIuZFeuSc0q2vzV8A+rvLgvfBJuyNlZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MkNysDklpupZtYyw8lG3//I9iChQdYOxNGGcNmyUXKk=;
 b=chU0E3JTeK4k4Pd/UCFTpcNs4CzSFKO6q/D1CloB+qh8oy9PCz1Si9idaN34GUe/qQMrdrdOG7PiwS/fMtpb8SCiq7IqnGz+CHNqbiwptcQeKqoZR4barDo8jtJfgDAeWpq1aKKnv8L8YhG55+m0qCFB6DvLES12rpetSIXV17l6Bwpd9HNc3SKXHE3Q6SGjG7ArOEcGHj/CzsHvV8iXx3oq3w4BLeAXtwiXld8GYtLB0JZl0YGhSlSzhah+hW3tNOvnIfjXB7sLiTd31OVJb+oUK4H7y1R9TUs1PLvumlDFIPwFKFPo9rtSr+2sQBjYzOasN7Yp/j5ty+t41ELKUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MkNysDklpupZtYyw8lG3//I9iChQdYOxNGGcNmyUXKk=;
 b=XNS+Y8//KjWZB4tZxbsYCHf8IM+wc5Upkauwg/WU1997pMQ7bCLV05Nw/VQMHOjVGB/xMWk5ygl/gqOuXDTgdf+/051cIkpVgn0pQ8cpbwkZ2ut0FHMDeJ9Od+ij8Hx86+2UZT8uUAFtJax8JtqKwLiTThHhz/bclIxqEpG7isA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Fri, 21 Oct
 2022 22:29:51 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:29:51 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 09/27] xfs: get directory offset when replacing a directory name
Date:   Fri, 21 Oct 2022 15:29:18 -0700
Message-Id: <20221021222936.934426-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 18a2fa18-dee1-4ca7-917d-08dab3b3c4bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eTMrJbeXxnJgR4ySvDT5zF2d7ueScyRNoPAjaBauF9QuFYOcv87ZwAJbHrzZbxx3uDOc5A+5HY1+Vs0aPu6Wtv8P9mRwseMXqEpTzXvYDAzXFNgNzc05BSvVKGcJf8iVzf8+a4B0rswZ4755J3CTPj9e02s3BHM5pzlQ1Uze9y7Ae/njViU6biRL6ul3pXYXP0vqwC4MZfDUVPNVPcowHmNDzEKfT15/Gp8ViWoGqfrOKE/uwLPzl5KfUUjA0MUBlUtneIVPuEOFDeM0jZZNhMtNWR9YetMm4z4Pdtay2C9ygsZV54yZVH0uv++QznaxqACAGO2xsCWvDtNu6LhK78cMvz4hwOto6R6FdneJXp54zfEiJDv0LeHYQSmMJL60KiMf4GeoQovqsYw0BRXfL9ref6wuI9s9Mt/CQ3K9OVzO9NVWrzQq9Hbbm3BIVt7SxjSI0Ul/h+O6CpMWuGdM4BK9fH/VPU8ju8Bwb2acUPGcJQstWGhEE+Pp6x9UXCgcouoEQzQF9YmLpXYBbbXDfZbkXr0JTgch76WEinh42oD7n3xOOjO5hxqT6kXId2FE/Jx6Clj69D0Ru5wJA+KmRkpm5NhrSvsKJELpSBCRiD4iXYM/sMFx20eLKQFFOQ/0KKjmv/sw+jjyoJELbqU9q0yadZjSU6wWSP5BQZPYbFL2f5QvSIgPZXWWPgB0WQ1v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199015)(36756003)(38100700002)(5660300002)(86362001)(6666004)(8936002)(83380400001)(6916009)(2616005)(6512007)(316002)(8676002)(6506007)(66946007)(478600001)(6486002)(66556008)(2906002)(1076003)(9686003)(41300700001)(66476007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PK0fpGfumyHmAHHf+q8FyeGTYUjmNlFqEOrUzljzC1qC3UDwkb5COg9VyQ0S?=
 =?us-ascii?Q?UloDGyTLK3XMTpG++Pav45Nfzjja9eYOariwjM8f+bPztp2SRjQv5tkzRoq8?=
 =?us-ascii?Q?o5mRuzc0QdcMzshxEdnveFEkfHoifTkbkBuWvcxpoAa3D4idz+lunhJ8VNRL?=
 =?us-ascii?Q?SX7qjNYLPbZEVtpoBaSgw1pORHAQKJ/LJ0L95PeuLUkfcE88TEtk0iYIdn9X?=
 =?us-ascii?Q?iTJY5lAY1SrRAaRSOrhnZNCHSDj6K6VumuXBOL71WngtGl4j/cZeMxYEc7OV?=
 =?us-ascii?Q?pKe1wIlDvSaskSYHlvkMDd2l6KWY89VyHOYmo/amgHIUFHlZtogk5+rrwU7x?=
 =?us-ascii?Q?c1bahDO6YBLink6IZIQyHHcyimn3xfZ4ST1eJVR19Imd+UWwI1kOUbvp+ExN?=
 =?us-ascii?Q?3TyYAjKeWR9Qa7XCCEh+TzAhNKdm6hxUy3Sy8h+TL0SqaZXtzKBTCZDfl7AR?=
 =?us-ascii?Q?MMYoKBkI9Z/XrZUQKHyTtwSjRURstQErK49nHP7MgWm8oCIjJ1SXla05/B/H?=
 =?us-ascii?Q?p+NHeaMpdxsevbkdFbBQQmtDLjnKvRojHDjNLmLNmP0cG2D6WyBBCv8b6pSA?=
 =?us-ascii?Q?4ONcpJbytXjoN+1BIdin9GQR0belLQRDnTQCOliq1XHozbu16S+L/c4sE5qP?=
 =?us-ascii?Q?nuTR/jYOHX+Ki6TUvzTTrDiTWVl3bTW99b6ag9O6CiDFvX+2JFe6593pirVz?=
 =?us-ascii?Q?capp4sdcbOyfX56SRFqyMLd5tPr65B0N1d57yRldFLy5aNsvrAkNNwKnpXbX?=
 =?us-ascii?Q?Pg0WWFeginkeTAHm8wcrffdISRC96anMvcfSVWdds8iCYPIb5cY1773THKPh?=
 =?us-ascii?Q?jctRO7VcoaBvz15vBFDk+9X9vNjqOkJpWoAQMTz6bAQgaMmK0YcD0TVc92eG?=
 =?us-ascii?Q?ciG93KpiBcMsyzlhEY7QRbkaoc10TKJoYKfp4fE01/wO1/MA4esD0zfp3+RH?=
 =?us-ascii?Q?goDpXXWWedkwXVMRAeP2hUloNIkBobFzWd4Bml3bMAeF832Ej066iRZwvZ7a?=
 =?us-ascii?Q?hrn2DSnRgPpqSZeKLOUIuESrQCePrP30PWLou45T6zbUb4XlOFZvW4D5aR80?=
 =?us-ascii?Q?U6iFsgVcOfI7r3OSjuy71IamgR98N6Yv/QRtEgV3q2szeJsgWlb35ddhmD25?=
 =?us-ascii?Q?tPYhqKdKG2G/JqmqbR/FV35stha7ueC9Y4QgfXssvtAGXy5WzpZ8kg+zC5P9?=
 =?us-ascii?Q?ERIHW+geWSfK33yzRQ3reXn/wGLEibcWpOy/GC744n3yln+YdLRwMgJfvFeu?=
 =?us-ascii?Q?zVw6xLUC5H31xlZV2MuJW+91vXGSRQ/SxpzY5/NAIBVL/er2zj0OB6T6QNJC?=
 =?us-ascii?Q?VUAAaD/TUPe8j/8bmvYNz16ap7xYrbhhX+Td43eSjkv0hucGgf2jjvN3bZ2q?=
 =?us-ascii?Q?UTro94jpF8U5gUC9kAy/L2xaEXiNf506cTY3C9JgQwJmS/ll3QSlLwPBmc//?=
 =?us-ascii?Q?53tUC/tokdJR5fP8SPjA/JVPQApNdcAfPAo2z1buLs8lGd1pKMvh87BVbt4v?=
 =?us-ascii?Q?2aJSZrgAEFDfe6DFpeG52HxKUixsOUqgkBJNvXRJTnXYMKcmBrbZYpayc7RG?=
 =?us-ascii?Q?nrVQyLggg59aFj61PkQVP/OV/w5PoXKBTSrk56SSSf7q2ObWkjqFl3/2btBV?=
 =?us-ascii?Q?OA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18a2fa18-dee1-4ca7-917d-08dab3b3c4bb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:29:50.9378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EGJqw7H8c62feAnoBycCaGobJXvOCWpp/lfl8gz9CYl3tXpcGWxcYqUZZHSCdMp5xsUv+3QpqQ6wuXTjnxmbwHlr/Uz+Rje2iGPTzd52f/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=980 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210131
X-Proofpoint-GUID: 5MWzo6GMFNYbly_AFYXBL-8WplwRePQQ
X-Proofpoint-ORIG-GUID: 5MWzo6GMFNYbly_AFYXBL-8WplwRePQQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when replacing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_rename.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c       |  8 ++++++--
 fs/xfs/libxfs/xfs_dir2.h       |  2 +-
 fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_node.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_sf.c    |  2 ++
 fs/xfs/xfs_inode.c             | 16 ++++++++--------
 7 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 891c1f701f53..c1a9394d7478 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -482,7 +482,7 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
-	if (offset)
+	if (!rval && offset)
 		*offset = args->offset;
 
 	kmem_free(args);
@@ -498,7 +498,8 @@ xfs_dir_replace(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t		inum,		/* new inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -546,6 +547,9 @@ xfs_dir_replace(
 	else
 		rval = xfs_dir2_node_replace(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 0c2d7c0af78f..ff59f009d1fd 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -50,7 +50,7 @@ extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index d36f3f1491da..0f3a03e87278 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -885,9 +885,9 @@ xfs_dir2_block_replace(
 	/*
 	 * Point to the data entry we need to change.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
 	/*
 	 * Change the inode number to the new value.
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index b4a066259d97..fe75ffadace9 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1523,6 +1523,7 @@ xfs_dir2_leaf_replace(
 	/*
 	 * Point to the data entry.
 	 */
+	args->offset = be32_to_cpu(lep->address);
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->b_addr +
 	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 39cbdeafa0f6..53cd0d5d94f7 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -2242,6 +2242,7 @@ xfs_dir2_node_replace(
 		hdr = state->extrablk.bp->b_addr;
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+		args->offset = be32_to_cpu(leafhdr.ents[blk->index].address);
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(args->geo,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index b49578a547b3..032c65804610 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1107,6 +1107,8 @@ xfs_dir2_sf_replace(
 				xfs_dir2_sf_put_ino(mp, sfp, sfep,
 						args->inumber);
 				xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+				args->offset = xfs_dir2_byte_to_dataptr(
+						  xfs_dir2_sf_get_offset(sfep));
 				break;
 			}
 		}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a0d5761e1fee..71d60885000e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2487,7 +2487,7 @@ xfs_remove(
 		 */
 		if (dp->i_ino != tp->t_mountp->m_sb.sb_rootino) {
 			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
-					tp->t_mountp->m_sb.sb_rootino, 0);
+					tp->t_mountp->m_sb.sb_rootino, 0, NULL);
 			if (error)
 				return error;
 		}
@@ -2642,12 +2642,12 @@ xfs_cross_rename(
 	int		dp2_flags = 0;
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
@@ -2661,7 +2661,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
 			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, spaceres);
+						dp1->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -2685,7 +2685,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
 			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, spaceres);
+						dp2->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -3019,7 +3019,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres);
+					src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3053,7 +3053,7 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres);
+					target_dp->i_ino, spaceres, NULL);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_trans_cancel;
@@ -3092,7 +3092,7 @@ xfs_rename(
 	 */
 	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres);
+					spaceres, NULL);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
 					   spaceres, NULL);
-- 
2.25.1

