Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B0F4A21
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300170; cv=none; b=rN9K6G96hUkmNqFN5VpdTNErJ8NGrPfYuv/TGn891+1ah/TSqHj/loil3bou3ZD1d6wuHLnANwEFb12gwrAoChtof15Osa8LQrgyD3hgwGm4Gee6sLBbNM6Nkl7KMHVp8QrMtjRZ8uHIanwhmbVGbzl8Tn3EEnMpdWPkiSpdRrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300170; c=relaxed/simple;
	bh=w/7g7Eh4p7v7mx+bYUziTSPKX7PBwRJOGJk9Zij+qjc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QzO//eN6c33xbik/23yjKme8+c8wAD1CZza2/X7+YMG6kp18yvjErGDkeLLo73rK20sL7sGshA6Zqfk12+1cOfrLfBn8VNXflOteF4EU1YEDz/Xl+hd9aGUhFLbMrZBT8ILCocEbLT3h+msmHJG9s5j9Gs297suLAcxyML349JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U4I3HLph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4I3HLph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00E0C32786;
	Tue, 30 Jul 2024 00:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300169;
	bh=w/7g7Eh4p7v7mx+bYUziTSPKX7PBwRJOGJk9Zij+qjc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U4I3HLph1NvJt+bMnlaipi2ehmp+wtO2j47D1S5LE0nMvc4zQlx7DOEOACmzCALQw
	 qKBO9dt0JC/42gw9ew6VAqrrnHgagaBTCJRzRop4q1nwvwj8Js+/xzXrdXodUQxoOV
	 qcP9HfmhYlGfheMl3ql16XhnSvpi91Yhm/Jnhp+KMTs59YODGw5s8tHAd5Ci0YB+Lq
	 Q9FbGKTM3HeHgqEQM1vNzhzExVbhcp/KIu8o3b0LNnM9XVYuS8w6VoJBvxh6ydSmD6
	 Bs1kt8dcS8OjETmXKClcR+aNxxCp7/nKSNT56DYyyrHSFoBpZkzM/qyeYonCGYSmDv
	 egcXkhr2KxWNg==
Date: Mon, 29 Jul 2024 17:42:49 -0700
Subject: [PATCH 073/115] xfs: add a incompat feature bit for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
 Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Message-ID: <172229843469.1338752.9535654513166030813.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 5f98ec1cb5c264e4815e21d632ee0b3d6e700e3d

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
 libxfs/xfs_format.h |    1 +
 libxfs/xfs_fs.h     |    1 +
 libxfs/xfs_sb.c     |    4 ++++
 3 files changed, 6 insertions(+)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f1818c54a..b457e457e 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -374,6 +374,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4) /* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)  /* large extent counters */
 #define XFS_SB_FEAT_INCOMPAT_EXCHRANGE	(1 << 6)  /* exchangerange supported */
+#define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 7)  /* parent pointers */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
 		 XFS_SB_FEAT_INCOMPAT_SPINODES | \
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index ea654df05..dd13bfa50 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -240,6 +240,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
 #define XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE (1 << 24) /* exchange range */
+#define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 2db43b805..f45ffd994 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -175,6 +175,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NREXT64;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_EXCHRANGE)
 		features |= XFS_FEAT_EXCHANGE_RANGE;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_PARENT)
+		features |= XFS_FEAT_PARENT;
 
 	return features;
 }
@@ -1251,6 +1253,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
 	if (xfs_has_inobtcounts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
+	if (xfs_has_parent(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
 	if (xfs_has_sector(mp)) {
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
 		geo->logsectsize = sbp->sb_logsectsize;

