Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463AA1401C
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609110; cv=none; b=OCWYiGvHE/HiegbXBddHsp1AtuVF5adhnXzAU3RkQZBnxgSUL/iG16g3flCeu6u0L6liM1H6q8QZtbBIrnEI55jFyb7Mfg/DjPGV2SLlKXQwTuj8IrlTP/NrwPygLfnNhjy3PY++LPkhWY8yj9YMEu/S8baZE4PS8o7KDekQzx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609110; c=relaxed/simple;
	bh=+xugqEpVSADynfY8J1tHIkEl/eTle6NqatQi7uOy58E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSdsWGlxi80geu7MSyy86qKWLoLVx6u1YsvspGhFlIfppno1/BoR4TxeOqfuG4bWM0WqQpnI4/t2gWXFaFLjBunTHonVMx/ry+XPG3xXa0GIFHdD/cYx7Ms49LnVCSeuhlrc8iPochURa6y2tTQ38aMbEA9CcUo2gzjWVfYf78k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ReM3dqkU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ReM3dqkU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YuZL/aX6HYoGiNvaPHL/vyDrERmBlLFfF/H/yceYwrY=; b=ReM3dqkUvJxBnhlEcVvBDalJmv
	OgDIuB5joD5ghvrIxsyK3m88pmH1XgSw4ykoj2deb9+4X7VUIA+oXCXz6JY8P3A8HLs4kGiXr/OJw
	JNV8i7wxNyUNZBwFu+8RcoU0dq9b8tmuAQy6CMoMU8EYC9kwVeX07jMHFSfZRawNGfJTtpGB05XMP
	0xwCMJUSaH1EuRc8uDgegqaTEFsDunx4uevafYTlPeRNUVca8UgVs7Ey2s4cL4+Nh85BOYf7c699f
	REh64yRZN42KG5hP7cZW+8qqPvlSsTP3ffXhE28Dk11p3VYT9Ve1fx4RZ/WVzYXC+S95ajq5zUHeM
	98+slyeA==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CWa-00000000iUJ-2VWD;
	Mon, 14 Apr 2025 05:38:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 42/43] xfs_mdrestore: support internal RT devices
Date: Mon, 14 Apr 2025 07:36:25 +0200
Message-ID: <20250414053629.360672-43-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Calculate the size properly for internal RT devices and skip restoring
to the external one for this case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mdrestore/xfs_mdrestore.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index d5014981b15a..95b01a99a154 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -183,6 +183,20 @@ verify_device_size(
 	}
 }
 
+static void
+verify_main_device_size(
+	const struct mdrestore_dev	*dev,
+	struct xfs_sb			*sb)
+{
+	xfs_rfsblock_t			nr_blocks = sb->sb_dblocks;
+
+	/* internal RT device */
+	if (sb->sb_rtstart)
+		nr_blocks = sb->sb_rtstart + sb->sb_rblocks;
+
+	verify_device_size(dev, nr_blocks, sb->sb_blocksize);
+}
+
 static void
 read_header_v1(
 	union mdrestore_headers	*h,
@@ -269,7 +283,7 @@ restore_v1(
 
 	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
 
-	verify_device_size(ddev, sb.sb_dblocks, sb.sb_blocksize);
+	verify_main_device_size(ddev, &sb);
 
 	bytes_read = 0;
 
@@ -432,14 +446,14 @@ restore_v2(
 
 	((struct xfs_dsb *)block_buffer)->sb_inprogress = 1;
 
-	verify_device_size(ddev, sb.sb_dblocks, sb.sb_blocksize);
+	verify_main_device_size(ddev, &sb);
 
 	if (sb.sb_logstart == 0) {
 		ASSERT(mdrestore.external_log == true);
 		verify_device_size(logdev, sb.sb_logblocks, sb.sb_blocksize);
 	}
 
-	if (sb.sb_rblocks > 0) {
+	if (sb.sb_rblocks > 0 && !sb.sb_rtstart) {
 		ASSERT(mdrestore.realtime_data == true);
 		verify_device_size(rtdev, sb.sb_rblocks, sb.sb_blocksize);
 	}
-- 
2.47.2

