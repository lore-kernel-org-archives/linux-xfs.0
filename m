Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2C5E28026
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:45:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0E7BB304039
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:45:44 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	QdITaGGbOKEt2lGk for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:45:40 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V04RT-0004JB-6u
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:27 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V04RT-0002LX-5j
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 31/49] libxfs: switch over to xfs_sb.c and remove xfs_mount.c
Date: Fri, 19 Jul 2013 16:45:06 +1000
Message-Id: <1374216324-8781-32-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-1-git-send-email-david@fromorbit.com>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Now that the kernel code has split the superblock specific code out
of xfs_mount.c, we don't need xfs_mount.c anymore. Copy in xfs_sb.c
and remove xfs_mount.c

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile    |   1 -
 include/libxfs.h    |  14 +-
 include/libxlog.h   |   4 -
 include/xfs_mount.h | 372 ---------------------------
 include/xfs_sb.h    |  26 ++
 include/xfs_trace.h |   1 +
 libxfs/Makefile     |  10 +-
 libxfs/init.c       |   2 +-
 libxfs/xfs.h        |   1 +
 libxfs/xfs_mount.c  | 627 ---------------------------------------------
 libxfs/xfs_sb.c     | 721 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 768 insertions(+), 1011 deletions(-)
 delete mode 100644 include/xfs_mount.h
 delete mode 100644 libxfs/xfs_mount.c
 create mode 100644 libxfs/xfs_sb.c

diff --git a/include/Makefile b/include/Makefile
index 70720e5..53821ee 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -36,7 +36,6 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_log_format.h \
 	xfs_log_recover.h \
 	xfs_metadump.h \
-	xfs_mount.h \
 	xfs_quota_defs.h \
 	xfs_sb.h \
 	xfs_trace.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index 37e9e15..b4d2657 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -47,7 +47,6 @@
 #include <xfs/xfs_sb.h>
 #include <xfs/xfs_ag.h>
 #include <xfs/xfs_dir2.h>
-#include <xfs/xfs_mount.h>
 #include <xfs/xfs_da_btree.h>
 #include <xfs/xfs_bmap_btree.h>
 #include <xfs/xfs_alloc_btree.h>
@@ -323,6 +322,11 @@ enum xfs_buf_flags_t {	/* b_flags bits */
 #define xfs_buf_set_ref(bp,ref)		((void) 0)
 #define xfs_buf_ioerror(bp,err)		(bp)->b_error = (err);
 
+#define xfs_daddr_to_agno(mp,d) \
+	((xfs_agnumber_t)(XFS_BB_TO_FSBT(mp, d) / (mp)->m_sb.sb_agblocks))
+#define xfs_daddr_to_agbno(mp,d) \
+	((xfs_agblock_t)(XFS_BB_TO_FSBT(mp, d) % (mp)->m_sb.sb_agblocks))
+
 /* Buffer Cache Interfaces */
 
 extern struct cache	*libxfs_bcache;
@@ -476,7 +480,6 @@ extern xfs_trans_t	*libxfs_trans_dup (xfs_trans_t *);
 extern int	libxfs_trans_reserve (xfs_trans_t *, uint,uint,uint,uint,uint);
 extern int	libxfs_trans_commit (xfs_trans_t *, uint);
 extern void	libxfs_trans_cancel (xfs_trans_t *, int);
-extern void	libxfs_mod_sb (xfs_trans_t *, __int64_t);
 extern xfs_buf_t	*libxfs_trans_getsb (xfs_trans_t *, xfs_mount_t *, int);
 
 extern int	libxfs_trans_iget (xfs_mount_t *, xfs_trans_t *, xfs_ino_t,
@@ -704,7 +707,7 @@ void	xfs_dinode_from_disk(struct xfs_icdinode *,
 #define libxfs_idata_realloc		xfs_idata_realloc
 #define libxfs_idestroy_fork		xfs_idestroy_fork
 
-/* xfs_mount.h */
+/* xfs_sb.h */
 #define libxfs_mod_sb			xfs_mod_sb
 #define libxfs_sb_from_disk		xfs_sb_from_disk
 #define libxfs_sb_to_disk		xfs_sb_to_disk
@@ -729,4 +732,9 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 
 #include <xfs/xfs_cksum.h>
 
+#define xfs_notice(mp,fmt,args...)		cmn_err(CE_NOTE,fmt, ## args)
+#define xfs_warn(mp,fmt,args...)		cmn_err(CE_WARN,fmt, ## args)
+#define xfs_alert(mp,fmt,args...)		cmn_err(CE_ALERT,fmt, ## args)
+#define xfs_hex_dump(d,n)		((void) 0)
+
 #endif	/* __LIBXFS_H__ */
diff --git a/include/libxlog.h b/include/libxlog.h
index e65b607..a61e437 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -66,10 +66,6 @@ struct xlog {
 #define XFS_MOUNT_WAS_CLEAN		0x1
 #define unlikely(x)			(x)
 
-#define xfs_warn(mp,fmt,args...)		cmn_err(CE_WARN,fmt, ## args)
-#define xfs_alert(mp,fmt,args...)		cmn_err(CE_ALERT,fmt, ## args)
-#define xfs_hex_dump(d,n)		((void) 0)
-
 extern void xlog_warn(char *fmt,...);
 extern void xlog_exit(char *fmt,...);
 extern void xlog_panic(char *fmt,...);
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
deleted file mode 100644
index 5410e9f..0000000
--- a/include/xfs_mount.h
+++ /dev/null
@@ -1,372 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_MOUNT_H__
-#define	__XFS_MOUNT_H__
-
-#ifndef __KERNEL__
-
-#define xfs_daddr_to_agno(mp,d) \
-	((xfs_agnumber_t)(XFS_BB_TO_FSBT(mp, d) / (mp)->m_sb.sb_agblocks))
-#define xfs_daddr_to_agbno(mp,d) \
-	((xfs_agblock_t)(XFS_BB_TO_FSBT(mp, d) % (mp)->m_sb.sb_agblocks))
-
-#else /* __KERNEL__ */
-
-struct xlog;
-struct xfs_inode;
-struct xfs_mru_cache;
-struct xfs_nameops;
-struct xfs_ail;
-struct xfs_quotainfo;
-
-#ifdef HAVE_PERCPU_SB
-
-/*
- * Valid per-cpu incore superblock counters. Note that if you add new counters,
- * you may need to define new counter disabled bit field descriptors as there
- * are more possible fields in the superblock that can fit in a bitfield on a
- * 32 bit platform. The XFS_SBS_* values for the current current counters just
- * fit.
- */
-typedef struct xfs_icsb_cnts {
-	uint64_t	icsb_fdblocks;
-	uint64_t	icsb_ifree;
-	uint64_t	icsb_icount;
-	unsigned long	icsb_flags;
-} xfs_icsb_cnts_t;
-
-#define XFS_ICSB_FLAG_LOCK	(1 << 0)	/* counter lock bit */
-
-#define XFS_ICSB_LAZY_COUNT	(1 << 1)	/* accuracy not needed */
-
-extern int	xfs_icsb_init_counters(struct xfs_mount *);
-extern void	xfs_icsb_reinit_counters(struct xfs_mount *);
-extern void	xfs_icsb_destroy_counters(struct xfs_mount *);
-extern void	xfs_icsb_sync_counters(struct xfs_mount *, int);
-extern void	xfs_icsb_sync_counters_locked(struct xfs_mount *, int);
-extern int	xfs_icsb_modify_counters(struct xfs_mount *, xfs_sb_field_t,
-						int64_t, int);
-
-#else
-#define xfs_icsb_init_counters(mp)		(0)
-#define xfs_icsb_destroy_counters(mp)		do { } while (0)
-#define xfs_icsb_reinit_counters(mp)		do { } while (0)
-#define xfs_icsb_sync_counters(mp, flags)	do { } while (0)
-#define xfs_icsb_sync_counters_locked(mp, flags) do { } while (0)
-#define xfs_icsb_modify_counters(mp, field, delta, rsvd) \
-	xfs_mod_incore_sb(mp, field, delta, rsvd)
-#endif
-
-/* dynamic preallocation free space thresholds, 5% down to 1% */
-enum {
-	XFS_LOWSP_1_PCNT = 0,
-	XFS_LOWSP_2_PCNT,
-	XFS_LOWSP_3_PCNT,
-	XFS_LOWSP_4_PCNT,
-	XFS_LOWSP_5_PCNT,
-	XFS_LOWSP_MAX,
-};
-
-typedef struct xfs_mount {
-	struct super_block	*m_super;
-	xfs_tid_t		m_tid;		/* next unused tid for fs */
-	struct xfs_ail		*m_ail;		/* fs active log item list */
-	xfs_sb_t		m_sb;		/* copy of fs superblock */
-	spinlock_t		m_sb_lock;	/* sb counter lock */
-	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
-	char			*m_fsname;	/* filesystem name */
-	int			m_fsname_len;	/* strlen of fs name */
-	char			*m_rtname;	/* realtime device name */
-	char			*m_logname;	/* external log device name */
-	int			m_bsize;	/* fs logical block size */
-	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
-	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
-	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
-	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
-	uint			m_readio_log;	/* min read size log bytes */
-	uint			m_readio_blocks; /* min read size blocks */
-	uint			m_writeio_log;	/* min write size log bytes */
-	uint			m_writeio_blocks; /* min write size blocks */
-	struct xlog		*m_log;		/* log specific stuff */
-	int			m_logbufs;	/* number of log buffers */
-	int			m_logbsize;	/* size of each log buffer */
-	uint			m_rsumlevels;	/* rt summary levels */
-	uint			m_rsumsize;	/* size of rt summary, bytes */
-	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
-	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
-	struct xfs_inode	*m_rootip;	/* pointer to root directory */
-	struct xfs_quotainfo	*m_quotainfo;	/* disk quota information */
-	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
-	xfs_buftarg_t		*m_logdev_targp;/* ptr to log device */
-	xfs_buftarg_t		*m_rtdev_targp;	/* ptr to rt device */
-	__uint8_t		m_blkbit_log;	/* blocklog + NBBY */
-	__uint8_t		m_blkbb_log;	/* blocklog - BBSHIFT */
-	__uint8_t		m_agno_log;	/* log #ag's */
-	__uint8_t		m_agino_log;	/* #bits for agino in inum */
-	__uint16_t		m_inode_cluster_size;/* min inode buf size */
-	uint			m_blockmask;	/* sb_blocksize-1 */
-	uint			m_blockwsize;	/* sb_blocksize in words */
-	uint			m_blockwmask;	/* blockwsize-1 */
-	uint			m_alloc_mxr[2];	/* max alloc btree records */
-	uint			m_alloc_mnr[2];	/* min alloc btree records */
-	uint			m_bmap_dmxr[2];	/* max bmap btree records */
-	uint			m_bmap_dmnr[2];	/* min bmap btree records */
-	uint			m_inobt_mxr[2];	/* max inobt btree records */
-	uint			m_inobt_mnr[2];	/* min inobt btree records */
-	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
-	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
-	uint			m_in_maxlevels;	/* max inobt btree levels. */
-	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
-	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
-	struct mutex		m_growlock;	/* growfs mutex */
-	int			m_fixedfsid[2];	/* unchanged for life of FS */
-	uint			m_dmevmask;	/* DMI events for this FS */
-	__uint64_t		m_flags;	/* global mount flags */
-	uint			m_dir_node_ents; /* #entries in a dir danode */
-	uint			m_attr_node_ents; /* #entries in attr danode */
-	int			m_ialloc_inos;	/* inodes in inode allocation */
-	int			m_ialloc_blks;	/* blocks in inode allocation */
-	int			m_inoalign_mask;/* mask sb_inoalignmt if used */
-	uint			m_qflags;	/* quota status flags */
-	struct xfs_trans_resv	m_reservations;	/* precomputed res values */
-	__uint64_t		m_maxicount;	/* maximum inode count */
-	__uint64_t		m_resblks;	/* total reserved blocks */
-	__uint64_t		m_resblks_avail;/* available reserved blocks */
-	__uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
-	int			m_dalign;	/* stripe unit */
-	int			m_swidth;	/* stripe width */
-	int			m_sinoalign;	/* stripe unit inode alignment */
-	int			m_attr_magicpct;/* 37% of the blocksize */
-	int			m_dir_magicpct;	/* 37% of the dir blocksize */
-	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */
-	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
-	int			m_dirblksize;	/* directory block sz--bytes */
-	int			m_dirblkfsbs;	/* directory block sz--fsbs */
-	xfs_dablk_t		m_dirdatablk;	/* blockno of dir data v2 */
-	xfs_dablk_t		m_dirleafblk;	/* blockno of dir non-data v2 */
-	xfs_dablk_t		m_dirfreeblk;	/* blockno of dirfreeindex v2 */
-	uint			m_chsize;	/* size of next field */
-	struct xfs_chash	*m_chash;	/* fs private inode per-cluster
-						 * hash table */
-	atomic_t		m_active_trans;	/* number trans frozen */
-#ifdef HAVE_PERCPU_SB
-	xfs_icsb_cnts_t __percpu *m_sb_cnts;	/* per-cpu superblock counters */
-	unsigned long		m_icsb_counters; /* disabled per-cpu counters */
-	struct notifier_block	m_icsb_notifier; /* hotplug cpu notifier */
-	struct mutex		m_icsb_mutex;	/* balancer sync lock */
-#endif
-	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
-	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
-	struct delayed_work	m_eofblocks_work; /* background eof blocks
-						     trimming */
-	__int64_t		m_update_flags;	/* sb flags we need to update
-						   on the next remount,rw */
-	int64_t			m_low_space[XFS_LOWSP_MAX];
-						/* low free space thresholds */
-
-	struct workqueue_struct	*m_data_workqueue;
-	struct workqueue_struct	*m_unwritten_workqueue;
-	struct workqueue_struct	*m_cil_workqueue;
-	struct workqueue_struct	*m_reclaim_workqueue;
-	struct workqueue_struct	*m_log_workqueue;
-	struct workqueue_struct *m_eofblocks_workqueue;
-} xfs_mount_t;
-
-/*
- * Flags for m_flags.
- */
-#define XFS_MOUNT_WSYNC		(1ULL << 0)	/* for nfs - all metadata ops
-						   must be synchronous except
-						   for space allocations */
-#define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
-#define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
-						   operations, typically for
-						   disk errors in metadata */
-#define XFS_MOUNT_DISCARD	(1ULL << 5)	/* discard unused blocks */
-#define XFS_MOUNT_RETERR	(1ULL << 6)     /* return alignment errors to
-						   user */
-#define XFS_MOUNT_NOALIGN	(1ULL << 7)	/* turn off stripe alignment
-						   allocations */
-#define XFS_MOUNT_ATTR2		(1ULL << 8)	/* allow use of attr2 format */
-#define XFS_MOUNT_GRPID		(1ULL << 9)	/* group-ID assigned from directory */
-#define XFS_MOUNT_NORECOVERY	(1ULL << 10)	/* no recovery - dirty fs */
-#define XFS_MOUNT_DFLT_IOSIZE	(1ULL << 12)	/* set default i/o size */
-#define XFS_MOUNT_32BITINODES	(1ULL << 14)	/* do not create inodes above
-						 * 32 bits in size */
-#define XFS_MOUNT_SMALL_INUMS	(1ULL << 15)	/* users wants 32bit inodes */
-#define XFS_MOUNT_NOUUID	(1ULL << 16)	/* ignore uuid during mount */
-#define XFS_MOUNT_BARRIER	(1ULL << 17)
-#define XFS_MOUNT_IKEEP		(1ULL << 18)	/* keep empty inode clusters*/
-#define XFS_MOUNT_SWALLOC	(1ULL << 19)	/* turn on stripe width
-						 * allocation */
-#define XFS_MOUNT_RDONLY	(1ULL << 20)	/* read-only fs */
-#define XFS_MOUNT_DIRSYNC	(1ULL << 21)	/* synchronous directory ops */
-#define XFS_MOUNT_COMPAT_IOSIZE	(1ULL << 22)	/* don't report large preferred
-						 * I/O size in stat() */
-#define XFS_MOUNT_FILESTREAMS	(1ULL << 24)	/* enable the filestreams
-						   allocator */
-#define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
-
-
-/*
- * Default minimum read and write sizes.
- */
-#define XFS_READIO_LOG_LARGE	16
-#define XFS_WRITEIO_LOG_LARGE	16
-
-/*
- * Max and min values for mount-option defined I/O
- * preallocation sizes.
- */
-#define XFS_MAX_IO_LOG		30	/* 1G */
-#define XFS_MIN_IO_LOG		PAGE_SHIFT
-
-/*
- * Synchronous read and write sizes.  This should be
- * better for NFSv2 wsync filesystems.
- */
-#define	XFS_WSYNC_READIO_LOG	15	/* 32k */
-#define	XFS_WSYNC_WRITEIO_LOG	14	/* 16k */
-
-/*
- * Allow large block sizes to be reported to userspace programs if the
- * "largeio" mount option is used.
- *
- * If compatibility mode is specified, simply return the basic unit of caching
- * so that we don't get inefficient read/modify/write I/O from user apps.
- * Otherwise....
- *
- * If the underlying volume is a stripe, then return the stripe width in bytes
- * as the recommended I/O size. It is not a stripe and we've set a default
- * buffered I/O size, return that, otherwise return the compat default.
- */
-static inline unsigned long
-xfs_preferred_iosize(xfs_mount_t *mp)
-{
-	if (mp->m_flags & XFS_MOUNT_COMPAT_IOSIZE)
-		return PAGE_CACHE_SIZE;
-	return (mp->m_swidth ?
-		(mp->m_swidth << mp->m_sb.sb_blocklog) :
-		((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) ?
-			(1 << (int)MAX(mp->m_readio_log, mp->m_writeio_log)) :
-			PAGE_CACHE_SIZE));
-}
-
-#define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
-				((mp)->m_flags & XFS_MOUNT_WAS_CLEAN)
-#define XFS_FORCED_SHUTDOWN(mp)	((mp)->m_flags & XFS_MOUNT_FS_SHUTDOWN)
-void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
-		int lnnum);
-#define xfs_force_shutdown(m,f)	\
-	xfs_do_force_shutdown(m, f, __FILE__, __LINE__)
-
-#define SHUTDOWN_META_IO_ERROR	0x0001	/* write attempt to metadata failed */
-#define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
-#define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount */
-#define SHUTDOWN_CORRUPT_INCORE	0x0008	/* corrupt in-memory data structures */
-#define SHUTDOWN_REMOTE_REQ	0x0010	/* shutdown came from remote cell */
-#define SHUTDOWN_DEVICE_REQ	0x0020	/* failed all paths to the device */
-
-/*
- * Flags for xfs_mountfs
- */
-#define XFS_MFSI_QUIET		0x40	/* Be silent if mount errors found */
-
-static inline xfs_agnumber_t
-xfs_daddr_to_agno(struct xfs_mount *mp, xfs_daddr_t d)
-{
-	xfs_daddr_t ld = XFS_BB_TO_FSBT(mp, d);
-	do_div(ld, mp->m_sb.sb_agblocks);
-	return (xfs_agnumber_t) ld;
-}
-
-static inline xfs_agblock_t
-xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
-{
-	xfs_daddr_t ld = XFS_BB_TO_FSBT(mp, d);
-	return (xfs_agblock_t) do_div(ld, mp->m_sb.sb_agblocks);
-}
-
-/*
- * Per-cpu superblock locking functions
- */
-#ifdef HAVE_PERCPU_SB
-static inline void
-xfs_icsb_lock(xfs_mount_t *mp)
-{
-	mutex_lock(&mp->m_icsb_mutex);
-}
-
-static inline void
-xfs_icsb_unlock(xfs_mount_t *mp)
-{
-	mutex_unlock(&mp->m_icsb_mutex);
-}
-#else
-#define xfs_icsb_lock(mp)
-#define xfs_icsb_unlock(mp)
-#endif
-
-/*
- * This structure is for use by the xfs_mod_incore_sb_batch() routine.
- * xfs_growfs can specify a few fields which are more than int limit
- */
-typedef struct xfs_mod_sb {
-	xfs_sb_field_t	msb_field;	/* Field to modify, see below */
-	int64_t		msb_delta;	/* Change to make to specified field */
-} xfs_mod_sb_t;
-
-extern int	xfs_log_sbcount(xfs_mount_t *);
-extern __uint64_t xfs_default_resblks(xfs_mount_t *mp);
-extern int	xfs_mountfs(xfs_mount_t *mp);
-
-extern void	xfs_unmountfs(xfs_mount_t *);
-extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
-extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
-			uint, int);
-extern int	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
-extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
-extern int	xfs_readsb(xfs_mount_t *, int);
-extern void	xfs_freesb(xfs_mount_t *);
-extern int	xfs_fs_writable(xfs_mount_t *);
-extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);
-
-extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
-
-extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
-
-#endif	/* __KERNEL__ */
-
-/*
- * perag get/put wrappers for ref counting
- */
-struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
-struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *mp, xfs_agnumber_t agno,
-					int tag);
-void	xfs_perag_put(struct xfs_perag *pag);
-
-extern void	xfs_sb_calc_crc(struct xfs_buf	*);
-extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);
-extern int	xfs_initialize_perag(struct xfs_mount *, xfs_agnumber_t,
-					xfs_agnumber_t *);
-extern void	xfs_sb_from_disk(struct xfs_sb *, struct xfs_dsb *);
-extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
-
-extern const struct xfs_buf_ops xfs_sb_buf_ops;
-
-#endif	/* __XFS_MOUNT_H__ */
diff --git a/include/xfs_sb.h b/include/xfs_sb.h
index 51db6f2..dea0373 100644
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
@@ -26,6 +26,7 @@
 
 struct xfs_buf;
 struct xfs_mount;
+struct xfs_trans;
 
 #define	XFS_SB_MAGIC		0x58465342	/* 'XFSB' */
 #define	XFS_SB_VERSION_1	1		/* 5.3, 6.0.1, 6.1 */
@@ -625,6 +626,12 @@ xfs_sb_has_incompat_log_feature(
 	return (sbp->sb_features_log_incompat & feature) != 0;
 }
 
+static inline bool
+xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
+{
+	return (ino == sbp->sb_uquotino || ino == sbp->sb_gquotino);
+}
+
 /*
  * end of superblock version macros
  */
@@ -661,4 +668,23 @@ xfs_sb_has_incompat_log_feature(
 #define XFS_B_TO_FSBT(mp,b)	(((__uint64_t)(b)) >> (mp)->m_sb.sb_blocklog)
 #define XFS_B_FSB_OFFSET(mp,b)	((b) & (mp)->m_blockmask)
 
+/*
+ * perag get/put wrappers for ref counting
+ */
+extern struct xfs_perag *xfs_perag_get(struct xfs_mount *, xfs_agnumber_t);
+extern struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
+					   int tag);
+extern void	xfs_perag_put(struct xfs_perag *pag);
+extern int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
+
+extern void	xfs_sb_calc_crc(struct xfs_buf	*);
+extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);
+extern void	xfs_sb_mount_common(struct xfs_mount *, struct xfs_sb *);
+extern void	xfs_sb_from_disk(struct xfs_sb *, struct xfs_dsb *);
+extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
+extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
+
+extern const struct xfs_buf_ops xfs_sb_buf_ops;
+extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
+
 #endif	/* __XFS_SB_H__ */
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 5f32097..1d2728e 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -162,6 +162,7 @@
 
 /* set c = c to avoid unused var warnings */
 #define trace_xfs_perag_get(a,b,c,d)	((c) = (c))
+#define trace_xfs_perag_get_tag(a,b,c,d) ((c) = (c))
 #define trace_xfs_perag_put(a,b,c,d)	((c) = (c))
 
 #endif /* __TRACE_H__ */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 6ba38f9..5608020 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -11,9 +11,13 @@ LT_REVISION = 0
 LT_AGE = 0
 
 HFILES = xfs.h init.h xfs_dir2_priv.h crc32defs.h crc32table.h
-CFILES = cache.c init.c kmem.c logitem.c radix-tree.c rdwr.c trans.c util.c \
+CFILES = cache.c \
+	crc32.c \
+	init.c kmem.c logitem.c radix-tree.c rdwr.c trans.c util.c \
 	xfs_alloc.c \
 	xfs_alloc_btree.c \
+	xfs_attr.c \
+	xfs_attr_remote.c \
 	xfs_btree.c \
 	xfs_ialloc.c \
 	xfs_inode_buf.c \
@@ -21,8 +25,8 @@ CFILES = cache.c init.c kmem.c logitem.c radix-tree.c rdwr.c trans.c util.c \
 	xfs_ialloc_btree.c xfs_bmap_btree.c xfs_da_btree.c \
 	xfs_dir2.c xfs_dir2_leaf.c xfs_attr_leaf.c xfs_dir2_block.c \
 	xfs_dir2_node.c xfs_dir2_data.c xfs_dir2_sf.c xfs_bmap.c \
-	xfs_mount.c xfs_rtalloc.c xfs_attr.c xfs_attr_remote.c \
-	crc32.c \
+	xfs_rtalloc.c \
+	xfs_sb.c \
 	xfs_symlink_remote.c \
 	xfs_trans_resv.c
 
diff --git a/libxfs/init.c b/libxfs/init.c
index 5c418bc..db7eeea 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -692,7 +692,7 @@ libxfs_mount(
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
 	sbp = &(mp->m_sb);
 
-	xfs_mount_common(mp, sb);
+	xfs_sb_mount_common(mp, sb);
 
 	xfs_alloc_compute_maxlevels(mp);
 	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index 1a01c61..0113b50 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -345,6 +345,7 @@ do { \
 #define uuid_equal(s,d)		(platform_uuid_compare((s),(d)) == 0)
 
 #define xfs_icreate_log(tp, agno, agbno, cnt, isize, len, gen) ((void) 0)
+#define xfs_sb_validate_fsb_count(sbp, nblks)		(0)
 
 /*
  * Prototypes for kernel static functions that are aren't in their
diff --git a/libxfs/xfs_mount.c b/libxfs/xfs_mount.c
deleted file mode 100644
index db3785d..0000000
--- a/libxfs/xfs_mount.c
+++ /dev/null
@@ -1,627 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-#include <xfs.h>
-
-static const struct {
-	short offset;
-	short type;	/* 0 = integer
-			 * 1 = binary / string (no translation)
-			 */
-} xfs_sb_info[] = {
-    { offsetof(xfs_sb_t, sb_magicnum),   0 },
-    { offsetof(xfs_sb_t, sb_blocksize),  0 },
-    { offsetof(xfs_sb_t, sb_dblocks),    0 },
-    { offsetof(xfs_sb_t, sb_rblocks),    0 },
-    { offsetof(xfs_sb_t, sb_rextents),   0 },
-    { offsetof(xfs_sb_t, sb_uuid),       1 },
-    { offsetof(xfs_sb_t, sb_logstart),   0 },
-    { offsetof(xfs_sb_t, sb_rootino),    0 },
-    { offsetof(xfs_sb_t, sb_rbmino),     0 },
-    { offsetof(xfs_sb_t, sb_rsumino),    0 },
-    { offsetof(xfs_sb_t, sb_rextsize),   0 },
-    { offsetof(xfs_sb_t, sb_agblocks),   0 },
-    { offsetof(xfs_sb_t, sb_agcount),    0 },
-    { offsetof(xfs_sb_t, sb_rbmblocks),  0 },
-    { offsetof(xfs_sb_t, sb_logblocks),  0 },
-    { offsetof(xfs_sb_t, sb_versionnum), 0 },
-    { offsetof(xfs_sb_t, sb_sectsize),   0 },
-    { offsetof(xfs_sb_t, sb_inodesize),  0 },
-    { offsetof(xfs_sb_t, sb_inopblock),  0 },
-    { offsetof(xfs_sb_t, sb_fname[0]),   1 },
-    { offsetof(xfs_sb_t, sb_blocklog),   0 },
-    { offsetof(xfs_sb_t, sb_sectlog),    0 },
-    { offsetof(xfs_sb_t, sb_inodelog),   0 },
-    { offsetof(xfs_sb_t, sb_inopblog),   0 },
-    { offsetof(xfs_sb_t, sb_agblklog),   0 },
-    { offsetof(xfs_sb_t, sb_rextslog),   0 },
-    { offsetof(xfs_sb_t, sb_inprogress), 0 },
-    { offsetof(xfs_sb_t, sb_imax_pct),   0 },
-    { offsetof(xfs_sb_t, sb_icount),     0 },
-    { offsetof(xfs_sb_t, sb_ifree),      0 },
-    { offsetof(xfs_sb_t, sb_fdblocks),   0 },
-    { offsetof(xfs_sb_t, sb_frextents),  0 },
-    { offsetof(xfs_sb_t, sb_uquotino),   0 },
-    { offsetof(xfs_sb_t, sb_gquotino),   0 },
-    { offsetof(xfs_sb_t, sb_qflags),     0 },
-    { offsetof(xfs_sb_t, sb_flags),      0 },
-    { offsetof(xfs_sb_t, sb_shared_vn),  0 },
-    { offsetof(xfs_sb_t, sb_inoalignmt), 0 },
-    { offsetof(xfs_sb_t, sb_unit),	 0 },
-    { offsetof(xfs_sb_t, sb_width),	 0 },
-    { offsetof(xfs_sb_t, sb_dirblklog),	 0 },
-    { offsetof(xfs_sb_t, sb_logsectlog), 0 },
-    { offsetof(xfs_sb_t, sb_logsectsize),0 },
-    { offsetof(xfs_sb_t, sb_logsunit),	 0 },
-    { offsetof(xfs_sb_t, sb_features2),	 0 },
-    { offsetof(xfs_sb_t, sb_bad_features2), 0 },
-    { offsetof(xfs_sb_t, sb_features_compat), 0 },
-    { offsetof(xfs_sb_t, sb_features_ro_compat), 0 },
-    { offsetof(xfs_sb_t, sb_features_incompat), 0 },
-    { offsetof(xfs_sb_t, sb_features_log_incompat), 0 },
-    { offsetof(xfs_sb_t, sb_crc),	 0 },
-    { offsetof(xfs_sb_t, sb_pad),	 0 },
-    { offsetof(xfs_sb_t, sb_pquotino),	 0 },
-    { offsetof(xfs_sb_t, sb_lsn),	 0 },
-    { sizeof(xfs_sb_t),			 0 }
-};
-
-/*
- * Reference counting access wrappers to the perag structures.
- * Because we never free per-ag structures, the only thing we
- * have to protect against changes is the tree structure itself.
- */
-struct xfs_perag *
-xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
-{
-	struct xfs_perag	*pag;
-	int			ref = 0;
-
-	rcu_read_lock();
-	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
-	if (pag) {
-		ASSERT(atomic_read(&pag->pag_ref) >= 0);
-		ref = atomic_inc_return(&pag->pag_ref);
-	}
-	rcu_read_unlock();
-	trace_xfs_perag_get(mp, agno, ref, _RET_IP_);
-	return pag;
-}
-
-void
-xfs_perag_put(struct xfs_perag *pag)
-{
-	int	ref;
-
-	ASSERT(atomic_read(&pag->pag_ref) > 0);
-	ref = atomic_dec_return(&pag->pag_ref);
-	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
-}
-
-/*
- * Check the validity of the SB found.
- */
-STATIC int
-xfs_mount_validate_sb(
-	xfs_mount_t	*mp,
-	xfs_sb_t	*sbp,
-	bool		check_inprogress,
-	bool		check_version)
-{
-
-	/*
-	 * If the log device and data device have the
-	 * same device number, the log is internal.
-	 * Consequently, the sb_logstart should be non-zero.  If
-	 * we have a zero sb_logstart in this case, we may be trying to mount
-	 * a volume filesystem in a non-volume manner.
-	 */
-	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
-		xfs_warn(mp, "bad magic number");
-		return XFS_ERROR(EWRONGFS);
-	}
-
-
-	if (!xfs_sb_good_version(sbp)) {
-		xfs_warn(mp, "bad version");
-		return XFS_ERROR(EWRONGFS);
-	}
-
-	/*
-	 * Version 5 superblock feature mask validation. Reject combinations the
-	 * kernel cannot support up front before checking anything else.
-	 */
-	if (check_version && XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
-		xfs_alert(mp,
-"Version 5 superblock detected. xfsprogs has EXPERIMENTAL support enabled!\n"
-"Use of these features is at your own risk!");
-
-		if (xfs_sb_has_compat_feature(sbp,
-					XFS_SB_FEAT_COMPAT_UNKNOWN)) {
-			xfs_warn(mp,
-"Superblock has unknown compatible features (0x%x) enabled.\n"
-"Using a more recent xfsprogs is recommended.",
-				(sbp->sb_features_compat &
-						XFS_SB_FEAT_COMPAT_UNKNOWN));
-		}
-
-		if (xfs_sb_has_ro_compat_feature(sbp,
-					XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
-			xfs_warn(mp,
-"Superblock has unknown read-only compatible features (0x%x) enabled.\n"
-"Using a more recent xfsprogs is recommended.",
-				(sbp->sb_features_ro_compat &
-						XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
-		}
-		if (xfs_sb_has_incompat_feature(sbp,
-					XFS_SB_FEAT_INCOMPAT_UNKNOWN)) {
-			xfs_warn(mp,
-"Superblock has unknown incompatible features (0x%x) enabled.\n"
-"Filesystem can not be safely operated on by this xfsprogs installation",
-				(sbp->sb_features_incompat &
-						XFS_SB_FEAT_INCOMPAT_UNKNOWN));
-			return XFS_ERROR(EINVAL);
-		}
-	}
-
-	if (unlikely(
-	    sbp->sb_logstart == 0 && mp->m_logdev_targp == mp->m_ddev_targp)) {
-		xfs_warn(mp,
-		"filesystem is marked as having an external log; "
-		"specify logdev on the mount command line.");
-		return XFS_ERROR(EINVAL);
-	}
-
-	if (unlikely(
-	    sbp->sb_logstart != 0 && mp->m_logdev_targp != mp->m_ddev_targp)) {
-		xfs_warn(mp,
-		"filesystem is marked as having an internal log; "
-		"do not specify logdev on the mount command line.");
-		return XFS_ERROR(EINVAL);
-	}
-
-	/*
-	 * More sanity checking.  Most of these were stolen directly from
-	 * xfs_repair.
-	 */
-	if (unlikely(
-	    sbp->sb_agcount <= 0					||
-	    sbp->sb_sectsize < XFS_MIN_SECTORSIZE			||
-	    sbp->sb_sectsize > XFS_MAX_SECTORSIZE			||
-	    sbp->sb_sectlog < XFS_MIN_SECTORSIZE_LOG			||
-	    sbp->sb_sectlog > XFS_MAX_SECTORSIZE_LOG			||
-	    sbp->sb_sectsize != (1 << sbp->sb_sectlog)			||
-	    sbp->sb_blocksize < XFS_MIN_BLOCKSIZE			||
-	    sbp->sb_blocksize > XFS_MAX_BLOCKSIZE			||
-	    sbp->sb_blocklog < XFS_MIN_BLOCKSIZE_LOG			||
-	    sbp->sb_blocklog > XFS_MAX_BLOCKSIZE_LOG			||
-	    sbp->sb_blocksize != (1 << sbp->sb_blocklog)		||
-	    sbp->sb_inodesize < XFS_DINODE_MIN_SIZE			||
-	    sbp->sb_inodesize > XFS_DINODE_MAX_SIZE			||
-	    sbp->sb_inodelog < XFS_DINODE_MIN_LOG			||
-	    sbp->sb_inodelog > XFS_DINODE_MAX_LOG			||
-	    sbp->sb_inodesize != (1 << sbp->sb_inodelog)		||
-	    (sbp->sb_blocklog - sbp->sb_inodelog != sbp->sb_inopblog)	||
-	    (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE)	||
-	    (sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)	||
-	    (sbp->sb_imax_pct > 100 /* zero sb_imax_pct is valid */)	||
-	    sbp->sb_dblocks == 0					||
-	    sbp->sb_dblocks > XFS_MAX_DBLOCKS(sbp)			||
-	    sbp->sb_dblocks < XFS_MIN_DBLOCKS(sbp))) {
-		XFS_CORRUPTION_ERROR("SB sanity check failed",
-				XFS_ERRLEVEL_LOW, mp, sbp);
-		return XFS_ERROR(EFSCORRUPTED);
-	}
-
-	/*
-	 * Currently only very few inode sizes are supported.
-	 */
-	switch (sbp->sb_inodesize) {
-	case 256:
-	case 512:
-	case 1024:
-	case 2048:
-		break;
-	default:
-		xfs_warn(mp, "inode size of %d bytes not supported",
-				sbp->sb_inodesize);
-		return XFS_ERROR(ENOSYS);
-	}
-
-	/*
-	 * Version 1 directory format has never worked on Linux.
-	 */
-	if (unlikely(!xfs_sb_version_hasdirv2(sbp))) {
-		xfs_warn(mp, "file system using version 1 directory format");
-		return XFS_ERROR(ENOSYS);
-	}
-
-	return 0;
-}
-
-void
-xfs_sb_from_disk(
-	xfs_sb_t	*to,
-	xfs_dsb_t	*from)
-{
-	to->sb_magicnum = be32_to_cpu(from->sb_magicnum);
-	to->sb_blocksize = be32_to_cpu(from->sb_blocksize);
-	to->sb_dblocks = be64_to_cpu(from->sb_dblocks);
-	to->sb_rblocks = be64_to_cpu(from->sb_rblocks);
-	to->sb_rextents = be64_to_cpu(from->sb_rextents);
-	memcpy(&to->sb_uuid, &from->sb_uuid, sizeof(to->sb_uuid));
-	to->sb_logstart = be64_to_cpu(from->sb_logstart);
-	to->sb_rootino = be64_to_cpu(from->sb_rootino);
-	to->sb_rbmino = be64_to_cpu(from->sb_rbmino);
-	to->sb_rsumino = be64_to_cpu(from->sb_rsumino);
-	to->sb_rextsize = be32_to_cpu(from->sb_rextsize);
-	to->sb_agblocks = be32_to_cpu(from->sb_agblocks);
-	to->sb_agcount = be32_to_cpu(from->sb_agcount);
-	to->sb_rbmblocks = be32_to_cpu(from->sb_rbmblocks);
-	to->sb_logblocks = be32_to_cpu(from->sb_logblocks);
-	to->sb_versionnum = be16_to_cpu(from->sb_versionnum);
-	to->sb_sectsize = be16_to_cpu(from->sb_sectsize);
-	to->sb_inodesize = be16_to_cpu(from->sb_inodesize);
-	to->sb_inopblock = be16_to_cpu(from->sb_inopblock);
-	memcpy(&to->sb_fname, &from->sb_fname, sizeof(to->sb_fname));
-	to->sb_blocklog = from->sb_blocklog;
-	to->sb_sectlog = from->sb_sectlog;
-	to->sb_inodelog = from->sb_inodelog;
-	to->sb_inopblog = from->sb_inopblog;
-	to->sb_agblklog = from->sb_agblklog;
-	to->sb_rextslog = from->sb_rextslog;
-	to->sb_inprogress = from->sb_inprogress;
-	to->sb_imax_pct = from->sb_imax_pct;
-	to->sb_icount = be64_to_cpu(from->sb_icount);
-	to->sb_ifree = be64_to_cpu(from->sb_ifree);
-	to->sb_fdblocks = be64_to_cpu(from->sb_fdblocks);
-	to->sb_frextents = be64_to_cpu(from->sb_frextents);
-	to->sb_uquotino = be64_to_cpu(from->sb_uquotino);
-	to->sb_gquotino = be64_to_cpu(from->sb_gquotino);
-	to->sb_qflags = be16_to_cpu(from->sb_qflags);
-	to->sb_flags = from->sb_flags;
-	to->sb_shared_vn = from->sb_shared_vn;
-	to->sb_inoalignmt = be32_to_cpu(from->sb_inoalignmt);
-	to->sb_unit = be32_to_cpu(from->sb_unit);
-	to->sb_width = be32_to_cpu(from->sb_width);
-	to->sb_dirblklog = from->sb_dirblklog;
-	to->sb_logsectlog = from->sb_logsectlog;
-	to->sb_logsectsize = be16_to_cpu(from->sb_logsectsize);
-	to->sb_logsunit = be32_to_cpu(from->sb_logsunit);
-	to->sb_features2 = be32_to_cpu(from->sb_features2);
-	to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
-	to->sb_features_compat = be32_to_cpu(from->sb_features_compat);
-	to->sb_features_ro_compat = be32_to_cpu(from->sb_features_ro_compat);
-	to->sb_features_incompat = be32_to_cpu(from->sb_features_incompat);
-	to->sb_features_log_incompat =
-				be32_to_cpu(from->sb_features_log_incompat);
-	to->sb_pad = 0;
-	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
-	to->sb_lsn = be64_to_cpu(from->sb_lsn);
-}
-
-/*
- * Copy in core superblock to ondisk one.
- *
- * The fields argument is mask of superblock fields to copy.
- */
-void
-xfs_sb_to_disk(
-	xfs_dsb_t	*to,
-	xfs_sb_t	*from,
-	__int64_t	fields)
-{
-	xfs_caddr_t	to_ptr = (xfs_caddr_t)to;
-	xfs_caddr_t	from_ptr = (xfs_caddr_t)from;
-	xfs_sb_field_t	f;
-	int		first;
-	int		size;
-
-	ASSERT(fields);
-	if (!fields)
-		return;
-
-	while (fields) {
-		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
-		first = xfs_sb_info[f].offset;
-		size = xfs_sb_info[f + 1].offset - first;
-
-		ASSERT(xfs_sb_info[f].type == 0 || xfs_sb_info[f].type == 1);
-
-		if (size == 1 || xfs_sb_info[f].type == 1) {
-			memcpy(to_ptr + first, from_ptr + first, size);
-		} else {
-			switch (size) {
-			case 2:
-				*(__be16 *)(to_ptr + first) =
-					cpu_to_be16(*(__u16 *)(from_ptr + first));
-				break;
-			case 4:
-				*(__be32 *)(to_ptr + first) =
-					cpu_to_be32(*(__u32 *)(from_ptr + first));
-				break;
-			case 8:
-				*(__be64 *)(to_ptr + first) =
-					cpu_to_be64(*(__u64 *)(from_ptr + first));
-				break;
-			default:
-				ASSERT(0);
-			}
-		}
-
-		fields &= ~(1LL << f);
-	}
-}
-
-static int
-xfs_sb_verify(
-	struct xfs_buf	*bp,
-	bool		check_version)
-{
-	struct xfs_mount *mp = bp->b_target->bt_mount;
-	struct xfs_sb	sb;
-
-	xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
-
-	/*
-	 * Only check the in progress field for the primary superblock as
-	 * mkfs.xfs doesn't clear it from secondary superblocks.
-	 */
-	return xfs_mount_validate_sb(mp, &sb, bp->b_bn == XFS_SB_DADDR,
-				     check_version);
-}
-
-/*
- * If the superblock has the CRC feature bit set or the CRC field is non-null,
- * check that the CRC is valid.  We check the CRC field is non-null because a
- * single bit error could clear the feature bit and unused parts of the
- * superblock are supposed to be zero. Hence a non-null crc field indicates that
- * we've potentially lost a feature bit and we should check it anyway.
- */
-static void
-xfs_sb_read_verify(
-	struct xfs_buf	*bp)
-{
-	struct xfs_mount *mp = bp->b_target->bt_mount;
-	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);
-	int		error;
-
-	/*
-	 * open code the version check to avoid needing to convert the entire
-	 * superblock from disk order just to check the version number
-	 */
-	if (dsb->sb_magicnum == cpu_to_be32(XFS_SB_MAGIC) &&
-	    (((be16_to_cpu(dsb->sb_versionnum) & XFS_SB_VERSION_NUMBITS) ==
-						XFS_SB_VERSION_5) ||
-	     dsb->sb_crc != 0)) {
-
-		if (!xfs_verify_cksum(bp->b_addr, be16_to_cpu(dsb->sb_sectsize),
-				      offsetof(struct xfs_sb, sb_crc))) {
-			error = EFSCORRUPTED;
-			goto out_error;
-		}
-	}
-	error = xfs_sb_verify(bp, true);
-
-out_error:
-	if (error) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
-		xfs_buf_ioerror(bp, error);
-	}
-}
-
-/*
- * We may be probed for a filesystem match, so we may not want to emit
- * messages when the superblock buffer is not actually an XFS superblock.
- * If we find an XFS superblock, the run a normal, noisy mount because we are
- * really going to mount it and want to know about errors.
- */
-static void
-xfs_sb_quiet_read_verify(
-	struct xfs_buf	*bp)
-{
-	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);
-
-
-	if (dsb->sb_magicnum == cpu_to_be32(XFS_SB_MAGIC)) {
-		/* XFS filesystem, verify noisily! */
-		xfs_sb_read_verify(bp);
-		return;
-	}
-	/* quietly fail */
-	xfs_buf_ioerror(bp, EWRONGFS);
-}
-
-static void
-xfs_sb_write_verify(
-	struct xfs_buf		*bp)
-{
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
-	int			error;
-
-	error = xfs_sb_verify(bp, false);
-	if (error) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
-		xfs_buf_ioerror(bp, error);
-		return;
-	}
-
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return;
-
-	if (bip)
-		XFS_BUF_TO_SBP(bp)->sb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
-
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 offsetof(struct xfs_sb, sb_crc));
-}
-
-const struct xfs_buf_ops xfs_sb_buf_ops = {
-	.verify_read = xfs_sb_read_verify,
-	.verify_write = xfs_sb_write_verify,
-};
-
-static const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
-	.verify_read = xfs_sb_quiet_read_verify,
-	.verify_write = xfs_sb_write_verify,
-};
-
-/*
- * xfs_mount_common
- *
- * Mount initialization code establishing various mount
- * fields from the superblock associated with the given
- * mount structure
- *
- * Note: this requires user-space public scope for libxfs_mount
- */
-void
-xfs_mount_common(xfs_mount_t *mp, xfs_sb_t *sbp)
-{
-	mp->m_agfrotor = mp->m_agirotor = 0;
-	spin_lock_init(&mp->m_agirotor_lock);
-	mp->m_maxagi = mp->m_sb.sb_agcount;
-	mp->m_blkbit_log = sbp->sb_blocklog + XFS_NBBYLOG;
-	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
-	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
-	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
-	mp->m_agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
-	mp->m_blockmask = sbp->sb_blocksize - 1;
-	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
-	mp->m_blockwmask = mp->m_blockwsize - 1;
-
-	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
-	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
-	mp->m_alloc_mnr[0] = mp->m_alloc_mxr[0] / 2;
-	mp->m_alloc_mnr[1] = mp->m_alloc_mxr[1] / 2;
-
-	mp->m_inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 1);
-	mp->m_inobt_mxr[1] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 0);
-	mp->m_inobt_mnr[0] = mp->m_inobt_mxr[0] / 2;
-	mp->m_inobt_mnr[1] = mp->m_inobt_mxr[1] / 2;
-
-	mp->m_bmap_dmxr[0] = xfs_bmbt_maxrecs(mp, sbp->sb_blocksize, 1);
-	mp->m_bmap_dmxr[1] = xfs_bmbt_maxrecs(mp, sbp->sb_blocksize, 0);
-	mp->m_bmap_dmnr[0] = mp->m_bmap_dmxr[0] / 2;
-	mp->m_bmap_dmnr[1] = mp->m_bmap_dmxr[1] / 2;
-
-	mp->m_bsize = XFS_FSB_TO_BB(mp, 1);
-	mp->m_ialloc_inos = (int)MAX((__uint16_t)XFS_INODES_PER_CHUNK,
-					sbp->sb_inopblock);
-	mp->m_ialloc_blks = mp->m_ialloc_inos >> sbp->sb_inopblog;
-}
-
-/*
- * xfs_initialize_perag_data
- *
- * Read in each per-ag structure so we can count up the number of
- * allocated inodes, free inodes and used filesystem blocks as this
- * information is no longer persistent in the superblock. Once we have
- * this information, write it into the in-core superblock structure.
- *
- * Note: this requires user-space public scope for libxfs_mount
- */
-int
-xfs_initialize_perag_data(xfs_mount_t *mp, xfs_agnumber_t agcount)
-{
-	xfs_agnumber_t	index;
-	xfs_perag_t	*pag;
-	xfs_sb_t	*sbp = &mp->m_sb;
-	uint64_t	ifree = 0;
-	uint64_t	ialloc = 0;
-	uint64_t	bfree = 0;
-	uint64_t	bfreelst = 0;
-	uint64_t	btree = 0;
-	int		error;
-
-	for (index = 0; index < agcount; index++) {
-		/*
-		 * read the agf, then the agi. This gets us
-		 * all the information we need and populates the
-		 * per-ag structures for us.
-		 */
-		error = xfs_alloc_pagf_init(mp, NULL, index, 0);
-		if (error)
-			return error;
-
-		error = xfs_ialloc_pagi_init(mp, NULL, index);
-		if (error)
-			return error;
-		pag = xfs_perag_get(mp, index);
-		ifree += pag->pagi_freecount;
-		ialloc += pag->pagi_count;
-		bfree += pag->pagf_freeblks;
-		bfreelst += pag->pagf_flcount;
-		btree += pag->pagf_btreeblks;
-		xfs_perag_put(pag);
-	}
-	/*
-	 * Overwrite incore superblock counters with just-read data
-	 */
-	spin_lock(&mp->m_sb_lock);
-	sbp->sb_ifree = ifree;
-	sbp->sb_icount = ialloc;
-	sbp->sb_fdblocks = bfree + bfreelst + btree;
-	spin_unlock(&mp->m_sb_lock);
-
-	/* Fixup the per-cpu counters as well. */
-	xfs_icsb_reinit_counters(mp);
-
-	return 0;
-}
-
-/*
- * xfs_mod_sb() can be used to copy arbitrary changes to the
- * in-core superblock into the superblock buffer to be logged.
- * It does not provide the higher level of locking that is
- * needed to protect the in-core superblock from concurrent
- * access.
- */
-void
-xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
-{
-	xfs_buf_t	*bp;
-	int		first;
-	int		last;
-	xfs_mount_t	*mp;
-	xfs_sb_field_t	f;
-
-	ASSERT(fields);
-	if (!fields)
-		return;
-	mp = tp->t_mountp;
-	bp = xfs_trans_getsb(tp, mp, 0);
-	first = sizeof(xfs_sb_t);
-	last = 0;
-
-	/* translate/copy */
-	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, fields);
-
-	/* find modified range */
-	f = (xfs_sb_field_t)xfs_highbit64((__uint64_t)fields);
-	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
-	last = xfs_sb_info[f + 1].offset - 1;
-
-	f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
-	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
-	first = xfs_sb_info[f].offset;
-
-	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
-	xfs_trans_log_buf(tp, bp, first, last);
-}
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
new file mode 100644
index 0000000..869fb76
--- /dev/null
+++ b/libxfs/xfs_sb.c
@@ -0,0 +1,721 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <xfs.h>
+
+/*
+ * Physical superblock buffer manipulations. Shared with libxfs in userspace.
+ */
+
+static const struct {
+	short offset;
+	short type;	/* 0 = integer
+			 * 1 = binary / string (no translation)
+			 */
+} xfs_sb_info[] = {
+    { offsetof(xfs_sb_t, sb_magicnum),   0 },
+    { offsetof(xfs_sb_t, sb_blocksize),  0 },
+    { offsetof(xfs_sb_t, sb_dblocks),    0 },
+    { offsetof(xfs_sb_t, sb_rblocks),    0 },
+    { offsetof(xfs_sb_t, sb_rextents),   0 },
+    { offsetof(xfs_sb_t, sb_uuid),       1 },
+    { offsetof(xfs_sb_t, sb_logstart),   0 },
+    { offsetof(xfs_sb_t, sb_rootino),    0 },
+    { offsetof(xfs_sb_t, sb_rbmino),     0 },
+    { offsetof(xfs_sb_t, sb_rsumino),    0 },
+    { offsetof(xfs_sb_t, sb_rextsize),   0 },
+    { offsetof(xfs_sb_t, sb_agblocks),   0 },
+    { offsetof(xfs_sb_t, sb_agcount),    0 },
+    { offsetof(xfs_sb_t, sb_rbmblocks),  0 },
+    { offsetof(xfs_sb_t, sb_logblocks),  0 },
+    { offsetof(xfs_sb_t, sb_versionnum), 0 },
+    { offsetof(xfs_sb_t, sb_sectsize),   0 },
+    { offsetof(xfs_sb_t, sb_inodesize),  0 },
+    { offsetof(xfs_sb_t, sb_inopblock),  0 },
+    { offsetof(xfs_sb_t, sb_fname[0]),   1 },
+    { offsetof(xfs_sb_t, sb_blocklog),   0 },
+    { offsetof(xfs_sb_t, sb_sectlog),    0 },
+    { offsetof(xfs_sb_t, sb_inodelog),   0 },
+    { offsetof(xfs_sb_t, sb_inopblog),   0 },
+    { offsetof(xfs_sb_t, sb_agblklog),   0 },
+    { offsetof(xfs_sb_t, sb_rextslog),   0 },
+    { offsetof(xfs_sb_t, sb_inprogress), 0 },
+    { offsetof(xfs_sb_t, sb_imax_pct),   0 },
+    { offsetof(xfs_sb_t, sb_icount),     0 },
+    { offsetof(xfs_sb_t, sb_ifree),      0 },
+    { offsetof(xfs_sb_t, sb_fdblocks),   0 },
+    { offsetof(xfs_sb_t, sb_frextents),  0 },
+    { offsetof(xfs_sb_t, sb_uquotino),   0 },
+    { offsetof(xfs_sb_t, sb_gquotino),   0 },
+    { offsetof(xfs_sb_t, sb_qflags),     0 },
+    { offsetof(xfs_sb_t, sb_flags),      0 },
+    { offsetof(xfs_sb_t, sb_shared_vn),  0 },
+    { offsetof(xfs_sb_t, sb_inoalignmt), 0 },
+    { offsetof(xfs_sb_t, sb_unit),	 0 },
+    { offsetof(xfs_sb_t, sb_width),	 0 },
+    { offsetof(xfs_sb_t, sb_dirblklog),	 0 },
+    { offsetof(xfs_sb_t, sb_logsectlog), 0 },
+    { offsetof(xfs_sb_t, sb_logsectsize),0 },
+    { offsetof(xfs_sb_t, sb_logsunit),	 0 },
+    { offsetof(xfs_sb_t, sb_features2),	 0 },
+    { offsetof(xfs_sb_t, sb_bad_features2), 0 },
+    { offsetof(xfs_sb_t, sb_features_compat), 0 },
+    { offsetof(xfs_sb_t, sb_features_ro_compat), 0 },
+    { offsetof(xfs_sb_t, sb_features_incompat), 0 },
+    { offsetof(xfs_sb_t, sb_features_log_incompat), 0 },
+    { offsetof(xfs_sb_t, sb_crc),	 0 },
+    { offsetof(xfs_sb_t, sb_pad),	 0 },
+    { offsetof(xfs_sb_t, sb_pquotino),	 0 },
+    { offsetof(xfs_sb_t, sb_lsn),	 0 },
+    { sizeof(xfs_sb_t),			 0 }
+};
+
+/*
+ * Reference counting access wrappers to the perag structures.
+ * Because we never free per-ag structures, the only thing we
+ * have to protect against changes is the tree structure itself.
+ */
+struct xfs_perag *
+xfs_perag_get(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_perag	*pag;
+	int			ref = 0;
+
+	rcu_read_lock();
+	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
+	if (pag) {
+		ASSERT(atomic_read(&pag->pag_ref) >= 0);
+		ref = atomic_inc_return(&pag->pag_ref);
+	}
+	rcu_read_unlock();
+	trace_xfs_perag_get(mp, agno, ref, _RET_IP_);
+	return pag;
+}
+
+/*
+ * search from @first to find the next perag with the given tag set.
+ */
+struct xfs_perag *
+xfs_perag_get_tag(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		first,
+	int			tag)
+{
+	struct xfs_perag	*pag;
+	int			found;
+	int			ref;
+
+	rcu_read_lock();
+	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
+					(void **)&pag, first, 1, tag);
+	if (found <= 0) {
+		rcu_read_unlock();
+		return NULL;
+	}
+	ref = atomic_inc_return(&pag->pag_ref);
+	rcu_read_unlock();
+	trace_xfs_perag_get_tag(mp, pag->pag_agno, ref, _RET_IP_);
+	return pag;
+}
+
+void
+xfs_perag_put(
+	struct xfs_perag	*pag)
+{
+	int	ref;
+
+	ASSERT(atomic_read(&pag->pag_ref) > 0);
+	ref = atomic_dec_return(&pag->pag_ref);
+	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
+}
+
+/*
+ * Check the validity of the SB found.
+ */
+STATIC int
+xfs_mount_validate_sb(
+	xfs_mount_t	*mp,
+	xfs_sb_t	*sbp,
+	bool		check_inprogress,
+	bool		check_version)
+{
+
+	/*
+	 * If the log device and data device have the
+	 * same device number, the log is internal.
+	 * Consequently, the sb_logstart should be non-zero.  If
+	 * we have a zero sb_logstart in this case, we may be trying to mount
+	 * a volume filesystem in a non-volume manner.
+	 */
+	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
+		xfs_warn(mp, "bad magic number");
+		return XFS_ERROR(EWRONGFS);
+	}
+
+
+	if (!xfs_sb_good_version(sbp)) {
+		xfs_warn(mp, "bad version");
+		return XFS_ERROR(EWRONGFS);
+	}
+
+	if ((sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) &&
+			(sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
+				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))) {
+		xfs_notice(mp,
+"Super block has XFS_OQUOTA bits along with XFS_PQUOTA and/or XFS_GQUOTA bits.\n");
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+
+	/*
+	 * Version 5 superblock feature mask validation. Reject combinations the
+	 * kernel cannot support up front before checking anything else. For
+	 * write validation, we don't need to check feature masks.
+	 */
+	if (check_version && XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
+		xfs_alert(mp,
+"Version 5 superblock detected. xfsprogs has EXPERIMENTAL support enabled!\n"
+"Use of these features is at your own risk!");
+
+		if (xfs_sb_has_compat_feature(sbp,
+					XFS_SB_FEAT_COMPAT_UNKNOWN)) {
+			xfs_warn(mp,
+"Superblock has unknown compatible features (0x%x) enabled.\n"
+"Using a more recent xfsprogs is recommended.",
+				(sbp->sb_features_compat &
+						XFS_SB_FEAT_COMPAT_UNKNOWN));
+		}
+
+		if (xfs_sb_has_ro_compat_feature(sbp,
+					XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
+			xfs_warn(mp,
+"Superblock has unknown read-only compatible features (0x%x) enabled.\n"
+"Using a more recent xfsprogs is recommended.",
+				(sbp->sb_features_ro_compat &
+						XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
+		}
+		if (xfs_sb_has_incompat_feature(sbp,
+					XFS_SB_FEAT_INCOMPAT_UNKNOWN)) {
+			xfs_warn(mp,
+"Superblock has unknown incompatible features (0x%x) enabled.\n"
+"Filesystem can not be safely operated on by this xfsprogs installation",
+				(sbp->sb_features_incompat &
+						XFS_SB_FEAT_INCOMPAT_UNKNOWN));
+			return XFS_ERROR(EINVAL);
+		}
+	}
+
+	if (unlikely(
+	    sbp->sb_logstart == 0 && mp->m_logdev_targp == mp->m_ddev_targp)) {
+		xfs_warn(mp,
+		"filesystem is marked as having an external log; "
+		"specify logdev on the mount command line.");
+		return XFS_ERROR(EINVAL);
+	}
+
+	if (unlikely(
+	    sbp->sb_logstart != 0 && mp->m_logdev_targp != mp->m_ddev_targp)) {
+		xfs_warn(mp,
+		"filesystem is marked as having an internal log; "
+		"do not specify logdev on the mount command line.");
+		return XFS_ERROR(EINVAL);
+	}
+
+	/*
+	 * More sanity checking.  Most of these were stolen directly from
+	 * xfs_repair.
+	 */
+	if (unlikely(
+	    sbp->sb_agcount <= 0					||
+	    sbp->sb_sectsize < XFS_MIN_SECTORSIZE			||
+	    sbp->sb_sectsize > XFS_MAX_SECTORSIZE			||
+	    sbp->sb_sectlog < XFS_MIN_SECTORSIZE_LOG			||
+	    sbp->sb_sectlog > XFS_MAX_SECTORSIZE_LOG			||
+	    sbp->sb_sectsize != (1 << sbp->sb_sectlog)			||
+	    sbp->sb_blocksize < XFS_MIN_BLOCKSIZE			||
+	    sbp->sb_blocksize > XFS_MAX_BLOCKSIZE			||
+	    sbp->sb_blocklog < XFS_MIN_BLOCKSIZE_LOG			||
+	    sbp->sb_blocklog > XFS_MAX_BLOCKSIZE_LOG			||
+	    sbp->sb_blocksize != (1 << sbp->sb_blocklog)		||
+	    sbp->sb_inodesize < XFS_DINODE_MIN_SIZE			||
+	    sbp->sb_inodesize > XFS_DINODE_MAX_SIZE			||
+	    sbp->sb_inodelog < XFS_DINODE_MIN_LOG			||
+	    sbp->sb_inodelog > XFS_DINODE_MAX_LOG			||
+	    sbp->sb_inodesize != (1 << sbp->sb_inodelog)		||
+	    (sbp->sb_blocklog - sbp->sb_inodelog != sbp->sb_inopblog)	||
+	    (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE)	||
+	    (sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)	||
+	    (sbp->sb_imax_pct > 100 /* zero sb_imax_pct is valid */)	||
+	    sbp->sb_dblocks == 0					||
+	    sbp->sb_dblocks > XFS_MAX_DBLOCKS(sbp)			||
+	    sbp->sb_dblocks < XFS_MIN_DBLOCKS(sbp))) {
+		XFS_CORRUPTION_ERROR("SB sanity check failed",
+				XFS_ERRLEVEL_LOW, mp, sbp);
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+
+	/*
+	 * Currently only very few inode sizes are supported.
+	 */
+	switch (sbp->sb_inodesize) {
+	case 256:
+	case 512:
+	case 1024:
+	case 2048:
+		break;
+	default:
+		xfs_warn(mp, "inode size of %d bytes not supported",
+				sbp->sb_inodesize);
+		return XFS_ERROR(ENOSYS);
+	}
+
+	if (xfs_sb_validate_fsb_count(sbp, sbp->sb_dblocks) ||
+	    xfs_sb_validate_fsb_count(sbp, sbp->sb_rblocks)) {
+		xfs_warn(mp,
+		"file system too large to be mounted on this system.");
+		return XFS_ERROR(EFBIG);
+	}
+
+	/*
+	 * Version 1 directory format has never worked on Linux.
+	 */
+	if (unlikely(!xfs_sb_version_hasdirv2(sbp))) {
+		xfs_warn(mp, "file system using version 1 directory format");
+		return XFS_ERROR(ENOSYS);
+	}
+
+	return 0;
+}
+
+void
+xfs_sb_quota_from_disk(
+	struct xfs_sb	*sbp)
+{
+	if (sbp->sb_qflags & XFS_OQUOTA_ENFD) {
+		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
+					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
+	}
+	if (sbp->sb_qflags & XFS_OQUOTA_CHKD) {
+		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
+					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
+	}
+	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
+}
+
+void
+xfs_sb_from_disk(
+	struct xfs_sb	*to,
+	xfs_dsb_t	*from)
+{
+	to->sb_magicnum = be32_to_cpu(from->sb_magicnum);
+	to->sb_blocksize = be32_to_cpu(from->sb_blocksize);
+	to->sb_dblocks = be64_to_cpu(from->sb_dblocks);
+	to->sb_rblocks = be64_to_cpu(from->sb_rblocks);
+	to->sb_rextents = be64_to_cpu(from->sb_rextents);
+	memcpy(&to->sb_uuid, &from->sb_uuid, sizeof(to->sb_uuid));
+	to->sb_logstart = be64_to_cpu(from->sb_logstart);
+	to->sb_rootino = be64_to_cpu(from->sb_rootino);
+	to->sb_rbmino = be64_to_cpu(from->sb_rbmino);
+	to->sb_rsumino = be64_to_cpu(from->sb_rsumino);
+	to->sb_rextsize = be32_to_cpu(from->sb_rextsize);
+	to->sb_agblocks = be32_to_cpu(from->sb_agblocks);
+	to->sb_agcount = be32_to_cpu(from->sb_agcount);
+	to->sb_rbmblocks = be32_to_cpu(from->sb_rbmblocks);
+	to->sb_logblocks = be32_to_cpu(from->sb_logblocks);
+	to->sb_versionnum = be16_to_cpu(from->sb_versionnum);
+	to->sb_sectsize = be16_to_cpu(from->sb_sectsize);
+	to->sb_inodesize = be16_to_cpu(from->sb_inodesize);
+	to->sb_inopblock = be16_to_cpu(from->sb_inopblock);
+	memcpy(&to->sb_fname, &from->sb_fname, sizeof(to->sb_fname));
+	to->sb_blocklog = from->sb_blocklog;
+	to->sb_sectlog = from->sb_sectlog;
+	to->sb_inodelog = from->sb_inodelog;
+	to->sb_inopblog = from->sb_inopblog;
+	to->sb_agblklog = from->sb_agblklog;
+	to->sb_rextslog = from->sb_rextslog;
+	to->sb_inprogress = from->sb_inprogress;
+	to->sb_imax_pct = from->sb_imax_pct;
+	to->sb_icount = be64_to_cpu(from->sb_icount);
+	to->sb_ifree = be64_to_cpu(from->sb_ifree);
+	to->sb_fdblocks = be64_to_cpu(from->sb_fdblocks);
+	to->sb_frextents = be64_to_cpu(from->sb_frextents);
+	to->sb_uquotino = be64_to_cpu(from->sb_uquotino);
+	to->sb_gquotino = be64_to_cpu(from->sb_gquotino);
+	to->sb_qflags = be16_to_cpu(from->sb_qflags);
+	to->sb_flags = from->sb_flags;
+	to->sb_shared_vn = from->sb_shared_vn;
+	to->sb_inoalignmt = be32_to_cpu(from->sb_inoalignmt);
+	to->sb_unit = be32_to_cpu(from->sb_unit);
+	to->sb_width = be32_to_cpu(from->sb_width);
+	to->sb_dirblklog = from->sb_dirblklog;
+	to->sb_logsectlog = from->sb_logsectlog;
+	to->sb_logsectsize = be16_to_cpu(from->sb_logsectsize);
+	to->sb_logsunit = be32_to_cpu(from->sb_logsunit);
+	to->sb_features2 = be32_to_cpu(from->sb_features2);
+	to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
+	to->sb_features_compat = be32_to_cpu(from->sb_features_compat);
+	to->sb_features_ro_compat = be32_to_cpu(from->sb_features_ro_compat);
+	to->sb_features_incompat = be32_to_cpu(from->sb_features_incompat);
+	to->sb_features_log_incompat =
+				be32_to_cpu(from->sb_features_log_incompat);
+	to->sb_pad = 0;
+	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
+	to->sb_lsn = be64_to_cpu(from->sb_lsn);
+}
+
+static void
+xfs_sb_quota_to_disk(
+	xfs_dsb_t	*to,
+	xfs_sb_t	*from,
+	__int64_t	*fields)
+{
+	__uint16_t	qflags = from->sb_qflags;
+
+	if (*fields & XFS_SB_QFLAGS) {
+		/*
+		 * The in-core version of sb_qflags do not have
+		 * XFS_OQUOTA_* flags, whereas the on-disk version
+		 * does.  So, convert incore XFS_{PG}QUOTA_* flags
+		 * to on-disk XFS_OQUOTA_* flags.
+		 */
+		qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
+				XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
+
+		if (from->sb_qflags &
+				(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
+			qflags |= XFS_OQUOTA_ENFD;
+		if (from->sb_qflags &
+				(XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
+			qflags |= XFS_OQUOTA_CHKD;
+		to->sb_qflags = cpu_to_be16(qflags);
+		*fields &= ~XFS_SB_QFLAGS;
+	}
+}
+
+/*
+ * Copy in core superblock to ondisk one.
+ *
+ * The fields argument is mask of superblock fields to copy.
+ */
+void
+xfs_sb_to_disk(
+	xfs_dsb_t	*to,
+	xfs_sb_t	*from,
+	__int64_t	fields)
+{
+	xfs_caddr_t	to_ptr = (xfs_caddr_t)to;
+	xfs_caddr_t	from_ptr = (xfs_caddr_t)from;
+	xfs_sb_field_t	f;
+	int		first;
+	int		size;
+
+	ASSERT(fields);
+	if (!fields)
+		return;
+
+	xfs_sb_quota_to_disk(to, from, &fields);
+	while (fields) {
+		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
+		first = xfs_sb_info[f].offset;
+		size = xfs_sb_info[f + 1].offset - first;
+
+		ASSERT(xfs_sb_info[f].type == 0 || xfs_sb_info[f].type == 1);
+
+		if (size == 1 || xfs_sb_info[f].type == 1) {
+			memcpy(to_ptr + first, from_ptr + first, size);
+		} else {
+			switch (size) {
+			case 2:
+				*(__be16 *)(to_ptr + first) =
+					cpu_to_be16(*(__u16 *)(from_ptr + first));
+				break;
+			case 4:
+				*(__be32 *)(to_ptr + first) =
+					cpu_to_be32(*(__u32 *)(from_ptr + first));
+				break;
+			case 8:
+				*(__be64 *)(to_ptr + first) =
+					cpu_to_be64(*(__u64 *)(from_ptr + first));
+				break;
+			default:
+				ASSERT(0);
+			}
+		}
+
+		fields &= ~(1LL << f);
+	}
+}
+
+static int
+xfs_sb_verify(
+	struct xfs_buf	*bp,
+	bool		check_version)
+{
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_sb	sb;
+
+	xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
+
+	/*
+	 * Only check the in progress field for the primary superblock as
+	 * mkfs.xfs doesn't clear it from secondary superblocks.
+	 */
+	return xfs_mount_validate_sb(mp, &sb, bp->b_bn == XFS_SB_DADDR,
+				     check_version);
+}
+
+/*
+ * If the superblock has the CRC feature bit set or the CRC field is non-null,
+ * check that the CRC is valid.  We check the CRC field is non-null because a
+ * single bit error could clear the feature bit and unused parts of the
+ * superblock are supposed to be zero. Hence a non-null crc field indicates that
+ * we've potentially lost a feature bit and we should check it anyway.
+ */
+static void
+xfs_sb_read_verify(
+	struct xfs_buf	*bp)
+{
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);
+	int		error;
+
+	/*
+	 * open code the version check to avoid needing to convert the entire
+	 * superblock from disk order just to check the version number
+	 */
+	if (dsb->sb_magicnum == cpu_to_be32(XFS_SB_MAGIC) &&
+	    (((be16_to_cpu(dsb->sb_versionnum) & XFS_SB_VERSION_NUMBITS) ==
+						XFS_SB_VERSION_5) ||
+	     dsb->sb_crc != 0)) {
+
+		if (!xfs_verify_cksum(bp->b_addr, be16_to_cpu(dsb->sb_sectsize),
+				      offsetof(struct xfs_sb, sb_crc))) {
+			error = EFSCORRUPTED;
+			goto out_error;
+		}
+	}
+	error = xfs_sb_verify(bp, true);
+
+out_error:
+	if (error) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, error);
+	}
+}
+
+/*
+ * We may be probed for a filesystem match, so we may not want to emit
+ * messages when the superblock buffer is not actually an XFS superblock.
+ * If we find an XFS superblock, the run a normal, noisy mount because we are
+ * really going to mount it and want to know about errors.
+ */
+static void
+xfs_sb_quiet_read_verify(
+	struct xfs_buf	*bp)
+{
+	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);
+
+
+	if (dsb->sb_magicnum == cpu_to_be32(XFS_SB_MAGIC)) {
+		/* XFS filesystem, verify noisily! */
+		xfs_sb_read_verify(bp);
+		return;
+	}
+	/* quietly fail */
+	xfs_buf_ioerror(bp, EWRONGFS);
+}
+
+static void
+xfs_sb_write_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	int			error;
+
+	error = xfs_sb_verify(bp, false);
+	if (error) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, error);
+		return;
+	}
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	if (bip)
+		XFS_BUF_TO_SBP(bp)->sb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
+			 offsetof(struct xfs_sb, sb_crc));
+}
+
+const struct xfs_buf_ops xfs_sb_buf_ops = {
+	.verify_read = xfs_sb_read_verify,
+	.verify_write = xfs_sb_write_verify,
+};
+
+const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
+	.verify_read = xfs_sb_quiet_read_verify,
+	.verify_write = xfs_sb_write_verify,
+};
+
+/*
+ * xfs_mount_common
+ *
+ * Mount initialization code establishing various mount
+ * fields from the superblock associated with the given
+ * mount structure
+ */
+void
+xfs_sb_mount_common(
+	struct xfs_mount *mp,
+	struct xfs_sb	*sbp)
+{
+	mp->m_agfrotor = mp->m_agirotor = 0;
+	spin_lock_init(&mp->m_agirotor_lock);
+	mp->m_maxagi = mp->m_sb.sb_agcount;
+	mp->m_blkbit_log = sbp->sb_blocklog + XFS_NBBYLOG;
+	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
+	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
+	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
+	mp->m_agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
+	mp->m_blockmask = sbp->sb_blocksize - 1;
+	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
+	mp->m_blockwmask = mp->m_blockwsize - 1;
+
+	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
+	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
+	mp->m_alloc_mnr[0] = mp->m_alloc_mxr[0] / 2;
+	mp->m_alloc_mnr[1] = mp->m_alloc_mxr[1] / 2;
+
+	mp->m_inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 1);
+	mp->m_inobt_mxr[1] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 0);
+	mp->m_inobt_mnr[0] = mp->m_inobt_mxr[0] / 2;
+	mp->m_inobt_mnr[1] = mp->m_inobt_mxr[1] / 2;
+
+	mp->m_bmap_dmxr[0] = xfs_bmbt_maxrecs(mp, sbp->sb_blocksize, 1);
+	mp->m_bmap_dmxr[1] = xfs_bmbt_maxrecs(mp, sbp->sb_blocksize, 0);
+	mp->m_bmap_dmnr[0] = mp->m_bmap_dmxr[0] / 2;
+	mp->m_bmap_dmnr[1] = mp->m_bmap_dmxr[1] / 2;
+
+	mp->m_bsize = XFS_FSB_TO_BB(mp, 1);
+	mp->m_ialloc_inos = (int)MAX((__uint16_t)XFS_INODES_PER_CHUNK,
+					sbp->sb_inopblock);
+	mp->m_ialloc_blks = mp->m_ialloc_inos >> sbp->sb_inopblog;
+}
+
+/*
+ * xfs_initialize_perag_data
+ *
+ * Read in each per-ag structure so we can count up the number of
+ * allocated inodes, free inodes and used filesystem blocks as this
+ * information is no longer persistent in the superblock. Once we have
+ * this information, write it into the in-core superblock structure.
+ */
+int
+xfs_initialize_perag_data(
+	struct xfs_mount *mp,
+	xfs_agnumber_t	agcount)
+{
+	xfs_agnumber_t	index;
+	xfs_perag_t	*pag;
+	xfs_sb_t	*sbp = &mp->m_sb;
+	uint64_t	ifree = 0;
+	uint64_t	ialloc = 0;
+	uint64_t	bfree = 0;
+	uint64_t	bfreelst = 0;
+	uint64_t	btree = 0;
+	int		error;
+
+	for (index = 0; index < agcount; index++) {
+		/*
+		 * read the agf, then the agi. This gets us
+		 * all the information we need and populates the
+		 * per-ag structures for us.
+		 */
+		error = xfs_alloc_pagf_init(mp, NULL, index, 0);
+		if (error)
+			return error;
+
+		error = xfs_ialloc_pagi_init(mp, NULL, index);
+		if (error)
+			return error;
+		pag = xfs_perag_get(mp, index);
+		ifree += pag->pagi_freecount;
+		ialloc += pag->pagi_count;
+		bfree += pag->pagf_freeblks;
+		bfreelst += pag->pagf_flcount;
+		btree += pag->pagf_btreeblks;
+		xfs_perag_put(pag);
+	}
+	/*
+	 * Overwrite incore superblock counters with just-read data
+	 */
+	spin_lock(&mp->m_sb_lock);
+	sbp->sb_ifree = ifree;
+	sbp->sb_icount = ialloc;
+	sbp->sb_fdblocks = bfree + bfreelst + btree;
+	spin_unlock(&mp->m_sb_lock);
+
+	/* Fixup the per-cpu counters as well. */
+	xfs_icsb_reinit_counters(mp);
+
+	return 0;
+}
+
+/*
+ * xfs_mod_sb() can be used to copy arbitrary changes to the
+ * in-core superblock into the superblock buffer to be logged.
+ * It does not provide the higher level of locking that is
+ * needed to protect the in-core superblock from concurrent
+ * access.
+ */
+void
+xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
+{
+	xfs_buf_t	*bp;
+	int		first;
+	int		last;
+	xfs_mount_t	*mp;
+	xfs_sb_field_t	f;
+
+	ASSERT(fields);
+	if (!fields)
+		return;
+	mp = tp->t_mountp;
+	bp = xfs_trans_getsb(tp, mp, 0);
+	first = sizeof(xfs_sb_t);
+	last = 0;
+
+	/* translate/copy */
+
+	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, fields);
+
+	/* find modified range */
+	f = (xfs_sb_field_t)xfs_highbit64((__uint64_t)fields);
+	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
+	last = xfs_sb_info[f + 1].offset - 1;
+
+	f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
+	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
+	first = xfs_sb_info[f].offset;
+
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
+	xfs_trans_log_buf(tp, bp, first, last);
+}
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
