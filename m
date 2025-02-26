Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CE9236451
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596249; cv=none; b=eKnew9C3T7odIteUK4Ps6QkUCLnRT8xzZGrtV6A5fyVfEV20+3suGaDzh+tR4pVhEQOGUtbl8oEM5CJHg4O+Mt3Na3TyOJC0YmL5jStuichmzhSXdOoyRCx+3ApSFQCGYjXEDyLZOnkKGav2OZSYnaHb34TOpKitci9iMqo6z5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596249; c=relaxed/simple;
	bh=EjzkT/rKe1MgBOMl6I5oCDY8dKEAcURlBs8ncbsageE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUgSvfQKWeqdijVDW+paMnS8eavfmCGZwd+LVNeexCtv8G4SmHYo/vZUeslqV0jdU5IS1RFDwYDu/U/kprUyQAUfEzUQDq+fzyvXjevnI5fi2aco6tNYxO1go3hMX4fJdqJXLas9jmmrJmO8JeJaaD6RII/XJ4j+R3odNwtu46I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b6WzMRhn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b6WzMRhn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iPBvCRbj/X/JcOUTZEUUZxkMmZj07JMHEYJHLce6e84=; b=b6WzMRhnmd62YXpheJvaahI/Qd
	mhkjfERGoriu/4ofiqle1HDAMxWVvNyOvf/RzVavUh3kRBopQjI0HLubA4OeQTgW1gSwCJeaoFp+Q
	NSUPmlqRrSpYdplvMP+yebUbApM+hb52LG02dUKNOPUKKM4jqFOT+r7RQFwG44r5IuWSzUrBLiLHR
	iowOilzng7FI065I+kXMycTnlxixfIsc1geCD44K67qZ6sd2RyYzZaXOdQeFVNzWzn2pWvPS8plNn
	pscmNAxG451qplqFH/rqgE3NQFGURAF4Q43aZp6ZKnLGqCkGdn2Eph755yKl0lq+b1r0gGNPmh3Q1
	h/bTiqBQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMb1-000000053sh-2q95;
	Wed, 26 Feb 2025 18:57:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/44] xfs: skip always_cow inodes in xfs_reflink_trim_around_shared
Date: Wed, 26 Feb 2025 10:56:43 -0800
Message-ID: <20250226185723.518867-12-hch@lst.de>
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

xfs_reflink_trim_around_shared tries to find shared blocks in the
refcount btree.  Always_cow inodes don't have that tree, so don't
bother.

For the existing always_cow code this is a minor optimization.  For
the upcoming zoned code that can do COW without the rtreflink code it
avoids triggering a NULL pointer dereference.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index b21cb0d36dd4..fd65e5d7994a 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -235,7 +235,7 @@ xfs_reflink_trim_around_shared(
 	int			error = 0;
 
 	/* Holes, unwritten, and delalloc extents cannot be shared */
-	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_written_extent(irec)) {
+	if (!xfs_is_reflink_inode(ip) || !xfs_bmap_is_written_extent(irec)) {
 		*shared = false;
 		return 0;
 	}
-- 
2.45.2

