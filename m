Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97088836
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928779; cv=none; b=jR9TBUoY9/H1f6viOHxe8vGTNZyWr9EFZ+vHTpGxqLP6++H0MtPBrwrBlxDcwo6/TgulwKp2V21NyR74QG9Ok4YtIsLxJWLEnDAkTJOFFq288sps1vzGmoW9Jo5JaWUl4Hl3m7mIoPe/87jQ4DcvI6xRqCl3Nl6m/0zwOZhjWR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928779; c=relaxed/simple;
	bh=Mv70ot+ZKk9HBVoG+HBBAvpzWGL57rALVlYeMvcbTtY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ClsN99E01+knbWvrzQI+qj20ugUM5X8oXbW/TZcurUuzjZyZi3VDLgcfrrVpOyV2H96Zxc5PnuhzTE2UHOGXAxc8tiFKCS1vfO1lRlf2W68BerBAFdr08FlXmCpDd5YSsAjzxWzp3c82d8ReyvMCRpRzvrxojX/V6DunBBjidOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PUvC/Jkf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PUvC/Jkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769E8C116B1;
	Wed, 24 Apr 2024 03:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928778;
	bh=Mv70ot+ZKk9HBVoG+HBBAvpzWGL57rALVlYeMvcbTtY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PUvC/JkfO6llIYOHdSitpsAdguR9ddRSz82co0psjFE0ABucsVnnKRzKRacv7zq1N
	 S7ztbf31ANupeZWjkIMtdUdPJelV4gxmsG48KSs3B+vVsRILw1pAgo1RcYB5sJK+TS
	 u81XtSAnr+Qm1F0D8vuq296iGuNcdq3M9R6C9kEjt8dTbJ8FyVBdbw81ARcKD3jZz0
	 kjk9O5/3FJPH+147xPiXYucyNMNP4IGg/BIlHm5S7gNtnfY+m/WYtNvUOJI1oxDVu3
	 4KcM42fa00ET9w95fXHCftYuVRfe+shmC1BLHJ8uK+MtAA1iL+G5TRF/Eh8WemM9Ib
	 XfC9QdoWphPvg==
Date: Tue, 23 Apr 2024 20:19:37 -0700
Subject: [PATCH 27/30] xfs: add a incompat feature bit for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
 Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 "Darrick J. Wong" <darrick.wong@oracle.com>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783726.1905110.10963834680079441797.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
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
index f1818c54af6f..b457e457e1f7 100644
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
index ea654df0505f..dd13bfa500f2 100644
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
index c350e259b685..09e4bf949bf8 100644
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
index c303d7ff9597..27e9f749c4c7 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1746,6 +1746,10 @@ xfs_fs_fill_super(
 		xfs_warn(mp,
 	"EXPERIMENTAL exchange-range feature enabled. Use at your own risk!");
 
+	if (xfs_has_parent(mp))
+		xfs_warn(mp,
+	"EXPERIMENTAL parent pointer feature enabled. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;

