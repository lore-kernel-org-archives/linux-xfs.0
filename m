Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07483AE6E6;
	Mon,  3 Aug 2026 20:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785787778; cv=none; b=k8BbL+7zkiVl8WDu9hHWE/HHSC8AIYFJ4nMDozp0URay2LhgfC38pNn7vRDdqN/JonALWmbTXokPQdT+hELLEekTmcx2lmB+MVlToQubr5znkNZzc/sE1Z357TUacPEkVC2mej7WMDumZo3vrskLOT+4KVQqryz0hNjlZuol35s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785787778; c=relaxed/simple;
	bh=HFvYVokeu9JGb6SFdLTk8NU1EuKjaZAaV2k235usN+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPg5GbfRTNsD8O2nSPgkZMqLXhA6R5HOz3D7gzaHMUYfrU0ws3ubFH5/53NTbhV318EvSm4jl3uplVbImKNrDFWWqib/w/OV8ccKOS83ps2vZXH4/3h/2pd1nB37wHdwqKlBWW1EzKQbmBhwMRzIclyBT6xpLLiJHvWm14L+ceg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wr6igXIa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wr6igXIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC671F00A3A;
	Mon,  3 Aug 2026 20:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785787776;
	bh=f6lFZ+zFVW+ee359CJGo6s1PxiJC5wOAqyw1jZLM8dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wr6igXIauB91HFQFmq+MGUb/tqIIyuGrbSt8hPy6iTuO6nwYCBktptty9BbGd30jf
	 4ueI3bTDnfR7zhVmYuZXb5n11fe4Yp7T1LdZVMtGcpW+pLKAk2/wjCucUTCBWjjTWF
	 suv2G36o+t4sYpgP2h0UbPK3aFd6D7MrJXFt6Ra4n65sdIQlxqH0hruHUN0uqt0FeO
	 fD/xeR94JPnLh0amFqfpAk86mhpbdcCymmfK7QsdmohksSJTKAobwWgzUbaAI+WQ3c
	 uCaX7PKjL5i2zS/BfzPaTVUdvkDb5dhzQPbd0zZez24ppgF0hBmzGK/uQnBJu2Rt6U
	 EYefu7BJaEonw==
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
Subject: [PATCH v14 10/21] xfs: disable direct read path for fs-verity files
Date: Mon,  3 Aug 2026 22:08:00 +0200
Message-ID: <20260803200820.393203-11-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260803200820.393203-1-aalbersh@kernel.org>
References: <20260803200820.393203-1-aalbersh@kernel.org>
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
index 04301ab977a3..67c1357f4701 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -37,6 +37,7 @@
 #include <linux/fadvise.h>
 #include <linux/mount.h>
 #include <linux/filelock.h>
+#include <linux/fsverity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -244,6 +245,25 @@ static const struct iomap_dio_ops xfs_dio_read_bounce_ops = {
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
@@ -264,6 +284,17 @@ xfs_file_dio_read(
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
 	if (mapping_stable_writes(iocb->ki_filp->f_mapping))
 		dio_ops = &xfs_dio_read_bounce_ops;
 	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, dio_ops, dio_flags,
@@ -278,7 +309,8 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -296,25 +328,6 @@ xfs_file_dax_read(
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
@@ -329,6 +342,14 @@ xfs_file_read_iter(
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

