Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155FE41DE08
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244349; cv=none; b=JB/4WW14AlF7JHg4HFKtHPusfU+/y8CM/CJiq2dSC4zLkrGE9E5q1nFk6Fx/T901tnsidOmLlqc1nHbfQYP7GFpwj6ivlu9OxtLfa3LTBecq4CTWpdRJaUGE8Nn497+NDKCOa9UiJEAG00N8pIwgsSkdqeDTxKOpVNsWT710BL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244349; c=relaxed/simple;
	bh=rKJeJ0VS0A64fZf8w2QyJZZfwmjoO9T0toni1OvfOf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAQs+m1YI5axrvBlvyOzCLLqf4iF+m2qgVpwKD9BvahMk/0lFK5McITxUjNNKtLaHyuXedW1DRv/fM3FU0UQYzvwORHRqeZmbPV1pQ4rRSlsb5r+eKVr4dpT0LVI4PYXS6v5g2oRcgCX0nZROktdGpSU4udTNp+qZ6F7ZPY1p5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uV1GjX9q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uV1GjX9q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rDax92Hbkv2pggd+5zIiIVUdGBpnjPktvXccpyj1AJI=; b=uV1GjX9qawcHsb0LMhhXc32TOa
	JCRoXbs7h0HQNtH/uh/Qd1WUhOQZnp/SgXxSFDVABiEIo0De7y+OBoLfHMFfg7qA1Xk4gqWJmjrmt
	bWwivpE6id3nirCsBNH2rA9CCk8UXL8Jtx4FuiWnobbs27Lr3FaAd1C6irUDPZuG+zxcijppWqwSS
	4gK1m4mHXL+M6vAJngpP7QsmfllsF8aR6+cJERPGta2q2+HARVJFjsUGKSJIY1xoY4s3fGNEGrQ2N
	uTYWUfFxPtPX9rSyEZoC09yE6J+TeA6yi86pk4F5J/Z6IGwG58bvacO5yLQ03PetW1W3w0ZqWxOOT
	vtu0GqpA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gKi-0000000AfE7-3FZX;
	Thu, 24 Sep 2026 10:05:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 08/32] xfs: hide b_flags manipulation from code outside of xfs_buf.c
Date: Thu, 24 Sep 2026 12:03:58 +0200
Message-ID: <20260924100512.2733748-9-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 9f224de410d7efafc44ce1880aabd0101aa8688f

Add helpers for the remaining buffer flags manipulation not done in the
core buffer cache code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_btree_staging.c | 7 +++----
 libxfs/xfs_ialloc.c        | 2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index c3c7ea54895a..7314dab4bcfb 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -248,11 +248,10 @@ xfs_btree_bload_drop_buf(
 		return 0;
 
 	/*
-	 * Mark this buffer XBF_DONE (i.e. uptodate) so that a subsequent
-	 * xfs_buf_read will not pointlessly reread the contents from the disk.
+	 * Mark this buffer uptodate so that a subsequent xfs_buf_read will
+	 * not pointlessly reread the contents from the disk.
 	 */
-	bp->b_flags |= XBF_DONE;
-
+	xfs_buf_set_uptodate(bp);
 	xfs_buf_delwri_queue_here(bp, buffers_list);
 	xfs_buf_relse(bp);
 	*bpp = NULL;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index aa895c0decbc..c60e2a5ed56b 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -409,7 +409,7 @@ xfs_ialloc_inode_init(
 				xfs_trans_ordered_buf(tp, fbuf);
 			}
 		} else {
-			fbuf->b_flags |= XBF_DONE;
+			xfs_buf_set_uptodate(fbuf);
 			xfs_buf_delwri_queue(fbuf, buffer_list);
 			xfs_buf_relse(fbuf);
 		}
-- 
2.53.0

