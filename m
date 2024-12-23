Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E737462
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994771; cv=none; b=fjMiPDuPBMIQpzsMNa0BRHUtR6AXJpvoKBYRrQ3FeK5MTu+VZ95C5MHiLE+knSCjlro+mQb/D+j4PZiULY8aZuNkiLn1dFcUlg155IiXRRxdkOCPbhLlwEslkBrN9EBwtTFb+V72m5EA+4KFc5GRGRdKqa4KRNEq4GpoWz1jWQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994771; c=relaxed/simple;
	bh=iBUro0qC9LrR/iolhzYMkJInVOfKyYZvpM1n2q7uIfQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=alKK4S6OWTsCrhPOEE5fVLTeGTgyv0bAG+S8OQWulpJdvAlMQybcVMXCvFo+6PdD6ADnnTggKTK5ZEhco4MvAmBf1V7NxjS30AiETOnv6w0Uir4m4PxB5eFbkn1tecexANXZYmURG7UII78EU4VDpOzhPzUkhRXWb2n+fntDxeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DUQ9Jyju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DUQ9Jyju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F3EC4CED6;
	Mon, 23 Dec 2024 22:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994771;
	bh=iBUro0qC9LrR/iolhzYMkJInVOfKyYZvpM1n2q7uIfQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DUQ9JyjuOuxXlgksMK1GaSt/+1GQYjETQXbG0X62szqGIt1oJ2tLBtHMiN/o+BvPc
	 VBlT3ms7mKI96tCDGAeEyPk3GCt4jfDJ2zgSYHsBNqpksmVbw/rDpE5y1WKEK9YjU5
	 m3ZN9AneNEOqoROR8bkG6agAJXY4XVnI8xwr+gWJbpyCxGhqjUZOpI+I5YG77yuXSK
	 pZjp6K+xdLy31jCYMZiLcQct4hKekm4KtAijGYnwcjf5k3y72C9UwJkgn/Y4+se8tm
	 fT3gmKkt8i5sCHEk567Bs733nz/1KzDhHajFzMfG5xJZddmlCMeLo8qXla4nCr7iXd
	 I/IyTF6QzPStQ==
Date: Mon, 23 Dec 2024 14:59:31 -0800
Subject: [PATCH 11/37] xfs: support file data forks containing metadata btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499418904.2380130.1036377006459432588.stgit@frogsfrogsfrogs>
In-Reply-To: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
References: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a new fork format type for metadata btrees.  This fork type
requires that the inode is in the metadata directory tree, and only
applies to the data fork.  The actual type of the metadata btree itself
is determined by the di_metatype field.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h      |    6 ++++--
 fs/xfs/libxfs/xfs_inode_buf.c   |   23 ++++++++++++++++++++--
 fs/xfs/libxfs/xfs_inode_fork.c  |   19 +++++++++++++++++++
 fs/xfs/scrub/bmap.c             |    1 +
 fs/xfs/scrub/bmap_repair.c      |    1 +
 fs/xfs/scrub/inode.c            |    4 ++++
 fs/xfs/scrub/inode_repair.c     |   36 +++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rmap_repair.c      |   31 ++++++++++++++++++++----------
 fs/xfs/xfs_inode.c              |   19 ++++++++++++++++++-
 fs/xfs/xfs_inode_item.c         |    2 ++
 fs/xfs/xfs_inode_item_recover.c |   40 ++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_trace.h              |    1 +
 12 files changed, 162 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 469fc7afa591b4..41ea4283c43cb4 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -997,7 +997,8 @@ enum xfs_dinode_fmt {
 	XFS_DINODE_FMT_LOCAL,		/* bulk data */
 	XFS_DINODE_FMT_EXTENTS,		/* struct xfs_bmbt_rec */
 	XFS_DINODE_FMT_BTREE,		/* struct xfs_bmdr_block */
-	XFS_DINODE_FMT_UUID		/* added long ago, but never used */
+	XFS_DINODE_FMT_UUID,		/* added long ago, but never used */
+	XFS_DINODE_FMT_META_BTREE,	/* metadata btree */
 };
 
 #define XFS_INODE_FORMAT_STR \
@@ -1005,7 +1006,8 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_LOCAL,		"local" }, \
 	{ XFS_DINODE_FMT_EXTENTS,	"extent" }, \
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
-	{ XFS_DINODE_FMT_UUID,		"uuid" }
+	{ XFS_DINODE_FMT_UUID,		"uuid" }, \
+	{ XFS_DINODE_FMT_META_BTREE,	"meta_btree" }
 
 /*
  * Max values for extnum and aextnum.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 424861fbf1bd49..1648d72d6ed95a 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -441,6 +441,16 @@ xfs_dinode_verify_fork(
 		if (di_nextents > max_extents)
 			return __this_address;
 		break;
+	case XFS_DINODE_FMT_META_BTREE:
+		if (!xfs_has_metadir(mp))
+			return __this_address;
+		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)))
+			return __this_address;
+		switch (be16_to_cpu(dip->di_metatype)) {
+		default:
+			return __this_address;
+		}
+		break;
 	default:
 		return __this_address;
 	}
@@ -460,6 +470,10 @@ xfs_dinode_verify_forkoff(
 		if (dip->di_forkoff != (roundup(sizeof(xfs_dev_t), 8) >> 3))
 			return __this_address;
 		break;
+	case XFS_DINODE_FMT_META_BTREE:
+		if (!xfs_has_metadir(mp) || !xfs_has_parent(mp))
+			return __this_address;
+		fallthrough;
 	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
 	case XFS_DINODE_FMT_EXTENTS:    /* fall through ... */
 	case XFS_DINODE_FMT_BTREE:
@@ -637,9 +651,6 @@ xfs_dinode_verify(
 	if (mode && nextents + naextents > nblocks)
 		return __this_address;
 
-	if (nextents + naextents == 0 && nblocks != 0)
-		return __this_address;
-
 	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
 		return __this_address;
 
@@ -743,6 +754,12 @@ xfs_dinode_verify(
 			return fa;
 	}
 
+	/* metadata inodes containing btrees always have zero extent count */
+	if (XFS_DFORK_FORMAT(dip, XFS_DATA_FORK) != XFS_DINODE_FMT_META_BTREE) {
+		if (nextents + naextents == 0 && nblocks != 0)
+			return __this_address;
+	}
+
 	return NULL;
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 60853bac289a39..1a782339396dc3 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -267,6 +267,12 @@ xfs_iformat_data_fork(
 			return xfs_iformat_extents(ip, dip, XFS_DATA_FORK);
 		case XFS_DINODE_FMT_BTREE:
 			return xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
+		case XFS_DINODE_FMT_META_BTREE:
+			switch (ip->i_metatype) {
+			default:
+				break;
+			}
+			fallthrough;
 		default:
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
 					dip, sizeof(*dip), __this_address);
@@ -601,6 +607,19 @@ xfs_iflush_fork(
 		}
 		break;
 
+	case XFS_DINODE_FMT_META_BTREE:
+		ASSERT(whichfork == XFS_DATA_FORK);
+
+		if (!(iip->ili_fields & brootflag[whichfork]))
+			break;
+
+		switch (ip->i_metatype) {
+		default:
+			ASSERT(0);
+			break;
+		}
+		break;
+
 	default:
 		ASSERT(0);
 		break;
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 7e00312225ed10..0d7ad692822d48 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -983,6 +983,7 @@ xchk_bmap(
 	case XFS_DINODE_FMT_UUID:
 	case XFS_DINODE_FMT_DEV:
 	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_META_BTREE:
 		/* No mappings to check. */
 		if (whichfork == XFS_COW_FORK)
 			xchk_fblock_set_corrupt(sc, whichfork, 0);
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 7c4955482641f7..141d36f1da9a71 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -731,6 +731,7 @@ xrep_bmap_check_inputs(
 	case XFS_DINODE_FMT_DEV:
 	case XFS_DINODE_FMT_LOCAL:
 	case XFS_DINODE_FMT_UUID:
+	case XFS_DINODE_FMT_META_BTREE:
 		return -ECANCELED;
 	case XFS_DINODE_FMT_EXTENTS:
 	case XFS_DINODE_FMT_BTREE:
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 25ee66e7649d40..2e911f38deaebe 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -502,6 +502,10 @@ xchk_dinode(
 		if (!S_ISREG(mode) && !S_ISDIR(mode))
 			xchk_ino_set_corrupt(sc, ino);
 		break;
+	case XFS_DINODE_FMT_META_BTREE:
+		if (!S_ISREG(mode))
+			xchk_ino_set_corrupt(sc, ino);
+		break;
 	case XFS_DINODE_FMT_UUID:
 	default:
 		xchk_ino_set_corrupt(sc, ino);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 5a58ddd27bd2f5..7faa27472b9129 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -888,6 +888,25 @@ xrep_dinode_bad_bmbt_fork(
 	return false;
 }
 
+/* Check a metadata-btree fork. */
+STATIC bool
+xrep_dinode_bad_metabt_fork(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip,
+	unsigned int		dfork_size,
+	int			whichfork)
+{
+	if (whichfork != XFS_DATA_FORK)
+		return true;
+
+	switch (be16_to_cpu(dip->di_metatype)) {
+	default:
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Check the data fork for things that will fail the ifork verifiers or the
  * ifork formatters.
@@ -968,6 +987,11 @@ xrep_dinode_check_dfork(
 				XFS_DATA_FORK))
 			return true;
 		break;
+	case XFS_DINODE_FMT_META_BTREE:
+		if (xrep_dinode_bad_metabt_fork(sc, dip, dfork_size,
+				XFS_DATA_FORK))
+			return true;
+		break;
 	default:
 		return true;
 	}
@@ -1088,6 +1112,11 @@ xrep_dinode_check_afork(
 					XFS_ATTR_FORK))
 			return true;
 		break;
+	case XFS_DINODE_FMT_META_BTREE:
+		if (xrep_dinode_bad_metabt_fork(sc, dip, afork_size,
+					XFS_ATTR_FORK))
+			return true;
+		break;
 	default:
 		return true;
 	}
@@ -1241,6 +1270,13 @@ xrep_dinode_ensure_forkoff(
 		bmdr = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
 		dfork_min = xfs_bmap_broot_space(sc->mp, bmdr);
 		break;
+	case XFS_DINODE_FMT_META_BTREE:
+		switch (be16_to_cpu(dip->di_metatype)) {
+		default:
+			dfork_min = 0;
+			break;
+		}
+		break;
 	default:
 		dfork_min = 0;
 		break;
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index a0a227d183d28d..2a0b9e3d0fbaee 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -499,6 +499,14 @@ xrep_rmap_scan_iext(
 	return xrep_rmap_stash_accumulated(rf);
 }
 
+static int
+xrep_rmap_scan_meta_btree(
+	struct xrep_rmap_ifork	*rf,
+	struct xfs_inode	*ip)
+{
+	return -EFSCORRUPTED; /* XXX placeholder */
+}
+
 /* Find all the extents from a given AG in an inode fork. */
 STATIC int
 xrep_rmap_scan_ifork(
@@ -512,14 +520,14 @@ xrep_rmap_scan_ifork(
 		.whichfork	= whichfork,
 	};
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
+	bool			mappings_done;
 	int			error = 0;
 
 	if (!ifp)
 		return 0;
 
-	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
-		bool		mappings_done;
-
+	switch (ifp->if_format) {
+	case XFS_DINODE_FMT_BTREE:
 		/*
 		 * Scan the bmap btree for data device mappings.  This includes
 		 * the btree blocks themselves, even if this is a realtime
@@ -528,15 +536,18 @@ xrep_rmap_scan_ifork(
 		error = xrep_rmap_scan_bmbt(&rf, ip, &mappings_done);
 		if (error || mappings_done)
 			return error;
-	} else if (ifp->if_format != XFS_DINODE_FMT_EXTENTS) {
-		return 0;
+		fallthrough;
+	case XFS_DINODE_FMT_EXTENTS:
+		/* Scan incore extent cache if this isn't a realtime file. */
+		if (xfs_ifork_is_realtime(ip, whichfork))
+			return 0;
+
+		return xrep_rmap_scan_iext(&rf, ifp);
+	case XFS_DINODE_FMT_META_BTREE:
+		return xrep_rmap_scan_meta_btree(&rf, ip);
 	}
 
-	/* Scan incore extent cache if this isn't a realtime file. */
-	if (xfs_ifork_is_realtime(ip, whichfork))
-		return 0;
-
-	return xrep_rmap_scan_iext(&rf, ifp);
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c8ad2606f928b2..c95fe1b1de4e6f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2382,7 +2382,16 @@ xfs_iflush(
 			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
 		goto flush_out;
 	}
-	if (S_ISREG(VFS_I(ip)->i_mode)) {
+	if (ip->i_df.if_format == XFS_DINODE_FMT_META_BTREE) {
+		if (!S_ISREG(VFS_I(ip)->i_mode) ||
+		    !(ip->i_diflags2 & XFS_DIFLAG2_METADATA)) {
+			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+				"%s: Bad %s meta btree inode %Lu, ptr "PTR_FMT,
+				__func__, xfs_metafile_type_str(ip->i_metatype),
+				ip->i_ino, ip);
+			goto flush_out;
+		}
+	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
 		if (XFS_TEST_ERROR(
 		    ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
 		    ip->i_df.if_format != XFS_DINODE_FMT_BTREE,
@@ -2422,6 +2431,14 @@ xfs_iflush(
 		goto flush_out;
 	}
 
+	if (xfs_inode_has_attr_fork(ip) &&
+	    ip->i_af.if_format == XFS_DINODE_FMT_META_BTREE) {
+		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+			"%s: meta btree in inode %Lu attr fork, ptr "PTR_FMT,
+			__func__, ip->i_ino, ip);
+		goto flush_out;
+	}
+
 	/*
 	 * Inode item log recovery for v2 inodes are dependent on the flushiter
 	 * count for correct sequencing.  We bump the flush iteration count so
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 912f0b1bc3cb70..a174f64b8bb250 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -242,6 +242,7 @@ xfs_inode_item_data_fork_size(
 		}
 		break;
 	case XFS_DINODE_FMT_BTREE:
+	case XFS_DINODE_FMT_META_BTREE:
 		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
 		    ip->i_df.if_broot_bytes > 0) {
 			*nbytes += ip->i_df.if_broot_bytes;
@@ -362,6 +363,7 @@ xfs_inode_item_format_data_fork(
 		}
 		break;
 	case XFS_DINODE_FMT_BTREE:
+	case XFS_DINODE_FMT_META_BTREE:
 		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DEXT | XFS_ILOG_DEV);
 
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index e70d2611456bc9..6e9b3bfc718c0b 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -266,6 +266,35 @@ xlog_dinode_verify_extent_counts(
 	return 0;
 }
 
+static inline int
+xlog_recover_inode_dbroot(
+	struct xfs_mount	*mp,
+	void			*src,
+	unsigned int		len,
+	struct xfs_dinode	*dip)
+{
+	void			*dfork = XFS_DFORK_DPTR(dip);
+	unsigned int		dsize = XFS_DFORK_DSIZE(dip, mp);
+
+	switch (dip->di_format) {
+	case XFS_DINODE_FMT_BTREE:
+		xfs_bmbt_to_bmdr(mp, src, len, dfork, dsize);
+		break;
+	case XFS_DINODE_FMT_META_BTREE:
+		switch (be16_to_cpu(dip->di_metatype)) {
+		default:
+			ASSERT(0);
+			return -EFSCORRUPTED;
+		}
+		break;
+	default:
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
 STATIC int
 xlog_recover_inode_commit_pass2(
 	struct xlog			*log,
@@ -393,8 +422,9 @@ xlog_recover_inode_commit_pass2(
 
 
 	if (unlikely(S_ISREG(ldip->di_mode))) {
-		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
-		    (ldip->di_format != XFS_DINODE_FMT_BTREE)) {
+		if (ldip->di_format != XFS_DINODE_FMT_EXTENTS &&
+		    ldip->di_format != XFS_DINODE_FMT_BTREE &&
+		    ldip->di_format != XFS_DINODE_FMT_META_BTREE) {
 			XFS_CORRUPTION_ERROR(
 				"Bad log dinode data fork format for regular file",
 				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
@@ -475,9 +505,9 @@ xlog_recover_inode_commit_pass2(
 		break;
 
 	case XFS_ILOG_DBROOT:
-		xfs_bmbt_to_bmdr(mp, (struct xfs_btree_block *)src, len,
-				 (struct xfs_bmdr_block *)XFS_DFORK_DPTR(dip),
-				 XFS_DFORK_DSIZE(dip, mp));
+		error = xlog_recover_inode_dbroot(mp, src, len, dip);
+		if (error)
+			goto out_release;
 		break;
 
 	default:
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8b7bb1f5ae3c6f..a098935163b7c2 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2299,6 +2299,7 @@ TRACE_DEFINE_ENUM(XFS_DINODE_FMT_LOCAL);
 TRACE_DEFINE_ENUM(XFS_DINODE_FMT_EXTENTS);
 TRACE_DEFINE_ENUM(XFS_DINODE_FMT_BTREE);
 TRACE_DEFINE_ENUM(XFS_DINODE_FMT_UUID);
+TRACE_DEFINE_ENUM(XFS_DINODE_FMT_META_BTREE);
 
 DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 	TP_PROTO(struct xfs_inode *ip, int which),

