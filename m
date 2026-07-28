Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644123DA7D0
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 08:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785226327; cv=none; b=CRSufPhnxVMj+4ZHJjwcfDLt480kbcnfAifnREWHLDZQvdWM0iQnHNtO10lM16vUnysLQDndkLXquS+KAePhXzdrzU1A3aUxbw1Cz44HEP9sLm57XSi5+O2CVAOtM5xuLqTCTKr2iV4ZDwO4SEfktnBPJCNf+IgHHDZjtGvyfMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785226327; c=relaxed/simple;
	bh=nvupfXlHERh/H0L5TzNn5jdQBaDMffhzu5v/uePmG6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PE+4hxFwxzfbMoRYUYa3Uk4EIoAxSI4J8DpCUdWzzs+3EKJt8XaG1uUiR1LeuWJMYY6jQw2E/tCBvaUbPsaezmTDJNBD66JoE3aSUp8gBp+pFBgQrQav8mklhDER7vU28JBa1oMbaUeQkcca+JioO0amzV+to5Mh9oNRxODpDdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z62+wdQM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z62+wdQM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=L2gK269n4YcrF9vPv462Q6QKZHcIh2bcO5EcGmdrC2U=; b=Z62+wdQMFBfVHVSFbef78f5JNk
	G+uhT3zRG8FMfj1tR8IoXKTTMHannya/7N6ga+NBhdQ0Vpveuw1gOrLXJplf5CPY9gUgrIeNmJu+a
	tEFWybcndBF1ClTCqakKCkGojI0/SYIvH7WJV8mQW0oYNrk8esEw6hEJAlckuaX7ZQqDXahrL7YdI
	Q593Sn51QWUm6xvpmvhFFuVl1BJQMx91r1gzx5xLb2+3qnZa7j+ArsN5iZi2MoZEnR9QgMm1/o8FN
	uEdtPm7Ah4Ey4OOyv0uDBevpX4IwGnQEeQ8hL+eXfpycum+y/P3E8vftWAOMGs/6nKYNFfgaOPJIK
	4RBJ7wGw==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wocuz-00000004gzK-31Br;
	Tue, 28 Jul 2026 08:12:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/12] xfs: split out a lower-level xfs_buf_get_map helper from xfs_find_get_buf
Date: Tue, 28 Jul 2026 10:11:11 +0200
Message-ID: <20260728081152.1778841-4-hch@lst.de>
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

xfs_buf_get_map is currently reused to implement xfs_buf_read_map and
xfs_buf_readahead_map.  This causes double accounting of buf_get stat
and leads to some ugly overload of the flags.

Split out a slightly lower-level xfs_find_get_buf helper and use that to
implement xfs_buf_get_map, xfs_buf_read_map and xfs_buf_readahead_map.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d4ab69112d11..14ef9ebcce1d 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -530,8 +530,8 @@ xfs_buf_find_insert(
  * cache hits, as metadata intensive workloads will see 3 orders of magnitude
  * more hits than misses.
  */
-int
-xfs_buf_get_map(
+static int
+__xfs_find_get_buf(
 	struct xfs_buftarg	*btp,
 	struct xfs_buf_map	*map,
 	int			nmaps,
@@ -568,16 +568,34 @@ xfs_buf_get_map(
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
+	error = __xfs_find_get_buf(btp, map, nmaps, flags, bpp);
+	if (error)
+		return error;
+
 	/*
-	 * Clear b_error if this is a lookup from a caller that doesn't expect
-	 * valid data to be found in the buffer.
+	 * Clear b_error as the callers don't expect to find valid data in the
+	 * buffer.
 	 */
-	if (!(flags & XBF_READ))
-		xfs_buf_ioerror(bp, 0);
-
+	xfs_buf_ioerror(*bpp, 0);
 	XFS_STATS_INC(btp->bt_mount, xb_get);
-	trace_xfs_buf_get(bp, flags, _RET_IP_);
-	*bpp = bp;
+	trace_xfs_buf_get(*bpp, flags, _RET_IP_);
 	return 0;
 }
 
@@ -641,12 +659,12 @@ xfs_buf_read_map(
 	struct xfs_buf		*bp;
 	int			error;
 
-	ASSERT(!(flags & (XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD)));
+	ASSERT(!(flags & ~XBF_TRYLOCK));
 
 	flags |= XBF_READ;
 	*bpp = NULL;
 
-	error = xfs_buf_get_map(target, map, nmaps, flags, &bp);
+	error = __xfs_find_get_buf(target, map, nmaps, flags, &bp);
 	if (error)
 		return error;
 
@@ -722,7 +740,7 @@ xfs_buf_readahead_map(
 	if (xfs_buftarg_is_mem(target))
 		return;
 
-	if (xfs_buf_get_map(target, map, nmaps, flags | XBF_TRYLOCK, &bp))
+	if (__xfs_find_get_buf(target, map, nmaps, flags | XBF_TRYLOCK, &bp))
 		return;
 	trace_xfs_buf_readahead(bp, 0, _RET_IP_);
 
-- 
2.53.0

