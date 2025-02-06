Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA5F1FDA85
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824325; cv=none; b=EZVRdrcK8xnlirxoO/dXL/ogMSnQlWJXhSfUV0eIFZn4f9MVhaoF4ZG+3PYgCUvFqqfO5oZP8tNhHD6up6Dwmxrko144wRa2HBFa/stDQc6neE0DS3zLCgxDNQgiBOc4/TqnYVPjTek7U9Yv1L5OxSYlL+oQg59dUJQSWStQWKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824325; c=relaxed/simple;
	bh=6vP3riFibSpJpf4VAEt/FDn2kVB2Bat3njOx6rhaoU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZuNKHf+XkkbRdktqmRIBqmjzUKcyMbC7vggPFlGixPa7FWsi0SwoOZLHDVvLHyXQr8HHhnqEJNgotCfr0uMTeAy4a3e07VIKHyImhSEK+1eez/XuBzOxN2mBLYjS4ljr0FxJlAkBrLI4a5gNhxpHEpKJW631PWxxwBDbaoLPVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hCZ2YUoH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hCZ2YUoH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hFhZsTt+WkWeyWfXt1lx2svm/aueat6biJQx6sJkcZQ=; b=hCZ2YUoHRrEIPfAkzsqj2kxcrk
	R30i78UIGq+yVAXoThLd8W8Vf16TnGRFTYWK5z7YphUzH8UMHoKAXKorozp37TxHe6RnZWwj26d92
	EKgaTYEPSRTeEmOmuhIXieXj0V3MQNXjMKceBdpRCfkS77OVfRpvq3f/5a9iCkaRf/5p7bcMh02aV
	m1Hw4RCi5vv6DTjqOR9aMl6y+ywTTsdMuSm+hQmKNiJ53RBl01TwYhYFQMVVQh8wJ74+DaXBry1O/
	Bm9Z4r5Oq05fgmEWXWaDcQE0fzK8k95OU0pvZJ8x1GC0aONmJovp/b15oQ4RsmFSATkZY7cuKvPFF
	KEfQAZ5A==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvda-00000005Q5W-3rG3;
	Thu, 06 Feb 2025 06:45:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/43] xfs: skip always_cow inodes in xfs_reflink_trim_around_shared
Date: Thu,  6 Feb 2025 07:44:20 +0100
Message-ID: <20250206064511.2323878-5-hch@lst.de>
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

xfs_reflink_trim_around_shared tries to find shared blocks in the
refcount btree.  Always_cow inodes don't have that tree, so don't
bother.

For the existing always_cow code this is a minor optimization.  For
the upcoming zoned code that can do COW without the rtreflink code it
avoids triggering a NULL pointer dereference.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 59f7fc16eb80..3e778e077d09 100644
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

