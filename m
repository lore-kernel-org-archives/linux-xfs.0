Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD80C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSHxZvui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1359C433C7;
	Sun, 31 Dec 2023 23:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065641;
	bh=oy0VWtjmvgOgjtInILcKWeLeIiqOffTKc/5EZ2ft2uk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hSHxZvuiQXhFLmJkcBDDBkvSTbVN+bEt+y9WrqaZFRIkcboaLBPV0lMGW8xG8ymh8
	 EwpY4fp9S1VczcPf3jDslDmQ4mDzrtYxapvoxUx0xdjLUOcFZoAN0Z0O0EA4T20H6T
	 XfWuJnCojNv2RuyjZS0zgqp4ayDZcJL54XUQFOusb4BWbEepwt0afDBnf7F/1MohVX
	 BszHwn0vBqLdyZ0QEgjmGJpAVDvVjrglbD1ToRhh9393uyB2UHl5ihDVk+exDcnpui
	 sYpv2kYFynMllBEoYWe/4n4s0kXsIVnwmK1bb8bYt/40QzMzIwXypTd//58Ma+bOcL
	 5M80W9ByMEqvA==
Date: Sun, 31 Dec 2023 15:34:01 -0800
Subject: [PATCH 17/58] xfs: advertise metadata directory feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010175.1809361.13950167954596436119.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Advertise the existence of the metadata directory feature; this will be
used by scrub to decide if it needs to scan the metadir too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h                 |    1 +
 libxfs/xfs_sb.c                 |    2 ++
 man/man2/ioctl_xfs_fsgeometry.2 |    3 +++
 3 files changed, 6 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 77fbca573e1..2e31fc2240e 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -239,6 +239,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
+#define XFS_FSOP_GEOM_FLAGS_METADIR	(1U << 29) /* metadata directories */
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1U << 30) /* parent pointers */
 
 /* atomic file extent swap available to userspace */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index b74a170605d..719da346d36 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1296,6 +1296,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
 	if (xfs_atomic_swap_supported(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATOMIC_SWAP;
+	if (xfs_has_metadir(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index 4c7ff9a270b..9c0ad165cbe 100644
--- a/man/man2/ioctl_xfs_fsgeometry.2
+++ b/man/man2/ioctl_xfs_fsgeometry.2
@@ -214,6 +214,9 @@ Filesystem supports sharing blocks between files.
 .TP
 .B XFS_FSOP_GEOM_FLAGS_ATOMICSWAP
 Filesystem can exchange file contents atomically via XFS_IOC_EXCHANGE_RANGE.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_METADIR
+Filesystem contains a metadata directory tree.
 .RE
 .SH XFS METADATA HEALTH REPORTING
 .PP

