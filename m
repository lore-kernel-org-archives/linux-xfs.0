Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 075D6C35669
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 03:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9B8420836
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 03:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgBXD7X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 22:59:23 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727227AbgBXD7X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 22:59:23 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01O3xK6r004916;
        Sun, 23 Feb 2020 22:59:20 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb1pfyjk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 22:59:20 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01O3xJSj004822;
        Sun, 23 Feb 2020 22:59:19 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb1pfyjgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 22:59:19 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01O3tNhE000354;
        Mon, 24 Feb 2020 03:59:04 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01dal.us.ibm.com with ESMTP id 2yaux6cc1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 03:59:04 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01O3x3Z933489352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 03:59:03 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 402126E050;
        Mon, 24 Feb 2020 03:59:03 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 793A96E04C;
        Mon, 24 Feb 2020 03:59:00 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.91.136])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 03:59:00 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, bfoster@redhat.com,
        amir73il@gmail.com
Subject: [PATCH V4 RESEND 4/7] xfsprogs: Introduce struct xfs_attr_set_resv
Date:   Mon, 24 Feb 2020 09:31:33 +0530
Message-Id: <20200224040136.31078-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200224040136.31078-1-chandanrlinux@gmail.com>
References: <20200224040136.31078-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-23_07:2020-02-21,2020-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 clxscore=1034 suspectscore=1 lowpriorityscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 phishscore=0 impostorscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240033
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The intermediate numbers calculated by xfs_attr_calc_size() will be needed by
a future commit to correctly calculate log reservation for xattr set
operation. Towards this goal, this commit introduces 'struct
xfs_attr_set_resv' to collect,
1. Number of dabtree blocks.
2. Number of remote blocks.
3. Number of Bmbt blocks.
4. Total number of blocks we need to reserve.

This will be returned as an out argument by xfs_attr_calc_size().

Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c | 48 +++++++++++++++++++++++++----------------------
 libxfs/xfs_attr.h | 13 +++++++++++++
 2 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 967aac1d..23fcb110 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -136,16 +136,14 @@ xfs_attr_get(
 /*
  * Calculate how many blocks we need for the new attribute,
  */
-STATIC int
+STATIC void
 xfs_attr_calc_size(
-	struct xfs_da_args	*args,
-	int			*local)
+	struct xfs_da_args		*args,
+	struct xfs_attr_set_resv	*resv,
+	int				*local)
 {
-	struct xfs_mount	*mp = args->dp->i_mount;
-	unsigned int		total_dablks;
-	unsigned int		bmbt_blks;
-	unsigned int		rmt_blks;
-	int			size;
+	struct xfs_mount		*mp = args->dp->i_mount;
+	int				size;
 
 	/*
 	 * Determine space new attribute will use, and if it would be
@@ -153,25 +151,27 @@ xfs_attr_calc_size(
 	 */
 	size = xfs_attr_leaf_newentsize(args->geo, args->namelen,
 			args->valuelen, local);
-	total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
+	resv->total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
 	if (*local) {
 		if (size > (args->geo->blksize / 2)) {
 			/* Double split possible */
-			total_dablks *= 2;
+			resv->total_dablks *= 2;
 		}
-		rmt_blks = 0;
+		resv->rmt_blks = 0;
 	} else {
 		/*
 		 * Out of line attribute, cannot double split, but
 		 * make room for the attribute value itself.
 		 */
-		rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
+		resv->rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
 	}
 
-	bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp, total_dablks + rmt_blks,
-			XFS_ATTR_FORK);
+	resv->bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp,
+				resv->total_dablks + resv->rmt_blks,
+				XFS_ATTR_FORK);
 
-	return total_dablks + rmt_blks + bmbt_blks;
+	resv->alloc_blks = resv->total_dablks + resv->rmt_blks +
+		resv->bmbt_blks;
 }
 
 STATIC int
@@ -297,12 +297,15 @@ int
 xfs_attr_set(
 	struct xfs_da_args	*args)
 {
-	struct xfs_inode	*dp = args->dp;
-	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_trans_res	tres;
-	bool			rsvd = (args->attr_namespace & XFS_ATTR_ROOT);
-	int			error, local;
-	unsigned int		total;
+	struct xfs_inode		*dp = args->dp;
+	struct xfs_mount		*mp = dp->i_mount;
+	struct xfs_attr_set_resv	resv;
+	struct xfs_trans_res		tres;
+	bool				rsvd;
+	int				error, local;
+	unsigned int			total;
+
+	rsvd = (args->attr_namespace & XFS_ATTR_ROOT);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
@@ -326,7 +329,8 @@ xfs_attr_set(
 		XFS_STATS_INC(mp, xs_attr_set);
 
 		args->op_flags |= XFS_DA_OP_ADDNAME;
-		args->total = xfs_attr_calc_size(args, &local);
+		xfs_attr_calc_size(args, &resv, &local);
+		args->total = resv.alloc_blks;
 
 		/*
 		 * If the inode doesn't have an attribute fork, add one.
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 861c81f9..dc08bdfb 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -73,6 +73,19 @@ struct xfs_attr_list_context {
 	int			index;		/* index into output buffer */
 };
 
+struct xfs_attr_set_resv {
+	/* Number of unlogged blocks needed to store the remote attr value. */
+	unsigned int		rmt_blks;
+
+	/* Number of filesystem blocks to allocate for the da btree. */
+	unsigned int		total_dablks;
+
+	/* Blocks we might need to create all the new attr fork mappings. */
+	unsigned int		bmbt_blks;
+
+	/* Total number of blocks we might have to allocate. */
+	unsigned int		alloc_blks;
+};
 
 /*========================================================================
  * Function prototypes for the kernel.
-- 
2.19.1

