Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D7745106D;
	Tue, 31 Mar 2026 21:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774992545; cv=none; b=I4r4zHaofEDU1BQ1/vW/9yLPKYnMz1WTgFLwwGozM/20t2sxSb9xiElVFUFJyZnL28cU79Q1btfyRFyAep8GGZqZ4ON5EysohCmRIhOv6BvwRvOiShW3iKflT94BSfH/WEKKnB+ocOlbTbJX+3Vmy4V/Fd0CNIWmNb1XA67+XNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774992545; c=relaxed/simple;
	bh=gjzi4j4Cju/ktgfw/m2kII6LXPtWjZKRFOLxEgok6kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEK7wOr9x2kmjfyh6xu/JPK5ifjfgfxZZ84jqXsuDNWHXB5/E3oqoHTN8scVPR3hHm6W7fFCNi/bJbGm+VSwGmX3IHXuV30gH2kwlj4OVx9uhKgwNGlRZpP7Y0/YIrnxN4WyYYiHRtDVbD4e3enw3WIae1kq8zzUe30FSf6c+rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QTw+M6nh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QTw+M6nh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE5DC19423;
	Tue, 31 Mar 2026 21:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774992545;
	bh=gjzi4j4Cju/ktgfw/m2kII6LXPtWjZKRFOLxEgok6kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTw+M6nhWB3vooD1fcAu4VAynFJKvX/lcxMtlPgAYuA1ubd7rp2fErvuNVkpkoGBZ
	 rN9Vgk7D01EITyvtAGWBSoavsR5jS/klg6FTpXuuWAwKWFxaK5RoayrjBeu7NeMLNE
	 62A81u4f+vN3xi0ZgQhJPzctyuK8sqp5gAvqsFWYTa1i2YVZ2na/K0kTp0rV4PR4JO
	 rGWbX9MMxVEuwulsF8nL6WQRQfq2//xU1y7HLpXoQEYddWdGDZvkIrsiKFVF5DKcSL
	 lKlE+oRLSj329Nzit5pPfTrTwVXC9OQN7S3aJy4Or3LHGF4PsptB2pnA4CKiR4c0XG
	 /86rt0FwuCcDg==
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
Subject: [PATCH v6 10/22] xfs: initialize fs-verity on file open
Date: Tue, 31 Mar 2026 23:28:11 +0200
Message-ID: <20260331212827.2631020-11-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260331212827.2631020-1-aalbersh@kernel.org>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
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

