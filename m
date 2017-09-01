Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47544 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752537AbdIAWWD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 18:22:03 -0400
Date: Fri, 1 Sep 2017 15:21:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] misc: fix more stupid compiler warnings
Message-ID: <20170901222157.GL3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

Fix more compiler warnings about pointless checks, unchecked return
values, brace problems, and missing parentheses.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c           |    2 --
 libxfs/init.c        |   17 ++++++++++++-----
 libxfs/libxfs_priv.h |    4 ++--
 libxfs/xfs_bmap.c    |    2 +-
 repair/phase6.c      |    4 ++--
 repair/rmap.c        |    2 +-
 6 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/db/check.c b/db/check.c
index 12a0aed..6076540 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3220,9 +3220,7 @@ process_leaf_node_dir_v2_free(
 		return;
 	}
 	if (be32_to_cpu(free->hdr.nvalid) > maxent ||
-				be32_to_cpu(free->hdr.nvalid) < 0 ||
 				be32_to_cpu(free->hdr.nused) > maxent ||
-				be32_to_cpu(free->hdr.nused) < 0 ||
 				be32_to_cpu(free->hdr.nused) >
 					be32_to_cpu(free->hdr.nvalid)) {
 		if (!sflag || v)
diff --git a/libxfs/init.c b/libxfs/init.c
index d77a9e6..2479220 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -262,7 +262,10 @@ libxfs_init(libxfs_init_t *a)
 	a->dsize = a->lbsize = a->rtbsize = 0;
 	a->dbsize = a->logBBsize = a->logBBstart = a->rtsize = 0;
 
-	(void)getcwd(curdir,MAXPATHLEN);
+	if (!getcwd(curdir, MAXPATHLEN)) {
+		perror("getcwd");
+		strcpy(curdir, ".");
+	}
 	needcd = 0;
 	fd = -1;
 	flags = (a->isreadonly | a->isdirect);
@@ -284,7 +287,8 @@ libxfs_init(libxfs_init_t *a)
 	}
 	if (dname) {
 		if (dname[0] != '/' && needcd)
-			chdir(curdir);
+			if (chdir(curdir))
+				perror(curdir);
 		if (a->disfile) {
 			a->ddev= libxfs_device_open(dname, a->dcreat, flags,
 						    a->setblksize);
@@ -305,7 +309,8 @@ libxfs_init(libxfs_init_t *a)
 		a->dsize = 0;
 	if (logname) {
 		if (logname[0] != '/' && needcd)
-			chdir(curdir);
+			if (chdir(curdir))
+				perror(curdir);
 		if (a->lisfile) {
 			a->logdev = libxfs_device_open(logname,
 					a->lcreat, flags, a->setblksize);
@@ -326,7 +331,8 @@ libxfs_init(libxfs_init_t *a)
 		a->logBBsize = 0;
 	if (rtname) {
 		if (rtname[0] != '/' && needcd)
-			chdir(curdir);
+			if (chdir(curdir))
+				perror(curdir);
 		if (a->risfile) {
 			a->rtdev = libxfs_device_open(rtname,
 					a->rcreat, flags, a->setblksize);
@@ -361,7 +367,8 @@ libxfs_init(libxfs_init_t *a)
 		goto done;
 	}
 	if (needcd)
-		chdir(curdir);
+		if (chdir(curdir))
+			perror(curdir);
 	if (!libxfs_bhash_size)
 		libxfs_bhash_size = LIBXFS_BHASHSIZE(sbp);
 	libxfs_bcache = cache_init(a->bcache_flags, libxfs_bhash_size,
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 19bdbdb..94804fe 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -504,8 +504,8 @@ int libxfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 bool xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 
 /* xfs_icache.c */
-#define xfs_inode_set_cowblocks_tag(ip)
-#define xfs_inode_set_eofblocks_tag(ip)
+#define xfs_inode_set_cowblocks_tag(ip)	do { } while (0)
+#define xfs_inode_set_eofblocks_tag(ip)	do { } while (0)
 
 /* xfs_stats.h */
 #define XFS_STATS_CALC_INDEX(member)	0
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 31a631a..ab5853d 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -570,7 +570,7 @@ xfs_bmap_validate_ret(
 
 #else
 #define xfs_bmap_check_leaf_extents(cur, ip, whichfork)		do { } while (0)
-#define	xfs_bmap_validate_ret(bno,len,flags,mval,onmap,nmap)
+#define	xfs_bmap_validate_ret(bno,len,flags,mval,onmap,nmap)	do { } while (0)
 #endif /* DEBUG */
 
 /*
diff --git a/repair/phase6.c b/repair/phase6.c
index b051a44..f360aed 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3092,11 +3092,11 @@ mark_standalone_inodes(xfs_mount_t *mp)
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rsumino),
 			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rsumino));
 
+	ASSERT(irec != NULL);
+
 	offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rsumino) -
 			irec->ino_startnum;
 
-	ASSERT(irec != NULL);
-
 	add_inode_reached(irec, offset);
 
 	if (fs_quotas)  {
diff --git a/repair/rmap.c b/repair/rmap.c
index 9710565..07d1ba8 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1542,7 +1542,7 @@ rmap_populate_realtime_rmapbt(
 		imap.br_startoff = rm_rec->rm_offset;
 		imap.br_startblock = rm_rec->rm_startblock;
 		imap.br_blockcount = rm_rec->rm_blockcount;
-		imap.br_state = (rm_rec->rm_flags & XFS_RMAP_UNWRITTEN ?
+		imap.br_state = ((rm_rec->rm_flags & XFS_RMAP_UNWRITTEN) ?
 				XFS_EXT_UNWRITTEN : XFS_EXT_NORM);
 		fakei.i_ino = rm_rec->rm_owner;
 		error = -libxfs_rmap_map_extent(mp, &dfops, &fakei,
