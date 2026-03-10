Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391394C77DD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 11:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773143766; cv=none; b=JYk22nkYWITi6LgJpJDEdT5FrlpWIq4sLzkSl0QMHZTqipIE6FON/U4v5DLT76Fh9B6GMxDC57qUZdVcY2WiN3igLdfzBH2iYWaEV7cMLLmC1j616kq2BWUcbnvB1KP0OOWYgfZISiJyDk3lCKFQrywCeUnEIZtFq541ISHWgBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773143766; c=relaxed/simple;
	bh=CfJCCnAJEwAju2aDY8Qzn0aX2+mjuV2/1RJuZGSp9gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCv0xH8GJMARn1jPeC6444IMgizihLAqcFHiB3axQ+RYyIuyQUNsVeNDQ+NjtcuKnuOQsKsupxvTocHScxg1WW5rqOsgmy0XpvxLsffbwSmN/1HXaE6eDClNPJBUGxIcTCkOTIaOFaLsSd8FZV851qA8duB6CzloEEJuuU5G9Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u31XpaEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u31XpaEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F549C2BC9E;
	Tue, 10 Mar 2026 11:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773143764;
	bh=CfJCCnAJEwAju2aDY8Qzn0aX2+mjuV2/1RJuZGSp9gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u31XpaEnclqNyjouEwZKUujEok73j1zXEvE+DXWHaVuHUKNbRov4NeyYoXmjfPXB7
	 Vc3amHjakrLOxygN4C8ViupT5IHRPvdhKb43FvIrCaayxWT73Q6753V349H/em/D88
	 A8MtccqwzuTofkZQGLOEwVBdieYeTvY78OnapkuL3pDSmliLD6zGHaommRzx7bEhm0
	 dSEkanU6zw9o3IKFDcM+egvJBf5CZdt+iutWSaxliSTaDS2j7dkmzohIJxLrfXtXx1
	 nEUt5qVf5HwSfogn6jrB9Zk9w5HHWkrRKryHwscYPOpcm3Tw0l1zxVd6Uqc9CqECJj
	 7MlTjrVpF/Tqw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	dlemoal@kernel.org
Subject: [PATCH 2/4] xfs: move zoned dio ioend to its own function
Date: Tue, 10 Mar 2026 12:55:05 +0100
Message-ID: <20260310115555.114197-3-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260310115555.114197-1-cem@kernel.org>
References: <20260310115555.114197-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

All zoned dio needs during endio is set the file size, so move it
out of the generic function.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_file.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 45ecd743fa32..29b02673111b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -595,6 +595,36 @@ xfs_dio_endio_set_isize(
 	return xfs_setfilesize(ip, offset, size);
 }
 
+static int
+xfs_zoned_dio_write_end_io(
+	struct kiocb		*iocb,
+	ssize_t			size,
+	int			error,
+	unsigned		flags)
+{
+	struct inode		*inode = file_inode(iocb->ki_filp);
+	struct xfs_inode	*ip = XFS_I(inode);
+	unsigned int		nofs_flag;
+
+	ASSERT(!(flags & (IOMAP_DIO_UNWRITTEN | IOMAP_DIO_COW)));
+
+	trace_xfs_end_io_direct_write(ip, iocb->ki_pos, size);
+
+	if (xfs_is_shutdown(ip->i_mount))
+		return -EIO;
+
+	if (error || !size)
+		return error;
+
+	XFS_STATS_ADD(ip->i_mount, xs_write_bytes, size);
+
+	nofs_flag = memalloc_nofs_save();
+	error = xfs_dio_endio_set_isize(inode, iocb->ki_pos, size);
+	memalloc_nofs_restore(nofs_flag);
+
+	return error;
+}
+
 static int
 xfs_dio_write_end_io(
 	struct kiocb		*iocb,
@@ -607,8 +637,7 @@ xfs_dio_write_end_io(
 	loff_t			offset = iocb->ki_pos;
 	unsigned int		nofs_flag;
 
-	ASSERT(!xfs_is_zoned_inode(ip) ||
-	       !(flags & (IOMAP_DIO_UNWRITTEN | IOMAP_DIO_COW)));
+	ASSERT(!xfs_is_zoned_inode(ip));
 
 	trace_xfs_end_io_direct_write(ip, offset, size);
 
@@ -701,7 +730,7 @@ xfs_dio_zoned_submit_io(
 static const struct iomap_dio_ops xfs_dio_zoned_write_ops = {
 	.bio_set	= &iomap_ioend_bioset,
 	.submit_io	= xfs_dio_zoned_submit_io,
-	.end_io		= xfs_dio_write_end_io,
+	.end_io		= xfs_zoned_dio_write_end_io,
 };
 
 /*
-- 
2.53.0

