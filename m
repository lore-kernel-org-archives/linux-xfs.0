Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Feb 2008 23:40:12 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1G7e2mm004769
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 23:40:06 -0800
Date: Sat, 16 Feb 2008 18:40:19 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Differences in mkfs.xfs and xfs_info output.
Message-ID: <20080216074019.GV155407@sgi.com>
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Derfinak <ja@mail.upjs.sk>
Cc: xfs@oss.sgi.com

On Sat, Feb 16, 2008 at 02:34:08AM +0100, Jan Derfinak wrote:
> Hello.
> 
> I found following problem with xfs_info (xfs_grows -p xfs_info) command:
> 
> # mkfs.xfs -f /dev/loop0     
> meta-data=/dev/loop0             isize=256    agcount=4, agsize=32000 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=128000, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096  
> log      =internal log           bsize=4096   blocks=1200, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> # mount /dev/loop0 /mnt/usb
> # xfs_info /mnt/usb
> meta-data=/dev/loop0             isize=256    agcount=4, agsize=32000 blks
>          =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=128000, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096  
> log      =internal               bsize=4096   blocks=1200, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Can somebody explain the difference in attr and lazy-count parameters?
> Which output is the right one?
.....
> # xfs_db -r /dev/loop0 
> xfs_db> sb
> xfs_db> print
....
> features2 = 0

That's why.

I've been meaning to push out a patch to fix this - just haven't
had time. The patch below should fix the problem - mkfs.xfs is writing
the features2 field to the wrong location in the superblock, and
this patch detects and corrects it. You'll probably see the output:

XFS: correcting sb_features alignment problem

in dmesg when you first mount the filesystem with the patched
kernel, and then it won't appear again (unless you mkfs it again).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_mount.c |   34 ++++++++++++++++++++++++++++------
 fs/xfs/xfs_sb.h    |   37 ++++++++++++++++++++++++++++++++++---
 2 files changed, 62 insertions(+), 9 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2007-11-22 10:25:25.590278381 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2007-11-22 10:31:27.891999961 +1100
@@ -44,7 +44,7 @@
 #include "xfs_quota.h"
 #include "xfs_fsops.h"
 
-STATIC void	xfs_mount_log_sbunit(xfs_mount_t *, __int64_t);
+STATIC void	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
 STATIC int	xfs_uuid_mount(xfs_mount_t *);
 STATIC void	xfs_uuid_unmount(xfs_mount_t *mp);
 STATIC void	xfs_unmountfs_wait(xfs_mount_t *);
@@ -119,6 +119,7 @@ static const struct {
     { offsetof(xfs_sb_t, sb_logsectsize),0 },
     { offsetof(xfs_sb_t, sb_logsunit),	 0 },
     { offsetof(xfs_sb_t, sb_features2),	 0 },
+    { offsetof(xfs_sb_t, sb_bad_features2), 0 },
     { sizeof(xfs_sb_t),			 0 }
 };
 
@@ -455,6 +456,7 @@ xfs_sb_from_disk(
 	to->sb_logsectsize = be16_to_cpu(from->sb_logsectsize);
 	to->sb_logsunit = be32_to_cpu(from->sb_logsunit);
 	to->sb_features2 = be32_to_cpu(from->sb_features2);
+	to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
 }
 
 /*
@@ -976,6 +978,26 @@ xfs_mountfs(
 	xfs_mount_common(mp, sbp);
 
 	/*
+	 * Check for a bad features2 field alignment. This happened on
+	 * some platforms due to xfs_sb_t not being 64bit size aligned
+	 * when sb_features was added and hence the compiler put it in
+	 * the wrong place.
+	 *
+	 * If we detect a bad field, we or the set bits into the existing
+	 * features2 field in case it has already been modified and we
+	 * don't want to lose any features. Zero the bad one and mark
+	 * the two fields as needing updates once the transaction subsystem
+	 * is online.
+	 */
+	if (xfs_sb_has_bad_features2(sbp)) {
+		cmn_err(CE_WARN,
+			"XFS: correcting sb_features alignment problem");
+		sbp->sb_features2 |= sbp->sb_bad_features2;
+		sbp->sb_bad_features2 = 0;
+		update_flags |= XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2;
+	}
+
+	/*
 	 * Check if sb_agblocks is aligned at stripe boundary
 	 * If sb_agblocks is NOT aligned turn off m_dalign since
 	 * allocator alignment is within an ag, therefore ag has
@@ -1165,11 +1187,10 @@ xfs_mountfs(
 	}
 
 	/*
-	 * If fs is not mounted readonly, then update the superblock
-	 * unit and width changes.
+	 * If fs is not mounted readonly, then update the superblock changes.
 	 */
 	if (update_flags && !(mp->m_flags & XFS_MOUNT_RDONLY))
-		xfs_mount_log_sbunit(mp, update_flags);
+		xfs_mount_log_sb(mp, update_flags);
 
 	/*
 	 * Initialise the XFS quota management subsystem for this mount
@@ -1884,13 +1905,14 @@ xfs_uuid_unmount(
  * be altered by the mount options. Only the first superblock is updated.
  */
 STATIC void
-xfs_mount_log_sbunit(
+xfs_mount_log_sb(
 	xfs_mount_t	*mp,
 	__int64_t	fields)
 {
 	xfs_trans_t	*tp;
 
-	ASSERT(fields & (XFS_SB_UNIT|XFS_SB_WIDTH|XFS_SB_UUID));
+	ASSERT(fields & (XFS_SB_UNIT | XFS_SB_WIDTH | XFS_SB_UUID |
+			 XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2));
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SB_UNIT);
 	if (xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
Index: 2.6.x-xfs-new/fs/xfs/xfs_sb.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_sb.h	2007-11-22 10:25:25.598277360 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_sb.h	2007-11-22 10:31:27.891999961 +1100
@@ -89,6 +89,7 @@ struct xfs_mount;
 
 /*
  * Superblock - in core version.  Must match the ondisk version below.
+ * Must be padded to 64 bit alignment.
  */
 typedef struct xfs_sb {
 	__uint32_t	sb_magicnum;	/* magic number == XFS_SB_MAGIC */
@@ -145,10 +146,21 @@ typedef struct xfs_sb {
 	__uint16_t	sb_logsectsize;	/* sector size for the log, bytes */
 	__uint32_t	sb_logsunit;	/* stripe unit size for the log */
 	__uint32_t	sb_features2;	/* additional feature bits */
+
+	/*
+	 * bad features2 field as a result of failing to pad the sb
+	 * structure to 64 bits. Some machines will be using this field
+	 * for features2 bits. Easiest just to mark it bad and not use
+	 * it for anything else.
+	 */
+	__uint32_t	sb_bad_features2;
+
+	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 
 /*
- * Superblock - on disk version.  Must match the in core version below.
+ * Superblock - on disk version.  Must match the in core version above.
+ * Must be padded to 64 bit alignment.
  */
 typedef struct xfs_dsb {
 	__be32		sb_magicnum;	/* magic number == XFS_SB_MAGIC */
@@ -205,6 +217,15 @@ typedef struct xfs_dsb {
 	__be16		sb_logsectsize;	/* sector size for the log, bytes */
 	__be32		sb_logsunit;	/* stripe unit size for the log */
 	__be32		sb_features2;	/* additional feature bits */
+	/*
+	 * bad features2 field as a result of failing to pad the sb
+	 * structure to 64 bits. Some machines will be using this field
+	 * for features2 bits. Easiest just to mark it bad and not use
+	 * it for anything else.
+	 */
+	__be32	sb_bad_features2;
+
+	/* must be padded to 64 bit alignment */
 } xfs_dsb_t;
 
 /*
@@ -223,7 +244,7 @@ typedef enum {
 	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
 	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
 	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
-	XFS_SBS_FEATURES2,
+	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2,
 	XFS_SBS_FIELDCOUNT
 } xfs_sb_field_t;
 
@@ -248,13 +269,15 @@ typedef enum {
 #define XFS_SB_IFREE		XFS_SB_MVAL(IFREE)
 #define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
 #define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
+#define XFS_SB_BAD_FEATURES2	XFS_SB_MVAL(BAD_FEATURES2)
 #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
 #define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
 #define	XFS_SB_MOD_BITS		\
 	(XFS_SB_UUID | XFS_SB_ROOTINO | XFS_SB_RBMINO | XFS_SB_RSUMINO | \
 	 XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO | XFS_SB_GQUOTINO | \
 	 XFS_SB_QFLAGS | XFS_SB_SHARED_VN | XFS_SB_UNIT | XFS_SB_WIDTH | \
-	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2)
+	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \
+	 XFS_SB_BAD_FEATURES2)
 
 
 /*
@@ -297,6 +320,14 @@ static inline int xfs_sb_good_version(xf
 }
 #endif /* __KERNEL__ */
 
+/*
+ * Detect a bad features2 field
+ */
+static inline int xfs_sb_has_bad_features2(xfs_sb_t *sbp)
+{
+	return (sbp->sb_bad_features2 != 0);
+}
+
 #define	XFS_SB_VERSION_TONEW(v)	xfs_sb_version_tonew(v)
 static inline unsigned xfs_sb_version_tonew(unsigned v)
 {
