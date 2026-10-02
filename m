Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954FF471424;
	Fri,  2 Oct 2026 22:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980704; cv=none; b=HPs5tLyjrBr1UIdfXs69LFPATbNjheQsBZeDJeA5MQSGGsTEtvXXxHsVYsp8g8+XrvdmkRZzLYauD2vIONCLZRnJWQaZiszdEGbpYncNgiM0HTK/2BqnpMIDSPGnuOjPmfM87g6vee8X17PzwfCikDqHDDZFFZEmJVKhwcvG3GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980704; c=relaxed/simple;
	bh=WQtT0toHGKRuk8a9l6hkMm6Nr4k4/dhUSkNv4uiBiGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPjXBFrcwl52yCTGsMxh0LmKIujmOOOXo6HTloA5lpOBXgdI5KDuzAy+v5nDW133aBJnuqh1Ys+sAh0fpBTq9qBb4FeXohgC9hRMTq9wTm6YdQ6Eljbka3cz1ehHGzTDodxI23O+7FDDvJ+61PujQav9NxKAFNHOYi8CQwHlh48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aZHEndfy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aZHEndfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503FA1F000FF;
	Fri,  2 Oct 2026 22:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790980703;
	bh=mScGgc1mNGHzg+HyC079sL+o0xTAcTNL6WYWLAzFG/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZHEndfyMSwq1kZNQPhF1XTzmZZGMGpf/8t9zJXzVkQxP/Xy+XYwS39+6XZXc7n5S
	 mlMpppAhAy6789X35pYfbAXfl5qF86+p1FD66IcdvjV48sg3vaIQjDda04ZvZCstA/
	 39nhjnnIy7zOFxrrMZwpsvA/V3gR53kAab1qNlKaNTAOo6okyF0dibDBecoE98X5XJ
	 cu861MS75j2HdLo/NYha4fO8Vz9S/o7JCVxoI4ohQpeKX+FTI9M4cAgoRa38rZEnsU
	 SPz7UQAirdj2/aD9+DqvcnMzoq9nqoyYh5AEGYYM9lsaf1qY6m8S5jYHRY+eGgPaVf
	 Fz+XmVextTA2w==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v17 20/21] xfs: introduce health state for corrupted fsverity metadata
Date: Sat,  3 Oct 2026 00:37:01 +0200
Message-ID: <20261002223705.2175542-21-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261002223705.2175542-1-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
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
 fs/xfs/xfs_fsverity.c      | 25 +++++++++++++++++++------
 fs/xfs/xfs_health.c        |  1 +
 4 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index c80133784419..84d62b7506a9 100644
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
index 8cffcafc19aa..7174b36c8cd3 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -96,13 +96,17 @@ xfs_fsverity_get_descriptor(
 	if (error)
 		return error;
 
-	if (is_empty)
+	if (is_empty) {
+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
 		return -ENODATA;
+	}
 
 	last_block_offset =
 		XFS_FSB_TO_B(mp, rec.br_startoff + rec.br_blockcount);
-	if (last_block_offset <= xfs_fsverity_metadata_offset(ip))
+	if (last_block_offset <= xfs_fsverity_metadata_offset(ip)) {
+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
 		return -ENODATA;
+	}
 
 	desc_size_pos = last_block_offset - sizeof(__be32);
 	error = fsverity_pagecache_read(inode, (char *)&d_desc_size,
@@ -111,20 +115,29 @@ xfs_fsverity_get_descriptor(
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
-	if (desc_pos < xfs_fsverity_metadata_offset(ip))
+	if (desc_pos < xfs_fsverity_metadata_offset(ip)) {
+		xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_FSVERITY);
 		return -ERANGE;
+	}
 
 	error = fsverity_pagecache_read(inode, buf, desc_size, desc_pos);
 	if (error)
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
2.54.0

