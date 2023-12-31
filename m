Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E0BB671
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U3LNVzdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABACC433C7;
	Sun, 31 Dec 2023 20:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053098;
	bh=R3J7qkOocHpYUBooRveODrgRQKX0d4aeAjZBtl2TfA4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U3LNVzdz90nZsStklNnoICl9eZtBU2QgLLlA+Iw+ZERPvDBN8csL/N+qJsHcWHT1+
	 duTDKPSKCl7bvuR1nef1HQvulOOntX/+I4k9e5qjczXqEP4wcxgsvuZ9iK9XAJV/lo
	 I3lC3H6EoK5wyFZBzFFucUXXCrHOk7bGs6FDosEqX27HUvLD7o4m0qkB5v6BjpDSrk
	 Uv2CfY7xwV4bWclZvp1wKki3DgRjwx8Pcuy9vPcAeJlm5u59AxEiNoe2Wx31/3FyoJ
	 I6ZccPz2dcUNSY2OotWbZBuwGiFQTLeR0NB67Zpmj3ZlZVKJudI0IN1tdyZicjxsRF
	 kSXV4pOTuQjNw==
Date: Sun, 31 Dec 2023 12:04:58 -0800
Subject: [PATCH 2/7] xfs: implement live inode scan for scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404826539.1747630.1668252376408967257.stgit@frogsfrogsfrogs>
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

This patch implements a live file scanner for online fsck functions that
require the ability to walk a filesystem to gather metadata records and
stay informed about metadata changes to files that have already been
visited.

The iscan structure consists of two inode number cursors: one to track
which inode we want to visit next, and a second one to track which
inodes have already been visited.  This second cursor is key to
capturing live updates to files previously scanned while the main thread
continues scanning -- any inode greater than this value hasn't been
scanned and can go on its way; any other update must be incorporated
into the collected data.  It is critical for the scanning thraad to hold
exclusive access on the inode until after marking the inode visited.

This new code is a separate patch from the patchsets adding callers for
the sake of enabling the author to move patches around his tree with
ease.  The intended usage model for this code is roughly:

	xchk_iscan_start(iscan, 0, 0);
	while ((error = xchk_iscan_iter(sc, iscan, &ip)) == 1) {
		xfs_ilock(ip, ...);
		/* capture inode metadata */
		xchk_iscan_mark_visited(iscan, ip);
		xfs_iunlock(ip, ...);

		xfs_irele(ip);
	}
	xchk_iscan_stop(iscan);
	if (error)
		return error;

Hook functions for live updates can then do:

	if (xchk_iscan_want_live_update(...))
		/* update the captured inode metadata */

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile      |    1 
 fs/xfs/scrub/iscan.c |  485 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/iscan.h |   63 ++++++
 fs/xfs/scrub/trace.c |    1 
 fs/xfs/scrub/trace.h |  106 +++++++++++
 5 files changed, 656 insertions(+)
 create mode 100644 fs/xfs/scrub/iscan.c
 create mode 100644 fs/xfs/scrub/iscan.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index fbe3cdc79036b..e5990a392ad62 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -159,6 +159,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   health.o \
 				   ialloc.o \
 				   inode.o \
+				   iscan.o \
 				   parent.o \
 				   readdir.o \
 				   refcount.o \
diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
new file mode 100644
index 0000000000000..d4c1fe0538df9
--- /dev/null
+++ b/fs/xfs/scrub/iscan.c
@@ -0,0 +1,485 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
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
+ * Set *cursor to the next allocated inode after whatever it's set to now.
+ * If there are no more inodes in this AG, cursor is set to NULLAGINO.
+ */
+STATIC int
+xchk_iscan_find_next(
+	struct xchk_iscan	*iscan,
+	struct xfs_buf		*agi_bp,
+	struct xfs_perag	*pag,
+	xfs_agino_t		*cursor)
+{
+	struct xfs_scrub	*sc = iscan->sc;
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
+	cur = xfs_inobt_init_cursor(pag, tp, agi_bp, XFS_BTNUM_INO);
+	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &has_rec);
+	if (!error && !has_rec)
+		error = xfs_btree_increment(cur, 0, &has_rec);
+	for (; !error; error = xfs_btree_increment(cur, 0, &has_rec)) {
+		xfs_inofree_t	allocmask;
+
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
+		 * search for allocated inodes will start at the cursor.
+		 * We don't care about ir_freecount here.
+		 */
+		if (agino >= rec.ir_startino)
+			rec.ir_free |= xfs_inobt_maskn(0,
+						agino + 1 - rec.ir_startino);
+
+		/*
+		 * If there are allocated inodes in this chunk, find them
+		 * and update the scan cursor.
+		 */
+		allocmask = ~rec.ir_free;
+		if (hweight64(allocmask) > 0) {
+			int	next = xfs_lowbit64(allocmask);
+
+			ASSERT(next >= 0);
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
+ * Advance both the scan and the visited cursors.
+ *
+ * The inumber address space for a given filesystem is sparse, which means that
+ * the scan cursor can jump a long ways in a single iter() call.  There are no
+ * inodes in these sparse areas, so we must move the visited cursor forward at
+ * the same time so that the scan user can receive live updates for inodes that
+ * may get created once we release the AGI buffer.
+ */
+static inline void
+xchk_iscan_move_cursor(
+	struct xchk_iscan	*iscan,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		agino)
+{
+	struct xfs_scrub	*sc = iscan->sc;
+	struct xfs_mount	*mp = sc->mp;
+
+	mutex_lock(&iscan->lock);
+	iscan->cursor_ino = XFS_AGINO_TO_INO(mp, agno, agino);
+	iscan->__visited_ino = iscan->cursor_ino - 1;
+	trace_xchk_iscan_move_cursor(iscan);
+	mutex_unlock(&iscan->lock);
+}
+
+/*
+ * Prepare to return agno/agino to the iscan caller by moving the lastino
+ * cursor to the previous inode.  Do this while we still hold the AGI so that
+ * no other threads can create or delete inodes in this AG.
+ */
+static inline void
+xchk_iscan_finish(
+	struct xchk_iscan	*iscan)
+{
+	mutex_lock(&iscan->lock);
+	iscan->cursor_ino = NULLFSINO;
+
+	/* All live updates will be applied from now on */
+	iscan->__visited_ino = NULLFSINO;
+
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
+	struct xchk_iscan	*iscan,
+	struct xfs_perag	**pagp,
+	struct xfs_buf		**agi_bpp)
+{
+	struct xfs_scrub	*sc = iscan->sc;
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
+		if (xchk_iscan_aborted(iscan))
+			return -ECANCELED;
+
+		agno = XFS_INO_TO_AGNO(mp, iscan->cursor_ino);
+		pag = xfs_perag_get(mp, agno);
+		if (!pag)
+			return -ECANCELED;
+
+		ret = xfs_ialloc_read_agi(pag, sc->tp, &agi_bp);
+		if (ret)
+			goto out_pag;
+
+		agino = XFS_INO_TO_AGINO(mp, iscan->cursor_ino);
+		ret = xchk_iscan_find_next(iscan, agi_bp, pag, &agino);
+		if (ret)
+			goto out_buf;
+
+		if (agino != NULLAGINO) {
+			/*
+			 * Found the next inode in this AG, so return it along
+			 * with the AGI buffer and the perag structure to
+			 * ensure it cannot go away.
+			 */
+			xchk_iscan_move_cursor(iscan, agno, agino);
+			*agi_bpp = agi_bp;
+			*pagp = pag;
+			return 1;
+		}
+
+		/*
+		 * Did not find any more inodes in this AG, move on to the next
+		 * AG.
+		 */
+		xchk_iscan_move_cursor(iscan, ++agno, 0);
+		xfs_trans_brelse(sc->tp, agi_bp);
+		xfs_perag_put(pag);
+
+		trace_xchk_iscan_advance_ag(iscan);
+	} while (agno < mp->m_sb.sb_agcount);
+
+	xchk_iscan_finish(iscan);
+	return 0;
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
+		trace_xchk_iscan_iget_retry_wait(iscan);
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
+	struct xchk_iscan	*iscan,
+	struct xfs_perag	*pag,
+	struct xfs_buf		*agi_bp,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_scrub	*sc = iscan->sc;
+	struct xfs_mount	*mp = sc->mp;
+	int			error;
+
+	error = xfs_iget(sc->mp, sc->tp, iscan->cursor_ino, XFS_IGET_NORETRY,
+			0, ipp);
+	xfs_trans_brelse(sc->tp, agi_bp);
+	xfs_perag_put(pag);
+
+	trace_xchk_iscan_iget(iscan, error);
+
+	if (error == -ENOENT || error == -EAGAIN) {
+		/*¬
+		 * It's possible that this inode has lost all of its links but
+		 * hasn't yet been inactivated.  If we don't have a transaction
+		 * or it's not writable, flush the inodegc workers and wait.
+		 */
+		xfs_inodegc_flush(mp);
+		return xchk_iscan_iget_retry(iscan, true);
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
+		return xchk_iscan_iget_retry(iscan, false);
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
+	struct xchk_iscan	*iscan,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_scrub	*sc = iscan->sc;
+	int			ret;
+
+	if (iscan->iget_timeout)
+		iscan->__iget_deadline = jiffies +
+					 msecs_to_jiffies(iscan->iget_timeout);
+
+	do {
+		struct xfs_buf	*agi_bp = NULL;
+		struct xfs_perag *pag = NULL;
+
+		ret = xchk_iscan_advance(iscan, &pag, &agi_bp);
+		if (ret != 1)
+			return ret;
+
+		if (xchk_iscan_aborted(iscan)) {
+			xfs_trans_brelse(sc->tp, agi_bp);
+			xfs_perag_put(pag);
+			ret = -ECANCELED;
+			break;
+		}
+
+		ret = xchk_iscan_iget(iscan, pag, agi_bp, ipp);
+	} while (ret == -EAGAIN);
+
+	if (!ret)
+		return 1;
+
+	return ret;
+}
+
+
+/* Mark this inode scan finished and release resources. */
+void
+xchk_iscan_teardown(
+	struct xchk_iscan	*iscan)
+{
+	xchk_iscan_finish(iscan);
+	mutex_destroy(&iscan->lock);
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
+	struct xfs_scrub	*sc,
+	unsigned int		iget_timeout,
+	unsigned int		iget_retry_delay,
+	struct xchk_iscan	*iscan)
+{
+	iscan->sc = sc;
+	clear_bit(XCHK_ISCAN_OPSTATE_ABORTED, &iscan->__opstate);
+	iscan->iget_timeout = iget_timeout;
+	iscan->iget_retry_delay = iget_retry_delay;
+	iscan->__visited_ino = 0;
+	iscan->cursor_ino = 0;
+	mutex_init(&iscan->lock);
+
+	trace_xchk_iscan_start(iscan);
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
+	trace_xchk_iscan_visit(iscan);
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
+	bool			ret;
+
+	if (xchk_iscan_aborted(iscan))
+		return false;
+
+	mutex_lock(&iscan->lock);
+	trace_xchk_iscan_want_live_update(iscan, ino);
+	ret = iscan->__visited_ino >= ino;
+	mutex_unlock(&iscan->lock);
+
+	return ret;
+}
diff --git a/fs/xfs/scrub/iscan.h b/fs/xfs/scrub/iscan.h
new file mode 100644
index 0000000000000..c25f121859ce2
--- /dev/null
+++ b/fs/xfs/scrub/iscan.h
@@ -0,0 +1,63 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_ISCAN_H__
+#define __XFS_SCRUB_ISCAN_H__
+
+struct xchk_iscan {
+	struct xfs_scrub	*sc;
+
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
+void xchk_iscan_start(struct xfs_scrub *sc, unsigned int iget_timeout,
+		unsigned int iget_retry_delay, struct xchk_iscan *iscan);
+void xchk_iscan_teardown(struct xchk_iscan *iscan);
+
+int xchk_iscan_iter(struct xchk_iscan *iscan, struct xfs_inode **ipp);
+
+void xchk_iscan_mark_visited(struct xchk_iscan *iscan, struct xfs_inode *ip);
+bool xchk_iscan_want_live_update(struct xchk_iscan *iscan, xfs_ino_t ino);
+
+#endif /* __XFS_SCRUB_ISCAN_H__ */
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index d0e24ffaf7547..4542eeebab6f1 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -20,6 +20,7 @@
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
 #include "scrub/quota.h"
+#include "scrub/iscan.h"
 
 /* Figure out which block the btree cursor was pointing to. */
 static inline xfs_fsblock_t
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 6bbb4e8639dca..138637198ad86 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -16,10 +16,12 @@
 #include <linux/tracepoint.h>
 #include "xfs_bit.h"
 
+struct xfs_scrub;
 struct xfile;
 struct xfarray;
 struct xfarray_sortinfo;
 struct xchk_dqiter;
+struct xchk_iscan;
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
@@ -1119,6 +1121,110 @@ TRACE_EVENT(xchk_rtsum_record_free,
 );
 #endif /* CONFIG_XFS_RT */
 
+DECLARE_EVENT_CLASS(xchk_iscan_class,
+	TP_PROTO(struct xchk_iscan *iscan),
+	TP_ARGS(iscan),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, cursor)
+		__field(xfs_ino_t, visited)
+	),
+	TP_fast_assign(
+		__entry->dev = iscan->sc->mp->m_super->s_dev;
+		__entry->cursor = iscan->cursor_ino;
+		__entry->visited = iscan->__visited_ino;
+	),
+	TP_printk("dev %d:%d iscan cursor 0x%llx visited 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->cursor,
+		  __entry->visited)
+)
+#define DEFINE_ISCAN_EVENT(name) \
+DEFINE_EVENT(xchk_iscan_class, name, \
+	TP_PROTO(struct xchk_iscan *iscan), \
+	TP_ARGS(iscan))
+DEFINE_ISCAN_EVENT(xchk_iscan_move_cursor);
+DEFINE_ISCAN_EVENT(xchk_iscan_visit);
+DEFINE_ISCAN_EVENT(xchk_iscan_advance_ag);
+DEFINE_ISCAN_EVENT(xchk_iscan_start);
+
+DECLARE_EVENT_CLASS(xchk_iscan_ino_class,
+	TP_PROTO(struct xchk_iscan *iscan, xfs_ino_t ino),
+	TP_ARGS(iscan, ino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, cursor)
+		__field(xfs_ino_t, visited)
+		__field(xfs_ino_t, ino)
+	),
+	TP_fast_assign(
+		__entry->dev = iscan->sc->mp->m_super->s_dev;
+		__entry->cursor = iscan->cursor_ino;
+		__entry->visited = iscan->__visited_ino;
+		__entry->ino = ino;
+	),
+	TP_printk("dev %d:%d iscan cursor 0x%llx visited 0x%llx ino 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->cursor,
+		  __entry->visited,
+		  __entry->ino)
+)
+#define DEFINE_ISCAN_INO_EVENT(name) \
+DEFINE_EVENT(xchk_iscan_ino_class, name, \
+	TP_PROTO(struct xchk_iscan *iscan, xfs_ino_t ino), \
+	TP_ARGS(iscan, ino))
+DEFINE_ISCAN_INO_EVENT(xchk_iscan_want_live_update);
+
+TRACE_EVENT(xchk_iscan_iget,
+	TP_PROTO(struct xchk_iscan *iscan, int error),
+	TP_ARGS(iscan, error),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, cursor)
+		__field(xfs_ino_t, visited)
+		__field(int, error)
+	),
+	TP_fast_assign(
+		__entry->dev = iscan->sc->mp->m_super->s_dev;
+		__entry->cursor = iscan->cursor_ino;
+		__entry->visited = iscan->__visited_ino;
+		__entry->error = error;
+	),
+	TP_printk("dev %d:%d iscan cursor 0x%llx visited 0x%llx error %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->cursor,
+		  __entry->visited,
+		  __entry->error)
+);
+
+TRACE_EVENT(xchk_iscan_iget_retry_wait,
+	TP_PROTO(struct xchk_iscan *iscan),
+	TP_ARGS(iscan),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, cursor)
+		__field(xfs_ino_t, visited)
+		__field(unsigned int, retry_delay)
+		__field(unsigned long, remaining)
+		__field(unsigned int, iget_timeout)
+	),
+	TP_fast_assign(
+		__entry->dev = iscan->sc->mp->m_super->s_dev;
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
 

