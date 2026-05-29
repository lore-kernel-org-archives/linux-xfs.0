Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D253E37E301
	for <linux-xfs@vger.kernel.org>; Fri, 29 May 2026 05:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780033448; cv=none; b=kkfQNSxjj3hMQ0ZiK2SpcCWu3oIkaNt+UEAQf0m9CWjNUaKC9yAbRRvRNn/HnLK+DNfSPgegxzO8X2T+0sfujBhWayWcRWfbvI6D1Oh5eNFcWQg8JIWZ0qtlGLu7uddFecANMsttd8Wgqw8kNu91yyKESb0PQKS/4xYcDUtlLU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780033448; c=relaxed/simple;
	bh=PwXi65n1O0YrKTNjqVqiuC+wPrfeuPopte/I7DJNV1A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=njvjqNbQfZWSbRouEOm4bIfUY72Qpj5VAQUNjY/gXRjZFD/744iiTlvRIc5DF+0WCTywtUzndg0QlDf9UCCZTS/0KP71Y7lcX7miiBB4+Hc3RE2zZUFp6NPwYgRoB2BwmrOLIv90wgtDZEokyPEApqEPK3JOfEVTGNqZBeRrOXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0H+LxkGK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0H+LxkGK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=bdzS+hT4nJT+GwQ0tamyy2X3ri9mQ4x79n91vJH1YPE=; b=0H+LxkGKjxAOeKfRQ+A8xIgDl/
	mJcP2r95556RQg/mc9NCQFfONWoGMcn9XGonjfp78poFx3LIFJJWO9NI1ZXSBiJcJDKjvwZ8lzdlo
	BBXY2+EjAFTulSBE1QI+nCZOx778mKT0sStJOX56tF7yiI8IZ54hPlE+Q3Po4uKdMt5dAR0IUzn/n
	P8R6Vrnq1xc+LpjwqPvtfrovvn1atopxfkZsmtHjNlbgE67c2znCtfMBW+Bx6TVtzkrTfpdi7E+tp
	9aAGv1bAvATuMT1bTM+G7lzpBZvHA8Osz2JH6aTA7WtzYkExoHnxe//LQJL0LfBNunYX1BsjTJkip
	rcbvBJTQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSq0t-00000006lyN-0eGx;
	Fri, 29 May 2026 05:44:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: remove the call to xfs_buf_reverify in xfs_trans_read_buf_map
Date: Fri, 29 May 2026 07:43:58 +0200
Message-ID: <20260529054404.2720366-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_trans_read_buf_map asserts bp->b_ops is non-NULL just before
calling xfs_buf_reverify which is a no-op if bp->b_ops is set, making the
call dead code ever since it as added in commit 1aff5696f3e0 ("xfs: always
assign buffer verifiers when one is provided").

Remove the useless call, mark xfs_buf_reverify static and clean up the
branch dealing with a buffer attached to the transaction in a bit by
deduplicating and keeping together the asserts and removing the bip
variable only used once outside of asserts and tracing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c       |  2 +-
 fs/xfs/xfs_buf.h       |  1 -
 fs/xfs/xfs_trans_buf.c | 39 ++++-----------------------------------
 3 files changed, 5 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 0cea458f1353..3ce12fe1c307 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -623,7 +623,7 @@ _xfs_buf_read(
  * type.  If repair can't establish that, the buffer will be left in memory
  * with NULL buffer ops.
  */
-int
+static int
 xfs_buf_reverify(
 	struct xfs_buf		*bp,
 	const struct xfs_buf_ops *ops)
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index bf39d89f0f6d..b3cd1c7029f1 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -365,7 +365,6 @@ int xfs_configure_buftarg(struct xfs_buftarg *btp, unsigned int sectorsize,
 
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
 
-int xfs_buf_reverify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
 bool xfs_verify_magic16(struct xfs_buf *bp, __be16 dmagic);
 
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 95db73a37e57..7e17b93fe9ad 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -234,7 +234,6 @@ xfs_trans_read_buf_map(
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp = NULL;
-	struct xfs_buf_log_item	*bip;
 	int			error;
 
 	*bpp = NULL;
@@ -251,9 +250,10 @@ xfs_trans_read_buf_map(
 	if (bp) {
 		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(bp->b_transp == tp);
-		ASSERT(bp->b_log_item != NULL);
 		ASSERT(!bp->b_error);
 		ASSERT(bp->b_flags & XBF_DONE);
+		ASSERT(atomic_read(&bp->b_log_item->bli_refcount) > 0);
+		ASSERT(bp->b_ops);
 
 		/*
 		 * We never locked this buf ourselves, so we shouldn't
@@ -264,39 +264,8 @@ xfs_trans_read_buf_map(
 			return -EIO;
 		}
 
-		/*
-		 * Check if the caller is trying to read a buffer that is
-		 * already attached to the transaction yet has no buffer ops
-		 * assigned.  Ops are usually attached when the buffer is
-		 * attached to the transaction, or by the read caller if
-		 * special circumstances.  That didn't happen, which is not
-		 * how this is supposed to go.
-		 *
-		 * If the buffer passes verification we'll let this go, but if
-		 * not we have to shut down.  Let the transaction cleanup code
-		 * release this buffer when it kills the tranaction.
-		 */
-		ASSERT(bp->b_ops != NULL);
-		error = xfs_buf_reverify(bp, ops);
-		if (error) {
-			xfs_buf_ioerror_alert(bp, __return_address);
-
-			if (tp->t_flags & XFS_TRANS_DIRTY)
-				xfs_force_shutdown(tp->t_mountp,
-						SHUTDOWN_META_IO_ERROR);
-
-			/* bad CRC means corrupted metadata */
-			if (error == -EFSBADCRC)
-				error = -EFSCORRUPTED;
-			return error;
-		}
-
-		bip = bp->b_log_item;
-		bip->bli_recur++;
-
-		ASSERT(atomic_read(&bip->bli_refcount) > 0);
-		trace_xfs_trans_read_buf_recur(bip);
-		ASSERT(bp->b_ops != NULL || ops == NULL);
+		bp->b_log_item->bli_recur++;
+		trace_xfs_trans_read_buf_recur(bp->b_log_item);
 		*bpp = bp;
 		return 0;
 	}
-- 
2.53.0

