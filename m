Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 87D668030
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:37:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 690FE8F8037
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:37:07 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	RHCgyaXy3u4XNhlw for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 03:37:04 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UmiQD-0001BW-F3
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:57 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UmiQ3-0006my-9a
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/22] libxfs: update xfs_inode.h to match new kernel version
Date: Wed, 12 Jun 2013 20:36:19 +1000
Message-Id: <1371033394-26006-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1371033394-26006-1-git-send-email-david@fromorbit.com>
References: <1371033394-26006-1-git-send-email-david@fromorbit.com>
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

Much of the kernel specific guts of xfs_inode.h have been moved to a
kernel only header file. Update the userspace header and libxfs
xfs_inode.c file to match the new kernel version.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_inode.h |  339 ++-------------------------------------------------
 libxfs/xfs.h        |    1 +
 libxfs/xfs_inode.c  |  170 ++++++++++++++------------
 3 files changed, 99 insertions(+), 411 deletions(-)

diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index fdca7f7..739a975 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -21,6 +21,7 @@
 struct posix_acl;
 struct xfs_dinode;
 struct xfs_inode;
+struct xfs_inode_log_item;
 
 /*
  * Fork identifiers.
@@ -152,7 +153,7 @@ typedef struct xfs_icdinode {
 	__uint32_t	di_gen;		/* generation number */
 
 	/* di_next_unlinked is the only non-core field in the old dinode */
-	__be32		di_next_unlinked;/* agi unlinked list ptr */
+	xfs_agino_t	di_next_unlinked;/* agi unlinked list ptr */
 
 	/* start of the extended dinode, writable fields */
 	__uint32_t	di_crc;		/* CRC of the inode */
@@ -237,335 +238,7 @@ static inline uint xfs_icdinode_size(int version)
 
 #ifdef __KERNEL__
 
-struct xfs_buf;
-struct xfs_bmap_free;
-struct xfs_bmbt_irec;
-struct xfs_inode_log_item;
-struct xfs_mount;
-struct xfs_trans;
-struct xfs_dquot;
-
-typedef struct xfs_inode {
-	/* Inode linking and identification information. */
-	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
-	struct xfs_dquot	*i_udquot;	/* user dquot */
-	struct xfs_dquot	*i_gdquot;	/* group dquot */
-
-	/* Inode location stuff */
-	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
-	struct xfs_imap		i_imap;		/* location for xfs_imap() */
-
-	/* Extent information. */
-	xfs_ifork_t		*i_afp;		/* attribute fork pointer */
-	xfs_ifork_t		i_df;		/* data fork */
-
-	/* Transaction and locking information. */
-	struct xfs_inode_log_item *i_itemp;	/* logging information */
-	mrlock_t		i_lock;		/* inode lock */
-	mrlock_t		i_iolock;	/* inode IO lock */
-	atomic_t		i_pincount;	/* inode pin count */
-	spinlock_t		i_flags_lock;	/* inode i_flags lock */
-	/* Miscellaneous state. */
-	unsigned long		i_flags;	/* see defined flags below */
-	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
-
-	xfs_icdinode_t		i_d;		/* most of ondisk inode */
-
-	/* VFS inode */
-	struct inode		i_vnode;	/* embedded VFS inode */
-} xfs_inode_t;
-
-/* Convert from vfs inode to xfs inode */
-static inline struct xfs_inode *XFS_I(struct inode *inode)
-{
-	return container_of(inode, struct xfs_inode, i_vnode);
-}
-
-/* convert from xfs inode to vfs inode */
-static inline struct inode *VFS_I(struct xfs_inode *ip)
-{
-	return &ip->i_vnode;
-}
-
-/*
- * For regular files we only update the on-disk filesize when actually
- * writing data back to disk.  Until then only the copy in the VFS inode
- * is uptodate.
- */
-static inline xfs_fsize_t XFS_ISIZE(struct xfs_inode *ip)
-{
-	if (S_ISREG(ip->i_d.di_mode))
-		return i_size_read(VFS_I(ip));
-	return ip->i_d.di_size;
-}
-
-/*
- * If this I/O goes past the on-disk inode size update it unless it would
- * be past the current in-core inode size.
- */
-static inline xfs_fsize_t
-xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
-{
-	xfs_fsize_t i_size = i_size_read(VFS_I(ip));
-
-	if (new_size > i_size)
-		new_size = i_size;
-	return new_size > ip->i_d.di_size ? new_size : 0;
-}
-
-/*
- * i_flags helper functions
- */
-static inline void
-__xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
-{
-	ip->i_flags |= flags;
-}
-
-static inline void
-xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
-{
-	spin_lock(&ip->i_flags_lock);
-	__xfs_iflags_set(ip, flags);
-	spin_unlock(&ip->i_flags_lock);
-}
-
-static inline void
-xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
-{
-	spin_lock(&ip->i_flags_lock);
-	ip->i_flags &= ~flags;
-	spin_unlock(&ip->i_flags_lock);
-}
-
-static inline int
-__xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
-{
-	return (ip->i_flags & flags);
-}
-
-static inline int
-xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
-{
-	int ret;
-	spin_lock(&ip->i_flags_lock);
-	ret = __xfs_iflags_test(ip, flags);
-	spin_unlock(&ip->i_flags_lock);
-	return ret;
-}
-
-static inline int
-xfs_iflags_test_and_clear(xfs_inode_t *ip, unsigned short flags)
-{
-	int ret;
-
-	spin_lock(&ip->i_flags_lock);
-	ret = ip->i_flags & flags;
-	if (ret)
-		ip->i_flags &= ~flags;
-	spin_unlock(&ip->i_flags_lock);
-	return ret;
-}
-
-static inline int
-xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
-{
-	int ret;
-
-	spin_lock(&ip->i_flags_lock);
-	ret = ip->i_flags & flags;
-	if (!ret)
-		ip->i_flags |= flags;
-	spin_unlock(&ip->i_flags_lock);
-	return ret;
-}
-
-/*
- * Project quota id helpers (previously projid was 16bit only
- * and using two 16bit values to hold new 32bit projid was chosen
- * to retain compatibility with "old" filesystems).
- */
-static inline prid_t
-xfs_get_projid(struct xfs_inode *ip)
-{
-	return (prid_t)ip->i_d.di_projid_hi << 16 | ip->i_d.di_projid_lo;
-}
-
-static inline void
-xfs_set_projid(struct xfs_inode *ip,
-		prid_t projid)
-{
-	ip->i_d.di_projid_hi = (__uint16_t) (projid >> 16);
-	ip->i_d.di_projid_lo = (__uint16_t) (projid & 0xffff);
-}
-
-/*
- * In-core inode flags.
- */
-#define XFS_IRECLAIM		(1 << 0) /* started reclaiming this inode */
-#define XFS_ISTALE		(1 << 1) /* inode has been staled */
-#define XFS_IRECLAIMABLE	(1 << 2) /* inode can be reclaimed */
-#define XFS_INEW		(1 << 3) /* inode has just been allocated */
-#define XFS_IFILESTREAM		(1 << 4) /* inode is in a filestream dir. */
-#define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
-#define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
-#define __XFS_IFLOCK_BIT	7	 /* inode is being flushed right now */
-#define XFS_IFLOCK		(1 << __XFS_IFLOCK_BIT)
-#define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
-#define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
-#define XFS_IDONTCACHE		(1 << 9) /* don't cache the inode long term */
-
-/*
- * Per-lifetime flags need to be reset when re-using a reclaimable inode during
- * inode lookup. This prevents unintended behaviour on the new inode from
- * ocurring.
- */
-#define XFS_IRECLAIM_RESET_FLAGS	\
-	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
-	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED | \
-	 XFS_IFILESTREAM);
-
-/*
- * Synchronize processes attempting to flush the in-core inode back to disk.
- */
-
-extern void __xfs_iflock(struct xfs_inode *ip);
-
-static inline int xfs_iflock_nowait(struct xfs_inode *ip)
-{
-	return !xfs_iflags_test_and_set(ip, XFS_IFLOCK);
-}
-
-static inline void xfs_iflock(struct xfs_inode *ip)
-{
-	if (!xfs_iflock_nowait(ip))
-		__xfs_iflock(ip);
-}
-
-static inline void xfs_ifunlock(struct xfs_inode *ip)
-{
-	xfs_iflags_clear(ip, XFS_IFLOCK);
-	smp_mb();
-	wake_up_bit(&ip->i_flags, __XFS_IFLOCK_BIT);
-}
-
-static inline int xfs_isiflocked(struct xfs_inode *ip)
-{
-	return xfs_iflags_test(ip, XFS_IFLOCK);
-}
-
-/*
- * Flags for inode locking.
- * Bit ranges:	1<<1  - 1<<16-1 -- iolock/ilock modes (bitfield)
- *		1<<16 - 1<<32-1 -- lockdep annotation (integers)
- */
-#define	XFS_IOLOCK_EXCL		(1<<0)
-#define	XFS_IOLOCK_SHARED	(1<<1)
-#define	XFS_ILOCK_EXCL		(1<<2)
-#define	XFS_ILOCK_SHARED	(1<<3)
-
-#define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
-				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)
-
-#define XFS_LOCK_FLAGS \
-	{ XFS_IOLOCK_EXCL,	"IOLOCK_EXCL" }, \
-	{ XFS_IOLOCK_SHARED,	"IOLOCK_SHARED" }, \
-	{ XFS_ILOCK_EXCL,	"ILOCK_EXCL" }, \
-	{ XFS_ILOCK_SHARED,	"ILOCK_SHARED" }
-
-
-/*
- * Flags for lockdep annotations.
- *
- * XFS_LOCK_PARENT - for directory operations that require locking a
- * parent directory inode and a child entry inode.  The parent gets locked
- * with this flag so it gets a lockdep subclass of 1 and the child entry
- * lock will have a lockdep subclass of 0.
- *
- * XFS_LOCK_RTBITMAP/XFS_LOCK_RTSUM - the realtime device bitmap and summary
- * inodes do not participate in the normal lock order, and thus have their
- * own subclasses.
- *
- * XFS_LOCK_INUMORDER - for locking several inodes at the some time
- * with xfs_lock_inodes().  This flag is used as the starting subclass
- * and each subsequent lock acquired will increment the subclass by one.
- * So the first lock acquired will have a lockdep subclass of 4, the
- * second lock will have a lockdep subclass of 5, and so on. It is
- * the responsibility of the class builder to shift this to the correct
- * portion of the lock_mode lockdep mask.
- */
-#define XFS_LOCK_PARENT		1
-#define XFS_LOCK_RTBITMAP	2
-#define XFS_LOCK_RTSUM		3
-#define XFS_LOCK_INUMORDER	4
-
-#define XFS_IOLOCK_SHIFT	16
-#define	XFS_IOLOCK_PARENT	(XFS_LOCK_PARENT << XFS_IOLOCK_SHIFT)
-
-#define XFS_ILOCK_SHIFT		24
-#define	XFS_ILOCK_PARENT	(XFS_LOCK_PARENT << XFS_ILOCK_SHIFT)
-#define	XFS_ILOCK_RTBITMAP	(XFS_LOCK_RTBITMAP << XFS_ILOCK_SHIFT)
-#define	XFS_ILOCK_RTSUM		(XFS_LOCK_RTSUM << XFS_ILOCK_SHIFT)
-
-#define XFS_IOLOCK_DEP_MASK	0x00ff0000
-#define XFS_ILOCK_DEP_MASK	0xff000000
-#define XFS_LOCK_DEP_MASK	(XFS_IOLOCK_DEP_MASK | XFS_ILOCK_DEP_MASK)
-
-#define XFS_IOLOCK_DEP(flags)	(((flags) & XFS_IOLOCK_DEP_MASK) >> XFS_IOLOCK_SHIFT)
-#define XFS_ILOCK_DEP(flags)	(((flags) & XFS_ILOCK_DEP_MASK) >> XFS_ILOCK_SHIFT)
-
-/*
- * For multiple groups support: if S_ISGID bit is set in the parent
- * directory, group of new file is set to that of the parent, and
- * new subdirectory gets S_ISGID bit from parent.
- */
-#define XFS_INHERIT_GID(pip)	\
-	(((pip)->i_mount->m_flags & XFS_MOUNT_GRPID) || \
-	 ((pip)->i_d.di_mode & S_ISGID))
-
-
-/*
- * xfs_inode.c prototypes.
- */
-void		xfs_ilock(xfs_inode_t *, uint);
-int		xfs_ilock_nowait(xfs_inode_t *, uint);
-void		xfs_iunlock(xfs_inode_t *, uint);
-void		xfs_ilock_demote(xfs_inode_t *, uint);
-int		xfs_isilocked(xfs_inode_t *, uint);
-uint		xfs_ilock_map_shared(xfs_inode_t *);
-void		xfs_iunlock_map_shared(xfs_inode_t *, uint);
-int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, umode_t,
-			   xfs_nlink_t, xfs_dev_t, prid_t, int,
-			   struct xfs_buf **, xfs_inode_t **);
-
-uint		xfs_ip2xflags(struct xfs_inode *);
-uint		xfs_dic2xflags(struct xfs_dinode *);
-int		xfs_ifree(struct xfs_trans *, xfs_inode_t *,
-			   struct xfs_bmap_free *);
-int		xfs_itruncate_extents(struct xfs_trans **, struct xfs_inode *,
-				      int, xfs_fsize_t);
-int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
-
-void		xfs_iext_realloc(xfs_inode_t *, int, int);
-void		xfs_iunpin_wait(xfs_inode_t *);
-int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
-void		xfs_lock_inodes(xfs_inode_t **, int, uint);
-void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
-
-xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
-
-#define IHOLD(ip) \
-do { \
-	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
-	ihold(VFS_I(ip)); \
-	trace_xfs_ihold(ip, _THIS_IP_); \
-} while (0)
-
-#define IRELE(ip) \
-do { \
-	trace_xfs_irele(ip, _THIS_IP_); \
-	iput(VFS_I(ip)); \
-} while (0)
+#include "xfs_inode_ops.h"
 
 #endif /* __KERNEL__ */
 
@@ -584,6 +257,9 @@ int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
 void		xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
 void		xfs_dinode_to_disk(struct xfs_dinode *,
 				   struct xfs_icdinode *);
+void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
+				struct xfs_inode_log_item *, int,
+				struct xfs_buf *);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
 void		xfs_idata_realloc(struct xfs_inode *, int, int);
 void		xfs_iroot_realloc(struct xfs_inode *, int, int);
@@ -592,14 +268,13 @@ int		xfs_iextents_copy(struct xfs_inode *, xfs_bmbt_rec_t *, int);
 
 xfs_bmbt_rec_host_t *xfs_iext_get_ext(xfs_ifork_t *, xfs_extnum_t);
 void		xfs_iext_insert(struct xfs_inode *, xfs_extnum_t, xfs_extnum_t,
-				xfs_bmbt_irec_t *, int);
+				struct xfs_bmbt_irec *, int);
 void		xfs_iext_add(xfs_ifork_t *, xfs_extnum_t, int);
 void		xfs_iext_add_indirect_multi(xfs_ifork_t *, int, xfs_extnum_t, int);
 void		xfs_iext_remove(struct xfs_inode *, xfs_extnum_t, int, int);
 void		xfs_iext_remove_inline(xfs_ifork_t *, xfs_extnum_t, int);
 void		xfs_iext_remove_direct(xfs_ifork_t *, xfs_extnum_t, int);
 void		xfs_iext_remove_indirect(xfs_ifork_t *, xfs_extnum_t, int);
-void		xfs_iext_realloc_direct(xfs_ifork_t *, int);
 void		xfs_iext_direct_to_inline(xfs_ifork_t *, xfs_extnum_t);
 void		xfs_iext_inline_to_direct(xfs_ifork_t *, int);
 void		xfs_iext_destroy(xfs_ifork_t *);
diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index eeb6128..baea002 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -208,6 +208,7 @@ roundup_pow_of_two(uint v)
 #define XFS_MOUNT_SMALL_INUMS		0	/* ignored in userspace */
 #define XFS_MOUNT_WSYNC			0	/* ignored in userspace */
 #define XFS_MOUNT_NOALIGN		0	/* ignored in userspace */
+#define XFS_MOUNT_IKEEP			0	/* ignored in userspace */
 
 #define xfs_icsb_modify_counters(mp, field, delta, rsvd) \
 	xfs_mod_incore_sb(mp, field, delta, rsvd)
diff --git a/libxfs/xfs_inode.c b/libxfs/xfs_inode.c
index d6513b9..195baae 100644
--- a/libxfs/xfs_inode.c
+++ b/libxfs/xfs_inode.c
@@ -21,12 +21,6 @@
 kmem_zone_t *xfs_ifork_zone;
 kmem_zone_t *xfs_inode_zone;
 
-/*
- * Used in xfs_itruncate_extents().  This is the maximum number of extents
- * freed from a file in a single transaction.
- */
-#define	XFS_ITRUNC_MAX_EXTENTS	2
-
 STATIC int xfs_iformat_local(xfs_inode_t *, xfs_dinode_t *, int, int);
 STATIC int xfs_iformat_extents(xfs_inode_t *, xfs_dinode_t *, int);
 STATIC int xfs_iformat_btree(xfs_inode_t *, xfs_dinode_t *, int);
@@ -237,7 +231,7 @@ xfs_iformat(
 	}
 
 	if (unlikely((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) &&
-		     !ip->i_mount->m_rtdev)) {
+		     !ip->i_mount->m_rtdev_targp)) {
 		xfs_warn(ip->i_mount,
 			"corrupt dinode %Lu, has realtime flag set.",
 			ip->i_ino);
@@ -581,7 +575,7 @@ xfs_dinode_from_disk(
 		to->di_ino = be64_to_cpu(from->di_ino);
 		to->di_lsn = be64_to_cpu(from->di_lsn);
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
-		platform_uuid_copy(&to->di_uuid, &from->di_uuid);
+		uuid_copy(&to->di_uuid, &from->di_uuid);
 	}
 }
 
@@ -628,7 +622,7 @@ xfs_dinode_to_disk(
 		to->di_ino = cpu_to_be64(from->di_ino);
 		to->di_lsn = cpu_to_be64(from->di_lsn);
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
-		platform_uuid_copy(&to->di_uuid, &from->di_uuid);
+		uuid_copy(&to->di_uuid, &from->di_uuid);
 	}
 }
 
@@ -675,6 +669,11 @@ xfs_dinode_calc_crc(
 
 /*
  * Read the disk inode attributes into the in-core inode structure.
+ *
+ * If we are initialising a new inode and we are not utilising the
+ * XFS_MOUNT_IKEEP inode cluster mode, we can simple build the new inode core
+ * with a random generation number. If we are keeping inodes around, we need to
+ * read the inode cluster to get the existing generation number off disk.
  */
 int
 xfs_iread(
@@ -694,6 +693,22 @@ xfs_iread(
 	if (error)
 		return error;
 
+	/* shortcut IO on inode allocation if possible */
+	if ((iget_flags & XFS_IGET_CREATE) &&
+	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
+		/* initialise the on-disk inode core */
+		memset(&ip->i_d, 0, sizeof(ip->i_d));
+		ip->i_d.di_magic = XFS_DINODE_MAGIC;
+		ip->i_d.di_gen = prandom_u32();
+		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			ip->i_d.di_version = 3;
+			ip->i_d.di_ino = ip->i_ino;
+			uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid);
+		} else
+			ip->i_d.di_version = 2;
+		return 0;
+	}
+
 	/*
 	 * Get pointers to the on-disk inode and the buffer containing it.
 	 */
@@ -780,17 +795,16 @@ xfs_iread(
 	xfs_buf_set_ref(bp, XFS_INO_REF);
 
 	/*
-	 * Use xfs_trans_brelse() to release the buffer containing the
-	 * on-disk inode, because it was acquired with xfs_trans_read_buf()
-	 * in xfs_imap_to_bp() above.  If tp is NULL, this is just a normal
+	 * Use xfs_trans_brelse() to release the buffer containing the on-disk
+	 * inode, because it was acquired with xfs_trans_read_buf() in
+	 * xfs_imap_to_bp() above.  If tp is NULL, this is just a normal
 	 * brelse().  If we're within a transaction, then xfs_trans_brelse()
 	 * will only release the buffer if it is not dirty within the
 	 * transaction.  It will be OK to release the buffer in this case,
-	 * because inodes on disk are never destroyed and we will be
-	 * locking the new in-core inode before putting it in the hash
-	 * table where other processes can find it.  Thus we don't have
-	 * to worry about the inode being changed just because we released
-	 * the buffer.
+	 * because inodes on disk are never destroyed and we will be locking the
+	 * new in-core inode before putting it in the cache where other
+	 * processes can find it.  Thus we don't have to worry about the inode
+	 * being changed just because we released the buffer.
 	 */
  out_brelse:
 	xfs_trans_brelse(tp, bp);
@@ -1170,7 +1184,6 @@ xfs_iextents_copy(
  * In these cases, the format always takes precedence, because the
  * format indicates the current state of the fork.
  */
-/*ARGSUSED*/
 void
 xfs_iflush_fork(
 	xfs_inode_t		*ip,
@@ -1182,7 +1195,6 @@ xfs_iflush_fork(
 	char			*cp;
 	xfs_ifork_t		*ifp;
 	xfs_mount_t		*mp;
-
 	static const short	brootflag[2] =
 		{ XFS_ILOG_DBROOT, XFS_ILOG_ABROOT };
 	static const short	dataflag[2] =
@@ -1288,6 +1300,66 @@ xfs_iext_get_ext(
 }
 
 /*
+ * Create, destroy, or resize a linear (direct) block of extents.
+ */
+STATIC void
+xfs_iext_realloc_direct(
+	xfs_ifork_t	*ifp,		/* inode fork pointer */
+	int		new_size)	/* new size of extents */
+{
+	int		rnew_size;	/* real new size of extents */
+
+	rnew_size = new_size;
+
+	ASSERT(!(ifp->if_flags & XFS_IFEXTIREC) ||
+		((new_size >= 0) && (new_size <= XFS_IEXT_BUFSZ) &&
+		 (new_size != ifp->if_real_bytes)));
+
+	/* Free extent records */
+	if (new_size == 0) {
+		xfs_iext_destroy(ifp);
+	}
+	/* Resize direct extent list and zero any new bytes */
+	else if (ifp->if_real_bytes) {
+		/* Check if extents will fit inside the inode */
+		if (new_size <= XFS_INLINE_EXTS * sizeof(xfs_bmbt_rec_t)) {
+			xfs_iext_direct_to_inline(ifp, new_size /
+				(uint)sizeof(xfs_bmbt_rec_t));
+			ifp->if_bytes = new_size;
+			return;
+		}
+		if (!is_power_of_2(new_size)){
+			rnew_size = roundup_pow_of_two(new_size);
+		}
+		if (rnew_size != ifp->if_real_bytes) {
+			ifp->if_u1.if_extents =
+				kmem_realloc(ifp->if_u1.if_extents,
+						rnew_size,
+						ifp->if_real_bytes, KM_NOFS);
+		}
+		if (rnew_size > ifp->if_real_bytes) {
+			memset(&ifp->if_u1.if_extents[ifp->if_bytes /
+				(uint)sizeof(xfs_bmbt_rec_t)], 0,
+				rnew_size - ifp->if_real_bytes);
+		}
+	}
+	/*
+	 * Switch from the inline extent buffer to a direct
+	 * extent list. Be sure to include the inline extent
+	 * bytes in new_size.
+	 */
+	else {
+		new_size += ifp->if_bytes;
+		if (!is_power_of_2(new_size)) {
+			rnew_size = roundup_pow_of_two(new_size);
+		}
+		xfs_iext_inline_to_direct(ifp, rnew_size);
+	}
+	ifp->if_real_bytes = rnew_size;
+	ifp->if_bytes = new_size;
+}
+
+/*
  * Insert new item(s) into the extent records for incore inode
  * fork 'ifp'.  'count' new items are inserted at index 'idx'.
  */
@@ -1727,66 +1799,6 @@ xfs_iext_remove_indirect(
 }
 
 /*
- * Create, destroy, or resize a linear (direct) block of extents.
- */
-void
-xfs_iext_realloc_direct(
-	xfs_ifork_t	*ifp,		/* inode fork pointer */
-	int		new_size)	/* new size of extents */
-{
-	int		rnew_size;	/* real new size of extents */
-
-	rnew_size = new_size;
-
-	ASSERT(!(ifp->if_flags & XFS_IFEXTIREC) ||
-		((new_size >= 0) && (new_size <= XFS_IEXT_BUFSZ) &&
-		 (new_size != ifp->if_real_bytes)));
-
-	/* Free extent records */
-	if (new_size == 0) {
-		xfs_iext_destroy(ifp);
-	}
-	/* Resize direct extent list and zero any new bytes */
-	else if (ifp->if_real_bytes) {
-		/* Check if extents will fit inside the inode */
-		if (new_size <= XFS_INLINE_EXTS * sizeof(xfs_bmbt_rec_t)) {
-			xfs_iext_direct_to_inline(ifp, new_size /
-				(uint)sizeof(xfs_bmbt_rec_t));
-			ifp->if_bytes = new_size;
-			return;
-		}
-		if (!is_power_of_2(new_size)){
-			rnew_size = roundup_pow_of_two(new_size);
-		}
-		if (rnew_size != ifp->if_real_bytes) {
-			ifp->if_u1.if_extents =
-				kmem_realloc(ifp->if_u1.if_extents,
-						rnew_size,
-						ifp->if_real_bytes, KM_NOFS);
-		}
-		if (rnew_size > ifp->if_real_bytes) {
-			memset(&ifp->if_u1.if_extents[ifp->if_bytes /
-				(uint)sizeof(xfs_bmbt_rec_t)], 0,
-				rnew_size - ifp->if_real_bytes);
-		}
-	}
-	/*
-	 * Switch from the inline extent buffer to a direct
-	 * extent list. Be sure to include the inline extent
-	 * bytes in new_size.
-	 */
-	else {
-		new_size += ifp->if_bytes;
-		if (!is_power_of_2(new_size)) {
-			rnew_size = roundup_pow_of_two(new_size);
-		}
-		xfs_iext_inline_to_direct(ifp, rnew_size);
-	}
-	ifp->if_real_bytes = rnew_size;
-	ifp->if_bytes = new_size;
-}
-
-/*
  * Switch from linear (direct) extent records to inline buffer.
  */
 void
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
