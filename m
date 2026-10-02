Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13253C4555;
	Fri,  2 Oct 2026 22:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980666; cv=none; b=KROuIukow9A1YnousqKuI+jnkNHVsG7IY+m5yPfDS8kA0PMKdxQAdL2XE80dKkAIjaGRDVktYV56S5lS+VfVst0V6y9UBN+KF6uJjUfXoylYsuzG5I3NNHA48y8ZrHiqdp2ge7gF9RklxiAavtpGZDW4QAgIGeZMjMRYdynhOck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980666; c=relaxed/simple;
	bh=T8QaJnUp0BFUpEp0YiOa+PckWORguMtKwkHNvRCfbeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGEfsGOvvZ0f1yliHwI6E4LMSFXxLefDCpfSfC+Yv5ZDDonxxtar0G8UgVhDkjXJQHj+YD1Grb3u4wK4SsduTt7ZURPvM9af2ja1KyztYzrPte8gvPuEDdUBDxmPjY6ZVBDXk1Lwrdupp3cOvMd2aTryyHudqlHvHnmZnYgdnrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aE8cWwJu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aE8cWwJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0251F00893;
	Fri,  2 Oct 2026 22:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790980664;
	bh=V/xMdTPkYwWHhaiHtNRdjWuqquaN/UDdlep3XfzYfiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aE8cWwJuQNVQUvEZa9dP1qgvQ5tnUowl9bA37rROte8G+MhGqEHmneOPCiZc/+xgM
	 WsIz3hWRkcRZWiRIMGMOAzTXHvN8dGaiwyX2W+NQcj8q1iG1I7IEFRxrjgdujXWvDE
	 N0/345qRxjhlGa30R0qzkxhIuO8fPgB2lW6U4HAhcYwQQfLZjwgUDO0YjmsGP9go4M
	 PTiOkEnArREa+yngNUKpziNTxiJFqB/eKdKqBs2ZjsAcbpU27ubSyYUR0aQH25H+mv
	 ePOwFYb1uu7zX2RheziOIJw5N+slBgzbach85qEprWRIbrcUg8Bd/pa2hW+LVF87mb
	 54O40WZgoxsGw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v17 09/21] xfs: disable direct read path for fs-verity files
Date: Sat,  3 Oct 2026 00:36:50 +0200
Message-ID: <20261002223705.2175542-10-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261002223705.2175542-1-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 61 +++++++++++++++++++++++++++++++----------------
 1 file changed, 41 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index dd3782e9af93..07abf6e8783f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -38,6 +38,7 @@
 #include <linux/mount.h>
 #include <linux/filelock.h>
 #include <linux/bio-integrity.h>
+#include <linux/fsverity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -232,6 +233,25 @@ static const struct iomap_dio_ops xfs_dio_read_bounce_ops = {
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
@@ -250,6 +270,17 @@ xfs_file_dio_read(
 	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
 	if (ret)
 		return ret;
+
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
 		ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops,
 				&xfs_dio_read_bounce_ops, 0, NULL, 0);
@@ -269,7 +300,8 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -287,25 +319,6 @@ xfs_file_dax_read(
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
@@ -320,6 +333,14 @@ xfs_file_read_iter(
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

