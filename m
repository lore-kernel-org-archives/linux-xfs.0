Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8192623
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712711288; cv=none; b=M2QTVIK/IuSzjZuwljGyu7j9HaObL5etdwKii2p2EJsdrNgNwENF8RYZMqzdC8a0bkRwQ74UUfb53TW39esX6lD9rpCtAyAwqpjoKG1M/CYYH2SHf80/1iinOsAWpBlXr/VzrXTA1GfQVJ0Cu1/k+bVexEqSSv96AaEhPuoSAEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712711288; c=relaxed/simple;
	bh=qbvqssVrlbIJ8JrdyCiQt82+EnJ5+IQl517Wj9C6Ff8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EFhj5GUcKex3yBLQ4wElyzCT6Gzaxw1WCBwGE/NOOHz1RXjG3BrLXYZJRlrRErcEs7qsvOA1l8dchFF0Vxld1qPtns9bT5bN94kHEg84nDhJJ96u+xUwR7CSMYayUPq24PsUnV514CdltQY4DLEgOk8olCqKh/g6NECze/WEkCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FuUQiPO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FuUQiPO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D30C433C7;
	Wed, 10 Apr 2024 01:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712711287;
	bh=qbvqssVrlbIJ8JrdyCiQt82+EnJ5+IQl517Wj9C6Ff8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FuUQiPO5FsWBvJGe47ZPpc33nXKo/THTVWL1id7xf0HH/AWodRwXKX/klbIY65tNo
	 Wf4oQ7xCRz4bitV7kF7kQ9txkvwQ+wztLacLFPX0ksb8KhZoATuYlB4eUXxpWSQDo8
	 +Gi/GxFN7JWo4HFrOEGRh7zC0vogOUmx81BvLRJrbh2fKVwewNEBzVh6x8sTSRGL4K
	 TtVaSxSRWgjDCLi/Iwb5jFMxRbfblA3wyddpT0ncmri02foOZ9PkYNbLpHF2K63f7I
	 X0UbO1h3m3OSnL8UHVZ1cmm36Q3dTP7NqPiUPk0Y+KX3mBffMx1XVq+CnZxXkiEcnn
	 zVNlOQ18gKvzg==
Date: Tue, 09 Apr 2024 18:08:07 -0700
Subject: [PATCH 3/4] xfs: report directory tree corruption in the health
 information
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270971640.3633329.13764771670901784778.stgit@frogsfrogsfrogs>
In-Reply-To: <171270971578.3633329.3916047777798574829.stgit@frogsfrogsfrogs>
References: <171270971578.3633329.3916047777798574829.stgit@frogsfrogsfrogs>
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
index da0f427a09730..f2d2c1db18e53 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -412,6 +412,7 @@ struct xfs_bulkstat {
 #define XFS_BS_SICK_XATTR	(1 << 5)  /* extended attributes */
 #define XFS_BS_SICK_SYMLINK	(1 << 6)  /* symbolic link remote target */
 #define XFS_BS_SICK_PARENT	(1 << 7)  /* parent pointers */
+#define XFS_BS_SICK_DIRTREE	(1 << 8)  /* directory tree structure */
 
 /*
  * Project quota id helpers (previously projid was 16bit only
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 3c64b5f9bd681..b0edb4288e592 100644
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
index 9020a6bef7f14..b712a8bd34f54 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -108,6 +108,7 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_FSCOUNTERS]	= { XHG_FS,  XFS_SICK_FS_COUNTERS },
 	[XFS_SCRUB_TYPE_QUOTACHECK]	= { XHG_FS,  XFS_SICK_FS_QUOTACHECK },
 	[XFS_SCRUB_TYPE_NLINKS]		= { XHG_FS,  XFS_SICK_FS_NLINKS },
+	[XFS_SCRUB_TYPE_DIRTREE]	= { XHG_INO, XFS_SICK_INO_DIRTREE },
 };
 
 /* Return the health status mask for this scrub type. */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index b39f959146bc1..10f116d093a22 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -470,6 +470,7 @@ static const struct ioctl_sick_map ino_map[] = {
 	{ XFS_SICK_INO_BMBTA_ZAPPED,	XFS_BS_SICK_BMBTA },
 	{ XFS_SICK_INO_DIR_ZAPPED,	XFS_BS_SICK_DIR },
 	{ XFS_SICK_INO_SYMLINK_ZAPPED,	XFS_BS_SICK_SYMLINK },
+	{ XFS_SICK_INO_DIRTREE,	XFS_BS_SICK_DIRTREE },
 	{ 0, 0 },
 };
 

