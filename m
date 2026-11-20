Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190304;
	b=Dbd6mDTiUuN7IGiKXLOknSXjyHNMmQQJMGgSBhletiIiVRNTQe7tsUO+J12uPpVtfunN
	 B+HsSQLZZEnggw1imvMK/7Mot4kNeUx+toz110YoV0U49fzh0M+7/aMBCwzVmiQZ7lNaT
	 +lc30Fb62p7Lg1vkVdKWVKXb8K8WMkFkLbECBmWdWZZKyUlcSkGfJWZc6pv1ssh6e21UX
	 cfIS9TsHPtj1TSx8GPrTLmxQXDDQh93dUfmlwf29uQC1kMGKu99rukgha/Jg19wm3iBOF
	 f0lvaZNp6sV6GvZY0aPDXMSVinO8XM/GzEpP8b8fn2Mnjgg0viVbHXmeMd6IZjb25uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=BRXIrlZYUV5jD1uregNzzVM7CkhVWvj4FOLp9A7nWlY=;
	b=Y9etRerzc3Wg3xzSvEh3G5KPvfTQSmd7Gu+9wboxk5iSzoRZ5wOZ5mJFnN7CzXgumT/u
	 uVPq1O/Fg1WhUV/dE9LFFZ7Ixv1OVKHe71z6m6h+ty1iDTZaQFvkdOe9/mMFnBYH0InGH
	 loKwRpzB8LisnSLEZd/OV1BnM1ipuSMOj2DQY87munWg/HWs38Qtg/fV5Gow6VDAJGTaJ
	 cQy7Mz0P/q6AJsMGpG61f73oC40gWbxBGH9DfOXv2/TL7RJsQ4/m2/Sjfkp7FM23b2pWa
	 GfKnzgAolC+v7ft6N9jK66Egm54PVEyi/k1muWF76Xux+J/3Wsfos2D/wp/wLeL7dSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FG2kS4Xd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783F360A260F;
	Fri, 20 Nov 2026 15:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FG2kS4Xd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16FB1F000ED;
	Fri, 20 Nov 2026 15:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190304;
	bh=BRXIrlZYUV5jD1uregNzzVM7CkhVWvj4FOLp9A7nWlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FG2kS4XdbNEce7HKVkcdzL99Jd7We1QOGgmtbXkJsbt2hnXvKQ94/m2hhgJC04ezY
	 4hlavT38a5YcAOoVFmthxKYoCzDZNMJw3SZppdmMgAZmu0rAM9jLfGxxyOwTmXJ++i
	 aHzEluFEhD68h8mX0+zGv4qG0X9HydLcefHmM7LG0d/Qj5Dj8n0igDjGl16vrfqQ/o
	 tZDFpI4vyNI/J56IJRPwI6UL/5GOjMFaiChnp8MPpwDjdx0atXqrgPiNxxZh14MTHx
	 0MgJPvTYr9ee+0cU5lvd60vO+1AXtKRT+oIqwYTSneXTz+7XypYQ4F9kxtrLk3hPEC
	 QMwp27jY6aKJg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>,
	"Christoph Hellwig" <hch@lst.de>,
	"Carlos Maiolino" <cem@kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-xfs" <linux-xfs@vger.kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"fsdevel" <linux-fsdevel@vger.kernel.org>,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v19 03/15] xfs: disable direct read path for fs-verity files
Date: Fri, 20 Nov 2026 16:57:37 +0100
Message-ID: <20261120155752.192025-4-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120155752.192025-1-aalbersh@kernel.org>
References: <20261120155752.192025-1-aalbersh@kernel.org>
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
index d61ea8e2c8e4..1171712d3e5b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -38,6 +38,7 @@
 #include <linux/mount.h>
 #include <linux/filelock.h>
 #include <linux/bio-integrity.h>
+#include <linux/fsverity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -189,6 +190,25 @@ static const struct iomap_dio_ops xfs_dio_read_bounce_ops = {
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
@@ -207,6 +227,17 @@ xfs_file_dio_read(
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
 		ret = iomap_dio_rw(iocb, to, xfs_read_iomap_next,
 				&xfs_dio_read_bounce_ops, 0, NULL, 0);
@@ -226,7 +257,8 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -244,25 +276,6 @@ xfs_file_dax_read(
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
@@ -277,6 +290,14 @@ xfs_file_read_iter(
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

