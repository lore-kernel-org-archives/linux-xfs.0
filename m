Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C008D1DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845045; cv=none; b=ODcIjLNlLVQjAfjmu4i7TbXTf5L7ABbMLndP7xUlO74pSn0pcqPzKT1OD1QwBlrXIOnj+Kwx0imeSsSdrdDOi2NYiyy46U9A7xhVRVN1CPnTa5N1yy0IipeD+1my3KpfxJe0wUK4g/beXrKlPdmPWaKDxxXL4ThBpIEARLLfAb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845045; c=relaxed/simple;
	bh=1EkNh4Z1vY63jP9lt1T0dA4fdm6V5tW2ZMs35mhyelE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=srQZgVU+ylyGNOcMbeTYWgUO2loOw1UqbTUKvTqr0AJgi5ur2dKyxvSZXbrrqotBIoGWfUKQjHd1Zfdu23E/3RQrjRiB7Oh/adAJMN/AKV+rM/hswxkqhC5kNg1L9bnsGzYESxM+/R0Z18cjOOjUXhMUcTHOZ+u+MY3XGR3ZTT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D2AWnT6T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2AWnT6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54063C4CED1;
	Tue,  5 Nov 2024 22:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845045;
	bh=1EkNh4Z1vY63jP9lt1T0dA4fdm6V5tW2ZMs35mhyelE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D2AWnT6Tgn7/I+aFnOsvxy8X6/TPMh3MXuIG/9LoisC6iPav8Jp3NdzMinuLdq33C
	 DO+37EbkdInjyoTPdaxpVXPZDN40pdTTUb4LcKDm64CYjAvl8v2oD0tHTUBoY08OSM
	 9vayLxOw+jrqEPj+2tTyU7xFwA4HsbHPQmTycO0LL6To5owqF5noK1wmSV7khHdjzJ
	 35mV8FoZDGpv5WiZjNfB9yebQl1Fm4F84sGnaCkSyXAInpqFhms/y2sXYsrMY0dZkA
	 b/CGv0lQ6tIrPEja1nVM3KMMEJTeRAdx13mmYEGv8T9Kqy66Nj23ctopPdmWUDcDwY
	 TJ4iyiZgtUHVQ==
Date: Tue, 05 Nov 2024 14:17:24 -0800
Subject: [PATCH 03/28] xfs: rename metadata inode predicates
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396069.1870066.2955419799237106193.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
References: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The predicate xfs_internal_inum tells us if an inumber refers to one of
the inodes rooted in the superblock.  Soon we're going to have internal
inodes in a metadata directory tree, so this helper should be renamed
to capture its limited scope.

Ondisk inodes will soon have a flag to indicate that they're metadata
inodes.  Head off some confusion by renaming the xfs_is_metadata_inode
predicate to xfs_is_internal_inode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_types.c      |    4 ++--
 fs/xfs/libxfs/xfs_types.h      |    2 +-
 fs/xfs/scrub/common.c          |    2 +-
 fs/xfs/scrub/inode.c           |    2 +-
 fs/xfs/scrub/inode_repair.c    |    2 +-
 fs/xfs/scrub/orphanage.c       |    2 +-
 fs/xfs/scrub/parent.c          |    2 +-
 fs/xfs/scrub/refcount_repair.c |    2 +-
 fs/xfs/xfs_inode.c             |    4 ++--
 fs/xfs/xfs_inode.h             |    2 +-
 fs/xfs/xfs_itable.c            |    2 +-
 11 files changed, 13 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index c91db4f5140743..1cbfe57e971d5c 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -111,7 +111,7 @@ xfs_verify_ino(
 
 /* Is this an internal inode number? */
 inline bool
-xfs_internal_inum(
+xfs_is_sb_inum(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino)
 {
@@ -129,7 +129,7 @@ xfs_verify_dir_ino(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino)
 {
-	if (xfs_internal_inum(mp, ino))
+	if (xfs_is_sb_inum(mp, ino))
 		return false;
 	return xfs_verify_ino(mp, ino);
 }
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index d3cb6ff3b91301..25053a66c225ed 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -230,7 +230,7 @@ bool xfs_verify_fsbext(struct xfs_mount *mp, xfs_fsblock_t fsbno,
 		xfs_fsblock_t len);
 
 bool xfs_verify_ino(struct xfs_mount *mp, xfs_ino_t ino);
-bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
+bool xfs_is_sb_inum(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
 bool xfs_verify_rtbext(struct xfs_mount *mp, xfs_rtblock_t rtbno,
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index e8b5e73bab60d3..777959f8ec724b 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -948,7 +948,7 @@ xchk_iget_for_scrubbing(
 		return xchk_install_live_inode(sc, ip_in);
 
 	/* Reject internal metadata files and obviously bad inode numbers. */
-	if (xfs_internal_inum(mp, sc->sm->sm_ino))
+	if (xfs_is_sb_inum(mp, sc->sm->sm_ino))
 		return -ENOENT;
 	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
 		return -ENOENT;
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index d32716fb2fecf7..4a8637afb0e29b 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -95,7 +95,7 @@ xchk_setup_inode(
 	}
 
 	/* Reject internal metadata files and obviously bad inode numbers. */
-	if (xfs_internal_inum(mp, sc->sm->sm_ino))
+	if (xfs_is_sb_inum(mp, sc->sm->sm_ino))
 		return -ENOENT;
 	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
 		return -ENOENT;
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 5da9e1a387a8bb..9085d6d11aebcd 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1762,7 +1762,7 @@ xrep_inode_pptr(
 	 * Metadata inodes are rooted in the superblock and do not have any
 	 * parents.
 	 */
-	if (xfs_is_metadata_inode(ip))
+	if (xfs_is_internal_inode(ip))
 		return 0;
 
 	/* Inode already has an attr fork; no further work possible here. */
diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 7148d8362db833..5f0d4239260862 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -295,7 +295,7 @@ xrep_orphanage_can_adopt(
 		return false;
 	if (sc->ip == sc->orphanage)
 		return false;
-	if (xfs_internal_inum(sc->mp, sc->ip->i_ino))
+	if (xfs_is_sb_inum(sc->mp, sc->ip->i_ino))
 		return false;
 	return true;
 }
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 91e7b51ce0680b..20711a68a87482 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -910,7 +910,7 @@ xchk_pptr_looks_zapped(
 	 * any parents.  Hence the attr fork will not be initialized, but
 	 * there are no parent pointers that might have been zapped.
 	 */
-	if (xfs_is_metadata_inode(ip))
+	if (xfs_is_internal_inode(ip))
 		return false;
 
 	/*
diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repair.c
index 4240fff459cb1d..4e572b81c98669 100644
--- a/fs/xfs/scrub/refcount_repair.c
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -215,7 +215,7 @@ xrep_refc_rmap_shareable(
 		return false;
 
 	/* Metadata in files are never shareable */
-	if (xfs_internal_inum(mp, rmap->rm_owner))
+	if (xfs_is_sb_inum(mp, rmap->rm_owner))
 		return false;
 
 	/* Metadata and unwritten file blocks are not shareable. */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a8430f30d6df29..0465546010554a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1295,7 +1295,7 @@ xfs_inode_needs_inactive(
 		return false;
 
 	/* Metadata inodes require explicit resource cleanup. */
-	if (xfs_is_metadata_inode(ip))
+	if (xfs_is_internal_inode(ip))
 		return false;
 
 	/* Want to clean out the cow blocks if there are any. */
@@ -1388,7 +1388,7 @@ xfs_inactive(
 		goto out;
 
 	/* Metadata inodes require explicit resource cleanup. */
-	if (xfs_is_metadata_inode(ip))
+	if (xfs_is_internal_inode(ip))
 		goto out;
 
 	/* Try to clean out the cow blocks if there are any. */
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 41444a557576c1..df7262f4674f78 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -276,7 +276,7 @@ static inline bool xfs_is_reflink_inode(const struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
 }
 
-static inline bool xfs_is_metadata_inode(const struct xfs_inode *ip)
+static inline bool xfs_is_internal_inode(const struct xfs_inode *ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index c0757ab994957b..37c2b50d877e42 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -69,7 +69,7 @@ xfs_bulkstat_one_int(
 	vfsuid_t		vfsuid;
 	vfsgid_t		vfsgid;
 
-	if (xfs_internal_inum(mp, ino))
+	if (xfs_is_sb_inum(mp, ino))
 		goto out_advance;
 
 	error = xfs_iget(mp, tp, ino,

