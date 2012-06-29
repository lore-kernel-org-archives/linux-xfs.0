Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5TI7KDY154060 for <xfs@oss.sgi.com>; Fri, 29 Jun 2012 13:07:20 -0500
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id gKjgRT47k8tF8zLk for
	<xfs@oss.sgi.com>; Fri, 29 Jun 2012 11:07:16 -0700 (PDT)
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH 1/2 V2] xfs: cleanup the mount options
Date: Sat, 30 Jun 2012 02:06:41 +0800
Message-Id: <1340993202-5560-1-git-send-email-gaowanlong@cn.fujitsu.com>
In-Reply-To: <1340816243-6177-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1340816243-6177-1-git-send-email-gaowanlong@cn.fujitsu.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: XFS <xfs@oss.sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Zach Brown <zab@zabbo.net>, Wanlong Gao <gaowanlong@cn.fujitsu.com>

remove the mount options macro, use tokens instead.

CC: Ben Myers <bpm@sgi.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Dave Chinner <david@fromorbit.com>
CC: Zach Brown <zab@zabbo.net>
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 fs/xfs/xfs_super.c |  523 ++++++++++++++++++++++++++++------------------------
 1 file changed, 287 insertions(+), 236 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0d9de41..36d139b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -66,66 +66,74 @@ static const struct super_operations xfs_super_operations;
 static kmem_zone_t *xfs_ioend_zone;
 mempool_t *xfs_ioend_pool;
 
-#define MNTOPT_LOGBUFS	"logbufs"	/* number of XFS log buffers */
-#define MNTOPT_LOGBSIZE	"logbsize"	/* size of XFS log buffers */
-#define MNTOPT_LOGDEV	"logdev"	/* log device */
-#define MNTOPT_RTDEV	"rtdev"		/* realtime I/O device */
-#define MNTOPT_BIOSIZE	"biosize"	/* log2 of preferred buffered io size */
-#define MNTOPT_WSYNC	"wsync"		/* safe-mode nfs compatible mount */
-#define MNTOPT_NOALIGN	"noalign"	/* turn off stripe alignment */
-#define MNTOPT_SWALLOC	"swalloc"	/* turn on stripe width allocation */
-#define MNTOPT_SUNIT	"sunit"		/* data volume stripe unit */
-#define MNTOPT_SWIDTH	"swidth"	/* data volume stripe width */
-#define MNTOPT_NOUUID	"nouuid"	/* ignore filesystem UUID */
-#define MNTOPT_MTPT	"mtpt"		/* filesystem mount point */
-#define MNTOPT_GRPID	"grpid"		/* group-ID from parent directory */
-#define MNTOPT_NOGRPID	"nogrpid"	/* group-ID from current process */
-#define MNTOPT_BSDGROUPS    "bsdgroups"    /* group-ID from parent directory */
-#define MNTOPT_SYSVGROUPS   "sysvgroups"   /* group-ID from current process */
-#define MNTOPT_ALLOCSIZE    "allocsize"    /* preferred allocation size */
-#define MNTOPT_NORECOVERY   "norecovery"   /* don't run XFS recovery */
-#define MNTOPT_BARRIER	"barrier"	/* use writer barriers for log write and
-					 * unwritten extent conversion */
-#define MNTOPT_NOBARRIER "nobarrier"	/* .. disable */
-#define MNTOPT_64BITINODE   "inode64"	/* inodes can be allocated anywhere */
-#define MNTOPT_IKEEP	"ikeep"		/* do not free empty inode clusters */
-#define MNTOPT_NOIKEEP	"noikeep"	/* free empty inode clusters */
-#define MNTOPT_LARGEIO	   "largeio"	/* report large I/O sizes in stat() */
-#define MNTOPT_NOLARGEIO   "nolargeio"	/* do not report large I/O sizes
-					 * in stat(). */
-#define MNTOPT_ATTR2	"attr2"		/* do use attr2 attribute format */
-#define MNTOPT_NOATTR2	"noattr2"	/* do not use attr2 attribute format */
-#define MNTOPT_FILESTREAM  "filestreams" /* use filestreams allocator */
-#define MNTOPT_QUOTA	"quota"		/* disk quotas (user) */
-#define MNTOPT_NOQUOTA	"noquota"	/* no quotas */
-#define MNTOPT_USRQUOTA	"usrquota"	/* user quota enabled */
-#define MNTOPT_GRPQUOTA	"grpquota"	/* group quota enabled */
-#define MNTOPT_PRJQUOTA	"prjquota"	/* project quota enabled */
-#define MNTOPT_UQUOTA	"uquota"	/* user quota (IRIX variant) */
-#define MNTOPT_GQUOTA	"gquota"	/* group quota (IRIX variant) */
-#define MNTOPT_PQUOTA	"pquota"	/* project quota (IRIX variant) */
-#define MNTOPT_UQUOTANOENF "uqnoenforce"/* user quota limit enforcement */
-#define MNTOPT_GQUOTANOENF "gqnoenforce"/* group quota limit enforcement */
-#define MNTOPT_PQUOTANOENF "pqnoenforce"/* project quota limit enforcement */
-#define MNTOPT_QUOTANOENF  "qnoenforce"	/* same as uqnoenforce */
-#define MNTOPT_DELAYLOG    "delaylog"	/* Delayed logging enabled */
-#define MNTOPT_NODELAYLOG  "nodelaylog"	/* Delayed logging disabled */
-#define MNTOPT_DISCARD	   "discard"	/* Discard unused blocks */
-#define MNTOPT_NODISCARD   "nodiscard"	/* Do not discard unused blocks */
-
 /*
  * Table driven mount option parser.
- *
- * Currently only used for remount, but it will be used for mount
- * in the future, too.
  */
 enum {
-	Opt_barrier, Opt_nobarrier, Opt_err
+	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev, Opt_biosize,
+	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth,
+	Opt_nouuid, Opt_mtpt, Opt_grpid, Opt_nogrpid, Opt_bsdgroups,
+	Opt_sysvgroups, Opt_allocsize, Opt_norecovery, Opt_barrier,
+	Opt_nobarrier, Opt_inode64, Opt_ikeep, Opt_noikeep, Opt_largeio,
+	Opt_nolargeio, Opt_attr2, Opt_noattr2, Opt_filestreams, Opt_quota,
+	Opt_noquota, Opt_usrquota, Opt_grpquota, Opt_prjquota, Opt_uquota,
+	Opt_gquota, Opt_pquota, Opt_uqnoenf, Opt_gqnoenf, Opt_pqnoenf,
+	Opt_qnoenf, Opt_delaylog, Opt_nodelaylog, Opt_discard, Opt_nodiscard,
+	Opt_ihashsize, Opt_osyncisdsync, Opt_osyncisosync, Opt_irixsgid,
+	Opt_err
 };
 
 static const match_table_t tokens = {
-	{Opt_barrier, "barrier"},
-	{Opt_nobarrier, "nobarrier"},
+	{Opt_logbufs, "logbufs=%d"},	/* number of XFS log buffers */
+	{Opt_logbsize, "logbsize=%s"},	/* size of XFS log buffers */
+	{Opt_logdev, "logdev=%s"},	/* log device */
+	{Opt_rtdev, "rtdev=%s"},	/* realtime I/O device */
+	{Opt_biosize, "biosize=%d"},	/* log2 of preferred buffered io size */
+	{Opt_wsync, "wsync"},		/* safe-mode nfs compatible mount */
+	{Opt_noalign, "noalign"},	/* turn off stripe alignment */
+	{Opt_swalloc, "swalloc"},	/* turn on stripe width allocation */
+	{Opt_sunit, "sunit=%d"},	/* data volume stripe unit */
+	{Opt_swidth, "swidth=%d"},	/* data volume stripe width */
+	{Opt_nouuid, "nouuid"},		/* ignore filesystem UUID */
+	{Opt_mtpt, "mtpt"},		/* filesystem mount point */
+	{Opt_grpid, "grpid"},		/* group-ID from parent directory */
+	{Opt_nogrpid, "nogrpid"},	/* group-ID from current process */
+	{Opt_bsdgroups, "bsdgroups"},	/* group-ID from parent directory */
+	{Opt_sysvgroups, "sysvgroups"},	/* group-ID from current process */
+	{Opt_allocsize, "allocsize=%s"},/* preferred allocation size */
+	{Opt_norecovery, "norecovery"},	/* do not run XFS recovery */
+	{Opt_barrier, "barrier"},	/* use writer barrier for log write and
+					 * unwritten extent conversation */
+	{Opt_nobarrier, "nobarrier"},	/* .. disable */
+	{Opt_inode64, "inode64"},	/* inodes can be allocated anywhere */
+	{Opt_ikeep, "ikeep"},		/* do not free empty inode clusters */
+	{Opt_noikeep, "noikeep"},	/* free empty inode clusters */
+	{Opt_largeio, "largeio"},	/* report large I/O sizes in start() */
+	{Opt_nolargeio, "nolargeio"},	/* do not report large I/O sizes
+					 * in start() */
+	{Opt_attr2, "attr2"},		/* do use attr2 attribute format */
+	{Opt_noattr2, "noattr2"},	/* do not use attr2 attribute format */
+	{Opt_filestreams, "filestreams"}, /* use filestreams allocator */
+	{Opt_quota, "quota"},		/* disk quotas (user) */
+	{Opt_noquota, "noquota"},	/* no quotas */
+	{Opt_usrquota, "usrquota"},	/* user quota enabled */
+	{Opt_grpquota, "grpquota"},	/* group quota enabled */
+	{Opt_prjquota, "prjquota"},	/* project quota enabled */
+	{Opt_uquota, "uquota"},		/* user quota (IRIX variant) */
+	{Opt_gquota, "gquota"},		/* group quota (IRIX variant) */
+	{Opt_pquota, "pquota"},		/* project quota (IRIX variant) */
+	{Opt_uqnoenf, "uqnoenforce"},	/* user quota limit enforcement */
+	{Opt_gqnoenf, "gqnoenforce"},	/* group quota limit enforcement */
+	{Opt_pqnoenf, "pqnoenforce"},	/* project quota limit enforcement */
+	{Opt_qnoenf, "qnoenforce"},	/* same as uqnoenforce */
+	{Opt_delaylog, "delaylog"},	/* deprecated */
+	{Opt_nodelaylog, "nodelaylog"},	/* deprecated */
+	{Opt_discard, "discard"},	/* Discard unused blocks */
+	{Opt_nodiscard, "nodiscard"},	/* Do not discard unused blocks */
+	{Opt_ihashsize, "ihashsize"},	/* deprecated */
+	{Opt_osyncisdsync, "osyncisdsync"}, /* deprecated */
+	{Opt_osyncisosync, "osyncisosync"}, /* deprecated */
+	{Opt_irixsgid, "irixsgid"},	/* deprecated */
 	{Opt_err, NULL}
 };
 
@@ -166,11 +174,14 @@ xfs_parseargs(
 	char			*options)
 {
 	struct super_block	*sb = mp->m_super;
-	char			*this_char, *value, *eov;
+	char			*p, *string, *eov;
 	int			dsunit = 0;
 	int			dswidth = 0;
-	int			iosize = 0;
 	__uint8_t		iosizelog = 0;
+	int			intarg;
+	substring_t		args[MAX_OPT_ARGS];
+	char			*orig = NULL;
+	int			ret = 0;
 
 	/*
 	 * set up the mount name first so all the errors will refer to the
@@ -208,175 +219,224 @@ xfs_parseargs(
 	if (!options)
 		goto done;
 
-	while ((this_char = strsep(&options, ",")) != NULL) {
-		if (!*this_char)
+	ret = ENOMEM;
+	options = kstrdup(options, GFP_NOFS);
+	if (!options)
+		goto done;
+
+	orig = options;
+
+	while ((p = strsep(&orig, ",")) != NULL) {
+		int token;
+		if (!*p)
 			continue;
-		if ((value = strchr(this_char, '=')) != NULL)
-			*value++ = 0;
-
-		if (!strcmp(this_char, MNTOPT_LOGBUFS)) {
-			if (!value || !*value) {
-				xfs_warn(mp, "%s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			mp->m_logbufs = simple_strtoul(value, &eov, 10);
-		} else if (!strcmp(this_char, MNTOPT_LOGBSIZE)) {
-			if (!value || !*value) {
-				xfs_warn(mp, "%s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			mp->m_logbsize = suffix_strtoul(value, &eov, 10);
-		} else if (!strcmp(this_char, MNTOPT_LOGDEV)) {
-			if (!value || !*value) {
-				xfs_warn(mp, "%s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			mp->m_logname = kstrndup(value, MAXNAMELEN, GFP_KERNEL);
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_logbufs:
+			intarg = 0;
+			ret = EINVAL;
+			match_int(args, &intarg);
+			if (!intarg)
+				goto free_orig;
+			mp->m_logbufs = intarg;
+			break;
+		case Opt_logbsize:
+			ret = ENOMEM;
+			string = match_strdup(args);
+			if (!string)
+				goto free_orig;
+			ret = EINVAL;
+			intarg = suffix_strtoul(string, &eov, 0);
+			if (!intarg)
+				goto free_string;
+			mp->m_logbsize = intarg;
+			break;
+		case Opt_logdev:
+			ret = ENOMEM;
+			string = match_strdup(args);
+			if (!string)
+				goto free_orig;
+
+			mp->m_logname = kstrndup(string, MAXNAMELEN, GFP_KERNEL);
 			if (!mp->m_logname)
-				return ENOMEM;
-		} else if (!strcmp(this_char, MNTOPT_MTPT)) {
-			xfs_warn(mp, "%s option not allowed on this system",
-				this_char);
-			return EINVAL;
-		} else if (!strcmp(this_char, MNTOPT_RTDEV)) {
-			if (!value || !*value) {
-				xfs_warn(mp, "%s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			mp->m_rtname = kstrndup(value, MAXNAMELEN, GFP_KERNEL);
+				goto free_string;
+			break;
+		case Opt_mtpt:
+			ret = EINVAL;
+			xfs_warn(mp, "%s option not allowed on this system", p);
+			goto free_orig;
+		case Opt_rtdev:
+			ret = ENOMEM;
+			string = match_strdup(args);
+			if (!string)
+				goto free_orig;
+			mp->m_rtname = kstrndup(string, MAXNAMELEN, GFP_KERNEL);
 			if (!mp->m_rtname)
-				return ENOMEM;
-		} else if (!strcmp(this_char, MNTOPT_BIOSIZE)) {
-			if (!value || !*value) {
-				xfs_warn(mp, "%s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			iosize = simple_strtoul(value, &eov, 10);
-			iosizelog = ffs(iosize) - 1;
-		} else if (!strcmp(this_char, MNTOPT_ALLOCSIZE)) {
-			if (!value || !*value) {
-				xfs_warn(mp, "%s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			iosize = suffix_strtoul(value, &eov, 10);
-			iosizelog = ffs(iosize) - 1;
-		} else if (!strcmp(this_char, MNTOPT_GRPID) ||
-			   !strcmp(this_char, MNTOPT_BSDGROUPS)) {
+				goto free_string;
+			break;
+		case Opt_biosize:
+			intarg = 0;
+			ret = EINVAL;
+			intarg = match_int(args, &intarg);
+			if (!intarg)
+				goto free_orig;
+			iosizelog = ffs(intarg) - 1;
+			break;
+		case Opt_allocsize:
+			ret = ENOMEM;
+			string = match_strdup(args);
+			if (!string)
+				goto free_orig;
+			ret = EINVAL;
+			intarg = suffix_strtoul(string, &eov, 0);
+			if (!intarg)
+				goto free_string;
+			iosizelog = ffs(intarg) - 1;
+			break;
+		case Opt_grpid:
+		case Opt_bsdgroups:
 			mp->m_flags |= XFS_MOUNT_GRPID;
-		} else if (!strcmp(this_char, MNTOPT_NOGRPID) ||
-			   !strcmp(this_char, MNTOPT_SYSVGROUPS)) {
+			break;
+		case Opt_nogrpid:
+		case Opt_sysvgroups:
 			mp->m_flags &= ~XFS_MOUNT_GRPID;
-		} else if (!strcmp(this_char, MNTOPT_WSYNC)) {
+			break;
+		case Opt_wsync:
 			mp->m_flags |= XFS_MOUNT_WSYNC;
-		} else if (!strcmp(this_char, MNTOPT_NORECOVERY)) {
+			break;
+		case Opt_norecovery:
 			mp->m_flags |= XFS_MOUNT_NORECOVERY;
-		} else if (!strcmp(this_char, MNTOPT_NOALIGN)) {
+			break;
+		case Opt_noalign:
 			mp->m_flags |= XFS_MOUNT_NOALIGN;
-		} else if (!strcmp(this_char, MNTOPT_SWALLOC)) {
+			break;
+		case Opt_swalloc:
 			mp->m_flags |= XFS_MOUNT_SWALLOC;
-		} else if (!strcmp(this_char, MNTOPT_SUNIT)) {
-			if (!value || !*value) {
-				xfs_warn(mp, "%s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			dsunit = simple_strtoul(value, &eov, 10);
-		} else if (!strcmp(this_char, MNTOPT_SWIDTH)) {
-			if (!value || !*value) {
-				xfs_warn(mp, "%s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			dswidth = simple_strtoul(value, &eov, 10);
-		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
+			break;
+		case Opt_sunit:
+			ret = EINVAL;
+			dsunit = match_int(args, &intarg);
+			if (!dsunit)
+				goto free_orig;
+			break;
+		case Opt_swidth:
+			ret = EINVAL;
+			dswidth = match_int(args, &intarg);
+			if (!dswidth)
+				goto free_orig;
+		case Opt_inode64:
 			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
 #if !XFS_BIG_INUMS
-			xfs_warn(mp, "%s option not allowed on this system",
-				this_char);
+			xfs_warn(mp, "%s options not allowed on this system", p);
 			return EINVAL;
 #endif
-		} else if (!strcmp(this_char, MNTOPT_NOUUID)) {
+			break;
+		case Opt_nouuid:
 			mp->m_flags |= XFS_MOUNT_NOUUID;
-		} else if (!strcmp(this_char, MNTOPT_BARRIER)) {
+			break;
+		case Opt_barrier:
 			mp->m_flags |= XFS_MOUNT_BARRIER;
-		} else if (!strcmp(this_char, MNTOPT_NOBARRIER)) {
+			break;
+		case Opt_nobarrier:
 			mp->m_flags &= ~XFS_MOUNT_BARRIER;
-		} else if (!strcmp(this_char, MNTOPT_IKEEP)) {
+			break;
+		case Opt_ikeep:
 			mp->m_flags |= XFS_MOUNT_IKEEP;
-		} else if (!strcmp(this_char, MNTOPT_NOIKEEP)) {
+			break;
+		case Opt_noikeep:
 			mp->m_flags &= ~XFS_MOUNT_IKEEP;
-		} else if (!strcmp(this_char, MNTOPT_LARGEIO)) {
+			break;
+		case Opt_largeio:
 			mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
-		} else if (!strcmp(this_char, MNTOPT_NOLARGEIO)) {
+			break;
+		case Opt_nolargeio:
 			mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
-		} else if (!strcmp(this_char, MNTOPT_ATTR2)) {
+			break;
+		case Opt_attr2:
 			mp->m_flags |= XFS_MOUNT_ATTR2;
-		} else if (!strcmp(this_char, MNTOPT_NOATTR2)) {
+			break;
+		case Opt_noattr2:
 			mp->m_flags &= ~XFS_MOUNT_ATTR2;
 			mp->m_flags |= XFS_MOUNT_NOATTR2;
-		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
+			break;
+		case Opt_filestreams:
 			mp->m_flags |= XFS_MOUNT_FILESTREAMS;
-		} else if (!strcmp(this_char, MNTOPT_NOQUOTA)) {
+			break;
+		case Opt_noquota:
 			mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
 			mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
 			mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
-		} else if (!strcmp(this_char, MNTOPT_QUOTA) ||
-			   !strcmp(this_char, MNTOPT_UQUOTA) ||
-			   !strcmp(this_char, MNTOPT_USRQUOTA)) {
+			break;
+		case Opt_quota:
+		case Opt_uquota:
+		case Opt_usrquota:
 			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
 					 XFS_UQUOTA_ENFD);
-		} else if (!strcmp(this_char, MNTOPT_QUOTANOENF) ||
-			   !strcmp(this_char, MNTOPT_UQUOTANOENF)) {
+			break;
+		case Opt_qnoenf:
+		case Opt_uqnoenf:
 			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
 			mp->m_qflags &= ~XFS_UQUOTA_ENFD;
-		} else if (!strcmp(this_char, MNTOPT_PQUOTA) ||
-			   !strcmp(this_char, MNTOPT_PRJQUOTA)) {
+			break;
+		case Opt_pquota:
+		case Opt_prjquota:
 			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
 					 XFS_OQUOTA_ENFD);
-		} else if (!strcmp(this_char, MNTOPT_PQUOTANOENF)) {
+			break;
+		case Opt_pqnoenf:
 			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
 			mp->m_qflags &= ~XFS_OQUOTA_ENFD;
-		} else if (!strcmp(this_char, MNTOPT_GQUOTA) ||
-			   !strcmp(this_char, MNTOPT_GRPQUOTA)) {
+			break;
+		case Opt_gquota:
+		case Opt_grpquota:
 			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
 					 XFS_OQUOTA_ENFD);
-		} else if (!strcmp(this_char, MNTOPT_GQUOTANOENF)) {
+			break;
+		case Opt_gqnoenf:
 			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
 			mp->m_qflags &= ~XFS_OQUOTA_ENFD;
-		} else if (!strcmp(this_char, MNTOPT_DELAYLOG)) {
+			break;
+		case Opt_delaylog:
 			xfs_warn(mp,
-	"delaylog is the default now, option is deprecated.");
-		} else if (!strcmp(this_char, MNTOPT_NODELAYLOG)) {
+		"delaylog is the default now, option is deprecated.");
+			break;
+		case Opt_nodelaylog:
 			xfs_warn(mp,
-	"nodelaylog support has been removed, option is deprecated.");
-		} else if (!strcmp(this_char, MNTOPT_DISCARD)) {
+		"nodelaylog support has been removed, option is deprecated.");
+			break;
+		case Opt_discard:
 			mp->m_flags |= XFS_MOUNT_DISCARD;
-		} else if (!strcmp(this_char, MNTOPT_NODISCARD)) {
+			break;
+		case Opt_nodiscard:
 			mp->m_flags &= ~XFS_MOUNT_DISCARD;
-		} else if (!strcmp(this_char, "ihashsize")) {
+			break;
+		case Opt_ihashsize:
 			xfs_warn(mp,
-	"ihashsize no longer used, option is deprecated.");
-		} else if (!strcmp(this_char, "osyncisdsync")) {
+		"ihashsize no longer used, option is deprecated.");
+		case Opt_osyncisdsync:
 			xfs_warn(mp,
-	"osyncisdsync has no effect, option is deprecated.");
-		} else if (!strcmp(this_char, "osyncisosync")) {
+		"osyncisdsync has no effect, option is deprecated.");
+			break;
+		case Opt_osyncisosync:
 			xfs_warn(mp,
-	"osyncisosync has no effect, option is deprecated.");
-		} else if (!strcmp(this_char, "irixsgid")) {
+		"osyncisosync has no effect, option is deprecated.");
+			break;
+		case Opt_irixsgid:
 			xfs_warn(mp,
-	"irixsgid is now a sysctl(2) variable, option is deprecated.");
-		} else {
-			xfs_warn(mp, "unknown mount option [%s].", this_char);
-			return EINVAL;
+		"irixsgid is now a sysctl(2) variable, option is deprecated.");
+			break;
+		default:
+			xfs_warn(mp, "unknown mount option [%s].", p);
+			break;
 		}
+
+		kfree(string);
+		string = NULL;
 	}
 
+	kfree(orig);
+
 	/*
 	 * no recovery flag requires a read-only mount
 	 */
@@ -468,92 +528,91 @@ done:
 	}
 
 	return 0;
-}
 
-struct proc_xfs_info {
-	int	flag;
-	char	*str;
-};
+free_string:
+	kfree(string);
+	string = NULL;
+free_orig:
+	kfree(orig);
+	return ret;
+}
 
 STATIC int
-xfs_showargs(
-	struct xfs_mount	*mp,
-	struct seq_file		*m)
+xfs_fs_show_options(
+	struct seq_file		*seq,
+	struct dentry		*dentry)
 {
-	static struct proc_xfs_info xfs_info_set[] = {
-		/* the few simple ones we can get from the mount struct */
-		{ XFS_MOUNT_IKEEP,		"," MNTOPT_IKEEP },
-		{ XFS_MOUNT_WSYNC,		"," MNTOPT_WSYNC },
-		{ XFS_MOUNT_NOALIGN,		"," MNTOPT_NOALIGN },
-		{ XFS_MOUNT_SWALLOC,		"," MNTOPT_SWALLOC },
-		{ XFS_MOUNT_NOUUID,		"," MNTOPT_NOUUID },
-		{ XFS_MOUNT_NORECOVERY,		"," MNTOPT_NORECOVERY },
-		{ XFS_MOUNT_ATTR2,		"," MNTOPT_ATTR2 },
-		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
-		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
-		{ XFS_MOUNT_DISCARD,		"," MNTOPT_DISCARD },
-		{ 0, NULL }
-	};
-	static struct proc_xfs_info xfs_info_unset[] = {
-		/* the few simple ones we can get from the mount struct */
-		{ XFS_MOUNT_COMPAT_IOSIZE,	"," MNTOPT_LARGEIO },
-		{ XFS_MOUNT_BARRIER,		"," MNTOPT_NOBARRIER },
-		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_64BITINODE },
-		{ 0, NULL }
-	};
-	struct proc_xfs_info	*xfs_infop;
-
-	for (xfs_infop = xfs_info_set; xfs_infop->flag; xfs_infop++) {
-		if (mp->m_flags & xfs_infop->flag)
-			seq_puts(m, xfs_infop->str);
-	}
-	for (xfs_infop = xfs_info_unset; xfs_infop->flag; xfs_infop++) {
-		if (!(mp->m_flags & xfs_infop->flag))
-			seq_puts(m, xfs_infop->str);
-	}
+	struct xfs_mount	*mp = XFS_M(dentry->d_sb);
 
-	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
-		seq_printf(m, "," MNTOPT_ALLOCSIZE "=%dk",
+	if ((mp->m_flags & XFS_MOUNT_IKEEP))
+		seq_puts(seq, ",ikeep");
+	if ((mp->m_flags & XFS_MOUNT_WSYNC))
+		seq_puts(seq, ",wsync");
+	if ((mp->m_flags & XFS_MOUNT_NOALIGN))
+		seq_puts(seq, ",noalign");
+	if ((mp->m_flags & XFS_MOUNT_SWALLOC))
+		seq_puts(seq, ",swalloc");
+	if ((mp->m_flags & XFS_MOUNT_NOUUID))
+		seq_puts(seq, ",nouuid");
+	if ((mp->m_flags & XFS_MOUNT_NORECOVERY))
+		seq_puts(seq, ",norecovery");
+	if ((mp->m_flags & XFS_MOUNT_ATTR2))
+		seq_puts(seq, ",attr2");
+	if ((mp->m_flags & XFS_MOUNT_FILESTREAMS))
+		seq_puts(seq, ",filestreams");
+	if ((mp->m_flags & XFS_MOUNT_GRPID))
+		seq_puts(seq, ",grpid");
+	if ((mp->m_flags & XFS_MOUNT_DISCARD))
+		seq_puts(seq, ",discard");
+	if (!(mp->m_flags & XFS_MOUNT_COMPAT_IOSIZE))
+		seq_puts(seq, ",largeio");
+	if (!(mp->m_flags & XFS_MOUNT_BARRIER))
+		seq_puts(seq, ",nobarrier");
+	if (!(mp->m_flags & XFS_MOUNT_SMALL_INUMS))
+		seq_puts(seq, ",inode64");
+
+	if ((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE))
+		seq_printf(seq, ",allocsize=%dk",
 				(int)(1 << mp->m_writeio_log) >> 10);
 
 	if (mp->m_logbufs > 0)
-		seq_printf(m, "," MNTOPT_LOGBUFS "=%d", mp->m_logbufs);
+		seq_printf(seq, ",logbufs=%d", mp->m_logbufs);
 	if (mp->m_logbsize > 0)
-		seq_printf(m, "," MNTOPT_LOGBSIZE "=%dk", mp->m_logbsize >> 10);
+		seq_printf(seq, ",logbsize=%dk", mp->m_logbsize >> 10);
 
 	if (mp->m_logname)
-		seq_printf(m, "," MNTOPT_LOGDEV "=%s", mp->m_logname);
+		seq_printf(seq, ",logdev=%s", mp->m_logname);
 	if (mp->m_rtname)
-		seq_printf(m, "," MNTOPT_RTDEV "=%s", mp->m_rtname);
+		seq_printf(seq, ",rtdev=%s", mp->m_rtname);
 
 	if (mp->m_dalign > 0)
-		seq_printf(m, "," MNTOPT_SUNIT "=%d",
+		seq_printf(seq, ",sunit=%d",
 				(int)XFS_FSB_TO_BB(mp, mp->m_dalign));
 	if (mp->m_swidth > 0)
-		seq_printf(m, "," MNTOPT_SWIDTH "=%d",
+		seq_printf(seq, ",swidth=%d",
 				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
 
 	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
-		seq_puts(m, "," MNTOPT_USRQUOTA);
+		seq_puts(seq, ",usrquota");
 	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
-		seq_puts(m, "," MNTOPT_UQUOTANOENF);
+		seq_puts(seq, ",uqnoenforce");
 
 	/* Either project or group quotas can be active, not both */
 
 	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
 		if (mp->m_qflags & XFS_OQUOTA_ENFD)
-			seq_puts(m, "," MNTOPT_PRJQUOTA);
+			seq_puts(seq, ",prjquota");
 		else
-			seq_puts(m, "," MNTOPT_PQUOTANOENF);
+			seq_puts(seq, ",pqnoenforce");
 	} else if (mp->m_qflags & XFS_GQUOTA_ACCT) {
 		if (mp->m_qflags & XFS_OQUOTA_ENFD)
-			seq_puts(m, "," MNTOPT_GRPQUOTA);
+			seq_puts(seq, ",grpquota");
 		else
-			seq_puts(m, "," MNTOPT_GQUOTANOENF);
+			seq_puts(seq, ",gqnoenforce");
 	}
 
 	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
-		seq_puts(m, "," MNTOPT_NOQUOTA);
+		seq_puts(seq, ",noquota");
 
 	return 0;
 }
@@ -1221,14 +1280,6 @@ xfs_fs_unfreeze(
 	return 0;
 }
 
-STATIC int
-xfs_fs_show_options(
-	struct seq_file		*m,
-	struct dentry		*root)
-{
-	return -xfs_showargs(XFS_M(root->d_sb), m);
-}
-
 /*
  * This function fills in xfs_mount_t fields based on mount args.
  * Note: the superblock _has_ now been read in.
-- 
1.7.9.2.323.gf051a

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
