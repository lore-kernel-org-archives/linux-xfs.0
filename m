Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65B246EC77;
	Tue, 21 Jul 2026 18:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659468; cv=none; b=Xv8ydbkTRlLRaOicJLunO/IoBIw6CFt6lQ91fsXkyqJqkzNZWRkVP80yWfS9VJFAr8wAtRp6q3uGrYrxMrC47G+8rLmvs9mkjkvnym9EBJraBZQIQQR+X9zcYUbcTwtrmvN5diL94+43ZulyNjwSRO6gh2R+RCwdiU9AeAzvqPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659468; c=relaxed/simple;
	bh=Wy5o9OnRMNvwtQA5xGH9N2exQqBqFF6O/O6bRhznn5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLimuJYt848xKwGR6J9HhDgWobUFTke/OwRA8usPcxppOD3WlI5kqcRZsxCMKaT37xMvNd3ymsy1Qv0a+QEmkQUibtrNQm7+7uA3vLjWCqdgl0/j+5k4km1CjVLrHZn8VtJH3xTkyHiI3c9Q5Ep6ZjjC6qT5GIvJBhPYMwSyXX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TrwJyO8e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TrwJyO8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3125B1F00A3D;
	Tue, 21 Jul 2026 18:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659467;
	bh=+tD0Us9sn7wTap8Za5kiVDiU+2D9hhY3YmsPKt5bTSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TrwJyO8eLxeCLhLyhnL4zLsM5PhSM1wulFC0qouFrNwCPPpousRa1vcxyUjKHt2dB
	 WTfHJ9GkrQIsMG9NHKtZzVpOza2B8x60/GmankpyVxevWD+V4F9qgMMsjTqZDnaL6V
	 XWzTPv5ZjkG4r0//Gwms2saWgRNARqId3GAYHex5Rd7ILcDx2iWbUuui3NxAhf2qJS
	 5/11oxxHTY23bV47/dbxbjHftXv1G/4Fh3TVBouhHI9I4+hSNOwB8tKNYOlm1lOttF
	 alaiYWOPrzHQrQ9GLfH3Et5wRukk0pTF7bWPyamuoYnoP/qnuySDUPfrMyZ0pilLVl
	 OmiJcZNBfYhPA==
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
Subject: [PATCH v13 11/23] xfs: disable direct read path for fs-verity files
Date: Tue, 21 Jul 2026 20:40:48 +0200
Message-ID: <20260721184346.416657-12-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260721184346.416657-1-aalbersh@kernel.org>
References: <20260721184346.416657-1-aalbersh@kernel.org>
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
index 845a97c9b063..f7e3fe22ca96 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -245,6 +245,25 @@ static const struct iomap_dio_ops xfs_dio_read_bounce_ops = {
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
@@ -265,6 +284,16 @@ xfs_file_dio_read(
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
@@ -281,7 +310,8 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -299,25 +329,6 @@ xfs_file_dax_read(
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
@@ -332,6 +343,14 @@ xfs_file_read_iter(
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

