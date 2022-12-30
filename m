Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7259C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbiL3X2o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiL3X2l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:28:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4BE1DDE1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:28:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE5D2B81DAD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EFFC433EF;
        Fri, 30 Dec 2022 23:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442917;
        bh=s2Gys8DQWyH//Ue9ZqWtTy4AmNHWIz3AEjLZ2VjeTtc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CW8MhRHMcw4EnjfczOUuPc2ZfXPAjUPQsUjQdiHSxVJ9QXoXh5Oq2av1BQJe2OOHA
         EbSwHZgMlF9QoMwKfnKxWLQNpFMjGn+HW6fqA/3XfGBJsZb+9tZBtq75CXjaQ4vNYG
         EMA2UT1tm3Ak7owVYK8IGg5AErNYDcH7RdXnm0UMQwAZzICv4YL//itxVbDzVseO8z
         DIuUuUDx/U1+H1W8mKsOHWEUdC8D+5bASBBsDtZcK9EDx9/ej/jtXuGcWdaH53QUNd
         NCixwZj0V3nvDplMAfGuvnWYffZw8tPML/KkFm22JP6v6SHKnuBT3USLj15RunwtuX
         xmAmvqskgbx2Q==
Subject: [PATCH 3/5] xfs: rewrite xfs_icache_inode_is_allocated
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:49 -0800
Message-ID: <167243836910.693494.5549987035106074962.stgit@magnolia>
In-Reply-To: <167243836860.693494.7976721071711129282.stgit@magnolia>
References: <167243836860.693494.7976721071711129282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Back in the mists of time[1], I proposed this function to assist the
inode btree scrubbers in checking the inode btree contents against the
allocation state of the inode records.  The original version performed a
direct lookup in the inode cache and returned the allocation status if
the cached inode hadn't been reused and wasn't in an intermediate state.
Brian thought it would be better to use the usual iget/irele mechanisms,
so that was changed for the final version.

Unfortunately, this hasn't aged well -- the IGET_INCORE flag only has
one user and clutters up the regular iget path, which makes it hard to
reason about how it actually works.  Worse yet, the inode inactivation
series silently broke it because iget won't return inodes that are
anywhere in the inactivation machinery, even though the caller is
already required to prevent inode allocation and freeing.  Inodes in the
inactivation machinery are still allocated, but the current code's
interactions with the iget code prevent us from being able to say that.

Now that I understand the inode lifecycle better than I did in early
2017, I now realize that as long as the cached inode hasn't been reused
and isn't actively being reclaimed, it's safe to access the i_mode field
(with the AGI, rcu, and i_flags locks held), and we don't need to worry
about the inode being freed out from under us.

Therefore, port the original version to modern code structure, which
fixes the brokennes w.r.t. inactivation.  In the next patch we'll remove
IGET_INCORE since it's no longer necessary.

[1] https://lore.kernel.org/linux-xfs/149643868294.23065.8094890990886436794.stgit@birch.djwong.org/

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |  122 +++++++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_trace.h  |   22 +++++++++
 2 files changed, 124 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0d58d7b0d8ac..c602c0f98053 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -777,23 +777,23 @@ xfs_iget(
 }
 
 /*
- * "Is this a cached inode that's also allocated?"
+ * Decide if this is this a cached inode that's also allocated.  The caller
+ * must hold the AGI buffer lock to prevent inodes from being allocated or
+ * freed.
  *
- * Look up an inode by number in the given file system.  If the inode is
- * in cache and isn't in purgatory, return 1 if the inode is allocated
- * and 0 if it is not.  For all other cases (not in cache, being torn
- * down, etc.), return a negative error code.
+ * Look up an inode by number in the given file system.  If the inode number
+ * is invalid, return -EINVAL.  If the inode is not in cache, return -ENODATA.
+ * If the inode is in an intermediate state (new, being reclaimed, reused) then
+ * return -EAGAIN.
  *
- * The caller has to prevent inode allocation and freeing activity,
- * presumably by locking the AGI buffer.   This is to ensure that an
- * inode cannot transition from allocated to freed until the caller is
- * ready to allow that.  If the inode is in an intermediate state (new,
- * reclaimable, or being reclaimed), -EAGAIN will be returned; if the
- * inode is not in the cache, -ENOENT will be returned.  The caller must
- * deal with these scenarios appropriately.
+ * Otherwise, the incore inode is the one we want, and it is either live,
+ * somewhere in the inactivation machinery, or reclaimable.  The inode is
+ * allocated if i_mode is nonzero.  In all three cases, the cached inode will
+ * be more up to date than the ondisk inode buffer, so we must use the incore
+ * i_mode.
  *
- * This is a specialized use case for the online scrubber; if you're
- * reading this, you probably want xfs_iget.
+ * This is a specialized use case for the online fsck; if you're reading this,
+ * you probably want xfs_iget.
  */
 int
 xfs_icache_inode_is_allocated(
@@ -803,15 +803,97 @@ xfs_icache_inode_is_allocated(
 	bool			*inuse)
 {
 	struct xfs_inode	*ip;
+	struct xfs_perag	*pag;
+	xfs_agino_t		agino;
 	int			error;
 
-	error = xfs_iget(mp, tp, ino, XFS_IGET_INCORE, 0, &ip);
-	if (error)
-		return error;
+	/* reject inode numbers outside existing AGs */
+	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
+		return -EINVAL;
 
-	*inuse = !!(VFS_I(ip)->i_mode);
-	xfs_irele(ip);
-	return 0;
+	/* get the perag structure and ensure that it's inode capable */
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
+	agino = XFS_INO_TO_AGINO(mp, ino);
+
+	rcu_read_lock();
+	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
+	if (!ip) {
+		/* cache miss */
+		error = -ENODATA;
+		goto out_pag;
+	}
+
+	/*
+	 * If the inode number doesn't match, the incore inode got reused
+	 * during an RCU grace period and the radix tree hasn't been updated.
+	 * This isn't the inode we want.
+	 */
+	error = -ENODATA;
+	spin_lock(&ip->i_flags_lock);
+	if (ip->i_ino != ino)
+		goto out_skip;
+
+	trace_xfs_icache_inode_is_allocated(ip);
+
+	/*
+	 * We have an incore inode that matches the inode we want, and the
+	 * caller holds the AGI buffer.
+	 *
+	 * If the incore inode is INEW, there are several possibilities:
+	 *
+	 * For a file that is being created, note that we allocate the ondisk
+	 * inode before allocating, initializing, and adding the incore inode
+	 * to the radix tree.
+	 *
+	 * If the incore inode is being recycled, the inode has to be allocated
+	 * because we don't allow freed inodes to be recycled.
+	 *
+	 * If the inode is queued for inactivation, it should still be
+	 * allocated.
+	 *
+	 * If the incore inode is undergoing inactivation, either it is before
+	 * the point where it would get freed ondisk (in which case i_mode is
+	 * still nonzero), or it has already been freed, in which case i_mode
+	 * is zero.  We don't take the ILOCK here, but difree and dialloc
+	 * require the AGI, which we do hold.
+	 *
+	 * If the inode is anywhere in the reclaim mechanism, we know that it's
+	 * still ok to query i_mode because we don't allow uncached inode
+	 * updates.
+	 *
+	 * If the incore inode is live (i.e. referenced from the dcache), the
+	 * ondisk inode had better be allocated.  This is the most trivial
+	 * case.
+	 */
+#ifdef DEBUG
+	if (ip->i_flags & XFS_INEW) {
+		/* created on disk already or recycling */
+		ASSERT(VFS_I(ip)->i_mode != 0);
+	}
+
+	if ((ip->i_flags & XFS_NEED_INACTIVE) &&
+	    !(ip->i_flags & XFS_INACTIVATING)) {
+		/* definitely before difree */
+		ASSERT(VFS_I(ip)->i_mode != 0);
+	}
+
+	/* XFS_INACTIVATING and XFS_IRECLAIMABLE could be either state */
+
+	if (!(ip->i_flags & (XFS_NEED_INACTIVE | XFS_INEW | XFS_IRECLAIMABLE |
+			     XFS_INACTIVATING))) {
+		/* live inode */
+		ASSERT(VFS_I(ip)->i_mode != 0);
+	}
+#endif
+	*inuse = VFS_I(ip)->i_mode != 0;
+	error = 0;
+
+out_skip:
+	spin_unlock(&ip->i_flags_lock);
+out_pag:
+	rcu_read_unlock();
+	xfs_perag_put(pag);
+	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index dfb1d47ee3c3..a435ca32f186 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -793,6 +793,28 @@ DEFINE_INODE_EVENT(xfs_inode_reclaiming);
 DEFINE_INODE_EVENT(xfs_inode_set_need_inactive);
 DEFINE_INODE_EVENT(xfs_inode_inactivating);
 
+TRACE_EVENT(xfs_icache_inode_is_allocated,
+	TP_PROTO(struct xfs_inode *ip),
+	TP_ARGS(ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned long, iflags)
+		__field(umode_t, mode)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->iflags = ip->i_flags;
+		__entry->mode = VFS_I(ip)->i_mode;
+	),
+	TP_printk("dev %d:%d ino 0x%llx iflags 0x%lx mode 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->iflags,
+		  __entry->mode)
+);
+
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
  * TRACE_DEFINE_ENUM macro so that the enum value can be encoded in the ftrace

