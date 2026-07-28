Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5106A224AF9
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 08:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785226352; cv=none; b=FEjfK15dtzgc44Xu9tiwTTXz+s3eAJyvNNBchM6lDXsvfP3SP8bK6bEwS+vuTlMeNuzGWmWrlSnngpvR9PTnQC6LjlZFOaOT9hlBOjb1JD6ZSRKLGKUj5L3w/1GzRT74RZfGvEKqTz8WLK77NX/m+RREkVH3C78iB3B92mJh+XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785226352; c=relaxed/simple;
	bh=OwZDn2KRILmIEilUhqi+QjmZ4y9jR7pQ2x5eMEfpg1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jN5G3l6NcY/4XubKFcw17LM+B2JvlaxJ/xGz5bL9ZSpfa8+KS7PcPFXg/xsvy+mCxyYlC0um96IwUe++XCBYAgPZOTZyn6Yp8Amhl3VigWV939qGdcJVwsZ1tV3iqzOPEfX2XjPJ1HoFFkY/E3TrfPGTaqpQp9WSY2djoxToyh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3OCDCNWd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3OCDCNWd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kPx2mRefwGX+mRoYWRk60MKEykS14d71Gh787ugG9NA=; b=3OCDCNWdlbx9OhX+DszMcdKxLA
	C9AXFxNOnj33aDph9ZF64kbmrQHBmJl0Cd6yuOSQhpdWYzQP6V2xRQ4qbTHmumoRJFSu4eRbtHEEo
	fIXVqw5CmKizQWvDomackLcth8gWLbGmJ7wm2AGmskpfZwi4YjBo2JI/+tve6JbdWJvlHbo/zr7jc
	DCIjuzc5PSY9YyzUa5SKF/sXwP3uItecDIKnekXK2X2FOhRZCXQrJWiJkS+dTfWAFSC8u7sl/CB2P
	0TpVK61xRGmFOOzPNog+v8dF1Uy0Q95FJwNwc912GeDSkp/nJTSh0gJbyJt9plFGqo5ZnUimdea4E
	R2e4hJUA==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wocvO-00000004hAf-2Fnd;
	Tue, 28 Jul 2026 08:12:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/12] xfs: merge xfs_buf_reverify into xfs_buf_read_map
Date: Tue, 28 Jul 2026 10:11:18 +0200
Message-ID: <20260728081152.1778841-11-hch@lst.de>
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

xfs_buf_read_map is the only caller of xfs_buf_reverify that is left.
Merge it into that so that the comments can be moved closer to the
logic, and redundant asserts can be removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 79 ++++++++++++++++++++++--------------------------
 1 file changed, 36 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 3d5e764e3613..aee58aca8c7c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -643,41 +643,6 @@ _xfs_buf_read(
 	return xfs_buf_iowait(bp);
 }
 
-/*
- * Reverify a buffer found in cache without an attached ->b_ops.
- *
- * If the caller passed an ops structure and the buffer doesn't have ops
- * assigned, set the ops and use it to verify the contents. If verification
- * fails, clear XBF_DONE. We assume the buffer has no recorded errors and is
- * already in XBF_DONE state on entry.
- *
- * Under normal operations, every in-core buffer is verified on read I/O
- * completion. There are two scenarios that can lead to in-core buffers without
- * an assigned ->b_ops. The first is during log recovery of buffers on a V4
- * filesystem, though these buffers are purged at the end of recovery. The
- * other is online repair, which intentionally reads with a NULL buffer ops to
- * run several verifiers across an in-core buffer in order to establish buffer
- * type.  If repair can't establish that, the buffer will be left in memory
- * with NULL buffer ops.
- */
-static int
-xfs_buf_reverify(
-	struct xfs_buf		*bp,
-	const struct xfs_buf_ops *ops)
-{
-	ASSERT(bp->b_flags & XBF_DONE);
-	ASSERT(bp->b_error == 0);
-
-	if (!ops || bp->b_ops)
-		return 0;
-
-	bp->b_ops = ops;
-	bp->b_ops->verify_read(bp);
-	if (bp->b_error)
-		xfs_buf_clear_flags(bp, XBF_DONE);
-	return bp->b_error;
-}
-
 int
 xfs_buf_read_map(
 	struct xfs_buftarg	*target,
@@ -702,18 +667,46 @@ xfs_buf_read_map(
 
 	trace_xfs_buf_read(bp, flags, _RET_IP_);
 
-	if (!(bp->b_flags & XBF_DONE)) {
+	if (bp->b_flags & XBF_DONE) {
+		ASSERT(bp->b_error == 0);
+
+		/*
+		 * If the caller passed an ops structure and the buffer doesn't
+		 * have ops assigned yet, set the ops and use them to verify the
+		 * buffer contents.
+		 *
+		 * Under normal operations, every in-core buffer is verified on
+		 * read I/O completion, but there are two scenarios that can
+		 * lead to in-core buffers without an assigned ->b_ops:
+		 *
+		 *   1) During log recovery of buffers on a V4 filesystem.
+		 *	These buffers are purged at the end of recovery, though.
+		 *   2) Online repair intentionally reads with a NULL buffer ops
+		 *	to run several verifiers across an in-core buffer in
+		 *	order to establish buffer type.  If repair can't
+		 *	establish that, the buffer will be left in memory with
+		 *	NULL buffer ops.
+		 */
+		if (ops && !bp->b_ops) {
+			bp->b_ops = ops;
+			bp->b_ops->verify_read(bp);
+			/*
+			 * If verification failed, clear XBF_DONE as we assume
+			 * that buffers have no recorded errors when in XBF_DONE
+			 * state.
+			 */
+			error = bp->b_error;
+			if (error)
+				xfs_buf_clear_flags(bp, XBF_DONE);
+		}
+
+		/* We do not want read in the flags */
+		xfs_buf_clear_flags(bp, XBF_READ);
+	} else {
 		/* Initiate the buffer read and wait. */
 		XFS_STATS_INC(target->bt_mount, xb_get_read);
 		bp->b_ops = ops;
 		error = _xfs_buf_read(bp);
-	} else {
-		/* Buffer already read; all we need to do is check it. */
-		error = xfs_buf_reverify(bp, ops);
-
-		/* We do not want read in the flags */
-		xfs_buf_clear_flags(bp, XBF_READ);
-		ASSERT(bp->b_ops != NULL || ops == NULL);
 	}
 
 	if (error)
-- 
2.53.0

