Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486DB3E7BC2
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 11:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781178059; cv=none; b=TvT8I/SsvFmpeu0mBjwSDxbSEyZK5kYUJMazzh027F9geRtjHyd6cNNKY1B1dposejFTFk9LPzmDd/R/KyC7+OpErZuR72Oh7VK4kfMMJtdVmOxRYXOg3SMu6ZL8Js8PxFV4y/8yHWfNZHSxOLMaXorXa8ohBj61skDEwe6XOrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781178059; c=relaxed/simple;
	bh=hlBv9vTbMP24bxLzmRXLaKXTQbE6ukSNjllDC0Ah23o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtuctJhe869P9h20PXSLmqPk517Q9lFH2TTUgaYhMi0s89ELSCBv0mS3MyrXEMNHSLNbt/b+am0XV4NxOpGdbtOXoxhcGWEeTutn+naxlkcNMdjfqz8jI2PfTJUQ972F6ok7z18YYYon91RGrIrfKjL9NSjfNbbyV5D4V/mVHxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4gbgh56J1rz9tnC;
	Thu, 11 Jun 2026 13:40:53 +0200 (CEST)
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of kernel@pankajraghav.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
From: Pankaj Raghav <p.raghav@samsung.com>
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com,
	lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>,
	p.raghav@samsung.com,
	dgc@kernel.org,
	gost.dev@samsung.com,
	pankaj.raghav@linux.dev,
	andres@anarazel.de,
	kundan.kumar@samsung.com,
	hch@lst.de,
	cem@kernel.org,
	hch@infradead.org
Subject: [PATCH v6 2/3] xfs: add an allocation mode to xfs_alloc_file_space()
Date: Thu, 11 Jun 2026 13:40:28 +0200
Message-ID: <20260611114029.176200-3-p.raghav@samsung.com>
In-Reply-To: <20260611114029.176200-1-p.raghav@samsung.com>
References: <20260611114029.176200-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4gbgh56J1rz9tnC

xfs_alloc_file_space() hardcodes XFS_BMAPI_PREALLOC to preallocate
unwritten extents across a range.

In preparation for FALLOC_FL_WRITE_ZEROES, add an explicit allocation
mode argument, enum xfs_alloc_file_space_mode, and derive the xfs_bmapi
flags from it. The only mode for now is XFS_ALLOC_FILE_SPACE_PREALLOC,
which preallocates unwritten extents and marks the inode as preallocated
exactly as before, so there is no functional change.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/xfs/xfs_bmap_util.c | 25 +++++++++++++++++++++----
 fs/xfs/xfs_bmap_util.h |  6 +++++-
 fs/xfs/xfs_file.c      |  9 ++++++---
 3 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 3b9f262f8e91..8dfb3c1e3759 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -642,11 +642,19 @@ xfs_free_eofblocks(
 	return error;
 }
 
+/*
+ * Allocate space for a file according to @mode:
+ *
+ * XFS_ALLOC_FILE_SPACE_PREALLOC:
+ * Preallocate unwritten extents across the range and mark the inode as
+ * preallocated.
+ */
 int
 xfs_alloc_file_space(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
-	xfs_off_t		len)
+	xfs_off_t		len,
+	enum xfs_alloc_file_space_mode mode)
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_off_t		count;
@@ -657,6 +665,7 @@ xfs_alloc_file_space(
 	int			rt;
 	xfs_trans_t		*tp;
 	xfs_bmbt_irec_t		imaps[1], *imapp;
+	uint32_t		bmapi_flags, nr_exts;
 	int			error;
 
 	if (xfs_is_always_cow_inode(ip))
@@ -674,6 +683,15 @@ xfs_alloc_file_space(
 	if (len <= 0)
 		return -EINVAL;
 
+	switch (mode) {
+	case XFS_ALLOC_FILE_SPACE_PREALLOC:
+		bmapi_flags = XFS_BMAPI_PREALLOC;
+		nr_exts = XFS_IEXT_ADD_NOSPLIT_CNT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	rt = XFS_IS_REALTIME_INODE(ip);
 	extsz = xfs_get_extsz_hint(ip);
 
@@ -733,8 +751,7 @@ xfs_alloc_file_space(
 		if (error)
 			break;
 
-		error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
-				XFS_IEXT_ADD_NOSPLIT_CNT);
+		error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK, nr_exts);
 		if (error)
 			goto error;
 
@@ -748,7 +765,7 @@ xfs_alloc_file_space(
 		 * will eventually reach the requested range.
 		 */
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
-				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
+				allocatesize_fsb, bmapi_flags, 0, imapp,
 				&nimaps);
 		if (error) {
 			if (error != -ENOSR)
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index c477b3361630..232b4c48247e 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -55,8 +55,12 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 			     int *is_empty);
 
 /* preallocation and hole punch interface */
+enum xfs_alloc_file_space_mode {
+	XFS_ALLOC_FILE_SPACE_PREALLOC,
+};
+
 int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
-		xfs_off_t len);
+		xfs_off_t len, enum xfs_alloc_file_space_mode mode);
 int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
 int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 845a97c9b063..e90ea6ebdc8e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1406,7 +1406,8 @@ xfs_falloc_zero_range(
 		len = round_up(offset + len, blksize) -
 			round_down(offset, blksize);
 		offset = round_down(offset, blksize);
-		error = xfs_alloc_file_space(ip, offset, len);
+		error = xfs_alloc_file_space(ip, offset, len,
+				XFS_ALLOC_FILE_SPACE_PREALLOC);
 	}
 	if (error)
 		return error;
@@ -1432,7 +1433,8 @@ xfs_falloc_unshare_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
+			XFS_ALLOC_FILE_SPACE_PREALLOC);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1460,7 +1462,8 @@ xfs_falloc_allocate_range(
 	if (error)
 		return error;
 
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
+			XFS_ALLOC_FILE_SPACE_PREALLOC);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
-- 
2.51.2

