Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFEAC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n3SRXy6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87651C433C8;
	Sun, 31 Dec 2023 23:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064735;
	bh=2LescKwlE7IzShpoJEPPigqDA5TX2y6109L0//pUMEk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n3SRXy6TlaTJ4AHW8H9gYwsZFOPVrQwq382iY9/FsQbyKglUzlvhOBB08rLRLuqB0
	 5vv9Qr47tH3kHYrLF6W//OY/Th1pJGydRmhsmUXKZ0Z85QCZ0B566WvRLJ3wFi1tso
	 4FB7UfXjeGaVB3r5f66SiVjuHbh08IK+UObxeSXhf9l3JCxBqIrIfVyJaeken4UUUD
	 RxRRjpZzOIs4M3fMgRtY2p4lctAOkZzA95LIcDl4GQYFh17IGE15Uy2e3L6P2veBxU
	 RLKQ38QD47yjIGGBqTgVHSc1A2ERMqAl4Q4WxsvEw+qzVV7fnyXbmvzZqOoE4z7ao5
	 IzDsBpetWzilw==
Date: Sun, 31 Dec 2023 15:18:55 -0800
Subject: [PATCH 3/6] xfs: report directory tree corruption in the health
 information
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405007473.1805996.14045845817139841397.stgit@frogsfrogsfrogs>
In-Reply-To: <170405007429.1805996.15935827855068032438.stgit@frogsfrogsfrogs>
References: <170405007429.1805996.15935827855068032438.stgit@frogsfrogsfrogs>
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

Report directories that are the source of corruption in the directory
tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h                 |    1 +
 libxfs/xfs_health.h             |    4 +++-
 man/man2/ioctl_xfs_bulkstat.2   |    3 +++
 man/man2/ioctl_xfs_fsbulkstat.2 |    3 +++
 spaceman/health.c               |    4 ++++
 5 files changed, 14 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 48f38694f12..2499a20f5f7 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -413,6 +413,7 @@ struct xfs_bulkstat {
 #define XFS_BS_SICK_XATTR	(1 << 5)  /* extended attributes */
 #define XFS_BS_SICK_SYMLINK	(1 << 6)  /* symbolic link remote target */
 #define XFS_BS_SICK_PARENT	(1 << 7)  /* parent pointers */
+#define XFS_BS_SICK_DIRTREE	(1 << 8)  /* directory tree structure */
 
 /*
  * Project quota id helpers (previously projid was 16bit only
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index df07c5877ba..bca1990f71d 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -95,6 +95,7 @@ struct xfs_da_args;
 
 /* Don't propagate sick status to ag health summary during inactivation */
 #define XFS_SICK_INO_FORGET	(1 << 12)
+#define XFS_SICK_INO_DIRTREE	(1 << 13)  /* directory tree structure */
 
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
@@ -125,7 +126,8 @@ struct xfs_da_args;
 				 XFS_SICK_INO_DIR | \
 				 XFS_SICK_INO_XATTR | \
 				 XFS_SICK_INO_SYMLINK | \
-				 XFS_SICK_INO_PARENT)
+				 XFS_SICK_INO_PARENT | \
+				 XFS_SICK_INO_DIRTREE)
 
 #define XFS_SICK_INO_ZAPPED	(XFS_SICK_INO_BMBTD_ZAPPED | \
 				 XFS_SICK_INO_BMBTA_ZAPPED | \
diff --git a/man/man2/ioctl_xfs_bulkstat.2 b/man/man2/ioctl_xfs_bulkstat.2
index 3203ca0c5d2..b6d51aa4381 100644
--- a/man/man2/ioctl_xfs_bulkstat.2
+++ b/man/man2/ioctl_xfs_bulkstat.2
@@ -326,6 +326,9 @@ Symbolic link target.
 .TP
 .B XFS_BS_SICK_PARENT
 Parent pointers.
+.TP
+.B XFS_BS_SICK_DIRTREE
+Directory is the source of corruption in the directory tree.
 .RE
 .SH ERRORS
 Error codes can be one of, but are not limited to, the following:
diff --git a/man/man2/ioctl_xfs_fsbulkstat.2 b/man/man2/ioctl_xfs_fsbulkstat.2
index 3f059942a21..cd38d2fd6f2 100644
--- a/man/man2/ioctl_xfs_fsbulkstat.2
+++ b/man/man2/ioctl_xfs_fsbulkstat.2
@@ -239,6 +239,9 @@ Symbolic link target.
 .TP
 .B XFS_BS_SICK_PARENT
 Parent pointers.
+.TP
+.B XFS_BS_SICK_DIRTREE
+Directory is the source of corruption in the directory tree.
 .RE
 .SH RETURN VALUE
 On error, \-1 is returned, and
diff --git a/spaceman/health.c b/spaceman/health.c
index ab5bc074988..8ba78152cb6 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -169,6 +169,10 @@ static const struct flag_map inode_flags[] = {
 		.mask = XFS_BS_SICK_PARENT,
 		.descr = "parent pointers",
 	},
+	{
+		.mask = XFS_BS_SICK_DIRTREE,
+		.descr = "directory tree structure",
+	},
 	{0},
 };
 

