Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27074594D
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157422; cv=none; b=pMt4F0y3DuR6NA1KKTDM7nC+YU53qCVhErW+NIFJnLO3U1HU1yyNxTu3YIxkuDWECZY4Qzvj/As295b0TJ9sOo4W2oauJFQpLw36X/wHe6fezUs/KKHEp3R7sgjAYcrioFBisCJqxx/5y54VSSJxZiIjqo0EsRFC1qdaVEFg1vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157422; c=relaxed/simple;
	bh=IIex3JbEb/hG0sBYBp7IHV2S/bQ52lGsx3i0Lm4ytvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPZwAMsqTBHdo/csQKGKWV7R7ovbjGxewghlYkzxo3Qz7e8aXxM07FP/mukbPqoSAIxCFBG3yUXgCVcBbF9Nx+B7uH4Jbw/KwnlrGmDTUpi2xKj9RhaOy4BJ/nllGbB6rsgw3Pi1jvDJ9Wv51ARC2mWEP/wJX15ipqav9o1rUb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qhVX2aD2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qhVX2aD2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=p5DVMtgGiz7fQGLbiuNJiorpzRogjT8m6kM57gq7ueU=; b=qhVX2aD2dmg0Pam2dHEgnUQhuz
	81jav5KKV9YTZesqP4ag6tMIwN/vN7BzgP9a62zkBpMbo+hvdI8LUaWoCFPS6k/8rfwCAThgyGpSe
	oGaJhwj/7n9K2rl8NB58yWTuPQ9Mj2rkk99TwpFrwcAuMroVhVQZBg3G1C9dxabv2d+EgkHIoVhbv
	WHa/d0+K8AbrxIBq3bwinIeh8SV7a1gezSZlrx0+qxcwh3mVKcO81hfIfAenMm/V52Fxg0l99Izpz
	Q1Zif3Jtr552or/hEUu8nuGFnPGbg6hCBcZEOgae9U/bQ2knuffL8rRtuiqo9wRUaTK87+PP9e9TE
	SBNPxImQ==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjr2-00000000lQ4-14xP;
	Mon, 06 Jan 2025 09:57:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 15/15] xfs: add a b_iodone callback to struct xfs_buf
Date: Mon,  6 Jan 2025 10:54:52 +0100
Message-ID: <20250106095613.847700-16-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250106095613.847700-1-hch@lst.de>
References: <20250106095613.847700-1-hch@lst.de>
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
---
 fs/xfs/xfs_buf.c        | 7 ++-----
 fs/xfs/xfs_buf.h        | 5 +----
 fs/xfs/xfs_dquot.c      | 2 +-
 fs/xfs/xfs_inode_item.c | 2 +-
 fs/xfs/xfs_trans_buf.c  | 8 ++++----
 5 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1cf5d14d0d06..68a5148115e5 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1394,11 +1394,8 @@ xfs_buf_ioend(
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
index 78dde811ab16..e0a379729674 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1446,7 +1446,7 @@ xfs_qm_dqflush(
 	 * Attach the dquot to the buffer so that we can remove this dquot from
 	 * the AIL and release the flush lock once the dquot is synced to disk.
 	 */
-	bp->b_flags |= _XBF_DQUOTS;
+	bp->b_iodone = xfs_buf_dquot_iodone;
 	list_add_tail(&lip->li_bio_list, &bp->b_li_list);
 
 	/*
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 4fb2e1a6ad26..e0990a8c4007 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -185,7 +185,7 @@ xfs_inode_item_precommit(
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

