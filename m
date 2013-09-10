Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 754597F5D
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 20:02:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1A3E2304051
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 18:02:52 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	PaQmgfyY7Dfk445r for <xfs@oss.sgi.com>;
	Mon, 09 Sep 2013 18:02:45 -0700 (PDT)
Date: Tue, 10 Sep 2013 11:02:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 31/55 V2] libxfs: switch over to xfs_sb.c and remove
	xfs_mount.c
Message-ID: <20130910010241.GZ12779@dastard>
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-32-git-send-email-david@fromorbit.com>
	<522A1BCA.6010500@sgi.com> <20130906214021.GD12541@dastard>
	<522A4C79.1030200@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <522A4C79.1030200@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

libxfs: switch over to xfs_sb.c and remove xfs_mount.c

From: Dave Chinner <dchinner@redhat.com>

Now that the kernel code has split the superblock specific code out
of xfs_mount.c, we don't need xfs_mount.c anymore. Copy in xfs_sb.c
and remove xfs_mount.c

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
v2: fix missing pquota changes and other minor differences.

 include/Makefile                 |   1 -
 include/libxfs.h                 |  14 +-
 include/libxlog.h                |   4 -
 include/xfs_mount.h              | 372 ---------------------------------------
 include/xfs_sb.h                 |  26 +++
 include/xfs_trace.h              |   1 +
 libxfs/Makefile                  |  10 +-
 libxfs/init.c                    |   2 +-
 libxfs/xfs.h                     |   1 +
 libxfs/{xfs_mount.c => xfs_sb.c} | 289 ++++++++++++++++++------------
 10 files changed, 223 insertions(+), 497 deletions(-)

diff --git a/include/Makefile b/include/Makefile
index 6a4e521..45b8533 100644
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
index 51a2442..5422147 100644
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
@@ -477,7 +481,6 @@ extern xfs_trans_t	*libxfs_trans_dup (xfs_trans_t *);
 extern int	libxfs_trans_reserve (xfs_trans_t *, uint,uint,uint,uint,uint);
 extern int	libxfs_trans_commit (xfs_trans_t *, uint);
 extern void	libxfs_trans_cancel (xfs_trans_t *, int);
-extern void	libxfs_mod_sb (xfs_trans_t *, __int64_t);
 extern xfs_buf_t	*libxfs_trans_getsb (xfs_trans_t *, xfs_mount_t *, int);
 
 extern int	libxfs_trans_iget (xfs_mount_t *, xfs_trans_t *, xfs_ino_t,
@@ -705,7 +708,7 @@ void	xfs_dinode_from_disk(struct xfs_icdinode *,
 #define libxfs_idata_realloc		xfs_idata_realloc
 #define libxfs_idestroy_fork		xfs_idestroy_fork
 
-/* xfs_mount.h */
+/* xfs_sb.h */
 #define libxfs_mod_sb			xfs_mod_sb
 #define libxfs_sb_from_disk		xfs_sb_from_disk
 #define libxfs_sb_to_disk		xfs_sb_to_disk
@@ -730,4 +733,9 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 
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
index 4a710d6..04fe32a 100644
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
@@ -26,6 +26,7 @@
 
 struct xfs_buf;
 struct xfs_mount;
+struct xfs_trans;
 
 #define	XFS_SB_MAGIC		0x58465342	/* 'XFSB' */
 #define	XFS_SB_VERSION_1	1		/* 5.3, 6.0.1, 6.1 */
@@ -630,6 +631,12 @@ static inline int xfs_sb_version_has_pquotino(xfs_sb_t *sbp)
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
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
@@ -666,4 +673,23 @@ static inline int xfs_sb_version_has_pquotino(xfs_sb_t *sbp)
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
diff --git a/libxfs/xfs_mount.c b/libxfs/xfs_sb.c
similarity index 78%
rename from libxfs/xfs_mount.c
rename to libxfs/xfs_sb.c
index 8b267bc..8b90b88 100644
--- a/libxfs/xfs_mount.c
+++ b/libxfs/xfs_sb.c
@@ -15,70 +15,73 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-
 #include <xfs.h>
 
+/*
+ * Physical superblock buffer manipulations. Shared with libxfs in userspace.
+ */
+
 static const struct {
 	short offset;
 	short type;	/* 0 = integer
 			 * 1 = binary / string (no translation)
 			 */
 } xfs_sb_info[] = {
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
+	{ offsetof(xfs_sb_t, sb_magicnum),	0 },
+	{ offsetof(xfs_sb_t, sb_blocksize),	0 },
+	{ offsetof(xfs_sb_t, sb_dblocks),	0 },
+	{ offsetof(xfs_sb_t, sb_rblocks),	0 },
+	{ offsetof(xfs_sb_t, sb_rextents),	0 },
+	{ offsetof(xfs_sb_t, sb_uuid),		1 },
+	{ offsetof(xfs_sb_t, sb_logstart),	0 },
+	{ offsetof(xfs_sb_t, sb_rootino),	0 },
+	{ offsetof(xfs_sb_t, sb_rbmino),	0 },
+	{ offsetof(xfs_sb_t, sb_rsumino),	0 },
+	{ offsetof(xfs_sb_t, sb_rextsize),	0 },
+	{ offsetof(xfs_sb_t, sb_agblocks),	0 },
+	{ offsetof(xfs_sb_t, sb_agcount),	0 },
+	{ offsetof(xfs_sb_t, sb_rbmblocks),	0 },
+	{ offsetof(xfs_sb_t, sb_logblocks),	0 },
+	{ offsetof(xfs_sb_t, sb_versionnum),	0 },
+	{ offsetof(xfs_sb_t, sb_sectsize),	0 },
+	{ offsetof(xfs_sb_t, sb_inodesize),	0 },
+	{ offsetof(xfs_sb_t, sb_inopblock),	0 },
+	{ offsetof(xfs_sb_t, sb_fname[0]),	1 },
+	{ offsetof(xfs_sb_t, sb_blocklog),	0 },
+	{ offsetof(xfs_sb_t, sb_sectlog),	0 },
+	{ offsetof(xfs_sb_t, sb_inodelog),	0 },
+	{ offsetof(xfs_sb_t, sb_inopblog),	0 },
+	{ offsetof(xfs_sb_t, sb_agblklog),	0 },
+	{ offsetof(xfs_sb_t, sb_rextslog),	0 },
+	{ offsetof(xfs_sb_t, sb_inprogress),	0 },
+	{ offsetof(xfs_sb_t, sb_imax_pct),	0 },
+	{ offsetof(xfs_sb_t, sb_icount),	0 },
+	{ offsetof(xfs_sb_t, sb_ifree),		0 },
+	{ offsetof(xfs_sb_t, sb_fdblocks),	0 },
+	{ offsetof(xfs_sb_t, sb_frextents),	0 },
+	{ offsetof(xfs_sb_t, sb_uquotino),	0 },
+	{ offsetof(xfs_sb_t, sb_gquotino),	0 },
+	{ offsetof(xfs_sb_t, sb_qflags),	0 },
+	{ offsetof(xfs_sb_t, sb_flags),		0 },
+	{ offsetof(xfs_sb_t, sb_shared_vn),	0 },
+	{ offsetof(xfs_sb_t, sb_inoalignmt),	0 },
+	{ offsetof(xfs_sb_t, sb_unit),		0 },
+	{ offsetof(xfs_sb_t, sb_width),		0 },
+	{ offsetof(xfs_sb_t, sb_dirblklog),	0 },
+	{ offsetof(xfs_sb_t, sb_logsectlog),	0 },
+	{ offsetof(xfs_sb_t, sb_logsectsize),	0 },
+	{ offsetof(xfs_sb_t, sb_logsunit),	0 },
+	{ offsetof(xfs_sb_t, sb_features2),	0 },
+	{ offsetof(xfs_sb_t, sb_bad_features2),	0 },
+	{ offsetof(xfs_sb_t, sb_features_compat),	0 },
+	{ offsetof(xfs_sb_t, sb_features_ro_compat),	0 },
+	{ offsetof(xfs_sb_t, sb_features_incompat),	0 },
+	{ offsetof(xfs_sb_t, sb_features_log_incompat),	0 },
+	{ offsetof(xfs_sb_t, sb_crc),		0 },
+	{ offsetof(xfs_sb_t, sb_pad),		0 },
+	{ offsetof(xfs_sb_t, sb_pquotino),	0 },
+	{ offsetof(xfs_sb_t, sb_lsn),		0 },
+	{ sizeof(xfs_sb_t),			0 }
 };
 
 /*
@@ -87,7 +90,9 @@ static const struct {
  * have to protect against changes is the tree structure itself.
  */
 struct xfs_perag *
-xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
+xfs_perag_get(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
 {
 	struct xfs_perag	*pag;
 	int			ref = 0;
@@ -103,8 +108,35 @@ xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
 	return pag;
 }
 
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
 void
-xfs_perag_put(struct xfs_perag *pag)
+xfs_perag_put(
+	struct xfs_perag	*pag)
 {
 	int	ref;
 
@@ -144,7 +176,8 @@ xfs_mount_validate_sb(
 
 	/*
 	 * Version 5 superblock feature mask validation. Reject combinations the
-	 * kernel cannot support up front before checking anything else.
+	 * kernel cannot support up front before checking anything else. For
+	 * write validation, we don't need to check feature masks.
 	 */
 	if (check_version && XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
 		xfs_alert(mp,
@@ -179,12 +212,17 @@ xfs_mount_validate_sb(
 		}
 	}
 
-	if ((sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) &&
-			(sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
-				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))) {
-		xfs_warn(mp,
-"Super block has XFS_OQUOTA bits along with XFS_PQUOTA and/or XFS_GQUOTA bits.\n");
-		return XFS_ERROR(EFSCORRUPTED);
+	if (xfs_sb_version_has_pquotino(sbp)) {
+		if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
+			xfs_notice(mp,
+			   "Version 5 of Super block has XFS_OQUOTA bits.\n");
+			return XFS_ERROR(EFSCORRUPTED);
+		}
+	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
+				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
+			xfs_notice(mp,
+"Superblock earlier than Version 5 has XFS_[PQ]UOTA_{ENFD|CHKD} bits.\n");
+			return XFS_ERROR(EFSCORRUPTED);
 	}
 
 	if (unlikely(
@@ -251,6 +289,13 @@ xfs_mount_validate_sb(
 		return XFS_ERROR(ENOSYS);
 	}
 
+	if (xfs_sb_validate_fsb_count(sbp, sbp->sb_dblocks) ||
+	    xfs_sb_validate_fsb_count(sbp, sbp->sb_rblocks)) {
+		xfs_warn(mp,
+		"file system too large to be mounted on this system.");
+		return XFS_ERROR(EFBIG);
+	}
+
 	/*
 	 * Version 1 directory format has never worked on Linux.
 	 */
@@ -263,8 +308,57 @@ xfs_mount_validate_sb(
 }
 
 void
+xfs_sb_quota_from_disk(struct xfs_sb *sbp)
+{
+	/*
+	 * older mkfs doesn't initialize quota inodes to NULLFSINO. This
+	 * leads to in-core values having two different values for a quota
+	 * inode to be invalid: 0 and NULLFSINO. Change it to a single value
+	 * NULLFSINO.
+	 *
+	 * Note that this change affect only the in-core values. These
+	 * values are not written back to disk unless any quota information
+	 * is written to the disk. Even in that case, sb_pquotino field is
+	 * not written to disk unless the superblock supports pquotino.
+	 */
+	if (sbp->sb_uquotino == 0)
+		sbp->sb_uquotino = NULLFSINO;
+	if (sbp->sb_gquotino == 0)
+		sbp->sb_gquotino = NULLFSINO;
+	if (sbp->sb_pquotino == 0)
+		sbp->sb_pquotino = NULLFSINO;
+
+	/*
+	 * We need to do these manipilations only if we are working
+	 * with an older version of on-disk superblock.
+	 */
+	if (xfs_sb_version_has_pquotino(sbp))
+		return;
+
+	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
+		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
+					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
+	if (sbp->sb_qflags & XFS_OQUOTA_CHKD)
+		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
+					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
+	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
+
+	if (sbp->sb_qflags & XFS_PQUOTA_ACCT)  {
+		/*
+		 * In older version of superblock, on-disk superblock only
+		 * has sb_gquotino, and in-core superblock has both sb_gquotino
+		 * and sb_pquotino. But, only one of them is supported at any
+		 * point of time. So, if PQUOTA is set in disk superblock,
+		 * copy over sb_gquotino to sb_pquotino.
+		 */
+		sbp->sb_pquotino = sbp->sb_gquotino;
+		sbp->sb_gquotino = NULLFSINO;
+	}
+}
+
+void
 xfs_sb_from_disk(
-	xfs_sb_t	*to,
+	struct xfs_sb	*to,
 	xfs_dsb_t	*from)
 {
 	to->sb_magicnum = be32_to_cpu(from->sb_magicnum);
@@ -323,37 +417,6 @@ xfs_sb_from_disk(
 	to->sb_lsn = be64_to_cpu(from->sb_lsn);
 }
 
-static void
-xfs_sb_quota_from_disk(struct xfs_sb *sbp)
-{
-	/*
-	 * We need to do these manipilations only if we are working
-	 * with an older version of on-disk superblock.
-	 */
-	if (xfs_sb_version_has_pquotino(sbp))
-		return;
-
-	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
-		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
-					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
-	if (sbp->sb_qflags & XFS_OQUOTA_CHKD)
-		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
-					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
-	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
-
-	if (sbp->sb_qflags & XFS_PQUOTA_ACCT)  {
-		/*
-		 * In older version of superblock, on-disk superblock only
-		 * has sb_gquotino, and in-core superblock has both sb_gquotino
-		 * and sb_pquotino. But, only one of them is supported at any
-		 * point of time. So, if PQUOTA is set in disk superblock,
-		 * copy over sb_gquotino to sb_pquotino.
-		 */
-		sbp->sb_pquotino = sbp->sb_gquotino;
-		sbp->sb_gquotino = NULLFSINO;
-	}
-}
-
 static inline void
 xfs_sb_quota_to_disk(
 	xfs_dsb_t	*to,
@@ -427,7 +490,6 @@ xfs_sb_to_disk(
 		return;
 
 	xfs_sb_quota_to_disk(to, from, &fields);
-
 	while (fields) {
 		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
 		first = xfs_sb_info[f].offset;
@@ -441,15 +503,15 @@ xfs_sb_to_disk(
 			switch (size) {
 			case 2:
 				*(__be16 *)(to_ptr + first) =
-					cpu_to_be16(*(__u16 *)(from_ptr + first));
+				      cpu_to_be16(*(__u16 *)(from_ptr + first));
 				break;
 			case 4:
 				*(__be32 *)(to_ptr + first) =
-					cpu_to_be32(*(__u32 *)(from_ptr + first));
+				      cpu_to_be32(*(__u32 *)(from_ptr + first));
 				break;
 			case 8:
 				*(__be64 *)(to_ptr + first) =
-					cpu_to_be64(*(__u64 *)(from_ptr + first));
+				      cpu_to_be64(*(__u64 *)(from_ptr + first));
 				break;
 			default:
 				ASSERT(0);
@@ -470,8 +532,6 @@ xfs_sb_verify(
 
 	xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
 
-	xfs_sb_quota_from_disk(&sb);
-
 	/*
 	 * Only check the in progress field for the primary superblock as
 	 * mkfs.xfs doesn't clear it from secondary superblocks.
@@ -514,7 +574,8 @@ xfs_sb_read_verify(
 
 out_error:
 	if (error) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
+				     mp, bp->b_addr);
 		xfs_buf_ioerror(bp, error);
 	}
 }
@@ -522,7 +583,7 @@ out_error:
 /*
  * We may be probed for a filesystem match, so we may not want to emit
  * messages when the superblock buffer is not actually an XFS superblock.
- * If we find an XFS superblock, the run a normal, noisy mount because we are
+ * If we find an XFS superblock, then run a normal, noisy mount because we are
  * really going to mount it and want to know about errors.
  */
 static void
@@ -551,7 +612,8 @@ xfs_sb_write_verify(
 
 	error = xfs_sb_verify(bp, false);
 	if (error) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
+				     mp, bp->b_addr);
 		xfs_buf_ioerror(bp, error);
 		return;
 	}
@@ -571,7 +633,7 @@ const struct xfs_buf_ops xfs_sb_buf_ops = {
 	.verify_write = xfs_sb_write_verify,
 };
 
-static const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
+const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
 	.verify_read = xfs_sb_quiet_read_verify,
 	.verify_write = xfs_sb_write_verify,
 };
@@ -582,11 +644,11 @@ static const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
  * Mount initialization code establishing various mount
  * fields from the superblock associated with the given
  * mount structure
- *
- * Note: this requires user-space public scope for libxfs_mount
  */
 void
-xfs_mount_common(xfs_mount_t *mp, xfs_sb_t *sbp)
+xfs_sb_mount_common(
+	struct xfs_mount *mp,
+	struct xfs_sb	*sbp)
 {
 	mp->m_agfrotor = mp->m_agirotor = 0;
 	spin_lock_init(&mp->m_agirotor_lock);
@@ -628,11 +690,11 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb_t *sbp)
  * allocated inodes, free inodes and used filesystem blocks as this
  * information is no longer persistent in the superblock. Once we have
  * this information, write it into the in-core superblock structure.
- *
- * Note: this requires user-space public scope for libxfs_mount
  */
 int
-xfs_initialize_perag_data(xfs_mount_t *mp, xfs_agnumber_t agcount)
+xfs_initialize_perag_data(
+	struct xfs_mount *mp,
+	xfs_agnumber_t	agcount)
 {
 	xfs_agnumber_t	index;
 	xfs_perag_t	*pag;
@@ -705,6 +767,7 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
 	last = 0;
 
 	/* translate/copy */
+
 	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, fields);
 
 	/* find modified range */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
