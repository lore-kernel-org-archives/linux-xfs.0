Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E343E63AC;
	Wed, 20 May 2026 12:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779280676; cv=none; b=Fl0+y+QKBc+0Fi8cEg8ngm5kH9HH/1C9SRyCVMELxpwYRv1I/lGVsbHeElqwnZCibn5w0/W+nouNeYZvYr1Mfzdugok0N1lflkUwW9W0pXuQ3ll2w/Hqr3BUDT7AzgxbD/R5WpcPEqcWfRth9aHXCPjOy8yPTRwp21E40yFKU10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779280676; c=relaxed/simple;
	bh=Xwc/mSUOzY/SmBUARJA9roLn2GRyO6d/A0YYUkM7h/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHOmutB5AIGs+d8HHwhGqTfOIl1NaEN0bJcAXH3+7Pn7JlNihIvAA5V4UWCinlEH/rWT4W/ifngh+pMXhvPQBVAuTguvgxo+7xlHKMF3kk8Y/1eW/Wb/B2O5JqmrbprSXNpBhVMeK2yFEjc9njs3EyPstiCwwSA+oTOKW2lD/6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kpYxJYjR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kpYxJYjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4341F000E9;
	Wed, 20 May 2026 12:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779280675;
	bh=Gmm/Ji1RHhaSPceVQfaTAAUkaYHkDKfuhVH2to82VPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpYxJYjRk5/+MEaUS8enTXHARxLnY/AfiiHQ0jcV+X0auH56ze47nTKqVDX3eGBzl
	 xHtK0JcZ1xuoC66vJWHOLfiZYk9DZNw4KdQXi6LfBSeg4mg4HEZ8lZ2ykZ4pv6292J
	 61ibHMo72HTxhQFOe4cLkqJpDNAhBWgPPDxz/Q3H2oRW2X4vALBflKXqBOfLpFfxnS
	 cKOVIT3XrRcyZfAPsVa6coZY9mCDt9u1GmxCQGRNuojQn8khA617kseH2NtQoVLBvM
	 bLUW9cruvYFz71WJ6PDtuJNIlivk1nApGr1a7tr4P3q1IMu7Lye46MFdr+XiOErIuy
	 jKGc+8vuceQ0Q==
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
Subject: [PATCH v10 11/22] xfs: initialize fs-verity on file open
Date: Wed, 20 May 2026 14:37:09 +0200
Message-ID: <20260520123722.405752-12-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260520123722.405752-1-aalbersh@kernel.org>
References: <20260520123722.405752-1-aalbersh@kernel.org>
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
index 845a97c9b063..e3f4353b3b78 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -37,6 +37,7 @@
 #include <linux/fadvise.h>
 #include <linux/mount.h>
 #include <linux/filelock.h>
+#include <linux/fsverity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -1700,11 +1701,18 @@ xfs_file_open(
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

