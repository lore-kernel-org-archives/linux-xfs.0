Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o28D525X035624 for <xfs@oss.sgi.com>; Mon, 8 Mar 2010 07:05:02 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C4F91D1DEA6
	for <xfs@oss.sgi.com>; Mon,  8 Mar 2010 05:06:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id TDnJavxiPr9zI2nk for
	<xfs@oss.sgi.com>; Mon, 08 Mar 2010 05:06:33 -0800 (PST)
Date: Mon, 8 Mar 2010 08:06:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, RFC] xfs: add discard support
Message-ID: <20100308130632.GA25726@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: jmoyer@redhat.com

Add a new -o discard option which allows the filesystem to discard unused
blocks on the backing devices.  This is done by running through the
freespace btrees every 30 seconds (or whatever the xfssyncd internal is),
and issue discard request for those not yet discarded.  Theres is some
bookepping to not discard the same blocks again and again, but for now
it's rather hacky and I'm still working on a better version.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2010-03-07 20:46:28.238024285 +0100
+++ xfs/fs/xfs/xfs_alloc.c	2010-03-08 13:59:51.735255533 +0100
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
+ * Copyright (C) 2010 Red Hat, Inc.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -66,6 +67,76 @@ STATIC int xfs_alloc_ag_vextent_small(xf
  * Internal functions.
  */
 
+struct xfs_discard_extent {
+	struct rb_node	rb_node;
+	xfs_agblock_t	bno;
+	xfs_extlen_t	len;
+};
+
+/*
+ * Insert an extent we are about to discard into our list of discarded
+ * entries.  Do not merge with adjacent entries.
+ */
+STATIC void
+xfs_discard_tree_insert(
+	struct xfs_perag	*pag,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len)
+{
+	struct rb_node		**rbp = &pag->pag_discard_tree.rb_node;
+	struct rb_node          *parent = NULL;
+	struct xfs_discard_extent *ep, *tmp;
+
+	/*
+	 * If we can't allocate memory here just return.  If we can't track
+	 * that we have discarded this entry we'll just discard it again
+	 * next time.
+	 */
+	ep = kmem_alloc(sizeof(*ep), KM_MAYFAIL);
+	if (!ep)
+		return;
+
+	ep->bno = bno;
+	ep->len = len;
+
+	while (*rbp) {
+		parent = *rbp;
+		tmp = rb_entry(parent, struct xfs_discard_extent, rb_node);
+
+		rbp = bno < tmp->bno ? &(*rbp)->rb_left : &(*rbp)->rb_right;
+	}
+
+	rb_link_node(&ep->rb_node, parent, rbp);
+	rb_insert_color(&ep->rb_node, &pag->pag_discard_tree);
+}
+
+STATIC struct xfs_discard_extent *
+xfs_discard_tree_search(
+	struct xfs_perag	*pag,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len)
+{
+	struct xfs_discard_extent *ep;
+	struct rb_node		*rbp;
+	xfs_agblock_t		uend, bend;
+
+	uend = bno + len - 1;
+	rbp = pag->pag_discard_tree.rb_node;
+	while (rbp) {
+		ep = rb_entry(rbp, struct xfs_discard_extent, rb_node);
+		bend = ep->bno + ep->len - 1;
+
+		if (uend < ep->bno)
+			rbp = rbp->rb_left;
+		else if (bno > bend)
+			rbp = rbp->rb_right;
+		else
+			return ep;
+	}
+
+	return NULL;
+}
+
 /*
  * Lookup the record equal to [bno, len] in the btree given by cur.
  */
@@ -312,6 +383,7 @@ xfs_alloc_fix_minleft(
  */
 STATIC int				/* error code */
 xfs_alloc_fixup_trees(
+	xfs_perag_t	*pag,		/* per-AG data */
 	xfs_btree_cur_t	*cnt_cur,	/* cursor for by-size btree */
 	xfs_btree_cur_t	*bno_cur,	/* cursor for by-block btree */
 	xfs_agblock_t	fbno,		/* starting block of free extent */
@@ -326,6 +398,7 @@ xfs_alloc_fixup_trees(
 	xfs_agblock_t	nfbno2;		/* second new free startblock */
 	xfs_extlen_t	nflen1=0;	/* first new free length */
 	xfs_extlen_t	nflen2=0;	/* second new free length */
+	struct xfs_discard_extent *ep;
 
 	/*
 	 * Look up the record in the by-size tree if necessary.
@@ -445,6 +518,28 @@ xfs_alloc_fixup_trees(
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 1);
 	}
+
+	if (!(cnt_cur->bc_mp->m_flags & XFS_MOUNT_DISCARD))
+		return 0;
+
+	/*
+	 * Check if there is an discarded extent overlapping with this
+	 * allocation, and if yes mark it our allocation as undiscarded.
+	 */
+	ep = xfs_discard_tree_search(pag, fbno, flen);
+	if (ep) {
+		if (nfbno1 != NULLAGBLOCK) {
+			ep->bno = nfbno1;
+			ep->len = nflen1;
+
+			if (nfbno2 != NULLAGBLOCK)
+				xfs_discard_tree_insert(pag, nfbno2, nflen2);
+		} else {
+			rb_erase(&ep->rb_node, &pag->pag_discard_tree);
+			kmem_free(ep);
+		}
+	}
+
 	return 0;
 }
 
@@ -640,8 +735,10 @@ xfs_alloc_ag_vextent_exact(
 		args->agno, XFS_BTNUM_CNT);
 	ASSERT(args->agbno + args->len <=
 		be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
-	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen,
-			args->agbno, args->len, XFSA_FIXUP_BNO_OK))) {
+	error = xfs_alloc_fixup_trees(args->pag, cnt_cur, bno_cur, fbno, flen,
+				      args->agbno, args->len,
+				      XFSA_FIXUP_BNO_OK);
+	if (error) {
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_ERROR);
 		goto error0;
 	}
@@ -832,8 +929,10 @@ xfs_alloc_ag_vextent_near(
 		/*
 		 * Fix up the btree entries.
 		 */
-		if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur_lt, ltbno,
-				ltlen, bnew, blen, XFSA_FIXUP_CNT_OK)))
+		error = xfs_alloc_fixup_trees(args->pag, cnt_cur, bno_cur_lt,
+					      ltbno, ltlen, bnew, blen,
+					      XFSA_FIXUP_CNT_OK);
+		if (error)
 			goto error0;
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 		xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_NOERROR);
@@ -1168,8 +1267,9 @@ xfs_alloc_ag_vextent_near(
 	ASSERT(ltnew + rlen <= ltend);
 	ASSERT(ltnew + rlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
 	args->agbno = ltnew;
-	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur_lt, ltbno, ltlen,
-			ltnew, rlen, XFSA_FIXUP_BNO_OK)))
+	error = xfs_alloc_fixup_trees(args->pag, cnt_cur, bno_cur_lt, ltbno,
+				      ltlen, ltnew, rlen, XFSA_FIXUP_BNO_OK);
+	if (error)
 		goto error0;
 
 	if (j)
@@ -1321,8 +1421,9 @@ xfs_alloc_ag_vextent_size(
 	 */
 	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
 		args->agno, XFS_BTNUM_BNO);
-	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen,
-			rbno, rlen, XFSA_FIXUP_CNT_OK)))
+	error = xfs_alloc_fixup_trees(args->pag, cnt_cur, bno_cur, fbno, flen,
+				      rbno, rlen, XFSA_FIXUP_CNT_OK);
+	if (error)
 		goto error0;
 	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
@@ -2202,6 +2303,7 @@ xfs_alloc_read_agf(
 		spin_lock_init(&pag->pagb_lock);
 		pag->pagb_count = 0;
 		memset(pag->pagb_list, 0, sizeof(pag->pagb_list));
+		pag->pag_discard_tree = RB_ROOT;
 		pag->pagf_init = 1;
 	}
 #ifdef DEBUG
@@ -2471,7 +2573,6 @@ error0:
 	return error;
 }
 
-
 /*
  * AG Busy list management
  * The busy list contains block ranges that have been freed but whose
@@ -2603,3 +2704,125 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 	if (lsn)
 		xfs_log_force_lsn(tp->t_mountp, lsn, XFS_LOG_SYNC);
 }
+
+STATIC int
+xfs_discard_extent(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		fbno,
+	xfs_extlen_t		flen)
+{
+	xfs_daddr_t		blkno = XFS_AGB_TO_DADDR(mp, agno, fbno);
+	sector_t		nblks = XFS_FSB_TO_BB(mp, flen);
+	int			error;
+
+#if 0
+	xfs_fs_cmn_err(CE_NOTE, mp, "discarding sectors [0x%llx-0x%llx]",
+			blkno, nblks);
+#endif
+
+	error = -blkdev_issue_discard(mp->m_ddev_targp->bt_bdev, blkno, nblks,
+				      GFP_NOFS, DISCARD_FL_WAIT);
+	if (error && error != EOPNOTSUPP) {
+		xfs_fs_cmn_err(CE_NOTE, mp, "discard failed, error %d", error);
+		return error;
+	}
+
+	return 0;
+}
+
+/*
+ * Notify the underlying block device about our free extent map.
+ *
+ * This walks all free extents above a minimum threshold and notifies the
+ * underlying device that these blocks are unused.  That information is
+ * useful for SSDs or thinly provisioned storage in high end arrays or
+ * virtualization scenarios.
+ */
+int
+xfs_discard_extents(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_extlen_t		minlen)	/* minimum extent size to bother */
+{
+	struct xfs_btree_cur	*cur;	/* cursor for the by-block btree */
+	struct xfs_buf		*agbp;	/* AGF buffer pointer */
+	struct xfs_perag	*pag;	/* per-AG information structure */
+	struct xfs_discard_extent *ep;
+	int			error;
+	int			i;
+
+	if (!(mp->m_flags & XFS_MOUNT_DISCARD))
+		return 0;
+
+	pag = xfs_perag_get(mp, agno);
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		goto out_put_perag;
+
+	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno, XFS_BTNUM_CNT);
+
+	/*
+	 * Look up the longest btree in the AGF and start with it.
+	 */
+	error = xfs_alloc_lookup_le(cur, 0,
+				    XFS_BUF_TO_AGF(agbp)->agf_longest, &i);
+	if (error)
+		goto out_del_cursor;
+
+	/*
+	 * Then loop until we are done with all extents that are large
+	 * enough to be worth discarding.
+	 */
+	while (i) {
+		xfs_agblock_t fbno;
+		xfs_extlen_t flen;
+		int match = 0;
+
+		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
+		if (error)
+			goto out_del_cursor;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, out_del_cursor);
+		ASSERT(flen <= XFS_BUF_TO_AGF(agbp)->agf_longest);
+
+		/*
+		 * Too small?  Give up.
+		 */
+		if (flen < minlen)
+			goto out_del_cursor;
+
+		/*
+		 * This is a bit of a hack - we check for an already discarded
+		 * extent covering the whole region.  If we have smaller eareas
+		 * already discarded we will cover them here, too.  This
+		 * assumes discards have negligible cost for additional blocks
+		 * and keeps the cost of bookkeeping down for us.
+		 */
+		while ((ep = xfs_discard_tree_search(pag, fbno, flen))) {
+			if (ep->bno <= fbno && ep->len >= flen)
+				match = 1;
+			rb_erase(&ep->rb_node, &pag->pag_discard_tree);
+			kmem_free(ep);
+		}
+
+		if (!match) {
+			error = xfs_discard_extent(mp, agno, fbno, flen);
+			if (error)
+				goto out_del_cursor;
+
+		}
+		xfs_discard_tree_insert(pag, fbno, flen);
+
+		error = xfs_btree_decrement(cur, 0, &i);
+		if (error)
+			goto out_del_cursor;
+	}
+
+out_del_cursor:
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	xfs_buf_relse(agbp);
+out_put_perag:
+	xfs_perag_put(pag);
+	return error;
+}
Index: xfs/fs/xfs/xfs_alloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.h	2010-03-07 20:46:28.246012202 +0100
+++ xfs/fs/xfs/xfs_alloc.h	2010-03-07 20:47:17.603254553 +0100
@@ -206,4 +206,7 @@ xfs_free_extent(
 	xfs_fsblock_t	bno,	/* starting block number of extent */
 	xfs_extlen_t	len);	/* length of extent */
 
+int xfs_discard_extents(struct xfs_mount *mp, xfs_agnumber_t agno,
+	xfs_extlen_t minlen);
+
 #endif	/* __XFS_ALLOC_H__ */
Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2010-03-07 20:46:28.227254624 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2010-03-07 21:26:03.389254274 +0100
@@ -43,6 +43,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_inode_item.h"
 #include "xfs_rw.h"
+#include "xfs_alloc.h"
 #include "xfs_quota.h"
 #include "xfs_trace.h"
 
@@ -412,6 +413,26 @@ xfs_sync_fsdata(
 	return error;
 }
 
+STATIC int
+xfs_discard_blocks(
+	struct xfs_mount	*mp)
+{
+	struct request_queue	*q = mp->m_ddev_targp->bt_bdev->bd_disk->queue;
+	xfs_extlen_t		minlen;
+	xfs_agnumber_t		agno;
+	int			error, last_error = 0;
+
+	minlen = XFS_B_TO_FSB(mp, q->limits.discard_granularity);
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		error = xfs_discard_extents(mp, agno, minlen);
+		if (error)
+			last_error = error;
+	}
+
+	return last_error;
+}
+
 /*
  * When remounting a filesystem read-only or freezing the filesystem, we have
  * two phases to execute. This first phase is syncing the data before we
@@ -433,7 +454,7 @@ int
 xfs_quiesce_data(
 	struct xfs_mount	*mp)
 {
-	int error;
+	int			error, error2;
 
 	/* push non-blocking */
 	xfs_sync_data(mp, 0);
@@ -450,6 +471,10 @@ xfs_quiesce_data(
 	if (mp->m_rtdev_targp)
 		XFS_bflush(mp->m_rtdev_targp);
 
+	error2 = xfs_discard_blocks(mp);
+	if (error)
+		error = error2;
+
 	return error;
 }
 
@@ -590,6 +615,12 @@ xfs_sync_worker(
 		/* dgc: errors ignored here */
 		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
 		error = xfs_sync_fsdata(mp, SYNC_TRYLOCK);
+		error = xfs_discard_blocks(mp);
+		if (error) {
+			xfs_fs_cmn_err(CE_WARN, mp,
+				"background discard failed with error %d",
+				error);
+		}
 	}
 	mp->m_sync_seq++;
 	wake_up(&mp->m_wait_single_sync_task);
Index: xfs/fs/xfs/xfs_ag.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ag.h	2010-03-07 20:46:28.267003961 +0100
+++ xfs/fs/xfs/xfs_ag.h	2010-03-07 20:47:17.614253855 +0100
@@ -223,6 +223,7 @@ typedef struct xfs_perag {
 	int		pag_ici_init;	/* incore inode cache initialised */
 	rwlock_t	pag_ici_lock;	/* incore inode lock */
 	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
+	struct rb_root	pag_discard_tree;
 #endif
 	int		pagb_count;	/* pagb slots in use */
 	xfs_perag_busy_t pagb_list[XFS_PAGB_NUM_SLOTS];	/* unstable blocks */
Index: xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2010-03-07 20:54:09.936253717 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_linux.h	2010-03-07 20:54:41.078446549 +0100
@@ -53,6 +53,7 @@
 #include <linux/file.h>
 #include <linux/swap.h>
 #include <linux/errno.h>
+#include <linux/rbtree.h>
 #include <linux/sched.h>
 #include <linux/bitops.h>
 #include <linux/major.h>
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-03-07 21:51:16.840004169 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-03-07 21:52:51.449022957 +0100
@@ -118,6 +118,7 @@ mempool_t *xfs_ioend_pool;
 #define MNTOPT_DMAPI	"dmapi"		/* DMI enabled (DMAPI / XDSM) */
 #define MNTOPT_XDSM	"xdsm"		/* DMI enabled (DMAPI / XDSM) */
 #define MNTOPT_DMI	"dmi"		/* DMI enabled (DMAPI / XDSM) */
+#define MNTOPT_DISCARD	"discard"	/* discard unused disk blocks */
 
 /*
  * Table driven mount option parser.
@@ -373,6 +375,8 @@ xfs_parseargs(
 			mp->m_flags |= XFS_MOUNT_DMAPI;
 		} else if (!strcmp(this_char, MNTOPT_DMI)) {
 			mp->m_flags |= XFS_MOUNT_DMAPI;
+		} else if (!strcmp(this_char, MNTOPT_DISCARD)) {
+			mp->m_flags |= XFS_MOUNT_DISCARD;
 		} else if (!strcmp(this_char, "ihashsize")) {
 			cmn_err(CE_WARN,
 	"XFS: ihashsize no longer used, option is deprecated.");
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2010-03-07 21:53:49.603253925 +0100
+++ xfs/fs/xfs/xfs_mount.h	2010-03-07 21:54:33.363284726 +0100
@@ -279,6 +279,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_ATTR2		(1ULL << 8)	/* allow use of attr2 format */
 #define XFS_MOUNT_GRPID		(1ULL << 9)	/* group-ID assigned from directory */
 #define XFS_MOUNT_NORECOVERY	(1ULL << 10)	/* no recovery - dirty fs */
+#define XFS_MOUNT_DISCARD	(1ULL << 11)	/* discard unused blocks */
 #define XFS_MOUNT_DFLT_IOSIZE	(1ULL << 12)	/* set default i/o size */
 #define XFS_MOUNT_OSYNCISOSYNC	(1ULL << 13)	/* o_sync is REALLY o_sync */
 						/* osyncisdsync is now default*/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
