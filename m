Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E882BC433E3
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC49D619D3
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhCZAVn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230202AbhCZAVY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:21:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E56761A3C;
        Fri, 26 Mar 2021 00:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718084;
        bh=AJ72v+tVpnKcjiU4hWQoFbYR1+z4k0YugYA9S+c89pM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=D3rjGXYSiFCKPA3CBsJBhSbXlAXhioaczWNRDAEEKIq1VMMBKIEa3LXe/FfT2IemC
         CHpwYFrKWk0au/fgjbZFrzf0DskXUXQwYvbD59H3UMk+ntqlg+h5Mx2C1MxlAFgcwF
         U/ZzngP+aMfGCCb6a93Jig7iOiOgQL6aRetSoBxX7aUFjENkPBmSJrEBanN83K70QH
         CYdSfIgGFzx0XQBN5k2AqSqr6NVNyOBtfwrePCZykBpU+92SV9tyaUgzFQPcOlsAOV
         WazWPsilGdKGdUHoKqlijmm9qRO2dmKv6DkKHhq8qoGppgtmqWKH8vso4QODYFetJd
         PK+2NPyrt/eIg==
Subject: [PATCH 2/6] xfs: remove iter_flags parameter from xfs_inode_walk_*
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 25 Mar 2021 17:21:24 -0700
Message-ID: <161671808412.621936.9290234722714661435.stgit@magnolia>
In-Reply-To: <161671807287.621936.13471099564526590235.stgit@magnolia>
References: <161671807287.621936.13471099564526590235.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The sole iter_flags is XFS_INODE_WALK_INEW_WAIT, and there are no users.
Remove the flag, and the parameter, and all the code that used it.
Since there are no longer any external callers of xfs_inode_walk, make
it static.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   22 +++++++---------------
 fs/xfs/xfs_icache.h |    9 ---------
 2 files changed, 7 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9a307bb738bd..16392e96be91 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -730,11 +730,9 @@ xfs_icache_inode_is_allocated(
  */
 STATIC bool
 xfs_inode_walk_ag_grab(
-	struct xfs_inode	*ip,
-	int			flags)
+	struct xfs_inode	*ip)
 {
 	struct inode		*inode = VFS_I(ip);
-	bool			newinos = !!(flags & XFS_INODE_WALK_INEW_WAIT);
 
 	ASSERT(rcu_read_lock_held());
 
@@ -744,8 +742,7 @@ xfs_inode_walk_ag_grab(
 		goto out_unlock_noent;
 
 	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
-	if ((!newinos && __xfs_iflags_test(ip, XFS_INEW)) ||
-	    __xfs_iflags_test(ip, XFS_IRECLAIMABLE | XFS_IRECLAIM))
+	if (__xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM))
 		goto out_unlock_noent;
 	spin_unlock(&ip->i_flags_lock);
 
@@ -772,7 +769,6 @@ xfs_inode_walk_ag_grab(
 STATIC int
 xfs_inode_walk_ag(
 	struct xfs_perag	*pag,
-	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
 	void			*args,
 	int			tag)
@@ -818,7 +814,7 @@ xfs_inode_walk_ag(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (done || !xfs_inode_walk_ag_grab(ip, iter_flags))
+			if (done || !xfs_inode_walk_ag_grab(ip))
 				batch[i] = NULL;
 
 			/*
@@ -846,9 +842,6 @@ xfs_inode_walk_ag(
 		for (i = 0; i < nr_found; i++) {
 			if (!batch[i])
 				continue;
-			if ((iter_flags & XFS_INODE_WALK_INEW_WAIT) &&
-			    xfs_iflags_test(batch[i], XFS_INEW))
-				xfs_inew_wait(batch[i]);
 			error = execute(batch[i], args);
 			xfs_irele(batch[i]);
 			if (error == -EAGAIN) {
@@ -890,10 +883,9 @@ xfs_inode_walk_get_perag(
  * Call the @execute function on all incore inodes matching the radix tree
  * @tag.
  */
-int
+static int
 xfs_inode_walk(
 	struct xfs_mount	*mp,
-	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
 	void			*args,
 	int			tag)
@@ -906,7 +898,7 @@ xfs_inode_walk(
 	ag = 0;
 	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_walk_ag(pag, iter_flags, execute, args, tag);
+		error = xfs_inode_walk_ag(pag, execute, args, tag);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
@@ -1618,7 +1610,7 @@ xfs_blockgc_worker(
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	error = xfs_inode_walk_ag(pag, 0, xfs_blockgc_scan_inode, NULL,
+	error = xfs_inode_walk_ag(pag, xfs_blockgc_scan_inode, NULL,
 			XFS_ICI_BLOCKGC_TAG);
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
@@ -1637,7 +1629,7 @@ xfs_blockgc_free_space(
 {
 	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
 
-	return xfs_inode_walk(mp, 0, xfs_blockgc_scan_inode, eofb,
+	return xfs_inode_walk(mp, xfs_blockgc_scan_inode, eofb,
 			XFS_ICI_BLOCKGC_TAG);
 }
 
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d70d93c2bb10..d52c041093a3 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -34,11 +34,6 @@ struct xfs_eofblocks {
 #define XFS_IGET_DONTCACHE	0x4
 #define XFS_IGET_INCORE		0x8	/* don't read from disk or reinit */
 
-/*
- * flags for AG inode iterator
- */
-#define XFS_INODE_WALK_INEW_WAIT	0x1	/* wait on new inodes */
-
 int xfs_iget(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t ino,
 	     uint flags, uint lock_flags, xfs_inode_t **ipp);
 
@@ -68,10 +63,6 @@ void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
 
 void xfs_blockgc_worker(struct work_struct *work);
 
-int xfs_inode_walk(struct xfs_mount *mp, int iter_flags,
-	int (*execute)(struct xfs_inode *ip, void *args),
-	void *args, int tag);
-
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);
 

