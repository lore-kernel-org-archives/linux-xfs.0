Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC1C39935E
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 14:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127121; cv=none; b=ScqEdNaGkj7fI95uNjT7g11h5I11c9be5x7Hx5oqkCR+PsDrZS3pJwK7PhjZhWAnCk9DlnWK+U2qtX+YjFBwvi9D+pVcAyBbXsKPfpf52+QFEQesy2Ssqlmw+8r1EFrt4lOsmbKlxNYMBb9HSX21lxm8YgBHNPArQ1JpEJXGloc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127121; c=relaxed/simple;
	bh=mKNsfbiwJOKJk72ZjWbxAz+6XvP6C3xa/b63n4flc7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfrxCAyn/jGZuvggv0x1f6lIpbixhBoBedigz34KctIUDpxAd3Z6Czinb/1FMsX4uW6vRebfptC+ZZO+CTM6gwl8A7NmKaE2yiwKaD6kf0r91Fo1i5UoLxXPMcwVjUg92n9ikIgEiQ3cEtJAX9PcDQfO/i4RzIJerqXHtDaopDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Q6ZR2Iys; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q6ZR2Iys"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qjuKLO7BFdbgxR/ImTTnlJqgKZNy01X8o1aP4DEjA84=; b=Q6ZR2IyseZsPoueL55cOsNwFjo
	lv9d8ve17do0uvTWZl7m97t5NdRnp67C/R6B88LBM8DQ+wkhlQV2kSxYKeL0uJOJ04vDryxNS94Ww
	+F+7wuDjLVyi+0kFORa6e6thvLSDmlOsJx9yoyRGDbKYJ5nzazhObn/6RLxUSOkF5lSg2KntHvums
	ZNGBTKtRJ0CHnhvfnzK6oDA0lTXgx3jp6IFs89YgibgOrinv3mhNMpXhFxgilCcMPwgxmw+K+ePLd
	P8N/JAumH6rLd0ldoY5JsZ5Hgdfi8Mn1P5k+oV6kDo4qvTUkToeGVlTeEg5EQt9kxA61/2cqq2U5C
	dhSP0yfQ==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk0xr-0000000FDVK-2mTL;
	Wed, 15 Jul 2026 14:52:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/12] xfs: split out a lower-level xfs_buf_get_map helper from xfs_find_get_buf
Date: Wed, 15 Jul 2026 16:50:56 +0200
Message-ID: <20260715145147.95654-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715145147.95654-1-hch@lst.de>
References: <20260715145147.95654-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_buf_get_map is currently reused to implement xfs_buf_read_map and
xfs_buf_readahead_map.  This causes double accounting of buf_get stat
and leads to some ugly overload of the flags.

Split out a slightly lower-level xfs_find_get_buf helper and use that to
implement xfs_buf_get_map, xfs_buf_read_map and xfs_buf_readahead_map.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e56d4b8b0771..2cf359b4c446 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -514,8 +514,8 @@ xfs_buf_find_insert(
  * cache hits, as metadata intensive workloads will see 3 orders of magnitude
  * more hits than misses.
  */
-int
-xfs_buf_get_map(
+static int
+xfs_find_get_buf(
 	struct xfs_buftarg	*btp,
 	struct xfs_buf_map	*map,
 	int			nmaps,
@@ -552,16 +552,33 @@ xfs_buf_get_map(
 		return error;
 	}
 
+	*bpp = bp;
+	return 0;
+}
+
+int
+xfs_buf_get_map(
+	struct xfs_buftarg	*btp,
+	struct xfs_buf_map	*map,
+	int			nmaps,
+	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp)
+{
+	int			error;
+
+	ASSERT(!(flags & ~(XBF_TRYLOCK | XBF_INCORE | XBF_LIVESCAN)));
+	ASSERT(!(flags & XBF_LIVESCAN) || (flags & XBF_INCORE));
+
 	/*
-	 * Clear b_error if this is a lookup from a caller that doesn't expect
-	 * valid data to be found in the buffer.
+	 * Zero the buffer and clear b_error as xfs_buf_get_map callers don't
+	 * expect valid data to be found in the buffer.
 	 */
-	if (!(flags & XBF_READ))
-		xfs_buf_ioerror(bp, 0);
-
+	error = xfs_find_get_buf(btp, map, nmaps, flags, bpp);
+	if (error)
+		return error;
 	XFS_STATS_INC(btp->bt_mount, xb_get);
-	trace_xfs_buf_get(bp, flags, _RET_IP_);
-	*bpp = bp;
+	trace_xfs_buf_get(*bpp, flags, _RET_IP_);
+	xfs_buf_ioerror(*bpp, 0);
 	return 0;
 }
 
@@ -625,12 +642,12 @@ xfs_buf_read_map(
 	struct xfs_buf		*bp;
 	int			error;
 
-	ASSERT(!(flags & (XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD)));
+	ASSERT(!(flags & ~XBF_TRYLOCK));
 
 	flags |= XBF_READ;
 	*bpp = NULL;
 
-	error = xfs_buf_get_map(target, map, nmaps, flags, &bp);
+	error = xfs_find_get_buf(target, map, nmaps, flags, &bp);
 	if (error)
 		return error;
 
@@ -706,7 +723,7 @@ xfs_buf_readahead_map(
 	if (xfs_buftarg_is_mem(target))
 		return;
 
-	if (xfs_buf_get_map(target, map, nmaps, flags | XBF_TRYLOCK, &bp))
+	if (xfs_find_get_buf(target, map, nmaps, flags | XBF_TRYLOCK, &bp))
 		return;
 	trace_xfs_buf_readahead(bp, 0, _RET_IP_);
 
-- 
2.53.0

