Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VG6YbE178926 for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:06:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 65DC1157FD1E
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 09:11:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jVd6Mw9M4LgONP2F for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 09:11:13 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OJ7Xw-0000xp-GG
	for xfs@oss.sgi.com; Mon, 31 May 2010 16:09:00 +0000
Message-Id: <20100531160900.319050257@bombadil.infradead.org>
Date: Mon, 31 May 2010 12:07:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/17] xfs: simplify log item descriptor tracking
References: <20100531160727.842750532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-log_item_desc-list
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Currently we track log item descriptor belonging to a transaction using a
complex opencoded chunk allocator.  This code has been there since day one
and seems to work around the lack of an efficient slab allocator.

This patch replaces it with dynamically allocated log item descriptors
from a dedicated slab pool, linked to the transaction by a linked list.

This allows to greatly simplify the log item descriptor tracking to the
point where it's just a couple hundred lines in xfs_trans.c instead of
a separate file.  The external API has also been simplified while we're
at it - the xfs_trans_add_item and xfs_trans_del_item functions to add/
delete items from a transaction have been simplified to the bare minium,
and the xfs_trans_find_item function is replaced with a direct dereference
of the li_desc field.  All debug code walking the list of log items in
a transaction is down to a simple list_for_each_entry.

Note that we could easily use a singly linked list here instead of the
double linked list from list.h as the fastpath only does deletion from
sequential traversal.  But given that we don't have one available as
a library function yet I use the list.h functions for simplicity.

[the patch applies ontop of Dave's delayed-logging branch]

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_trans_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_trans_dquot.c	2010-05-25 11:40:59.000000000 +0200
+++ xfs/fs/xfs/quota/xfs_trans_dquot.c	2010-05-25 12:43:47.925004680 +0200
@@ -49,16 +49,14 @@ xfs_trans_dqjoin(
 	xfs_trans_t	*tp,
 	xfs_dquot_t	*dqp)
 {
-	xfs_dq_logitem_t    *lp = &dqp->q_logitem;
-
 	ASSERT(dqp->q_transp != tp);
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
-	ASSERT(lp->qli_dquot == dqp);
+	ASSERT(dqp->q_logitem.qli_dquot == dqp);
 
 	/*
 	 * Get a log_item_desc to point at the new item.
 	 */
-	(void) xfs_trans_add_item(tp, (xfs_log_item_t*)(lp));
+	xfs_trans_add_item(tp, &dqp->q_logitem.qli_item);
 
 	/*
 	 * Initialize i_transp so we can later determine if this dquot is
@@ -83,16 +81,11 @@ xfs_trans_log_dquot(
 	xfs_trans_t	*tp,
 	xfs_dquot_t	*dqp)
 {
-	xfs_log_item_desc_t	*lidp;
-
 	ASSERT(dqp->q_transp == tp);
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)(&dqp->q_logitem));
-	ASSERT(lidp != NULL);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
-	lidp->lid_flags |= XFS_LID_DIRTY;
+	dqp->q_logitem.qli_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 }
 
 /*
@@ -864,9 +857,8 @@ xfs_trans_get_qoff_item(
 	/*
 	 * Get a log_item_desc to point at the new item.
 	 */
-	(void) xfs_trans_add_item(tp, (xfs_log_item_t*)q);
-
-	return (q);
+	xfs_trans_add_item(tp, &q->qql_item);
+	return q;
 }
 
 
@@ -880,13 +872,8 @@ xfs_trans_log_quotaoff_item(
 	xfs_trans_t		*tp,
 	xfs_qoff_logitem_t	*qlp)
 {
-	xfs_log_item_desc_t	*lidp;
-
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t *)qlp);
-	ASSERT(lidp != NULL);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
-	lidp->lid_flags |= XFS_LID_DIRTY;
+	qlp->qql_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 }
 
 STATIC void
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2010-05-25 11:40:58.000000000 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2010-05-25 12:43:47.926004470 +0200
@@ -460,13 +460,10 @@ xfs_buf_item_unpin_remove(
 		 * occurs later in the xfs_trans_uncommit() will try to
 		 * reference the buffer which we no longer have a hold on.
 		 */
-		struct xfs_log_item_desc *lidp;
-
 		ASSERT(XFS_BUF_VALUSEMA(bip->bli_buf) <= 0);
 		trace_xfs_buf_item_unpin_stale(bip);
 
-		lidp = xfs_trans_find_item(tp, (xfs_log_item_t *)bip);
-		xfs_trans_free_item(tp, lidp);
+		xfs_trans_del_item(&bip->bli_item);
 
 		/*
 		 * Since the transaction no longer refers to the buffer, the
Index: xfs/fs/xfs/xfs_extfree_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_extfree_item.c	2010-05-25 11:40:58.000000000 +0200
+++ xfs/fs/xfs/xfs_extfree_item.c	2010-05-25 12:43:47.938004470 +0200
@@ -131,18 +131,18 @@ STATIC void
 xfs_efi_item_unpin_remove(xfs_efi_log_item_t *efip, xfs_trans_t *tp)
 {
 	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
-	xfs_log_item_desc_t	*lidp;
 
 	spin_lock(&ailp->xa_lock);
 	if (efip->efi_flags & XFS_EFI_CANCELED) {
+		struct xfs_log_item	*lip = &efip->efi_item;
+
 		/*
 		 * free the xaction descriptor pointing to this item
 		 */
-		lidp = xfs_trans_find_item(tp, (xfs_log_item_t *) efip);
-		xfs_trans_free_item(tp, lidp);
+		xfs_trans_del_item(lip);
 
 		/* xfs_trans_ail_delete() drops the AIL lock. */
-		xfs_trans_ail_delete(ailp, (xfs_log_item_t *)efip);
+		xfs_trans_ail_delete(ailp, lip);
 		xfs_efi_item_free(efip);
 	} else {
 		efip->efi_flags |= XFS_EFI_COMMITTED;
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2010-05-25 11:40:59.292005935 +0200
+++ xfs/fs/xfs/xfs_trans_buf.c	2010-05-25 12:43:47.945004470 +0200
@@ -47,36 +47,17 @@ xfs_trans_buf_item_match(
 	xfs_daddr_t		blkno,
 	int			len)
 {
-	xfs_log_item_chunk_t	*licp;
-	xfs_log_item_desc_t	*lidp;
-	xfs_buf_log_item_t	*blip;
-	int			i;
+	struct xfs_log_item_desc *lidp;
+	struct xfs_buf_log_item	*blip;
 
 	len = BBTOB(len);
-	for (licp = &tp->t_items; licp != NULL; licp = licp->lic_next) {
-		if (xfs_lic_are_all_free(licp)) {
-			ASSERT(licp == &tp->t_items);
-			ASSERT(licp->lic_next == NULL);
-			return NULL;
-		}
-
-		for (i = 0; i < licp->lic_unused; i++) {
-			/*
-			 * Skip unoccupied slots.
-			 */
-			if (xfs_lic_isfree(licp, i))
-				continue;
-
-			lidp = xfs_lic_slot(licp, i);
-			blip = (xfs_buf_log_item_t *)lidp->lid_item;
-			if (blip->bli_item.li_type != XFS_LI_BUF)
-				continue;
-
-			if (XFS_BUF_TARGET(blip->bli_buf) == target &&
-			    XFS_BUF_ADDR(blip->bli_buf) == blkno &&
-			    XFS_BUF_COUNT(blip->bli_buf) == len)
-				return blip->bli_buf;
-		}
+	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
+		blip = (struct xfs_buf_log_item *)lidp->lid_item;
+		if (blip->bli_item.li_type == XFS_LI_BUF &&
+		    XFS_BUF_TARGET(blip->bli_buf) == target &&
+		    XFS_BUF_ADDR(blip->bli_buf) == blkno &&
+		    XFS_BUF_COUNT(blip->bli_buf) == len)
+			return blip->bli_buf;
 	}
 
 	return NULL;
@@ -123,7 +104,7 @@ _xfs_trans_bjoin(
 	/*
 	 * Get a log_item_desc to point at the new item.
 	 */
-	(void) xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
+	xfs_trans_add_item(tp, &bip->bli_item);
 
 	/*
 	 * Initialize b_fsprivate2 so we can find it with incore_match()
@@ -479,7 +460,6 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 {
 	xfs_buf_log_item_t	*bip;
 	xfs_log_item_t		*lip;
-	xfs_log_item_desc_t	*lidp;
 
 	/*
 	 * Default to a normal brelse() call if the tp is NULL.
@@ -510,13 +490,6 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 	ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_CANCEL));
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
-	/*
-	 * Find the item descriptor pointing to this buffer's
-	 * log item.  It must be there.
-	 */
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)bip);
-	ASSERT(lidp != NULL);
-
 	trace_xfs_trans_brelse(bip);
 
 	/*
@@ -532,7 +505,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 	 * If the buffer is dirty within this transaction, we can't
 	 * release it until we commit.
 	 */
-	if (lidp->lid_flags & XFS_LID_DIRTY)
+	if (bip->bli_item.li_desc->lid_flags & XFS_LID_DIRTY)
 		return;
 
 	/*
@@ -549,7 +522,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 	/*
 	 * Free up the log item descriptor tracking the released item.
 	 */
-	xfs_trans_free_item(tp, lidp);
+	xfs_trans_del_item(&bip->bli_item);
 
 	/*
 	 * Clear the hold flag in the buf log item if it is set.
@@ -661,7 +634,6 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 		  uint		last)
 {
 	xfs_buf_log_item_t	*bip;
-	xfs_log_item_desc_t	*lidp;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
@@ -703,11 +675,8 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 		bip->bli_format.blf_flags &= ~XFS_BLF_CANCEL;
 	}
 
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)bip);
-	ASSERT(lidp != NULL);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
-	lidp->lid_flags |= XFS_LID_DIRTY;
+	bip->bli_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 	bip->bli_flags |= XFS_BLI_LOGGED;
 	xfs_buf_item_log(bip, first, last);
 }
@@ -736,7 +705,6 @@ xfs_trans_binval(
 	xfs_trans_t	*tp,
 	xfs_buf_t	*bp)
 {
-	xfs_log_item_desc_t	*lidp;
 	xfs_buf_log_item_t	*bip;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
@@ -744,8 +712,6 @@ xfs_trans_binval(
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)bip);
-	ASSERT(lidp != NULL);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	trace_xfs_trans_binval(bip);
@@ -760,7 +726,7 @@ xfs_trans_binval(
 		ASSERT(!(bip->bli_flags & (XFS_BLI_LOGGED | XFS_BLI_DIRTY)));
 		ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_INODE_BUF));
 		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
-		ASSERT(lidp->lid_flags & XFS_LID_DIRTY);
+		ASSERT(bip->bli_item.li_desc->lid_flags & XFS_LID_DIRTY);
 		ASSERT(tp->t_flags & XFS_TRANS_DIRTY);
 		return;
 	}
@@ -793,7 +759,7 @@ xfs_trans_binval(
 	bip->bli_format.blf_flags |= XFS_BLF_CANCEL;
 	memset((char *)(bip->bli_format.blf_data_map), 0,
 	      (bip->bli_format.blf_map_size * sizeof(uint)));
-	lidp->lid_flags |= XFS_LID_DIRTY;
+	bip->bli_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 	tp->t_flags |= XFS_TRANS_DIRTY;
 }
 
Index: xfs/fs/xfs/xfs_trans_extfree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_extfree.c	2010-05-25 11:40:58.000000000 +0200
+++ xfs/fs/xfs/xfs_trans_extfree.c	2010-05-25 12:43:47.950004191 +0200
@@ -48,9 +48,8 @@ xfs_trans_get_efi(xfs_trans_t	*tp,
 	/*
 	 * Get a log_item_desc to point at the new item.
 	 */
-	(void) xfs_trans_add_item(tp, (xfs_log_item_t*)efip);
-
-	return (efip);
+	xfs_trans_add_item(tp, &efip->efi_item);
+	return efip;
 }
 
 /*
@@ -64,15 +63,11 @@ xfs_trans_log_efi_extent(xfs_trans_t		*t
 			 xfs_fsblock_t		start_block,
 			 xfs_extlen_t		ext_len)
 {
-	xfs_log_item_desc_t	*lidp;
 	uint			next_extent;
 	xfs_extent_t		*extp;
 
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)efip);
-	ASSERT(lidp != NULL);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
-	lidp->lid_flags |= XFS_LID_DIRTY;
+	efip->efi_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 
 	next_extent = efip->efi_next_extent;
 	ASSERT(next_extent < efip->efi_format.efi_nextents);
@@ -105,9 +100,8 @@ xfs_trans_get_efd(xfs_trans_t		*tp,
 	/*
 	 * Get a log_item_desc to point at the new item.
 	 */
-	(void) xfs_trans_add_item(tp, (xfs_log_item_t*)efdp);
-
-	return (efdp);
+	xfs_trans_add_item(tp, &efdp->efd_item);
+	return efdp;
 }
 
 /*
@@ -121,15 +115,11 @@ xfs_trans_log_efd_extent(xfs_trans_t		*t
 			 xfs_fsblock_t		start_block,
 			 xfs_extlen_t		ext_len)
 {
-	xfs_log_item_desc_t	*lidp;
 	uint			next_extent;
 	xfs_extent_t		*extp;
 
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)efdp);
-	ASSERT(lidp != NULL);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
-	lidp->lid_flags |= XFS_LID_DIRTY;
+	efdp->efd_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 
 	next_extent = efdp->efd_next_extent;
 	ASSERT(next_extent < efdp->efd_format.efd_nextents);
Index: xfs/fs/xfs/xfs_trans_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_inode.c	2010-05-25 11:40:59.000000000 +0200
+++ xfs/fs/xfs/xfs_trans_inode.c	2010-05-25 12:43:47.956003422 +0200
@@ -88,7 +88,7 @@ xfs_trans_ijoin(
 	/*
 	 * Get a log_item_desc to point at the new item.
 	 */
-	(void) xfs_trans_add_item(tp, (xfs_log_item_t*)(iip));
+	xfs_trans_add_item(tp, &iip->ili_item);
 
 	xfs_trans_inode_broot_debug(ip);
 
@@ -144,17 +144,12 @@ xfs_trans_log_inode(
 	xfs_inode_t	*ip,
 	uint		flags)
 {
-	xfs_log_item_desc_t	*lidp;
-
 	ASSERT(ip->i_transp == tp);
 	ASSERT(ip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)(ip->i_itemp));
-	ASSERT(lidp != NULL);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
-	lidp->lid_flags |= XFS_LID_DIRTY;
+	ip->i_itemp->ili_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 
 	/*
 	 * Always OR in the bits from the ili_last_fields field.
Index: xfs/fs/xfs/xfs_trans_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_item.c	2010-05-25 12:43:55.924003980 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,440 +0,0 @@
-/*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_log.h"
-#include "xfs_inum.h"
-#include "xfs_trans.h"
-#include "xfs_trans_priv.h"
-/* XXX: from here down needed until struct xfs_trans has its own ailp */
-#include "xfs_bit.h"
-#include "xfs_buf_item.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_dir2.h"
-#include "xfs_mount.h"
-
-STATIC int	xfs_trans_unlock_chunk(xfs_log_item_chunk_t *,
-					int, int, xfs_lsn_t);
-
-/*
- * This is called to add the given log item to the transaction's
- * list of log items.  It must find a free log item descriptor
- * or allocate a new one and add the item to that descriptor.
- * The function returns a pointer to item descriptor used to point
- * to the new item.  The log item will now point to its new descriptor
- * with its li_desc field.
- */
-xfs_log_item_desc_t *
-xfs_trans_add_item(xfs_trans_t *tp, xfs_log_item_t *lip)
-{
-	xfs_log_item_desc_t	*lidp;
-	xfs_log_item_chunk_t	*licp;
-	int			i=0;
-
-	/*
-	 * If there are no free descriptors, allocate a new chunk
-	 * of them and put it at the front of the chunk list.
-	 */
-	if (tp->t_items_free == 0) {
-		licp = (xfs_log_item_chunk_t*)
-		       kmem_alloc(sizeof(xfs_log_item_chunk_t), KM_SLEEP);
-		ASSERT(licp != NULL);
-		/*
-		 * Initialize the chunk, and then
-		 * claim the first slot in the newly allocated chunk.
-		 */
-		xfs_lic_init(licp);
-		xfs_lic_claim(licp, 0);
-		licp->lic_unused = 1;
-		xfs_lic_init_slot(licp, 0);
-		lidp = xfs_lic_slot(licp, 0);
-
-		/*
-		 * Link in the new chunk and update the free count.
-		 */
-		licp->lic_next = tp->t_items.lic_next;
-		tp->t_items.lic_next = licp;
-		tp->t_items_free = XFS_LIC_NUM_SLOTS - 1;
-
-		/*
-		 * Initialize the descriptor and the generic portion
-		 * of the log item.
-		 *
-		 * Point the new slot at this item and return it.
-		 * Also point the log item at its currently active
-		 * descriptor and set the item's mount pointer.
-		 */
-		lidp->lid_item = lip;
-		lidp->lid_flags = 0;
-		lidp->lid_size = 0;
-		lip->li_desc = lidp;
-		lip->li_mountp = tp->t_mountp;
-		lip->li_ailp = tp->t_mountp->m_ail;
-		return lidp;
-	}
-
-	/*
-	 * Find the free descriptor. It is somewhere in the chunklist
-	 * of descriptors.
-	 */
-	licp = &tp->t_items;
-	while (licp != NULL) {
-		if (xfs_lic_vacancy(licp)) {
-			if (licp->lic_unused <= XFS_LIC_MAX_SLOT) {
-				i = licp->lic_unused;
-				ASSERT(xfs_lic_isfree(licp, i));
-				break;
-			}
-			for (i = 0; i <= XFS_LIC_MAX_SLOT; i++) {
-				if (xfs_lic_isfree(licp, i))
-					break;
-			}
-			ASSERT(i <= XFS_LIC_MAX_SLOT);
-			break;
-		}
-		licp = licp->lic_next;
-	}
-	ASSERT(licp != NULL);
-	/*
-	 * If we find a free descriptor, claim it,
-	 * initialize it, and return it.
-	 */
-	xfs_lic_claim(licp, i);
-	if (licp->lic_unused <= i) {
-		licp->lic_unused = i + 1;
-		xfs_lic_init_slot(licp, i);
-	}
-	lidp = xfs_lic_slot(licp, i);
-	tp->t_items_free--;
-	lidp->lid_item = lip;
-	lidp->lid_flags = 0;
-	lidp->lid_size = 0;
-	lip->li_desc = lidp;
-	lip->li_mountp = tp->t_mountp;
-	lip->li_ailp = tp->t_mountp->m_ail;
-	return lidp;
-}
-
-/*
- * Free the given descriptor.
- *
- * This requires setting the bit in the chunk's free mask corresponding
- * to the given slot.
- */
-void
-xfs_trans_free_item(xfs_trans_t	*tp, xfs_log_item_desc_t *lidp)
-{
-	uint			slot;
-	xfs_log_item_chunk_t	*licp;
-	xfs_log_item_chunk_t	**licpp;
-
-	slot = xfs_lic_desc_to_slot(lidp);
-	licp = xfs_lic_desc_to_chunk(lidp);
-	xfs_lic_relse(licp, slot);
-	lidp->lid_item->li_desc = NULL;
-	tp->t_items_free++;
-
-	/*
-	 * If there are no more used items in the chunk and this is not
-	 * the chunk embedded in the transaction structure, then free
-	 * the chunk. First pull it from the chunk list and then
-	 * free it back to the heap.  We didn't bother with a doubly
-	 * linked list here because the lists should be very short
-	 * and this is not a performance path.  It's better to save
-	 * the memory of the extra pointer.
-	 *
-	 * Also decrement the transaction structure's count of free items
-	 * by the number in a chunk since we are freeing an empty chunk.
-	 */
-	if (xfs_lic_are_all_free(licp) && (licp != &(tp->t_items))) {
-		licpp = &(tp->t_items.lic_next);
-		while (*licpp != licp) {
-			ASSERT(*licpp != NULL);
-			licpp = &((*licpp)->lic_next);
-		}
-		*licpp = licp->lic_next;
-		kmem_free(licp);
-		tp->t_items_free -= XFS_LIC_NUM_SLOTS;
-	}
-}
-
-/*
- * This is called to find the descriptor corresponding to the given
- * log item.  It returns a pointer to the descriptor.
- * The log item MUST have a corresponding descriptor in the given
- * transaction.  This routine does not return NULL, it panics.
- *
- * The descriptor pointer is kept in the log item's li_desc field.
- * Just return it.
- */
-/*ARGSUSED*/
-xfs_log_item_desc_t *
-xfs_trans_find_item(xfs_trans_t	*tp, xfs_log_item_t *lip)
-{
-	ASSERT(lip->li_desc != NULL);
-
-	return lip->li_desc;
-}
-
-
-/*
- * Return a pointer to the first descriptor in the chunk list.
- * This does not return NULL if there are none, it panics.
- *
- * The first descriptor must be in either the first or second chunk.
- * This is because the only chunk allowed to be empty is the first.
- * All others are freed when they become empty.
- *
- * At some point this and xfs_trans_next_item() should be optimized
- * to quickly look at the mask to determine if there is anything to
- * look at.
- */
-xfs_log_item_desc_t *
-xfs_trans_first_item(xfs_trans_t *tp)
-{
-	xfs_log_item_chunk_t	*licp;
-	int			i;
-
-	licp = &tp->t_items;
-	/*
-	 * If it's not in the first chunk, skip to the second.
-	 */
-	if (xfs_lic_are_all_free(licp)) {
-		licp = licp->lic_next;
-	}
-
-	/*
-	 * Return the first non-free descriptor in the chunk.
-	 */
-	ASSERT(!xfs_lic_are_all_free(licp));
-	for (i = 0; i < licp->lic_unused; i++) {
-		if (xfs_lic_isfree(licp, i)) {
-			continue;
-		}
-
-		return xfs_lic_slot(licp, i);
-	}
-	cmn_err(CE_WARN, "xfs_trans_first_item() -- no first item");
-	return NULL;
-}
-
-
-/*
- * Given a descriptor, return the next descriptor in the chunk list.
- * This returns NULL if there are no more used descriptors in the list.
- *
- * We do this by first locating the chunk in which the descriptor resides,
- * and then scanning forward in the chunk and the list for the next
- * used descriptor.
- */
-/*ARGSUSED*/
-xfs_log_item_desc_t *
-xfs_trans_next_item(xfs_trans_t *tp, xfs_log_item_desc_t *lidp)
-{
-	xfs_log_item_chunk_t	*licp;
-	int			i;
-
-	licp = xfs_lic_desc_to_chunk(lidp);
-
-	/*
-	 * First search the rest of the chunk. The for loop keeps us
-	 * from referencing things beyond the end of the chunk.
-	 */
-	for (i = (int)xfs_lic_desc_to_slot(lidp) + 1; i < licp->lic_unused; i++) {
-		if (xfs_lic_isfree(licp, i)) {
-			continue;
-		}
-
-		return xfs_lic_slot(licp, i);
-	}
-
-	/*
-	 * Now search the next chunk.  It must be there, because the
-	 * next chunk would have been freed if it were empty.
-	 * If there is no next chunk, return NULL.
-	 */
-	if (licp->lic_next == NULL) {
-		return NULL;
-	}
-
-	licp = licp->lic_next;
-	ASSERT(!xfs_lic_are_all_free(licp));
-	for (i = 0; i < licp->lic_unused; i++) {
-		if (xfs_lic_isfree(licp, i)) {
-			continue;
-		}
-
-		return xfs_lic_slot(licp, i);
-	}
-	ASSERT(0);
-	/* NOTREACHED */
-	return NULL; /* keep gcc quite */
-}
-
-/*
- * This is called to unlock all of the items of a transaction and to free
- * all the descriptors of that transaction.
- *
- * It walks the list of descriptors and unlocks each item.  It frees
- * each chunk except that embedded in the transaction as it goes along.
- */
-void
-xfs_trans_free_items(
-	xfs_trans_t	*tp,
-	xfs_lsn_t	commit_lsn,
-	int		flags)
-{
-	xfs_log_item_chunk_t	*licp;
-	xfs_log_item_chunk_t	*next_licp;
-	int			abort;
-
-	abort = flags & XFS_TRANS_ABORT;
-	licp = &tp->t_items;
-	/*
-	 * Special case the embedded chunk so we don't free it below.
-	 */
-	if (!xfs_lic_are_all_free(licp)) {
-		(void) xfs_trans_unlock_chunk(licp, 1, abort, commit_lsn);
-		xfs_lic_all_free(licp);
-		licp->lic_unused = 0;
-	}
-	licp = licp->lic_next;
-
-	/*
-	 * Unlock each item in each chunk and free the chunks.
-	 */
-	while (licp != NULL) {
-		ASSERT(!xfs_lic_are_all_free(licp));
-		(void) xfs_trans_unlock_chunk(licp, 1, abort, commit_lsn);
-		next_licp = licp->lic_next;
-		kmem_free(licp);
-		licp = next_licp;
-	}
-
-	/*
-	 * Reset the transaction structure's free item count.
-	 */
-	tp->t_items_free = XFS_LIC_NUM_SLOTS;
-	tp->t_items.lic_next = NULL;
-}
-
-
-
-/*
- * This is called to unlock the items associated with a transaction.
- * Items which were not logged should be freed.
- * Those which were logged must still be tracked so they can be unpinned
- * when the transaction commits.
- */
-void
-xfs_trans_unlock_items(xfs_trans_t *tp, xfs_lsn_t commit_lsn)
-{
-	xfs_log_item_chunk_t	*licp;
-	xfs_log_item_chunk_t	*next_licp;
-	xfs_log_item_chunk_t	**licpp;
-	int			freed;
-
-	freed = 0;
-	licp = &tp->t_items;
-
-	/*
-	 * Special case the embedded chunk so we don't free.
-	 */
-	if (!xfs_lic_are_all_free(licp)) {
-		freed = xfs_trans_unlock_chunk(licp, 0, 0, commit_lsn);
-	}
-	licpp = &(tp->t_items.lic_next);
-	licp = licp->lic_next;
-
-	/*
-	 * Unlock each item in each chunk, free non-dirty descriptors,
-	 * and free empty chunks.
-	 */
-	while (licp != NULL) {
-		ASSERT(!xfs_lic_are_all_free(licp));
-		freed += xfs_trans_unlock_chunk(licp, 0, 0, commit_lsn);
-		next_licp = licp->lic_next;
-		if (xfs_lic_are_all_free(licp)) {
-			*licpp = next_licp;
-			kmem_free(licp);
-			freed -= XFS_LIC_NUM_SLOTS;
-		} else {
-			licpp = &(licp->lic_next);
-		}
-		ASSERT(*licpp == next_licp);
-		licp = next_licp;
-	}
-
-	/*
-	 * Fix the free descriptor count in the transaction.
-	 */
-	tp->t_items_free += freed;
-}
-
-/*
- * Unlock each item pointed to by a descriptor in the given chunk.
- * Stamp the commit lsn into each item if necessary.
- * Free descriptors pointing to items which are not dirty if freeing_chunk
- * is zero. If freeing_chunk is non-zero, then we need to unlock all
- * items in the chunk.
- * 
- * Return the number of descriptors freed.
- */
-STATIC int
-xfs_trans_unlock_chunk(
-	xfs_log_item_chunk_t	*licp,
-	int			freeing_chunk,
-	int			abort,
-	xfs_lsn_t		commit_lsn)
-{
-	xfs_log_item_desc_t	*lidp;
-	xfs_log_item_t		*lip;
-	int			i;
-	int			freed;
-
-	freed = 0;
-	lidp = licp->lic_descs;
-	for (i = 0; i < licp->lic_unused; i++, lidp++) {
-		if (xfs_lic_isfree(licp, i)) {
-			continue;
-		}
-		lip = lidp->lid_item;
-		lip->li_desc = NULL;
-
-		if (commit_lsn != NULLCOMMITLSN)
-			IOP_COMMITTING(lip, commit_lsn);
-		if (abort)
-			lip->li_flags |= XFS_LI_ABORTED;
-		IOP_UNLOCK(lip);
-
-		/*
-		 * Free the descriptor if the item is not dirty
-		 * within this transaction and the caller is not
-		 * going to just free the entire thing regardless.
-		 */
-		if (!(freeing_chunk) &&
-		    (!(lidp->lid_flags & XFS_LID_DIRTY) || abort)) {
-			xfs_lic_relse(licp, i);
-			freed++;
-		}
-	}
-
-	return freed;
-}
Index: xfs/fs/xfs/xfs_trans_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_priv.h	2010-05-24 23:11:41.000000000 +0200
+++ xfs/fs/xfs/xfs_trans_priv.h	2010-05-25 12:43:47.958004191 +0200
@@ -23,22 +23,8 @@ struct xfs_log_item_desc;
 struct xfs_mount;
 struct xfs_trans;
 
-/*
- * From xfs_trans_item.c
- */
-struct xfs_log_item_desc	*xfs_trans_add_item(struct xfs_trans *,
-					    struct xfs_log_item *);
-void				xfs_trans_free_item(struct xfs_trans *,
-					    struct xfs_log_item_desc *);
-struct xfs_log_item_desc	*xfs_trans_find_item(struct xfs_trans *,
-					     struct xfs_log_item *);
-struct xfs_log_item_desc	*xfs_trans_first_item(struct xfs_trans *);
-struct xfs_log_item_desc	*xfs_trans_next_item(struct xfs_trans *,
-					     struct xfs_log_item_desc *);
-
-void	xfs_trans_unlock_items(struct xfs_trans *tp, xfs_lsn_t commit_lsn);
-void	xfs_trans_free_items(struct xfs_trans *tp, xfs_lsn_t commit_lsn,
-				int flags);
+void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
+void	xfs_trans_del_item(struct xfs_log_item *);
 
 void	xfs_trans_item_committed(struct xfs_log_item *lip,
 				xfs_lsn_t commit_lsn, int aborted);
Index: xfs/fs/xfs/Makefile
===================================================================
--- xfs.orig/fs/xfs/Makefile	2010-05-25 11:40:58.000000000 +0200
+++ xfs/fs/xfs/Makefile	2010-05-25 12:43:47.961004819 +0200
@@ -87,7 +87,6 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_trans_buf.o \
 				   xfs_trans_extfree.o \
 				   xfs_trans_inode.o \
-				   xfs_trans_item.o \
 				   xfs_utils.o \
 				   xfs_vnodeops.o \
 				   xfs_rw.o
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-05-25 11:40:59.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-05-25 12:43:47.966004540 +0200
@@ -1702,6 +1702,12 @@ xfs_init_zones(void)
 	if (!xfs_trans_zone)
 		goto out_destroy_ifork_zone;
 
+	xfs_log_item_desc_zone =
+		kmem_zone_init(sizeof(struct xfs_log_item_desc),
+			       "xfs_log_item_desc");
+	if (!xfs_log_item_desc_zone)
+		goto out_destroy_trans_zone;
+
 	/*
 	 * The size of the zone allocated buf log item is the maximum
 	 * size possible under XFS.  This wastes a little bit of memory,
@@ -1711,7 +1717,7 @@ xfs_init_zones(void)
 				(((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) /
 				  NBWORD) * sizeof(int))), "xfs_buf_item");
 	if (!xfs_buf_item_zone)
-		goto out_destroy_trans_zone;
+		goto out_destroy_log_item_desc_zone;
 
 	xfs_efd_zone = kmem_zone_init((sizeof(xfs_efd_log_item_t) +
 			((XFS_EFD_MAX_FAST_EXTENTS - 1) *
@@ -1748,6 +1754,8 @@ xfs_init_zones(void)
 	kmem_zone_destroy(xfs_efd_zone);
  out_destroy_buf_item_zone:
 	kmem_zone_destroy(xfs_buf_item_zone);
+ out_destroy_log_item_desc_zone:
+	kmem_zone_destroy(xfs_log_item_desc_zone);
  out_destroy_trans_zone:
 	kmem_zone_destroy(xfs_trans_zone);
  out_destroy_ifork_zone:
@@ -1778,6 +1786,7 @@ xfs_destroy_zones(void)
 	kmem_zone_destroy(xfs_efi_zone);
 	kmem_zone_destroy(xfs_efd_zone);
 	kmem_zone_destroy(xfs_buf_item_zone);
+	kmem_zone_destroy(xfs_log_item_desc_zone);
 	kmem_zone_destroy(xfs_trans_zone);
 	kmem_zone_destroy(xfs_ifork_zone);
 	kmem_zone_destroy(xfs_dabuf_zone);
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2010-05-25 11:40:59.000000000 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2010-05-25 12:43:47.970004889 +0200
@@ -5857,43 +5857,18 @@ xfs_bmap_get_bp(
 		bp = NULL;
 
 	if (!bp) { /* Chase down all the log items to see if the bp is there */
-		xfs_log_item_chunk_t    *licp;
-		xfs_trans_t		*tp;
+		struct xfs_log_item_desc *lidp;
+		struct xfs_buf_log_item	*bip;
 
-		tp = cur->bc_tp;
-		licp = &tp->t_items;
-		while (!bp && licp != NULL) {
-			if (xfs_lic_are_all_free(licp)) {
-				licp = licp->lic_next;
-				continue;
-			}
-			for (i = 0; i < licp->lic_unused; i++) {
-				xfs_log_item_desc_t	*lidp;
-				xfs_log_item_t		*lip;
-				xfs_buf_log_item_t	*bip;
-				xfs_buf_t		*lbp;
-
-				if (xfs_lic_isfree(licp, i)) {
-					continue;
-				}
-
-				lidp = xfs_lic_slot(licp, i);
-				lip = lidp->lid_item;
-				if (lip->li_type != XFS_LI_BUF)
-					continue;
-
-				bip = (xfs_buf_log_item_t *)lip;
-				lbp = bip->bli_buf;
-
-				if (XFS_BUF_ADDR(lbp) == bno) {
-					bp = lbp;
-					break; /* Found it */
-				}
-			}
-			licp = licp->lic_next;
+		list_for_each_entry(lidp, &cur->bc_tp->t_items, lid_trans) {
+			bip = (struct xfs_buf_log_item *)lidp->lid_item;
+			if (bip->bli_item.li_type == XFS_LI_BUF &&
+			    XFS_BUF_ADDR(bip->bli_buf) == bno)
+				return bip->bli_buf;
 		}
 	}
-	return(bp);
+
+	return bp;
 }
 
 STATIC void
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2010-05-25 12:43:44.000000000 +0200
+++ xfs/fs/xfs/xfs_trans.c	2010-05-25 12:43:47.977004330 +0200
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * Copyright (C) 2010 Red Hat, Inc.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -43,6 +44,7 @@
 #include "xfs_trace.h"
 
 kmem_zone_t	*xfs_trans_zone;
+kmem_zone_t	*xfs_log_item_desc_zone;
 
 
 /*
@@ -593,8 +595,7 @@ _xfs_trans_alloc(
 	tp->t_magic = XFS_TRANS_MAGIC;
 	tp->t_type = type;
 	tp->t_mountp = mp;
-	tp->t_items_free = XFS_LIC_NUM_SLOTS;
-	xfs_lic_init(&(tp->t_items));
+	INIT_LIST_HEAD(&tp->t_items);
 	INIT_LIST_HEAD(&tp->t_busy);
 	return tp;
 }
@@ -639,8 +640,7 @@ xfs_trans_dup(
 	ntp->t_magic = XFS_TRANS_MAGIC;
 	ntp->t_type = tp->t_type;
 	ntp->t_mountp = tp->t_mountp;
-	ntp->t_items_free = XFS_LIC_NUM_SLOTS;
-	xfs_lic_init(&(ntp->t_items));
+	INIT_LIST_HEAD(&ntp->t_items);
 	INIT_LIST_HEAD(&ntp->t_busy);
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
@@ -1120,6 +1120,108 @@ xfs_trans_unreserve_and_mod_sb(
 }
 
 /*
+ * Add the given log item to the transaction's list of log items.
+ *
+ * The log item will now point to its new descriptor with its li_desc field.
+ */
+void
+xfs_trans_add_item(
+	struct xfs_trans	*tp,
+	struct xfs_log_item	*lip)
+{
+	struct xfs_log_item_desc *lidp;
+
+	ASSERT(lip->li_mountp = tp->t_mountp);
+	ASSERT(lip->li_ailp = tp->t_mountp->m_ail);
+
+	lidp = kmem_zone_zalloc(xfs_log_item_desc_zone, KM_SLEEP);
+
+	lidp->lid_item = lip;
+	lidp->lid_flags = 0;
+	lidp->lid_size = 0;
+	list_add_tail(&lidp->lid_trans, &tp->t_items);
+
+	lip->li_desc = lidp;
+}
+
+STATIC void
+xfs_trans_free_item_desc(
+	struct xfs_log_item_desc *lidp)
+{
+	list_del_init(&lidp->lid_trans);
+	kmem_zone_free(xfs_log_item_desc_zone, lidp);
+}
+
+/*
+ * Unlink and free the given descriptor.
+ */
+void
+xfs_trans_del_item(
+	struct xfs_log_item	*lip)
+{
+	xfs_trans_free_item_desc(lip->li_desc);
+	lip->li_desc = NULL;
+}
+
+/*
+ * Unlock all of the items of a transaction and free all the descriptors
+ * of that transaction.
+ */
+STATIC void
+xfs_trans_free_items(
+	struct xfs_trans	*tp,
+	xfs_lsn_t		commit_lsn,
+	int			flags)
+{
+	struct xfs_log_item_desc *lidp, *next;
+
+	list_for_each_entry_safe(lidp, next, &tp->t_items, lid_trans) {
+		struct xfs_log_item	*lip = lidp->lid_item;
+
+		lip->li_desc = NULL;
+
+		if (commit_lsn != NULLCOMMITLSN)
+			IOP_COMMITTING(lip, commit_lsn);
+		if (flags & XFS_TRANS_ABORT)
+			lip->li_flags |= XFS_LI_ABORTED;
+		IOP_UNLOCK(lip);
+
+		xfs_trans_free_item_desc(lidp);
+	}
+}
+
+/*
+ * Unlock the items associated with a transaction.
+ *
+ * Items which were not logged should be freed.  Those which were logged must
+ * still be tracked so they can be unpinned when the transaction commits.
+ */
+STATIC void
+xfs_trans_unlock_items(
+	struct xfs_trans	*tp,
+	xfs_lsn_t		commit_lsn)
+{
+	struct xfs_log_item_desc *lidp, *next;
+
+	list_for_each_entry_safe(lidp, next, &tp->t_items, lid_trans) {
+		struct xfs_log_item	*lip = lidp->lid_item;
+
+		lip->li_desc = NULL;
+
+		if (commit_lsn != NULLCOMMITLSN)
+			IOP_COMMITTING(lip, commit_lsn);
+		IOP_UNLOCK(lip);
+
+		/*
+		 * Free the descriptor if the item is not dirty
+		 * within this transaction.
+		 */
+		if (!(lidp->lid_flags & XFS_LID_DIRTY))
+			xfs_trans_free_item_desc(lidp);
+	}
+}
+
+/*
  * Total up the number of log iovecs needed to commit this
  * transaction.  The transaction itself needs one for the
  * transaction header.  Ask each dirty item in turn how many
@@ -1130,30 +1232,27 @@ xfs_trans_count_vecs(
 	struct xfs_trans	*tp)
 {
 	int			nvecs;
-	xfs_log_item_desc_t	*lidp;
+	struct xfs_log_item_desc *lidp;
 
 	nvecs = 1;
-	lidp = xfs_trans_first_item(tp);
-	ASSERT(lidp != NULL);
 
 	/* In the non-debug case we need to start bailing out if we
 	 * didn't find a log_item here, return zero and let trans_commit
 	 * deal with it.
 	 */
-	if (lidp == NULL)
+	if (list_empty(&tp->t_items)) {
+		ASSERT(0);
 		return 0;
+	}
 
-	while (lidp != NULL) {
+	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
 		/*
 		 * Skip items which aren't dirty in this transaction.
 		 */
-		if (!(lidp->lid_flags & XFS_LID_DIRTY)) {
-			lidp = xfs_trans_next_item(tp, lidp);
+		if (!(lidp->lid_flags & XFS_LID_DIRTY))
 			continue;
-		}
 		lidp->lid_size = IOP_SIZE(lidp->lid_item);
 		nvecs += lidp->lid_size;
-		lidp = xfs_trans_next_item(tp, lidp);
 	}
 
 	return nvecs;
@@ -1173,7 +1272,7 @@ xfs_trans_fill_vecs(
 	struct xfs_trans	*tp,
 	struct xfs_log_iovec	*log_vector)
 {
-	xfs_log_item_desc_t	*lidp;
+	struct xfs_log_item_desc *lidp;
 	struct xfs_log_iovec	*vecp;
 	uint			nitems;
 
@@ -1184,14 +1283,11 @@ xfs_trans_fill_vecs(
 	vecp = log_vector + 1;
 
 	nitems = 0;
-	lidp = xfs_trans_first_item(tp);
-	ASSERT(lidp);
-	while (lidp) {
+	ASSERT(!list_empty(&tp->t_items));
+	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
 		/* Skip items which aren't dirty in this transaction. */
-		if (!(lidp->lid_flags & XFS_LID_DIRTY)) {
-			lidp = xfs_trans_next_item(tp, lidp);
+		if (!(lidp->lid_flags & XFS_LID_DIRTY))
 			continue;
-		}
 
 		/*
 		 * The item may be marked dirty but not log anything.  This can
@@ -1202,7 +1298,6 @@ xfs_trans_fill_vecs(
 		IOP_FORMAT(lidp->lid_item, vecp);
 		vecp += lidp->lid_size;
 		IOP_PIN(lidp->lid_item);
-		lidp = xfs_trans_next_item(tp, lidp);
 	}
 
 	/*
@@ -1297,24 +1392,15 @@ xfs_trans_committed(
 	struct xfs_trans	*tp,
 	int			abortflag)
 {
-	xfs_log_item_desc_t	*lidp;
-	xfs_log_item_chunk_t	*licp;
-	xfs_log_item_chunk_t	*next_licp;
+	struct xfs_log_item_desc *lidp, *next;
 
 	/* Call the transaction's completion callback if there is one. */
 	if (tp->t_callback != NULL)
 		tp->t_callback(tp, tp->t_callarg);
 
-	for (lidp = xfs_trans_first_item(tp);
-	     lidp != NULL;
-	     lidp = xfs_trans_next_item(tp, lidp)) {
+	list_for_each_entry_safe(lidp, next, &tp->t_items, lid_trans) {
 		xfs_trans_item_committed(lidp->lid_item, tp->t_lsn, abortflag);
-	}
-
-	/* free the item chunks, ignoring the embedded chunk */
-	for (licp = tp->t_items.lic_next; licp != NULL; licp = next_licp) {
-		next_licp = licp->lic_next;
-		kmem_free(licp);
+		xfs_trans_free_item_desc(lidp);
 	}
 
 	xfs_trans_free(tp);
@@ -1329,11 +1415,9 @@ xfs_trans_uncommit(
 	struct xfs_trans	*tp,
 	uint			flags)
 {
-	xfs_log_item_desc_t	*lidp;
+	struct xfs_log_item_desc *lidp;
 
-	for (lidp = xfs_trans_first_item(tp);
-	     lidp != NULL;
-	     lidp = xfs_trans_next_item(tp, lidp)) {
+	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
 		/*
 		 * Unpin all but those that aren't dirty.
 		 */
@@ -1504,33 +1588,28 @@ STATIC struct xfs_log_vec *
 xfs_trans_alloc_log_vecs(
 	xfs_trans_t	*tp)
 {
-	xfs_log_item_desc_t	*lidp;
+	struct xfs_log_item_desc *lidp;
 	struct xfs_log_vec	*lv = NULL;
 	struct xfs_log_vec	*ret_lv = NULL;
 
-	lidp = xfs_trans_first_item(tp);
 
 	/* Bail out if we didn't find a log item.  */
-	if (!lidp) {
+	if (list_empty(&tp->t_items)) {
 		ASSERT(0);
 		return NULL;
 	}
 
-	while (lidp != NULL) {
+	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
 		struct xfs_log_vec *new_lv;
 
 		/* Skip items which aren't dirty in this transaction. */
-		if (!(lidp->lid_flags & XFS_LID_DIRTY)) {
-			lidp = xfs_trans_next_item(tp, lidp);
+		if (!(lidp->lid_flags & XFS_LID_DIRTY))
 			continue;
-		}
 
 		/* Skip items that do not have any vectors for writing */
 		lidp->lid_size = IOP_SIZE(lidp->lid_item);
-		if (!lidp->lid_size) {
-			lidp = xfs_trans_next_item(tp, lidp);
+		if (!lidp->lid_size)
 			continue;
-		}
 
 		new_lv = kmem_zalloc(sizeof(*new_lv) +
 				lidp->lid_size * sizeof(struct xfs_log_iovec),
@@ -1545,7 +1624,6 @@ xfs_trans_alloc_log_vecs(
 		else
 			lv->lv_next = new_lv;
 		lv = new_lv;
-		lidp = xfs_trans_next_item(tp, lidp);
 	}
 
 	return ret_lv;
@@ -1704,12 +1782,6 @@ xfs_trans_cancel(
 	int			flags)
 {
 	int			log_flags;
-#ifdef DEBUG
-	xfs_log_item_chunk_t	*licp;
-	xfs_log_item_desc_t	*lidp;
-	xfs_log_item_t		*lip;
-	int			i;
-#endif
 	xfs_mount_t		*mp = tp->t_mountp;
 
 	/*
@@ -1728,21 +1800,11 @@ xfs_trans_cancel(
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	}
 #ifdef DEBUG
-	if (!(flags & XFS_TRANS_ABORT)) {
-		licp = &(tp->t_items);
-		while (licp != NULL) {
-			lidp = licp->lic_descs;
-			for (i = 0; i < licp->lic_unused; i++, lidp++) {
-				if (xfs_lic_isfree(licp, i)) {
-					continue;
-				}
-
-				lip = lidp->lid_item;
-				if (!XFS_FORCED_SHUTDOWN(mp))
-					ASSERT(!(lip->li_type == XFS_LI_EFD));
-			}
-			licp = licp->lic_next;
-		}
+	if (!(flags & XFS_TRANS_ABORT) && !XFS_FORCED_SHUTDOWN(mp)) {
+		struct xfs_log_item_desc *lidp;
+
+		list_for_each_entry(lidp, &tp->t_items, lid_trans)
+			ASSERT(!(lidp->lid_item->li_type == XFS_LI_EFD));
 	}
 #endif
 	xfs_trans_unreserve_and_mod_sb(tp);
Index: xfs/fs/xfs/xfs_trans.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.h	2010-05-25 12:43:44.000000000 +0200
+++ xfs/fs/xfs/xfs_trans.h	2010-05-25 12:43:47.986004051 +0200
@@ -161,105 +161,14 @@ typedef struct xfs_trans_header {
  * the amount of space needed to log the item it describes
  * once we get to commit processing (see xfs_trans_commit()).
  */
-typedef struct xfs_log_item_desc {
+struct xfs_log_item_desc {
 	struct xfs_log_item	*lid_item;
-	ushort		lid_size;
-	unsigned char	lid_flags;
-	unsigned char	lid_index;
-} xfs_log_item_desc_t;
+	ushort			lid_size;
+	unsigned char		lid_flags;
+	struct list_head	lid_trans;
+};
 
 #define XFS_LID_DIRTY		0x1
-#define XFS_LID_PINNED		0x2
-
-/*
- * This structure is used to maintain a chunk list of log_item_desc
- * structures. The free field is a bitmask indicating which descriptors
- * in this chunk's array are free.  The unused field is the first value
- * not used since this chunk was allocated.
- */
-#define	XFS_LIC_NUM_SLOTS	15
-typedef struct xfs_log_item_chunk {
-	struct xfs_log_item_chunk	*lic_next;
-	ushort				lic_free;
-	ushort				lic_unused;
-	xfs_log_item_desc_t		lic_descs[XFS_LIC_NUM_SLOTS];
-} xfs_log_item_chunk_t;
-
-#define	XFS_LIC_MAX_SLOT	(XFS_LIC_NUM_SLOTS - 1)
-#define	XFS_LIC_FREEMASK	((1 << XFS_LIC_NUM_SLOTS) - 1)
-
-
-/*
- * Initialize the given chunk.  Set the chunk's free descriptor mask
- * to indicate that all descriptors are free.  The caller gets to set
- * lic_unused to the right value (0 matches all free).  The
- * lic_descs.lid_index values are set up as each desc is allocated.
- */
-static inline void xfs_lic_init(xfs_log_item_chunk_t *cp)
-{
-	cp->lic_free = XFS_LIC_FREEMASK;
-}
-
-static inline void xfs_lic_init_slot(xfs_log_item_chunk_t *cp, int slot)
-{
-	cp->lic_descs[slot].lid_index = (unsigned char)(slot);
-}
-
-static inline int xfs_lic_vacancy(xfs_log_item_chunk_t *cp)
-{
-	return cp->lic_free & XFS_LIC_FREEMASK;
-}
-
-static inline void xfs_lic_all_free(xfs_log_item_chunk_t *cp)
-{
-	cp->lic_free = XFS_LIC_FREEMASK;
-}
-
-static inline int xfs_lic_are_all_free(xfs_log_item_chunk_t *cp)
-{
-	return ((cp->lic_free & XFS_LIC_FREEMASK) == XFS_LIC_FREEMASK);
-}
-
-static inline int xfs_lic_isfree(xfs_log_item_chunk_t *cp, int slot)
-{
-	return (cp->lic_free & (1 << slot));
-}
-
-static inline void xfs_lic_claim(xfs_log_item_chunk_t *cp, int slot)
-{
-	cp->lic_free &= ~(1 << slot);
-}
-
-static inline void xfs_lic_relse(xfs_log_item_chunk_t *cp, int slot)
-{
-	cp->lic_free |= 1 << slot;
-}
-
-static inline xfs_log_item_desc_t *
-xfs_lic_slot(xfs_log_item_chunk_t *cp, int slot)
-{
-	return &(cp->lic_descs[slot]);
-}
-
-static inline int xfs_lic_desc_to_slot(xfs_log_item_desc_t *dp)
-{
-	return (uint)dp->lid_index;
-}
-
-/*
- * Calculate the address of a chunk given a descriptor pointer:
- * dp - dp->lid_index give the address of the start of the lic_descs array.
- * From this we subtract the offset of the lic_descs field in a chunk.
- * All of this yields the address of the chunk, which is
- * cast to a chunk pointer.
- */
-static inline xfs_log_item_chunk_t *
-xfs_lic_desc_to_chunk(xfs_log_item_desc_t *dp)
-{
-	return (xfs_log_item_chunk_t*) \
-		(((xfs_caddr_t)((dp) - (dp)->lid_index)) - \
-		(xfs_caddr_t)(((xfs_log_item_chunk_t*)0)->lic_descs));
-}
 
 #define	XFS_TRANS_MAGIC		0x5452414E	/* 'TRAN' */
 /*
@@ -516,8 +425,7 @@ typedef struct xfs_trans {
 	int64_t			t_rblocks_delta;/* superblock rblocks change */
 	int64_t			t_rextents_delta;/* superblocks rextents chg */
 	int64_t			t_rextslog_delta;/* superblocks rextslog chg */
-	unsigned int		t_items_free;	/* log item descs free */
-	xfs_log_item_chunk_t	t_items;	/* first log item desc chunk */
+	struct list_head	t_items;	/* log item descriptors */
 	xfs_trans_header_t	t_header;	/* header for in-log trans */
 	struct list_head	t_busy;		/* list of busy extents */
 	unsigned long		t_pflags;	/* saved process flags state */
@@ -595,6 +503,7 @@ int		xfs_trans_ail_init(struct xfs_mount
 void		xfs_trans_ail_destroy(struct xfs_mount *);
 
 extern kmem_zone_t	*xfs_trans_zone;
+extern kmem_zone_t	*xfs_log_item_desc_zone;
 
 #endif	/* __KERNEL__ */
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
