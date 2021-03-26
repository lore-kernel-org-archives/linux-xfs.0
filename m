Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 077D9C433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA78C61A3C
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhCZAWO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:22:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230164AbhCZAVz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:21:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDC59619F3;
        Fri, 26 Mar 2021 00:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718114;
        bh=BjbVBiMZlzUgM1gI3PbSZk090bVrLGUUmK7/oefqhb0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ddaEWUNhgMuQ0oj+oH1xDn+vGb+E1xVaxyXo+y2bgpyCIpqHMzyOdApYVt7NyEi5K
         5VQzjNxolS7oVYKXKAkPWAJlz08wNznZD9YILhMnrw5CBxoa9/RvDZgC76lHp8MD7N
         KzHj8rmZTbeB5X4wpTGvxso5BG+EEDQKHpepaWg+VNJbDAs2IZ58W9Wzf4VDsG1hBU
         +cBlp4K2W5PxJZUm1qPfSI+8Yj4wV4KA9CrK3N+8iIzd4Josy6P0RgmZy0KyYDVaqn
         gx5ncFpLDg7FFh22p3p80e4Jo051t157PYbq10vojZ7+WAnWRYMZS7/Uxyt0ekfyi0
         YTEGnE9cj8edQ==
Subject: [PATCH 1/9] xfs: refactor the inode recycling code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 25 Mar 2021 17:21:54 -0700
Message-ID: <161671811446.622901.13774973473200855377.stgit@magnolia>
In-Reply-To: <161671810866.622901.16520335819131743716.stgit@magnolia>
References: <161671810866.622901.16520335819131743716.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Hoist the code in xfs_iget_cache_hit that restores the VFS inode state
to an xfs_inode that was previously vfs-destroyed.  The next patch will
add a new set of state flags, so we need the helper to avoid
duplication.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |  144 +++++++++++++++++++++++++++++----------------------
 1 file changed, 83 insertions(+), 61 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 4c124bc98f39..79f61a7f40b2 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -286,19 +286,19 @@ xfs_inew_wait(
  * need to retain across reinitialisation, and rewrite them into the VFS inode
  * after reinitialisation even if it fails.
  */
-static int
+static inline int
 xfs_reinit_inode(
 	struct xfs_mount	*mp,
 	struct inode		*inode)
 {
-	int		error;
-	uint32_t	nlink = inode->i_nlink;
-	uint32_t	generation = inode->i_generation;
-	uint64_t	version = inode_peek_iversion(inode);
-	umode_t		mode = inode->i_mode;
-	dev_t		dev = inode->i_rdev;
-	kuid_t		uid = inode->i_uid;
-	kgid_t		gid = inode->i_gid;
+	int			error;
+	uint32_t		nlink = inode->i_nlink;
+	uint32_t		generation = inode->i_generation;
+	uint64_t		version = inode_peek_iversion(inode);
+	umode_t			mode = inode->i_mode;
+	dev_t			dev = inode->i_rdev;
+	kuid_t			uid = inode->i_uid;
+	kgid_t			gid = inode->i_gid;
 
 	error = inode_init_always(mp->m_super, inode);
 
@@ -312,6 +312,73 @@ xfs_reinit_inode(
 	return error;
 }
 
+/*
+ * Carefully nudge an inode whose VFS state has been torn down back into a
+ * usable state.
+ */
+static int
+xfs_iget_recycle(
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct inode		*inode = VFS_I(ip);
+	int			error;
+
+	/*
+	 * We need to make it look like the inode is being reclaimed to prevent
+	 * the actual reclaim workers from stomping over us while we recycle
+	 * the inode.  We can't clear the radix tree tag yet as it requires
+	 * pag_ici_lock to be held exclusive.
+	 */
+	ip->i_flags |= XFS_IRECLAIM;
+
+	spin_unlock(&ip->i_flags_lock);
+	rcu_read_unlock();
+
+	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
+	error = xfs_reinit_inode(mp, inode);
+	if (error) {
+		bool		wake;
+
+		/*
+		 * Re-initializing the inode failed, and we are in deep
+		 * trouble.  Try to re-add it to the inactive list.
+		 */
+		rcu_read_lock();
+		spin_lock(&ip->i_flags_lock);
+		wake = !!__xfs_iflags_test(ip, XFS_INEW);
+		ip->i_flags &= ~(XFS_INEW | XFS_IRECLAIM);
+		if (wake)
+			wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
+		spin_unlock(&ip->i_flags_lock);
+		rcu_read_unlock();
+		return error;
+	}
+
+	spin_lock(&pag->pag_ici_lock);
+	spin_lock(&ip->i_flags_lock);
+
+	/*
+	 * Clear the per-lifetime state in the inode as we are now effectively
+	 * a new inode and need to return to the initial state before reuse
+	 * occurs.
+	 */
+	ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
+	ip->i_flags |= XFS_INEW;
+	xfs_perag_clear_ici_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
+			XFS_ICI_RECLAIM_TAG);
+	inode->i_state = I_NEW;
+
+	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
+	init_rwsem(&inode->i_rwsem);
+
+	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&pag->pag_ici_lock);
+
+	return 0;
+}
+
 /*
  * If we are allocating a new inode, then check what was returned is
  * actually a free, empty inode. If we are not allocating an inode,
@@ -386,7 +453,7 @@ xfs_iget_cache_hit(
 	/*
 	 * If we are racing with another cache hit that is currently
 	 * instantiating this inode or currently recycling it out of
-	 * reclaimabe state, wait for the initialisation to complete
+	 * reclaimable state, wait for the initialisation to complete
 	 * before continuing.
 	 *
 	 * XXX(hch): eventually we should do something equivalent to
@@ -408,11 +475,11 @@ xfs_iget_cache_hit(
 	if (error)
 		goto out_error;
 
-	/*
-	 * If IRECLAIMABLE is set, we've torn down the VFS inode already.
-	 * Need to carefully get it back into useable state.
-	 */
 	if (ip->i_flags & XFS_IRECLAIMABLE) {
+		/*
+		 * If IRECLAIMABLE is set, we've torn down the VFS inode
+		 * already, and must carefully restore it to usable state.
+		 */
 		trace_xfs_iget_reclaim(ip);
 
 		if (flags & XFS_IGET_INCORE) {
@@ -420,55 +487,11 @@ xfs_iget_cache_hit(
 			goto out_error;
 		}
 
-		/*
-		 * We need to set XFS_IRECLAIM to prevent xfs_reclaim_inode
-		 * from stomping over us while we recycle the inode.  We can't
-		 * clear the radix tree reclaimable tag yet as it requires
-		 * pag_ici_lock to be held exclusive.
-		 */
-		ip->i_flags |= XFS_IRECLAIM;
-
-		spin_unlock(&ip->i_flags_lock);
-		rcu_read_unlock();
-
-		ASSERT(!rwsem_is_locked(&inode->i_rwsem));
-		error = xfs_reinit_inode(mp, inode);
+		error = xfs_iget_recycle(pag, ip);
 		if (error) {
-			bool wake;
-			/*
-			 * Re-initializing the inode failed, and we are in deep
-			 * trouble.  Try to re-add it to the reclaim list.
-			 */
-			rcu_read_lock();
-			spin_lock(&ip->i_flags_lock);
-			wake = !!__xfs_iflags_test(ip, XFS_INEW);
-			ip->i_flags &= ~(XFS_INEW | XFS_IRECLAIM);
-			if (wake)
-				wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
-			ASSERT(ip->i_flags & XFS_IRECLAIMABLE);
 			trace_xfs_iget_reclaim_fail(ip);
-			goto out_error;
+			return error;
 		}
-
-		spin_lock(&pag->pag_ici_lock);
-		spin_lock(&ip->i_flags_lock);
-
-		/*
-		 * Clear the per-lifetime state in the inode as we are now
-		 * effectively a new inode and need to return to the initial
-		 * state before reuse occurs.
-		 */
-		ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
-		ip->i_flags |= XFS_INEW;
-		xfs_perag_clear_ici_tag(pag,
-				XFS_INO_TO_AGINO(pag->pag_mount, ino),
-				XFS_ICI_RECLAIM_TAG);
-		inode->i_state = I_NEW;
-		ip->i_sick = 0;
-		ip->i_checked = 0;
-
-		spin_unlock(&ip->i_flags_lock);
-		spin_unlock(&pag->pag_ici_lock);
 	} else {
 		/* If the VFS inode is being torn down, pause and try again. */
 		if (!igrab(inode)) {
@@ -498,7 +521,6 @@ xfs_iget_cache_hit(
 	return error;
 }
 
-
 static int
 xfs_iget_cache_miss(
 	struct xfs_mount	*mp,

