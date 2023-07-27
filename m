Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A7AEB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjG0WbH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbjG0WbG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:31:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A602D64
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:31:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0393561F6E
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63109C433CA;
        Thu, 27 Jul 2023 22:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690497064;
        bh=Hg2meWQqQQFj4/uTh2zJDU9KLFrNgl1Hk3CAkoLQWNs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=bW3O/9CBDeRrDgq/3LUUdDgBojou6ZBUAoifHU0xJWvh2KDG52hPcH/dskQ5y1KTK
         T2o5sEJ1/+9XV+33qUo3uH1unh1qw4xXUZfkR+wFbgJkr9cETRByZ2UGjhZB9s4147
         qHgv0PCnxBDBFrP6OmhZSZELMmGDZzdcc1JM2EG5MYqVpMpHHWEwuxlJmIbq6n12LM
         47dJ1e/3K/bTvZnBIO+G9nDk2rUfb7jkK9CUP12yiK6wMnHiDYAdUNhq2ZskP4hfJ1
         BLRbzSdaj2DpzlQt0lhFz9J7EbSlohmZliubvXrgedHmMePf7MFQjZqnj/dMp0LWob
         7j9qWfTMIJMeQ==
Date:   Thu, 27 Jul 2023 15:31:03 -0700
Subject: [PATCH 3/5] xfs: rewrite xchk_inode_is_allocated to work properly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049625753.922264.11707952061753226050.stgit@frogsfrogsfrogs>
In-Reply-To: <169049625702.922264.5146998399930069330.stgit@frogsfrogsfrogs>
References: <169049625702.922264.5146998399930069330.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/common.c |  159 ++++++++++++++++++++++++++++++++++++++++++-------
 fs/xfs/scrub/common.h |    3 +
 fs/xfs/scrub/ialloc.c |    2 -
 fs/xfs/scrub/trace.h  |   22 +++++++
 4 files changed, 162 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 8ae4a54c7be46..61f583b72a669 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1233,38 +1233,153 @@ xchk_fsgates_enable(
 }
 
 /*
- * Decide if this is this a cached inode that's also allocated.
+ * Decide if this is this a cached inode that's also allocated.  The caller
+ * must hold a reference to an AG and the AGI buffer lock to prevent inodes
+ * from being allocated or freed.
  *
- * Look up an inode by number in the given file system.  If the inode is
- * in cache and isn't in purgatory, return 1 if the inode is allocated
- * and 0 if it is not.  For all other cases (not in cache, being torn
- * down, etc.), return a negative error code.
+ * Look up an inode by number in the given file system.  If the inode number
+ * is invalid, return -EINVAL.  If the inode is not in cache, return -ENODATA.
+ * If the inode is being reclaimed, return -ENODATA because we know the inode
+ * cache cannot be updating the ondisk metadata.
  *
- * The caller has to prevent inode allocation and freeing activity,
- * presumably by locking the AGI buffer.   This is to ensure that an
- * inode cannot transition from allocated to freed until the caller is
- * ready to allow that.  If the inode is in an intermediate state (new,
- * reclaimable, or being reclaimed), -EAGAIN will be returned; if the
- * inode is not in the cache, -ENOENT will be returned.  The caller must
- * deal with these scenarios appropriately.
- *
- * This is a specialized use case for the online scrubber; if you're
- * reading this, you probably want xfs_iget.
+ * Otherwise, the incore inode is the one we want, and it is either live,
+ * somewhere in the inactivation machinery, or reclaimable.  The inode is
+ * allocated if i_mode is nonzero.  In all three cases, the cached inode will
+ * be more up to date than the ondisk inode buffer, so we must use the incore
+ * i_mode.
  */
 int
 xchk_inode_is_allocated(
 	struct xfs_scrub	*sc,
-	xfs_ino_t		ino,
+	xfs_agino_t		agino,
 	bool			*inuse)
 {
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_perag	*pag = sc->sa.pag;
+	xfs_ino_t		ino;
 	struct xfs_inode	*ip;
 	int			error;
 
-	error = xfs_iget(sc->mp, sc->tp, ino, XFS_IGET_INCORE, 0, &ip);
-	if (error)
-		return error;
+	/* caller must hold perag reference */
+	if (pag == NULL) {
+		ASSERT(pag != NULL);
+		return -EINVAL;
+	}
 
-	*inuse = !!(VFS_I(ip)->i_mode);
-	xfs_irele(ip);
-	return 0;
+	/* caller must have AGI buffer */
+	if (sc->sa.agi_bp == NULL) {
+		ASSERT(sc->sa.agi_bp != NULL);
+		return -EINVAL;
+	}
+
+	/* reject inode numbers outside existing AGs */
+	ino = XFS_AGINO_TO_INO(sc->mp, pag->pag_agno, agino);
+	if (!xfs_verify_ino(mp, ino))
+		return -EINVAL;
+
+	error = -ENODATA;
+	rcu_read_lock();
+	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
+	if (!ip) {
+		/* cache miss */
+		goto out_rcu;
+	}
+
+	/*
+	 * If the inode number doesn't match, the incore inode got reused
+	 * during an RCU grace period and the radix tree hasn't been updated.
+	 * This isn't the inode we want.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	if (ip->i_ino != ino)
+		goto out_skip;
+
+	trace_xchk_inode_is_allocated(ip);
+
+	/*
+	 * We have an incore inode that matches the inode we want, and the
+	 * caller holds the perag structure and the AGI buffer.  Let's check
+	 * our assumptions below:
+	 */
+
+#ifdef DEBUG
+	/*
+	 * (1) If the incore inode is live (i.e. referenced from the dcache),
+	 * it will not be INEW, nor will it be in the inactivation or reclaim
+	 * machinery.  The ondisk inode had better be allocated.  This is the
+	 * most trivial case.
+	 */
+	if (!(ip->i_flags & (XFS_NEED_INACTIVE | XFS_INEW | XFS_IRECLAIMABLE |
+			     XFS_INACTIVATING))) {
+		/* live inode */
+		ASSERT(VFS_I(ip)->i_mode != 0);
+	}
+
+	/*
+	 * If the incore inode is INEW, there are several possibilities:
+	 *
+	 * (2) For a file that is being created, note that we allocate the
+	 * ondisk inode before allocating, initializing, and adding the incore
+	 * inode to the radix tree.
+	 *
+	 * (3) If the incore inode is being recycled, the inode has to be
+	 * allocated because we don't allow freed inodes to be recycled.
+	 * Recycling doesn't touch i_mode.
+	 */
+	if (ip->i_flags & XFS_INEW) {
+		/* created on disk already or recycling */
+		ASSERT(VFS_I(ip)->i_mode != 0);
+	}
+
+	/*
+	 * (4) If the inode is queued for inactivation (NEED_INACTIVE) but
+	 * inactivation has not started (!INACTIVATING), it is still allocated.
+	 */
+	if ((ip->i_flags & XFS_NEED_INACTIVE) &&
+	    !(ip->i_flags & XFS_INACTIVATING)) {
+		/* definitely before difree */
+		ASSERT(VFS_I(ip)->i_mode != 0);
+	}
+#endif
+
+	/*
+	 * If the incore inode is undergoing inactivation (INACTIVATING), there
+	 * are two possibilities:
+	 *
+	 * (5) It is before the point where it would get freed ondisk, in which
+	 * case i_mode is still nonzero.
+	 *
+	 * (6) It has already been freed, in which case i_mode is zero.
+	 *
+	 * We don't take the ILOCK here, but difree and dialloc update the AGI,
+	 * and we've taken the AGI buffer lock, which prevents that from
+	 * happening.
+	 */
+
+	/*
+	 * (7) Inodes undergoing inactivation (INACTIVATING) or queued for
+	 * reclaim (IRECLAIMABLE) could be allocated or free.  i_mode still
+	 * reflects the ondisk state.
+	 */
+
+	/*
+	 * (8) If the inode is in IFLUSHING, it's safe to query i_mode because
+	 * the flush code uses i_mode to format the ondisk inode.
+	 */
+
+	/*
+	 * (9) If the inode is in IRECLAIM and was reachable via the radix
+	 * tree, it still has the same i_mode as it did before it entered
+	 * reclaim.  The inode object is still alive because we hold the RCU
+	 * read lock.
+	 */
+
+	*inuse = VFS_I(ip)->i_mode != 0;
+	error = 0;
+
+out_skip:
+	spin_unlock(&ip->i_flags_lock);
+out_rcu:
+	rcu_read_unlock();
+	return error;
 }
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 77b3338a67c6d..b26b0ea3ea5a1 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -222,6 +222,7 @@ static inline bool xchk_need_intent_drain(struct xfs_scrub *sc)
 
 void xchk_fsgates_enable(struct xfs_scrub *sc, unsigned int scrub_fshooks);
 
-int xchk_inode_is_allocated(struct xfs_scrub *sc, xfs_ino_t ino, bool *inuse);
+int xchk_inode_is_allocated(struct xfs_scrub *sc, xfs_agino_t agino,
+		bool *inuse);
 
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 3a3d750b02e0e..fb7bbf47ae5d6 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -328,7 +328,7 @@ xchk_iallocbt_check_cluster_ifree(
 		goto out;
 	}
 
-	error = xchk_inode_is_allocated(bs->sc, fsino, &ino_inuse);
+	error = xchk_inode_is_allocated(bs->sc, agino, &ino_inuse);
 	if (error == -ENODATA) {
 		/* Not cached, just read the disk buffer */
 		freemask_ok = irec_free ^ !!(dip->di_mode);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index d9ddd6ffe572f..c9097d138c044 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -640,6 +640,28 @@ TRACE_EVENT(xchk_iallocbt_check_cluster,
 		  __entry->cluster_ino)
 )
 
+TRACE_EVENT(xchk_inode_is_allocated,
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
 TRACE_EVENT(xchk_fscounters_calc,
 	TP_PROTO(struct xfs_mount *mp, uint64_t icount, uint64_t ifree,
 		 uint64_t fdblocks, uint64_t delalloc),

