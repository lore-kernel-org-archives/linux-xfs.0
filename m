Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 149F0C6FA8F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbjH2XUy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241146AbjH2XUr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:20:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37F9132
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 16:20:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 720C6632FC
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 23:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF670C433C9;
        Tue, 29 Aug 2023 23:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693351243;
        bh=FWJ9oE2DlfBA+KgvkuH1nerE6yLWJgfdq5qEHWdsvXg=;
        h=Date:From:To:Cc:Subject:From;
        b=oNhMOAV78VP7BsICXHEU08xMk+UFbcpvqpbVrYw+PYcWwIfohaNQKnG0z5InTsoH4
         JONKmoMVPRoTLGtt0YKmaS7hqtUQjINttn2Rr4j4+l6vpAQlZcF1ZNZh8RVCFW3FmO
         LVgQW9kQI5+urNAK4KgPlyKmGaqk237ciysbcxe2ZyjQZ+JsjgcFAfXpTBJgccvL0V
         kKbnB6E2g5o9WFP6SFUFlcwj1bDG6MoPicCA8/IIgOJV7F/cLantFgBu59No9mnBy6
         cub6bjj2NAdHfKhD3JUy+FiPU/D/Y/wFUB9KgCKLESA/e+melkKKwnkar8xuUwrvrM
         uzq41/eiStnqQ==
Date:   Tue, 29 Aug 2023 16:20:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        shrikanth hegde <sshegde@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: [RFC PATCH] xfs: load uncached unlinked inodes into memory on demand
Message-ID: <20230829232043.GE28186@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

shrikanth hegde reports that filesystems fail shortly after mount with
the following failure:

	WARNING: CPU: 56 PID: 12450 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]

This of course is the WARN_ON_ONCE in xfs_iunlink_lookup:

	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
	if (WARN_ON_ONCE(!ip || !ip->i_ino)) { ... }

From diagnostic data collected by the bug reporters, it would appear
that we cleanly mounted a filesystem that contained unlinked inodes.
Unlinked inodes are only processed as a final step of log recovery,
which means that clean mounts do not process the unlinked list at all.

Prior to the introduction of the incore unlinked lists, this wasn't a
problem because the unlink code would (very expensively) traverse the
entire ondisk metadata iunlink chain to keep things up to date.
However, the incore unlinked list code complains when it realizes that
it is out of sync with the ondisk metadata and shuts down the fs, which
is bad.

Ritesh proposed to solve this problem by unconditionally parsing the
unlinked lists at mount time, but this imposes a mount time cost for
every filesystem to catch something that should be very infrequent.
Instead, let's target the places where we can encounter a next_unlinked
pointer that refers to an inode that is not in cache, and load it into
cache.

Note: This patch does not address the problem of iget loading an inode
from the middle of the iunlink list and needing to set i_prev_unlinked
correctly.

Link: https://lore.kernel.org/linux-xfs/e5004868-4a03-93e5-5077-e7ed0e533996@linux.vnet.ibm.com/
Reported-by: shrikanth hegde <sshegde@linux.vnet.ibm.com>
Triaged-by: Ritesh Harjani <ritesh.list@gmail.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_trace.h |   25 +++++++++++++++++++
 2 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6ee266be45d4..3ab140ec09bb 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1829,12 +1829,17 @@ xfs_iunlink_lookup(
 
 	rcu_read_lock();
 	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
+	if (!ip) {
+		/* Caller can handle inode not being in memory. */
+		rcu_read_unlock();
+		return NULL;
+	}
 
 	/*
-	 * Inode not in memory or in RCU freeing limbo should not happen.
-	 * Warn about this and let the caller handle the failure.
+	 * Inode in RCU freeing limbo should not happen.  Warn about this and
+	 * let the caller handle the failure.
 	 */
-	if (WARN_ON_ONCE(!ip || !ip->i_ino)) {
+	if (WARN_ON_ONCE(!ip->i_ino)) {
 		rcu_read_unlock();
 		return NULL;
 	}
@@ -1902,6 +1907,60 @@ xfs_iunlink_update_bucket(
 	return 0;
 }
 
+/*
+ * Load the inode @next_agino into the cache and set its prev_unlinked pointer
+ * to @prev_agino.  Caller must hold the AGI to synchronize with other changes
+ * to the unlinked list.
+ */
+STATIC int
+xfs_iunlink_reload_next(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agibp,
+	xfs_agino_t		prev_agino,
+	xfs_agino_t		next_agino)
+{
+	struct xfs_perag	*pag = agibp->b_pag;
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_inode	*next_ip = NULL;
+	xfs_ino_t		ino;
+	int			error;
+
+	ASSERT(next_agino != NULLAGINO);
+
+#ifdef DEBUG
+	rcu_read_lock();
+	next_ip = radix_tree_lookup(&pag->pag_ici_root, next_agino);
+	ASSERT(next_ip == NULL);
+	rcu_read_unlock();
+#endif
+
+	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
+	error = xfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, 0, &next_ip);
+	if (error)
+		return error;
+
+	/* If this is not an unlinked inode, something is very wrong. */
+	if (VFS_I(next_ip)->i_nlink != 0) {
+		error = -EFSCORRUPTED;
+		goto rele;
+	}
+
+	next_ip->i_prev_unlinked = prev_agino;
+	trace_xfs_iunlink_reload_next(next_ip);
+rele:
+	/*
+	 * We're running in transaction context, so we cannot run any inode
+	 * release code.  Clear DONTCACHE on this inode to prevent the VFS from
+	 * initiating writeback and to force the irele to push this inode to
+	 * the LRU instead of dropping it immediately.
+	 */
+	spin_lock(&VFS_I(next_ip)->i_lock);
+	VFS_I(next_ip)->i_state &= ~I_DONTCACHE;
+	spin_unlock(&VFS_I(next_ip)->i_lock);
+	xfs_irele(next_ip);
+	return error;
+}
+
 static int
 xfs_iunlink_insert_inode(
 	struct xfs_trans	*tp,
@@ -1933,6 +1992,8 @@ xfs_iunlink_insert_inode(
 	 * inode.
 	 */
 	error = xfs_iunlink_update_backref(pag, agino, next_agino);
+	if (error == -ENOLINK)
+		error = xfs_iunlink_reload_next(tp, agibp, agino, next_agino);
 	if (error)
 		return error;
 
@@ -2027,6 +2088,9 @@ xfs_iunlink_remove_inode(
 	 */
 	error = xfs_iunlink_update_backref(pag, ip->i_prev_unlinked,
 			ip->i_next_unlinked);
+	if (error == -ENOLINK)
+		error = xfs_iunlink_reload_next(tp, agibp, ip->i_prev_unlinked,
+				ip->i_next_unlinked);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 36bd42ed9ec8..f4e46bac9b91 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3832,6 +3832,31 @@ TRACE_EVENT(xfs_iunlink_update_dinode,
 		  __entry->new_ptr)
 );
 
+TRACE_EVENT(xfs_iunlink_reload_next,
+	TP_PROTO(struct xfs_inode *ip),
+	TP_ARGS(ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, agino)
+		__field(xfs_agino_t, prev_agino)
+		__field(xfs_agino_t, next_agino)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
+		__entry->prev_agino = ip->i_prev_unlinked;
+		__entry->next_agino = ip->i_next_unlinked;
+	),
+	TP_printk("dev %d:%d agno 0x%x agino 0x%x prev_unlinked 0x%x next_unlinked 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agino,
+		  __entry->prev_agino,
+		  __entry->next_agino)
+);
+
 DECLARE_EVENT_CLASS(xfs_ag_inode_class,
 	TP_PROTO(struct xfs_inode *ip),
 	TP_ARGS(ip),
