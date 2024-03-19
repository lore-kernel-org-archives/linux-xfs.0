Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AE565197
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 02:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710814556; cv=none; b=Prt6h/mbGjS85FPkJMe/Sd7lRRf78E1GxpmZDzTjp7tz58aGi2QFIxlFKjZMdl1qgxsJiN2ABWTuFiCd6PpyeWMrfSUhQuBcdEOa6eklcaAGt9M1xXLqa1vq1IKfuQPrmFetfAy3dS/vXXgMVY1YRr1Dq4ofj1sXJ5nrZxSDZ/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710814556; c=relaxed/simple;
	bh=nQLBaarSRJFvBUEubxM7xhMwp0+AqzbgsVkJ8MFpntw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwEpclydMLnEyB7z6fFDCShHHdlERjD7eSUzkO4RrQNNxvV1nPIpdCDtyZS1DLUfECfPBiUP9+/b5qXePWOZ6SitRXULRtgTERlyhw2hKx8/Lzjk37SF0ugOF2Wcwh6ZQGfid4n5SXLQ6Z5zx/lMj1rc5bknwz7//K1ksoZuPkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=JC+MbMp0; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="JC+MbMp0"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e6b5432439so4856416b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 19:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710814554; x=1711419354; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VVhiFEWWawY+pfKjAMMd/EV/29oKOuM8OrVr5fN+bWo=;
        b=JC+MbMp0qYSABtkTA/9ty1pDdmEUnBMqKrjqCKZQMFjcrX+EtiUCI0gn1i/FpPrYmY
         zuj5LLPq+5LOfaxsRqEIOc+R5nXE1d3kVo4g3GKMAIdTMAb9NaWAYUtaQV58T/JhfAOx
         6qkZ5VueKKa+nnvOGmQW12f872BD1y+dx7+zdNwTrh0O7WHqzuI2sT8+OQ5Lj19n1nTp
         fRPxhx0DyRQ2tKtDRIDtWFJHMrExavjAhN/fh6iRGGVJntjGOoKG6Vzn3JoEdHvuM/iA
         jJTwIwZkQJShTrpPaEitPbWvcyZ5zaAn4bdZjsTdsrcucIxB1kxzWE19EK/KzHZeuvGy
         SS2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710814554; x=1711419354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VVhiFEWWawY+pfKjAMMd/EV/29oKOuM8OrVr5fN+bWo=;
        b=nLrLLax47SbNexfwLTIeIclfjgCGaheSHbI4d3the6TiFg8UkuGco2pKl27Wuh+d4L
         /MPlNjpuKCK0U4iTwYgovl6A5hMmD+oslBhnblceHL9RuvEtW2hSpSqCcJQ5M2yea+Zq
         xMF237TNUy5KYeoZolBjDHhp5bFscOiaSuxG01ngtyoiPIoPQ3pv7Qp1RhzGXKELB1a5
         13jaYxeb72VLS2HWkJ0j6OkIUifEqPdGJCS92uQtzOzy6/IiC9aQriJWX3sMuNIHZCl+
         1YhWiHkYAFfAC4HZ9OsUOBF2VoXfC+1WMfxcK/EkCK6q8DfwktgZmlzq6UM9/jbj84nW
         9mRQ==
X-Gm-Message-State: AOJu0Yw3Teu8zpSMgvyb0NcHGNH3tnZKfESIgBN8TZIO1tf/t8BORgtd
	fnyQaNq8eM3pBxnuaNEIXTlK+ahY/K3UfjeHOQsKgsyQnTV7rpkyv35fIxEr5pfa7htBnskcDu0
	C
X-Google-Smtp-Source: AGHT+IF3Mw+mTRjXdphe8AfZzES0fI10fHq8COKzzvXHHeZUNUQVSsS8baYiXYAX4mdiyea+84FhyA==
X-Received: by 2002:a05:6a00:803:b0:6e5:cd5c:620a with SMTP id m3-20020a056a00080300b006e5cd5c620amr18684679pfk.16.1710814553602;
        Mon, 18 Mar 2024 19:15:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id i4-20020aa787c4000000b006e6ab7cb10esm8571848pfo.186.2024.03.18.19.15.51
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 19:15:52 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmP13-003s57-2K
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 13:15:49 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmP13-0000000Ec6x-0vu9
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 13:15:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] xfs: detect partial buffer recovery operations
Date: Tue, 19 Mar 2024 13:15:23 +1100
Message-ID: <20240319021547.3483050-5-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240319021547.3483050-1-david@fromorbit.com>
References: <20240319021547.3483050-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

When a compound buffer is logged (e.g. fragmented large directory
block) we record it in the log as a series of separate buffer log
format items in the journal. These get recovered individually, and
because they are for non-contiguous extent ranges, we cannot use
buffer addresses to detect that the buffer format items are from the
same directory block.

Further, we cannot use LSN checks to determine if the partial
block buffers should be recovered - apart from the first buffer we
don't have a header with an LSN in it to check.

Finally, we cannot add a verifier to a partial block buffer because,
again, it will fail the verifier checks and report corruption. We
already skip this step due to bad magic number detection, but we
should be able to do better here.

The one thing we can rely on, though, is that each buffer format
item is written consecutively in the journal. They are built at
commit time into a single log iovec and chained into the iclog write
log vector chain as an unbroken sequence. Hence all the parts of a
compound buffer should be consecutive buf log format items in the
transaction being recovered.

Unfortunately, we don't have the information available in recovery
to do a full compound buffer instantiation for recovery. We only
have the fragments that contained modifications in the journal, and
so there may be missing fragments that are still clean and hence are
not in the journal. Hence we cannot use journal state to rebuild the
compound buffer entirely and hence recover it as a complete entity
and run a verifier over it before writeback.

Hence the first thing we need to do is detect such partial buffer
recovery situations and track whether we need to skip all the
partial buffers due to the LSN check in the initial header fragment
read from disk.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item_recover.c | 178 +++++++++++++++++++++++++++-------
 1 file changed, 143 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 90740fcf2fbe..9225baa62755 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -434,18 +434,17 @@ xlog_recover_validate_buf_type(
 }
 
 /*
- * Perform a 'normal' buffer recovery.  Each logged region of the
+ * Perform recovery of the logged regions. Each logged region of the
  * buffer should be copied over the corresponding region in the
  * given buffer.  The bitmap in the buf log format structure indicates
  * where to place the logged data.
  */
-static int
-xlog_recover_do_reg_buffer(
+static void
+xlog_recover_buffer(
 	struct xfs_mount		*mp,
 	struct xlog_recover_item	*item,
 	struct xfs_buf			*bp,
-	struct xfs_buf_log_format	*buf_f,
-	xfs_lsn_t			current_lsn)
+	struct xfs_buf_log_format	*buf_f)
 {
 	int			i;
 	int			bit;
@@ -489,7 +488,17 @@ xlog_recover_do_reg_buffer(
 
 	/* Shouldn't be any more regions */
 	ASSERT(i == item->ri_total);
+}
 
+static int
+xlog_recover_do_reg_buffer(
+	struct xfs_mount		*mp,
+	struct xlog_recover_item	*item,
+	struct xfs_buf			*bp,
+	struct xfs_buf_log_format	*buf_f,
+	xfs_lsn_t			current_lsn)
+{
+	xlog_recover_buffer(mp, item, bp, buf_f);
 	return xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
 }
 
@@ -735,6 +744,67 @@ xlog_recover_do_inode_buffer(
 	return 0;
 }
 
+static bool
+xlog_recovery_is_dir_buf(
+	struct xfs_buf_log_format	*buf_f)
+{
+	switch (xfs_blft_from_flags(buf_f)) {
+	case XFS_BLFT_DIR_BLOCK_BUF:
+	case XFS_BLFT_DIR_DATA_BUF:
+	case XFS_BLFT_DIR_FREE_BUF:
+	case XFS_BLFT_DIR_LEAF1_BUF:
+	case XFS_BLFT_DIR_LEAFN_BUF:
+	case XFS_BLFT_DA_NODE_BUF:
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
+
+/*
+ * Partial dabuf recovery.
+ *
+ * There are two main cases here - a buffer that contains the dabuf header and
+ * hence can be magic number and LSN checked, and then everything else.
+ *
+ * We can determine if the former should be replayed or not via LSN checks, but
+ * we cannot do that with the latter, so the only choice we have here is to
+ * always recover the changes regardless of whether this means metadata on disk
+ * will go backwards in time. This, at least, means that the changes in each
+ * checkpoint are applied consistently to the dabuf and we don't do really
+ * stupid things like skip the header fragment replay and then replay all the
+ * other changes to the dabuf block.
+ *
+ * While this is not ideal, finishing log recovery should them replay all the
+ * remaining changes across this buffer and so bring it back to being consistent
+ * on disk at the completion of recovery. Hence this "going backwards in time"
+ * situation will only be relevant to failed journal replay situations. These
+ * are rare and will require xfs_repair to be run, anyway, so the inconsistency
+ * that results will be corrected before the filesystem goes back into service,
+ * anyway.
+ *
+ * Important: This partial fragment recovery relies on log recovery purging the
+ * buffer cache after completion of this recovery phase. These partial buffers
+ * are never used at runtime (discontiguous buffers will be used instead), so
+ * they must be removed from the buffer cache to prevent them from causing
+ * overlapping range lookup failures for the entire dabuf range.
+ */
+static void
+xlog_recover_do_partial_dabuf(
+	struct xfs_mount		*mp,
+	struct xlog_recover_item	*item,
+	struct xfs_buf			*bp,
+	struct xfs_buf_log_format	*buf_f)
+{
+	/*
+	 * Always recover without verification or write verifiers. Use delwri
+	 * and rely on post pass2 recovery cache purge to clean these out of
+	 * memory.
+	 */
+	xlog_recover_buffer(mp, item, bp, buf_f);
+}
+
 /*
  * V5 filesystems know the age of the buffer on disk being recovered. We can
  * have newer objects on disk than we are replaying, and so for these cases we
@@ -886,6 +956,54 @@ xlog_recover_get_buf_lsn(
 
 }
 
+/*
+ * Recover the buffer only if we get an LSN from it and it's less than the lsn
+ * of the transaction we are replaying.
+ *
+ * Note that we have to be extremely careful of readahead here.  Readahead does
+ * not attach verfiers to the buffers so if we don't actually do any replay
+ * after readahead because of the LSN we found in the buffer if more recent than
+ * that current transaction then we need to attach the verifier directly.
+ * Failure to do so can lead to future recovery actions (e.g. EFI and unlinked
+ * list recovery) can operate on the buffers and they won't get the verifier
+ * attached. This can lead to blocks on disk having the correct content but a
+ * stale CRC.
+ *
+ * It is safe to assume these clean buffers are currently up to date.  If the
+ * buffer is dirtied by a later transaction being replayed, then the verifier
+ * will be reset to match whatever recover turns that buffer into.
+ *
+ * Return true if the buffer needs to be recovered, false if it doesn't.
+ */
+static bool
+xlog_recover_this_buffer(
+	struct xfs_mount		*mp,
+	struct xfs_buf			*bp,
+	struct xfs_buf_log_format	*buf_f,
+	xfs_lsn_t			current_lsn)
+{
+	xfs_lsn_t			lsn;
+
+	lsn = xlog_recover_get_buf_lsn(mp, bp, buf_f);
+	if (!lsn)
+		return true;
+	if (lsn == -1)
+		return true;
+	if (XFS_LSN_CMP(lsn, current_lsn) < 0)
+		return true;
+
+	trace_xfs_log_recover_buf_skip(mp->m_log, buf_f);
+	xlog_recover_validate_buf_type(mp, bp, buf_f, NULLCOMMITLSN);
+
+	/*
+	 * We're skipping replay of this buffer log item due to the log
+	 * item LSN being behind the ondisk buffer.  Verify the buffer
+	 * contents since we aren't going to run the write verifier.
+	 */
+	if (bp->b_ops)
+		bp->b_ops->verify_read(bp);
+	return false;
+}
 /*
  * This routine replays a modification made to a buffer at runtime.
  * There are actually two types of buffer, regular and inode, which
@@ -920,7 +1038,6 @@ xlog_recover_buf_commit_pass2(
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_buf			*bp;
 	int				error;
-	xfs_lsn_t			lsn;
 
 	/*
 	 * In this pass we only want to recover all the buffers which have
@@ -962,7 +1079,8 @@ xlog_recover_buf_commit_pass2(
 		if (error)
 			goto out_release;
 
-		error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f,
+		xlog_recover_buffer(mp, item, bp, buf_f);
+		error = xlog_recover_validate_buf_type(mp, bp, buf_f,
 				NULLCOMMITLSN);
 		if (error)
 			goto out_release;
@@ -970,41 +1088,31 @@ xlog_recover_buf_commit_pass2(
 	}
 
 	/*
-	 * Recover the buffer only if we get an LSN from it and it's less than
-	 * the lsn of the transaction we are replaying.
-	 *
-	 * Note that we have to be extremely careful of readahead here.
-	 * Readahead does not attach verfiers to the buffers so if we don't
-	 * actually do any replay after readahead because of the LSN we found
-	 * in the buffer if more recent than that current transaction then we
-	 * need to attach the verifier directly. Failure to do so can lead to
-	 * future recovery actions (e.g. EFI and unlinked list recovery) can
-	 * operate on the buffers and they won't get the verifier attached. This
-	 * can lead to blocks on disk having the correct content but a stale
-	 * CRC.
-	 *
-	 * It is safe to assume these clean buffers are currently up to date.
-	 * If the buffer is dirtied by a later transaction being replayed, then
-	 * the verifier will be reset to match whatever recover turns that
-	 * buffer into.
+	 * Directory buffers can be larger than a single filesystem block and
+	 * if they are they can be fragmented. There are lots of concerns about
+	 * recovering these, so push them out of line where the concerns can be
+	 * documented clearly.
 	 */
-	lsn = xlog_recover_get_buf_lsn(mp, bp, buf_f);
-	if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
-		trace_xfs_log_recover_buf_skip(log, buf_f);
-		xlog_recover_validate_buf_type(mp, bp, buf_f, NULLCOMMITLSN);
+	if (xlog_recovery_is_dir_buf(buf_f) &&
+	    mp->m_dir_geo->blksize != BBTOB(buf_f->blf_len)) {
+		xlog_recover_do_partial_dabuf(mp, item, bp, buf_f);
+		goto out_write;
+	}
 
+	/*
+	 * Whole buffer recovery, dependent on the LSN in the on-disk structure.
+	 */
+	if (!xlog_recover_this_buffer(mp, bp, buf_f, current_lsn)) {
 		/*
-		 * We're skipping replay of this buffer log item due to the log
-		 * item LSN being behind the ondisk buffer.  Verify the buffer
-		 * contents since we aren't going to run the write verifier.
+		 * We may have verified this buffer even though we aren't
+		 * recovering it. Return the verifier error for early detection
+		 * of recovery inconsistencies.
 		 */
-		if (bp->b_ops) {
-			bp->b_ops->verify_read(bp);
-			error = bp->b_error;
-		}
+		error = bp->b_error;
 		goto out_release;
 	}
 
+
 	error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
 	if (error)
 		goto out_release;
-- 
2.43.0

