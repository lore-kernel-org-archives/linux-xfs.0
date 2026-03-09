Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE383EDABB;
	Mon,  9 Mar 2026 19:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084294; cv=none; b=qI8/Z+IWh9XWHht2QM7plO0HEjj4jRxAskjdf4++xYWa03Op51RaCIusaQt3246wEFWLEMKdryPL3e5FP00f4iaFQHhWyaM/qOj7S/dJVQJw+Rg9hEoEy3Bv7cM8Ztwfo5u6T9rre2Wg+YltXVjfhWc/59/8Uice9NvP/ZrFdXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084294; c=relaxed/simple;
	bh=mPVHTe9Ab/5USFw8EX0zjFajZsuuSbaTg0zG8xac2aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lG8yGZhhnTAxJeRys/0oB65+QSeKquMrsl0X2gnWfbjNxlA3kp4C65RpAyDvl857z0jwM+sji9RD9bNbw3+AJmhMFnq9At9OaB+LJM6bR6QPyIeFtrcILG4/7dqvy3axdtGcjxvSDV4GsRroPdwhHU+anDGQiTwWeqmOFcEQn/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pqMQpCfN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pqMQpCfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC78C4CEF7;
	Mon,  9 Mar 2026 19:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773084294;
	bh=mPVHTe9Ab/5USFw8EX0zjFajZsuuSbaTg0zG8xac2aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqMQpCfNaVdvzzzpIP2DjrTS/ZYgyv17WBIAofC2mluK9x7PojwIAkcwUCDorbStG
	 cKDa4XcHWWlLpAppZsausDrJ7XzMgqvPwaUuIjM79XYywjNK32FAifnr0vp8nk4+2F
	 Nc63s20tWE1ALdyokpYpgrlR/VrWbPdFC3nChVeTttukJHoTeyp0gN6JpBrjJYfUSk
	 ZdCDvWwYdbzR9Dqo3QOqP1Oi7ZLOdOhSbGM5JG1SQTEabt4lnJwreVeeQqtbIw9y/c
	 hRULBLGqzjK5ig6Zb6b1Oy+9m9eyEjx8HgS3vlg5ajicMrAr/u138wDv5oG/D+QUpZ
	 Pc5W0BCuC8kcQ==
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
Subject: [PATCH v4 13/25] xfs: initialize fs-verity on file open
Date: Mon,  9 Mar 2026 20:23:28 +0100
Message-ID: <20260309192355.176980-14-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260309192355.176980-1-aalbersh@kernel.org>
References: <20260309192355.176980-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fs-verity will read and attach metadata (not the tree itself) from
a disk for those inodes which already have fs-verity enabled.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6246f34df9fd..a980ac5196a8 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -37,6 +37,7 @@
 #include <linux/fadvise.h>
 #include <linux/mount.h>
 #include <linux/filelock.h>
+#include <linux/fsverity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -1640,11 +1641,18 @@ xfs_file_open(
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
2.51.2

