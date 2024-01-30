Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E68376F2
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591104; cv=none; b=ni2hJf4j0Y9FfC/Wu6XdlESflQuYYVsQuE7DoZuwaA1urCe8fOQ3tMjP3uWGdokZorFmor7FbKIWcA5Z+u5XPGo8QqSBiS9D3hxSyWhEgV4KSfcDosSLY40qCJKM9YT3tNOOslJ7Hb5BHIvVlPtyLIT/ocShmqhW2yEf1sj/5no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591104; c=relaxed/simple;
	bh=v893fa0YppMT1XhwJx1+oU0Ga2JBt1QYNpa/C+SZuxM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q6GZ1ZvB8BRg6hEVo+yCgkO9gLszqSI+22+A2ixbriGA0EguWssyQssQENKBk0xMeAbNLoNDVJv4JLm3VNbSAAQd7q4SqdfjYOck0lupvJa+779tAZBLu/CZDXQjbERfMQUBYjSur3CAShs4Fcp/m8YvXiLqEs77eUlSd2/L5O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aGYm0EvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aGYm0EvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D22C433C7;
	Tue, 30 Jan 2024 05:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591103;
	bh=v893fa0YppMT1XhwJx1+oU0Ga2JBt1QYNpa/C+SZuxM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aGYm0EvBXOoao/4qcy7I7NaaDBS3HDDPQz4qNgb9XxAnPy5DdqvvkbZoKD4YoM6rq
	 oTwyEgR4ZU2G294j9d6ZHKge5kSz0PgvZF6Fc9ly6v3uagy/D4DtdBYiECcyNt89jj
	 tUZDsyOi2zs1JhyZnc7GwZwbfKlcZkyAlbDWqocob/L7KH3HH6gTv3qtCSaNv3B6G8
	 VHoUwhDSFTI7QfCDxK6xjA5Hsfzhr0XAJ/E5AlejGMpELG6NrV84iKVgK52SVugpZC
	 5uvrKjgQl+K/Y6BE8fOTXoN1gZm6UfizMBi3b0/ynP07E9Ch6SPwuk3eizCmyFSXjj
	 F/LPKBFZpEWNA==
Date: Mon, 29 Jan 2024 21:05:03 -0800
Subject: [PATCH 6/6] xfs: iscan batching should handle unallocated inodes too
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659061935.3353019.10379387280462663397.stgit@frogsfrogsfrogs>
In-Reply-To: <170659061824.3353019.15854398821862048839.stgit@frogsfrogsfrogs>
References: <170659061824.3353019.15854398821862048839.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The inode scanner tries to reduce contention on the AGI header buffer
lock by grabbing references to consecutive allocated inodes.  Batching
stops as soon as we encounter an unallocated inode.  This is unfortunate
because in the worst case performance collapses to the old "one at a
time" behavior if every other inode is free.

This is correct behavior, but we could do better.  Unallocated inodes by
definition have nothing to scan, which means the iscan can ignore them
as long as someone ensures that the scan data will reflect another
thread allocating the inode and adding interesting metadata to that
inode.  That mechanism is, of course, the live update hooks.

Therefore, extend the batching mechanism to track unallocated inodes
adjacent to the scan cursor.  The _want_live_update predicate can tell
the caller's live update hook to incorporate all live updates to what
the scanner thinks is an unallocated inode if (after dropping the AGI)
some other thread allocates one of those inodes and begins using it.

Note that we cannot just copy the ir_free bitmap into the scan cursor
because the batching stops if iget says the inode is in an intermediate
state (e.g. on the inactivation list) and cannot be igrabbed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/iscan.c |  107 +++++++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/scrub/iscan.h |    6 ++-
 fs/xfs/scrub/trace.h |   21 ++++++++--
 3 files changed, 119 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
index d1c33aba1f10d..327f7fb83958a 100644
--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -61,7 +61,8 @@ xchk_iscan_find_next(
 	struct xfs_buf		*agi_bp,
 	struct xfs_perag	*pag,
 	xfs_inofree_t		*allocmaskp,
-	xfs_agino_t		*cursor)
+	xfs_agino_t		*cursor,
+	uint8_t			*nr_inodesp)
 {
 	struct xfs_scrub	*sc = iscan->sc;
 	struct xfs_inobt_rec_incore	rec;
@@ -147,6 +148,7 @@ xchk_iscan_find_next(
 			ASSERT(next >= 0);
 			*cursor = rec.ir_startino + next;
 			*allocmaskp = allocmask >> next;
+			*nr_inodesp = XFS_INODES_PER_CHUNK - next;
 			break;
 		}
 	}
@@ -228,7 +230,8 @@ xchk_iscan_advance(
 	struct xchk_iscan	*iscan,
 	struct xfs_perag	**pagp,
 	struct xfs_buf		**agi_bpp,
-	xfs_inofree_t		*allocmaskp)
+	xfs_inofree_t		*allocmaskp,
+	uint8_t			*nr_inodesp)
 {
 	struct xfs_scrub	*sc = iscan->sc;
 	struct xfs_mount	*mp = sc->mp;
@@ -255,7 +258,7 @@ xchk_iscan_advance(
 
 		agino = XFS_INO_TO_AGINO(mp, iscan->cursor_ino);
 		ret = xchk_iscan_find_next(iscan, agi_bp, pag, allocmaskp,
-				&agino);
+				&agino, nr_inodesp);
 		if (ret)
 			goto out_buf;
 
@@ -344,12 +347,14 @@ xchk_iscan_iget(
 	struct xchk_iscan	*iscan,
 	struct xfs_perag	*pag,
 	struct xfs_buf		*agi_bp,
-	xfs_inofree_t		allocmask)
+	xfs_inofree_t		allocmask,
+	uint8_t			nr_inodes)
 {
 	struct xfs_scrub	*sc = iscan->sc;
 	struct xfs_mount	*mp = sc->mp;
 	xfs_ino_t		ino = iscan->cursor_ino;
 	unsigned int		idx = 0;
+	unsigned int		i;
 	int			error;
 
 	ASSERT(iscan->__inodes[0] == NULL);
@@ -399,10 +404,28 @@ xchk_iscan_iget(
 	/*
 	 * Now that we've filled the first slot in __inodes, try to fill the
 	 * rest of the batch with consecutively ordered inodes.  to reduce the
-	 * number of _iter calls.  If we can't get an inode, we stop and return
-	 * what we have.
+	 * number of _iter calls.  Make a bitmap of unallocated inodes from the
+	 * zeroes in the inuse bitmap; these inodes will not be scanned, but
+	 * the _want_live_update predicate will pass through all live updates.
+	 *
+	 * If we can't iget an allocated inode, stop and return what we have.
 	 */
-	for (; allocmask & 1; allocmask >>= 1, ino++, idx++) {
+	mutex_lock(&iscan->lock);
+	iscan->__batch_ino = ino - 1;
+	iscan->__skipped_inomask = 0;
+	mutex_unlock(&iscan->lock);
+
+	for (i = 1; i < nr_inodes; i++, ino++, allocmask >>= 1) {
+		if (!(allocmask & 1)) {
+			ASSERT(!(iscan->__skipped_inomask & (1ULL << i)));
+
+			mutex_lock(&iscan->lock);
+			iscan->cursor_ino = ino;
+			iscan->__skipped_inomask |= (1ULL << i);
+			mutex_unlock(&iscan->lock);
+			continue;
+		}
+
 		ASSERT(iscan->__inodes[idx] == NULL);
 
 		error = xfs_iget(sc->mp, sc->tp, ino, XFS_IGET_NORETRY, 0,
@@ -413,14 +436,42 @@ xchk_iscan_iget(
 		mutex_lock(&iscan->lock);
 		iscan->cursor_ino = ino;
 		mutex_unlock(&iscan->lock);
+		idx++;
 	}
 
-	trace_xchk_iscan_iget_batch(sc->mp, iscan, idx);
+	trace_xchk_iscan_iget_batch(sc->mp, iscan, nr_inodes, idx);
 	xfs_trans_brelse(sc->tp, agi_bp);
 	xfs_perag_put(pag);
 	return idx;
 }
 
+/*
+ * Advance the visit cursor to reflect skipped inodes beyond whatever we
+ * scanned.
+ */
+STATIC void
+xchk_iscan_finish_batch(
+	struct xchk_iscan	*iscan)
+{
+	xfs_ino_t		highest_skipped;
+
+	mutex_lock(&iscan->lock);
+
+	if (iscan->__batch_ino != NULLFSINO) {
+		highest_skipped = iscan->__batch_ino +
+					xfs_highbit64(iscan->__skipped_inomask);
+		iscan->__visited_ino = max(iscan->__visited_ino,
+					   highest_skipped);
+
+		trace_xchk_iscan_skip(iscan);
+	}
+
+	iscan->__batch_ino = NULLFSINO;
+	iscan->__skipped_inomask = 0;
+
+	mutex_unlock(&iscan->lock);
+}
+
 /*
  * Advance the inode scan cursor to the next allocated inode and return up to
  * 64 consecutive allocated inodes starting with the cursor position.
@@ -432,6 +483,8 @@ xchk_iscan_iter_batch(
 	struct xfs_scrub	*sc = iscan->sc;
 	int			ret;
 
+	xchk_iscan_finish_batch(iscan);
+
 	if (iscan->iget_timeout)
 		iscan->__iget_deadline = jiffies +
 					 msecs_to_jiffies(iscan->iget_timeout);
@@ -440,8 +493,10 @@ xchk_iscan_iter_batch(
 		struct xfs_buf	*agi_bp = NULL;
 		struct xfs_perag *pag = NULL;
 		xfs_inofree_t	allocmask = 0;
+		uint8_t		nr_inodes = 0;
 
-		ret = xchk_iscan_advance(iscan, &pag, &agi_bp, &allocmask);
+		ret = xchk_iscan_advance(iscan, &pag, &agi_bp, &allocmask,
+				&nr_inodes);
 		if (ret != 1)
 			return ret;
 
@@ -452,7 +507,7 @@ xchk_iscan_iter_batch(
 			break;
 		}
 
-		ret = xchk_iscan_iget(iscan, pag, agi_bp, allocmask);
+		ret = xchk_iscan_iget(iscan, pag, agi_bp, allocmask, nr_inodes);
 	} while (ret == -EAGAIN);
 
 	return ret;
@@ -559,6 +614,9 @@ xchk_iscan_start(
 
 	start_ino = xchk_iscan_rotor(sc->mp);
 
+	iscan->__batch_ino = NULLFSINO;
+	iscan->__skipped_inomask = 0;
+
 	iscan->sc = sc;
 	clear_bit(XCHK_ISCAN_OPSTATE_ABORTED, &iscan->__opstate);
 	iscan->iget_timeout = iget_timeout;
@@ -587,6 +645,26 @@ xchk_iscan_mark_visited(
 	mutex_unlock(&iscan->lock);
 }
 
+/*
+ * Did we skip this inode because it wasn't allocated when we loaded the batch?
+ * If so, it is newly allocated and will not be scanned.  All live updates to
+ * this inode must be passed to the caller to maintain scan correctness.
+ */
+static inline bool
+xchk_iscan_skipped(
+	const struct xchk_iscan	*iscan,
+	xfs_ino_t		ino)
+{
+	if (iscan->__batch_ino == NULLFSINO)
+		return false;
+	if (ino < iscan->__batch_ino)
+		return false;
+	if (ino >= iscan->__batch_ino + XFS_INODES_PER_CHUNK)
+		return false;
+
+	return iscan->__skipped_inomask & (1ULL << (ino - iscan->__batch_ino));
+}
+
 /*
  * Do we need a live update for this inode?  This is true if the scanner thread
  * has visited this inode and the scan hasn't been aborted due to errors.
@@ -622,6 +700,15 @@ xchk_iscan_want_live_update(
 		goto unlock;
 	}
 
+	/*
+	 * This inode was not allocated at the time of the iscan batch.
+	 * The caller should receive all updates.
+	 */
+	if (xchk_iscan_skipped(iscan, ino)) {
+		ret = true;
+		goto unlock;
+	}
+
 	/*
 	 * The visited cursor hasn't yet wrapped around the end of the FS.  If
 	 * @ino is inside the starred range, the caller should receive updates:
diff --git a/fs/xfs/scrub/iscan.h b/fs/xfs/scrub/iscan.h
index f7317af807ddc..365d54e35cd94 100644
--- a/fs/xfs/scrub/iscan.h
+++ b/fs/xfs/scrub/iscan.h
@@ -44,8 +44,12 @@ struct xchk_iscan {
 
 	/*
 	 * The scan grabs batches of inodes and stashes them here before
-	 * handing them out with _iter.
+	 * handing them out with _iter.  Unallocated inodes are set in the
+	 * mask so that all updates to that inode are selected for live
+	 * update propagation.
 	 */
+	xfs_ino_t		__batch_ino;
+	xfs_inofree_t		__skipped_inomask;
 	struct xfs_inode	*__inodes[XFS_INODES_PER_CHUNK];
 };
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 38d3356466cdc..829c90da59c7c 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1172,6 +1172,7 @@ DEFINE_EVENT(xchk_iscan_class, name, \
 	TP_ARGS(iscan))
 DEFINE_ISCAN_EVENT(xchk_iscan_move_cursor);
 DEFINE_ISCAN_EVENT(xchk_iscan_visit);
+DEFINE_ISCAN_EVENT(xchk_iscan_skip);
 DEFINE_ISCAN_EVENT(xchk_iscan_advance_ag);
 
 DECLARE_EVENT_CLASS(xchk_iscan_ino_class,
@@ -1229,25 +1230,37 @@ TRACE_EVENT(xchk_iscan_iget,
 
 TRACE_EVENT(xchk_iscan_iget_batch,
 	TP_PROTO(struct xfs_mount *mp, struct xchk_iscan *iscan,
-		 unsigned int nr),
-	TP_ARGS(mp, iscan, nr),
+		 unsigned int nr, unsigned int avail),
+	TP_ARGS(mp, iscan, nr, avail),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, cursor)
 		__field(xfs_ino_t, visited)
 		__field(unsigned int, nr)
+		__field(unsigned int, avail)
+		__field(unsigned int, unavail)
+		__field(xfs_ino_t, batch_ino)
+		__field(unsigned long long, skipmask)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->cursor = iscan->cursor_ino;
 		__entry->visited = iscan->__visited_ino;
 		__entry->nr = nr;
+		__entry->avail = avail;
+		__entry->unavail = hweight64(iscan->__skipped_inomask);
+		__entry->batch_ino = iscan->__batch_ino;
+		__entry->skipmask = iscan->__skipped_inomask;
 	),
-	TP_printk("dev %d:%d iscan cursor 0x%llx visited 0x%llx nr %d",
+	TP_printk("dev %d:%d iscan cursor 0x%llx visited 0x%llx batchino 0x%llx skipmask 0x%llx nr %u avail %u unavail %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->cursor,
 		  __entry->visited,
-		  __entry->nr)
+		  __entry->batch_ino,
+		  __entry->skipmask,
+		  __entry->nr,
+		  __entry->avail,
+		  __entry->unavail)
 );
 
 TRACE_EVENT(xchk_iscan_iget_retry_wait,

