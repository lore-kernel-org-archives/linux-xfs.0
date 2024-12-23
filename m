Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B166318A6D7
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994912; cv=none; b=A9ggtF1wG3iqkg79SPLV8Anb71YCxdd6rI2FCXP3T5AbKOhp/rTmWtaxlLWDSz+gv0745y2G67Kln1F2bkKa9ocpDdB05XWnvhqwQL9IrzSq+3ojZvGlE8dEnk9VCWEkdyGne8G3ppgkOFegHKflJ17FQ1LTz0zWQcLiHKn99/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994912; c=relaxed/simple;
	bh=Eyn7jYVk/xi8JfymAi9xJ9JJTHq9YkGtu3i7wnamv94=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mADo+Qmwwfrh3tvEHQautmymVTNKv5qYq8Ha/pPoItN9xUVnB04Zs8+4jubizdF8EOzgqZCMYxADi+r+287ZS0q8v697F/Ik1wPhT7OihQbh7mNEnK1mahqX5wew07q0DdcUF0ADnAC7N3uC8ejsV0FQN63SQM0aw94Y1ZK23mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GXmDkWdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GXmDkWdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43769C4CED3;
	Mon, 23 Dec 2024 23:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994912;
	bh=Eyn7jYVk/xi8JfymAi9xJ9JJTHq9YkGtu3i7wnamv94=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GXmDkWdDjjmSWRafq6nDDR3KfAeWScbF7AAYS2WSap8qg1q4rMF5//SVxI9xKSFNm
	 F4uaElnoNvUhgDN3P4ZsWkb8ZxGkoTomwQwBJyZxeypV63INKMwDDPmRQ8ffKg1hx0
	 K+6bqX8jbv9aeh3TEC0Xzdc2PMV7bcCAHwFagL8Iywnn3iU0S48OiWw2joa0FaT37z
	 7MtT1qrdtWR4FYmur81OmIkcFWMzK2ik/BwDN4mzLLkwUmxCRK5tc/c/7aIrF6TMqM
	 61sB1Tsxd7bfGvHxX/StVOwZN+l6dmUIRJOyIhi0+vvNNPVRl14vpN07igD4RAwl6d
	 YU6/0RVZApw0A==
Date: Mon, 23 Dec 2024 15:01:51 -0800
Subject: [PATCH 20/37] xfs: allow queued realtime intents to drain before
 scrubbing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499419061.2380130.5770616854296426548.stgit@frogsfrogsfrogs>
In-Reply-To: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
References: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When a writer thread executes a chain of log intent items for the
realtime volume, the ILOCKs taken during each step are for each rt
metadata file, not the entire rt volume itself.  Although scrub takes
all rt metadata ILOCKs, this isn't sufficient to guard against scrub
checking the rt volume while that writer thread is in the middle of
finishing a chain because there's no higher level locking primitive
guarding the realtime volume.

When there's a collision, cross-referencing between data structures
(e.g. rtrmapbt and rtrefcountbt) yields false corruption events; if
repair is running, this results in incorrect repairs, which is
catastrophic.

Fix this by adding to the mount structure the same drain that we use to
protect scrub against concurrent AG updates, but this time for the
realtime volume.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/bmap.c      |    7 ++++
 fs/xfs/scrub/common.c    |   72 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/common.h    |    5 ++-
 fs/xfs/scrub/rgsuper.c   |    4 ++-
 fs/xfs/scrub/rtbitmap.c  |    8 ++++-
 fs/xfs/scrub/rtsummary.c |    5 +++
 fs/xfs/scrub/scrub.c     |    2 +
 fs/xfs/xfs_drain.c       |   20 ++++++-------
 fs/xfs/xfs_drain.h       |    7 +++-
 9 files changed, 108 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 0d7ad692822d48..dd99366643f832 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -324,10 +324,15 @@ xchk_bmap_rt_iextent_xref(
 			irec->br_startoff, &error))
 		return;
 
-	xchk_rtgroup_lock(&info->sc->sr, XCHK_RTGLOCK_ALL);
+	error = xchk_rtgroup_lock(info->sc, &info->sc->sr, XCHK_RTGLOCK_ALL);
+	if (!xchk_fblock_process_error(info->sc, info->whichfork,
+			irec->br_startoff, &error))
+		goto out_free;
+
 	xchk_xref_is_used_rt_space(info->sc, irec->br_startblock,
 			irec->br_blockcount);
 
+out_free:
 	xchk_rtgroup_free(info->sc, &info->sc->sr);
 }
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 5cbd94b56582a4..613fb54e723ede 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -719,13 +719,79 @@ xchk_rtgroup_init(
 	return 0;
 }
 
-void
+/* Lock all the rt group metadata inode ILOCKs and wait for intents. */
+int
 xchk_rtgroup_lock(
+	struct xfs_scrub	*sc,
 	struct xchk_rt		*sr,
 	unsigned int		rtglock_flags)
 {
-	xfs_rtgroup_lock(sr->rtg, rtglock_flags);
+	int			error = 0;
+
+	ASSERT(sr->rtg != NULL);
+
+	/*
+	 * If we're /only/ locking the rtbitmap in shared mode, then we're
+	 * obviously not trying to compare records in two metadata inodes.
+	 * There's no need to drain intents here because the caller (most
+	 * likely the rgsuper scanner) doesn't need that level of consistency.
+	 */
+	if (rtglock_flags == XFS_RTGLOCK_BITMAP_SHARED) {
+		xfs_rtgroup_lock(sr->rtg, rtglock_flags);
+		sr->rtlock_flags = rtglock_flags;
+		return 0;
+	}
+
+	do {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
+		xfs_rtgroup_lock(sr->rtg, rtglock_flags);
+
+		/*
+		 * If we've grabbed a non-metadata file for scrubbing, we
+		 * assume that holding its ILOCK will suffice to coordinate
+		 * with any rt intent chains involving this inode.
+		 */
+		if (sc->ip && !xfs_is_internal_inode(sc->ip))
+			break;
+
+		/*
+		 * Decide if the rt group is quiet enough for all metadata to
+		 * be consistent with each other.  Regular file IO doesn't get
+		 * to lock all the rt inodes at the same time, which means that
+		 * there could be other threads in the middle of processing a
+		 * chain of deferred ops.
+		 *
+		 * We just locked all the metadata inodes for this rt group;
+		 * now take a look to see if there are any intents in progress.
+		 * If there are, drop the rt group inode locks and wait for the
+		 * intents to drain.  Since we hold the rt group inode locks
+		 * for the duration of the scrub, this is the only time we have
+		 * to sample the intents counter; any threads increasing it
+		 * after this point can't possibly be in the middle of a chain
+		 * of rt metadata updates.
+		 *
+		 * Obviously, this should be slanted against scrub and in favor
+		 * of runtime threads.
+		 */
+		if (!xfs_group_intent_busy(rtg_group(sr->rtg)))
+			break;
+
+		xfs_rtgroup_unlock(sr->rtg, rtglock_flags);
+
+		if (!(sc->flags & XCHK_FSGATES_DRAIN))
+			return -ECHRNG;
+		error = xfs_group_intent_drain(rtg_group(sr->rtg));
+		if (error) {
+			if (error == -ERESTARTSYS)
+				error = -EINTR;
+			return error;
+		}
+	} while (1);
+
 	sr->rtlock_flags = rtglock_flags;
+	return 0;
 }
 
 /*
@@ -1379,7 +1445,7 @@ xchk_fsgates_enable(
 	trace_xchk_fsgates_enable(sc, scrub_fsgates);
 
 	if (scrub_fsgates & XCHK_FSGATES_DRAIN)
-		xfs_drain_wait_enable();
+		xfs_defer_drain_wait_enable();
 
 	if (scrub_fsgates & XCHK_FSGATES_QUOTA)
 		xfs_dqtrx_hook_enable();
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 9ff3cafd867962..e734572a8dd6ec 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -141,12 +141,13 @@ xchk_rtgroup_init_existing(
 	return error == -ENOENT ? -EFSCORRUPTED : error;
 }
 
-void xchk_rtgroup_lock(struct xchk_rt *sr, unsigned int rtglock_flags);
+int xchk_rtgroup_lock(struct xfs_scrub *sc, struct xchk_rt *sr,
+		unsigned int rtglock_flags);
 void xchk_rtgroup_free(struct xfs_scrub *sc, struct xchk_rt *sr);
 #else
 # define xchk_rtgroup_init(sc, rgno, sr)		(-EFSCORRUPTED)
 # define xchk_rtgroup_init_existing(sc, rgno, sr)	(-EFSCORRUPTED)
-# define xchk_rtgroup_lock(sc, lockflags)		do { } while (0)
+# define xchk_rtgroup_lock(sc, sr, lockflags)		(-EFSCORRUPTED)
 # define xchk_rtgroup_free(sc, sr)			do { } while (0)
 #endif /* CONFIG_XFS_RT */
 
diff --git a/fs/xfs/scrub/rgsuper.c b/fs/xfs/scrub/rgsuper.c
index 463b3573bb761b..e062c7d12565cd 100644
--- a/fs/xfs/scrub/rgsuper.c
+++ b/fs/xfs/scrub/rgsuper.c
@@ -61,7 +61,9 @@ xchk_rgsuperblock(
 	if (!xchk_xref_process_error(sc, 0, 0, &error))
 		return error;
 
-	xchk_rtgroup_lock(&sc->sr, XFS_RTGLOCK_BITMAP_SHARED);
+	error = xchk_rtgroup_lock(sc, &sc->sr, XFS_RTGLOCK_BITMAP_SHARED);
+	if (error)
+		return error;
 
 	/*
 	 * Since we already validated the rt superblock at mount time, we don't
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index fb4970c877abd3..819026ea2d741f 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -30,6 +30,9 @@ xchk_setup_rtbitmap(
 	struct xchk_rtbitmap	*rtb;
 	int			error;
 
+	if (xchk_need_intent_drain(sc))
+		xchk_fsgates_enable(sc, XCHK_FSGATES_DRAIN);
+
 	rtb = kzalloc(sizeof(struct xchk_rtbitmap), XCHK_GFP_FLAGS);
 	if (!rtb)
 		return -ENOMEM;
@@ -57,12 +60,15 @@ xchk_setup_rtbitmap(
 	if (error)
 		return error;
 
+	error = xchk_rtgroup_lock(sc, &sc->sr, XCHK_RTGLOCK_ALL);
+	if (error)
+		return error;
+
 	/*
 	 * Now that we've locked the rtbitmap, we can't race with growfsrt
 	 * trying to expand the bitmap or change the size of the rt volume.
 	 * Hence it is safe to compute and check the geometry values.
 	 */
-	xchk_rtgroup_lock(&sc->sr, XFS_RTGLOCK_BITMAP);
 	if (mp->m_sb.sb_rblocks) {
 		rtb->rextents = xfs_blen_to_rtbxlen(mp, mp->m_sb.sb_rblocks);
 		rtb->rextslog = xfs_compute_rextslog(rtb->rextents);
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index f1af5431b38856..4ac679c1bd29cd 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -89,6 +89,10 @@ xchk_setup_rtsummary(
 	if (error)
 		return error;
 
+	error = xchk_rtgroup_lock(sc, &sc->sr, XFS_RTGLOCK_BITMAP);
+	if (error)
+		return error;
+
 	/*
 	 * Now that we've locked the rtbitmap and rtsummary, we can't race with
 	 * growfsrt trying to expand the summary or change the size of the rt
@@ -99,7 +103,6 @@ xchk_setup_rtsummary(
 	 * exclusively here.  If we ever start caring about running concurrent
 	 * fsmap with scrub this could be changed.
 	 */
-	xchk_rtgroup_lock(&sc->sr, XFS_RTGLOCK_BITMAP);
 	if (mp->m_sb.sb_rblocks) {
 		rts->rextents = xfs_blen_to_rtbxlen(mp, mp->m_sb.sb_rblocks);
 		rts->rbmblocks = xfs_rtbitmap_blockcount(mp);
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 950f5a58dcd967..652d347cee9929 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -164,7 +164,7 @@ xchk_fsgates_disable(
 	trace_xchk_fsgates_disable(sc, sc->flags & XCHK_FSGATES_ALL);
 
 	if (sc->flags & XCHK_FSGATES_DRAIN)
-		xfs_drain_wait_disable();
+		xfs_defer_drain_wait_disable();
 
 	if (sc->flags & XCHK_FSGATES_QUOTA)
 		xfs_dqtrx_hook_disable();
diff --git a/fs/xfs/xfs_drain.c b/fs/xfs/xfs_drain.c
index 5ede81fadbd8ca..fa5f31931efdb5 100644
--- a/fs/xfs/xfs_drain.c
+++ b/fs/xfs/xfs_drain.c
@@ -13,28 +13,28 @@
 #include "xfs_trace.h"
 
 /*
- * Use a static key here to reduce the overhead of xfs_drain_rele.  If the
- * compiler supports jump labels, the static branch will be replaced by a nop
- * sled when there are no xfs_drain_wait callers.  Online fsck is currently
- * the only caller, so this is a reasonable tradeoff.
+ * Use a static key here to reduce the overhead of xfs_defer_drain_rele.  If
+ * the compiler supports jump labels, the static branch will be replaced by a
+ * nop sled when there are no xfs_defer_drain_wait callers.  Online fsck is
+ * currently the only caller, so this is a reasonable tradeoff.
  *
  * Note: Patching the kernel code requires taking the cpu hotplug lock.  Other
  * parts of the kernel allocate memory with that lock held, which means that
  * XFS callers cannot hold any locks that might be used by memory reclaim or
  * writeback when calling the static_branch_{inc,dec} functions.
  */
-static DEFINE_STATIC_KEY_FALSE(xfs_drain_waiter_gate);
+static DEFINE_STATIC_KEY_FALSE(xfs_defer_drain_waiter_gate);
 
 void
-xfs_drain_wait_disable(void)
+xfs_defer_drain_wait_disable(void)
 {
-	static_branch_dec(&xfs_drain_waiter_gate);
+	static_branch_dec(&xfs_defer_drain_waiter_gate);
 }
 
 void
-xfs_drain_wait_enable(void)
+xfs_defer_drain_wait_enable(void)
 {
-	static_branch_inc(&xfs_drain_waiter_gate);
+	static_branch_inc(&xfs_defer_drain_waiter_gate);
 }
 
 void
@@ -71,7 +71,7 @@ static inline bool has_waiters(struct wait_queue_head *wq_head)
 static inline void xfs_defer_drain_rele(struct xfs_defer_drain *dr)
 {
 	if (atomic_dec_and_test(&dr->dr_count) &&
-	    static_branch_unlikely(&xfs_drain_waiter_gate) &&
+	    static_branch_unlikely(&xfs_defer_drain_waiter_gate) &&
 	    has_waiters(&dr->dr_waiters))
 		wake_up(&dr->dr_waiters);
 }
diff --git a/fs/xfs/xfs_drain.h b/fs/xfs/xfs_drain.h
index efcf88df9a5e70..4d446dbf65e519 100644
--- a/fs/xfs/xfs_drain.h
+++ b/fs/xfs/xfs_drain.h
@@ -26,8 +26,8 @@ struct xfs_defer_drain {
 void xfs_defer_drain_init(struct xfs_defer_drain *dr);
 void xfs_defer_drain_free(struct xfs_defer_drain *dr);
 
-void xfs_drain_wait_disable(void);
-void xfs_drain_wait_enable(void);
+void xfs_defer_drain_wait_disable(void);
+void xfs_defer_drain_wait_enable(void);
 
 /*
  * Deferred Work Intent Drains
@@ -61,6 +61,9 @@ void xfs_drain_wait_enable(void);
  * All functions that create work items must increment the intent counter as
  * soon as the item is added to the transaction and cannot drop the counter
  * until the item is finished or cancelled.
+ *
+ * The same principles apply to realtime groups because the rt metadata inode
+ * ILOCKs are not held across transaction rolls.
  */
 struct xfs_group *xfs_group_intent_get(struct xfs_mount *mp,
 		xfs_fsblock_t fsbno, enum xfs_group_type type);

