Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1063D8115;
	Thu,  9 Apr 2026 13:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775740483; cv=none; b=KLdflLkRVNh8os5DQwxJa5mkTjUTwzHNtF/8ulc+6elo56CqPvQJ3GJlaRrmOE8kZmRQUjVIfwatCEK3R15Kr5is9094T2UV3zv5g5pykQYJ7FDAqGP0rL8fFf3E25HqC5JRK9DhWYJkeuTn1cch1f0po41aAvCLQRVWov5p+Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775740483; c=relaxed/simple;
	bh=gjzi4j4Cju/ktgfw/m2kII6LXPtWjZKRFOLxEgok6kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cI7slTUwdqFbhB9Efmi7jy0Yn86EhRP2hYwdWbeajVT0XHodcpCzYP0Khrp8u/RWj6/LHnneyMbnMlu/0NRItNPTfayYHk2Ron1T/YwjGLwlaZ2mJ1gP5SUdqy1ALQOfPNz88rIoXNVbTez/Xj8bOILaw+kC5uPOK1fs12ROsP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aWc/n18W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aWc/n18W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3E5C4CEF7;
	Thu,  9 Apr 2026 13:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775740483;
	bh=gjzi4j4Cju/ktgfw/m2kII6LXPtWjZKRFOLxEgok6kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWc/n18W67MZy9r5fQx165Ihrot24Dhpq9cXDaGfokKJ87NrIFMH7+2ip/qXXZ+RP
	 /DDPl78ndyuE4pEcaP58ISr8+ACz71pdgmagSAIvF4jr+CijwklAcoyJPM2n4TqKrc
	 jvtPjbQw7o+JYKlQ5pobp2ZFC/jPcp6gDorWQiCTLdh4TPaTwfc9pHVRGP9WLihmoK
	 4NdZ5NUZuQCwVKQUqZfFoTqnICq31xtbsJzujyAMe5ysiRHTSVHzyVbFX6q6BywD9Z
	 Wy1xh1hFFeaO3NIK/qMkwE5RZCtUhCX4NfBb/HfphPQ3CPeEs+8Unrk1SnaI+1L0t1
	 fmaWdt+XyZyyQ==
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
Subject: [PATCH v7 11/22] xfs: initialize fs-verity on file open
Date: Thu,  9 Apr 2026 15:13:43 +0200
Message-ID: <20260409131404.1545834-12-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260409131404.1545834-1-aalbersh@kernel.org>
References: <20260409131404.1545834-1-aalbersh@kernel.org>
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

