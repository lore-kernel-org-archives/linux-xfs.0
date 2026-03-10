Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E173D47BA
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 17:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773164388; cv=none; b=H2dMHEKJjhvxJR1M1dTHNDJfBlHEHG8tmoXfA3vOOX3uMHiCqpsUcdrnuroJZx64cKcwpNHUrVfNl5MBrg9mZYpFqSvJ7G8RU9QQ9NLoeNiVyUB+92vJronfiNKvxXmq46q12Efv/7HeexDBzjmmFJq6xTM/h7vh132UPS17mkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773164388; c=relaxed/simple;
	bh=yxNwTryMkaIA9jwM9Q9kv1kshtPcUu3GOo7+2KmKQuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpThSCqZKT4oQM7ztaA3eOeflA5DSRm+4IUU9aMGSCLU2qD0zd5KefDonM/DOIA+XkyLoZ8FFhSdQDE1IoZpC8N/gdoAjX9VP2G0Mv22w9mJ0rsFCg0B8SvWbM8vQTyFsxiJ3EnvSZ1p4zHEoCAIrSB0VkEtRJMM6mRfRTmJoqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M900mfD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M900mfD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B27C19423;
	Tue, 10 Mar 2026 17:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773164388;
	bh=yxNwTryMkaIA9jwM9Q9kv1kshtPcUu3GOo7+2KmKQuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M900mfD30wix7Kb8savVWyGU5OpEIQu0bevv/vtZYY3wAPsLsko/xDPRzG3XOl5TR
	 xX4Uk83I1kyvZZqoLgh8VjDQ0QTaDGJZd6qUEF/WxwUpoF/dGS8q8Cx8gGfZTLoFgO
	 TEF5wPxJ/jZAEqcwqTKzXMWo4YU3uIlKDn50fUWDu+OKmwDyPhRVXRciA5UnSjuZzA
	 2di9r3fiy1tprDV0qQRBbKn2wbVp/tvCE/QnKpQantTBGToL444fsC+gRQcUFcwbom
	 wERhsm3lvt9wV2Ah+iKaKDTfidAx4IK69w+SJCMOxmGsgSyRRq8JxZPlGqO4zLUWMY
	 MvChpCcAc4+4w==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	dlemoal@kernel.org
Subject: [PATCH v2 2/4] xfs: factor out xfs_dio_write_zoned_end_io
Date: Tue, 10 Mar 2026 18:36:47 +0100
Message-ID: <20260310173709.457047-3-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260310173709.457047-1-cem@kernel.org>
References: <20260310173709.457047-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Stop sharing direct IO end_io between regular and zoned devices
by factoring out zoned dio end_io to its own function.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>

---
v2: Rewrite commit description - no code change

 fs/xfs/xfs_file.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index fce6be55d90c..7918968e1d62 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -596,6 +596,36 @@ xfs_dio_endio_set_isize(
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
@@ -608,8 +638,7 @@ xfs_dio_write_end_io(
 	loff_t			offset = iocb->ki_pos;
 	unsigned int		nofs_flag;
 
-	ASSERT(!xfs_is_zoned_inode(ip) ||
-	       !(flags & (IOMAP_DIO_UNWRITTEN | IOMAP_DIO_COW)));
+	ASSERT(!xfs_is_zoned_inode(ip));
 
 	trace_xfs_end_io_direct_write(ip, offset, size);
 
@@ -702,7 +731,7 @@ xfs_dio_zoned_submit_io(
 static const struct iomap_dio_ops xfs_dio_zoned_write_ops = {
 	.bio_set	= &iomap_ioend_bioset,
 	.submit_io	= xfs_dio_zoned_submit_io,
-	.end_io		= xfs_dio_write_end_io,
+	.end_io		= xfs_zoned_dio_write_end_io,
 };
 
 /*
-- 
2.53.0

