Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4447746EF6D;
	Tue, 21 Jul 2026 18:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659489; cv=none; b=cq004UxIPcNsYgGRjbyn6MHoLtlqMbnnn92W1ehnlitf4/YJ4Mkz1wmZOL4zA2H+gBGRS6waHgpP68YjM7fqkhFpBdyiPGhypY1xi7xJKPeete4RcjFXtEYTrVw3lF7jd/YMgoeSXXzw9qZOtAYArpeEyE7ImRzNIsx3TAUSDGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659489; c=relaxed/simple;
	bh=dy4Edc29BpzzxgPr3/G78KApna/3QhJs5nn2dTWPf8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4GBvEjWOoPZyINh985skQOxN0RbZq72nLxEcG2JYsNccJa7WrMCSy756P05GNHiwIdSj8BdA/t8/7srzs1XBnxmKUvzMuq+4jCcxX3NLDsUigu0nBqRsBChhn6EAWxnEXg42b5l81OyD2LPTao+43sh1wvzILhZ0HxvXFhiNGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GfNXUEeB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GfNXUEeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08291F000E9;
	Tue, 21 Jul 2026 18:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659488;
	bh=9QTcR6aLgUEtsJ2fn2Z4p7S4tu82w8VjwhNOU+8/DXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GfNXUEeB/wLF5RcE1h6XfuPwhyAxRp30JRgQuzfTpOOIt/YDoNZDyLtdueppx1NDQ
	 5OoODdku6w55fUJqrVgqIuWoepjjYSCXiUZr/zQKoAhEmEFAMQm3mMxXHD6m3oa26W
	 88CR4fF2CC/16dhJ6yd29NiK7I23o3c0cujNhxy4vakNZzqTOz2mo547jPLabo6N2q
	 htd9VEuGY+bzCd2jr6C4wyNY4HjJzbJ7ArhiMf43KADFQImKq/9p85NpGMd9SzUrkU
	 vYj3CMLUq9Yd4XLQV2pdk9glNwEPJ6ECC4ThTjWKwTRRphs4ke3u4Y3VRiSnVXNiEt
	 dHC2QGO0Ws4Kg==
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
Subject: [PATCH v13 18/23] xfs: initialize fs-verity on file open
Date: Tue, 21 Jul 2026 20:40:55 +0200
Message-ID: <20260721184346.416657-19-aalbersh@kernel.org>
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

