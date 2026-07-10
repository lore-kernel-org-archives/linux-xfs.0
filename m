Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266AF3F8715;
	Fri, 10 Jul 2026 08:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673662; cv=none; b=E8q1sIE0R67g/PmSFYc3YUCUBBbE37T8Ek0WAz0rw+oG3rggOjyoASOtoQBBL/ebZ4VxlT3w7kNJYz8DvMS61lBmPq3nagRZDw514cqM6oBIdK+eTa1NGkyzK6iRvafWfVMIVQqR6gOF4z/vQyy7AqOz8emKMwNZs8nkZkFNHfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673662; c=relaxed/simple;
	bh=AOsZ7cmg0K2e4ykHB3K6XLTT5MGa6T11VN3OPfSzJRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeNjB7LNDXtiLGmo4Ac6wa7ki23DpWP5N9VDdCwDxO2tzXLrZarV6qoUODSb/Wnl1C2VNQC8mdcrEHtJw+Bv3Ie/8EGrmFzFh3e9919cnTkrhqhbyLMCpvKyEfwOpJZcIt+REKtiEs/Vf+upgOOqzBwafu+m3PH8mcFNTiZ5w8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MVJKDVP0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MVJKDVP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1B91F00A3A;
	Fri, 10 Jul 2026 08:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783673661;
	bh=YZNE0lbtlq0p297df2r/Rm0xdJBDP67BvirQJmtok1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MVJKDVP0PZmlaxHeBLQCnH7pBt7Qpmd8Y9a/PDeExQblKs2KCxxEXoc6PLOPH04yO
	 2FlCm+S7CFY3OYEGWxn2dOiqduuoJFnCFQPluLPvOvFYKVINRllrVZI/nhd3kEWCQ7
	 oBjwtuQ8kdXIjAkOqKlq4rgGO12cnXYuetV1fYpVMTb37DEeV/GPpbh5J4aETSRtY6
	 ICS4fcQA1/cDo7APghHDkZHyVRmp560pS7RB1EdvDPPBGIjbSLLnlRp8BG2fbCK4L3
	 Vu8sXbNkkYpnqnqMeksUBEaJ6CH9c+K9T4Ih9k2BAcRzBiZ7IKpKhaUTsa/dXhMVB/
	 wjz/Y9eZQgcdw==
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
Subject: [PATCH v11 19/20] xfs: introduce health state for corrupted fsverity metadata
Date: Fri, 10 Jul 2026 10:52:47 +0200
Message-ID: <20260710085256.3464201-20-aalbersh@kernel.org>
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
index 31faa95c396d..9732811a1444 100644
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
 	if (desc_pos < xfs_fsverity_metadata_offset(ip)) {
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

