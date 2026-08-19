Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BB32C08D0
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098519; cv=none; b=Yryxl/zrzsT23Jn83s3uDgig27jeByDtZJ/rkfAaOEEZ4sSPLm71DmxfRMddElva8OZiSWFOInXcbxH9XICtEvUKweW4AU7kY6arduYJr2Bpp9TSqQTNtm//9w3dLI+hfpCOn8hSi0qgPRIE/BSpxuPqMqGEsNBpgx2Y+mD8o/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098519; c=relaxed/simple;
	bh=vkPapmO99TYxej2MLCimbJdtG3vucJAtld86UWrIsd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRtwJXxYH38I1TvE8HrjIkFvCA/0dAcfk+mLdNr/tr+JVukm6E6BEOHx7PCC7lNDqr24mNOkFFmXbiKASupO/T+nK9hL7cVV3Hw2kgoAghwTVkX9O4ZiWx08ur80nJYOAbN9sajAKr+63RExyson60T6zVja23reetUnqnWMTrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QfVmnta4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QfVmnta4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D901F00A3A;
	Wed, 19 Aug 2026 00:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098517;
	bh=YMuHPM6ijz6EKzeDKoUI7z9K57VYZux4UJW0yGvTWYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QfVmnta4GtzkUBYvgHEFzwbN6EehiOZEy86peb+sIoWogc/gpf48W/F+8VoZGDUR+
	 FD9h0PR/wA4AAGOzsoQFfGuqsxWO8DYAblBLNIy951/1BlhEHDnaReUQwIC74xYrcK
	 DgYHwQMjcauuNHuKKFMBg5wnxwC+kcZd7nFLEJxRTcI2ev4ZI6s6VIpcAe8Tk8FZIm
	 6cAQawc0B/DYvAgGNHTqG0r0plI88k1cwTmMRHZ/PP6MfFmSHfooF9tOlItU4XxrTr
	 Mb6Ta1vZ3FR+CbvoM9A972lccx35+gPAomWLMFv7dbMYhm7jowvxL3tjz6NLbuo8TN
	 8QaT8Ncnq3HuA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 23/38] xfs: add block reservation renewal to xfs_defer_finish
Date: Wed, 19 Aug 2026 10:12:26 +1000
Message-ID: <20260819001442.1451892-24-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819001442.1451892-1-dgc@kernel.org>
References: <20260819001442.1451892-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add infrastructure to automatically renew block and RT extent
reservations after deferred operations have been processed by
xfs_defer_finish().

Unlike log reservations which are renewed by xfs_log_regrant() on
every roll, block reservations are carried forward by
xfs_trans_dup() with consumed blocks subtracted. Over multiple
rolls, the reservation can be depleted even though each iteration
of the caller needs the same reservation.

Add a new XFS_TRANS_RENEW_BLKRES flag. When set, the original
block reservation is recorded in t_blk_res_orig (and t_rtx_res_orig
for RT extents) at reservation time and propagated through
xfs_trans_dup(). After xfs_defer_finish() completes all deferred
operations and performs the final roll, xfs_trans_regrant_blkres()
reserves the deficit between t_blk_res and t_blk_res_orig from the
free space pool, restoring the original reservation for the next
iteration.

The _orig values are set in xfs_trans_reserve() and
xfs_trans_reserve_more_inode() so that they are correctly captured
regardless of how the block reservation was established.

The regrant is not performed during the internal rolls in
xfs_defer_finish_noroll() because the original reservation already
contains all the space needed for the deferred op chain. The regrant
after the final roll operates on a clean transaction, so the caller
can safely cancel on ENOSPC without causing a filesystem shutdown.

xfs_defer_finish() is changed to unconditionally roll the transaction
after deferred op processing so that the regrant always occurs.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c  | 38 +++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_shared.h |  3 +++
 fs/xfs/xfs_trans.c         | 40 +++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_trans.h         |  3 +++
 4 files changed, 70 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 89501e8bd2f8..f1807dadafb2 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -725,6 +725,24 @@ xfs_defer_finish_noroll(
 	return error;
 }
 
+/*
+ * Finish all deferred ops and roll the transaction. The transaction is
+ * always rolled unconditionally so that the block reservation can be
+ * regranted after all deferred ops have completed.
+ *
+ * The block reservation regrant is not performed during the internal
+ * transaction rolls in xfs_defer_finish_noroll() because the original
+ * reservation already contains all the space needed for the deferred op
+ * chain. Regranting during internal rolls would risk unnecessary ENOSPC
+ * errors in the middle of a deferred op chain that cannot be safely
+ * aborted.
+ *
+ * The regrant is done after the final roll when the transaction is clean,
+ * replenishing whatever blocks were consumed by both the caller's
+ * modifications and the deferred operations. If the regrant fails with
+ * ENOSPC, the caller can safely cancel the clean transaction without
+ * causing a filesystem shutdown.
+ */
 int
 xfs_defer_finish(
 	struct xfs_trans	**tp)
@@ -734,22 +752,20 @@ xfs_defer_finish(
 #endif
 	int			error;
 
-	/*
-	 * Finish and roll the transaction once more to avoid returning to the
-	 * caller with a dirty transaction.
-	 */
 	error = xfs_defer_finish_noroll(tp);
 	if (error)
 		return error;
-	if ((*tp)->t_flags & XFS_TRANS_DIRTY) {
-		error = xfs_defer_trans_roll(tp);
-		if (error) {
-			xfs_force_shutdown((*tp)->t_mountp,
-					   SHUTDOWN_CORRUPT_INCORE);
-			return error;
-		}
+
+	error = xfs_defer_trans_roll(tp);
+	if (error) {
+		xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
+		return error;
 	}
 
+	error = xfs_trans_regrant_blkres(*tp);
+	if (error)
+		return error;
+
 	/* Reset LOWMODE now that we've finished all the dfops. */
 #ifdef DEBUG
 	list_for_each_entry(dfp, &(*tp)->t_dfops, dfp_list)
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index b1e0d9bc1f7d..e3909d46f3cd 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -164,6 +164,9 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 /* Transaction has locked the rtbitmap and rtsum inodes */
 #define XFS_TRANS_RTBITMAP_LOCKED	(1u << 9)
 
+/* Renew block reservation on transaction roll */
+#define XFS_TRANS_RENEW_BLKRES		(1u << 10)
+
 /*
  * Field values for xfs_trans_mod_sb.
  */
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 8e32da47501e..6a274e3aed36 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -112,16 +112,19 @@ xfs_trans_dup(
 	ntp->t_flags = XFS_TRANS_PERM_LOG_RES |
 		       (tp->t_flags & XFS_TRANS_RESERVE) |
 		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT) |
-		       (tp->t_flags & XFS_TRANS_RES_FDBLKS);
+		       (tp->t_flags & XFS_TRANS_RES_FDBLKS) |
+		       (tp->t_flags & XFS_TRANS_RENEW_BLKRES);
 	/* We gave our writer reference to the new transaction */
 	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
 	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
 
 	ASSERT(tp->t_blk_res >= tp->t_blk_res_used);
 	ntp->t_blk_res = tp->t_blk_res - tp->t_blk_res_used;
+	ntp->t_blk_res_orig = tp->t_blk_res_orig;
 	tp->t_blk_res = tp->t_blk_res_used;
 
 	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
+	ntp->t_rtx_res_orig = tp->t_rtx_res_orig;
 	tp->t_rtx_res = tp->t_rtx_res_used;
 
 	/* move deferred ops over to the new tp */
@@ -203,6 +206,8 @@ xfs_trans_reserve(
 	error = xfs_trans_reserve_blocks(tp, blocks, rtextents);
 	if (error)
 		return error;
+	tp->t_blk_res_orig = tp->t_blk_res;
+	tp->t_rtx_res_orig = tp->t_rtx_res;
 
 	/*
 	 * Reserve the log space needed for this transaction.
@@ -1009,6 +1014,31 @@ xfs_trans_cancel(
 	xfs_trans_free(tp);
 }
 
+/*
+ * Renew the block and RT extent reservations from the free space pool.
+ * The consumed counts were carried forward by xfs_trans_dup() so we know
+ * exactly how many blocks need to be reserved to restore the original
+ * reservation.
+ */
+int
+xfs_trans_regrant_blkres(
+	struct xfs_trans	*tp)
+{
+	unsigned int		blk_deficit;
+	unsigned int		rtx_deficit;
+
+	if (!(tp->t_flags & XFS_TRANS_RENEW_BLKRES))
+		return 0;
+
+	blk_deficit = tp->t_blk_res_orig - tp->t_blk_res;
+	rtx_deficit = tp->t_rtx_res_orig - tp->t_rtx_res;
+
+	if (!blk_deficit && !rtx_deficit)
+		return 0;
+
+	return xfs_trans_reserve_blocks(tp, blk_deficit, rtx_deficit);
+}
+
 /*
  * Roll from one trans in the sequence of PERMANENT transactions to the next:
  * permanent transactions are only flushed out when committed with
@@ -1181,12 +1211,12 @@ xfs_trans_reserve_more_inode(
 
 		if (!XFS_IS_QUOTA_ON(mp) ||
 		    xfs_is_quota_inode(&mp->m_sb, I_INO(ip)))
-			return 0;
+			break;
 
 		error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks,
 				rblocks, force_quota);
 		if (!error)
-			return 0;
+			break;
 
 		xfs_trans_unreserve_blocks(tp, dblocks, rtx);
 
@@ -1197,6 +1227,10 @@ xfs_trans_reserve_more_inode(
 		return error;
 	} while (retry++ == 0);
 
+	if (!error) {
+		tp->t_blk_res_orig = tp->t_blk_res;
+		tp->t_rtx_res_orig = tp->t_rtx_res;
+	}
 	return error;
 }
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index de77b617bccf..cf527d57d40b 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -127,8 +127,10 @@ typedef struct xfs_trans {
 	unsigned int		t_log_count;	/* count for perm log res */
 	unsigned int		t_blk_res;	/* # of blocks resvd */
 	unsigned int		t_blk_res_used;	/* # of resvd blocks used */
+	unsigned int		t_blk_res_orig;	/* used with XFS_TRANS_RENEW_BLKRES */
 	unsigned int		t_rtx_res;	/* # of rt extents resvd */
 	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
+	unsigned int		t_rtx_res_orig;	/* used with XFS_TRANS_RENEW_BLKRES */
 	unsigned int		t_flags;	/* misc flags */
 	xfs_agnumber_t		t_highest_agno;	/* highest AGF locked */
 	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
@@ -239,6 +241,7 @@ void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 int		xfs_trans_commit(struct xfs_trans *);
 int		xfs_trans_roll(struct xfs_trans **);
 int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
+int		xfs_trans_regrant_blkres(struct xfs_trans *);
 void		xfs_trans_cancel(xfs_trans_t *);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
-- 
2.55.0

