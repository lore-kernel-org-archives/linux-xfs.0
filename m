Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE747443C32;
	Thu, 24 Sep 2026 10:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244078; cv=none; b=h6jAVkKiOXHEiSzZUILtZdCM04RxYS5J/+UPq5LMOo0FFrfvLVYuy1EiMGr8OOWJa1tnqK7Yo5eGNI0tF/ojI2aPO/o/ST1K+XsCphNSn/fF/zKDEtPNn6YmK7KQ0VGFoOrfWWxugmEy5VuZWyvNi8Q4AJu8beBMYhHHxZXSATo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244078; c=relaxed/simple;
	bh=RE5McOAGEL1xui4prdXmdDCFOKsd+6/RETQglT87ZTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAfzI9oiqH46yqOU+miG8OP687un9BK5xE6a0SPPQeeqMQypswsvqnWIITj21JfWZy7Lg2mjPB1D/SrtMSpvdt3jQFIjuriUZKcSnMr+1YRKJrmRGQ0/aVTXWLCP6rS5OsqXXTjheSEQiIRU4exkHst9t/XfHn0l/IBOWSeu+xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Qic7Cto7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qic7Cto7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=narawQpSzqiQn0M9l1Lo9lHTbEA6pxTUQDMKpj3wJow=; b=Qic7Cto76S9jv+40b2ADkPFedE
	axZeKQmGI1XIhHCu961MpVfOQQolySbNUNAGd/YiPIHpZIqZNu+Wo7QkHI0RJJiULIjddi9d040rH
	7XOfLNIEL/AHX8DQsyZ4BrTGUcEm6zye67qejOevcuhnMdz+tW7MXpnGWBp939xn5FNfNwnX1aOyd
	UoLtOTjL7Xp+qMzZB3g2IiBrbIAZAcUtCfBMzr8ZPheusEHKqgs+4cnFJAew+M9uAyHQd6X3GRIFs
	rynrQCZ+vBjuhm8p4/QLHIbJkqF+p2J/BfUCCSu5wkkUfdK85+6RlBArQo37cihKfmHVqEJL4Cxh7
	d62lHytw==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gGK-0000000AeUM-4AIa;
	Thu, 24 Sep 2026 10:01:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 05/21] xfs: introduce XFS_BLI_PREALLOC
Date: Thu, 24 Sep 2026 11:59:37 +0200
Message-ID: <20260924100032.2733101-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100032.2733101-1-hch@lst.de>
References: <20260924100032.2733101-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a flag so that the shadow CIL buffer for a buffer log item is always
sizes to the maximum to prevent reallocations.  This will be used for the
RT checksum item, where we know that we are going to fill it up very soon,
and (almost) sequentially, so there is no point in doing a constant
realloc cycle when more data is added to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_trans_resv.c |  2 +-
 fs/xfs/libxfs/xfs_trans_resv.h |  1 +
 fs/xfs/xfs_buf_item.c          | 10 ++++++++++
 fs/xfs/xfs_buf_item.h          |  4 +++-
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 3151e97ca8ff..5382ece51812 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -53,7 +53,7 @@ xfs_buf_log_overhead(void)
  * will be changed in a transaction.  size is used to tell how many
  * bytes should be reserved per item.
  */
-STATIC uint
+uint
 xfs_calc_buf_res(
 	uint		nbufs,
 	uint		size)
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 336279e0fc61..1804e821f382 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -96,6 +96,7 @@ struct xfs_trans_resv {
 #define	XFS_ITRUNCATE_LOG_COUNT_REFLINK	8
 #define	XFS_WRITE_LOG_COUNT_REFLINK	8
 
+uint xfs_calc_buf_res(uint nbufs, uint size);
 void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
 uint xfs_allocfree_block_count(struct xfs_mount *mp, uint num_ops);
 
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1a4ef34af8d5..644c3fb18310 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -252,6 +252,16 @@ xfs_buf_item_size(
 		offset += BBTOB(bp->b_maps[i].bm_len);
 	}
 
+	/*
+	 * For buffers with the prealloc flag, always size the allocation size
+	 * to the maximum as per the log reservation.  This avoids constant
+	 * realloc cycles for buffers that are filled sequentially in rapid
+	 * pace.  Note that the nvecs calaculation is kept from the regular
+	 * look as the buffer item formatting expects it.
+	 */
+	if (bip->bli_flags & XFS_BLI_PREALLOC)
+		*nbytes = xfs_calc_buf_res(bip->bli_format_count, bp->b_length);
+
 	/*
 	 * Round up the buffer size required to minimise the number of memory
 	 * allocations that need to be done as this item grows when relogged by
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 3159325dd17b..ddc8ecc4683e 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -20,6 +20,7 @@ struct xfs_mount;
 #define XFS_BLI_STALE_INODE	(1u << 5)
 #define	XFS_BLI_INODE_BUF	(1u << 6)
 #define	XFS_BLI_ORDERED		(1u << 7)
+#define	XFS_BLI_PREALLOC	(1u << 8)
 
 #define XFS_BLI_FLAGS \
 	{ XFS_BLI_HOLD,		"HOLD" }, \
@@ -29,7 +30,8 @@ struct xfs_mount;
 	{ XFS_BLI_INODE_ALLOC_BUF, "INODE_ALLOC" }, \
 	{ XFS_BLI_STALE_INODE,	"STALE_INODE" }, \
 	{ XFS_BLI_INODE_BUF,	"INODE_BUF" }, \
-	{ XFS_BLI_ORDERED,	"ORDERED" }
+	{ XFS_BLI_ORDERED,	"ORDERED" }, \
+	{ XFS_BLI_PREALLOC,	"PREALLOC" }
 
 /*
  * This is the in core log item structure used to track information
-- 
2.53.0

