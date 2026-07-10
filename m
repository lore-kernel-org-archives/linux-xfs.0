Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2673DA5D5;
	Fri, 10 Jul 2026 08:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673639; cv=none; b=IdPwxj5ywEYi1mJYPVtDBiMaysMGmNNGQqdLiscMSPVaZ8mvFcUDDA+THFJ8Po6ZAh5lixnC/zq2EBekzvfNBjl2qfHMULNCBop6e5Lkljrqqqt+SOmRZVBmIJfMAhPu1Ucea1Lnc0HNexfvZbXv3Fve1ek1N9b7QjWOzBCMBTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673639; c=relaxed/simple;
	bh=mDosfPzgYC16cJ0LllsDGXsNTYYjFfv6DY7gE1CkfM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtnukxMADjU/bf1bO7gHFYQkY8rMtQJHlAsSFKqEiZuE8eOAblCQR0zGM43lgzyYyo91YLIV2a0PhJLMhtQZntoOjrDHc7UuLc5bubQ9eTxz0HS7a0Bsus4CvcQoLjviWWvTHQ4g5cQiH4ClMj+SkEHobsZ22UAL9JkDnq8uerE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i4NhtQ8d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i4NhtQ8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7A31F000E9;
	Fri, 10 Jul 2026 08:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783673637;
	bh=jo5kGnyg/lTwyLsYWmslZGu/Gmp+gDx1qOE4iRmbEpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4NhtQ8dgLSb2clPBJ6pyZZIG8kVplbYzbikMotAkQZTeawEsy+DMjdi+z/ug04TV
	 3NmXbu39TrWwWD00k7yWvsbRDqXTJA+W38/wa3tmVIMtrLMnYZBlRVakVEt4hnfVge
	 hL+W/Bpmj/ZtBWWcCTUpaHf/OkSNjo2YHKjpXK6kZm0Em9rZka3aZ4xZ2LZcxFseSE
	 P+7Hl/RwGzER1dvRQov23Y0hL6kXbjRLNo0pKAfzsKEsvD3q8OOLRgS1CEk51Wjn3n
	 9rV1TtB1XVqAEaUIFV8lEpa8zrMspjf2XTJOw+N3mLbCqaB5q7XGvDHEMb9aFA+6UH
	 3FsHGziw5docw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v11 11/20] xfs: disable direct read path for fs-verity files
Date: Fri, 10 Jul 2026 10:52:39 +0200
Message-ID: <20260710085256.3464201-12-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710085256.3464201-1-aalbersh@kernel.org>
References: <20260710085256.3464201-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The direct path is not supported on verity files. Attempts to use direct
I/O path on such files should fall back to buffered I/O path.

Add a fall back to buffered I/O at two place, in a common fast path and
latter when lock is acquired. The second check prevents TOCTOU issue
with reading fsverity_active() status and resetting IOCB_DIRECT flag.

If one thread saw fsverity_active() to be false, and then second thread
acquired XFS_IOLOCK_EXCL and enabled fsverity. The first thread will go
through the DIO path.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_file.c | 59 +++++++++++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e3f4353b3b78..cba194d678fc 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -246,6 +246,25 @@ static const struct iomap_dio_ops xfs_dio_read_bounce_ops = {
 	.bio_set	= &iomap_ioend_bioset,
 };
 
+STATIC ssize_t
+xfs_file_buffered_read(
+	struct kiocb		*iocb,
+	struct iov_iter		*to)
+{
+	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
+	ssize_t			ret;
+
+	trace_xfs_file_buffered_read(iocb, to);
+
+	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
+	if (ret)
+		return ret;
+	ret = generic_file_read_iter(iocb, to);
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+
+	return ret;
+}
+
 STATIC ssize_t
 xfs_file_dio_read(
 	struct kiocb		*iocb,
@@ -266,6 +285,16 @@ xfs_file_dio_read(
 	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
 	if (ret)
 		return ret;
+	/*
+	 * Re-check verity status after acquiring lock. This prevents TOCTOU in
+	 * xfs_file_read_iter() while falling back from DIO to buffered I/O as
+	 * now we are holding a lock
+	 */
+	if (fsverity_active(VFS_I(ip))) {
+		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+		iocb->ki_flags &= ~IOCB_DIRECT;
+		return xfs_file_buffered_read(iocb, to);
+	}
 	if (mapping_stable_writes(iocb->ki_filp->f_mapping)) {
 		dio_ops = &xfs_dio_read_bounce_ops;
 		dio_flags |= IOMAP_DIO_BOUNCE;
@@ -282,7 +311,8 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -300,25 +330,6 @@ xfs_file_dax_read(
 	return ret;
 }
 
-STATIC ssize_t
-xfs_file_buffered_read(
-	struct kiocb		*iocb,
-	struct iov_iter		*to)
-{
-	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
-	ssize_t			ret;
-
-	trace_xfs_file_buffered_read(iocb, to);
-
-	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
-	if (ret)
-		return ret;
-	ret = generic_file_read_iter(iocb, to);
-	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-
-	return ret;
-}
-
 STATIC ssize_t
 xfs_file_read_iter(
 	struct kiocb		*iocb,
@@ -333,6 +344,14 @@ xfs_file_read_iter(
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
+	/*
+	 * In case fs-verity is enabled, we also fallback to the buffered read
+	 * from the direct read path. Therefore, IOCB_DIRECT is set and need to
+	 * be cleared (see generic_file_read_iter())
+	 */
+	if (fsverity_active(inode))
+		iocb->ki_flags &= ~IOCB_DIRECT;
+
 	if (IS_DAX(inode))
 		ret = xfs_file_dax_read(iocb, to);
 	else if (iocb->ki_flags & IOCB_DIRECT)
-- 
2.54.0

