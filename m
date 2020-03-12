Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7CCBC1975A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2E5E206E2
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:46:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YDdEWP3J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731594AbgCLDq2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 23:46:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36862 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730913AbgCLDq1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 23:46:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3hBPY181336;
        Thu, 12 Mar 2020 03:46:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=eQNryDSdXe7VtitYPNCBpwqCJmPSUXmBjzsMsX7LXy8=;
 b=YDdEWP3JFP9OSz9KnlZQnGYUOZGh0V2jTPrNpYtbDyLh7+z0JfBENNO10v9BZIJ4d+WV
 2J0aYmalTKnOxqKC9xtY2d+siEdMN6REuswcnxRf5c9RS22ZisEqg78U7rhmCxXRpCOq
 GmWfxCZctm2KWbxNieSwWr5u0ztENlke6+oOjIExGOZTnb+dAduuywM9NVMq3hMygvjw
 38YSz9nRTHuRDFAEOGswbKWyZ1b8msAJmlfmUcHsM1GvZdb3tofexJatZVtWPbQdfdX4
 lgdiKEaqGeNLKRyqg6WYTlj/dQTvvY2EdJCd089lvR3r2VgTXtnQ+kK/DvDgjMN/sA8I lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ym31uq7au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:46:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3cEG2096651;
        Thu, 12 Mar 2020 03:46:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yp8qyawbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:46:24 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02C3kN5J022683;
        Thu, 12 Mar 2020 03:46:23 GMT
Received: from localhost (/10.159.134.61) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Wed, 11 Mar 2020 20:46:07 -0700
USER-AGENT: StGit/0.17.1-dirty
MIME-Version: 1.0
Message-ID: <158398476287.1308059.2210747176346883815.stgit@magnolia>
Date:   Wed, 11 Mar 2020 20:46:02 -0700 (PDT)
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: [PATCH 5/7] xfs: add support for inode btree staging cursors
References: <158398473036.1308059.18353233923283406961.stgit@magnolia>
In-Reply-To: <158398473036.1308059.18353233923283406961.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=3 bulkscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=3
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add support for btree staging cursors for the inode btrees.  This
is needed both for online repair and also to convert xfs_repair to use
btree bulk loading.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc_btree.c |   80 +++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_ialloc_btree.h |    6 +++
 2 files changed, 75 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index e0e8570af023..d7cf74a68578 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -400,32 +400,27 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
 };
 
 /*
- * Allocate a new inode btree cursor.
+ * Initialize a new inode btree cursor.
  */
-struct xfs_btree_cur *				/* new inode btree cursor */
-xfs_inobt_init_cursor(
+static struct xfs_btree_cur *
+xfs_inobt_init_common(
 	struct xfs_mount	*mp,		/* file system mount point */
 	struct xfs_trans	*tp,		/* transaction pointer */
-	struct xfs_buf		*agbp,		/* buffer for agi structure */
 	xfs_agnumber_t		agno,		/* allocation group number */
 	xfs_btnum_t		btnum)		/* ialloc or free ino btree */
 {
-	struct xfs_agi		*agi = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
 	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
-
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
 	if (btnum == XFS_BTNUM_INO) {
-		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
-		cur->bc_ops = &xfs_inobt_ops;
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
+		cur->bc_ops = &xfs_inobt_ops;
 	} else {
-		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
-		cur->bc_ops = &xfs_finobt_ops;
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_fibt_2);
+		cur->bc_ops = &xfs_finobt_ops;
 	}
 
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
@@ -433,12 +428,75 @@ xfs_inobt_init_cursor(
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
-	cur->bc_ag.agbp = agbp;
 	cur->bc_ag.agno = agno;
+	return cur;
+}
 
+/* Create an inode btree cursor. */
+struct xfs_btree_cur *
+xfs_inobt_init_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno,
+	xfs_btnum_t		btnum)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_agi		*agi = agbp->b_addr;
+
+	cur = xfs_inobt_init_common(mp, tp, agno, btnum);
+	if (btnum == XFS_BTNUM_INO)
+		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
+	else
+		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
+	cur->bc_ag.agbp = agbp;
 	return cur;
 }
 
+/* Create an inode btree cursor with a fake root for staging. */
+struct xfs_btree_cur *
+xfs_inobt_stage_cursor(
+	struct xfs_mount	*mp,
+	struct xbtree_afakeroot	*afake,
+	xfs_agnumber_t		agno,
+	xfs_btnum_t		btnum)
+{
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_inobt_init_common(mp, NULL, agno, btnum);
+	xfs_btree_stage_afakeroot(cur, afake, NULL);
+	return cur;
+}
+
+/*
+ * Install a new inobt btree root.  Caller is responsible for invalidating
+ * and freeing the old btree blocks.
+ */
+void
+xfs_inobt_commit_staged_btree(
+	struct xfs_btree_cur	*cur,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp)
+{
+	struct xfs_agi		*agi = agbp->b_addr;
+	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	if (cur->bc_btnum == XFS_BTNUM_INO) {
+		agi->agi_root = cpu_to_be32(afake->af_root);
+		agi->agi_level = cpu_to_be32(afake->af_levels);
+		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_ROOT | XFS_AGI_LEVEL);
+		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_inobt_ops);
+	} else {
+		agi->agi_free_root = cpu_to_be32(afake->af_root);
+		agi->agi_free_level = cpu_to_be32(afake->af_levels);
+		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREE_ROOT |
+					     XFS_AGI_FREE_LEVEL);
+		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_finobt_ops);
+	}
+}
+
 /*
  * Calculate number of records in an inobt btree block.
  */
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index 951305ecaae1..35bbd978c272 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -48,6 +48,9 @@ struct xfs_mount;
 extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t,
 		xfs_btnum_t);
+struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_mount *mp,
+		struct xbtree_afakeroot *afake, xfs_agnumber_t agno,
+		xfs_btnum_t btnum);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
 /* ir_holemask to inode allocation bitmap conversion */
@@ -68,4 +71,7 @@ int xfs_inobt_cur(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_agnumber_t agno, xfs_btnum_t btnum,
 		struct xfs_btree_cur **curpp, struct xfs_buf **agi_bpp);
 
+void xfs_inobt_commit_staged_btree(struct xfs_btree_cur *cur,
+		struct xfs_trans *tp, struct xfs_buf *agbp);
+
 #endif	/* __XFS_IALLOC_BTREE_H__ */

