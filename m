Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC07621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710865; cv=none; b=E8uckZserhLyrUeI706Xuzg4Qeto6hYFgaCEI6f4pAO+e/bSzIGxBvOI+h0tgqIyvTMNBFO3mxnvw5cac04y9h7Yk9JO6w4N/a52LN/yJVKBKLNRv9GI26G17oYbgkwWKLA7o/lS6dqD+fNQ+6En9sudhAcK2FabHQ88Zt2BPXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710865; c=relaxed/simple;
	bh=Djm1otwGDlSzthgpwdLVXi+/17+f5iG8zxcHmKst0DE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uWdsJc6OQl27PpaLaAI0tz/oWantzZjkucihRRIpQQjdFWcY65hxNs3YMKA5kNtlkZpNIQUlw8CDvaxCZlR9ZS34W93M7o5yrhaStK2ITCQDYR2eebXQZq+vR6TUBQ2EzsXJHhhEvdYyozl71PTbdhWzC90LtSF5NufGBNGg7w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MKeJA1df; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MKeJA1df"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF25DC433F1;
	Wed, 10 Apr 2024 01:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710865;
	bh=Djm1otwGDlSzthgpwdLVXi+/17+f5iG8zxcHmKst0DE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MKeJA1dfOlu1uLM42nV2+6qDPbOT07ZCtMM1RvHge+ufvRZEOJBk9OOwOnbCXCPYk
	 av+xDMlZx0gtyUuemDj6DKL6/abIjWGNwN19TzFfJRCLOnJgYMpw7zzRCW0MI+EH8+
	 BIdcPuGZ0dyrfjC96vgdxUNsj00cJDyyfgUizlCOEpEcCozf/Kueo3/mFssl6PwkP1
	 3d02zaatSiVUu8Z7MYeKUwlJFCJa2uWhh5SpdXSR9fII3dFqY5MaCAW2t/ZKcRT9Mj
	 0VwxjB79jDSYOy40bGRg3qK/KBFDGZiQxWSMu5GzwvkM4RB9VSa1Hs+sH7zE/CgKj2
	 RQlzHbVADp8yQ==
Date: Tue, 09 Apr 2024 18:01:04 -0700
Subject: [PATCH 29/32] xfs: Add the parent pointer support to the superblock
 version 5.
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
 Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 "Darrick J. Wong" <darrick.wong@oracle.com>, catherine.hoang@oracle.com,
 hch@lst.de, allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <171270970042.3631889.15727225239821945588.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    1 +
 fs/xfs/libxfs/xfs_fs.h     |    2 ++
 fs/xfs/libxfs/xfs_sb.c     |    4 ++++
 fs/xfs/xfs_super.c         |    4 ++++
 4 files changed, 11 insertions(+)


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
index fa28c18e521bf..90e1d0cc04e4b 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -241,6 +241,8 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
 #define XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE (1 << 24) /* exchange range */
 
+#define XFS_FSOP_GEOM_FLAGS_PARENT	(1U << 30) /* parent pointers */
+
 /*
  * Minimum and maximum sizes need for growth checks.
  *
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

