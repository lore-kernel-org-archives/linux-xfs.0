Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB9C370D55;
	Tue, 28 Apr 2026 08:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365268; cv=none; b=tH3SQaEcbjySOg1BrPdq8jwWrLkS8EZCRw4X1o0qiL3lnUK2qnjARnEvZFvJRWkrcZViaYqJItUmFzR4BKc19cbiln/GW3yCuSyWu59+b/5wd4HPbHd6L4WU/1Ee9CvTQ17L3208OU+VrJZ37YmHjyn4RPdVL+Qt/GP71rx7uiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365268; c=relaxed/simple;
	bh=gjzi4j4Cju/ktgfw/m2kII6LXPtWjZKRFOLxEgok6kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxOMV3aYN/E0vM6jtlVEku7avVkfKmUZqUvhPZylq1Geo2tP/pxkAAUE5Gwbu3c1eeorkHsOm3ESE4TMy5big+anDno4iv5CraBz+OfsSCSsQGkeEsJJcMZGi+xKSD/24CnRpoNbMk5uxLZk76nHTUzSV7+GIaybbM0MQbQFlTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kQQqgaq/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kQQqgaq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC14C2BCB8;
	Tue, 28 Apr 2026 08:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777365268;
	bh=gjzi4j4Cju/ktgfw/m2kII6LXPtWjZKRFOLxEgok6kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQQqgaq/AiAAz4xNYUvTUtSy9hWe/wYbd5ZoX6p5fHwXs0IWI8zD+qF4KmbF/b5xC
	 kPCjbhwETRlN2ZP6hes2WErZirCek9tosw7ZVLznp0uZHK+RwOpiC34X6hXBV1K5lf
	 VEnBxN9zTv+6OAMDwjGbNz0Lu/tDUjroJfjY+gdq3bvtaJDtNtyTzDWA0eENcDgyay
	 dryRImn5gvnmhPf9z6d2MhvigjJ3NKG2SOPvk4TjbJiDZV1F69JgtoH1MT00DLD5vo
	 b74FJlpQUjo1boN6LF9fHc1yCY+6tQKcY6Ztx5snHyDe26cxmso2AVUYV7gMZ0qO5J
	 YTxaXNcufWxhw==
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
Subject: [PATCH v9 11/22] xfs: initialize fs-verity on file open
Date: Tue, 28 Apr 2026 10:33:17 +0200
Message-ID: <20260428083332.768693-12-aalbersh@kernel.org>
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

fs-verity will read and attach metadata (not the tree itself) from
a disk for those inodes which already have fs-verity enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
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

