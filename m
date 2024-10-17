Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612011FCC47
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191310; cv=none; b=DqTzvcLcU8O1nIA6jmQtfMoFKlRFN4VfP2BP80mCSGIWEqTo0boIAYAtQZdizFbWeQDA5cB4+IaH+TM8/wMZrqI2+kbyohyfBVf0Icv2ScZoa7SKfoT1bN8eMoX+Qd/8jGSlWlJ7irze/FTkKRts5GlqP9YzZqcvcyZ4xmc/akk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191310; c=relaxed/simple;
	bh=2oC2CFF4EXxTbSdWcpiU8TM9dFnwQ0X2nxIRw8YH/6U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RUEA185y63ECn/y3pdLmVpwGOgQ2k4L1FI9CTi9bG3Uxbx1BbygKINESqxcJsctlt1HHiSdCme1nYlGPP8AfXo7/4e4LcpyQwut4rxoIQ00u0Zb4l8b5KdjOByV3jPap6KnKrxuUe9j/WFQ7TrELcon2UYtf1l1PTa8x4/3aRd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pl3hih9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pl3hih9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6B4C4CEC3;
	Thu, 17 Oct 2024 18:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191310;
	bh=2oC2CFF4EXxTbSdWcpiU8TM9dFnwQ0X2nxIRw8YH/6U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pl3hih9fCYzNH1oorePTsqE9/NJ4uybloLWmu7lkaFqGe12GFlw8cnTibg2ROEo80
	 r3nokY1oI+NVhFxqgCvIykb1csNl8H9j9JabXIdU4LMvbeY/WZhbwN/XqcBd8/XzVv
	 9VlOoSENZR6qKaYveCQfnwCUTEfU0vGLWOpfEXhqymrR4bfw1Hq0bhxBxYUtKdc6Jh
	 GeJzrWVEX29zbYRnZaKlmOPgfPQImpTq5RojYRmyRxlPiw99BpAtOmHiXp+g2Ndmuq
	 W1PYxmVjN1s0ydF0B11s87TR5/2U6M1mViY2Xn4J6EC4CjAFqHl9ZMcqVfsm2b1ypI
	 6PO25qdgutePw==
Date: Thu, 17 Oct 2024 11:55:09 -0700
Subject: [PATCH 03/29] xfs: rename metadata inode predicates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919069495.3451313.13697143366804161635.stgit@frogsfrogsfrogs>
In-Reply-To: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
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
index 0439f129629937..e09fd0ef4201f2 100644
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
index be7d4b26aaea3f..96e92409ca2523 100644
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

