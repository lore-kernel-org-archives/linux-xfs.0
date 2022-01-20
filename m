Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81BB7C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345209AbiATAXZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:23:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59928 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240495AbiATAXY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:23:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38D9661515
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7F4C004E1;
        Thu, 20 Jan 2022 00:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638203;
        bh=/kpl9NPpfxagooowStok9BODKRRebKbb/MA65iSv4mE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hzDnUyddUWAk3tOpCE8Thp7kleqF66654sxSNcn4efMQPjI7zvOLs8widbcZDoHlG
         f4eKA+0b08zz1aZZnEvCsCAnphG3Ux1SNsg5n8Te+mAPxwjAMCnHxg5iKVKvX3Fjdv
         nSElrq8p8d9EIMbTZR2O2xyItdz9oyGdsVsh52DI0MEI6FF3NPVC9MALAv1RYx+zce
         gkVoteutLX7PvqjhuQg1M6oJDEK4Q8TeIkdQK+WWWNuqEV2TAHnSXS7dnAJc6QdZKY
         WWy5UG1kXxc4xDy0bEUTtqqRezOf8pnVNkdnxyj8G4RM+Mh0ub5oRAIHJXl8FUKHE7
         jkNeqvIFhzFbQ==
Subject: [PATCH 02/48] xfs: port the defer ops capture and continue to
 resource capture
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:23:23 -0800
Message-ID: <164263820326.865554.8930683632348589030.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 512edfac85d243ed6a5a5f42f513ebb7c2d32863

When log recovery tries to recover a transaction that had log intent
items attached to it, it has to save certain parts of the transaction
state (reservation, dfops chain, inodes with no automatic unlock) so
that it can finish single-stepping the recovered transactions before
finishing the chains.

This is done with the xfs_defer_ops_capture and xfs_defer_ops_continue
functions.  Right now they open-code this functionality, so let's port
this to the formalized resource capture structure that we introduced in
the previous patch.  This enables us to hold up to two inodes and two
buffers during log recovery, the same way we do for regular runtime.

With this patch applied, we'll be ready to support atomic extent swap
which holds two inodes; and logged xattrs which holds one inode and one
xattr leaf buffer.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_priv.h |    2 +
 libxfs/xfs_defer.c   |   86 ++++++++++++++++++++++++++++++++++++++------------
 libxfs/xfs_defer.h   |   14 +++-----
 3 files changed, 73 insertions(+), 29 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index b94ff41e..466865f7 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -468,6 +468,8 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 	__mode = __mode; /* no set-but-unused warning */	\
 })
 
+#define xfs_lock_two_inodes(ip1, mode1, ip2, mode2)	((void) 0)
+
 /* space allocation */
 #define XFS_EXTENT_BUSY_DISCARDED	0x01	/* undergoing a discard op. */
 #define XFS_EXTENT_BUSY_SKIP_DISCARD	0x02	/* do not discard */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 35f51f87..40d49abc 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -646,10 +646,11 @@ xfs_defer_move(
  */
 static struct xfs_defer_capture *
 xfs_defer_ops_capture(
-	struct xfs_trans		*tp,
-	struct xfs_inode		*capture_ip)
+	struct xfs_trans		*tp)
 {
 	struct xfs_defer_capture	*dfc;
+	unsigned short			i;
+	int				error;
 
 	if (list_empty(&tp->t_dfops))
 		return NULL;
@@ -673,27 +674,48 @@ xfs_defer_ops_capture(
 	/* Preserve the log reservation size. */
 	dfc->dfc_logres = tp->t_log_res;
 
+	error = xfs_defer_save_resources(&dfc->dfc_held, tp);
+	if (error) {
+		/*
+		 * Resource capture should never fail, but if it does, we
+		 * still have to shut down the log and release things
+		 * properly.
+		 */
+		xfs_force_shutdown(tp->t_mountp, SHUTDOWN_CORRUPT_INCORE);
+	}
+
 	/*
-	 * Grab an extra reference to this inode and attach it to the capture
-	 * structure.
+	 * Grab extra references to the inodes and buffers because callers are
+	 * expected to release their held references after we commit the
+	 * transaction.
 	 */
-	if (capture_ip) {
-		ihold(VFS_I(capture_ip));
-		dfc->dfc_capture_ip = capture_ip;
+	for (i = 0; i < dfc->dfc_held.dr_inos; i++) {
+		ASSERT(xfs_isilocked(dfc->dfc_held.dr_ip[i], XFS_ILOCK_EXCL));
+		ihold(VFS_I(dfc->dfc_held.dr_ip[i]));
 	}
 
+	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
+		xfs_buf_hold(dfc->dfc_held.dr_bp[i]);
+
 	return dfc;
 }
 
 /* Release all resources that we used to capture deferred ops. */
 void
-xfs_defer_ops_release(
+xfs_defer_ops_capture_free(
 	struct xfs_mount		*mp,
 	struct xfs_defer_capture	*dfc)
 {
+	unsigned short			i;
+
 	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
-	if (dfc->dfc_capture_ip)
-		xfs_irele(dfc->dfc_capture_ip);
+
+	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
+		xfs_buf_relse(dfc->dfc_held.dr_bp[i]);
+
+	for (i = 0; i < dfc->dfc_held.dr_inos; i++)
+		xfs_irele(dfc->dfc_held.dr_ip[i]);
+
 	kmem_free(dfc);
 }
 
@@ -708,24 +730,21 @@ xfs_defer_ops_release(
 int
 xfs_defer_ops_capture_and_commit(
 	struct xfs_trans		*tp,
-	struct xfs_inode		*capture_ip,
 	struct list_head		*capture_list)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_defer_capture	*dfc;
 	int				error;
 
-	ASSERT(!capture_ip || xfs_isilocked(capture_ip, XFS_ILOCK_EXCL));
-
 	/* If we don't capture anything, commit transaction and exit. */
-	dfc = xfs_defer_ops_capture(tp, capture_ip);
+	dfc = xfs_defer_ops_capture(tp);
 	if (!dfc)
 		return xfs_trans_commit(tp);
 
 	/* Commit the transaction and add the capture structure to the list. */
 	error = xfs_trans_commit(tp);
 	if (error) {
-		xfs_defer_ops_release(mp, dfc);
+		xfs_defer_ops_capture_free(mp, dfc);
 		return error;
 	}
 
@@ -743,17 +762,19 @@ void
 xfs_defer_ops_continue(
 	struct xfs_defer_capture	*dfc,
 	struct xfs_trans		*tp,
-	struct xfs_inode		**captured_ipp)
+	struct xfs_defer_resources	*dres)
 {
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
 	/* Lock and join the captured inode to the new transaction. */
-	if (dfc->dfc_capture_ip) {
-		xfs_ilock(dfc->dfc_capture_ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, dfc->dfc_capture_ip, 0);
-	}
-	*captured_ipp = dfc->dfc_capture_ip;
+	if (dfc->dfc_held.dr_inos == 2)
+		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
+				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
+	else if (dfc->dfc_held.dr_inos == 1)
+		xfs_ilock(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL);
+	xfs_defer_restore_resources(tp, &dfc->dfc_held);
+	memcpy(dres, &dfc->dfc_held, sizeof(struct xfs_defer_resources));
 
 	/* Move captured dfops chain and state to the transaction. */
 	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
@@ -761,3 +782,26 @@ xfs_defer_ops_continue(
 
 	kmem_free(dfc);
 }
+
+/* Release the resources captured and continued during recovery. */
+void
+xfs_defer_resources_rele(
+	struct xfs_defer_resources	*dres)
+{
+	unsigned short			i;
+
+	for (i = 0; i < dres->dr_inos; i++) {
+		xfs_iunlock(dres->dr_ip[i], XFS_ILOCK_EXCL);
+		xfs_irele(dres->dr_ip[i]);
+		dres->dr_ip[i] = NULL;
+	}
+
+	for (i = 0; i < dres->dr_bufs; i++) {
+		xfs_buf_relse(dres->dr_bp[i]);
+		dres->dr_bp[i] = NULL;
+	}
+
+	dres->dr_inos = 0;
+	dres->dr_bufs = 0;
+	dres->dr_ordered = 0;
+}
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index e095abb9..7952695c 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -107,11 +107,7 @@ struct xfs_defer_capture {
 	/* Log reservation saved from the transaction. */
 	unsigned int		dfc_logres;
 
-	/*
-	 * An inode reference that must be maintained to complete the deferred
-	 * work.
-	 */
-	struct xfs_inode	*dfc_capture_ip;
+	struct xfs_defer_resources dfc_held;
 };
 
 /*
@@ -119,9 +115,11 @@ struct xfs_defer_capture {
  * This doesn't normally happen except log recovery.
  */
 int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
-		struct xfs_inode *capture_ip, struct list_head *capture_list);
+		struct list_head *capture_list);
 void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp,
-		struct xfs_inode **captured_ipp);
-void xfs_defer_ops_release(struct xfs_mount *mp, struct xfs_defer_capture *d);
+		struct xfs_defer_resources *dres);
+void xfs_defer_ops_capture_free(struct xfs_mount *mp,
+		struct xfs_defer_capture *d);
+void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
 
 #endif /* __XFS_DEFER_H__ */

