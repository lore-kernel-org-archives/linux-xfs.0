Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54416 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfFTQuG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:50:06 -0400
Subject: [PATCH 05/12] libfrog: store more inode and block geometry in
 struct xfrog
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 20 Jun 2019 09:50:01 -0700
Message-ID: <156104940145.1172531.5596841620134065896.stgit@magnolia>
In-Reply-To: <156104936953.1172531.2121427277342917243.stgit@magnolia>
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the extra AG geometry fields out of scrub and into the libfrog code
so that we can consolidate the geoemtry code in one place.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfrog.h    |   12 ++++++++++++
 libfrog/fsgeom.c   |   13 ++++++++++++-
 scrub/fscounters.c |    4 ++--
 scrub/inodes.c     |    4 ++--
 scrub/phase1.c     |    5 -----
 scrub/phase3.c     |    6 +++---
 scrub/phase5.c     |    4 ++--
 scrub/phase6.c     |    2 +-
 scrub/phase7.c     |    6 +++---
 scrub/xfs_scrub.h  |    4 ----
 10 files changed, 37 insertions(+), 23 deletions(-)


diff --git a/include/xfrog.h b/include/xfrog.h
index e450ee1d..507f27a4 100644
--- a/include/xfrog.h
+++ b/include/xfrog.h
@@ -30,6 +30,18 @@ struct xfrog {
 
 	/* filesystem geometry */
 	struct xfs_fsop_geom	fsgeom;
+
+	/* log2 of sb_agblocks (rounded up) */
+	unsigned int		agblklog;
+
+	/* log2 of sb_blocksize */
+	unsigned int		blocklog;
+
+	/* log2 of sb_inodesize */
+	unsigned int		inodelog;
+
+	/* log2 of sb_inopblock */
+	unsigned int		inopblog;
 };
 
 /* Static initializers */
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index bf76b520..28e4fd62 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -5,6 +5,7 @@
 #include "libxfs.h"
 #include "fsgeom.h"
 #include "xfrog.h"
+#include "libfrog.h"
 
 void
 xfs_report_geom(
@@ -94,7 +95,17 @@ int
 xfrog_prepare_geometry(
 	struct xfrog		*froggie)
 {
-	return xfrog_geometry(froggie->fd, &froggie->fsgeom);
+	int			ret;
+
+	ret = xfrog_geometry(froggie->fd, &froggie->fsgeom);
+	if (ret)
+		return ret;
+
+	froggie->agblklog = log2_roundup(froggie->fsgeom.agblocks);
+	froggie->blocklog = highbit32(froggie->fsgeom.blocksize);
+	froggie->inodelog = highbit32(froggie->fsgeom.inodesize);
+	froggie->inopblog = froggie->blocklog - froggie->inodelog;
+	return 0;
 }
 
 /* Release any resources associated with this xfrog structure. */
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index f18d0e19..ac898764 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -91,8 +91,8 @@ xfs_count_ag_inodes(
 				minor(ctx->fsinfo.fs_datadev),
 				agno);
 
-	ag_ino = (__u64)agno << (ctx->inopblog + ctx->agblklog);
-	next_ag_ino = (__u64)(agno + 1) << (ctx->inopblog + ctx->agblklog);
+	ag_ino = (__u64)agno << (ctx->mnt.inopblog + ctx->mnt.agblklog);
+	next_ag_ino = (__u64)(agno + 1) << (ctx->mnt.inopblog + ctx->mnt.agblklog);
 
 	moveon = xfs_count_inodes_range(ctx, descr, ag_ino, next_ag_ino - 1,
 			&ci->counters[agno]);
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 08f3d847..873ad425 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -228,8 +228,8 @@ xfs_scan_ag_inodes(
 				minor(ctx->fsinfo.fs_datadev),
 				agno);
 
-	ag_ino = (__u64)agno << (ctx->inopblog + ctx->agblklog);
-	next_ag_ino = (__u64)(agno + 1) << (ctx->inopblog + ctx->agblklog);
+	ag_ino = (__u64)agno << (ctx->mnt.inopblog + ctx->mnt.agblklog);
+	next_ag_ino = (__u64)(agno + 1) << (ctx->mnt.inopblog + ctx->mnt.agblklog);
 
 	moveon = xfs_iterate_inodes_range(ctx, descr, ctx->fshandle, ag_ino,
 			next_ag_ino - 1, si->fn, si->arg);
diff --git a/scrub/phase1.c b/scrub/phase1.c
index c7034527..9a3d8f05 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -140,11 +140,6 @@ _("Does not appear to be an XFS filesystem!"));
 		return false;
 	}
 
-	ctx->agblklog = log2_roundup(ctx->mnt.fsgeom.agblocks);
-	ctx->blocklog = highbit32(ctx->mnt.fsgeom.blocksize);
-	ctx->inodelog = highbit32(ctx->mnt.fsgeom.inodesize);
-	ctx->inopblog = ctx->blocklog - ctx->inodelog;
-
 	error = path_to_fshandle(ctx->mntpoint, &ctx->fshandle,
 			&ctx->fshandle_len);
 	if (error) {
diff --git a/scrub/phase3.c b/scrub/phase3.c
index a42d8213..579e08c3 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -52,8 +52,8 @@ xfs_scrub_inode_vfs_error(
 	xfs_agino_t		agino;
 	int			old_errno = errno;
 
-	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
-	agino = bstat->bs_ino % (1ULL << (ctx->inopblog + ctx->agblklog));
+	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
+	agino = bstat->bs_ino % (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
 	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
 			(uint64_t)bstat->bs_ino, agno, agino);
 	errno = old_errno;
@@ -77,7 +77,7 @@ xfs_scrub_inode(
 	int			error;
 
 	xfs_action_list_init(&alist);
-	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
+	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
 	background_sleep();
 
 	/* Try to open the inode to pin it. */
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 748885d4..36ec27b3 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -239,8 +239,8 @@ xfs_scrub_connections(
 	int			fd = -1;
 	int			error;
 
-	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
-	agino = bstat->bs_ino % (1ULL << (ctx->inopblog + ctx->agblklog));
+	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
+	agino = bstat->bs_ino % (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
 	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
 			(uint64_t)bstat->bs_ino, agno, agino);
 	background_sleep();
diff --git a/scrub/phase6.c b/scrub/phase6.c
index e5a0b3c1..48971270 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -547,7 +547,7 @@ xfs_estimate_verify_work(
 	if (!moveon)
 		return moveon;
 
-	*items = ((d_blocks - d_bfree) + (r_blocks - r_bfree)) << ctx->blocklog;
+	*items = ((d_blocks - d_bfree) + (r_blocks - r_bfree)) << ctx->mnt.blocklog;
 	*nr_threads = disk_heads(ctx->datadev);
 	*rshift = 20;
 	return moveon;
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 13959ca8..41a77356 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -148,11 +148,11 @@ xfs_scan_summary(
 	 * filesystem treats them as "free", but since we scanned
 	 * them, we'll consider them used.
 	 */
-	d_bfree -= totalcount.agbytes >> ctx->blocklog;
+	d_bfree -= totalcount.agbytes >> ctx->mnt.blocklog;
 
 	/* Report on what we found. */
-	used_data = (d_blocks - d_bfree) << ctx->blocklog;
-	used_rt = (r_blocks - r_bfree) << ctx->blocklog;
+	used_data = (d_blocks - d_bfree) << ctx->mnt.blocklog;
+	used_rt = (r_blocks - r_bfree) << ctx->mnt.blocklog;
 	used_files = f_files - f_free;
 	stat_data = totalcount.dbytes;
 	stat_rt = totalcount.rbytes;
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 3eb7ed79..13888f8c 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -63,10 +63,6 @@ struct scrub_ctx {
 
 	/* XFS specific geometry */
 	struct fs_path		fsinfo;
-	unsigned int		agblklog;
-	unsigned int		blocklog;
-	unsigned int		inodelog;
-	unsigned int		inopblog;
 	void			*fshandle;
 	size_t			fshandle_len;
 
