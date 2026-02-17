Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B59A29D297;
	Tue, 17 Feb 2026 23:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771370468; cv=none; b=HrYaOkbNLA/+zy5HEKDyZQfzoEpbZtkDS3B6p9KJiKaypbZ0SVjPLtg0Z07+RjJaysH9H1gqgFgVMCkgJBCu1J5AhbhVA9awd4q7+iQdxZ3DxSR96+F2DnAkIaQ3U5N63DVag4Td8W8sEGExnBU4gsIbzP2EiIUQxwpX3q6uBWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771370468; c=relaxed/simple;
	bh=aSLaNPYsr/dHbB+8XZkm8B1IZRehJsO3fo5rjrKLOr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puX0Q3EbJLUcx0V+iqL22zuYZwQBneFjwV0GU8CYJwnrr37wQBGF9CnedQOV5mVF3LVc0puocKYGiOYWGnQF7ERmc02FJOOWPF1qt2bkvaZ62rHNudyVICM0UqFHOgRQn6TxzlKE5ybeypgmr0GJE/Z9GAMzrzDbyAAo8esm9m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ltLdyD8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ltLdyD8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056A1C4CEF7;
	Tue, 17 Feb 2026 23:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771370467;
	bh=aSLaNPYsr/dHbB+8XZkm8B1IZRehJsO3fo5rjrKLOr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltLdyD8Yp6GJnEPDYNEDuicTX7DuGgStUNHMSXOrKbdWtWVaU2J4xoK6vOE7ExbYA
	 PpziNXtQlO24D771AfM1w2qs7Hc+soCDuZRhmabh/5VBZ6PksM4KBG80yTrQRft9jW
	 bPEgEazLsEmglW5CkALzNmX+Ug7Sc39E3P4wbo8ghAPIpsKq3+8bWWTG+WdY2BJjju
	 7W+QcSaBe7MJrscSiCYfWFrjGsd5lpbCT0CRT3pZ2eIrxWdZ8nQNqBS27NmS0fS8k8
	 g8MJU7/gQGowJJLBXgWbXlbGJQUMsdpBJQ2ZQNFWPJuff3fWB8r0z0ysbsK/+owaMQ
	 qBuwQpVTIcNvQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	djwong@kernel.org
Subject: [PATCH v3 16/35] xfs: initialize fs-verity on file open
Date: Wed, 18 Feb 2026 00:19:16 +0100
Message-ID: <20260217231937.1183679-17-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260217231937.1183679-1-aalbersh@kernel.org>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f6cc63dcf961..693d298ac388 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -36,6 +36,7 @@
 #include <linux/mman.h>
 #include <linux/fadvise.h>
 #include <linux/mount.h>
+#include <linux/fsverity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -1639,11 +1640,18 @@ xfs_file_open(
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

