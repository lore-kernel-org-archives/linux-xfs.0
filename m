Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFF1376F2
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591073; cv=none; b=nO0ERUlc7wrY3yb0M4zk71FaiDMaLbFuTGvTS5YdAggA08G3OJeUuNS/Ke4X+qwnfKydOQrgStOcYwHBgaFpb7AY0KczNpX16vOZCNasdUoSKONnDHqtjNsR2HMVcbwaBEbtorWsUpaGshLId6wWkArDXJb5zmLKBAo+9Ovh6yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591073; c=relaxed/simple;
	bh=raB6CxHcBM4QGOKXlyLCLelTqKCW8bCpx6hCU+K9Nu4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qANo+aWw/Q0i1UuvOBI0bOH4hdjPr3tYvG5tpmUqS7NZusbEBWrycbqRdI8W8ha3inYi2bZlDI/56XAd/i0PsoMfLUPW+oin8Q2bGkO3GWQL9/b+nkyLqd8YClR1KvqPGA7CrmhPVukB0Iz05GWfFoulmF9l5ohmvuOexj8kXDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WJJo/g94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WJJo/g94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B30C433C7;
	Tue, 30 Jan 2024 05:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591072;
	bh=raB6CxHcBM4QGOKXlyLCLelTqKCW8bCpx6hCU+K9Nu4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WJJo/g94uDGXXfyEhMPEeAGUxDtVBhU0LfLd/IkXqZYGU0XR5kg7EV1J1A9ptvnxT
	 KaSxJ5M75Du4ga75182C7Qexo3h5U6fTxGG1lPO+ShJdUYfIGTA1jqfqq3azTcu+Sa
	 2VgvhofhHjsvsXHH1UcxWVfGw39ecOYCjXYkaxxrDKvQHJ8MxD1ZsGzZkeNC4OdpRI
	 95prxYt4eZl8nABRTiHzY1gKIb3pIsrzkZF5y4OWJ5nWQOq+oCRHo4NDv0cj9v0fWj
	 /3YAVvd55Rxto5uCVEai/a6GgGqAqxPphhVE99VkqGjSWdzLUxrHl9Jr73/QJKoKro
	 L4Hzu61oDs9uw==
Date: Mon, 29 Jan 2024 21:04:32 -0800
Subject: [PATCH 4/6] xfs: stagger the starting AG of scrub iscans to reduce
 contention
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659061902.3353019.14857365283362176712.stgit@frogsfrogsfrogs>
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

Online directory and parent repairs on parent-pointer equipped
filesystems have shown that starting a large number of parallel iscans
causes a lot of AGI buffer contention.  Try to reduce this by making it
so that iscans scan wrap around the end of the filesystem, and using a
rotor to stagger where each scanner begins.  Surprisingly, this boosts
CPU utilization (on the author's test machines) from effectively
single-threaded to 160%.  Not great, but see the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/iscan.c |   87 ++++++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/scrub/iscan.h |    7 ++++
 fs/xfs/scrub/trace.h |    7 +++-
 3 files changed, 89 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
index d13fc3b60f2e7..3179c299c77f9 100644
--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -170,10 +170,24 @@ xchk_iscan_move_cursor(
 {
 	struct xfs_scrub	*sc = iscan->sc;
 	struct xfs_mount	*mp = sc->mp;
+	xfs_ino_t		cursor, visited;
+
+	BUILD_BUG_ON(XFS_MAXINUMBER == NULLFSINO);
+
+	/*
+	 * Special-case ino == 0 here so that we never set visited_ino to
+	 * NULLFSINO when wrapping around EOFS, for that will let through all
+	 * live updates.
+	 */
+	cursor = XFS_AGINO_TO_INO(mp, agno, agino);
+	if (cursor == 0)
+		visited = XFS_MAXINUMBER;
+	else
+		visited = cursor - 1;
 
 	mutex_lock(&iscan->lock);
-	iscan->cursor_ino = XFS_AGINO_TO_INO(mp, agno, agino);
-	iscan->__visited_ino = iscan->cursor_ino - 1;
+	iscan->cursor_ino = cursor;
+	iscan->__visited_ino = visited;
 	trace_xchk_iscan_move_cursor(iscan);
 	mutex_unlock(&iscan->lock);
 }
@@ -257,12 +271,13 @@ xchk_iscan_advance(
 		 * Did not find any more inodes in this AG, move on to the next
 		 * AG.
 		 */
-		xchk_iscan_move_cursor(iscan, ++agno, 0);
+		agno = (agno + 1) % mp->m_sb.sb_agcount;
+		xchk_iscan_move_cursor(iscan, agno, 0);
 		xfs_trans_brelse(sc->tp, agi_bp);
 		xfs_perag_put(pag);
 
 		trace_xchk_iscan_advance_ag(iscan);
-	} while (agno < mp->m_sb.sb_agcount);
+	} while (iscan->cursor_ino != iscan->scan_start_ino);
 
 	xchk_iscan_finish(iscan);
 	return 0;
@@ -420,6 +435,23 @@ xchk_iscan_teardown(
 	mutex_destroy(&iscan->lock);
 }
 
+/* Pick an AG from which to start a scan. */
+static inline xfs_ino_t
+xchk_iscan_rotor(
+	struct xfs_mount	*mp)
+{
+	static atomic_t		agi_rotor;
+	unsigned int		r = atomic_inc_return(&agi_rotor) - 1;
+
+	/*
+	 * Rotoring *backwards* through the AGs, so we add one here before
+	 * subtracting from the agcount to arrive at an AG number.
+	 */
+	r = (r % mp->m_sb.sb_agcount) + 1;
+
+	return XFS_AGINO_TO_INO(mp, mp->m_sb.sb_agcount - r, 0);
+}
+
 /*
  * Set ourselves up to start an inode scan.  If the @iget_timeout and
  * @iget_retry_delay parameters are set, the scan will try to iget each inode
@@ -434,15 +466,20 @@ xchk_iscan_start(
 	unsigned int		iget_retry_delay,
 	struct xchk_iscan	*iscan)
 {
+	xfs_ino_t		start_ino;
+
+	start_ino = xchk_iscan_rotor(sc->mp);
+
 	iscan->sc = sc;
 	clear_bit(XCHK_ISCAN_OPSTATE_ABORTED, &iscan->__opstate);
 	iscan->iget_timeout = iget_timeout;
 	iscan->iget_retry_delay = iget_retry_delay;
-	iscan->__visited_ino = 0;
-	iscan->cursor_ino = 0;
+	iscan->__visited_ino = start_ino;
+	iscan->cursor_ino = start_ino;
+	iscan->scan_start_ino = start_ino;
 	mutex_init(&iscan->lock);
 
-	trace_xchk_iscan_start(iscan);
+	trace_xchk_iscan_start(iscan, start_ino);
 }
 
 /*
@@ -471,15 +508,45 @@ xchk_iscan_want_live_update(
 	struct xchk_iscan	*iscan,
 	xfs_ino_t		ino)
 {
-	bool			ret;
+	bool			ret = false;
 
 	if (xchk_iscan_aborted(iscan))
 		return false;
 
 	mutex_lock(&iscan->lock);
+
 	trace_xchk_iscan_want_live_update(iscan, ino);
-	ret = iscan->__visited_ino >= ino;
+
+	/* Scan is finished, caller should receive all updates. */
+	if (iscan->__visited_ino == NULLFSINO) {
+		ret = true;
+		goto unlock;
+	}
+
+	/*
+	 * The visited cursor hasn't yet wrapped around the end of the FS.  If
+	 * @ino is inside the starred range, the caller should receive updates:
+	 *
+	 * 0 ------------ S ************ V ------------ EOFS
+	 */
+	if (iscan->scan_start_ino <= iscan->__visited_ino) {
+		if (ino >= iscan->scan_start_ino &&
+		    ino <= iscan->__visited_ino)
+			ret = true;
+
+		goto unlock;
+	}
+
+	/*
+	 * The visited cursor wrapped around the end of the FS.  If @ino is
+	 * inside the starred range, the caller should receive updates:
+	 *
+	 * 0 ************ V ------------ S ************ EOFS
+	 */
+	if (ino >= iscan->scan_start_ino || ino <= iscan->__visited_ino)
+		ret = true;
+
+unlock:
 	mutex_unlock(&iscan->lock);
-
 	return ret;
 }
diff --git a/fs/xfs/scrub/iscan.h b/fs/xfs/scrub/iscan.h
index c25f121859ce2..0db97d98ee8da 100644
--- a/fs/xfs/scrub/iscan.h
+++ b/fs/xfs/scrub/iscan.h
@@ -12,6 +12,13 @@ struct xchk_iscan {
 	/* Lock to protect the scan cursor. */
 	struct mutex		lock;
 
+	/*
+	 * This is the first inode in the inumber address space that we
+	 * examined.  When the scan wraps around back to here, the scan is
+	 * finished.
+	 */
+	xfs_ino_t		scan_start_ino;
+
 	/* This is the inode that will be examined next. */
 	xfs_ino_t		cursor_ino;
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 29026d1d92931..5a70968bc3e2c 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1173,25 +1173,27 @@ DEFINE_EVENT(xchk_iscan_class, name, \
 DEFINE_ISCAN_EVENT(xchk_iscan_move_cursor);
 DEFINE_ISCAN_EVENT(xchk_iscan_visit);
 DEFINE_ISCAN_EVENT(xchk_iscan_advance_ag);
-DEFINE_ISCAN_EVENT(xchk_iscan_start);
 
 DECLARE_EVENT_CLASS(xchk_iscan_ino_class,
 	TP_PROTO(struct xchk_iscan *iscan, xfs_ino_t ino),
 	TP_ARGS(iscan, ino),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(xfs_ino_t, startino)
 		__field(xfs_ino_t, cursor)
 		__field(xfs_ino_t, visited)
 		__field(xfs_ino_t, ino)
 	),
 	TP_fast_assign(
 		__entry->dev = iscan->sc->mp->m_super->s_dev;
+		__entry->startino = iscan->scan_start_ino;
 		__entry->cursor = iscan->cursor_ino;
 		__entry->visited = iscan->__visited_ino;
 		__entry->ino = ino;
 	),
-	TP_printk("dev %d:%d iscan cursor 0x%llx visited 0x%llx ino 0x%llx",
+	TP_printk("dev %d:%d iscan start 0x%llx cursor 0x%llx visited 0x%llx ino 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->startino,
 		  __entry->cursor,
 		  __entry->visited,
 		  __entry->ino)
@@ -1201,6 +1203,7 @@ DEFINE_EVENT(xchk_iscan_ino_class, name, \
 	TP_PROTO(struct xchk_iscan *iscan, xfs_ino_t ino), \
 	TP_ARGS(iscan, ino))
 DEFINE_ISCAN_INO_EVENT(xchk_iscan_want_live_update);
+DEFINE_ISCAN_INO_EVENT(xchk_iscan_start);
 
 TRACE_EVENT(xchk_iscan_iget,
 	TP_PROTO(struct xchk_iscan *iscan, int error),

