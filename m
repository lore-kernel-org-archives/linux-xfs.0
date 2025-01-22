Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9069A653
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 05:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737524609; cv=none; b=HVnuw7JcpHLvM7SNvdkgN6H+8YpNJtXWOq1pYfBFbD7hNoYq874HYl42INgguz89d3dLlEZH36M9TZPR2v7XPCyQpPcKybWB2Yj9XR7K/y+3vo6qio7Dt09XVjqfoFXrsN5/UBaR6JHV2PMfNFaWZn17RP9cJL2/sP7wslM+OhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737524609; c=relaxed/simple;
	bh=iiLXhl5Nq+X+MqO24N3rU80tLOx0/IrI4tdm6gCbxRo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BAaqxpPEj2YqRAaqv4slpEEIJnxpVZ8GVDxjWrmTqO6JmNxIKHjYs460NhyndYCzlDND6xVWGiic40HIOlfKV/He47CXHzhWw3KVm8fRjyoftmhfH5CyMTlQ14FTqa6fzh5LJLtXI7Ked6KAr4QyfhJSyFTXMh8jiyMx4zuB8tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FOAz+bVu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FOAz+bVu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=hlb/VpO+7Aov/Y4PqN47iFxJbn6BSQXB2yeaNU20/K4=; b=FOAz+bVuC8b4l3Vdtm5xrFy8a7
	irDbzmD+EyDCMx8k3EExqyKpmD4Hjg4ft9F17N8osrg0tM9ynWILJL0HW7s0vaAPptwj60zUEt+UC
	SDoIVYzsqj3pkKnQ8i3VzL7tTEy+8NK77+ediMNBF93v0NxxXrk3Poos3tXQ4jQambQXBnnD5J8Uo
	ZcpAxcxI6HhGEJnNWfOZfgqe39ijjZmkv1eW/lf9VHXPrUtmnYAoTmHWJ3KrBZPhGaLZcR4MzJiPa
	JHs1wQrs5p/kSH9tjfwsPihqUFJNMymCGmp3Ym9adNh/Gnft/n70hpEHS6R605wcujDwr9xCyq/wt
	dd/5lX7A==;
Received: from 2a02-8389-2341-5b80-adc8-6898-145f-8c92.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:adc8:6898:145f:8c92] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1taTWP-00000009QpB-1Cyi;
	Wed, 22 Jan 2025 05:43:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	amir73il@gmail.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: don't call remap_verify_area with sb write protection held
Date: Wed, 22 Jan 2025 06:43:21 +0100
Message-ID: <20250122054321.910578-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The XFS_IOC_EXCHANGE_RANGE ioctl with the XFS_EXCHANGE_RANGE_TO_EOF flag
operates on a range bounded by the end of the file.  This means the
actual amount of blocks exchanged is derived from the inode size, which
is only stable with the IOLOCK (i_rwsem) held.  Do that, it currently
calls remap_verify_area from inside the sb write protection which nests
outside the IOLOCK.  But this makes fsnotify_file_area_perm which is
called from remap_verify_area unhappy when the kernel is built with
lockdep and the recently added CONFIG_FANOTIFY_ACCESS_PERMISSIONS
option.

Fix this by always calling remap_verify_area before taking the write
protection, and passing a 0 size to remap_verify_area similar to
the FICLONE/FICLONERANGE ioctls when they are asked to clone until
the file end.

(Note: the size argument gets passed to fsnotify_file_area_perm, but
then isn't actually used there).

Fixes: 9a64d9b3109d ("xfs: introduce new file range exchange ioctl")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_exchrange.c | 71 ++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index f340a2015c4c..0b41bdfecdfb 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -329,22 +329,6 @@ xfs_exchrange_mappings(
  * successfully but before locks are dropped.
  */
 
-/* Verify that we have security clearance to perform this operation. */
-static int
-xfs_exchange_range_verify_area(
-	struct xfs_exchrange	*fxr)
-{
-	int			ret;
-
-	ret = remap_verify_area(fxr->file1, fxr->file1_offset, fxr->length,
-			true);
-	if (ret)
-		return ret;
-
-	return remap_verify_area(fxr->file2, fxr->file2_offset, fxr->length,
-			true);
-}
-
 /*
  * Performs necessary checks before doing a range exchange, having stabilized
  * mutable inode attributes via i_rwsem.
@@ -355,11 +339,13 @@ xfs_exchange_range_checks(
 	unsigned int		alloc_unit)
 {
 	struct inode		*inode1 = file_inode(fxr->file1);
+	loff_t			size1 = i_size_read(inode1);
 	struct inode		*inode2 = file_inode(fxr->file2);
+	loff_t			size2 = i_size_read(inode2);
 	uint64_t		allocmask = alloc_unit - 1;
 	int64_t			test_len;
 	uint64_t		blen;
-	loff_t			size1, size2, tmp;
+	loff_t			tmp;
 	int			error;
 
 	/* Don't touch certain kinds of inodes */
@@ -368,24 +354,25 @@ xfs_exchange_range_checks(
 	if (IS_SWAPFILE(inode1) || IS_SWAPFILE(inode2))
 		return -ETXTBSY;
 
-	size1 = i_size_read(inode1);
-	size2 = i_size_read(inode2);
-
 	/* Ranges cannot start after EOF. */
 	if (fxr->file1_offset > size1 || fxr->file2_offset > size2)
 		return -EINVAL;
 
-	/*
-	 * If the caller said to exchange to EOF, we set the length of the
-	 * request large enough to cover everything to the end of both files.
-	 */
 	if (fxr->flags & XFS_EXCHANGE_RANGE_TO_EOF) {
+		/*
+		 * If the caller said to exchange to EOF, we set the length of
+		 * the request large enough to cover everything to the end of
+		 * both files.
+		 */
 		fxr->length = max_t(int64_t, size1 - fxr->file1_offset,
 					     size2 - fxr->file2_offset);
-
-		error = xfs_exchange_range_verify_area(fxr);
-		if (error)
-			return error;
+	} else {
+		/*
+		 * Otherwise we require both ranges to end within EOF.
+		 */
+		if (fxr->file1_offset + fxr->length > size1 ||
+		    fxr->file2_offset + fxr->length > size2)
+			return -EINVAL;
 	}
 
 	/*
@@ -401,15 +388,6 @@ xfs_exchange_range_checks(
 	    check_add_overflow(fxr->file2_offset, fxr->length, &tmp))
 		return -EINVAL;
 
-	/*
-	 * We require both ranges to end within EOF, unless we're exchanging
-	 * to EOF.
-	 */
-	if (!(fxr->flags & XFS_EXCHANGE_RANGE_TO_EOF) &&
-	    (fxr->file1_offset + fxr->length > size1 ||
-	     fxr->file2_offset + fxr->length > size2))
-		return -EINVAL;
-
 	/*
 	 * Make sure we don't hit any file size limits.  If we hit any size
 	 * limits such that test_length was adjusted, we abort the whole
@@ -747,6 +725,7 @@ xfs_exchange_range(
 {
 	struct inode		*inode1 = file_inode(fxr->file1);
 	struct inode		*inode2 = file_inode(fxr->file2);
+	loff_t			check_len = fxr->length;
 	int			ret;
 
 	BUILD_BUG_ON(XFS_EXCHANGE_RANGE_ALL_FLAGS &
@@ -779,14 +758,18 @@ xfs_exchange_range(
 		return -EBADF;
 
 	/*
-	 * If we're not exchanging to EOF, we can check the areas before
-	 * stabilizing both files' i_size.
+	 * If we're exchanging to EOF we can't calculate the length until taking
+	 * the iolock.  Pass a 0 length to remap_verify_area similar to the
+	 * FICLONE and FICLONERANGE ioctls that support cloning to EOF as well.
 	 */
-	if (!(fxr->flags & XFS_EXCHANGE_RANGE_TO_EOF)) {
-		ret = xfs_exchange_range_verify_area(fxr);
-		if (ret)
-			return ret;
-	}
+	if (fxr->flags & XFS_EXCHANGE_RANGE_TO_EOF)
+		check_len = 0;
+	ret = remap_verify_area(fxr->file1, fxr->file1_offset, check_len, true);
+	if (ret)
+		return ret;
+	ret = remap_verify_area(fxr->file2, fxr->file2_offset, check_len, true);
+	if (ret)
+		return ret;
 
 	/* Update cmtime if the fd/inode don't forbid it. */
 	if (!(fxr->file1->f_mode & FMODE_NOCMTIME) && !IS_NOCMTIME(inode1))
-- 
2.45.2

