Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CEF3009C1
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 09:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765357448; cv=none; b=ujMb5NWzVJo0bZoSyVtV39NfNrx7IimDpT2HUh9UOJmGtqOTQzjC7sgOggF6WD+Tw+bQi8y3PrmGy2Z5SkrDq+tSeZNhcHOoU6Mf2W+35omnUnPQuOjGAJiqWqhCXMm9HB3hun+63t8qy6tZduYQX0FD6jVckm3/3EtTa5kyz+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765357448; c=relaxed/simple;
	bh=2LBDfTBQfB6fFmL86DFHVzznvs1+lWqpwojCCvX/kGs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=raBcrY4w0JdTmlrCk9J+GwXBWRj+T2ThEMKpEfho8kd+PuT3GZn7bYuxUe7UF9p7siY6Ai2xXdHr/tdRMxO6PrWPKXgvbry06L4RcE+/MbQ0pZkioRjR3ANVHfbPVS285EsV1Xz1ABqb7a2mAzvuNDztY1k6svRg+aAuMb9L7So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B7eBn7S2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B7eBn7S2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=zhwldDlTLA1fydvroi2hnYzlTB5lzfmqfCNXoQxn5no=; b=B7eBn7S25IfC/m+kLqnWRffWtM
	RyEZpT9tinYKmlUnIVBaSjWXHPOGtFYBTAaDckriFcLbi5FETID1L2KYaHSk7ltXeYQzB0QLsSWNA
	bRtOkuHWA0tcIvlkK09KYh4qRftIC930pDNKYlIV0kZGAr1cDBipWIeTrlGqJM47/dQcL0tV1187/
	uz8LEc8ZPFuFLxO2FNT3qStC05TdmNlQuY/R52m8sYDiBK6fetuSJuOakgmHqA501m67Yiqe49pRL
	66DdH3OlwWIKEQLlLWVV1gDEmCO/N+P7QvxD2fQpDpuUq7Wko3hwPAH2tmnNdsmWvwwakxonj9Qdc
	3dI1z6Sg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTG7A-0000000FGWk-3DWs;
	Wed, 10 Dec 2025 09:04:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: bfoster@redhat.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix XFS_ERRTAG_FORCE_ZERO_RANGE for zoned file system
Date: Wed, 10 Dec 2025 10:03:55 +0100
Message-ID: <20251210090400.3642383-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The new XFS_ERRTAG_FORCE_ZERO_RANGE error tag added by commit
ea9989668081 ("xfs: error tag to force zeroing on debug kernels") fails
to account for the zoned space reservation rules and this reliably fails
xfs/131 because the zeroing operation returns -EIO.

Fix this by reserving enough space to zero the entire range, which
requires a bit of (fairly ugly) reshuffling to do the error injection
early enough to affect the space reservation.

Fixes: ea9989668081 ("xfs: error tag to force zeroing on debug kernels")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 46 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6108612182e2..dbf37adf3a6b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1254,7 +1254,8 @@ xfs_falloc_zero_range(
 	int			mode,
 	loff_t			offset,
 	loff_t			len,
-	struct xfs_zone_alloc_ctx *ac)
+	struct xfs_zone_alloc_ctx *ac,
+	bool			force_zero_range)
 {
 	struct inode		*inode = file_inode(file);
 	struct xfs_inode	*ip = XFS_I(inode);
@@ -1274,8 +1275,7 @@ xfs_falloc_zero_range(
 	 * extents than to perform zeroing here, so use an errortag to randomly
 	 * force zeroing on DEBUG kernels for added test coverage.
 	 */
-	if (XFS_TEST_ERROR(ip->i_mount,
-			   XFS_ERRTAG_FORCE_ZERO_RANGE)) {
+	if (force_zero_range) {
 		error = xfs_zero_range(ip, offset, len, ac, NULL);
 	} else {
 		error = xfs_free_file_space(ip, offset, len, ac);
@@ -1357,7 +1357,8 @@ __xfs_file_fallocate(
 	int			mode,
 	loff_t			offset,
 	loff_t			len,
-	struct xfs_zone_alloc_ctx *ac)
+	struct xfs_zone_alloc_ctx *ac,
+	bool			force_zero_range)
 {
 	struct inode		*inode = file_inode(file);
 	struct xfs_inode	*ip = XFS_I(inode);
@@ -1393,7 +1394,8 @@ __xfs_file_fallocate(
 		error = xfs_falloc_insert_range(file, offset, len);
 		break;
 	case FALLOC_FL_ZERO_RANGE:
-		error = xfs_falloc_zero_range(file, mode, offset, len, ac);
+		error = xfs_falloc_zero_range(file, mode, offset, len, ac,
+				force_zero_range);
 		break;
 	case FALLOC_FL_UNSHARE_RANGE:
 		error = xfs_falloc_unshare_range(file, mode, offset, len);
@@ -1419,17 +1421,24 @@ xfs_file_zoned_fallocate(
 	struct file		*file,
 	int			mode,
 	loff_t			offset,
-	loff_t			len)
+	loff_t			len,
+	bool			force_zero_range)
 {
 	struct xfs_zone_alloc_ctx ac = { };
 	struct xfs_inode	*ip = XFS_I(file_inode(file));
+	struct xfs_mount	*mp = ip->i_mount;
 	int			error;
+	xfs_filblks_t		count_fsb = 2;
 
-	error = xfs_zoned_space_reserve(ip->i_mount, 2, XFS_ZR_RESERVED, &ac);
+	if (force_zero_range)
+		count_fsb += XFS_B_TO_FSB(mp, len) + 1;
+
+	error = xfs_zoned_space_reserve(mp, count_fsb, XFS_ZR_RESERVED, &ac);
 	if (error)
 		return error;
-	error = __xfs_file_fallocate(file, mode, offset, len, &ac);
-	xfs_zoned_space_unreserve(ip->i_mount, &ac);
+	error = __xfs_file_fallocate(file, mode, offset, len, &ac,
+			force_zero_range);
+	xfs_zoned_space_unreserve(mp, &ac);
 	return error;
 }
 
@@ -1441,12 +1450,18 @@ xfs_file_fallocate(
 	loff_t			len)
 {
 	struct inode		*inode = file_inode(file);
+	struct xfs_inode	*ip = XFS_I(inode);
+	bool			force_zero_range = false;
 
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
 	if (mode & ~XFS_FALLOC_FL_SUPPORTED)
 		return -EOPNOTSUPP;
 
+	if ((mode & FALLOC_FL_MODE_MASK) == FALLOC_FL_ZERO_RANGE &&
+	    XFS_TEST_ERROR(ip->i_mount, XFS_ERRTAG_FORCE_ZERO_RANGE))
+		force_zero_range = true;
+
 	/*
 	 * For zoned file systems, zeroing the first and last block of a hole
 	 * punch requires allocating a new block to rewrite the remaining data
@@ -1455,11 +1470,14 @@ xfs_file_fallocate(
 	 * expected to be able to punch a hole even on a completely full
 	 * file system.
 	 */
-	if (xfs_is_zoned_inode(XFS_I(inode)) &&
-	    (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
-		     FALLOC_FL_COLLAPSE_RANGE)))
-		return xfs_file_zoned_fallocate(file, mode, offset, len);
-	return __xfs_file_fallocate(file, mode, offset, len, NULL);
+	if (xfs_is_zoned_inode(ip) &&
+	    (force_zero_range ||
+	     (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
+		      FALLOC_FL_COLLAPSE_RANGE))))
+		return xfs_file_zoned_fallocate(file, mode, offset, len,
+				force_zero_range);
+	return __xfs_file_fallocate(file, mode, offset, len, NULL,
+			force_zero_range);
 }
 
 STATIC int
-- 
2.47.3

