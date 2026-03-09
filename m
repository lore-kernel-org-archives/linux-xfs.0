Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC532364E82;
	Mon,  9 Mar 2026 19:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084321; cv=none; b=lypheq07niMofRhHVIrV3dMWkM2zZ/IL3Akj55YXyJQdAV9+sb0DcIyxqrI0d8ftohDETHmwUfKndka1Ppw4Ktj60r3FMd7ZbxZUDQpmgsKtgKgAen6MrZvJauyHH4JJ8Wus+0ADaifJGI4rkPTeEZhC0ul+OTIqdzFIKec+D1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084321; c=relaxed/simple;
	bh=yMnEK6AxJtjDqdBedC51f5E00TG7FWRBCbUNxKYwYD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAVs1h2sLiOWbCp/6QuiTUw20syEqI6jt7g1U4t6D0N0rcK8Z1ao2LjvzaPTkzV1tmL9by6NMjgUw7Nh6NTB+WlA2EJp6FJ5WsAus9l1YvvK/s65B7SyGb0qD3smlhj8R0neFY3g9dv0cToQEXVDhX5lQH/YyDW/rCzDbdt6VzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I3qplzQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I3qplzQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F5EC2BC9E;
	Mon,  9 Mar 2026 19:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773084321;
	bh=yMnEK6AxJtjDqdBedC51f5E00TG7FWRBCbUNxKYwYD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I3qplzQxeoM2aGq37V4SrYZgSIk4QpK5jrIfh53Kox9Rv/04OHstdakK8TCjefxaJ
	 jJkqsEfd1YEMJHM3IawCL8DkNupaQs8rfgi7lMUxV3g3R/jwWqqyaZNCq0JERWx5Jx
	 4axIiHjvXqsRWCqhVeFmv+mR9jypNP83Mjod9UnygLb7cVcLehJQPqPfnxVpdLsjH7
	 4B0VQyIDW3DvCMQWUnaXYP34JSDNPK4X1bzD+LKIenfbC4jwJL0Ag6dM5TR9GWul7Z
	 PnHv2s0un7WBn2dX6oq40+X8SMR7xfzLllW4vMhivYcEXgNlavRTimX3cafnBLdnxx
	 QHal2BWbVIROA==
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
Subject: [PATCH v4 23/25] xfs: introduce health state for corrupted fsverity metadata
Date: Mon,  9 Mar 2026 20:23:38 +0100
Message-ID: <20260309192355.176980-24-aalbersh@kernel.org>
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

Report corrupted fsverity descriptor through health system.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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
index f78e5f0c2fd0..adc53dad174b 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -99,16 +99,23 @@ xfs_fsverity_get_descriptor(
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
index 169123772cb3..4e6273ae9b10 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -609,6 +609,7 @@ static const struct ioctl_sick_map ino_map[] = {
 	{ XFS_SICK_INO_DIR_ZAPPED,	XFS_BS_SICK_DIR },
 	{ XFS_SICK_INO_SYMLINK_ZAPPED,	XFS_BS_SICK_SYMLINK },
 	{ XFS_SICK_INO_DIRTREE,	XFS_BS_SICK_DIRTREE },
+	{ XFS_SICK_INO_FSVERITY,	XFS_BS_SICK_FSVERITY },
 };
 
 /* Fill out bulkstat health info. */
-- 
2.51.2

