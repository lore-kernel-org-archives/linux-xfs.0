Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47650 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389390AbeHAPFj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Aug 2018 11:05:39 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 093407DAC8
        for <linux-xfs@vger.kernel.org>; Wed,  1 Aug 2018 13:19:53 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E951C2026D68
        for <linux-xfs@vger.kernel.org>; Wed,  1 Aug 2018 13:19:52 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 05/15] xfs: replace dop_low with transaction flag
Date: Wed,  1 Aug 2018 09:19:42 -0400
Message-Id: <20180801131952.60250-6-bfoster@redhat.com>
In-Reply-To: <20180801131952.60250-1-bfoster@redhat.com>
References: <20180801131952.60250-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The dop_low field enables the low free space allocation mode when a
previous allocation has detected difficulty allocating blocks. It
has historically been part of the xfs_defer_ops structure, which
means if enabled, it remains enabled across a set of transactions
until the deferred operations have completed and the dfops is reset.

Now that the dfops is embedded in the transaction, we can save a bit
more space by using a transaction flag rather than a standalone
boolean. Drop the ->dop_low field and replace it with a transaction
flag that is set at the same points, carried across rolling
transactions and cleared on completion of deferred operations. This
essentially emulates the behavior of ->dop_low and so should not
change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c       |  8 ++++----
 fs/xfs/libxfs/xfs_bmap_btree.c |  4 ++--
 fs/xfs/libxfs/xfs_defer.c      | 16 ++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h      | 11 -----------
 fs/xfs/libxfs/xfs_shared.h     | 12 ++++++++++++
 fs/xfs/xfs_filestream.c        |  3 ++-
 fs/xfs/xfs_trace.h             | 10 ++--------
 fs/xfs/xfs_trans.h             |  2 --
 8 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a85c0445b38f..8edf7522aaff 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -700,7 +700,7 @@ xfs_bmap_extents_to_btree(
 	if (tp->t_firstblock == NULLFSBLOCK) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
-	} else if (tp->t_dfops->dop_low) {
+	} else if (tp->t_flags & XFS_TRANS_LOWMODE) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = tp->t_firstblock;
 	} else {
@@ -3449,7 +3449,7 @@ xfs_bmap_btalloc(
 			error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
 		if (error)
 			return error;
-	} else if (ap->tp->t_dfops->dop_low) {
+	} else if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
 		if (xfs_inode_is_filestream(ap->ip))
 			args.type = XFS_ALLOCTYPE_FIRST_AG;
 		else
@@ -3484,7 +3484,7 @@ xfs_bmap_btalloc(
 	 * is >= the stripe unit and the allocation offset is
 	 * at the end of file.
 	 */
-	if (!ap->tp->t_dfops->dop_low && ap->aeof) {
+	if (!(ap->tp->t_flags & XFS_TRANS_LOWMODE) && ap->aeof) {
 		if (!ap->offset) {
 			args.alignment = stripe_align;
 			atype = args.type;
@@ -3576,7 +3576,7 @@ xfs_bmap_btalloc(
 		args.total = ap->minlen;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
-		ap->tp->t_dfops->dop_low = true;
+		ap->tp->t_flags |= XFS_TRANS_LOWMODE;
 	}
 	if (args.fsbno != NULLFSBLOCK) {
 		/*
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 01489714a253..955e29de8cae 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -226,7 +226,7 @@ xfs_bmbt_alloc_block(
 		 * block allocation here and corrupt the filesystem.
 		 */
 		args.minleft = args.tp->t_blk_res;
-	} else if (cur->bc_tp->t_dfops->dop_low) {
+	} else if (cur->bc_tp->t_flags & XFS_TRANS_LOWMODE) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 	} else {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
@@ -253,7 +253,7 @@ xfs_bmbt_alloc_block(
 		error = xfs_alloc_vextent(&args);
 		if (error)
 			goto error0;
-		cur->bc_tp->t_dfops->dop_low = true;
+		cur->bc_tp->t_flags |= XFS_TRANS_LOWMODE;
 	}
 	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
 		*stat = 0;
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index e3517a53c525..64e1abc60edc 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -330,9 +330,14 @@ xfs_defer_reset(
 
 	ASSERT(!xfs_defer_has_unfinished_work(dop));
 
-	dop->dop_low = false;
 	memset(dop->dop_inodes, 0, sizeof(dop->dop_inodes));
 	memset(dop->dop_bufs, 0, sizeof(dop->dop_bufs));
+
+	/*
+	 * Low mode state transfers across transaction rolls to mirror dfops
+	 * lifetime. Clear it now that dfops is reset.
+	 */
+	tp->t_flags &= ~XFS_TRANS_LOWMODE;
 }
 
 /*
@@ -590,7 +595,14 @@ xfs_defer_move(
 
 	memcpy(dst->dop_inodes, src->dop_inodes, sizeof(dst->dop_inodes));
 	memcpy(dst->dop_bufs, src->dop_bufs, sizeof(dst->dop_bufs));
-	dst->dop_low = src->dop_low;
+
+	/*
+	 * Low free space mode was historically controlled by a dfops field.
+	 * This meant that low mode state potentially carried across multiple
+	 * transaction rolls. Transfer low mode on a dfops move to preserve
+	 * that behavior.
+	 */
+	dtp->t_flags |= (stp->t_flags & XFS_TRANS_LOWMODE);
 
 	xfs_defer_reset(stp);
 }
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index d60c50498fdf..8908a2716774 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -25,17 +25,6 @@ struct xfs_defer_pending {
 
 /*
  * Header for deferred operation list.
- *
- * dop_low is used by the allocator to activate the lowspace algorithm -
- * when free space is running low the extent allocator may choose to
- * allocate an extent from an AG without leaving sufficient space for
- * a btree split when inserting the new extent.  In this case the allocator
- * will enable the lowspace algorithm which is supposed to allow further
- * allocations (such as btree splits and newroots) to allocate from
- * sequential AGs.  In order to avoid locking AGs out of order the lowspace
- * algorithm will start searching for free space from AG 0.  If the correct
- * transaction reservations have been made then this algorithm will eventually
- * find all the space it needs.
  */
 enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_BMAP,
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 22089f1c880a..1c5debe748f0 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -64,6 +64,18 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
 #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
 #define XFS_TRANS_NOFS		0x80	/* pass KM_NOFS to kmem_alloc */
+/*
+ * LOWMODE is used by the allocator to activate the lowspace algorithm - when
+ * free space is running low the extent allocator may choose to allocate an
+ * extent from an AG without leaving sufficient space for a btree split when
+ * inserting the new extent. In this case the allocator will enable the
+ * lowspace algorithm which is supposed to allow further allocations (such as
+ * btree splits and newroots) to allocate from sequential AGs. In order to
+ * avoid locking AGs out of order the lowspace algorithm will start searching
+ * for free space from AG 0. If the correct transaction reservations have been
+ * made then this algorithm will eventually find all the space it needs.
+ */
+#define XFS_TRANS_LOWMODE	0x100	/* allocate in low space mode */
 
 /*
  * Field values for xfs_trans_mod_sb.
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 212173c62588..182501373af2 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -20,6 +20,7 @@
 #include "xfs_trace.h"
 #include "xfs_ag_resv.h"
 #include "xfs_trans.h"
+#include "xfs_shared.h"
 
 struct xfs_fstrm_item {
 	struct xfs_mru_cache_elem	mru;
@@ -378,7 +379,7 @@ xfs_filestream_new_ag(
 
 	if (xfs_alloc_is_userdata(ap->datatype))
 		flags |= XFS_PICK_USERDATA;
-	if (ap->tp->t_dfops->dop_low)
+	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
 		flags |= XFS_PICK_LOWSPACE;
 
 	err = xfs_filestream_pick_ag(pip, startag, agp, flags, minlen);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index cc6995cfce66..8807f1bb814a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2223,19 +2223,16 @@ DECLARE_EVENT_CLASS(xfs_defer_class,
 		__field(dev_t, dev)
 		__field(void *, dop)
 		__field(char, committed)
-		__field(char, low)
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
 		__entry->dev = mp ? mp->m_super->s_dev : 0;
 		__entry->dop = dop;
-		__entry->low = dop->dop_low;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ops %p low %d, caller %pS",
+	TP_printk("dev %d:%d ops %p caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->dop,
-		  __entry->low,
 		  (char *)__entry->caller_ip)
 )
 #define DEFINE_DEFER_EVENT(name) \
@@ -2251,19 +2248,16 @@ DECLARE_EVENT_CLASS(xfs_defer_error_class,
 		__field(dev_t, dev)
 		__field(void *, dop)
 		__field(char, committed)
-		__field(char, low)
 		__field(int, error)
 	),
 	TP_fast_assign(
 		__entry->dev = mp ? mp->m_super->s_dev : 0;
 		__entry->dop = dop;
-		__entry->low = dop->dop_low;
 		__entry->error = error;
 	),
-	TP_printk("dev %d:%d ops %p low %d err %d",
+	TP_printk("dev %d:%d ops %p err %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->dop,
-		  __entry->low,
 		  __entry->error)
 )
 #define DEFINE_DEFER_ERROR_EVENT(name) \
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index dc79e3c1d3e8..7e493221160e 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -101,8 +101,6 @@ struct xfs_defer_ops {
 	/* relog these with each roll */
 	struct xfs_inode	*dop_inodes[XFS_DEFER_OPS_NR_INODES];
 	struct xfs_buf		*dop_bufs[XFS_DEFER_OPS_NR_BUFS];
-
-	bool			dop_low;	/* alloc in low mode */
 };
 
 /*
-- 
2.17.1

