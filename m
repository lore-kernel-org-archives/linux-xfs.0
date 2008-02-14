Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Feb 2008 03:18:05 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1EBHxqC028059
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 03:18:01 -0800
Received: from mta5.srv.hcvlny.cv.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 421E35D647C
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 03:18:22 -0800 (PST)
Received: from mta5.srv.hcvlny.cv.net (mta5.srv.hcvlny.cv.net [167.206.4.200]) by cuda.sgi.com with ESMTP id P7a5u82JiibqHnpc for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 03:18:22 -0800 (PST)
Received: from freyr.home (ool-44c218a8.dyn.optonline.net [68.194.24.168])
 by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JW7009UHXLA60U0@mta5.srv.hcvlny.cv.net> for xfs@oss.sgi.com;
 Thu, 14 Feb 2008 02:46:30 -0500 (EST)
Date: Thu, 14 Feb 2008 02:45:39 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: [PATCH 1/1] XFS: replace *_IDELETE with *_IKEEP
In-reply-to: <47B3B6AE.4030505@sandeen.net>
Message-id: <1202975139-10546-1-git-send-email-jeffpc@josefsipek.net>
Content-transfer-encoding: 7BIT
References: <47B3B6AE.4030505@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: sandeen@sandeen.net, Josef 'Jeff' Sipek <jeffpc@josefsipek.net>

Change the *_IDELETE flags to *_IKEEP, and flip the logic as necessary.

This completely eliminates the no-no-no-idelete madness.

Additionally, "ikeep" or "noikeep" is always displayed in /proc/mounts
option string. This should help clear up any confusion about what the
current mode is.

Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
---
 fs/xfs/linux-2.6/xfs_super.c |   11 ++++++-----
 fs/xfs/xfs_clnt.h            |    2 +-
 fs/xfs/xfs_ialloc.c          |    2 +-
 fs/xfs/xfs_mount.h           |    2 +-
 fs/xfs/xfs_vfsops.c          |    4 ++--
 fs/xfs/xfsidbg.c             |    2 +-
 6 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index a0b1235..5c343a0 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -171,7 +171,7 @@ xfs_parseargs(
 	char			*this_char, *value, *eov;
 	int			dsunit, dswidth, vol_dsunit, vol_dswidth;
 	int			iosize;
-	int			ikeep = 0;
+	int			ikeep = 0; /* don't keep by default */
 
 	args->flags |= XFSMNT_BARRIER;
 	args->flags2 |= XFSMNT2_COMPAT_IOSIZE;
@@ -303,9 +303,9 @@ xfs_parseargs(
 			args->flags &= ~XFSMNT_BARRIER;
 		} else if (!strcmp(this_char, MNTOPT_IKEEP)) {
 			ikeep = 1;
-			args->flags &= ~XFSMNT_IDELETE;
+			args->flags |= XFSMNT_IKEEP;
 		} else if (!strcmp(this_char, MNTOPT_NOIKEEP)) {
-			args->flags |= XFSMNT_IDELETE;
+			args->flags &= ~XFSMNT_IKEEP;
 		} else if (!strcmp(this_char, MNTOPT_LARGEIO)) {
 			args->flags2 &= ~XFSMNT2_COMPAT_IOSIZE;
 		} else if (!strcmp(this_char, MNTOPT_NOLARGEIO)) {
@@ -411,7 +411,7 @@ xfs_parseargs(
 	 * supplied, then they are honored.
 	 */
 	if (!(args->flags & XFSMNT_DMAPI) && !ikeep)
-		args->flags |= XFSMNT_IDELETE;
+		args->flags &= ~XFSMNT_IKEEP;
 
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
@@ -461,7 +462,7 @@ xfs_showargs(
 	};
 	static struct proc_xfs_info xfs_info_unset[] = {
 		/* the few simple ones we can get from the mount struct */
-		{ XFS_MOUNT_IDELETE,		"," MNTOPT_IKEEP },
+		{ XFS_MOUNT_IKEEP,		"," MNTOPT_NOIKEEP },
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
