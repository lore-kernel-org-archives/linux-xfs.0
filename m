Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAD03D4117;
	Tue, 28 Apr 2026 08:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365274; cv=none; b=fj7vFdlrIEkGvVl9zwuB2t6M1aP2P0mHHBzQ/DJrm2Dm7fDndNNY9Kzr0RFzP/UhRwwaKjoywhAZp+7iJjw81daAp8rMvk2yBhaR5PGp8tDjsySCjtugiyLpQOpHdCrfSBEPgeGPpZq32Jm5P41hOUrcKGe+cE/NYFsKtQhGowk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365274; c=relaxed/simple;
	bh=l2TuE4Dq3W00QnGqh26ac7WtX/eqBCa3lcQ4ZM8TF1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQz739AF6Cmgjzbk6L0Tu7gzWv7S4iCyCS2bpCH+5xw3dFCionsyDYMgMQfZLeo5Doxm43SqLfqgqomArTkexc37BEM8u8FhdFvBuaykUGCJx3k6daHK8zHpbJuwGAJWN5CGb7LRSbZnFt9GR2dg9YRJY1l3b0p/HELzxIbZCkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YMwK2SQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YMwK2SQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698DBC2BCB9;
	Tue, 28 Apr 2026 08:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777365273;
	bh=l2TuE4Dq3W00QnGqh26ac7WtX/eqBCa3lcQ4ZM8TF1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMwK2SQ6PuOpeyfRJw58qAZtdcj0ld0MHefAaomuol/byqLyagL8z2OnXDvQ88nAe
	 VgRYaBrpWNw1GDwBgpJwJbzz5QlIvIOrqAQ/sImd1mHsAgk746ujTCQXHlQjobP+vx
	 SsOQ0JJbSqzH4c8wvITLmHPprh8vM1hkgcB5xq3xiWP+w0+nW0xBCtrHNAkKWMYzq/
	 gw5oVMGNE0A0oDI3340xvs7oK+Tm4CFF/nXxbKYLxiXEmxy8W/rd7LUfGxguEiY3Dk
	 GH5DA2auZZ1xuXTWyzvLOeKNPYCGHxmijpda4QWfmRKPrzcwgD93RSLUFbmq6+zFiP
	 D7KVqTgTWS6Ug==
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
	linux-unionfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v9 13/22] xfs: disable direct read path for fs-verity files
Date: Tue, 28 Apr 2026 10:33:19 +0200
Message-ID: <20260428083332.768693-14-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260428083332.768693-1-aalbersh@kernel.org>
References: <20260428083332.768693-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The direct path is not supported on verity files. Attempts to use direct
I/O path on such files should fall back to buffered I/O path.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a980ac5196a8..6fa9835f9531 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -282,7 +282,8 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -333,6 +334,14 @@ xfs_file_read_iter(
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
2.51.2

