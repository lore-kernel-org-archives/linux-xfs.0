Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6O2Bn2Z015033 for <xfs@oss.sgi.com>; Mon, 23 Jul 2012 21:11:49 -0500
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id Gl5wQVijgwzvCQGQ for
	<xfs@oss.sgi.com>; Mon, 23 Jul 2012 19:11:46 -0700 (PDT)
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH V6] xfs: cleanup the mount options
Date: Tue, 24 Jul 2012 10:10:43 +0800
Message-Id: <1343095843-32230-1-git-send-email-gaowanlong@cn.fujitsu.com>
In-Reply-To: <20120723232813.GL23387@dastard>
References: <20120723232813.GL23387@dastard>
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
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Zach Brown <zab@zabbo.net>, Wanlong Gao <gaowanlong@cn.fujitsu.com>

remove the mount options macro, use tokens instead.

change from V5: (Dave)
1. fix a string leak.
2. leave the show options to raw numbers.

change from V4: (as Dave suggested)
1. suffix_match_int avoid overflow.
2. convert the return style to be consistent with others.
3. move the "intarg" init above the switch.
4. move match_strdup to a help function.
5. collapsed Opt_biosize and Opt_allocsize.
6. make a consistent deprecated message.

CC: Ben Myers <bpm@sgi.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Dave Chinner <david@fromorbit.com>
CC: Zach Brown <zab@zabbo.net>
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 fs/xfs/xfs_super.c | 551 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 325 insertions(+), 226 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 07f70e1..eb9aa89 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -66,91 +66,171 @@ static const struct super_operations xfs_super_operations;
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
+#define	MNTOPT_LOGBUFS		"logbufs"
+#define	MNTOPT_LOGBSIZE		"logbsize"
+#define	MNTOPT_LOGDEV		"logdev"
+#define	MNTOPT_RTDEV		"rtdev"
+#define	MNTOPT_BIOSIZE		"biosize"
+#define	MNTOPT_WSYNC		"wsync"
+#define	MNTOPT_NOALIGN		"noalign"
+#define	MNTOPT_SWALLOC		"swalloc"
+#define	MNTOPT_SUNIT		"sunit"
+#define	MNTOPT_SWIDTH		"swidth"
+#define	MNTOPT_NOUUID		"nouuid"
+#define	MNTOPT_MTPT		"mtpt"
+#define	MNTOPT_GRPID		"grpid"
+#define	MNTOPT_NOGRPID		"nogrpid"
+#define	MNTOPT_BSDGROUPS	"bsdgroups"
+#define	MNTOPT_SYSVGROUPS	"sysvgroups"
+#define	MNTOPT_ALLOCSIZE	"allocsize"
+#define	MNTOPT_NORECOVERY	"norecovery"
+#define	MNTOPT_BARRIER		"barrier"
+#define	MNTOPT_NOBARRIER	"nobarrier"
+#define	MNTOPT_64BITINODE	"inode64"
+#define	MNTOPT_IKEEP		"ikeep"
+#define	MNTOPT_NOIKEEP		"noikeep"
+#define	MNTOPT_LARGEIO		"largeio"
+#define	MNTOPT_NOLARGEIO	"nolargeio"
+#define	MNTOPT_ATTR2		"attr2"
+#define	MNTOPT_NOATTR2		"noattr2"
+#define	MNTOPT_FILESTREAM	"filestreams"
+#define	MNTOPT_QUOTA		"quota"
+#define	MNTOPT_NOQUOTA		"noquota"
+#define	MNTOPT_USRQUOTA		"usrquota"
+#define	MNTOPT_GRPQUOTA		"grpquota"
+#define	MNTOPT_PRJQUOTA		"prjquota"
+#define	MNTOPT_UQUOTA		"uquota"
+#define	MNTOPT_GQUOTA		"gquota"
+#define	MNTOPT_PQUOTA		"pquota"
+#define	MNTOPT_UQUOTANOENF	"uqnoenforce"
+#define	MNTOPT_GQUOTANOENF	"gqnoenforce"
+#define	MNTOPT_PQUOTANOENF	"pqnoenforce"
+#define	MNTOPT_QUOTANOENF	"qnoenforce"
+#define	MNTOPT_DISCARD		"discard"
+#define	MNTOPT_NODISCARD	"nodiscard"
+#define	MNTOPT_DELAYLOG		"delaylog"
+#define	MNTOPT_NODELAYLOG	"nodelaylog"
+#define	MNTOPT_IHASHSIZE	"ihashsize"
+#define	MNTOPT_OSYNCISDSYNC	"osyncisdsync"
+#define	MNTOPT_OSYNCISOSYNC	"osyncisosync"
+#define	MNTOPT_IRIXSGID		"irixsgid"
+
+#define MNTOPT_DEPRECATED "has no effect, option is deprecated"
 
-/*
- * Table driven mount option parser.
- *
- * Currently only used for remount, but it will be used for mount
- * in the future, too.
- */
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
+	Opt_qnoenf, Opt_discard, Opt_nodiscard, Opt_delaylog, Opt_nodelaylog,
+	Opt_ihashsize, Opt_osyncisdsync, Opt_osyncisosync, Opt_irixsgid,
+	Opt_err
 };
 
 static const match_table_t tokens = {
-	{Opt_barrier, "barrier"},
-	{Opt_nobarrier, "nobarrier"},
+	{Opt_logbufs, MNTOPT_LOGBUFS "=%d"},	/* number of XFS log buffers */
+	{Opt_logbsize, MNTOPT_LOGBSIZE "=%s"},	/* size of XFS log buffers */
+	{Opt_logdev, MNTOPT_LOGDEV "=%s"},	/* log device */
+	{Opt_rtdev, MNTOPT_RTDEV "=%s"},	/* realtime I/O device */
+	{Opt_biosize, MNTOPT_BIOSIZE "=%d"},	/* log2 of preferred buffered io size */
+	{Opt_wsync, MNTOPT_WSYNC},		/* safe-mode nfs compatible mount */
+	{Opt_noalign, MNTOPT_NOALIGN},		/* turn off stripe alignment */
+	{Opt_swalloc, MNTOPT_SWALLOC},		/* turn on stripe width allocation */
+	{Opt_sunit, MNTOPT_SUNIT "=%d"},	/* data volume stripe unit */
+	{Opt_swidth, MNTOPT_SWIDTH "=%d"},	/* data volume stripe width */
+	{Opt_nouuid, MNTOPT_NOUUID},		/* ignore filesystem UUID */
+	{Opt_mtpt, MNTOPT_MTPT},		/* filesystem mount point */
+	{Opt_grpid, MNTOPT_GRPID},		/* group-ID from parent directory */
+	{Opt_nogrpid, MNTOPT_NOGRPID},		/* group-ID from current process */
+	{Opt_bsdgroups, MNTOPT_BSDGROUPS},	/* group-ID from parent directory */
+	{Opt_sysvgroups, MNTOPT_SYSVGROUPS},	/* group-ID from current process */
+	{Opt_allocsize, MNTOPT_ALLOCSIZE "=%s"},/* preferred allocation size */
+	{Opt_norecovery, MNTOPT_NORECOVERY},	/* do not run XFS recovery */
+	{Opt_barrier, MNTOPT_BARRIER},		/* use writer barrier for log write and
+						 * unwritten extent conversation */
+	{Opt_nobarrier, MNTOPT_NOBARRIER},	/* .. disable */
+	{Opt_inode64, MNTOPT_64BITINODE},	/* inodes can be allocated anywhere */
+	{Opt_ikeep, MNTOPT_IKEEP},		/* do not free empty inode clusters */
+	{Opt_noikeep, MNTOPT_NOIKEEP},		/* free empty inode clusters */
+	{Opt_largeio, MNTOPT_LARGEIO},		/* report large I/O sizes in start() */
+	{Opt_nolargeio, MNTOPT_NOLARGEIO},	/* do not report large I/O sizes
+						 * in start() */
+	{Opt_attr2, MNTOPT_ATTR2},		/* do use attr2 attribute format */
+	{Opt_noattr2, MNTOPT_NOATTR2},		/* do not use attr2 attribute format */
+	{Opt_filestreams, MNTOPT_FILESTREAM}, 	/* use filestreams allocator */
+	{Opt_quota, MNTOPT_QUOTA},		/* disk quotas (user) */
+	{Opt_noquota, MNTOPT_NOQUOTA},		/* no quotas */
+	{Opt_usrquota, MNTOPT_USRQUOTA},	/* user quota enabled */
+	{Opt_grpquota, MNTOPT_GRPQUOTA},	/* group quota enabled */
+	{Opt_prjquota, MNTOPT_PRJQUOTA},	/* project quota enabled */
+	{Opt_uquota, MNTOPT_UQUOTA},		/* user quota (IRIX variant) */
+	{Opt_gquota, MNTOPT_GQUOTA},		/* group quota (IRIX variant) */
+	{Opt_pquota, MNTOPT_PQUOTA},		/* project quota (IRIX variant) */
+	{Opt_uqnoenf, MNTOPT_UQUOTANOENF},	/* user quota limit enforcement */
+	{Opt_gqnoenf, MNTOPT_GQUOTANOENF},	/* group quota limit enforcement */
+	{Opt_pqnoenf, MNTOPT_PQUOTANOENF},	/* project quota limit enforcement */
+	{Opt_qnoenf, MNTOPT_QUOTANOENF},	/* same as uqnoenforce */
+	{Opt_discard, MNTOPT_DISCARD},		/* Discard unused blocks */
+	{Opt_nodiscard, MNTOPT_NODISCARD},	/* Do not discard unused blocks */
+	{Opt_delaylog, MNTOPT_DELAYLOG},	/* deprecated */
+	{Opt_nodelaylog, MNTOPT_NODELAYLOG},	/* deprecated */
+	{Opt_ihashsize, MNTOPT_IHASHSIZE},	/* deprecated */
+	{Opt_osyncisdsync, MNTOPT_OSYNCISDSYNC},/* deprecated */
+	{Opt_osyncisosync, MNTOPT_OSYNCISOSYNC},/* deprecated */
+	{Opt_irixsgid, MNTOPT_IRIXSGID},	/* deprecated */
 	{Opt_err, NULL}
 };
 
-
-STATIC unsigned long
-suffix_strtoul(char *s, char **endp, unsigned int base)
+STATIC int
+suffix_match_int(substring_t *s, unsigned long *result)
 {
-	int	last, shift_left_factor = 0;
-	char	*value = s;
+	int shift_left_factor = 0;
+	char *value = s->to - 1;
+	char *string;
 
-	last = strlen(value) - 1;
-	if (value[last] == 'K' || value[last] == 'k') {
+	if (*value == 'K' || *value == 'k') {
 		shift_left_factor = 10;
-		value[last] = '\0';
+		s->to--;
 	}
-	if (value[last] == 'M' || value[last] == 'm') {
+	if (*value == 'M' || *value == 'm') {
 		shift_left_factor = 20;
-		value[last] = '\0';
+		s->to--;
 	}
-	if (value[last] == 'G' || value[last] == 'g') {
+	if (*value == 'G' || *value == 'g') {
 		shift_left_factor = 30;
-		value[last] = '\0';
+		s->to--;
 	}
 
-	return simple_strtoul((const char *)s, endp, base) << shift_left_factor;
+	string = match_strdup(s);
+	if (!string)
+		return ENOMEM;
+
+	*result = simple_strtoul((const char *)string, NULL, 0) <<
+			shift_left_factor;
+
+	kfree(string);
+	return 0;
+}
+
+STATIC int
+match_name_strdup(substring_t *s, char *name)
+{
+	char *string;
+	int ret = 0;
+	string = match_strdup(s);
+	if (!string)
+		return ENOMEM;
+
+	name = kstrndup(string, MAXNAMELEN, GFP_KERNEL);
+	if (!name)
+		ret = ENOMEM;
+
+	kfree(string);
+	return ret;
 }
 
 /*
@@ -166,11 +246,15 @@ xfs_parseargs(
 	char			*options)
 {
 	struct super_block	*sb = mp->m_super;
-	char			*this_char, *value, *eov;
+	char			*p;
 	int			dsunit = 0;
 	int			dswidth = 0;
-	int			iosize = 0;
 	__uint8_t		iosizelog = 0;
+	int			intarg;
+	unsigned long		ularg;
+	substring_t		args[MAX_OPT_ARGS];
+	char			*orig = NULL;
+	int			ret = 0;
 
 	/*
 	 * set up the mount name first so all the errors will refer to the
@@ -208,175 +292,190 @@ xfs_parseargs(
 	if (!options)
 		goto done;
 
-	while ((this_char = strsep(&options, ",")) != NULL) {
-		if (!*this_char)
+	orig = kstrdup(options, GFP_NOFS);
+	if (!orig) {
+		ret = ENOMEM;
+		goto done;
+	}
+
+	while ((p = strsep(&options, ",")) != NULL) {
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
-			if (!mp->m_logname)
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
-			if (!mp->m_rtname)
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
+
+		token = match_token(p, tokens, args);
+		intarg = 0;
+		ularg = 0;
+		switch (token) {
+		case Opt_logbufs:
+			ret = match_int(args, &intarg);
+			if (ret)
+				goto free_orig;
+			mp->m_logbufs = intarg;
+			break;
+		case Opt_logbsize:
+			ret = suffix_match_int(args, &ularg);
+			if (ret)
+				goto free_orig;
+			mp->m_logbsize = ularg;
+			break;
+		case Opt_logdev:
+			ret = match_name_strdup(args, mp->m_logname);
+			if (ret)
+				goto free_orig;
+			break;
+		case Opt_mtpt:
+			xfs_warn(mp, "%s option not allowed on this system", p);
+			ret = EINVAL;
+			goto free_orig;
+		case Opt_rtdev:
+			ret = match_name_strdup(args, mp->m_rtname);
+			if (ret)
+				goto free_orig;
+			break;
+		case Opt_biosize:
+		case Opt_allocsize:
+			ret = suffix_match_int(args, &ularg);
+			if (ret)
+				goto free_orig;
+			iosizelog = ffs(ularg) - 1;
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
+			ret = match_int(args, &intarg);
+			if (ret)
+				goto free_orig;
+			dsunit = intarg;
+			break;
+		case Opt_swidth:
+			ret = match_int(args, &intarg);
+			if (ret)
+				goto free_orig;
+			dswidth = intarg;
+			break;
+		case Opt_inode64:
 			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
 #if !XFS_BIG_INUMS
-			xfs_warn(mp, "%s option not allowed on this system",
-				this_char);
-			return EINVAL;
+			xfs_warn(mp, "%s options not allowed on this system", p);
+			ret = EINVAL;
+			goto free_orig;
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
-			xfs_warn(mp,
-	"delaylog is the default now, option is deprecated.");
-		} else if (!strcmp(this_char, MNTOPT_NODELAYLOG)) {
-			xfs_warn(mp,
-	"nodelaylog support has been removed, option is deprecated.");
-		} else if (!strcmp(this_char, MNTOPT_DISCARD)) {
+			break;
+		case Opt_discard:
 			mp->m_flags |= XFS_MOUNT_DISCARD;
-		} else if (!strcmp(this_char, MNTOPT_NODISCARD)) {
+			break;
+		case Opt_nodiscard:
 			mp->m_flags &= ~XFS_MOUNT_DISCARD;
-		} else if (!strcmp(this_char, "ihashsize")) {
-			xfs_warn(mp,
-	"ihashsize no longer used, option is deprecated.");
-		} else if (!strcmp(this_char, "osyncisdsync")) {
-			xfs_warn(mp,
-	"osyncisdsync has no effect, option is deprecated.");
-		} else if (!strcmp(this_char, "osyncisosync")) {
-			xfs_warn(mp,
-	"osyncisosync has no effect, option is deprecated.");
-		} else if (!strcmp(this_char, "irixsgid")) {
-			xfs_warn(mp,
-	"irixsgid is now a sysctl(2) variable, option is deprecated.");
-		} else {
-			xfs_warn(mp, "unknown mount option [%s].", this_char);
-			return EINVAL;
+			break;
+		case Opt_delaylog:
+			xfs_warn(mp, MNTOPT_DELAYLOG MNTOPT_DEPRECATED);
+			break;
+		case Opt_nodelaylog:
+			xfs_warn(mp, MNTOPT_NODELAYLOG MNTOPT_DEPRECATED);
+			break;
+		case Opt_ihashsize:
+			xfs_warn(mp, MNTOPT_IHASHSIZE MNTOPT_DEPRECATED);
+		case Opt_osyncisdsync:
+			xfs_warn(mp, MNTOPT_OSYNCISDSYNC MNTOPT_DEPRECATED);
+			break;
+		case Opt_osyncisosync:
+			xfs_warn(mp, MNTOPT_OSYNCISOSYNC MNTOPT_DEPRECATED);
+			break;
+		case Opt_irixsgid:
+			xfs_warn(mp, MNTOPT_IRIXSGID MNTOPT_DEPRECATED);
+			break;
+		default:
+			xfs_warn(mp, "unknown mount option [%s].", p);
+			break;
 		}
 	}
 
+	kfree(orig);
+
 	/*
 	 * no recovery flag requires a read-only mount
 	 */
@@ -468,6 +567,10 @@ done:
 	}
 
 	return 0;
+
+free_orig:
+	kfree(orig);
+	return ret;
 }
 
 struct proc_xfs_info {
@@ -476,10 +579,12 @@ struct proc_xfs_info {
 };
 
 STATIC int
-xfs_showargs(
-	struct xfs_mount	*mp,
-	struct seq_file		*m)
+xfs_fs_show_options(
+	struct seq_file		*seq,
+	struct dentry		*dentry)
 {
+	struct xfs_mount	*mp = XFS_M(dentry->d_sb);
+
 	static struct proc_xfs_info xfs_info_set[] = {
 		/* the few simple ones we can get from the mount struct */
 		{ XFS_MOUNT_IKEEP,		"," MNTOPT_IKEEP },
@@ -505,58 +610,60 @@ xfs_showargs(
 
 	for (xfs_infop = xfs_info_set; xfs_infop->flag; xfs_infop++) {
 		if (mp->m_flags & xfs_infop->flag)
-			seq_puts(m, xfs_infop->str);
+			seq_puts(seq, xfs_infop->str);
 	}
 	for (xfs_infop = xfs_info_unset; xfs_infop->flag; xfs_infop++) {
 		if (!(mp->m_flags & xfs_infop->flag))
-			seq_puts(m, xfs_infop->str);
+			seq_puts(seq, xfs_infop->str);
 	}
 
 	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
-		seq_printf(m, "," MNTOPT_ALLOCSIZE "=%dk",
-				(int)(1 << mp->m_writeio_log) >> 10);
+		seq_printf(seq, "," MNTOPT_ALLOCSIZE "=%d",
+				(int)(1 << mp->m_writeio_log));
 
 	if (mp->m_logbufs > 0)
-		seq_printf(m, "," MNTOPT_LOGBUFS "=%d", mp->m_logbufs);
+		seq_printf(seq, "," MNTOPT_LOGBUFS "=%d", mp->m_logbufs);
 	if (mp->m_logbsize > 0)
-		seq_printf(m, "," MNTOPT_LOGBSIZE "=%dk", mp->m_logbsize >> 10);
+		seq_printf(seq, "," MNTOPT_LOGBSIZE "=%d",
+				mp->m_logbsize);
 
 	if (mp->m_logname)
-		seq_printf(m, "," MNTOPT_LOGDEV "=%s", mp->m_logname);
+		seq_printf(seq, "," MNTOPT_LOGDEV "=%s", mp->m_logname);
 	if (mp->m_rtname)
-		seq_printf(m, "," MNTOPT_RTDEV "=%s", mp->m_rtname);
+		seq_printf(seq, "," MNTOPT_RTDEV "=%s", mp->m_rtname);
 
 	if (mp->m_dalign > 0)
-		seq_printf(m, "," MNTOPT_SUNIT "=%d",
+		seq_printf(seq, "," MNTOPT_SUNIT "=%d",
 				(int)XFS_FSB_TO_BB(mp, mp->m_dalign));
 	if (mp->m_swidth > 0)
-		seq_printf(m, "," MNTOPT_SWIDTH "=%d",
+		seq_printf(seq, "," MNTOPT_SWIDTH "=%d",
 				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
 
 	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
-		seq_puts(m, "," MNTOPT_USRQUOTA);
+		seq_puts(seq, "," MNTOPT_USRQUOTA);
 	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
-		seq_puts(m, "," MNTOPT_UQUOTANOENF);
+		seq_puts(seq, "," MNTOPT_UQUOTANOENF);
 
 	/* Either project or group quotas can be active, not both */
 
 	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
 		if (mp->m_qflags & XFS_OQUOTA_ENFD)
-			seq_puts(m, "," MNTOPT_PRJQUOTA);
+			seq_puts(seq, "," MNTOPT_PRJQUOTA);
 		else
-			seq_puts(m, "," MNTOPT_PQUOTANOENF);
+			seq_puts(seq, "," MNTOPT_PQUOTANOENF);
 	} else if (mp->m_qflags & XFS_GQUOTA_ACCT) {
 		if (mp->m_qflags & XFS_OQUOTA_ENFD)
-			seq_puts(m, "," MNTOPT_GRPQUOTA);
+			seq_puts(seq, "," MNTOPT_GRPQUOTA);
 		else
-			seq_puts(m, "," MNTOPT_GQUOTANOENF);
+			seq_puts(seq, "," MNTOPT_GQUOTANOENF);
 	}
 
 	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
-		seq_puts(m, "," MNTOPT_NOQUOTA);
+		seq_puts(seq, "," MNTOPT_NOQUOTA);
 
 	return 0;
 }
+
 __uint64_t
 xfs_max_file_offset(
 	unsigned int		blockshift)
@@ -1221,14 +1328,6 @@ xfs_fs_unfreeze(
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
1.7.11.3.287.ge771946

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
