Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F09817548
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738822521; cv=none; b=iN6+ZonBiPnDGep6YCdlsHYTQdXyv002htwS6bBzLuL7vSRYhzSWKYDd50tfj1bp/Fx3BH/cuaFHyyuFISzEGKaT1n7Alo8oQ3ceQPzVUBc7IXt1fMz8ozqgysJIkzFXu2WeP7b+Rc1Z7ZlHYh22c+n+w8dilPxjmcH+9U5wCiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738822521; c=relaxed/simple;
	bh=a6y00avvIG31JRWksWYH2NwiUZ1R/TSq0DIQDTOY6jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Il8BHAAfHWuQMFH0Njfl76lIk/xXNTeJpJJprhrsrgqBRohXxOabfsQ/LC2INX6ueHUv8ZixcY0Kx49RY5cRYwp4H1F+IyCH0YDy5vvh7jhOtAg+ojzE1+CFB8yF2WoaBEc+qlSyOaSjeJtYPlOBQ6p2OA6nOjrgZdX6wX2m8/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YTpGROx6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YTpGROx6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EtuHfVBgzwHzNTRcWyhZ/hJIRmPDG9IhllHTpuP7oeo=; b=YTpGROx6KJbt1XML7SQraz8D5/
	9fkXsjDkHEkh8M62RpVoLvz7Krj7cks1x98V1UFe1t0UtuHd5br9h66v2eOjeI1tr/XJGdxT1xFMD
	Hoos2IJCLXcXz7PI51PNFFsRGTV1YxsiP11DGtFRqCXXPckmsZrrdPEmRV6agIbbUNbQDUdspzYrm
	yRtm9JEX6oW4telBLyLu6VuQ2BsEdy5d/drQw0xZPgCDgBvT72Xs0vJ/lDFMmJIz3b59D1TEDf3OU
	U2QtR9SCu3U3FOWsp23jq1JDjGa/TjKDBrao2ly9CQEYfA6ArTiLqCoFiU2hLsWgvam6kyVZMKVZv
	xA0nj4qg==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvAT-00000005MhY-2eTF;
	Thu, 06 Feb 2025 06:15:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: flush inodegc before swapon
Date: Thu,  6 Feb 2025 07:15:00 +0100
Message-ID: <20250206061507.2320090-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206061507.2320090-1-hch@lst.de>
References: <20250206061507.2320090-1-hch@lst.de>
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

The big comment is taken from a mailinglist post by Dave Chinner.

Fixes: 5e672cd69f0a53 ("xfs: introduce xfs_inodegc_push()")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 69b8c2d1937d..9ff1a0b07303 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -21,6 +21,7 @@
 #include "xfs_error.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_rtgroup.h"
+#include "xfs_icache.h"
 
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
@@ -685,7 +686,39 @@ xfs_iomap_swapfile_activate(
 	struct file			*swap_file,
 	sector_t			*span)
 {
-	sis->bdev = xfs_inode_buftarg(XFS_I(file_inode(swap_file)))->bt_bdev;
+	struct xfs_inode		*ip = XFS_I(file_inode(swap_file));
+
+	/*
+	 * Swap file activation can race against concurrent shared extent
+	 * removal in files that have been cloned.  If this happens,
+	 * iomap_swapfile_iter() can fail because it encountered a shared
+	 * extent even though an operation is in progress to remove those
+	 * shared extents.
+	 *
+	 * This race becomes problematic when we defer extent removal
+	 * operations beyond the end of a syscall (i.e. use async background
+	 * processing algorithms).  Users think the extents are no longer
+	 * shared, but iomap_swapfile_iter() still sees them as shared
+	 * because the refcountbt entries for the extents being removed have
+	 * not yet been updated.  Hence the swapon call fails unexpectedly.
+	 *
+	 * The race condition is currently most obvious from the unlink()
+	 * operation as extent removal is deferred until after the last
+	 * reference to the inode goes away.  We then process the extent
+	 * removal asynchronously, hence triggers the "syscall completed but
+	 * work not done" condition mentioned above.  To close this race
+	 * window, we need to flush any pending inodegc operations to ensure
+	 * they have updated the refcountbt records before we try to map the
+	 * swapfile.
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

