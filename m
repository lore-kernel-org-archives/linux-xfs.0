Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB596C8C8
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oUDnanSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3312DC433C7;
	Sun, 31 Dec 2023 20:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056383;
	bh=3o6vgTbzrsO/ksjq0KlWh041cumVCru+jj2/wbXTfZ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oUDnanSZaxcLdMWbv//gSCBqLtrNugVV7KvfEJs+I1DHKK99ueK6PKYz/6a8shVXg
	 E9r6vxf8gd1fSE1xo+Huvl7HDBkpLo/nLg5SY82bcCcXAl1pcBNeHbOFxuh8XFe3E8
	 OBEeM815uvAR876mOuLeamNKSklQXJyuiTNAz6tqXNVY9yZd4Rfu8E3ap1Bm0GyaRk
	 +8Q4UF9nCucewTyo1tQ6H/9EaDtwMFgcTI9yhJU/ZtXmNM9C+McEVku3W9xRrUR/m8
	 W9xmMmvvFg/ygt9y+5iwjQqoZWN1uKRtW9jOk+/AmFBY4JugCJiGHPAIKQwmJqH7qB
	 Y1Z8JRPq7znJQ==
Date: Sun, 31 Dec 2023 12:59:42 -0800
Subject: [PATCH 3/4] xfs: report directory tree corruption in the health
 information
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404842504.1757975.2834172389553295172.stgit@frogsfrogsfrogs>
In-Reply-To: <170404842446.1757975.532228960833173146.stgit@frogsfrogsfrogs>
References: <170404842446.1757975.532228960833173146.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_fs.h     |    1 +
 fs/xfs/libxfs/xfs_health.h |    4 +++-
 fs/xfs/scrub/health.c      |    1 +
 fs/xfs/xfs_health.c        |    1 +
 4 files changed, 6 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 48f38694f1232..2499a20f5f774 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -413,6 +413,7 @@ struct xfs_bulkstat {
 #define XFS_BS_SICK_XATTR	(1 << 5)  /* extended attributes */
 #define XFS_BS_SICK_SYMLINK	(1 << 6)  /* symbolic link remote target */
 #define XFS_BS_SICK_PARENT	(1 << 7)  /* parent pointers */
+#define XFS_BS_SICK_DIRTREE	(1 << 8)  /* directory tree structure */
 
 /*
  * Project quota id helpers (previously projid was 16bit only
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index df07c5877ba44..bca1990f71da8 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
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
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 664d57247ddf5..12f3e9fca727f 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -110,6 +110,7 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_FSCOUNTERS]	= { XHG_FS,  XFS_SICK_FS_COUNTERS },
 	[XFS_SCRUB_TYPE_QUOTACHECK]	= { XHG_FS,  XFS_SICK_FS_QUOTACHECK },
 	[XFS_SCRUB_TYPE_NLINKS]		= { XHG_FS,  XFS_SICK_FS_NLINKS },
+	[XFS_SCRUB_TYPE_DIRTREE]	= { XHG_INO, XFS_SICK_INO_DIRTREE },
 };
 
 /* Return the health status mask for this scrub type. */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index bd884c154cf37..15ebfe331f277 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -454,6 +454,7 @@ static const struct ioctl_sick_map ino_map[] = {
 	{ XFS_SICK_INO_BMBTA_ZAPPED,	XFS_BS_SICK_BMBTA },
 	{ XFS_SICK_INO_DIR_ZAPPED,	XFS_BS_SICK_DIR },
 	{ XFS_SICK_INO_SYMLINK_ZAPPED,	XFS_BS_SICK_SYMLINK },
+	{ XFS_SICK_INO_DIRTREE,	XFS_BS_SICK_DIRTREE },
 	{ 0, 0 },
 };
 

