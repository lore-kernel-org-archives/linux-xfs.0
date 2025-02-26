Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF427238D2D
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596252; cv=none; b=WXvjY0Gnm2mR3XA4tpxwu6CbeCwXi0FqAFN57ZM19NNsNHMoFRU+Q/0zAtyhmYeG7o3n06dFBgJZW4S16HsJKhdai3lCSNuVdZZf73gSNj22e+WcR9v9wLyxKGWkLJsXKZxiLcGeyZTw2aGX0Qljw3ALu5GFMNKq6as+nqwLjMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596252; c=relaxed/simple;
	bh=4k58kD67nZvC2dmdEKeXXx4m6ifY2FvzapN63EAU80U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSAHMPlMCk87aJDSYnkmA/slyoopUkRnoh1sZisO0gkPmn677HW/la00BcKijqQPhY6kIVGgDQ/U/YVY6p2co4hd5E9GD31IXgwBK+umQbTjFK978xLg1tQ5oAwPRFy7+Z6FiVV1D8EkerxqhjWvN6A1j2cP4g/q8bAFnC7e4/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K+TkCyLe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K+TkCyLe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nDMKuLKHDFqGDB4I12oNhDo6qyA124YPibheK11TMGw=; b=K+TkCyLefdWsTZipbOFQ8wP3gS
	FE5R7Zdi1VMk2xokfazp1+5Js2yOGRIJH3L+UsCVDTpHAK+Qy7O1lmgIy/RCluahaFO5KzC8EOChN
	vpKUSSTL8xxMuOOwqzIkPRCrd2JNclP4qnv2WhbTppewip8tepZG4zVzh7eyGLV8Qc95I/Uuz57Nt
	LI3spYdoAKZ4vbBI/wet1xihiLMDxCJ1X9+Wf2JUe4qEWlAMsMI+O6IYjnflcCVwvuxzNe1ShPOq2
	S70BQsE6UdqRnZdtQbGRrMTL9G5s8VJWZ+dsVtbp9MjCXFGxlPgM5Jg1BdfmhDL3P8EQ9qO6NGXHZ
	Y0xd5LoQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMb4-000000053uZ-2VKf;
	Wed, 26 Feb 2025 18:57:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 21/44] xfs: skip zoned RT inodes in xfs_inodegc_want_queue_rt_file
Date: Wed, 26 Feb 2025 10:56:53 -0800
Message-ID: <20250226185723.518867-22-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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

