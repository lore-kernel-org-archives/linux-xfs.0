Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1C45XZL198059 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 22:05:33 -0600
Message-ID: <4993A0E4.9010900@sgi.com>
Date: Thu, 12 Feb 2009 15:09:08 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [PATCH, needs new owner] agskip mount option
Content-Type: multipart/mixed; boundary="------------030206020408090608040208"
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

This is a multi-part message in MIME format.
--------------030206020408090608040208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch provides a new mount option, agskip=N, that tells the XFS allocator
to skip over X many AGs when selecting an initial AG for data extent allocations
for a new file.  This option is particularly useful when the volume layout is a
series of concat units - just set N to be the number of AGs in a concat and data
allocations will then be load balanced over the spindles.

--------------030206020408090608040208
Content-Type: text/x-patch;
 name="agskip.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="agskip.patch"

--- linux.orig/fs/xfs/xfs_alloc.c
+++ linux/fs/xfs/xfs_alloc.c
@@ -2334,12 +2334,20 @@ xfs_alloc_vextent(
 		 * Try near allocation first, then anywhere-in-ag after
 		 * the first a.g. fails.
 		 */
-		if ((args->userdata  == XFS_ALLOC_INITIAL_USER_DATA) &&
-		    (mp->m_flags & XFS_MOUNT_32BITINODES)) {
-			args->fsbno = XFS_AGB_TO_FSB(mp,
-					((mp->m_agfrotor / rotorstep) %
-					mp->m_sb.sb_agcount), 0);
-			bump_rotor = 1;
+		if (args->userdata == XFS_ALLOC_INITIAL_USER_DATA) {
+			if (mp->m_flags & XFS_MOUNT_AGSKIP) {
+				spin_lock(&mp->m_agfrotor_lock);
+				args->fsbno = XFS_AGB_TO_FSB(mp,
+					mp->m_agfrotor, 0);
+				mp->m_agfrotor = (mp->m_agfrotor + mp->m_agskip)
+					% mp->m_sb.sb_agcount;
+				spin_unlock(&mp->m_agfrotor_lock);
+			} else if (mp->m_flags & XFS_MOUNT_32BITINODES) {
+				args->fsbno = XFS_AGB_TO_FSB(mp,
+						((mp->m_agfrotor / rotorstep) %
+						mp->m_sb.sb_agcount), 0);
+				bump_rotor = 1;
+			}
 		}
 		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
 		args->type = XFS_ALLOCTYPE_NEAR_BNO;
@@ -2354,8 +2362,15 @@ xfs_alloc_vextent(
 			/*
 			 * Start with the last place we left off.
 			 */
-			args->agno = sagno = (mp->m_agfrotor / rotorstep) %
+			if (mp->m_flags & XFS_MOUNT_AGSKIP) {
+				spin_lock(&mp->m_agfrotor_lock);
+				sagno = mp->m_agfrotor;
+				spin_unlock(&mp->m_agfrotor_lock);
+			} else {
+				sagno = (mp->m_agfrotor / rotorstep) %
 					mp->m_sb.sb_agcount;
+			}
+			args->agno = sagno;
 			args->type = XFS_ALLOCTYPE_THIS_AG;
 			flags = XFS_ALLOC_FLAG_TRYLOCK;
 		} else if (type == XFS_ALLOCTYPE_FIRST_AG) {
--- linux.orig/fs/xfs/xfs_clnt.h
+++ linux/fs/xfs/xfs_clnt.h
@@ -52,6 +52,7 @@ struct xfs_mount_args {
 	int	swidth;		/* stripe width (BBs), multiple of sunit */
 	uchar_t iosizelog;	/* log2 of the preferred I/O size */
 	int	ihashsize;	/* inode hash table size (buckets) */
+	int	agskip;		/* initial extent allocation stride */
 };
 
 /*
@@ -69,6 +70,7 @@ struct xfs_mount_args {
 #define XFSMNT_PQUOTAENF	0x00000040	/* IRIX project quota limit
 						 * enforcement */
 #define XFSMNT_QUIET		0x00000080	/* don't report mount errors */
+#define XFSMNT_AGSKIP		0x00000100	/* extent allocation stride */
 #define XFSMNT_NOALIGN		0x00000200	/* don't allocate at
 						 * stripe boundaries*/
 #define XFSMNT_RETERR		0x00000400	/* return error to user */
--- linux.orig/fs/xfs/xfs_filestream.c
+++ linux/fs/xfs/xfs_filestream.c
@@ -575,7 +575,13 @@ xfs_filestream_associate(
 	 * Set the starting AG using the rotor for inode32, otherwise
 	 * use the directory inode's AG.
 	 */
-	if (mp->m_flags & XFS_MOUNT_32BITINODES) {
+	if (mp->m_flags & XFS_MOUNT_AGSKIP) {
+		spin_lock(&mp->m_agfrotor_lock);
+		startag = mp->m_agfrotor;
+		mp->m_agfrotor = (mp->m_agfrotor + mp->m_agskip)
+			% mp->m_sb.sb_agcount;
+		spin_unlock(&mp->m_agfrotor_lock);
+	} else if (mp->m_flags & XFS_MOUNT_32BITINODES) {
 		rotorstep = xfs_rotorstep;
 		startag = (mp->m_agfrotor / rotorstep) % mp->m_sb.sb_agcount;
 		mp->m_agfrotor = (mp->m_agfrotor + 1) %
--- linux.orig/fs/xfs/xfs_mount.c
+++ linux/fs/xfs/xfs_mount.c
@@ -576,6 +576,7 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb
 	int	i;
 
 	mp->m_agfrotor = mp->m_agirotor = 0;
+	spinlock_init(&mp->m_agfrotor_lock, "m_agfrotor_lock");
 	spinlock_init(&mp->m_agirotor_lock, "m_agirotor_lock");
 	mp->m_maxagi = mp->m_sb.sb_agcount;
 	mp->m_blkbit_log = sbp->sb_blocklog + XFS_NBBYLOG;
--- linux.orig/fs/xfs/xfs_mount.h
+++ linux/fs/xfs/xfs_mount.h
@@ -336,6 +336,7 @@ typedef struct xfs_mount {
 	char			*m_logname;	/* external log device name */
 	int			m_bsize;	/* fs logical block size */
 	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
+	spinlock_t		m_agfrotor_lock;/* .. and lock protecting it */
 	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
 	lock_t			m_agirotor_lock;/* .. and lock protecting it */
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
@@ -429,6 +430,7 @@ typedef struct xfs_mount {
 	struct mutex		m_icsb_mutex;	/* balancer sync lock */
 #endif
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
+	int			m_agskip;	/* extent allocation stride */
 } xfs_mount_t;
 
 /*
@@ -471,6 +473,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_FILESTREAMS	(1ULL << 24)	/* enable the filestreams
 						   allocator */
 #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
+#define XFS_MOUNT_AGSKIP	(1ULL << 26)	/* extent allocation stride */
 
 
 /*
--- linux.orig/fs/xfs/xfs_vfsops.c
+++ linux/fs/xfs/xfs_vfsops.c
@@ -326,6 +326,11 @@ xfs_start_flags(
 	if (ap->flags2 & XFSMNT2_FILESTREAMS)
 		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
 
+	if (ap->flags & XFSMNT_AGSKIP) {
+		mp->m_flags |= XFS_MOUNT_AGSKIP;
+		mp->m_agskip = ap->agskip;
+	}
+
 	return 0;
 }
 
@@ -1527,6 +1532,7 @@ xfs_vget(
 #define MNTOPT_ATTR2	"attr2"		/* do use attr2 attribute format */
 #define MNTOPT_NOATTR2	"noattr2"	/* do not use attr2 attribute format */
 #define MNTOPT_FILESTREAM  "filestreams" /* use filestreams allocator */
+#define MNTOPT_AGSKIP	"agskip"	/* initial extent allocation stride */
 
 STATIC unsigned long
 suffix_strtoul(char *s, char **endp, unsigned int base)
@@ -1678,6 +1684,15 @@ xfs_parseargs(
 				return EINVAL;
 			}
 			dswidth = simple_strtoul(value, &eov, 10);
+		} else if (!strcmp(this_char, MNTOPT_AGSKIP)) {
+			if (!value || !*value) {
+				cmn_err(CE_WARN,
+					"XFS: %s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			args->flags |= XFSMNT_AGSKIP;
+			args->agskip = simple_strtoul(value, &eov, 10);
 		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
 			args->flags &= ~XFSMNT_32BITINODES;
 #if !XFS_BIG_INUMS

--------------030206020408090608040208
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------030206020408090608040208--
