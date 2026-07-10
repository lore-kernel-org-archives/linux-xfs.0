Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315113A543A;
	Fri, 10 Jul 2026 08:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673630; cv=none; b=Zu6fPZ0r3NBRAg6yk9IDZ5Nm8Q2pAzo/GnUeUltxVKnMvbHIxujGUqX4qFv9WYHym/SLe1AbO+nHbblFPYHO5LqjrB3+mx24V3p8iW2pGkWwI/Ukqnvn13isKUTEcYfSD4qFsX8LUyIG32YIWzZglxdYZ5dysaXMLtj4G5F/2G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673630; c=relaxed/simple;
	bh=kDUo/vxOZKov+cFEjV8SXXy7yNW2OFVMzguHP7TLQqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQzccIPSbSLZ3TNT8zf2e+8+BSmqCcYziny13UJi81ET76MBzyvW+CFaZZpU2jnYW90NB1UmL9txKquLfB12v9C/lvoiwabp5qQRlLs2dStLdjcpuwEWA1mD/xsrig/SJMTjSAhATPFAOvRCiOC4X2DHT4rMTcsM/gOzHXFBK+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QvCGBaRk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QvCGBaRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1190F1F00A3A;
	Fri, 10 Jul 2026 08:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783673628;
	bh=EuVZQdKpD6wWTod+s5OV2gKgFo++vov/5xhrOV1O3Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QvCGBaRkVXPf2wYBo5OdXJeKMFQsq5zzgt/fCJ/VyPUx/zgiQKeBGsOoyoF9XvH6S
	 NMALpbyHy6w1WaW21WfkUgwOGCz31/FuNu88dl6/4ELckwPSsl+SRD0qsEDdlnzwtv
	 pHrfdqsDinlyizVkjR85S04GBczWc2ZGRVUgmIPU9hr8zldkKydc23ZVMlpwZ1Fn7P
	 lY/BAeIn5tW3mNyQjNUsLUysT570cPZb/HMYhgPihrLYP80Qjb60Z6exQdGmRgWvWO
	 UvaZ8CKSQqCyYNxEuI2LUnXFKbbrmSWFCNearvGXAneng15BRvtIY6o47dljMeCtbh
	 sChXNqls8NAHg==
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
Subject: [PATCH v11 08/20] xfs: initialize fs-verity on file open
Date: Fri, 10 Jul 2026 10:52:36 +0200
Message-ID: <20260710085256.3464201-9-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710085256.3464201-1-aalbersh@kernel.org>
References: <20260710085256.3464201-1-aalbersh@kernel.org>
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
2.54.0

