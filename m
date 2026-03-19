Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6999C2BEC57;
	Thu, 19 Mar 2026 17:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939794; cv=none; b=af+XhLxxrJZvjGHQ8QHUH03iFPU1G9/HYoBY3lHDaJEqtk8pNHU7hFisbp8+//xXUfCHt2lMVDf8yxeTSC6PlLGBeU+g5VglgHpMw6IKWGJlzI4tx1UpQ5vq157BmpncuBlk2y4gZtBk+/DCKqw7azkgb6P5wpDkL1g9Reabgnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939794; c=relaxed/simple;
	bh=mPVHTe9Ab/5USFw8EX0zjFajZsuuSbaTg0zG8xac2aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPoQV4tUJnQWvYd7Ym+ZzqC/n2WjegHBTjPll6Pr15XGCwxOK2lyHLbDbq1/iHpfiZKOX6QlfO4HHI8mlcNQPIKjklLYXqNUa+YBIP7q3UxZIhlsDyMc5MPpJ/prCPlYKKIpPHcyFrGj7I1USfV8tHrAWx3Jb/quJjVjOSPjEc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gbsm3bOP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gbsm3bOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B11DC19425;
	Thu, 19 Mar 2026 17:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939794;
	bh=mPVHTe9Ab/5USFw8EX0zjFajZsuuSbaTg0zG8xac2aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gbsm3bOPTMYIsSmsJlgY7rkp3yJKsmpVgeMM6YFh5HmBhkJoxn6KUf1lapv9fBgDP
	 JIIO/2+F+NqloFX3i9xzto1AhtXIHmEUUawgxgQcmMzacWd0mkbxzTB/d8jkA/IbnZ
	 JGpY+c1Knjpqk4/91gaBLePlF4EwVKYoxGlEJSD//GRAU4U7xNSOFVQtR1e9z+014/
	 PnhV+i75t51uIWx448W4o09sxbTFUOfGZzBnPGDat9BDzwz+wT7MGtGJXRKlP3GHMw
	 RVCEc2z0gsVkKZ/XD+2+c6RyJNpK2rF7zwaXEUIgT8GlfIRS7vWsniO+g+0AgVf9Iu
	 DVtUF3QAKXQMQ==
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
Subject: [PATCH v5 13/25] xfs: initialize fs-verity on file open
Date: Thu, 19 Mar 2026 18:02:00 +0100
Message-ID: <20260319170231.1455553-14-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260319170231.1455553-1-aalbersh@kernel.org>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
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

