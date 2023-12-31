Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81518C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ii7sxgAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563FBC433C8;
	Sun, 31 Dec 2023 23:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064141;
	bh=I1MJR2U1yZLpcfcsDThFsKXry8DkaQVKn1yUUjuNwDw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ii7sxgAzhQe82983p94RsrYJ10QmqCcmke+aF1d4paC8yFoXwqVwYvChi0/eZDCHf
	 xossCtN8v0wo3XLXOGjkC3kRjcGE2PcTT0pXXAzPl8YCAuHrQRmmKskb2F0u8mshdg
	 xSFpKvrWzVJp4or3QBkrteq/J9JYWGpdXpkyD+oOXgvY79ZFxExkhlKQKzpfd0D9wo
	 8xOydJFkpHe9B/Z6daqYN5xKyQTBbLKNqBXvKDvy3QrZiL+qfZD0Kc2brkRq0Xorlg
	 jau0bi4HtC7zjRwsvGoX1bgG/ZzzjCQing6XSO3kYRKeffKaHl8F8B3Cx+D1MOuBKo
	 a8caTHfi0SMIw==
Date: Sun, 31 Dec 2023 15:09:00 -0800
Subject: [PATCH 15/32] xfs: Add the parent pointer support to the superblock
 version 5.
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Mark Tinguely <tinguely@sgi.com>, Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 "Darrick J. Wong" <darrick.wong@oracle.com>, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Message-ID: <170405006302.1804688.5942768186018194393.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Add the parent pointer superblock flag so that we can actually mount
filesystems with this feature enabled.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/fsgeom.c    |    6 ++++--
 libxfs/xfs_format.h |    4 +++-
 libxfs/xfs_fs.h     |    1 +
 libxfs/xfs_sb.c     |    4 ++++
 4 files changed, 12 insertions(+), 3 deletions(-)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 6980d3ffab6..061995fa2c7 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -31,6 +31,7 @@ xfs_report_geom(
 	int			bigtime_enabled;
 	int			inobtcount;
 	int			nrext64;
+	int			parent;
 
 	isint = geo->logstart > 0;
 	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
@@ -49,6 +50,7 @@ xfs_report_geom(
 	bigtime_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_BIGTIME ? 1 : 0;
 	inobtcount = geo->flags & XFS_FSOP_GEOM_FLAGS_INOBTCNT ? 1 : 0;
 	nrext64 = geo->flags & XFS_FSOP_GEOM_FLAGS_NREXT64 ? 1 : 0;
+	parent = geo->flags & XFS_FSOP_GEOM_FLAGS_PARENT ? 1 : 0;
 
 	printf(_(
 "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
@@ -57,7 +59,7 @@ xfs_report_geom(
 "         =%-22s reflink=%-4u bigtime=%u inobtcount=%u nrext64=%u\n"
 "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 "         =%-22s sunit=%-6u swidth=%u blks\n"
-"naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d\n"
+"naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d, parent=%d\n"
 "log      =%-22s bsize=%-6d blocks=%u, version=%d\n"
 "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
@@ -68,7 +70,7 @@ xfs_report_geom(
 		"", geo->blocksize, (unsigned long long)geo->datablocks,
 			geo->imaxpct,
 		"", geo->sunit, geo->swidth,
-		dirversion, geo->dirblocksize, cimode, ftype_enabled,
+		dirversion, geo->dirblocksize, cimode, ftype_enabled, parent,
 		isint ? _("internal log") : logname ? logname : _("external"),
 			geo->blocksize, geo->logblocks, logversion,
 		"", geo->logsectsize, geo->logsunit / geo->blocksize, lazycount,
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 8b952909ce1..b0aaa825539 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -373,13 +373,15 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
+#define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 6)	/* parent pointers */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
-		 XFS_SB_FEAT_INCOMPAT_NREXT64)
+		 XFS_SB_FEAT_INCOMPAT_NREXT64| \
+		 XFS_SB_FEAT_INCOMPAT_PARENT)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index e92b6a9612a..efa68a2d82a 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -239,6 +239,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
+#define XFS_FSOP_GEOM_FLAGS_PARENT	(1U << 30) /* parent pointers */
 
 /* atomic file extent swap available to userspace */
 #define XFS_FSOP_GEOM_FLAGS_ATOMIC_SWAP	(1U << 31)
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index fd017d18cda..d150170d87b 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -174,6 +174,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NEEDSREPAIR;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
 		features |= XFS_FEAT_NREXT64;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_PARENT)
+		features |= XFS_FEAT_PARENT;
 
 	return features;
 }
@@ -1249,6 +1251,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
 	if (xfs_has_inobtcounts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
+	if (xfs_has_parent(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
 	if (xfs_has_sector(mp)) {
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
 		geo->logsectsize = sbp->sb_logsectsize;

