Return-Path: <SRS0=4Z0m=Y3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A18CA9EB0
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E05AA2190F
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:25:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xu+jFeN+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbfKCWZP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Nov 2019 17:25:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44398 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727503AbfKCWZP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Nov 2019 17:25:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MODWp061235
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:25:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Jqfkyx3N1SBWixGWlKQqc5BgVAhIJbEASLkuzy63fpk=;
 b=Xu+jFeN+ReGdJAkdpuKch9qmr9GecfKXXKbX/ymN9z0+tQBSOViYFWZl/t/mzdTZ786F
 1ilP9q40nc1mwv7i7Z6lAvqTpFlw/0nj6HJYNcnHAZ46NXjUIejbhquzaox8gEzDsD4S
 BqE2MfB4NHbJq9gLOtp+yiHc3/qXuOcmB+1JCWUEaUKQPkOR49bfiB7S6hp3m0OIeG0l
 WZ1dFxsDu2uoD9A2/6Gy5rp634ZrJLN2qJzeszb5qp4RC5wmNlq79YtiURSMgydOhCU0
 gkQ775EQsy7nOuRh6iM1nuERIYAlAER/MMDXIqBrhd+Nxvvg5HLmhC9qpCYt+wGwx2OB gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w12eqv05v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:25:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MNKHn072701
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:25:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2w1k8tmtkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:25:11 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA3MPBwO007488
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:25:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 03 Nov 2019 14:25:10 -0800
Subject: [PATCH 04/10] xfs: report btree block corruption errors to the
 health system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 03 Nov 2019 14:25:09 -0800
Message-ID: <157281990960.4152102.11682866870966346595.stgit@magnolia>
In-Reply-To: <157281988489.4152102.1632857939932700344.stgit@magnolia>
References: <157281988489.4152102.1632857939932700344.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911030234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911030234
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Whenever we encounter corrupt btree blocks, we should report that to the
health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c    |    1 +
 fs/xfs/libxfs/xfs_bmap.c     |    7 +++++++
 fs/xfs/libxfs/xfs_btree.c    |   13 +++++++++++++
 fs/xfs/libxfs/xfs_health.h   |    2 ++
 fs/xfs/libxfs/xfs_ialloc.c   |    1 +
 fs/xfs/libxfs/xfs_refcount.c |    3 +++
 fs/xfs/libxfs/xfs_rmap.c     |   14 +++++++++++---
 fs/xfs/libxfs/xfs_rmap.h     |    2 +-
 fs/xfs/scrub/rmap.c          |    2 +-
 fs/xfs/xfs_health.c          |   39 +++++++++++++++++++++++++++++++++++++++
 10 files changed, 79 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 72cfe243d58d..742ad359da6b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -261,6 +261,7 @@ xfs_alloc_get_rec(
 		cur->bc_btnum == XFS_BTNUM_BNO ? "Block" : "Size", agno);
 	xfs_warn(mp,
 		"start block 0x%x block count 0x%x", *bno, *len);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 13523be72b8a..f3a6598d364a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -369,6 +369,8 @@ xfs_bmap_check_leaf_extents(
 			error = xfs_btree_read_bufl(mp, NULL, bno, &bp,
 						XFS_BMAP_BTREE_REF,
 						&xfs_bmbt_buf_ops);
+			if (xfs_metadata_is_sick(error))
+				xfs_btree_mark_sick(cur);
 			if (error)
 				goto error_norelse;
 		}
@@ -455,6 +457,8 @@ xfs_bmap_check_leaf_extents(
 			error = xfs_btree_read_bufl(mp, NULL, bno, &bp,
 						XFS_BMAP_BTREE_REF,
 						&xfs_bmbt_buf_ops);
+			if (xfs_metadata_is_sick(error))
+				xfs_btree_mark_sick(cur);
 			if (error)
 				goto error_norelse;
 		}
@@ -619,6 +623,8 @@ xfs_bmap_btree_to_extents(
 #endif
 	error = xfs_btree_read_bufl(mp, tp, cbno, &cbp, XFS_BMAP_BTREE_REF,
 				&xfs_bmbt_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_btree_mark_sick(cur);
 	if (error)
 		return error;
 	cblock = XFS_BUF_TO_BLOCK(cbp);
@@ -5993,6 +5999,7 @@ xfs_bmap_insert_extents(
 
 	if (XFS_CORRUPT_ON(mp,
 	    stop_fsb >= got.br_startoff + got.br_blockcount)) {
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto del_cursor;
 	}
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 94404d8555f0..fee1dad5eab9 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -20,6 +20,7 @@
 #include "xfs_trace.h"
 #include "xfs_alloc.h"
 #include "xfs_log.h"
+#include "xfs_health.h"
 
 /*
  * Cursor allocation zone.
@@ -109,6 +110,7 @@ xfs_btree_check_lblock(
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_LBLOCK)) {
 		if (bp)
 			trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
 	}
 	return 0;
@@ -172,6 +174,7 @@ xfs_btree_check_sblock(
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_SBLOCK)) {
 		if (bp)
 			trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
 	}
 	return 0;
@@ -247,6 +250,7 @@ xfs_btree_check_ptr(
 				level, index);
 	}
 
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
@@ -426,6 +430,8 @@ xfs_btree_dup_cursor(
 						   XFS_BUF_ADDR(bp), mp->m_bsize,
 						   0, &bp,
 						   cur->bc_ops->buf_ops);
+			if (xfs_metadata_is_sick(error))
+				xfs_btree_mark_sick(new);
 			if (error) {
 				xfs_btree_del_cursor(new, error);
 				*ncur = NULL;
@@ -1325,6 +1331,8 @@ xfs_btree_read_buf_block(
 	error = xfs_trans_read_buf(mp, cur->bc_tp, mp->m_ddev_targp, d,
 				   mp->m_bsize, flags, bpp,
 				   cur->bc_ops->buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_btree_mark_sick(cur);
 	if (error)
 		return error;
 
@@ -1635,6 +1643,7 @@ xfs_btree_increment(
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
 			goto out0;
 		ASSERT(0);
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1728,6 +1737,7 @@ xfs_btree_decrement(
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
 			goto out0;
 		ASSERT(0);
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1820,6 +1830,7 @@ xfs_btree_lookup_get_block(
 	*blkp = NULL;
 	xfs_buf_corruption_error(bp);
 	xfs_trans_brelse(cur->bc_tp, bp);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
@@ -1867,6 +1878,7 @@ xfs_btree_lookup(
 
 	/* No such thing as a zero-level tree. */
 	if (XFS_CORRUPT_ON(cur->bc_mp, cur->bc_nlevels == 0)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
 	}
 
@@ -1911,6 +1923,7 @@ xfs_btree_lookup(
 							XFS_ERRLEVEL_LOW,
 							cur->bc_mp, block,
 							sizeof(*block));
+					xfs_btree_mark_sick(cur);
 					return -EFSCORRUPTED;
 				}
 
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 25b61180b562..2049419e9555 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -37,6 +37,7 @@ struct xfs_mount;
 struct xfs_perag;
 struct xfs_inode;
 struct xfs_fsop_geom;
+struct xfs_btree_cur;
 
 /* Observable health issues for metadata spanning the entire filesystem. */
 #define XFS_SICK_FS_COUNTERS	(1 << 0)  /* summary counters */
@@ -139,6 +140,7 @@ void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
 
 void xfs_health_unmount(struct xfs_mount *mp);
 void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork);
+void xfs_btree_mark_sick(struct xfs_btree_cur *cur);
 
 /* Now some helpers. */
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 57da33556e9f..20d539923b2f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -143,6 +143,7 @@ xfs_inobt_get_rec(
 "start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
 		irec->ir_startino, irec->ir_count, irec->ir_freecount,
 		irec->ir_free, irec->ir_holemask);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 26ab2c629c1f..75c4f45e1221 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -22,6 +22,7 @@
 #include "xfs_bit.h"
 #include "xfs_refcount.h"
 #include "xfs_rmap.h"
+#include "xfs_health.h"
 
 /* Allowable refcount adjustment amounts. */
 enum xfs_refc_adjust_op {
@@ -153,6 +154,7 @@ xfs_refcount_get_rec(
 	xfs_warn(mp,
 		"Start block 0x%x, block count 0x%x, references 0x%x",
 		irec->rc_startblock, irec->rc_blockcount, irec->rc_refcount);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
@@ -1672,6 +1674,7 @@ xfs_refcount_recover_extent(
 
 	if (XFS_CORRUPT_ON(cur->bc_mp,
 	    be32_to_cpu(rec->refc.rc_refcount) != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 03ce3d6f4c87..ac579cdcb885 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -21,6 +21,7 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_inode.h"
+#include "xfs_health.h"
 
 /*
  * Lookup the first record less than or equal to [bno, len, owner, offset]
@@ -177,14 +178,20 @@ xfs_rmap_delete(
 /* Convert an internal btree record to an rmap record. */
 int
 xfs_rmap_btrec_to_irec(
+	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec,
 	struct xfs_rmap_irec	*irec)
 {
+	int			error;
+
 	irec->rm_startblock = be32_to_cpu(rec->rmap.rm_startblock);
 	irec->rm_blockcount = be32_to_cpu(rec->rmap.rm_blockcount);
 	irec->rm_owner = be64_to_cpu(rec->rmap.rm_owner);
-	return xfs_rmap_irec_offset_unpack(be64_to_cpu(rec->rmap.rm_offset),
+	error = xfs_rmap_irec_offset_unpack(be64_to_cpu(rec->rmap.rm_offset),
 			irec);
+	if (xfs_metadata_is_sick(error))
+		xfs_btree_mark_sick(cur);
+	return error;
 }
 
 /*
@@ -205,7 +212,7 @@ xfs_rmap_get_rec(
 	if (error || !*stat)
 		return error;
 
-	if (xfs_rmap_btrec_to_irec(rec, irec))
+	if (xfs_rmap_btrec_to_irec(cur, rec, irec))
 		goto out_bad_rec;
 
 	if (irec->rm_blockcount == 0)
@@ -241,6 +248,7 @@ xfs_rmap_get_rec(
 		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
 		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
 		irec->rm_blockcount);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
@@ -2278,7 +2286,7 @@ xfs_rmap_query_range_helper(
 	struct xfs_rmap_irec			irec;
 	int					error;
 
-	error = xfs_rmap_btrec_to_irec(rec, &irec);
+	error = xfs_rmap_btrec_to_irec(cur, rec, &irec);
 	if (error)
 		return error;
 	return query->fn(cur, &irec, query->priv);
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index abe633403fd1..e756989d0da5 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -190,7 +190,7 @@ int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 int xfs_rmap_compare(const struct xfs_rmap_irec *a,
 		const struct xfs_rmap_irec *b);
 union xfs_btree_rec;
-int xfs_rmap_btrec_to_irec(union xfs_btree_rec *rec,
+int xfs_rmap_btrec_to_irec(struct xfs_btree_cur *cur, union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
 int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, bool *exists);
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 8d4cefd761c1..eb92ccb67a98 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -99,7 +99,7 @@ xchk_rmapbt_rec(
 	bool			is_attr;
 	int			error;
 
-	error = xfs_rmap_btrec_to_irec(rec, &irec);
+	error = xfs_rmap_btrec_to_irec(bs->cur, rec, &irec);
 	if (!xchk_btree_process_error(bs->sc, bs->cur, 0, &error))
 		goto out;
 
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 5e5de5338476..1f09027c55ad 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -14,6 +14,7 @@
 #include "xfs_inode.h"
 #include "xfs_trace.h"
 #include "xfs_health.h"
+#include "xfs_btree.h"
 
 /*
  * Warn about metadata corruption that we detected but haven't fixed, and
@@ -478,3 +479,41 @@ xfs_bmap_mark_sick(
 
 	xfs_inode_mark_sick(ip, mask);
 }
+
+/* Record observations of btree corruption with the health tracking system. */
+void
+xfs_btree_mark_sick(
+	struct xfs_btree_cur		*cur)
+{
+	unsigned int			mask;
+
+	switch (cur->bc_btnum) {
+	case XFS_BTNUM_BMAP:
+		xfs_bmap_mark_sick(cur->bc_private.b.ip,
+				   cur->bc_private.b.whichfork);
+		return;
+	case XFS_BTNUM_BNO:
+		mask = XFS_SICK_AG_BNOBT;
+		break;
+	case XFS_BTNUM_CNT:
+		mask = XFS_SICK_AG_CNTBT;
+		break;
+	case XFS_BTNUM_INO:
+		mask = XFS_SICK_AG_INOBT;
+		break;
+	case XFS_BTNUM_FINO:
+		mask = XFS_SICK_AG_FINOBT;
+		break;
+	case XFS_BTNUM_RMAP:
+		mask = XFS_SICK_AG_RMAPBT;
+		break;
+	case XFS_BTNUM_REFC:
+		mask = XFS_SICK_AG_REFCNTBT;
+		break;
+	default:
+		ASSERT(0);
+		return;
+	}
+
+	xfs_agno_mark_sick(cur->bc_mp, cur->bc_private.a.agno, mask);
+}

