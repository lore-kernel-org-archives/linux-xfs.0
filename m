Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4AE3D25CC;
	Mon, 20 Jul 2026 09:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538343; cv=none; b=eHazbZoFWsZs1xx6l6rDaXgkuU+wDm30iF3YkYMBFive9uemlecYmimZa868gF3LjPE0Rwk7emRYYl4H/I9bxFphLI2JSXxAKBefaJP4JWUp/FDvohjMwFVz414i3S/W6HtUxCWJBcTZzx6kwmKHDFyfrachZZWPr/+Ii5UewbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538343; c=relaxed/simple;
	bh=dy4Edc29BpzzxgPr3/G78KApna/3QhJs5nn2dTWPf8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fy/Qe6zzfZVVQdqeYqZs2Kh52m+DBPdVXTihhGKCEsJkqVKFqJ2xEZ1kACg6BiZIIdGVunAXqCX+Yo9vc1/2MOTf0S+040i8xzSYziJc4OINpzRb+TcdfFquSjY+kRdAD0ZPfiztUENaW1/xvIvSQ0dQ3hPsyvHhbm5L5yd7yRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i5QOQBy4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i5QOQBy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8114D1F000E9;
	Mon, 20 Jul 2026 09:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784538341;
	bh=9QTcR6aLgUEtsJ2fn2Z4p7S4tu82w8VjwhNOU+8/DXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5QOQBy4bo4w3OKQlYJKwiK5yblyNYd9hqNIPmFxRcDXI0zhxBVBkh/jL4k2Btl2j
	 nKQd7+z+JHbGwm0Mw5PH0CmbIgihBzCAzm1IJA7p+N6kdqDYH3L5QNy0rSP/am02N7
	 QD29x7ijzv4Yw3FwLzfmFnLGEJntA+50sEFiRpnSZUOMVYrifimVsemdtHKc02NkGr
	 JkhPOcDUHBFPjxUdXv2tU5XsUjUt+jbSEKxkYcRnOVEBU0LPQRK8hpsfQ26xs2HMNc
	 8qwFzXB0VLVMP711qB4BWjk1n5P1H3sQWainbeiSNaKRpWgFFzeYi1aOrNHRSqd6MQ
	 G68iEEcrpgxwQ==
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
Subject: [PATCH v12 16/21] xfs: initialize fs-verity on file open
Date: Mon, 20 Jul 2026 11:03:44 +0200
Message-ID: <20260720090410.3487990-17-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720090410.3487990-1-aalbersh@kernel.org>
References: <20260720090410.3487990-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fs-verity will read and attach metadata (not the tree itself) from
a disk for those inodes which already have fs-verity enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_file.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f7e3fe22ca96..cba194d678fc 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -37,6 +37,7 @@
 #include <linux/fadvise.h>
 #include <linux/mount.h>
 #include <linux/filelock.h>
+#include <linux/fsverity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -1719,11 +1720,18 @@ xfs_file_open(
 	struct inode	*inode,
 	struct file	*file)
 {
+	int		error;
+
 	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
 		return -EIO;
 	file->f_mode |= FMODE_NOWAIT | FMODE_CAN_ODIRECT;
 	if (xfs_get_atomic_write_min(XFS_I(inode)) > 0)
 		file->f_mode |= FMODE_CAN_ATOMIC_WRITE;
+
+	error = fsverity_file_open(inode, file);
+	if (error)
+		return error;
+
 	return generic_file_open(inode, file);
 }
 
-- 
2.54.0

