Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87896EB64DA
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 01:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjFPBh2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 21:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFPBh2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 21:37:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8582948
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 18:37:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C462761BCB
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 01:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21F4C433C0;
        Fri, 16 Jun 2023 01:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686879445;
        bh=XRHy5yhuy3KQtvIjHc0VxWkbMeX9tswBP+Wcs3yAQAw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o8u8bnH7tFb3GdszlnuQ3SUG9ZPMrGEkogt6TeP0SafDnqNOitXB2zsjgcOUBtB0j
         TGHvVpFxSC/rpK48sPWMGChnTRPEakFRiAufrhESeeal06HteJIxdL49f/+Q2VHv2+
         rJCzufegajs3d7Mv4oX7upEdliqwwm3UYVvYuvkf58MYEb31TI2/mP5PJv+9fP3feD
         HRMsojeKMSTw1Dl9r5GXIVONflscmPZdf3QS57VqifA3B0hmUqR7y/GQgfJAEqRT2q
         vMYidAAGOYAaK7UTdNkWb7GzJcvurlvfr6pCYADH2UCD6yjB7Poe1O5kTlWp8WLDgB
         zUlX8yiJEJVoA==
Subject: [PATCH 5/8] xfs: fix AGF vs inode cluster buffer deadlock
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Thu, 15 Jun 2023 18:37:24 -0700
Message-ID: <168687944448.831530.3926573287687741867.stgit@frogsfrogsfrogs>
In-Reply-To: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
References: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 82842fee6e5979ca7e2bf4d839ef890c22ffb7aa

Lock order in XFS is AGI -> AGF, hence for operations involving
inode unlinked list operations we always lock the AGI first. Inode
unlinked list operations operate on the inode cluster buffer,
so the lock order there is AGI -> inode cluster buffer.

For O_TMPFILE operations, this now means the lock order set down in
xfs_rename and xfs_link is AGI -> inode cluster buffer -> AGF as the
unlinked ops are done before the directory modifications that may
allocate space and lock the AGF.

Unfortunately, we also now lock the inode cluster buffer when
logging an inode so that we can attach the inode to the cluster
buffer and pin it in memory. This creates a lock order of AGF ->
inode cluster buffer in directory operations as we have to log the
inode after we've allocated new space for it.

This creates a lock inversion between the AGF and the inode cluster
buffer. Because the inode cluster buffer is shared across multiple
inodes, the inversion is not specific to individual inodes but can
occur when inodes in the same cluster buffer are accessed in
different orders.

To fix this we need move all the inode log item cluster buffer
interactions to the end of the current transaction. Unfortunately,
xfs_trans_log_inode() calls are littered throughout the transactions
with no thought to ordering against other items or locking. This
makes it difficult to do anything that involves changing the call
sites of xfs_trans_log_inode() to change locking orders.

However, we do now have a mechanism that allows is to postpone dirty
item processing to just before we commit the transaction: the
->iop_precommit method. This will be called after all the
modifications are done and high level objects like AGI and AGF
buffers have been locked and modified, thereby providing a mechanism
that guarantees we don't lock the inode cluster buffer before those
high level objects are locked.

This change is largely moving the guts of xfs_trans_log_inode() to
xfs_inode_item_precommit() and providing an extra flag context in
the inode log item to track the dirty state of the inode in the
current transaction. This also means we do a lot less repeated work
in xfs_trans_log_inode() by only doing it once per transaction when
all the work is done.

Fixes: 298f7bec503f ("xfs: pin inode backing buffer to the inode log item")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 include/xfs_inode.h      |    3 +
 include/xfs_trans.h      |    1 
 libxfs/logitem.c         |  154 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_log_format.h  |    9 ++-
 libxfs/xfs_trans_inode.c |  113 ++--------------------------------
 5 files changed, 173 insertions(+), 107 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index b0bba109..069fcf36 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -14,6 +14,7 @@
 struct xfs_trans;
 struct xfs_mount;
 struct xfs_inode_log_item;
+struct inode;
 
 /*
  * These are not actually used, they are only for userspace build
@@ -22,7 +23,7 @@ struct xfs_inode_log_item;
 #define I_DIRTY_TIME		0
 #define I_DIRTY_TIME_EXPIRED	0
 
-#define IS_I_VERSION(inode)			(0)
+static inline bool IS_I_VERSION(const struct inode *inode) { return false; }
 #define inode_maybe_inc_iversion(inode,flags)	(0)
 
 /*
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 64aade94..8371bc7e 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -38,6 +38,7 @@ struct xfs_inode_log_item {
 	xfs_log_item_t		ili_item;		/* common portion */
 	struct xfs_inode	*ili_inode;		/* inode pointer */
 	unsigned short		ili_lock_flags;		/* lock flags */
+	unsigned int		ili_dirty_flags;	/* dirty in current tx */
 	unsigned int		ili_last_fields;	/* fields when flushed*/
 	unsigned int		ili_fields;		/* fields to be logged */
 	unsigned int		ili_fsync_fields;	/* ignored by userspace */
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 6b3315c3..48928f32 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -130,7 +130,161 @@ xfs_buf_item_log(
 	bip->bli_flags |= XFS_BLI_DIRTY;
 }
 
+static inline struct xfs_inode_log_item *INODE_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_inode_log_item, ili_item);
+}
+
+static uint64_t
+xfs_inode_item_sort(
+	struct xfs_log_item	*lip)
+{
+	return INODE_ITEM(lip)->ili_inode->i_ino;
+}
+
+/*
+ * Prior to finally logging the inode, we have to ensure that all the
+ * per-modification inode state changes are applied. This includes VFS inode
+ * state updates, format conversions, verifier state synchronisation and
+ * ensuring the inode buffer remains in memory whilst the inode is dirty.
+ *
+ * We have to be careful when we grab the inode cluster buffer due to lock
+ * ordering constraints. The unlinked inode modifications (xfs_iunlink_item)
+ * require AGI -> inode cluster buffer lock order. The inode cluster buffer is
+ * not locked until ->precommit, so it happens after everything else has been
+ * modified.
+ *
+ * Further, we have AGI -> AGF lock ordering, and with O_TMPFILE handling we
+ * have AGI -> AGF -> iunlink item -> inode cluster buffer lock order. Hence we
+ * cannot safely lock the inode cluster buffer in xfs_trans_log_inode() because
+ * it can be called on a inode (e.g. via bumplink/droplink) before we take the
+ * AGF lock modifying directory blocks.
+ *
+ * Rather than force a complete rework of all the transactions to call
+ * xfs_trans_log_inode() once and once only at the end of every transaction, we
+ * move the pinning of the inode cluster buffer to a ->precommit operation. This
+ * matches how the xfs_iunlink_item locks the inode cluster buffer, and it
+ * ensures that the inode cluster buffer locking is always done last in a
+ * transaction. i.e. we ensure the lock order is always AGI -> AGF -> inode
+ * cluster buffer.
+ *
+ * If we return the inode number as the precommit sort key then we'll also
+ * guarantee that the order all inode cluster buffer locking is the same all the
+ * inodes and unlink items in the transaction.
+ */
+static int
+xfs_inode_item_precommit(
+	struct xfs_trans	*tp,
+	struct xfs_log_item	*lip)
+{
+	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+	struct xfs_inode	*ip = iip->ili_inode;
+	struct inode		*inode = VFS_I(ip);
+	unsigned int		flags = iip->ili_dirty_flags;
+
+	/*
+	 * Don't bother with i_lock for the I_DIRTY_TIME check here, as races
+	 * don't matter - we either will need an extra transaction in 24 hours
+	 * to log the timestamps, or will clear already cleared fields in the
+	 * worst case.
+	 */
+	if (inode->i_state & I_DIRTY_TIME) {
+		spin_lock(&inode->i_lock);
+		inode->i_state &= ~I_DIRTY_TIME;
+		spin_unlock(&inode->i_lock);
+	}
+
+	/*
+	 * If we're updating the inode core or the timestamps and it's possible
+	 * to upgrade this inode to bigtime format, do so now.
+	 */
+	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
+	    xfs_has_bigtime(ip->i_mount) &&
+	    !xfs_inode_has_bigtime(ip)) {
+		ip->i_diflags2 |= XFS_DIFLAG2_BIGTIME;
+		flags |= XFS_ILOG_CORE;
+	}
+
+	/*
+	 * Inode verifiers do not check that the extent size hint is an integer
+	 * multiple of the rt extent size on a directory with both rtinherit
+	 * and extszinherit flags set.  If we're logging a directory that is
+	 * misconfigured in this way, clear the hint.
+	 */
+	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
+	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
+	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
+		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
+				   XFS_DIFLAG_EXTSZINHERIT);
+		ip->i_extsize = 0;
+		flags |= XFS_ILOG_CORE;
+	}
+
+	/*
+	 * Record the specific change for fdatasync optimisation. This allows
+	 * fdatasync to skip log forces for inodes that are only timestamp
+	 * dirty. Once we've processed the XFS_ILOG_IVERSION flag, convert it
+	 * to XFS_ILOG_CORE so that the actual on-disk dirty tracking
+	 * (ili_fields) correctly tracks that the version has changed.
+	 */
+	spin_lock(&iip->ili_lock);
+	iip->ili_fsync_fields |= (flags & ~XFS_ILOG_IVERSION);
+	if (flags & XFS_ILOG_IVERSION)
+		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
+
+	if (!iip->ili_item.li_buf) {
+		struct xfs_buf	*bp;
+		int		error;
+
+		/*
+		 * We hold the ILOCK here, so this inode is not going to be
+		 * flushed while we are here. Further, because there is no
+		 * buffer attached to the item, we know that there is no IO in
+		 * progress, so nothing will clear the ili_fields while we read
+		 * in the buffer. Hence we can safely drop the spin lock and
+		 * read the buffer knowing that the state will not change from
+		 * here.
+		 */
+		spin_unlock(&iip->ili_lock);
+		error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, &bp);
+		if (error)
+			return error;
+
+		/*
+		 * We need an explicit buffer reference for the log item but
+		 * don't want the buffer to remain attached to the transaction.
+		 * Hold the buffer but release the transaction reference once
+		 * we've attached the inode log item to the buffer log item
+		 * list.
+		 */
+		xfs_buf_hold(bp);
+		spin_lock(&iip->ili_lock);
+		iip->ili_item.li_buf = bp;
+		bp->b_flags |= _XBF_INODES;
+		list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
+		xfs_trans_brelse(tp, bp);
+	}
+
+	/*
+	 * Always OR in the bits from the ili_last_fields field.  This is to
+	 * coordinate with the xfs_iflush() and xfs_buf_inode_iodone() routines
+	 * in the eventual clearing of the ili_fields bits.  See the big comment
+	 * in xfs_iflush() for an explanation of this coordination mechanism.
+	 */
+	iip->ili_fields |= (flags | iip->ili_last_fields);
+	spin_unlock(&iip->ili_lock);
+
+	/*
+	 * We are done with the log item transaction dirty state, so clear it so
+	 * that it doesn't pollute future transactions.
+	 */
+	iip->ili_dirty_flags = 0;
+	return 0;
+}
+
 static const struct xfs_item_ops xfs_inode_item_ops = {
+	.iop_sort	= xfs_inode_item_sort,
+	.iop_precommit	= xfs_inode_item_precommit,
 };
 
 /*
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index f13e0809..269573c8 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -324,7 +324,6 @@ struct xfs_inode_log_format_32 {
 #define XFS_ILOG_DOWNER	0x200	/* change the data fork owner on replay */
 #define XFS_ILOG_AOWNER	0x400	/* change the attr fork owner on replay */
 
-
 /*
  * The timestamps are dirty, but not necessarily anything else in the inode
  * core.  Unlike the other fields above this one must never make it to disk
@@ -333,6 +332,14 @@ struct xfs_inode_log_format_32 {
  */
 #define XFS_ILOG_TIMESTAMP	0x4000
 
+/*
+ * The version field has been changed, but not necessarily anything else of
+ * interest. This must never make it to disk - it is used purely to ensure that
+ * the inode item ->precommit operation can update the fsync flag triggers
+ * in the inode item correctly.
+ */
+#define XFS_ILOG_IVERSION	0x8000
+
 #define	XFS_ILOG_NONCORE	(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
 				 XFS_ILOG_DBROOT | XFS_ILOG_DEV | \
 				 XFS_ILOG_ADATA | XFS_ILOG_AEXT | \
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index 276d57cf..c4f81e5d 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -37,9 +37,8 @@ xfs_trans_ijoin(
 	iip->ili_lock_flags = lock_flags;
 	ASSERT(!xfs_iflags_test(ip, XFS_ISTALE));
 
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
+	/* Reset the per-tx dirty context and add the item to the tx. */
+	iip->ili_dirty_flags = 0;
 	xfs_trans_add_item(tp, &iip->ili_item);
 }
 
@@ -73,17 +72,10 @@ xfs_trans_ichgtime(
 /*
  * This is called to mark the fields indicated in fieldmask as needing to be
  * logged when the transaction is committed.  The inode must already be
- * associated with the given transaction.
- *
- * The values for fieldmask are defined in xfs_inode_item.h.  We always log all
- * of the core inode if any of it has changed, and we always log all of the
- * inline data/extents/b-tree root if any of them has changed.
- *
- * Grab and pin the cluster buffer associated with this inode to avoid RMW
- * cycles at inode writeback time. Avoid the need to add error handling to every
- * xfs_trans_log_inode() call by shutting down on read error.  This will cause
- * transactions to fail and everything to error out, just like if we return a
- * read error in a dirty transaction and cancel it.
+ * associated with the given transaction. All we do here is record where the
+ * inode was dirtied and mark the transaction and inode log item dirty;
+ * everything else is done in the ->precommit log item operation after the
+ * changes in the transaction have been completed.
  */
 void
 xfs_trans_log_inode(
@@ -93,7 +85,6 @@ xfs_trans_log_inode(
 {
 	struct xfs_inode_log_item *iip = ip->i_itemp;
 	struct inode		*inode = VFS_I(ip);
-	uint			iversion_flags = 0;
 
 	ASSERT(iip);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
@@ -101,18 +92,6 @@ xfs_trans_log_inode(
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
 
-	/*
-	 * Don't bother with i_lock for the I_DIRTY_TIME check here, as races
-	 * don't matter - we either will need an extra transaction in 24 hours
-	 * to log the timestamps, or will clear already cleared fields in the
-	 * worst case.
-	 */
-	if (inode->i_state & I_DIRTY_TIME) {
-		spin_lock(&inode->i_lock);
-		inode->i_state &= ~I_DIRTY_TIME;
-		spin_unlock(&inode->i_lock);
-	}
-
 	/*
 	 * First time we log the inode in a transaction, bump the inode change
 	 * counter if it is configured for this to occur. While we have the
@@ -125,86 +104,10 @@ xfs_trans_log_inode(
 	if (!test_and_set_bit(XFS_LI_DIRTY, &iip->ili_item.li_flags)) {
 		if (IS_I_VERSION(inode) &&
 		    inode_maybe_inc_iversion(inode, flags & XFS_ILOG_CORE))
-			iversion_flags = XFS_ILOG_CORE;
+			flags |= XFS_ILOG_IVERSION;
 	}
 
-	/*
-	 * If we're updating the inode core or the timestamps and it's possible
-	 * to upgrade this inode to bigtime format, do so now.
-	 */
-	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
-	    xfs_has_bigtime(ip->i_mount) &&
-	    !xfs_inode_has_bigtime(ip)) {
-		ip->i_diflags2 |= XFS_DIFLAG2_BIGTIME;
-		flags |= XFS_ILOG_CORE;
-	}
-
-	/*
-	 * Inode verifiers do not check that the extent size hint is an integer
-	 * multiple of the rt extent size on a directory with both rtinherit
-	 * and extszinherit flags set.  If we're logging a directory that is
-	 * misconfigured in this way, clear the hint.
-	 */
-	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
-	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
-	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
-		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
-				   XFS_DIFLAG_EXTSZINHERIT);
-		ip->i_extsize = 0;
-		flags |= XFS_ILOG_CORE;
-	}
-
-	/*
-	 * Record the specific change for fdatasync optimisation. This allows
-	 * fdatasync to skip log forces for inodes that are only timestamp
-	 * dirty.
-	 */
-	spin_lock(&iip->ili_lock);
-	iip->ili_fsync_fields |= flags;
-
-	if (!iip->ili_item.li_buf) {
-		struct xfs_buf	*bp;
-		int		error;
-
-		/*
-		 * We hold the ILOCK here, so this inode is not going to be
-		 * flushed while we are here. Further, because there is no
-		 * buffer attached to the item, we know that there is no IO in
-		 * progress, so nothing will clear the ili_fields while we read
-		 * in the buffer. Hence we can safely drop the spin lock and
-		 * read the buffer knowing that the state will not change from
-		 * here.
-		 */
-		spin_unlock(&iip->ili_lock);
-		error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, &bp);
-		if (error) {
-			xfs_force_shutdown(ip->i_mount, SHUTDOWN_META_IO_ERROR);
-			return;
-		}
-
-		/*
-		 * We need an explicit buffer reference for the log item but
-		 * don't want the buffer to remain attached to the transaction.
-		 * Hold the buffer but release the transaction reference once
-		 * we've attached the inode log item to the buffer log item
-		 * list.
-		 */
-		xfs_buf_hold(bp);
-		spin_lock(&iip->ili_lock);
-		iip->ili_item.li_buf = bp;
-		bp->b_flags |= _XBF_INODES;
-		list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
-		xfs_trans_brelse(tp, bp);
-	}
-
-	/*
-	 * Always OR in the bits from the ili_last_fields field.  This is to
-	 * coordinate with the xfs_iflush() and xfs_buf_inode_iodone() routines
-	 * in the eventual clearing of the ili_fields bits.  See the big comment
-	 * in xfs_iflush() for an explanation of this coordination mechanism.
-	 */
-	iip->ili_fields |= (flags | iip->ili_last_fields | iversion_flags);
-	spin_unlock(&iip->ili_lock);
+	iip->ili_dirty_flags |= flags;
 }
 
 int

