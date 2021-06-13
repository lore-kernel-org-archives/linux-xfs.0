Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26479C48BCF
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED62361284
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhFMRWE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 13 Jun 2021 13:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231915AbhFMRWE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 13 Jun 2021 13:22:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADA1661078;
        Sun, 13 Jun 2021 17:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623604802;
        bh=V2R6VpMA805DF/IiZD0t7l8tdX/48BvUPgC4EPk0aEY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NP58FwX8dnV5Sh9wNrPJmGC20k0SLGOwhOaw/H/kkLKnCL8S3ncAsWR/CsJzq8ncM
         qWKFveeYyzVnmzLgh+HcyyMujvtPsW9CBiXvhw2wbqsf2vhk7aass3xyUbZINtFsSf
         1YJC1oSVzCCXSt1E9A5L+47vZpmQqChom/p+yikRXM5wTH3a1qkTvfkCotz1LMiEu/
         eFjgTM+szsTpdUnNUAFuj6CgiFa4BTlrDhlTj7QjaHDhq67ZgDfkokA+0U0wzQyQJw
         c+4vSX5IlC5OGXg68iEbImsop8xP5S4usQV+XXwJpB18unMZdRH44w3V/P0sX5ljwp
         d3jmT4XlfQXSw==
Subject: [PATCH 01/16] xfs: refactor the inode recycling code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org, bfoster@redhat.com
Date:   Sun, 13 Jun 2021 10:20:02 -0700
Message-ID: <162360480240.1530792.10821283161255096063.stgit@locust>
In-Reply-To: <162360479631.1530792.17147217854887531696.stgit@locust>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c |  143 +++++++++++++++++++++++++++++----------------------
 fs/xfs/xfs_trace.h  |    4 +
 2 files changed, 83 insertions(+), 64 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 4e4682879bbd..37229517c8f7 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -355,14 +355,14 @@ xfs_reinit_inode(
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
 
@@ -376,6 +376,74 @@ xfs_reinit_inode(
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
+	trace_xfs_iget_recycle(ip);
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
+
+		trace_xfs_iget_recycle_fail(ip);
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
@@ -450,7 +518,7 @@ xfs_iget_cache_hit(
 	/*
 	 * If we are racing with another cache hit that is currently
 	 * instantiating this inode or currently recycling it out of
-	 * reclaimabe state, wait for the initialisation to complete
+	 * reclaimable state, wait for the initialisation to complete
 	 * before continuing.
 	 *
 	 * XXX(hch): eventually we should do something equivalent to
@@ -472,64 +540,16 @@ xfs_iget_cache_hit(
 	if (error)
 		goto out_error;
 
-	/*
-	 * If IRECLAIMABLE is set, we've torn down the VFS inode already.
-	 * Need to carefully get it back into useable state.
-	 */
 	if (ip->i_flags & XFS_IRECLAIMABLE) {
-		trace_xfs_iget_reclaim(ip);
-
 		if (flags & XFS_IGET_INCORE) {
 			error = -EAGAIN;
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
-		if (error) {
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
-			trace_xfs_iget_reclaim_fail(ip);
-			goto out_error;
-		}
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
+		/* Drops i_flags_lock and RCU read lock. */
+		error = xfs_iget_recycle(pag, ip);
+		if (error)
+			return error;
 	} else {
 		/* If the VFS inode is being torn down, pause and try again. */
 		if (!igrab(inode)) {
@@ -559,7 +579,6 @@ xfs_iget_cache_hit(
 	return error;
 }
 
-
 static int
 xfs_iget_cache_miss(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a10612155377..d0b4799ad1e6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -630,8 +630,8 @@ DEFINE_EVENT(xfs_inode_class, name, \
 	TP_PROTO(struct xfs_inode *ip), \
 	TP_ARGS(ip))
 DEFINE_INODE_EVENT(xfs_iget_skip);
-DEFINE_INODE_EVENT(xfs_iget_reclaim);
-DEFINE_INODE_EVENT(xfs_iget_reclaim_fail);
+DEFINE_INODE_EVENT(xfs_iget_recycle);
+DEFINE_INODE_EVENT(xfs_iget_recycle_fail);
 DEFINE_INODE_EVENT(xfs_iget_hit);
 DEFINE_INODE_EVENT(xfs_iget_miss);
 

