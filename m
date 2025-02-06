Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE952253F2
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824373; cv=none; b=FrOzmgkIM4y9cwZzAhAV18M8L0ep/Nvfunx8nicK83B7+LrTG6iPn3X07syFGxNH1AqLEst/eBQaFIO/pRSo/pjiasBgIWZfs98pwpCsWV6WRG2BRrzseNLCtUYZVh2L3OvHUjQSOoCkZ6tNkNyxtteV/ishZQxq9fXfKeQHSbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824373; c=relaxed/simple;
	bh=xdIxbwKuMnlvbGn0Wo89d+1Xa3asE1hn3MsuPCO9cak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEQVaZ40KyPaKZGCxLkfDPUzUOqtnuux090LQ9GVO39qBCEa8V8WZsIa1ivopIsZ7VbMoyJwN3CaznTWZmAoS3KSjD7mRiet6XM3xrqyhBbsJb9oLn/MLDDzcJxRA68Lnb7TC4H8Mq8CH/ot1L2wifZ7KGsguTH1BEKNf49Ljh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aplsSo1k; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aplsSo1k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=m2IXdFM6BrXWDuw6B+2yW7DUOGq/LH9DICmroScX4pI=; b=aplsSo1kh+VDY2nhH3k43OzZYd
	w3+sWok90c4lZBOLcCm6skc33RDygaYiIzL66M+gQmqbwjd7rTXy0m6L1vCcl1VIt8Wf7dv2L0Pnd
	3hXmr+975Yn6E2AgOTfLUwyOFOJctYj65Zhg0vdyL8JeebNR3fL6J7AQV/uYzab3poZnb8V0awRw+
	zkpesCJPgS9iwz5xMoqsOchHxkr9vkdeiw9deDb9jejGAJAc0M0makvn8cbfhDVqicO4e79wp6w6Q
	zLR4zL02Yiy0nsvnoN9jxnrWzyUy0q9JPAg/tozw4XUnVeEZCopN6QyIeyrZn8Q+f7oyhvxBYEBzA
	tsmB3Dzw==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfveN-00000005QNF-1IUA;
	Thu, 06 Feb 2025 06:46:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 20/43] xfs: skip zoned RT inodes in xfs_inodegc_want_queue_rt_file
Date: Thu,  6 Feb 2025 07:44:36 +0100
Message-ID: <20250206064511.2323878-21-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The zoned allocator never performs speculative preallocations, so don't
bother queueing up zoned inodes here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index c9ded501e89b..2f53ca7e12d4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -2073,7 +2073,7 @@ xfs_inodegc_want_queue_rt_file(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
-	if (!XFS_IS_REALTIME_INODE(ip))
+	if (!XFS_IS_REALTIME_INODE(ip) || xfs_has_zoned(mp))
 		return false;
 
 	if (xfs_compare_freecounter(mp, XC_FREE_RTEXTENTS,
-- 
2.45.2

