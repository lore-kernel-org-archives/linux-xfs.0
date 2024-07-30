Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97F74A11
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299090; cv=none; b=jVyfd3n64zxUut0wVv/Ffj7pDf9eEiPKIHZ1LQY6EOezR+ouCimHiNC8GXqQdt/GOdP2Bpf5pDTs+op2paSi69nigRd3rpHiz1Phio1uyCDqgvSwaLL+1qmG9ZmVHczZjvrZLIfbJMmkZn7SpTLKUTHzFt6jlNTMIDSoYV8jjlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299090; c=relaxed/simple;
	bh=e4hjONcryM0XHtXZ+ZWzdpvDQVEa0yi/JNxkAhiNg1o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R6MncHGhxx4+fK3x+B1+GV4bHVk9yDp0xQOjxhhGX48qpNDCvalTH1MMqHQ3tFHMD91gP+8CoyKK+Sv3YUfvOj5hDPGRxRqFgAMgC75Qrycl1iXu0+Tl9mvl5KI4ZDT/qb4Hqyc+daGYaUAAtpLOQ0Qv+AqR/XR/XjzAKbGTdYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XuzFePtg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XuzFePtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AA1C32786;
	Tue, 30 Jul 2024 00:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299089;
	bh=e4hjONcryM0XHtXZ+ZWzdpvDQVEa0yi/JNxkAhiNg1o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XuzFePtgn9znRLT6wg6G6l8EhoyF9srlIgl+rtAgGGRvJrFJOKhnqivdhLIWt+cFe
	 SOeyu9wg6AzQ58GdeyjaBa+tXtGuBi0nCYaSCPpRbsjxY4JDQPKeK/fWgOPEiqnagN
	 YOHjBwde09L6uR1k9XmvuOpnoAYv7ryopXxL5EGVKWlHVKd777PpYqP7NP0o18gJ8d
	 Jk7FHKWT7dallrdayy2RQ3jnCPKGi4E5jx7wqX3nm6o54fgeHzsYCKoN2OLqrBiK6w
	 twn/U8DsmFgIFEmU6STh3N03jt6OaylvFi3HFgEcEFWxqyBVH0BQ8EvECqDsZH4GdE
	 9it80ML2N+wWA==
Date: Mon, 29 Jul 2024 17:24:49 -0700
Subject: [PATCH 004/115] xfs: create a incompat flag for atomic file mapping
 exchanges
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842498.1338752.2972429724527989367.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 1518646eef26c220e9256906260ecaaa64503522

Create a incompat flag so that we only attempt to process file mapping
exchange log items if the filesystem supports it, and a geometry flag to
advertise support if it's present.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_mount.h |    2 ++
 libxfs/xfs_format.h |   23 ++++++++++++-----------
 libxfs/xfs_fs.h     |    1 +
 libxfs/xfs_sb.c     |    4 ++++
 4 files changed, 19 insertions(+), 11 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 9c492b8f5..a9525e4e0 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -169,6 +169,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
+#define XFS_FEAT_EXCHANGE_RANGE	(1ULL << 27)	/* exchange range */
 
 #define __XFS_HAS_FEAT(name, NAME) \
 static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
@@ -213,6 +214,7 @@ __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
+__XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
 
 /* Kernel mount features that we don't support */
 #define __XFS_UNSUPP_FEAT(name) \
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 2b2f9050f..ff1e28316 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -367,18 +367,19 @@ xfs_sb_has_ro_compat_feature(
 	return (sbp->sb_features_ro_compat & feature) != 0;
 }
 
-#define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
-#define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
-#define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
-#define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
-#define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
-#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
+#define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)  /* filetype in dirent */
+#define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)  /* sparse inode chunks */
+#define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)  /* metadata UUID */
+#define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)  /* large timestamps */
+#define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4) /* needs xfs_repair */
+#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)  /* large extent counters */
+#define XFS_SB_FEAT_INCOMPAT_EXCHRANGE	(1 << 6)  /* exchangerange supported */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
-		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
-		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
-		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
-		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
-		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
+		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
+		 XFS_SB_FEAT_INCOMPAT_SPINODES | \
+		 XFS_SB_FEAT_INCOMPAT_META_UUID | \
+		 XFS_SB_FEAT_INCOMPAT_BIGTIME | \
+		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR | \
 		 XFS_SB_FEAT_INCOMPAT_NREXT64)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 8a1e30cf4..53526fca7 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -239,6 +239,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
+#define XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE (1 << 24) /* exchange range */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 895d646bb..2db43b805 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -173,6 +173,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NEEDSREPAIR;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
 		features |= XFS_FEAT_NREXT64;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_EXCHRANGE)
+		features |= XFS_FEAT_EXCHANGE_RANGE;
 
 	return features;
 }
@@ -1257,6 +1259,8 @@ xfs_fs_geometry(
 	}
 	if (xfs_has_large_extent_counts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
+	if (xfs_has_exchange_range(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 

