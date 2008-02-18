Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Feb 2008 22:58:23 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1I6wGKO031388
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 22:58:21 -0800
Received: from mta2.srv.hcvlny.cv.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1879F123FE17
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 22:58:41 -0800 (PST)
Received: from mta2.srv.hcvlny.cv.net (mta2.srv.hcvlny.cv.net [167.206.4.197]) by cuda.sgi.com with ESMTP id zTFMdHFOElyMAxF7 for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 22:58:41 -0800 (PST)
Received: from freyr.home (ool-44c218a8.dyn.optonline.net [68.194.24.168])
 by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JWF00FNW8MT69J0@mta2.srv.hcvlny.cv.net> for xfs@oss.sgi.com;
 Mon, 18 Feb 2008 01:28:08 -0500 (EST)
Date: Mon, 18 Feb 2008 01:26:57 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: [PATCH 1/1] XFS: replace *_IDELETE with *_IKEEP
In-reply-to: <op.t6pgeisy3jf8g2@pc-bnaujok.melbourne.sgi.com>
Message-id: <1203316017-31561-1-git-send-email-jeffpc@josefsipek.net>
Content-transfer-encoding: 7BIT
References: <op.t6pgeisy3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: hch@infradead.org, sandeen@sandeen.net, xfs@oss.sgi.com, bnaujok@sgi.com
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>

Change the *_IDELETE flags to *_IKEEP, and flip the logic as necessary.

This completely eliminates the no-no-no-idelete madness.

Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
---
 fs/xfs/linux-2.6/xfs_super.c |   14 +++++++-------
 fs/xfs/xfs_clnt.h            |    2 +-
 fs/xfs/xfs_ialloc.c          |    2 +-
 fs/xfs/xfs_mount.h           |    2 +-
 fs/xfs/xfs_vfsops.c          |    4 ++--
 fs/xfs/xfsidbg.c             |    2 +-
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index a0b1235..32b7f6e 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -171,7 +171,7 @@ xfs_parseargs(
 	char			*this_char, *value, *eov;
 	int			dsunit, dswidth, vol_dsunit, vol_dswidth;
 	int			iosize;
-	int			ikeep = 0;
+	int			dmapi_implies_ikeep = 1;
 
 	args->flags |= XFSMNT_BARRIER;
 	args->flags2 |= XFSMNT2_COMPAT_IOSIZE;
@@ -302,10 +302,10 @@ xfs_parseargs(
 		} else if (!strcmp(this_char, MNTOPT_NOBARRIER)) {
 			args->flags &= ~XFSMNT_BARRIER;
 		} else if (!strcmp(this_char, MNTOPT_IKEEP)) {
-			ikeep = 1;
-			args->flags &= ~XFSMNT_IDELETE;
+			args->flags |= XFSMNT_IKEEP;
 		} else if (!strcmp(this_char, MNTOPT_NOIKEEP)) {
-			args->flags |= XFSMNT_IDELETE;
+			dmapi_implies_ikeep = 0;
+			args->flags &= ~XFSMNT_IKEEP;
 		} else if (!strcmp(this_char, MNTOPT_LARGEIO)) {
 			args->flags2 &= ~XFSMNT2_COMPAT_IOSIZE;
 		} else if (!strcmp(this_char, MNTOPT_NOLARGEIO)) {
@@ -410,8 +410,8 @@ xfs_parseargs(
 	 * Note that if "ikeep" or "noikeep" mount options are
 	 * supplied, then they are honored.
 	 */
-	if (!(args->flags & XFSMNT_DMAPI) && !ikeep)
-		args->flags |= XFSMNT_IDELETE;
+	if ((args->flags & XFSMNT_DMAPI) && dmapi_implies_ikeep)
+		args->flags |= XFSMNT_IKEEP;
 
 	if ((args->flags & XFSMNT_NOALIGN) != XFSMNT_NOALIGN) {
 		if (dsunit) {
@@ -446,6 +446,7 @@ xfs_showargs(
 {
 	static struct proc_xfs_info xfs_info_set[] = {
 		/* the few simple ones we can get from the mount struct */
+		{ XFS_MOUNT_IKEEP,		"," MNTOPT_IKEEP },
 		{ XFS_MOUNT_WSYNC,		"," MNTOPT_WSYNC },
 		{ XFS_MOUNT_INO64,		"," MNTOPT_INO64 },
 		{ XFS_MOUNT_NOALIGN,		"," MNTOPT_NOALIGN },
@@ -461,7 +462,6 @@ xfs_showargs(
 	};
 	static struct proc_xfs_info xfs_info_unset[] = {
 		/* the few simple ones we can get from the mount struct */
-		{ XFS_MOUNT_IDELETE,		"," MNTOPT_IKEEP },
 		{ XFS_MOUNT_COMPAT_IOSIZE,	"," MNTOPT_LARGEIO },
 		{ XFS_MOUNT_BARRIER,		"," MNTOPT_NOBARRIER },
 		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_64BITINODE },
diff --git a/fs/xfs/xfs_clnt.h b/fs/xfs/xfs_clnt.h
index d16c1b9..d5d1e60 100644
--- a/fs/xfs/xfs_clnt.h
+++ b/fs/xfs/xfs_clnt.h
@@ -86,7 +86,7 @@ struct xfs_mount_args {
 #define XFSMNT_NOUUID		0x01000000	/* Ignore fs uuid */
 #define XFSMNT_DMAPI		0x02000000	/* enable dmapi/xdsm */
 #define XFSMNT_BARRIER		0x04000000	/* use write barriers */
-#define XFSMNT_IDELETE		0x08000000	/* inode cluster delete */
+#define XFSMNT_IKEEP		0x08000000	/* inode cluster delete */
 #define XFSMNT_SWALLOC		0x10000000	/* turn on stripe width
 						 * allocation */
 #define XFSMNT_DIRSYNC		0x40000000	/* sync creat,link,unlink,rename
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 1409c2d..badf745 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1053,7 +1053,7 @@ xfs_difree(
 	/*
 	 * When an inode cluster is free, it becomes eligible for removal
 	 */
-	if ((mp->m_flags & XFS_MOUNT_IDELETE) &&
+	if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
 	    (rec.ir_freecount == XFS_IALLOC_INODES(mp))) {
 
 		*delete = 1;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 435d625..87ee8b8 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -366,7 +366,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_SMALL_INUMS	(1ULL << 15)	/* users wants 32bit inodes */
 #define XFS_MOUNT_NOUUID	(1ULL << 16)	/* ignore uuid during mount */
 #define XFS_MOUNT_BARRIER	(1ULL << 17)
-#define XFS_MOUNT_IDELETE	(1ULL << 18)	/* delete empty inode clusters*/
+#define XFS_MOUNT_IKEEP		(1ULL << 18)	/* keep empty inode clusters*/
 #define XFS_MOUNT_SWALLOC	(1ULL << 19)	/* turn on stripe width
 						 * allocation */
 #define XFS_MOUNT_RDONLY	(1ULL << 20)	/* read-only fs */
diff --git a/fs/xfs/xfs_vfsops.c b/fs/xfs/xfs_vfsops.c
index a0f287e..e809b1c 100644
--- a/fs/xfs/xfs_vfsops.c
+++ b/fs/xfs/xfs_vfsops.c
@@ -279,8 +279,8 @@ xfs_start_flags(
 		mp->m_readio_log = mp->m_writeio_log = ap->iosizelog;
 	}
 
-	if (ap->flags & XFSMNT_IDELETE)
-		mp->m_flags |= XFS_MOUNT_IDELETE;
+	if (ap->flags & XFSMNT_IKEEP)
+		mp->m_flags |= XFS_MOUNT_IKEEP;
 	if (ap->flags & XFSMNT_DIRSYNC)
 		mp->m_flags |= XFS_MOUNT_DIRSYNC;
 	if (ap->flags & XFSMNT_ATTR2)
diff --git a/fs/xfs/xfsidbg.c b/fs/xfs/xfsidbg.c
index aa029da..a875351 100644
--- a/fs/xfs/xfsidbg.c
+++ b/fs/xfs/xfsidbg.c
@@ -6282,7 +6282,7 @@ xfsidbg_xmount(xfs_mount_t *mp)
 		"SMALL_INUMS",	/* 0x8000 */
 		"NOUUID",	/* 0x10000 */
 		"BARRIER",	/* 0x20000 */
-		"IDELETE",	/* 0x40000 */
+		"IKEEP",	/* 0x40000 */
 		"SWALLOC",	/* 0x80000 */
 		"RDONLY", 	/* 0x100000 */
 		"DIRSYNC",	/* 0x200000 */
-- 
1.5.4.rc2.85.g9de45-dirty
