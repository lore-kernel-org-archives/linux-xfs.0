Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C112C35641
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 03:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E40D620828
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 03:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbgBXD6S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 22:58:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57062 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727207AbgBXD6S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 22:58:18 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01O3si3P118115;
        Sun, 23 Feb 2020 22:58:15 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yaygnaauy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 22:58:15 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01O3tXtZ119777;
        Sun, 23 Feb 2020 22:58:15 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yaygnaauh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 22:58:15 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01O3tLD4004806;
        Mon, 24 Feb 2020 03:58:13 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 2yaux60889-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 03:58:13 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01O3wCie45089180
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 03:58:13 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7CB66A04D;
        Mon, 24 Feb 2020 03:58:12 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C3006A047;
        Mon, 24 Feb 2020 03:58:10 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.91.136])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 03:58:09 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, bfoster@redhat.com,
        amir73il@gmail.com
Subject: [PATCH V4 RESEND 4/7] xfs: Introduce struct xfs_attr_set_resv
Date:   Mon, 24 Feb 2020 09:30:41 +0530
Message-Id: <20200224040044.30923-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200224040044.30923-1-chandanrlinux@gmail.com>
References: <20200224040044.30923-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-23_07:2020-02-21,2020-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=1
 bulkscore=0 malwarescore=0 adultscore=0 priorityscore=1501 spamscore=0
 phishscore=0 clxscore=1034 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240032
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
 fs/xfs/libxfs/xfs_attr.c | 50 ++++++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_attr.h | 13 +++++++++++
 2 files changed, 40 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a708b142f69b6..921acac71e5d9 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
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
@@ -295,14 +295,17 @@ xfs_attr_remove_args(
  */
 int
 xfs_attr_set(
-	struct xfs_da_args	*args)
+	struct xfs_da_args		*args)
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
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 861c81f9bb918..dc08bdfbc9615 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
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

