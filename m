Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46DB3D648A;
	Tue, 28 Apr 2026 08:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365298; cv=none; b=g9OJ4Ltv6ZJLmaYxToJm5M5ok1K50qJn88OJeNcVUEyhAri2bjt+98ofBmFRPqJbBpZMwY7zpXBLIR/0c9LrJJ9aA/xLBn9AF4fVD8iDFgTzINbBWV2/vdQsfMTh+Gw2+FLbj0db9fIfyJ1q6pS5vlX5tfSvFcN9tR8KrUK6gn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365298; c=relaxed/simple;
	bh=JXHTSbqvbrxVG3d7HPfzTq0FVlIRscym93k2ZVkiAFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOrPPLE/f6/7IpC18/3ui78OSq7TQpFaFWfl2XhFdVSxtBAb7wGxajO+bL5x2q9+D9u/kKtQQEsZCyvpVonWQIwHfbNsCwSGLaYaQiXUjIehc2fs97AtDgOP+RBPRjqO/K5RIxdNopSms8cG91oCHIXDfh+0XaEpIGrAn/1wTbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hNJaJCKT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hNJaJCKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50984C2BCB6;
	Tue, 28 Apr 2026 08:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777365297;
	bh=JXHTSbqvbrxVG3d7HPfzTq0FVlIRscym93k2ZVkiAFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNJaJCKTYIXQdqZyyO8JvaQuYr2jeCmFp2z9M3tgEnh46MJGQRDZ4LeTprSIMeicL
	 HCnqZnUt4V0QooRbaV9TmI23k47UVck44ean3PDncrm8OyL+4JTMZuyamCREcPQQJW
	 a+ln/AXVHA0DY5c/p3HTdgfpbLwJptu0R5711J8wd4no53+naB/tytLIYWHrJbeYu4
	 A1iRQkR+ICeEGo6tWDyMsbzRP3ZaR9yLdEINzUuYG/Z7/t9g/LT8y766BLOngS4ZCh
	 gUwxLkbT5N4lADekOYr+WwH4GzECOGaGViVAOAcenjUlb/BpBtNc7c3cIjrlVLe9EN
	 AvJIPoYrmLuhg==
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
Subject: [PATCH v9 21/22] xfs: introduce health state for corrupted fsverity metadata
Date: Tue, 28 Apr 2026 10:33:27 +0200
Message-ID: <20260428083332.768693-22-aalbersh@kernel.org>
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

Report corrupted fsverity descriptor through health system.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h     |  1 +
 fs/xfs/libxfs/xfs_health.h |  4 +++-
 fs/xfs/xfs_fsverity.c      | 13 ++++++++++---
 fs/xfs/xfs_health.c        |  1 +
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index ebf17a0b0722..cece31ecee81 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -422,6 +422,7 @@ struct xfs_bulkstat {
 #define XFS_BS_SICK_SYMLINK	(1 << 6)  /* symbolic link remote target */
 #define XFS_BS_SICK_PARENT	(1 << 7)  /* parent pointers */
 #define XFS_BS_SICK_DIRTREE	(1 << 8)  /* directory tree structure */
+#define XFS_BS_SICK_FSVERITY	(1 << 9)  /* fsverity metadata */
 
 /*
  * Project quota id helpers (previously projid was 16bit only
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 1d45cf5789e8..932b447190da 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -104,6 +104,7 @@ struct xfs_rtgroup;
 /* Don't propagate sick status to ag health summary during inactivation */
 #define XFS_SICK_INO_FORGET	(1 << 12)
 #define XFS_SICK_INO_DIRTREE	(1 << 13)  /* directory tree structure */
+#define XFS_SICK_INO_FSVERITY	(1 << 14)  /* fsverity metadata */
 
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
@@ -140,7 +141,8 @@ struct xfs_rtgroup;
 				 XFS_SICK_INO_XATTR | \
 				 XFS_SICK_INO_SYMLINK | \
 				 XFS_SICK_INO_PARENT | \
-				 XFS_SICK_INO_DIRTREE)
+				 XFS_SICK_INO_DIRTREE | \
+				 XFS_SICK_INO_FSVERITY)
 
 #define XFS_SICK_INO_ZAPPED	(XFS_SICK_INO_BMBTD_ZAPPED | \
 				 XFS_SICK_INO_BMBTA_ZAPPED | \
diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index 298d712b5ba2..82f5ca542c97 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -84,16 +84,23 @@ xfs_fsverity_get_descriptor(
 		return error;
 
 	desc_size = be32_to_cpu(d_desc_size);
-	if (XFS_IS_CORRUPT(mp, desc_size > FS_VERITY_MAX_DESCRIPTOR_SIZE))
+	if (XFS_IS_CORRUPT(mp, desc_size > FS_VERITY_MAX_DESCRIPTOR_SIZE)) {
+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
 		return -ERANGE;
-	if (XFS_IS_CORRUPT(mp, desc_size > desc_size_pos))
+	}
+
+	if (XFS_IS_CORRUPT(mp, desc_size > desc_size_pos)) {
+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
 		return -ERANGE;
+	}
 
 	if (!buf_size)
 		return desc_size;
 
-	if (XFS_IS_CORRUPT(mp, desc_size > buf_size))
+	if (XFS_IS_CORRUPT(mp, desc_size > buf_size)) {
+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
 		return -ERANGE;
+	}
 
 	desc_pos = round_down(desc_size_pos - desc_size, blocksize);
 	error = fsverity_pagecache_read(inode, buf, desc_size, desc_pos);
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 239b843e83d4..be66760fb120 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -625,6 +625,7 @@ static const struct ioctl_sick_map ino_map[] = {
 	{ XFS_SICK_INO_DIR_ZAPPED,	XFS_BS_SICK_DIR },
 	{ XFS_SICK_INO_SYMLINK_ZAPPED,	XFS_BS_SICK_SYMLINK },
 	{ XFS_SICK_INO_DIRTREE,	XFS_BS_SICK_DIRTREE },
+	{ XFS_SICK_INO_FSVERITY,	XFS_BS_SICK_FSVERITY },
 };
 
 /* Fill out bulkstat health info. */
-- 
2.51.2

