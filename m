Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEE31DD874
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 16:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738772902; cv=none; b=WjkPdzsrPhrgnDzZjiYs3gjfm/rkyK6o3tcJnQZ0FF07yq/vgux6gcCe6f3IpDnPoezdln2a1c965fEeZEq+ON7+W8lhOiOc3KMJVOpzVCSwMGdnY+4djgHB3uskLde31v2OusHhbF6bjfcNBUOVIskfQLSVcZZGExYhesFaAK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738772902; c=relaxed/simple;
	bh=xRuy/3e5f/UudOVv0bLVPSfJC/iT1sYQK+idvNgGQ3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqgpvO+KlL3rWBhPURUEEiHOn+5m9Pvm6HzrUdzou3vn/KXMZ1D1rH+MopZKK5jxtPKJOypM+kCXKM3wqE17bvS01ybqszKGU+lleggk1sS/mtaJgjtGwEhSxXHT3u8L6zvABYBQk/3IuQFnM8pFwxTzZTpDfFmYzB7OPW+o12w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=01xioHyr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="01xioHyr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4ORis3ByM7YtEDwzZKxb6UKam6j1o/jPJRgbNqYnmmI=; b=01xioHyrMbaYX6NgN9sXUVf3m0
	NmnGFeGf9mLewZL4s0ImSKXnq10Dk3zCHtYRpnn3y/XkYqjWGEqKMuO0j9iGUjL2lIwOT9eeF1tIA
	EVd5NwOZP9fXrt3E2lqrwVN7Sfdz61/sHVpAKnhCtMPVpO2ifs0wHQxVvDh7gb2t0VrcaG7TWi9wH
	YadNsvqPS3JJvBDxwSEB0aI2KK6lg40csqWZb+jeSo4PmSAS2XuSTKxRi7yeBQXakXLKpMRAmlfxb
	8e4KkbRV6iXMK6QvrRFo1MOFpxG5/Akj6CPTez20s0Y9iUILjYN5YOA/56+f0VZiGC/xmMgJhaYKI
	rT2J4HWw==;
Received: from 2a02-8389-2341-5b80-839d-6dcb-449a-ed13.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:839d:6dcb:449a:ed13] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfiGB-00000003ynb-2RCz;
	Wed, 05 Feb 2025 16:28:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: flush inodegc before swapon
Date: Wed,  5 Feb 2025 17:28:00 +0100
Message-ID: <20250205162813.2249154-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250205162813.2249154-1-hch@lst.de>
References: <20250205162813.2249154-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Fix the brand new xfstest that tries to swapon on a recently unshared
file and use the chance to document the other bit of magic in this
function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 69b8c2d1937d..c792297aa0a3 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -21,6 +21,7 @@
 #include "xfs_error.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_rtgroup.h"
+#include "xfs_icache.h"
 
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
@@ -685,7 +686,22 @@ xfs_iomap_swapfile_activate(
 	struct file			*swap_file,
 	sector_t			*span)
 {
-	sis->bdev = xfs_inode_buftarg(XFS_I(file_inode(swap_file)))->bt_bdev;
+	struct xfs_inode		*ip = XFS_I(file_inode(swap_file));
+
+	/*
+	 * Ensure inode GC has finished to remove unmapped extents, as the
+	 * reflink bit is only cleared once all previously shared extents
+	 * are unmapped.  Otherwise swapon could incorrectly fail on a
+	 * very recently unshare file.
+	 */
+	xfs_inodegc_flush(ip->i_mount);
+
+	/*
+	 * Direct the swap code to the correct block device when this file
+	 * sits on the RT device.
+	 */
+	sis->bdev = xfs_inode_buftarg(ip)->bt_bdev;
+
 	return iomap_swapfile_activate(sis, swap_file, span,
 			&xfs_read_iomap_ops);
 }
-- 
2.45.2

