Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA6ABA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHvGUT1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1FEC433C8;
	Sun, 31 Dec 2023 20:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053161;
	bh=3camY0y11MN4KV8Rkk1/dMIh4RMjlYE4GgZtrGRcalI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VHvGUT1n2DAQI7YoooZO+PGROoO4zzNtpPLYZXml20HxRxoeZxu8FmARaKxQURGW8
	 vxB2dcy6XSEbvjlQbOSr8jhMtt40mz2chLTOM+V95bNc9mwLP+QqWvXgcb21cuy92B
	 x5pVE5Qr7khXtUS4KpVliR2RHcq1TsHonb59No+aJOsqRZWe5uIp1uvVYmhR64MdOp
	 BtXnZIokD8fxmkxD9rAPbVlMmBp+MAgM0ijjSM/LQLo73FaPNVK7MoQEn5VzTKZqf4
	 /acwvKgWRkGqsQ9iE1tYImmbgct6n+1XQssNqVsBOHENUwNOuKCvH/9zxrNZsbmnlz
	 e9mG51m672QSg==
Date: Sun, 31 Dec 2023 12:06:00 -0800
Subject: [PATCH 6/7] xfs: cache a bunch of inodes for repair scans
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404826603.1747630.1523391664280656042.stgit@frogsfrogsfrogs>
In-Reply-To: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
References: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

After observing xfs_scrub taking forever to rebuild parent pointers on a
pptrs enabled filesystem, I decided to profile what the system was
doing.  It turns out that when there are a lot of threads trying to scan
the filesystem, most of our time is spent contending on AGI buffer
locks.  Given that we're walking the inobt records anyway, we can often
tell ahead of time when there's a bunch of (up to 64) consecutive inodes
that we could grab all at once.

Do this to amortize the cost of taking the AGI lock across as many
inodes as we possibly can.  On the author's system this seems to improve
parallel throughput from barely one and a half cores to slightly
sublinear scaling.  The obvious antipattern here of course is where the
freemask has every other bit set (e.g. all 0xA's)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/iscan.c |  159 +++++++++++++++++++++++++++++++++++++++++---------
 fs/xfs/scrub/iscan.h |    7 ++
 fs/xfs/scrub/trace.h |   23 +++++++
 3 files changed, 159 insertions(+), 30 deletions(-)


diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
index ef78620dcc846..ba93258c47030 100644
--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -60,6 +60,7 @@ xchk_iscan_find_next(
 	struct xchk_iscan	*iscan,
 	struct xfs_buf		*agi_bp,
 	struct xfs_perag	*pag,
+	xfs_inofree_t		*allocmaskp,
 	xfs_agino_t		*cursor)
 {
 	struct xfs_scrub	*sc = iscan->sc;
@@ -145,6 +146,7 @@ xchk_iscan_find_next(
 
 			ASSERT(next >= 0);
 			*cursor = rec.ir_startino + next;
+			*allocmaskp = allocmask >> next;
 			break;
 		}
 	}
@@ -225,7 +227,8 @@ STATIC int
 xchk_iscan_advance(
 	struct xchk_iscan	*iscan,
 	struct xfs_perag	**pagp,
-	struct xfs_buf		**agi_bpp)
+	struct xfs_buf		**agi_bpp,
+	xfs_inofree_t		*allocmaskp)
 {
 	struct xfs_scrub	*sc = iscan->sc;
 	struct xfs_mount	*mp = sc->mp;
@@ -251,7 +254,8 @@ xchk_iscan_advance(
 			goto out_pag;
 
 		agino = XFS_INO_TO_AGINO(mp, iscan->cursor_ino);
-		ret = xchk_iscan_find_next(iscan, agi_bp, pag, &agino);
+		ret = xchk_iscan_find_next(iscan, agi_bp, pag, allocmaskp,
+				&agino);
 		if (ret)
 			goto out_buf;
 
@@ -331,29 +335,35 @@ xchk_iscan_iget_retry(
  * caller must ensure that no other threads can modify the inode until a call
  * to xchk_iscan_visit succeeds.
  *
- * Returns 0 and an incore inode; -EAGAIN if the caller should call again
- * xchk_iscan_advance; -EBUSY if we couldn't grab an inode; -ECANCELED if
- * there's a fatal signal pending; or some other negative errno.
+ * Returns the number of incore inodes grabbed; -EAGAIN if the caller should
+ * call again xchk_iscan_advance; -EBUSY if we couldn't grab an inode;
+ * -ECANCELED if there's a fatal signal pending; or some other negative errno.
  */
 STATIC int
 xchk_iscan_iget(
 	struct xchk_iscan	*iscan,
 	struct xfs_perag	*pag,
 	struct xfs_buf		*agi_bp,
-	struct xfs_inode	**ipp)
+	xfs_inofree_t		allocmask)
 {
 	struct xfs_scrub	*sc = iscan->sc;
 	struct xfs_mount	*mp = sc->mp;
+	xfs_ino_t		ino = iscan->cursor_ino;
+	unsigned int		idx = 0;
 	int			error;
 
-	error = xfs_iget(sc->mp, sc->tp, iscan->cursor_ino, XFS_IGET_NORETRY,
-			0, ipp);
-	xfs_trans_brelse(sc->tp, agi_bp);
-	xfs_perag_put(pag);
+	ASSERT(iscan->__inodes[0] == NULL);
+
+	/* Fill the first slot in the inode array. */
+	error = xfs_iget(sc->mp, sc->tp, ino, XFS_IGET_NORETRY, 0,
+			&iscan->__inodes[idx]);
 
 	trace_xchk_iscan_iget(iscan, error);
 
 	if (error == -ENOENT || error == -EAGAIN) {
+		xfs_trans_brelse(sc->tp, agi_bp);
+		xfs_perag_put(pag);
+
 		/*¬
 		 * It's possible that this inode has lost all of its links but
 		 * hasn't yet been inactivated.  If we don't have a transaction
@@ -364,6 +374,9 @@ xchk_iscan_iget(
 	}
 
 	if (error == -EINVAL) {
+		xfs_trans_brelse(sc->tp, agi_bp);
+		xfs_perag_put(pag);
+
 		/*
 		 * We thought the inode was allocated, but the inode btree
 		 * lookup failed, which means that it was freed since the last
@@ -374,25 +387,47 @@ xchk_iscan_iget(
 		return xchk_iscan_iget_retry(iscan, false);
 	}
 
-	return error;
+	if (error) {
+		xfs_trans_brelse(sc->tp, agi_bp);
+		xfs_perag_put(pag);
+		return error;
+	}
+	idx++;
+	ino++;
+	allocmask >>= 1;
+
+	/*
+	 * Now that we've filled the first slot in __inodes, try to fill the
+	 * rest of the batch with consecutively ordered inodes.  to reduce the
+	 * number of _iter calls.  If we can't get an inode, we stop and return
+	 * what we have.
+	 */
+	for (; allocmask & 1; allocmask >>= 1, ino++, idx++) {
+		ASSERT(iscan->__inodes[idx] == NULL);
+
+		error = xfs_iget(sc->mp, sc->tp, ino, XFS_IGET_NORETRY, 0,
+				&iscan->__inodes[idx]);
+		if (error)
+			break;
+
+		mutex_lock(&iscan->lock);
+		iscan->cursor_ino = ino;
+		mutex_unlock(&iscan->lock);
+	}
+
+	trace_xchk_iscan_iget_batch(sc->mp, iscan, idx);
+	xfs_trans_brelse(sc->tp, agi_bp);
+	xfs_perag_put(pag);
+	return idx;
 }
 
 /*
- * Advance the inode scan cursor to the next allocated inode and return the
- * incore inode structure associated with it.
- *
- * Returns 1 if there's a new inode to examine, 0 if we've run out of inodes,
- * -ECANCELED if the live scan aborted, -EBUSY if the incore inode could not be
- * grabbed, or the usual negative errno.
- *
- * If the function returns -EBUSY and the caller can handle skipping an inode,
- * it may call this function again to continue the scan with the next allocated
- * inode.
+ * Advance the inode scan cursor to the next allocated inode and return up to
+ * 64 consecutive allocated inodes starting with the cursor position.
  */
-int
-xchk_iscan_iter(
-	struct xchk_iscan	*iscan,
-	struct xfs_inode	**ipp)
+STATIC int
+xchk_iscan_iter_batch(
+	struct xchk_iscan	*iscan)
 {
 	struct xfs_scrub	*sc = iscan->sc;
 	int			ret;
@@ -404,8 +439,9 @@ xchk_iscan_iter(
 	do {
 		struct xfs_buf	*agi_bp = NULL;
 		struct xfs_perag *pag = NULL;
+		xfs_inofree_t	allocmask = 0;
 
-		ret = xchk_iscan_advance(iscan, &pag, &agi_bp);
+		ret = xchk_iscan_advance(iscan, &pag, &agi_bp, &allocmask);
 		if (ret != 1)
 			return ret;
 
@@ -416,21 +452,74 @@ xchk_iscan_iter(
 			break;
 		}
 
-		ret = xchk_iscan_iget(iscan, pag, agi_bp, ipp);
+		ret = xchk_iscan_iget(iscan, pag, agi_bp, allocmask);
 	} while (ret == -EAGAIN);
 
-	if (!ret)
-		return 1;
-
 	return ret;
 }
 
+/*
+ * Advance the inode scan cursor to the next allocated inode and return the
+ * incore inode structure associated with it.
+ *
+ * Returns 1 if there's a new inode to examine, 0 if we've run out of inodes,
+ * -ECANCELED if the live scan aborted, -EBUSY if the incore inode could not be
+ * grabbed, or the usual negative errno.
+ *
+ * If the function returns -EBUSY and the caller can handle skipping an inode,
+ * it may call this function again to continue the scan with the next allocated
+ * inode.
+ */
+int
+xchk_iscan_iter(
+	struct xchk_iscan	*iscan,
+	struct xfs_inode	**ipp)
+{
+	unsigned int		i;
+	int			error;
+
+	/* Find a cached inode, or go get another batch. */
+	for (i = 0; i < XFS_INODES_PER_CHUNK; i++) {
+		if (iscan->__inodes[i])
+			goto foundit;
+	}
+
+	error = xchk_iscan_iter_batch(iscan);
+	if (error <= 0)
+		return error;
+
+	ASSERT(iscan->__inodes[0] != NULL);
+	i = 0;
+
+foundit:
+	/* Give the caller our reference. */
+	*ipp = iscan->__inodes[i];
+	iscan->__inodes[i] = NULL;
+	return 1;
+}
+
+/* Clean up an xfs_iscan_iter call by dropping any inodes that we still hold. */
+void
+xchk_iscan_iter_finish(
+	struct xchk_iscan	*iscan)
+{
+	struct xfs_scrub	*sc = iscan->sc;
+	unsigned int		i;
+
+	for (i = 0; i < XFS_INODES_PER_CHUNK; i++) {
+		if (iscan->__inodes[i]) {
+			xchk_irele(sc, iscan->__inodes[i]);
+			iscan->__inodes[i] = NULL;
+		}
+	}
+}
 
 /* Mark this inode scan finished and release resources. */
 void
 xchk_iscan_teardown(
 	struct xchk_iscan	*iscan)
 {
+	xchk_iscan_iter_finish(iscan);
 	xchk_iscan_finish(iscan);
 	mutex_destroy(&iscan->lock);
 }
@@ -478,6 +567,7 @@ xchk_iscan_start(
 	iscan->cursor_ino = start_ino;
 	iscan->scan_start_ino = start_ino;
 	mutex_init(&iscan->lock);
+	memset(iscan->__inodes, 0, sizeof(iscan->__inodes));
 
 	trace_xchk_iscan_start(iscan, start_ino);
 }
@@ -523,6 +613,15 @@ xchk_iscan_want_live_update(
 		goto unlock;
 	}
 
+	/*
+	 * No inodes have been visited yet, so the visited cursor points at the
+	 * start of the scan range.  The caller should not receive any updates.
+	 */
+	if (iscan->scan_start_ino == iscan->__visited_ino) {
+		ret = false;
+		goto unlock;
+	}
+
 	/*
 	 * The visited cursor hasn't yet wrapped around the end of the FS.  If
 	 * @ino is inside the starred range, the caller should receive updates:
diff --git a/fs/xfs/scrub/iscan.h b/fs/xfs/scrub/iscan.h
index 0db97d98ee8da..f7317af807ddc 100644
--- a/fs/xfs/scrub/iscan.h
+++ b/fs/xfs/scrub/iscan.h
@@ -41,6 +41,12 @@ struct xchk_iscan {
 
 	/* Wait this many ms to retry an iget. */
 	unsigned int		iget_retry_delay;
+
+	/*
+	 * The scan grabs batches of inodes and stashes them here before
+	 * handing them out with _iter.
+	 */
+	struct xfs_inode	*__inodes[XFS_INODES_PER_CHUNK];
 };
 
 /* Set if the scan has been aborted due to some event in the fs. */
@@ -63,6 +69,7 @@ void xchk_iscan_start(struct xfs_scrub *sc, unsigned int iget_timeout,
 void xchk_iscan_teardown(struct xchk_iscan *iscan);
 
 int xchk_iscan_iter(struct xchk_iscan *iscan, struct xfs_inode **ipp);
+void xchk_iscan_iter_finish(struct xchk_iscan *iscan);
 
 void xchk_iscan_mark_visited(struct xchk_iscan *iscan, struct xfs_inode *ip);
 bool xchk_iscan_want_live_update(struct xchk_iscan *iscan, xfs_ino_t ino);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 92d1f3b6203db..896910be3173b 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1200,6 +1200,29 @@ TRACE_EVENT(xchk_iscan_iget,
 		  __entry->error)
 );
 
+TRACE_EVENT(xchk_iscan_iget_batch,
+	TP_PROTO(struct xfs_mount *mp, struct xchk_iscan *iscan,
+		 unsigned int nr),
+	TP_ARGS(mp, iscan, nr),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, cursor)
+		__field(xfs_ino_t, visited)
+		__field(unsigned int, nr)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->cursor = iscan->cursor_ino;
+		__entry->visited = iscan->__visited_ino;
+		__entry->nr = nr;
+	),
+	TP_printk("dev %d:%d iscan cursor 0x%llx visited 0x%llx nr %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->cursor,
+		  __entry->visited,
+		  __entry->nr)
+);
+
 TRACE_EVENT(xchk_iscan_iget_retry_wait,
 	TP_PROTO(struct xchk_iscan *iscan),
 	TP_ARGS(iscan),

