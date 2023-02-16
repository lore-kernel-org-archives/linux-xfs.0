Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58152C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjBPUpA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBPUo7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:44:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E304ECDC
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:44:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AB5EB82958
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F01C433EF;
        Thu, 16 Feb 2023 20:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580294;
        bh=ok1zIZmGRdXK76Q0pNtsprAHkqPAM7gOcyzRtk3noeI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=VzAWJojXZAWs438Sby2rOdXZ4QvWCOwC9deS58ZIXCoN7J5gzDCgobKT3tEMZT+Ot
         XGi5T4bp59REiAGPteQByvzM3EUDf8QfIlW5YTi7FftnmBuXicf1gjotv+eHCQozEc
         vuY5TzJE6zERXpnVD795hIPwS0H0aOQxuPdVI73InACYzmksDlKX70axetHUeCZ2Xt
         pg6XZYY9s0Iq4fjyI3am466e92EkFAAFtWyAc8lkWnuBxo/WxcKkchFDP9RY1mQ5OU
         RYbMQvVtdk40peCA1oV+qC+BwKQZNju4xDk0xy9ymibE6MN28RiAjHe5VMQfzn3I0f
         DSSEmE0HGlJwg==
Date:   Thu, 16 Feb 2023 12:44:53 -0800
Subject: [PATCH 12/23] xfs: port scrub inode scan from djwong-dev
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874007.3474338.13621018084165784177.stgit@magnolia>
In-Reply-To: <167657873813.3474338.3118516275923112371.stgit@magnolia>
References: <167657873813.3474338.3118516275923112371.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Port the inode scanning code from djwong-dev so we can use it here.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile      |    1 
 fs/xfs/scrub/iscan.c |  483 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/iscan.h |   65 +++++++
 fs/xfs/scrub/trace.c |    1 
 fs/xfs/scrub/trace.h |   73 ++++++++
 fs/xfs/xfs_icache.c  |    3 
 fs/xfs/xfs_icache.h  |   11 +
 7 files changed, 632 insertions(+), 5 deletions(-)
 create mode 100644 fs/xfs/scrub/iscan.c
 create mode 100644 fs/xfs/scrub/iscan.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index b55b8ece7627..69805b4ad79f 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -157,6 +157,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   health.o \
 				   ialloc.o \
 				   inode.o \
+				   iscan.o \
 				   parent.o \
 				   refcount.o \
 				   rmap.o \
diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
new file mode 100644
index 000000000000..8cf486dfde19
--- /dev/null
+++ b/fs/xfs/scrub/iscan.c
@@ -0,0 +1,483 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_inode.h"
+#include "xfs_btree.h"
+#include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_ag.h"
+#include "xfs_error.h"
+#include "xfs_bit.h"
+#include "xfs_icache.h"
+#include "scrub/scrub.h"
+#include "scrub/iscan.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+
+/*
+ * Live File Scan
+ * ==============
+ *
+ * Live file scans walk every inode in a live filesystem.  This is more or
+ * less like a regular iwalk, except that when we're advancing the scan cursor,
+ * we must ensure that inodes cannot be added or deleted anywhere between the
+ * old cursor value and the new cursor value.  If we're advancing the cursor
+ * by one inode, the caller must hold that inode; if we're finding the next
+ * inode to scan, we must grab the AGI and hold it until we've updated the
+ * scan cursor.
+ *
+ * Callers are expected to use this code to scan all files in the filesystem to
+ * construct a new metadata index of some kind.  The scan races against other
+ * live updates, which means there must be a provision to update the new index
+ * when updates are made to inodes that already been scanned.  The iscan lock
+ * can be used in live update hook code to stop the scan and protect this data
+ * structure.
+ *
+ * To keep the new index up to date with other metadata updates being made to
+ * the live filesystem, it is assumed that the caller will add hooks as needed
+ * to be notified when a metadata update occurs.  The inode scanner must tell
+ * the hook code when an inode has been visited with xchk_iscan_mark_visit.
+ * Hook functions can use xchk_iscan_want_live_update to decide if the
+ * scanner's observations must be updated.
+ */
+
+/*
+ * Set the bits in @irec's free mask that correspond to the inodes before
+ * @agino so that we skip them.  This is how we restart an inode walk that was
+ * interrupted in the middle of an inode record.
+ */
+STATIC void
+xchk_iscan_adjust_start(
+	xfs_agino_t			agino,	/* starting inode of chunk */
+	struct xfs_inobt_rec_incore	*irec)	/* btree record */
+{
+	int				idx;	/* index into inode chunk */
+
+	idx = agino - irec->ir_startino;
+
+	irec->ir_free |= xfs_inobt_maskn(0, idx);
+	irec->ir_freecount = hweight64(irec->ir_free);
+}
+
+/*
+ * Set *cursor to the next allocated inode after whatever it's set to now.
+ * If there are no more inodes in this AG, cursor is set to NULLAGINO.
+ */
+STATIC int
+xchk_iscan_find_next(
+	struct xfs_scrub	*sc,
+	struct xfs_buf		*agi_bp,
+	struct xfs_perag	*pag,
+	xfs_agino_t		*cursor)
+{
+	struct xfs_inobt_rec_incore	rec;
+	struct xfs_btree_cur	*cur;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_trans	*tp = sc->tp;
+	xfs_agnumber_t		agno = pag->pag_agno;
+	xfs_agino_t		lastino = NULLAGINO;
+	xfs_agino_t		first, last;
+	xfs_agino_t		agino = *cursor;
+	int			has_rec;
+	int			error;
+
+	/* If the cursor is beyond the end of this AG, move to the next one. */
+	xfs_agino_range(mp, agno, &first, &last);
+	if (agino > last) {
+		*cursor = NULLAGINO;
+		return 0;
+	}
+
+	/*
+	 * Look up the inode chunk for the current cursor position.  If there
+	 * is no chunk here, we want the next one.
+	 */
+	cur = xfs_inobt_init_cursor(mp, tp, agi_bp, pag, XFS_BTNUM_INO);
+	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &has_rec);
+	if (!error && !has_rec)
+		error = xfs_btree_increment(cur, 0, &has_rec);
+	for (; !error; error = xfs_btree_increment(cur, 0, &has_rec)) {
+		/*
+		 * If we've run out of inobt records in this AG, move the
+		 * cursor on to the next AG and exit.  The caller can try
+		 * again with the next AG.
+		 */
+		if (!has_rec) {
+			*cursor = NULLAGINO;
+			break;
+		}
+
+		error = xfs_inobt_get_rec(cur, &rec, &has_rec);
+		if (error)
+			break;
+		if (!has_rec) {
+			error = -EFSCORRUPTED;
+			break;
+		}
+
+		/* Make sure that we always move forward. */
+		if (lastino != NULLAGINO &&
+		    XFS_IS_CORRUPT(mp, lastino >= rec.ir_startino)) {
+			error = -EFSCORRUPTED;
+			break;
+		}
+		lastino = rec.ir_startino + XFS_INODES_PER_CHUNK - 1;
+
+		/*
+		 * If this record only covers inodes that come before the
+		 * cursor, advance to the next record.
+		 */
+		if (rec.ir_startino + XFS_INODES_PER_CHUNK <= agino)
+			continue;
+
+		/*
+		 * If the incoming lookup put us in the middle of an inobt
+		 * record, mark it and the previous inodes "free" so that the
+		 * search for allocated inodes will start at the cursor.  Use
+		 * funny math to avoid overflowing the bit shift.
+		 */
+		if (agino >= rec.ir_startino)
+			xchk_iscan_adjust_start(agino + 1, &rec);
+
+		/*
+		 * If there are allocated inodes in this chunk, find them,
+		 * and update the cursor.
+		 */
+		if (rec.ir_freecount < XFS_INODES_PER_CHUNK) {
+			int	next = xfs_lowbit64(~rec.ir_free);
+
+			*cursor = rec.ir_startino + next;
+			break;
+		}
+	}
+
+	xfs_btree_del_cursor(cur, error);
+	return error;
+}
+
+/*
+ * Prepare to return agno/agino to the iscan caller by moving the lastino
+ * cursor to the previous inode.  Do this while we still hold the AGI so that
+ * no other threads can create or delete inodes in this AG.
+ */
+static inline void
+xchk_iscan_move_cursor(
+	struct xfs_scrub	*sc,
+	struct xchk_iscan	*iscan,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		agino)
+{
+	struct xfs_mount	*mp = sc->mp;
+
+	mutex_lock(&iscan->lock);
+	iscan->cursor_ino = XFS_AGINO_TO_INO(mp, agno, agino);
+	iscan->__visited_ino = iscan->cursor_ino - 1;
+	trace_xchk_iscan_move_cursor(mp, iscan);
+	mutex_unlock(&iscan->lock);
+}
+
+/*
+ * Prepare to return agno/agino to the iscan caller by moving the lastino
+ * cursor to the previous inode.  Do this while we still hold the AGI so that
+ * no other threads can create or delete inodes in this AG.
+ */
+static inline void
+xchk_iscan_finish_scan(
+	struct xfs_scrub	*sc,
+	struct xchk_iscan	*iscan)
+{
+	struct xfs_mount	*mp = sc->mp;
+
+	mutex_lock(&iscan->lock);
+	iscan->cursor_ino = NULLFSINO;
+
+	/* All live updates will be applied from now on */
+	iscan->__visited_ino = NULLFSINO;
+
+	trace_xchk_iscan_move_cursor(mp, iscan);
+	mutex_unlock(&iscan->lock);
+}
+
+/*
+ * Advance ino to the next inode that the inobt thinks is allocated, being
+ * careful to jump to the next AG if we've reached the right end of this AG's
+ * inode btree.  Advancing ino effectively means that we've pushed the inode
+ * scan forward, so set the iscan cursor to (ino - 1) so that our live update
+ * predicates will track inode allocations in that part of the inode number
+ * key space once we release the AGI buffer.
+ *
+ * Returns 1 if there's a new inode to examine, 0 if we've run out of inodes,
+ * -ECANCELED if the live scan aborted, or the usual negative errno.
+ */
+STATIC int
+xchk_iscan_advance(
+	struct xfs_scrub	*sc,
+	struct xchk_iscan	*iscan,
+	struct xfs_buf		**agi_bpp)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_buf		*agi_bp;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	xfs_agino_t		agino;
+	int			ret;
+
+	ASSERT(iscan->cursor_ino >= iscan->__visited_ino);
+
+	do {
+		agno = XFS_INO_TO_AGNO(mp, iscan->cursor_ino);
+		pag = xfs_perag_get(mp, agno);
+		if (!pag) {
+			xchk_iscan_finish_scan(sc, iscan);
+			return 0;
+		}
+
+		ret = xfs_ialloc_read_agi(pag, sc->tp, &agi_bp);
+		if (ret)
+			goto out_pag;
+
+		agino = XFS_INO_TO_AGINO(mp, iscan->cursor_ino);
+		ret = xchk_iscan_find_next(sc, agi_bp, pag, &agino);
+		if (ret)
+			goto out_buf;
+
+		if (agino != NULLAGINO)
+			break;
+
+		xchk_iscan_move_cursor(sc, iscan, agno + 1, 0);
+		xfs_trans_brelse(sc->tp, agi_bp);
+		xfs_perag_put(pag);
+
+		if (xchk_iscan_aborted(iscan))
+			return -ECANCELED;
+	} while (1);
+
+	xchk_iscan_move_cursor(sc, iscan, agno, agino);
+	*agi_bpp = agi_bp;
+	xfs_perag_put(pag);
+	return 1;
+
+out_buf:
+	xfs_trans_brelse(sc->tp, agi_bp);
+out_pag:
+	xfs_perag_put(pag);
+	return ret;
+}
+
+/*
+ * Grabbing the inode failed, so we need to back up the scan and ask the caller
+ * to try to _advance the scan again.  Returns -EBUSY if we've run out of retry
+ * opportunities, -ECANCELED if the process has a fatal signal pending, or
+ * -EAGAIN if we should try again.
+ */
+STATIC int
+xchk_iscan_iget_retry(
+	struct xfs_mount	*mp,
+	struct xchk_iscan	*iscan,
+	bool			wait)
+{
+	ASSERT(iscan->cursor_ino == iscan->__visited_ino + 1);
+
+	if (!iscan->iget_timeout ||
+	    time_is_before_jiffies(iscan->__iget_deadline))
+		return -EBUSY;
+
+	if (wait) {
+		unsigned long	relax;
+
+		/*
+		 * Sleep for a period of time to let the rest of the system
+		 * catch up.  If we return early, someone sent a kill signal to
+		 * the calling process.
+		 */
+		relax = msecs_to_jiffies(iscan->iget_retry_delay);
+		trace_xchk_iscan_iget_retry_wait(mp, iscan);
+
+		if (schedule_timeout_killable(relax) ||
+		    xchk_iscan_aborted(iscan))
+			return -ECANCELED;
+	}
+
+	iscan->cursor_ino--;
+	return -EAGAIN;
+}
+
+/*
+ * Grab an inode as part of an inode scan.  While scanning this inode, the
+ * caller must ensure that no other threads can modify the inode until a call
+ * to xchk_iscan_visit succeeds.
+ *
+ * Returns 0 and an incore inode; -EAGAIN if the caller should call again
+ * xchk_iscan_advance; -EBUSY if we couldn't grab an inode; -ECANCELED if
+ * there's a fatal signal pending; or some other negative errno.
+ */
+STATIC int
+xchk_iscan_iget(
+	struct xfs_scrub	*sc,
+	struct xchk_iscan	*iscan,
+	struct xfs_buf		*agi_bp,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_mount	*mp = sc->mp;
+	int			error;
+
+	error = xfs_iget(sc->mp, sc->tp, iscan->cursor_ino, XFS_IGET_NORETRY, 0,
+			ipp);
+	xfs_trans_brelse(sc->tp, agi_bp);
+
+	trace_xchk_iscan_iget(mp, iscan, error);
+
+	if (error == -ENOENT || error == -EAGAIN) {
+		/*¬
+		 * It's possible that this inode has lost all of its links but
+		 * hasn't yet been inactivated.  If we don't have a transaction
+		 * or it's not writable, flush the inodegc workers and wait.
+		 * Otherwise, we have a dirty transaction in progress and the
+		 * best we can do is to queue the inodegc workers.
+		 */
+		if (!iscan->iget_nowait)
+			xfs_inodegc_flush(mp);
+		else
+			xfs_inodegc_push(mp);
+		return xchk_iscan_iget_retry(mp, iscan, true);
+	}
+
+	if (error == -EINVAL) {
+		/*
+		 * We thought the inode was allocated, but the inode btree
+		 * lookup failed, which means that it was freed since the last
+		 * time we advanced the cursor.  Back up and try again.  This
+		 * should never happen since still hold the AGI buffer from the
+		 * inobt check, but we need to be careful about infinite loops.
+		 */
+		return xchk_iscan_iget_retry(mp, iscan, false);
+	}
+
+	return error;
+}
+
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
+	struct xfs_scrub	*sc,
+	struct xchk_iscan	*iscan,
+	struct xfs_inode	**ipp)
+{
+	int			ret;
+
+	if (iscan->iget_timeout)
+		iscan->__iget_deadline = jiffies +
+					 msecs_to_jiffies(iscan->iget_timeout);
+
+	do {
+		struct xfs_buf	*agi_bp = NULL;
+
+		ret = xchk_iscan_advance(sc, iscan, &agi_bp);
+		if (ret != 1)
+			return ret;
+
+		if (xchk_iscan_aborted(iscan)) {
+			xfs_trans_brelse(sc->tp, agi_bp);
+			ret = -ECANCELED;
+			break;
+		}
+
+		ret = xchk_iscan_iget(sc, iscan, agi_bp, ipp);
+	} while (ret == -EAGAIN);
+
+	if (!ret)
+		return 1;
+
+	return ret;
+}
+
+
+/* Release inode scan resources. */
+void
+xchk_iscan_finish(
+	struct xchk_iscan	*iscan)
+{
+	mutex_destroy(&iscan->lock);
+	iscan->cursor_ino = NULLFSINO;
+	iscan->__visited_ino = NULLFSINO;
+}
+
+/*
+ * Set ourselves up to start an inode scan.  If the @iget_timeout and
+ * @iget_retry_delay parameters are set, the scan will try to iget each inode
+ * for @iget_timeout milliseconds.  If an iget call indicates that the inode is
+ * waiting to be inactivated, the CPU will relax for @iget_retry_delay
+ * milliseconds after pushing the inactivation workers.
+ */
+void
+xchk_iscan_start(
+	struct xchk_iscan	*iscan,
+	unsigned int		iget_timeout,
+	unsigned int		iget_retry_delay)
+{
+	clear_bit(XCHK_ISCAN_OPSTATE_ABORTED, &iscan->__opstate);
+	iscan->iget_timeout = iget_timeout;
+	iscan->iget_retry_delay = iget_retry_delay;
+	iscan->__visited_ino = 0;
+	iscan->cursor_ino = 0;
+	mutex_init(&iscan->lock);
+}
+
+/*
+ * Mark this inode as having been visited.  Callers must hold a sufficiently
+ * exclusive lock on the inode to prevent concurrent modifications.
+ */
+void
+xchk_iscan_mark_visited(
+	struct xchk_iscan	*iscan,
+	struct xfs_inode	*ip)
+{
+	mutex_lock(&iscan->lock);
+	iscan->__visited_ino = ip->i_ino;
+	trace_xchk_iscan_visit(ip->i_mount, iscan);
+	mutex_unlock(&iscan->lock);
+}
+
+/*
+ * Do we need a live update for this inode?  This is true if the scanner thread
+ * has visited this inode and the scan hasn't been aborted due to errors.
+ * Callers must hold a sufficiently exclusive lock on the inode to prevent
+ * scanners from reading any inode metadata.
+ */
+bool
+xchk_iscan_want_live_update(
+	struct xchk_iscan	*iscan,
+	xfs_ino_t		ino)
+{
+        bool			ret;
+
+	if (xchk_iscan_aborted(iscan))
+		return false;
+
+	mutex_lock(&iscan->lock);
+	ret = iscan->__visited_ino >= ino;
+	mutex_unlock(&iscan->lock);
+
+	return ret;
+}
diff --git a/fs/xfs/scrub/iscan.h b/fs/xfs/scrub/iscan.h
new file mode 100644
index 000000000000..f10b71d9cec4
--- /dev/null
+++ b/fs/xfs/scrub/iscan.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_ISCAN_H__
+#define __XFS_SCRUB_ISCAN_H__
+
+struct xchk_iscan {
+	/* Lock to protect the scan cursor. */
+	struct mutex		lock;
+
+	/* This is the inode that will be examined next. */
+	xfs_ino_t		cursor_ino;
+
+	/*
+	 * This is the last inode that we've successfully scanned, either
+	 * because the caller scanned it, or we moved the cursor past an empty
+	 * part of the inode address space.  Scan callers should only use the
+	 * xchk_iscan_visit function to modify this.
+	 */
+	xfs_ino_t		__visited_ino;
+
+	/* Operational state of the livescan. */
+	unsigned long		__opstate;
+
+	/* Give up on iterating @cursor_ino if we can't iget it by this time. */
+	unsigned long		__iget_deadline;
+
+	/* Amount of time (in ms) that we will try to iget an inode. */
+	unsigned int		iget_timeout;
+
+	/* Wait this many ms to retry an iget. */
+	unsigned int		iget_retry_delay;
+
+	/* True if we cannot allow iget to wait indefinitely. */
+	bool			iget_nowait:1;
+};
+
+/* Set if the scan has been aborted due to some event in the fs. */
+#define XCHK_ISCAN_OPSTATE_ABORTED	(1)
+
+static inline bool
+xchk_iscan_aborted(const struct xchk_iscan *iscan)
+{
+	return test_bit(XCHK_ISCAN_OPSTATE_ABORTED, &iscan->__opstate);
+}
+
+static inline void
+xchk_iscan_abort(struct xchk_iscan *iscan)
+{
+	set_bit(XCHK_ISCAN_OPSTATE_ABORTED, &iscan->__opstate);
+}
+
+void xchk_iscan_start(struct xchk_iscan *iscan, unsigned int iget_timeout,
+		unsigned int iget_retry_delay);
+void xchk_iscan_finish(struct xchk_iscan *iscan);
+
+int xchk_iscan_iter(struct xfs_scrub *sc, struct xchk_iscan *iscan,
+		struct xfs_inode **ipp);
+
+void xchk_iscan_mark_visited(struct xchk_iscan *iscan, struct xfs_inode *ip);
+bool xchk_iscan_want_live_update(struct xchk_iscan *iscan, xfs_ino_t ino);
+
+#endif /* __XFS_SCRUB_ISCAN_H__ */
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 4a0385c97ea6..83e8a64c95d4 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -16,6 +16,7 @@
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
+#include "scrub/iscan.h"
 
 /* Figure out which block the btree cursor was pointing to. */
 static inline xfs_fsblock_t
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 25086df0963c..d97c9a40186a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -18,6 +18,7 @@
 
 struct xfile;
 struct xfarray;
+struct xchk_iscan;
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
@@ -780,6 +781,78 @@ TRACE_EVENT(xfarray_create,
 		  __entry->obj_size_log)
 );
 
+DECLARE_EVENT_CLASS(xchk_iscan_class,
+	TP_PROTO(struct xfs_mount *mp, struct xchk_iscan *iscan),
+	TP_ARGS(mp, iscan),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, cursor)
+		__field(xfs_ino_t, visited)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->cursor = iscan->cursor_ino;
+		__entry->visited = iscan->__visited_ino;
+	),
+	TP_printk("dev %d:%d iscan cursor 0x%llx visited 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->cursor, __entry->visited)
+)
+#define DEFINE_ISCAN_EVENT(name) \
+DEFINE_EVENT(xchk_iscan_class, name, \
+	TP_PROTO(struct xfs_mount *mp, struct xchk_iscan *iscan), \
+	TP_ARGS(mp, iscan))
+DEFINE_ISCAN_EVENT(xchk_iscan_move_cursor);
+DEFINE_ISCAN_EVENT(xchk_iscan_visit);
+
+TRACE_EVENT(xchk_iscan_iget,
+	TP_PROTO(struct xfs_mount *mp, struct xchk_iscan *iscan, int error),
+	TP_ARGS(mp, iscan, error),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, cursor)
+		__field(xfs_ino_t, visited)
+		__field(int, error)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->cursor = iscan->cursor_ino;
+		__entry->visited = iscan->__visited_ino;
+		__entry->error = error;
+	),
+	TP_printk("dev %d:%d iscan cursor 0x%llx visited 0x%llx error %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->cursor, __entry->visited, __entry->error)
+);
+
+TRACE_EVENT(xchk_iscan_iget_retry_wait,
+	TP_PROTO(struct xfs_mount *mp, struct xchk_iscan *iscan),
+	TP_ARGS(mp, iscan),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, cursor)
+		__field(xfs_ino_t, visited)
+		__field(unsigned int, retry_delay)
+		__field(unsigned long, remaining)
+		__field(unsigned int, iget_timeout)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->cursor = iscan->cursor_ino;
+		__entry->visited = iscan->__visited_ino;
+		__entry->retry_delay = iscan->iget_retry_delay;
+		__entry->remaining = jiffies_to_msecs(iscan->__iget_deadline - jiffies);
+		__entry->iget_timeout = iscan->iget_timeout;
+	),
+	TP_printk("dev %d:%d iscan cursor 0x%llx visited 0x%llx remaining %lu timeout %u delay %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->cursor,
+		  __entry->visited,
+		  __entry->remaining,
+		  __entry->iget_timeout,
+		  __entry->retry_delay)
+);
+
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ddeaccc04aec..0d58d7b0d8ac 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -767,7 +767,8 @@ xfs_iget(
 	return 0;
 
 out_error_or_again:
-	if (!(flags & XFS_IGET_INCORE) && error == -EAGAIN) {
+	if (!(flags & (XFS_IGET_INCORE | XFS_IGET_NORETRY)) &&
+	    error == -EAGAIN) {
 		delay(1);
 		goto again;
 	}
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 6cd180721659..87910191a9dd 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -34,10 +34,13 @@ struct xfs_icwalk {
 /*
  * Flags for xfs_iget()
  */
-#define XFS_IGET_CREATE		0x1
-#define XFS_IGET_UNTRUSTED	0x2
-#define XFS_IGET_DONTCACHE	0x4
-#define XFS_IGET_INCORE		0x8	/* don't read from disk or reinit */
+#define XFS_IGET_CREATE		(1U << 0)
+#define XFS_IGET_UNTRUSTED	(1U << 1)
+#define XFS_IGET_DONTCACHE	(1U << 2)
+/* don't read from disk or reinit */
+#define XFS_IGET_INCORE		(1U << 3)
+/* Return -EAGAIN immediately if the inode is unavailable. */
+#define XFS_IGET_NORETRY	(1U << 4)
 
 int xfs_iget(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t ino,
 	     uint flags, uint lock_flags, xfs_inode_t **ipp);

