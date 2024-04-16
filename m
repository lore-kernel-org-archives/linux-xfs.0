Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CA34C98
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231201; cv=none; b=E2EMyI2rCH7UbPfZLnmfLw2VVGe8i6yrwOMP5Le/qMTPBVKM/VVBTh4y/My9wjMtHkF4F1dBM7/3GSxvGmTlakXYc3EdTWiyICbQoCWgEhBaeXLd4EeD+uXTRn++t1H9srfX2SBPpxny+ON34pzChFNXfV7wJqijTS1d0VobEoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231201; c=relaxed/simple;
	bh=mi3wER0VBREe2iWqta81cwbLpAsnGm6I87v5AH/6hN0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yca+R2Blc2tM8NCdus11hBgGUWhJCVwvEq+z5t3TCMlt86raAj+4WIr1dQggeplqtMlU2RixePvxHAr27MdEKc+KnAfl4+wEBv6ryJ2VdvWU8JQEPBO/CacMFH2+QaF/uPbVfOMFP4hAZV65wL4NmQc8HYY8UDNWWDzDbDJGeUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z67xRYK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z67xRYK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF5BC113CC;
	Tue, 16 Apr 2024 01:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231201;
	bh=mi3wER0VBREe2iWqta81cwbLpAsnGm6I87v5AH/6hN0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z67xRYK7aK/HLTBF5B2aJ+HHB+CYOrHKAABg71KfRii+/A2CvoRac0G+a6lBtoYoJ
	 1cZbKqNYKYvPr696qTIclYPssmyiI6vYPI+xalgmuqrdmcOVpJhFvOYYFTBNv8MCLq
	 ECPGN6UxMsP82htKXsDz9IriUOZV31JGdHtPV6UrXKVz8oympbuuTb3RPavaHYkyXz
	 PknFR9ldzVcYtvux2iekVopZ0SfiQjNhcrjaDWbP5HzaDRGru1y3GEKYXQKVarAjup
	 bV21WJ5rIq18rHXsP7djBGvbjYEb4hi0B7eaWikGio9Y5kLTwHOB63kNTAGqyU+eRI
	 +jVgHXM+qcqkQ==
Date: Mon, 15 Apr 2024 18:33:20 -0700
Subject: [PATCH 28/31] xfs: add a incompat feature bit for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
 Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 "Darrick J. Wong" <darrick.wong@oracle.com>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323028245.251715.15931129361997171407.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
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

Create an incompat feature bit and a fs geometry flag so that we can
enable the feature in the ondisk superblock and advertise its existence
to userspace.

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    1 +
 fs/xfs/libxfs/xfs_fs.h     |    1 +
 fs/xfs/libxfs/xfs_sb.c     |    4 ++++
 fs/xfs/xfs_super.c         |    4 ++++
 4 files changed, 10 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index f1818c54af6f8..b457e457e1f71 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -374,6 +374,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4) /* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)  /* large extent counters */
 #define XFS_SB_FEAT_INCOMPAT_EXCHRANGE	(1 << 6)  /* exchangerange supported */
+#define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 7)  /* parent pointers */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
 		 XFS_SB_FEAT_INCOMPAT_SPINODES | \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 29a4e62d4e92b..7e578c4894061 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -240,6 +240,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
 #define XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE (1 << 24) /* exchange range */
+#define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index c350e259b6855..09e4bf949bf88 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -178,6 +178,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NREXT64;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_EXCHRANGE)
 		features |= XFS_FEAT_EXCHANGE_RANGE;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_PARENT)
+		features |= XFS_FEAT_PARENT;
 
 	return features;
 }
@@ -1254,6 +1256,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
 	if (xfs_has_inobtcounts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
+	if (xfs_has_parent(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
 	if (xfs_has_sector(mp)) {
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
 		geo->logsectsize = sbp->sb_logsectsize;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 84f37e8474da2..14a7f74b20dbb 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1733,6 +1733,10 @@ xfs_fs_fill_super(
 		xfs_warn(mp,
 	"EXPERIMENTAL exchange-range feature enabled. Use at your own risk!");
 
+	if (xfs_has_parent(mp))
+		xfs_warn(mp,
+	"EXPERIMENTAL parent pointer feature enabled. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;

