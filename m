Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630538;
	b=bS9OuedXwcOK2bfgFeB6OmOr5NNE+V9WFrA4VyNfHf5DtpqUzFsRK9ONY77gbuRKwH8A
	 w5k/MQQOT4YuDLBbvkDPyVvDT10N7g3g4VY1OQm9HMRn0oX18zjRK1C+9xPGV6xstnKQu
	 ckZBbhl09bF+8oqZz6w7WDC1DDDBH5Vg4Cj/LrJeYquU+w4Fh0cFl8vwM+nCFzQeMD7Hp
	 QjjgZGM4tOy6BqlX3OBatMUCS/I0RKVp7rXeOJ/1cEBWnIVzjQopkc7YpmcosUt06gGNe
	 0biaLZG1EJm83nh8PE1HvA3H+8wGPNkKyb6J3FoALmo/9UNt5VwTEqMmdXaSaPRR0sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=rXte9rTzRKjbHCORODsd7uOdWMwyVG0CphMK55pLtU0=;
	b=XOTvmKA8j7gDs4MTaJGlDVLsMhAsPILBb5PmBvqq1RPcqBwi8zRJNCbxVG9zPCp4o9KF
	 pe8n3GQ3AHOxpNjhvH+HBkrxYAjgS43lEHnVbYPLHDE+qVhkiQwWkmG4LbCLethz5cYfu
	 sPHBpkndjHlzKN0Til0bOTHaMsej70vcVTDRP2lLUCJapPGmERJ+x7RxXw4v63ytiIGS1
	 OGmAdC1eQGuFZQjC4aZKPpwpkt26vegdYXtZ5DRRo7XTO5xed6bVckInfkz2wAC4S3mU8
	 embF8329lFQHyZYUnwQ8PCc4Wp55XdEH6w/HEDgvuR3k+Ga6sjkrZ4xq8ojeotLtagA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oh149vWI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F72606F23F;
	Mon,  2 Nov 2026 14:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oh149vWI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532F01F00A1A;
	Mon,  2 Nov 2026 14:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630537;
	bh=rXte9rTzRKjbHCORODsd7uOdWMwyVG0CphMK55pLtU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oh149vWIFnGhS5SOkxgOwu1WQi8Um15nQEtH1j/hUw2FjWXfxivojTu6mFuKkrBvB
	 inywo1aMidNpCFYPR5P4UH4Gw7aWkit8yotNwLkLTA0dke+Z88UmQjiZxdMzKp4bGh
	 suo4ZF/zQvUPviZB8t4yhRfQMfnCMIKr+LB19AxRR/XF3E5V8P0M7ZApThxrPbeVR1
	 xkI79I5YwGsB5Lt3BDgWkFpShVGtYZ3NNk8+FOsBhW1RwrHdz5kklPP+Kte1CX2yG9
	 7Ui25KhKph7bFbuyRWkN9YchSHwCCMsIJmuOPN+a571Z8oaey5kybYEzcTImT1MvFI
	 oH7IRhPZ+NbWw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v18 03/15] xfs: disable direct read path for fs-verity files
Date: Mon,  2 Nov 2026 15:41:33 +0100
Message-ID: <20261102144147.2393369-4-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102144147.2393369-1-aalbersh@kernel.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
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
index 7d0c8a197575..f0d000272521 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -38,6 +38,7 @@
 #include <linux/mount.h>
 #include <linux/filelock.h>
 #include <linux/bio-integrity.h>
+#include <linux/fsverity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -231,6 +232,25 @@ static const struct iomap_dio_ops xfs_dio_read_bounce_ops = {
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
@@ -249,6 +269,17 @@ xfs_file_dio_read(
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
@@ -268,7 +299,8 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -286,25 +318,6 @@ xfs_file_dax_read(
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
@@ -319,6 +332,14 @@ xfs_file_read_iter(
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

