Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48096 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727576AbeJELAN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 07:00:13 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 05/15] xfsprogs: don't use 0 as pointer
Date: Thu,  4 Oct 2018 23:03:06 -0500
Message-Id: <1538712196-13625-6-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

Use NULL as appropriate.

Fixes sparse warnings about this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 db/dir2sf.c          |  4 ++--
 fsr/xfs_fsr.c        | 10 +++++-----
 libxfs/libxfs_priv.h |  2 +-
 libxfs/rdwr.c        |  6 +++---
 mkfs/proto.c         |  4 ++--
 scrub/fscounters.c   |  2 +-
 scrub/inodes.c       |  6 +++---
 7 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/db/dir2sf.c b/db/dir2sf.c
index 977a932..5737f2a 100644
--- a/db/dir2sf.c
+++ b/db/dir2sf.c
@@ -30,8 +30,8 @@ const field_t	dir2sf_flds[] = {
 };
 
 const field_t	dir2_inou_flds[] = {
-	{ "i8", FLDT_DIR2_INO8, 0, dir2_inou_i8_count, FLD_COUNT, TYP_INODE },
-	{ "i4", FLDT_DIR2_INO4, 0, dir2_inou_i4_count, FLD_COUNT, TYP_INODE },
+	{ "i8", FLDT_DIR2_INO8, NULL, dir2_inou_i8_count, FLD_COUNT, TYP_INODE},
+	{ "i4", FLDT_DIR2_INO4, NULL, dir2_inou_i4_count, FLD_COUNT, TYP_INODE},
 	{ NULL }
 };
 
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index e21643a..c8aea98 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -241,7 +241,7 @@ main(int argc, char **argv)
 	if (vflag)
 		setbuf(stdout, NULL);
 
-	starttime = time(0);
+	starttime = time(NULL);
 
 	/* Save the caller's real uid */
 	RealUid = getuid();
@@ -525,7 +525,7 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
 	signal(SIGTERM, aborter);
 
 	/* reorg for 'howlong' -- checked in 'fsrfs' */
-	while (endtime > time(0)) {
+	while (endtime > time(NULL)) {
 		pid_t pid;
 
 		if (npasses > 1 && !fs->npass)
@@ -560,7 +560,7 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
 			break;
 		}
 	}
-	fsrall_cleanup(endtime <= time(0));
+	fsrall_cleanup(endtime <= time(NULL));
 }
 
 /*
@@ -578,7 +578,7 @@ fsrall_cleanup(int timeout)
 	if (timeout) {
 		fsrprintf(_("%s startpass %d, endpass %d, time %d seconds\n"),
 			progname, startpass, fs->npass,
-			time(0) - endtime + howlong);
+			time(NULL) - endtime + howlong);
 
 		/* record where we left off */
 		fd = open(leftofffile, O_WRONLY|O_CREAT|O_EXCL, 0644);
@@ -688,7 +688,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 					break;
 			}
 		}
-		if (endtime && endtime < time(0)) {
+		if (endtime && endtime < time(NULL)) {
 			tmp_close(mntdir);
 			close(fsfd);
 			fsrall_cleanup(1);
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index a2fbeac..b4bdc64 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -391,7 +391,7 @@ roundup_64(uint64_t x, uint32_t y)
 #define XBRW_READ			LIBXFS_BREAD
 #define XBRW_WRITE			LIBXFS_BWRITE
 #define xfs_buf_iomove(bp,off,len,data,f)	libxfs_iomove(bp,off,len,data,f)
-#define xfs_buf_zero(bp,off,len)	libxfs_iomove(bp,off,len,0,LIBXFS_BZERO)
+#define xfs_buf_zero(bp,off,len)     libxfs_iomove(bp,off,len,NULL,LIBXFS_BZERO)
 
 /* mount stuff */
 #define XFS_MOUNT_32BITINODES		LIBXFS_MOUNT_32BITINODES
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 0ee3ba8..c160e20 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -779,7 +779,7 @@ struct xfs_buf *
 libxfs_getbuf_flags(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len,
 		unsigned int flags)
 {
-	struct xfs_bufkey key = {0};
+	struct xfs_bufkey key = {NULL};
 
 	key.buftarg = btp;
 	key.blkno = blkno;
@@ -822,7 +822,7 @@ static struct xfs_buf *
 __libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
 		    int nmaps, int flags)
 {
-	struct xfs_bufkey key = {0};
+	struct xfs_bufkey key = {NULL};
 	int i;
 
 	if (nmaps == 1)
@@ -882,7 +882,7 @@ libxfs_putbuf(xfs_buf_t *bp)
 void
 libxfs_purgebuf(xfs_buf_t *bp)
 {
-	struct xfs_bufkey key = {0};
+	struct xfs_bufkey key = {NULL};
 
 	key.buftarg = bp->b_target;
 	key.blkno = bp->b_bn;
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 687c53a..1cd5436 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -259,7 +259,7 @@ newfile(
 			exit(1);
 		}
 		d = XFS_FSB_TO_DADDR(mp, map.br_startblock);
-		bp = libxfs_trans_get_buf(logit ? tp : 0, mp->m_dev, d,
+		bp = libxfs_trans_get_buf(logit ? tp : NULL, mp->m_dev, d,
 			nb << mp->m_blkbb_log, 0);
 		memmove(bp->b_addr, buf, len);
 		if (len < bp->b_bcount)
@@ -297,7 +297,7 @@ newregfile(
 			exit(1);
 		}
 	} else
-		buf = 0;
+		buf = NULL;
 	close(fd);
 	return buf;
 }
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index 6e9bd05..9e93e2a 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -41,7 +41,7 @@ xfs_count_inodes_range(
 	uint64_t		last_ino,
 	uint64_t		*count)
 {
-	struct xfs_fsop_bulkreq	igrpreq = {0};
+	struct xfs_fsop_bulkreq	igrpreq = {NULL};
 	struct xfs_inogrp	inogrp;
 	__u64			igrp_ino;
 	uint64_t		nr = 0;
diff --git a/scrub/inodes.c b/scrub/inodes.c
index add6876..693f21e 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -50,7 +50,7 @@ xfs_iterate_inodes_range_check(
 	struct xfs_inogrp	*inogrp,
 	struct xfs_bstat	*bstat)
 {
-	struct xfs_fsop_bulkreq	onereq = {0};
+	struct xfs_fsop_bulkreq	onereq = {NULL};
 	struct xfs_bstat	*bs;
 	__u64			oneino;
 	__s32			onelen = 0;
@@ -98,8 +98,8 @@ xfs_iterate_inodes_range(
 	xfs_inode_iter_fn	fn,
 	void			*arg)
 {
-	struct xfs_fsop_bulkreq	igrpreq = {0};
-	struct xfs_fsop_bulkreq	bulkreq = {0};
+	struct xfs_fsop_bulkreq	igrpreq = {NULL};
+	struct xfs_fsop_bulkreq	bulkreq = {NULL};
 	struct xfs_handle	handle;
 	struct xfs_inogrp	inogrp;
 	struct xfs_bstat	bstat[XFS_INODES_PER_CHUNK];
-- 
1.8.3.1
