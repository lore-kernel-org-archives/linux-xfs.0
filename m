Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB15A3BFE52
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 08:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785226335; cv=none; b=M7/APahL3rejYDattL7jk1vhHZcWFEChbOgSiTQmSSLJo4L7sdYyn89NoMtr3cftW9LvNRYoYZWWy1Z0yQem76yRv38MZ/AYn14+bTJ8iL9EeLv9MjDk1NV38BODrn2F8y9x1AiBSfCNXNHLy3eaYiK2nL1/TEB4ZHy6JqFsZbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785226335; c=relaxed/simple;
	bh=0vFAyfsdRTnkhFWZZZMrXnnSKKUrv6h/+G8EsYP/QQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3DCPJvyl2Dua8fYU/TEr/X9yBqvMKhF5KlGOp6sDvNVlbLxyLHkn7G5YYunyi2gUbXVYinM4QHiwoDmuDSt2yNUYVI4yuZWAMZ1YysNZQgzDXDmfA07J1xKmxFdOvpU4ksCctsJwoDEjWLMl43pggzyFmFaSGLVwpz0rhxuTqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IHatjDPf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IHatjDPf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MMOq2LHMtuaQiYxbKue0HaHdY/y6lcSENsIvI9V6Jc4=; b=IHatjDPfKwb4IK2jK9Fdrq/FUA
	ZEY6GNtMewnMBdN6pFrsoyJRb8cJ+BWQ8ninuLPGn0gJfzD8nz8/8uxt6d2vSW1JgCBu4P9aGqPMa
	sxohJMPJeIjEWD8cA1V5XWMmVBzGeOS+4xlTu//D+uVLfGfFyRd1w4ls27s6S8tBlqs3t7bM2ZOKX
	9Kujq0rCXlXcebtBSv+zGcIRhfsHsPBeX0u+Qiyh43ITSjPOdz4l3ASXWfnWT025HZyvBHE2amHWG
	6rxHJE14e5yJA6c8YXpmR1RAlm9MSRk0091WZZcHPE5sAPGqmqCdd3rPDOy5+dFxNWTsNEZDYVlYu
	fEorWKgA==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wocv7-00000004h3c-0ld0;
	Tue, 28 Jul 2026 08:12:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/12] xfs: remove _XBF_LOGRECOVERY
Date: Tue, 28 Jul 2026 10:11:13 +0200
Message-ID: <20260728081152.1778841-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260728081152.1778841-1-hch@lst.de>
References: <20260728081152.1778841-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Adding _XBF_LOGRECOVERY to every buffer write from log recovery is error
prone.  Instead key off the behavior on log recovery being active with
indirecting that through a flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c                |  5 ++---
 fs/xfs/xfs_buf.h                |  4 ----
 fs/xfs/xfs_buf_item.c           | 10 ++++++----
 fs/xfs/xfs_buf_item_recover.c   |  3 ---
 fs/xfs/xfs_dquot_item_recover.c |  1 -
 fs/xfs/xfs_inode_item_recover.c |  1 -
 fs/xfs/xfs_log_recover.c        |  5 ++---
 7 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 14ef9ebcce1d..95ead3aa296a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1034,7 +1034,7 @@ xfs_buf_ioend_handle_error(
 	 * We're not going to bother about retrying this during recovery.
 	 * One strike!
 	 */
-	if (bp->b_flags & _XBF_LOGRECOVERY) {
+	if (mp->m_log && xlog_in_recovery(mp->m_log)) {
 		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
 		return false;
 	}
@@ -1141,8 +1141,7 @@ xfs_buf_ioend(
 			bp->b_iodone(bp);
 	}
 
-	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD |
-			 _XBF_LOGRECOVERY);
+	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
 	if (async)
 		xfs_buf_relse(bp);
 }
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 79cc9c3f0254..e440f97cf3e1 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -34,9 +34,6 @@ struct xfs_buf;
 #define XBF_STALE	 (1u << 6) /* buffer has been staled, do not find it */
 #define XBF_WRITE_FAIL	 (1u << 7) /* async writes have failed on this buffer */
 
-/* buffer type flags for write callbacks */
-#define _XBF_LOGRECOVERY (1u << 18)/* log recovery buffer */
-
 /* flags used only internally */
 #define _XBF_KMEM	 (1u << 21)/* backed by heap memory */
 #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
@@ -61,7 +58,6 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_DONE,		"DONE" }, \
 	{ XBF_STALE,		"STALE" }, \
 	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
-	{ _XBF_LOGRECOVERY,	"LOG_RECOVERY" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
 	/* The following interface flags should never be set */ \
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1f055cd6732e..1a4ef34af8d5 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1066,6 +1066,8 @@ void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
 {
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+
 	/*
 	 * If we are forcibly shutting down, this may well be off the AIL
 	 * already. That's because we simulate the log-committed callbacks to
@@ -1078,8 +1080,8 @@ xfs_buf_item_done(
 	 * Note that log recovery writes might have buffer items that are not on
 	 * the AIL even when the file system is not shut down.
 	 */
-	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
-			     (bp->b_flags & _XBF_LOGRECOVERY) ? 0 :
-			     SHUTDOWN_CORRUPT_INCORE);
-	xfs_buf_item_relse(bp->b_log_item);
+	xfs_trans_ail_delete(&bip->bli_item,
+			     xlog_in_recovery(bip->bli_item.li_log) ?
+			     0 : SHUTDOWN_CORRUPT_INCORE);
+	xfs_buf_item_relse(bip);
 }
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 240deb3f7827..57929f115055 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -448,7 +448,6 @@ xlog_recover_validate_buf_type(
 	if (bp->b_ops) {
 		struct xfs_buf_log_item	*bip;
 
-		bp->b_flags |= _XBF_LOGRECOVERY;
 		xfs_buf_item_init(bp, mp);
 		bip = bp->b_log_item;
 		bip->bli_item.li_lsn = current_lsn;
@@ -1122,7 +1121,6 @@ xlog_recover_buf_commit_pass2(
 			xfs_buf_lock(rtsb_bp);
 			xfs_buf_hold(rtsb_bp);
 			xfs_update_rtsb(rtsb_bp, bp);
-			rtsb_bp->b_flags |= _XBF_LOGRECOVERY;
 			xfs_buf_delwri_queue(rtsb_bp, buffer_list);
 			xfs_buf_relse(rtsb_bp);
 		}
@@ -1164,7 +1162,6 @@ xlog_recover_buf_commit_pass2(
 		error = xfs_bwrite(bp);
 	} else {
 		ASSERT(bp->b_mount == mp);
-		bp->b_flags |= _XBF_LOGRECOVERY;
 		xfs_buf_delwri_queue(bp, buffer_list);
 	}
 
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index fe419b28de22..d4dfe1885666 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -168,7 +168,6 @@ xlog_recover_dquot_commit_pass2(
 
 	ASSERT(dq_f->qlf_size == 2);
 	ASSERT(bp->b_mount == mp);
-	bp->b_flags |= _XBF_LOGRECOVERY;
 	xfs_buf_delwri_queue(bp, buffer_list);
 
 out_release:
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 169a8fe3bf0a..1d2319ad15c5 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -586,7 +586,6 @@ xlog_recover_inode_commit_pass2(
 	}
 
 	ASSERT(bp->b_mount == mp);
-	bp->b_flags |= _XBF_LOGRECOVERY;
 	xfs_buf_delwri_queue(bp, buffer_list);
 
 out_release:
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index fdb011e6ef60..e7e49529658b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3279,9 +3279,8 @@ xlog_do_recovery_pass(
 			 * checkpoints at this start LSN.
 			 *
 			 * Note: Shutting down the filesystem will result in the
-			 * delwri submission marking all the buffers stale,
-			 * completing them and cleaning up _XBF_LOGRECOVERY
-			 * state without doing any IO.
+			 * delwri submission marking all the buffers stale and
+			 * completing them without doing any IO.
 			 */
 			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
 		}
-- 
2.53.0

