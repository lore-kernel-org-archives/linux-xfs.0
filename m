Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D099DC47094
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 22:25:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACD6F6120F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 22:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhFGW0v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 18:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229997AbhFGW0v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Jun 2021 18:26:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93EF961040;
        Mon,  7 Jun 2021 22:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623104699;
        bh=ONVjuPGs6z1SVA3NgzmY7r+s+auPemWq1fslDvFrWRM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=s7SWF1+jlVR92GG2f7tTCNxm2BKHz9qlCnVwZLC/Bl83RX3A0PjfwuWxA/wTicEe8
         t2N5fjy9Yy+4gdh4YxhoQzqDRnAP8TkRJj9rXy40OjGYFw/b9sp1rG6sJlRRutMtF9
         3SRvbTUSJXvmVNzIWAWNEpx+BcWp8zs9S+JDQKPdgclZ0uz/oPh7E0Wmo2H34zY37K
         +SQi2kGvJiRypXWL5gCFeGHBh8sYz+zGv87KTYL3e8vi9CAvgu6MU4XBN24/VTqdQ4
         l7BN8SSuUBLXg/WMcHb3ydQq6LF+wbt8Px5jcRybcp19pmF7HwRze+Z+HoM9fEeVir
         X5uMnqPI5OiZg==
Subject: [PATCH 1/9] xfs: refactor the inode recycling code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Mon, 07 Jun 2021 15:24:59 -0700
Message-ID: <162310469929.3465262.17904743035514961089.stgit@locust>
In-Reply-To: <162310469340.3465262.504398465311182657.stgit@locust>
References: <162310469340.3465262.504398465311182657.stgit@locust>
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
 fs/xfs/xfs_icache.c |  139 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 81 insertions(+), 58 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 4e4682879bbd..4d4aa61fbd34 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -350,19 +350,19 @@ xfs_inew_wait(
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
 
@@ -376,6 +376,70 @@ xfs_reinit_inode(
 	return error;
 }
 
+/*
+ * Carefully nudge an inode whose VFS state has been torn down back into a
+ * usable state.  Drops the i_flags_lock and the rcu read lock.
+ */
+static int
+xfs_iget_recycle(
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip) __releases(&ip->i_flags_lock)
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
+		bool	wake;
+
+		/*
+		 * Re-initializing the inode failed, and we are in deep
+		 * trouble.  Try to re-add it to the reclaim list.
+		 */
+		rcu_read_lock();
+		spin_lock(&ip->i_flags_lock);
+		wake = !!__xfs_iflags_test(ip, XFS_INEW);
+		ip->i_flags &= ~(XFS_INEW | XFS_IRECLAIM);
+		if (wake)
+			wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
+		ASSERT(ip->i_flags & XFS_IRECLAIMABLE);
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
+	xfs_perag_clear_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
+			XFS_ICI_RECLAIM_TAG);
+	inode->i_state = I_NEW;
+	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&pag->pag_ici_lock);
+
+	return 0;
+}
+
 /*
  * If we are allocating a new inode, then check what was returned is
  * actually a free, empty inode. If we are not allocating an inode,
@@ -450,7 +514,7 @@ xfs_iget_cache_hit(
 	/*
 	 * If we are racing with another cache hit that is currently
 	 * instantiating this inode or currently recycling it out of
-	 * reclaimabe state, wait for the initialisation to complete
+	 * reclaimable state, wait for the initialisation to complete
 	 * before continuing.
 	 *
 	 * XXX(hch): eventually we should do something equivalent to
@@ -472,11 +536,11 @@ xfs_iget_cache_hit(
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
@@ -484,52 +548,12 @@ xfs_iget_cache_hit(
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
+		/* Drops i_flags_lock and RCU read lock. */
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
-		xfs_perag_clear_inode_tag(pag,
-				XFS_INO_TO_AGINO(pag->pag_mount, ino),
-				XFS_ICI_RECLAIM_TAG);
-		inode->i_state = I_NEW;
-		spin_unlock(&ip->i_flags_lock);
-		spin_unlock(&pag->pag_ici_lock);
 	} else {
 		/* If the VFS inode is being torn down, pause and try again. */
 		if (!igrab(inode)) {
@@ -559,7 +583,6 @@ xfs_iget_cache_hit(
 	return error;
 }
 
-
 static int
 xfs_iget_cache_miss(
 	struct xfs_mount	*mp,

