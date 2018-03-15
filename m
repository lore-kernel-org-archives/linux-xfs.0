Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51664 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751362AbeCOAaR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 20:30:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2F0R4p8095152
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:30:17 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2gqdm702p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:30:17 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2F0UFBc008112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:30:16 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2F0UFfj026916
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:30:15 GMT
Subject: [PATCH 7/9] xfs: remove xfs_buf parameter from inode scrub methods
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 14 Mar 2018 17:30:13 -0700
Message-ID: <152107381362.19571.9576830486159390552.stgit@magnolia>
In-Reply-To: <152107377037.19571.8618901963505842632.stgit@magnolia>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we no longer do raw inode buffer scrubbing, the bp parameter is
no longer used anywhere we're dealing with an inode, so remove it and
all the useless NULL parameters that go with it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/attr.c     |    2 -
 fs/xfs/scrub/bmap.c     |    4 +-
 fs/xfs/scrub/common.c   |   22 ++++------
 fs/xfs/scrub/common.h   |   13 ++----
 fs/xfs/scrub/dir.c      |    2 -
 fs/xfs/scrub/inode.c    |  106 ++++++++++++++++++++++-------------------------
 fs/xfs/scrub/quota.c    |    2 -
 fs/xfs/scrub/rtbitmap.c |    3 -
 fs/xfs/scrub/trace.h    |   31 ++------------
 9 files changed, 74 insertions(+), 111 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 4ed8047..127575f 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -98,7 +98,7 @@ xfs_scrub_xattr_listent(
 
 	if (flags & XFS_ATTR_INCOMPLETE) {
 		/* Incomplete attr key, just mark the inode for preening. */
-		xfs_scrub_ino_set_preen(sx->sc, context->dp->i_ino, NULL);
+		xfs_scrub_ino_set_preen(sx->sc, context->dp->i_ino);
 		return;
 	}
 
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 2f38add..23556ca 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -615,7 +615,7 @@ xfs_scrub_bmap(
 			goto out;
 		/* No CoW forks on non-reflink inodes/filesystems. */
 		if (!xfs_is_reflink_inode(ip)) {
-			xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino, NULL);
+			xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
 			goto out;
 		}
 		break;
@@ -624,7 +624,7 @@ xfs_scrub_bmap(
 			goto out_check_rmap;
 		if (!xfs_sb_version_hasattr(&mp->m_sb) &&
 		    !xfs_sb_version_hasattr2(&mp->m_sb))
-			xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino, NULL);
+			xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
 		break;
 	default:
 		ASSERT(whichfork == XFS_DATA_FORK);
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 8033ab9..fe3a2b1 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -213,12 +213,10 @@ xfs_scrub_block_set_preen(
 void
 xfs_scrub_ino_set_preen(
 	struct xfs_scrub_context	*sc,
-	xfs_ino_t			ino,
-	struct xfs_buf			*bp)
+	xfs_ino_t			ino)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
-	trace_xfs_scrub_ino_preen(sc, ino, bp ? bp->b_bn : 0,
-			__return_address);
+	trace_xfs_scrub_ino_preen(sc, ino, __return_address);
 }
 
 /* Record a corrupt block. */
@@ -249,22 +247,20 @@ xfs_scrub_block_xref_set_corrupt(
 void
 xfs_scrub_ino_set_corrupt(
 	struct xfs_scrub_context	*sc,
-	xfs_ino_t			ino,
-	struct xfs_buf			*bp)
+	xfs_ino_t			ino)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
-	trace_xfs_scrub_ino_error(sc, ino, bp ? bp->b_bn : 0, __return_address);
+	trace_xfs_scrub_ino_error(sc, ino, __return_address);
 }
 
 /* Record a corruption while cross-referencing with an inode. */
 void
 xfs_scrub_ino_xref_set_corrupt(
 	struct xfs_scrub_context	*sc,
-	xfs_ino_t			ino,
-	struct xfs_buf			*bp)
+	xfs_ino_t			ino)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
-	trace_xfs_scrub_ino_error(sc, ino, bp ? bp->b_bn : 0, __return_address);
+	trace_xfs_scrub_ino_error(sc, ino, __return_address);
 }
 
 /* Record corruption in a block indexed by a file fork. */
@@ -296,12 +292,10 @@ xfs_scrub_fblock_xref_set_corrupt(
 void
 xfs_scrub_ino_set_warning(
 	struct xfs_scrub_context	*sc,
-	xfs_ino_t			ino,
-	struct xfs_buf			*bp)
+	xfs_ino_t			ino)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_WARNING;
-	trace_xfs_scrub_ino_warning(sc, ino, bp ? bp->b_bn : 0,
-			__return_address);
+	trace_xfs_scrub_ino_warning(sc, ino, __return_address);
 }
 
 /* Warn about a block indexed by a file fork that needs review. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index ddb65d2..deaf604 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -63,25 +63,22 @@ bool xfs_scrub_fblock_xref_process_error(struct xfs_scrub_context *sc,
 
 void xfs_scrub_block_set_preen(struct xfs_scrub_context *sc,
 		struct xfs_buf *bp);
-void xfs_scrub_ino_set_preen(struct xfs_scrub_context *sc, xfs_ino_t ino,
-		struct xfs_buf *bp);
+void xfs_scrub_ino_set_preen(struct xfs_scrub_context *sc, xfs_ino_t ino);
 
 void xfs_scrub_block_set_corrupt(struct xfs_scrub_context *sc,
 		struct xfs_buf *bp);
-void xfs_scrub_ino_set_corrupt(struct xfs_scrub_context *sc, xfs_ino_t ino,
-		struct xfs_buf *bp);
+void xfs_scrub_ino_set_corrupt(struct xfs_scrub_context *sc, xfs_ino_t ino);
 void xfs_scrub_fblock_set_corrupt(struct xfs_scrub_context *sc, int whichfork,
 		xfs_fileoff_t offset);
 
 void xfs_scrub_block_xref_set_corrupt(struct xfs_scrub_context *sc,
 		struct xfs_buf *bp);
-void xfs_scrub_ino_xref_set_corrupt(struct xfs_scrub_context *sc, xfs_ino_t ino,
-		struct xfs_buf *bp);
+void xfs_scrub_ino_xref_set_corrupt(struct xfs_scrub_context *sc,
+		xfs_ino_t ino);
 void xfs_scrub_fblock_xref_set_corrupt(struct xfs_scrub_context *sc,
 		int whichfork, xfs_fileoff_t offset);
 
-void xfs_scrub_ino_set_warning(struct xfs_scrub_context *sc, xfs_ino_t ino,
-		struct xfs_buf *bp);
+void xfs_scrub_ino_set_warning(struct xfs_scrub_context *sc, xfs_ino_t ino);
 void xfs_scrub_fblock_set_warning(struct xfs_scrub_context *sc, int whichfork,
 		xfs_fileoff_t offset);
 
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 50b6a26..38f2980 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -781,7 +781,7 @@ xfs_scrub_directory(
 
 	/* Plausible size? */
 	if (sc->ip->i_d.di_size < xfs_dir2_sf_hdr_size(0)) {
-		xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino, NULL);
+		xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
 		goto out;
 	}
 
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 0332a01..9eadca9 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -98,7 +98,6 @@ xfs_scrub_setup_inode(
 STATIC void
 xfs_scrub_inode_extsize(
 	struct xfs_scrub_context	*sc,
-	struct xfs_buf			*bp,
 	struct xfs_dinode		*dip,
 	xfs_ino_t			ino,
 	uint16_t			mode,
@@ -149,7 +148,7 @@ xfs_scrub_inode_extsize(
 
 	return;
 bad:
-	xfs_scrub_ino_set_corrupt(sc, ino, bp);
+	xfs_scrub_ino_set_corrupt(sc, ino);
 }
 
 /*
@@ -161,7 +160,6 @@ xfs_scrub_inode_extsize(
 STATIC void
 xfs_scrub_inode_cowextsize(
 	struct xfs_scrub_context	*sc,
-	struct xfs_buf			*bp,
 	struct xfs_dinode		*dip,
 	xfs_ino_t			ino,
 	uint16_t			mode,
@@ -205,14 +203,13 @@ xfs_scrub_inode_cowextsize(
 
 	return;
 bad:
-	xfs_scrub_ino_set_corrupt(sc, ino, bp);
+	xfs_scrub_ino_set_corrupt(sc, ino);
 }
 
 /* Make sure the di_flags make sense for the inode. */
 STATIC void
 xfs_scrub_inode_flags(
 	struct xfs_scrub_context	*sc,
-	struct xfs_buf			*bp,
 	struct xfs_dinode		*dip,
 	xfs_ino_t			ino,
 	uint16_t			mode,
@@ -251,14 +248,13 @@ xfs_scrub_inode_flags(
 
 	return;
 bad:
-	xfs_scrub_ino_set_corrupt(sc, ino, bp);
+	xfs_scrub_ino_set_corrupt(sc, ino);
 }
 
 /* Make sure the di_flags2 make sense for the inode. */
 STATIC void
 xfs_scrub_inode_flags2(
 	struct xfs_scrub_context	*sc,
-	struct xfs_buf			*bp,
 	struct xfs_dinode		*dip,
 	xfs_ino_t			ino,
 	uint16_t			mode,
@@ -295,14 +291,13 @@ xfs_scrub_inode_flags2(
 
 	return;
 bad:
-	xfs_scrub_ino_set_corrupt(sc, ino, bp);
+	xfs_scrub_ino_set_corrupt(sc, ino);
 }
 
 /* Scrub all the ondisk inode fields. */
 STATIC void
 xfs_scrub_dinode(
 	struct xfs_scrub_context	*sc,
-	struct xfs_buf			*bp,
 	struct xfs_dinode		*dip,
 	xfs_ino_t			ino)
 {
@@ -333,7 +328,7 @@ xfs_scrub_dinode(
 		/* mode is recognized */
 		break;
 	default:
-		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		xfs_scrub_ino_set_corrupt(sc, ino);
 		break;
 	}
 
@@ -344,22 +339,22 @@ xfs_scrub_dinode(
 		 * We autoconvert v1 inodes into v2 inodes on writeout,
 		 * so just mark this inode for preening.
 		 */
-		xfs_scrub_ino_set_preen(sc, ino, bp);
+		xfs_scrub_ino_set_preen(sc, ino);
 		break;
 	case 2:
 	case 3:
 		if (dip->di_onlink != 0)
-			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+			xfs_scrub_ino_set_corrupt(sc, ino);
 
 		if (dip->di_mode == 0 && sc->ip)
-			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+			xfs_scrub_ino_set_corrupt(sc, ino);
 
 		if (dip->di_projid_hi != 0 &&
 		    !xfs_sb_version_hasprojid32bit(&mp->m_sb))
-			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+			xfs_scrub_ino_set_corrupt(sc, ino);
 		break;
 	default:
-		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		xfs_scrub_ino_set_corrupt(sc, ino);
 		return;
 	}
 
@@ -369,40 +364,40 @@ xfs_scrub_dinode(
 	 */
 	if (dip->di_uid == cpu_to_be32(-1U) ||
 	    dip->di_gid == cpu_to_be32(-1U))
-		xfs_scrub_ino_set_warning(sc, ino, bp);
+		xfs_scrub_ino_set_warning(sc, ino);
 
 	/* di_format */
 	switch (dip->di_format) {
 	case XFS_DINODE_FMT_DEV:
 		if (!S_ISCHR(mode) && !S_ISBLK(mode) &&
 		    !S_ISFIFO(mode) && !S_ISSOCK(mode))
-			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+			xfs_scrub_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_LOCAL:
 		if (!S_ISDIR(mode) && !S_ISLNK(mode))
-			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+			xfs_scrub_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
 		if (!S_ISREG(mode) && !S_ISDIR(mode) && !S_ISLNK(mode))
-			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+			xfs_scrub_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		if (!S_ISREG(mode) && !S_ISDIR(mode))
-			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+			xfs_scrub_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_UUID:
 	default:
-		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		xfs_scrub_ino_set_corrupt(sc, ino);
 		break;
 	}
 
 	/* di_[amc]time.nsec */
 	if (be32_to_cpu(dip->di_atime.t_nsec) >= NSEC_PER_SEC)
-		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		xfs_scrub_ino_set_corrupt(sc, ino);
 	if (be32_to_cpu(dip->di_mtime.t_nsec) >= NSEC_PER_SEC)
-		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		xfs_scrub_ino_set_corrupt(sc, ino);
 	if (be32_to_cpu(dip->di_ctime.t_nsec) >= NSEC_PER_SEC)
-		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		xfs_scrub_ino_set_corrupt(sc, ino);
 
 	/*
 	 * di_size.  xfs_dinode_verify checks for things that screw up
@@ -411,19 +406,19 @@ xfs_scrub_dinode(
 	 */
 	isize = be64_to_cpu(dip->di_size);
 	if (isize & (1ULL << 63))
-		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		xfs_scrub_ino_set_corrupt(sc, ino);
 
 	/* Devices, fifos, and sockets must have zero size */
 	if (!S_ISDIR(mode) && !S_ISREG(mode) && !S_ISLNK(mode) && isize != 0)
-		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		xfs_scrub_ino_set_corrupt(sc, ino);
 
 	/* Directories can't be larger than the data section size (32G) */
 	if (S_ISDIR(mode) && (isize == 0 || isize >= XFS_DIR2_SPACE_SIZE))
-		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		xfs_scrub_ino_set_corrupt(sc, ino);
 
 	/* Symlinks can't be larger than SYMLINK_MAXLEN */
 	if (S_ISLNK(mode) && (isize == 0 || isize >= XFS_SYMLINK_MAXLEN))
-		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		xfs_scrub_ino_set_corrupt(sc, ino);
 
 	/*
 	 * Warn if the running kernel can't handle the kinds of offsets
@@ -432,7 +427,7 @@ xfs_scrub_dinode(
 	 * overly large offsets, flag the inode for admin review.
 	 */
 	if (isize >= mp->m_super->s_maxbytes)
-		xfs_scrub_ino_set_warning(sc, ino, bp);
+		xfs_scrub_ino_set_warning(sc, ino);
 
 	/* di_nblocks */
 	if (flags2 & XFS_DIFLAG2_REFLINK) {
@@ -447,15 +442,15 @@ xfs_scrub_dinode(
 		 */
 		if (be64_to_cpu(dip->di_nblocks) >=
 		    mp->m_sb.sb_dblocks + mp->m_sb.sb_rblocks)
-			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+			xfs_scrub_ino_set_corrupt(sc, ino);
 	} else {
 		if (be64_to_cpu(dip->di_nblocks) >= mp->m_sb.sb_dblocks)
-			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+			xfs_scrub_ino_set_corrupt(sc, ino);
 	}
 
-	xfs_scrub_inode_flags(sc, bp, dip, ino, mode, flags);
+	xfs_scrub_inode_flags(sc, dip, ino, mode, flags);
 
-	xfs_scrub_inode_extsize(sc, bp, dip, ino, mode, flags);
+	xfs_scrub_inode_extsize(sc, dip, ino, mode, flags);
 
 	/* di_nextents */
 	nextents = be32_to_cpu(dip->di_nextents);
@@ -463,31 +458,31 @@ xfs_scrub_dinode(
 	switch (dip->di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		if (nextents > fork_recs)
-			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+			xfs_scrub_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		if (nextents <= fork_recs)
-			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+			xfs_scrub_ino_set_corrupt(sc, ino);
 		break;
 	default:
 		if (nextents != 0)
-			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+			xfs_scrub_ino_set_corrupt(sc, ino);
 		break;
 	}
 
 	/* di_forkoff */
 	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
-		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		xfs_scrub_ino_set_corrupt(sc, ino);
 	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
-		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		xfs_scrub_ino_set_corrupt(sc, ino);
 	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
-		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		xfs_scrub_ino_set_corrupt(sc, ino);
 
 	/* di_aformat */
 	if (dip->di_aformat != XFS_DINODE_FMT_LOCAL &&
 	    dip->di_aformat != XFS_DINODE_FMT_EXTENTS &&
 	    dip->di_aformat != XFS_DINODE_FMT_BTREE)
-		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		xfs_scrub_ino_set_corrupt(sc, ino);
 
 	/* di_anextents */
 	nextents = be16_to_cpu(dip->di_anextents);
@@ -495,22 +490,22 @@ xfs_scrub_dinode(
 	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
 		if (nextents > fork_recs)
-			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+			xfs_scrub_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		if (nextents <= fork_recs)
-			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+			xfs_scrub_ino_set_corrupt(sc, ino);
 		break;
 	default:
 		if (nextents != 0)
-			xfs_scrub_ino_set_corrupt(sc, ino, bp);
+			xfs_scrub_ino_set_corrupt(sc, ino);
 	}
 
 	if (dip->di_version >= 3) {
 		if (be32_to_cpu(dip->di_crtime.t_nsec) >= NSEC_PER_SEC)
-			xfs_scrub_ino_set_corrupt(sc, ino, bp);
-		xfs_scrub_inode_flags2(sc, bp, dip, ino, mode, flags, flags2);
-		xfs_scrub_inode_cowextsize(sc, bp, dip, ino, mode, flags,
+			xfs_scrub_ino_set_corrupt(sc, ino);
+		xfs_scrub_inode_flags2(sc, dip, ino, mode, flags, flags2);
+		xfs_scrub_inode_cowextsize(sc, dip, ino, mode, flags,
 				flags2);
 	}
 }
@@ -579,18 +574,18 @@ xfs_scrub_inode_xref_bmap(
 	if (!xfs_scrub_should_check_xref(sc, &error, NULL))
 		return;
 	if (nextents < be32_to_cpu(dip->di_nextents))
-		xfs_scrub_ino_xref_set_corrupt(sc, sc->ip->i_ino, NULL);
+		xfs_scrub_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
 			&nextents, &acount);
 	if (!xfs_scrub_should_check_xref(sc, &error, NULL))
 		return;
 	if (nextents != be16_to_cpu(dip->di_anextents))
-		xfs_scrub_ino_xref_set_corrupt(sc, sc->ip->i_ino, NULL);
+		xfs_scrub_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	/* Check nblocks against the inode. */
 	if (count + acount != be64_to_cpu(dip->di_nblocks))
-		xfs_scrub_ino_xref_set_corrupt(sc, sc->ip->i_ino, NULL);
+		xfs_scrub_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 }
 
 /* Cross-reference with the other btrees. */
@@ -634,8 +629,7 @@ xfs_scrub_inode_xref(
 static void
 xfs_scrub_inode_check_reflink_iflag(
 	struct xfs_scrub_context	*sc,
-	xfs_ino_t			ino,
-	struct xfs_buf			*bp)
+	xfs_ino_t			ino)
 {
 	struct xfs_mount		*mp = sc->mp;
 	bool				has_shared;
@@ -650,9 +644,9 @@ xfs_scrub_inode_check_reflink_iflag(
 			XFS_INO_TO_AGBNO(mp, ino), &error))
 		return;
 	if (xfs_is_reflink_inode(sc->ip) && !has_shared)
-		xfs_scrub_ino_set_preen(sc, ino, bp);
+		xfs_scrub_ino_set_preen(sc, ino);
 	else if (!xfs_is_reflink_inode(sc->ip) && has_shared)
-		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		xfs_scrub_ino_set_corrupt(sc, ino);
 }
 
 /* Scrub an inode. */
@@ -665,13 +659,13 @@ xfs_scrub_inode(
 
 	/* iget failed means automatic fail. */
 	if (!sc->ip) {
-		xfs_scrub_ino_set_corrupt(sc, sc->sm->sm_ino, NULL);
+		xfs_scrub_ino_set_corrupt(sc, sc->sm->sm_ino);
 		return 0;
 	}
 
 	/* Scrub the inode core. */
 	xfs_inode_to_disk(sc->ip, &di, 0);
-	xfs_scrub_dinode(sc, NULL, &di, sc->ip->i_ino);
+	xfs_scrub_dinode(sc, &di, sc->ip->i_ino);
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
 
@@ -681,7 +675,7 @@ xfs_scrub_inode(
 	 * we scrubbed the dinode.
 	 */
 	if (S_ISREG(VFS_I(sc->ip)->i_mode))
-		xfs_scrub_inode_check_reflink_iflag(sc, sc->ip->i_ino, NULL);
+		xfs_scrub_inode_check_reflink_iflag(sc, sc->ip->i_ino);
 
 	xfs_scrub_inode_xref(sc, sc->ip->i_ino, &di);
 out:
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 51daa4a..6ba465e 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -219,7 +219,7 @@ xfs_scrub_quota(
 	/* Look for problem extents. */
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (ip->i_d.di_flags & XFS_DIFLAG_REALTIME) {
-		xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino, NULL);
+		xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
 		goto out_unlock_inode;
 	}
 	max_dqid_off = ((xfs_dqid_t)-1) / qi->qi_dqperchunk;
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 2639099..39c41dfe 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -116,8 +116,7 @@ xfs_scrub_xref_is_used_rt_space(
 	if (!xfs_scrub_should_check_xref(sc, &error, NULL))
 		goto out_unlock;
 	if (is_free)
-		xfs_scrub_ino_xref_set_corrupt(sc, sc->mp->m_rbmip->i_ino,
-				NULL);
+		xfs_scrub_ino_xref_set_corrupt(sc, sc->mp->m_rbmip->i_ino);
 out_unlock:
 	xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 }
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 4dc8968..5d2b1c2 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -174,53 +174,32 @@ DEFINE_SCRUB_BLOCK_ERROR_EVENT(xfs_scrub_block_error);
 DEFINE_SCRUB_BLOCK_ERROR_EVENT(xfs_scrub_block_preen);
 
 DECLARE_EVENT_CLASS(xfs_scrub_ino_error_class,
-	TP_PROTO(struct xfs_scrub_context *sc, xfs_ino_t ino, xfs_daddr_t daddr,
-		 void *ret_ip),
-	TP_ARGS(sc, ino, daddr, ret_ip),
+	TP_PROTO(struct xfs_scrub_context *sc, xfs_ino_t ino, void *ret_ip),
+	TP_ARGS(sc, ino, ret_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(unsigned int, type)
-		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, bno)
 		__field(void *, ret_ip)
 	),
 	TP_fast_assign(
-		xfs_fsblock_t	fsbno;
-		xfs_agnumber_t	agno;
-		xfs_agblock_t	bno;
-
-		if (daddr) {
-			fsbno = XFS_DADDR_TO_FSB(sc->mp, daddr);
-			agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
-			bno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
-		} else {
-			agno = XFS_INO_TO_AGNO(sc->mp, ino);
-			bno = XFS_AGINO_TO_AGBNO(sc->mp,
-					XFS_INO_TO_AGINO(sc->mp, ino));
-		}
-
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->ino = ino;
 		__entry->type = sc->sm->sm_type;
-		__entry->agno = agno;
-		__entry->bno = bno;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx type %u agno %u agbno %u ret_ip %pS",
+	TP_printk("dev %d:%d ino 0x%llx type %u ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->type,
-		  __entry->agno,
-		  __entry->bno,
 		  __entry->ret_ip)
 )
 
 #define DEFINE_SCRUB_INO_ERROR_EVENT(name) \
 DEFINE_EVENT(xfs_scrub_ino_error_class, name, \
 	TP_PROTO(struct xfs_scrub_context *sc, xfs_ino_t ino, \
-		 xfs_daddr_t daddr, void *ret_ip), \
-	TP_ARGS(sc, ino, daddr, ret_ip))
+		 void *ret_ip), \
+	TP_ARGS(sc, ino, ret_ip))
 
 DEFINE_SCRUB_INO_ERROR_EVENT(xfs_scrub_ino_error);
 DEFINE_SCRUB_INO_ERROR_EVENT(xfs_scrub_ino_preen);

