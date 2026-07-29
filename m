Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FEE44C50F
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319617; cv=none; b=KL8l6QvoDrmobe1BBjAJnZfjwX/aV4GG3KHml9B+JKgYl0OVwyK8zA6BxiG9MQbMtWxP3gXQ+lqyQO4a8ufyyA1O2JhtqZZGaxoTJh27rshLOiU/AmN9J+ZfKkZBXQFjye6MJVCa82kZjYfvfr2NXvk7CuHxfpgLBQXgRi9FWJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319617; c=relaxed/simple;
	bh=tCnNCVZWGQwLwCTx9Ptm+dZxfL3PihRSZSwv7SzUBDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M04mSAVul4cIqQOjsasiCnQYTz9lWhoHw4gbVk7YzK6XqzD4/jzOXfFbanfO3sf9ggR8u8V7v+KodnY+qp/zzIL3DM5QQ7zjDNIoHb1qsxiTMi94qhV2tZ06FzqzLUKZOR0CqeVKSzK8YLU58JRyb4E2nVwufVJREuSBI0byCms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YYdd5B8z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YYdd5B8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772351F00A3A;
	Wed, 29 Jul 2026 10:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319616;
	bh=862j62bsYRbr54WkzS/mrr1kWdYxTz0WN2hEgoUkb5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYdd5B8zdYQV2fV3UV/Yi9HRm43mWeZU4TwI8sAxUPE4doQytFVk3GFpU9uqB+TvE
	 L12cMIw8tKJegHYYJhi54wlZ0p359bCaKMdnqTZKVTxI4e6NAjGtg/oVmFPB0pmefc
	 9WlJaRoaM711iukN3tBN4dB8OP5XgXqu27qzZ0sCGogK4TQtoghkynAkwA7g8+hh5P
	 zE2DgavLbQwhTeZSS31NPw1esWkYkjhcC39ebOMqQQJsf1WrmhCVCUeGSIgFU4gPqM
	 EsVEq/t6UsN/fnuG4cIQ55TmuwtRY77oZ2XkpMb9xdp3d8LH1X//OP4ECsCuPUcTdI
	 S7LL1O2hEIqqw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 18/33] xfs: add block reservation renewal to xfs_defer_finish
Date: Wed, 29 Jul 2026 20:02:02 +1000
Message-ID: <20260729100629.1943710-19-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729100629.1943710-1-dgc@kernel.org>
References: <20260729100629.1943710-1-dgc@kernel.org>
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
for RT extents) at transaction allocation time and propagated
through xfs_trans_dup(). After xfs_defer_finish() completes all
deferred operations and performs the final roll,
xfs_trans_regrant_blkres() reserves the deficit between
t_blk_res and t_blk_res_orig from the free space pool, restoring
the original reservation for the next iteration.

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
 fs/xfs/xfs_trans.c         | 40 +++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans.h         |  3 +++
 4 files changed, 72 insertions(+), 12 deletions(-)

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
index 7bfbd9f6f0df..c267a174cbe1 100644
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
@@ -164,6 +167,7 @@ xfs_trans_reserve(
 		if (error != 0)
 			return -ENOSPC;
 		tp->t_blk_res += blocks;
+		tp->t_blk_res_orig = tp->t_blk_res;
 	}
 
 	/*
@@ -191,6 +195,7 @@ xfs_trans_reserve(
 			goto undo_log;
 		}
 		tp->t_rtx_res += rtextents;
+		tp->t_rtx_res_orig = tp->t_rtx_res;
 	}
 
 	return 0;
@@ -995,6 +1000,39 @@ xfs_trans_cancel(
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
+	int			error;
+
+	if (!(tp->t_flags & XFS_TRANS_RENEW_BLKRES))
+		return 0;
+
+	if (tp->t_blk_res != tp->t_blk_res_orig) {
+		error = xfs_dec_fdblocks(tp->t_mountp,
+				tp->t_blk_res_orig - tp->t_blk_res,
+				tp->t_flags & XFS_TRANS_RESERVE);
+		if (error)
+			return error;
+		tp->t_blk_res = tp->t_blk_res_orig;
+	}
+	if (tp->t_rtx_res != tp->t_rtx_res_orig) {
+		error = xfs_dec_frextents(tp->t_mountp,
+				tp->t_rtx_res_orig - tp->t_rtx_res);
+		if (error)
+			return error;
+		tp->t_rtx_res = tp->t_rtx_res_orig;
+	}
+	return 0;
+}
+
 /*
  * Roll from one trans in the sequence of PERMANENT transactions to the next:
  * permanent transactions are only flushed out when committed with
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index eb83c5dac032..3d1ddc2a90f7 100644
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
@@ -237,6 +239,7 @@ void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 int		xfs_trans_commit(struct xfs_trans *);
 int		xfs_trans_roll(struct xfs_trans **);
 int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
+int		xfs_trans_regrant_blkres(struct xfs_trans *);
 void		xfs_trans_cancel(xfs_trans_t *);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
-- 
2.55.0

