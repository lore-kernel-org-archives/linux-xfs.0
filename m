Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C2123ED45
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 14:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736777600; cv=none; b=bmAT7a9nqKNZyFEqKBse6+PPKTGN3GjMxcm6mXwpC/eOplkzZ6uzp02bLwgh96jcLrPojJbe9KSQ+JRCKe2VlZpBNzfnqiA/H0pJ7U1ZQqIDroX5BiTMTZKtRUUAZKwIizUsF6oSEQoL3841kz3ukm5tLrEnmPYLbdDmBAej1fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736777600; c=relaxed/simple;
	bh=wLFSec7X50dGlp05uCZKv9NRWK7+i0SrkPN7H8sTEhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbOQvGem2bkT7/3btLnlj070eOYTCn7nXi2Sjz5JOgbCBpQZ8BOAXDxFeRsohaCJvuYrI0bqsTkOBQDEdh68zamMZducEVRiZKWwObOcj5uu3uCzgXoaPpMLrRtNEhbsFEWUJXEdyZIxPJPkvRR21IfN0GYxZYQVfSpwtkNC+Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=viYl1rrY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="viYl1rrY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZpJGjCMlaEG/6vS9jVEqeXDeWLzXqeptEVw8m62Aac8=; b=viYl1rrYeLtw6g37m2vouq3yYA
	Iztwim7aPdmyyHo22X9zrnoqplJovNLs2oHov+kjOp9UV1znKasPvX+g4zjy83hgZt91Kwm1B2kzO
	zlm1j4I5a2zAZ+Z93lIWoouaqk2i9g/qGiaGL1Wt+Mfw3JYo1y+pZFZGuA28pw6LZWrLr41mTBX3B
	CgkLmr+vT4Z6rNu5T3Kz1CjEKuBjQY35/4UPn1skAEzzv+7OxzNQXKD2Y4Ir3HJDChdNmioMKoVKo
	hLHY3HkvYPFEsYD7XujR+Fd87bpqij3bzQM2QJv2u0AyY/h9qAGtBuAYyDe5VGUuuwZeMTjRfV9E0
	J+WbpMcw==;
Received: from 2a02-8389-2341-5b80-b273-11c2-5421-183d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b273:11c2:5421:183d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXLBu-00000005Mve-2UaD;
	Mon, 13 Jan 2025 14:13:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 15/15] xfs: add a b_iodone callback to struct xfs_buf
Date: Mon, 13 Jan 2025 15:12:19 +0100
Message-ID: <20250113141228.113714-16-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250113141228.113714-1-hch@lst.de>
References: <20250113141228.113714-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Stop open coding the log item completions and instead add a callback
into back into the submitter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c        | 7 ++-----
 fs/xfs/xfs_buf.h        | 5 +----
 fs/xfs/xfs_dquot.c      | 2 +-
 fs/xfs/xfs_inode_item.c | 2 +-
 fs/xfs/xfs_trans_buf.c  | 8 ++++----
 5 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d5e23c4c7674..d9636bff16ce 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1392,11 +1392,8 @@ xfs_buf_ioend(
 		if (bp->b_log_item)
 			xfs_buf_item_done(bp);
 
-		if (bp->b_flags & _XBF_INODES)
-			xfs_buf_inode_iodone(bp);
-		else if (bp->b_flags & _XBF_DQUOTS)
-			xfs_buf_dquot_iodone(bp);
-
+		if (bp->b_iodone)
+			bp->b_iodone(bp);
 	}
 
 	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD |
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index c53d27439ff2..10bf66e074a0 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -34,8 +34,6 @@ struct xfs_buf;
 #define XBF_WRITE_FAIL	 (1u << 7) /* async writes have failed on this buffer */
 
 /* buffer type flags for write callbacks */
-#define _XBF_INODES	 (1u << 16)/* inode buffer */
-#define _XBF_DQUOTS	 (1u << 17)/* dquot buffer */
 #define _XBF_LOGRECOVERY (1u << 18)/* log recovery buffer */
 
 /* flags used only internally */
@@ -65,8 +63,6 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_DONE,		"DONE" }, \
 	{ XBF_STALE,		"STALE" }, \
 	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
-	{ _XBF_INODES,		"INODES" }, \
-	{ _XBF_DQUOTS,		"DQUOTS" }, \
 	{ _XBF_LOGRECOVERY,	"LOG_RECOVERY" }, \
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
@@ -205,6 +201,7 @@ struct xfs_buf {
 	unsigned int		b_offset;	/* page offset of b_addr,
 						   only for _XBF_KMEM buffers */
 	int			b_error;	/* error code on I/O */
+	void			(*b_iodone)(struct xfs_buf *bp);
 
 	/*
 	 * async write failure retry count. Initialised to zero on the first
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 1082c5d980c8..edbc521870a1 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1451,7 +1451,7 @@ xfs_qm_dqflush(
 	 * Attach the dquot to the buffer so that we can remove this dquot from
 	 * the AIL and release the flush lock once the dquot is synced to disk.
 	 */
-	bp->b_flags |= _XBF_DQUOTS;
+	bp->b_iodone = xfs_buf_dquot_iodone;
 	list_add_tail(&lip->li_bio_list, &bp->b_li_list);
 
 	/*
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 9b3dac5b2a33..35803fcf0beb 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -199,7 +199,7 @@ xfs_inode_item_precommit(
 		xfs_buf_hold(bp);
 		spin_lock(&iip->ili_lock);
 		iip->ili_item.li_buf = bp;
-		bp->b_flags |= _XBF_INODES;
+		bp->b_iodone = xfs_buf_inode_iodone;
 		list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
 		xfs_trans_brelse(tp, bp);
 	}
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 8e886ecfd69a..53af546c0b23 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -659,7 +659,7 @@ xfs_trans_inode_buf(
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_INODE_BUF;
-	bp->b_flags |= _XBF_INODES;
+	bp->b_iodone = xfs_buf_inode_iodone;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
 }
 
@@ -684,7 +684,7 @@ xfs_trans_stale_inode_buf(
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_STALE_INODE;
-	bp->b_flags |= _XBF_INODES;
+	bp->b_iodone = xfs_buf_inode_iodone;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
 }
 
@@ -709,7 +709,7 @@ xfs_trans_inode_alloc_buf(
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
-	bp->b_flags |= _XBF_INODES;
+	bp->b_iodone = xfs_buf_inode_iodone;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
 }
 
@@ -820,6 +820,6 @@ xfs_trans_dquot_buf(
 		break;
 	}
 
-	bp->b_flags |= _XBF_DQUOTS;
+	bp->b_iodone = xfs_buf_dquot_iodone;
 	xfs_trans_buf_set_type(tp, bp, type);
 }
-- 
2.45.2

