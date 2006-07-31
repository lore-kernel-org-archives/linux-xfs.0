Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Jul 2006 20:54:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6V3rrDW001029
	for <xfs@oss.sgi.com>; Sun, 30 Jul 2006 20:53:53 -0700
Message-ID: <44CD7EBA.2040504@sandeen.net>
Date: Sun, 30 Jul 2006 22:53:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Kill off a bunch of unused macros
References: <44CC28BA.7070005@sandeen.net>
In-Reply-To: <44CC28BA.7070005@sandeen.net>
Content-Type: multipart/mixed;
 boundary="------------090208020808090209090202"
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------090208020808090209090202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Eric Sandeen wrote:
> This kills off 74 unused macros; more could go but I left some in for 
> symmetry, bitfields, etc... *shrug* Nathan, maybe you don't want all 
> these to go, but surely some can.
> 
> I left xfs_mac.h intact but it's really not used at this point either...

whoops, this version has linux-2.4/ in it as well.

Thanks,

-Eric



--------------090208020808090209090202
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="kill-unused-macros"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kill-unused-macros"

nux-2.4/sv.h         |    3 ---
 linux-2.4/xfs_buf.h    |    7 -------
 linux-2.4/xfs_linux.h  |    7 -------
 linux-2.4/xfs_vfs.h    |   10 ----------
 linux-2.4/xfs_vnode.h  |    3 ---
 linux-2.6/sv.h         |    4 ----
 linux-2.6/xfs_buf.h    |   10 ----------
 linux-2.6/xfs_linux.h  |    7 -------
 linux-2.6/xfs_vfs.h    |   10 ----------
 linux-2.6/xfs_vnode.h  |    3 ---
 quota/xfs_qm.h         |    6 ------
 quota/xfs_quota_priv.h |    2 --
 support/radix-tree.h   |   15 ---------------
 xfs_acl.h              |    4 ----
 xfs_bmap_btree.h       |    3 ---
 xfs_cap.h              |   19 -------------------
 xfs_da_btree.h         |    2 --
 xfs_error.h            |    8 --------
 xfs_fs.h               |    4 ----
 xfs_log.h              |    8 --------
 xfs_log_priv.h         |    4 ----
 xfs_quota.h            |    3 ---
 xfs_sb.h               |   22 ----------------------
 23 files changed, 164 deletions(-)

Signed-Off-By: Eric Sandeen <sandeen@sandeen.net>

Index: xfs-linux/linux-2.6/sv.h
===================================================================
--- xfs-linux.orig/linux-2.6/sv.h
+++ xfs-linux/linux-2.6/sv.h
@@ -33,12 +33,8 @@ typedef struct sv_s {
 } sv_t;
 
 #define SV_FIFO		0x0		/* sv_t is FIFO type */
-#define SV_LIFO		0x2		/* sv_t is LIFO type */
-#define SV_PRIO		0x4		/* sv_t is PRIO type */
-#define SV_KEYED	0x6		/* sv_t is KEYED type */
 #define SV_DEFAULT      SV_FIFO
 
-
 static inline void _sv_wait(sv_t *sv, spinlock_t *lock, int state,
 			     unsigned long timeout)
 {
Index: xfs-linux/linux-2.6/xfs_buf.h
===================================================================
--- xfs-linux.orig/linux-2.6/xfs_buf.h
+++ xfs-linux/linux-2.6/xfs_buf.h
@@ -275,7 +275,6 @@ extern void xfs_buf_trace(xfs_buf_t *, c
 #define XFS_BUF_ISDONE(bp)	((bp)->b_flags & XBF_DONE)
 
 #define XFS_BUF_BUSY(bp)	do { } while (0)
-#define XFS_BUF_UNBUSY(bp)	do { } while (0)
 #define XFS_BUF_ISBUSY(bp)	(1)
 
 #define XFS_BUF_ASYNC(bp)	((bp)->b_flags |= XBF_ASYNC)
@@ -284,7 +283,6 @@ extern void xfs_buf_trace(xfs_buf_t *, c
 
 #define XFS_BUF_ORDERED(bp)	((bp)->b_flags |= XBF_ORDERED)
 #define XFS_BUF_UNORDERED(bp)	((bp)->b_flags &= ~XBF_ORDERED)
-#define XFS_BUF_ISORDERED(bp)	((bp)->b_flags & XBF_ORDERED)
 
 #define XFS_BUF_SHUT(bp)	do { } while (0)
 #define XFS_BUF_UNSHUT(bp)	do { } while (0)
@@ -297,10 +295,8 @@ extern void xfs_buf_trace(xfs_buf_t *, c
 
 #define XFS_BUF_WRITE(bp)	((bp)->b_flags |= XBF_WRITE)
 #define XFS_BUF_UNWRITE(bp)	((bp)->b_flags &= ~XBF_WRITE)
-#define XFS_BUF_ISWRITE(bp)	((bp)->b_flags & XBF_WRITE)
 
 #define XFS_BUF_ISUNINITIAL(bp)	(0)
-#define XFS_BUF_UNUNINITIAL(bp)	(0)
 
 #define XFS_BUF_BP_ISMAPPED(bp)	(1)
 
@@ -323,12 +319,9 @@ extern void xfs_buf_trace(xfs_buf_t *, c
 #define XFS_BUF_SET_PTR(bp, val, cnt)	xfs_buf_associate_memory(bp, val, cnt)
 #define XFS_BUF_ADDR(bp)		((bp)->b_bn)
 #define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_bn = (xfs_daddr_t)(bno))
-#define XFS_BUF_OFFSET(bp)		((bp)->b_file_offset)
-#define XFS_BUF_SET_OFFSET(bp, off)	((bp)->b_file_offset = (off))
 #define XFS_BUF_COUNT(bp)		((bp)->b_count_desired)
 #define XFS_BUF_SET_COUNT(bp, cnt)	((bp)->b_count_desired = (cnt))
 #define XFS_BUF_SIZE(bp)		((bp)->b_buffer_length)
-#define XFS_BUF_SET_SIZE(bp, cnt)	((bp)->b_buffer_length = (cnt))
 
 #define XFS_BUF_SET_VTYPE_REF(bp, type, ref)	do { } while (0)
 #define XFS_BUF_SET_VTYPE(bp, type)		do { } while (0)
@@ -338,7 +331,6 @@ extern void xfs_buf_trace(xfs_buf_t *, c
 
 #define XFS_BUF_VALUSEMA(bp)	xfs_buf_lock_value(bp)
 #define XFS_BUF_CPSEMA(bp)	(xfs_buf_cond_lock(bp) == 0)
-#define XFS_BUF_VSEMA(bp)	xfs_buf_unlock(bp)
 #define XFS_BUF_PSEMA(bp,x)	xfs_buf_lock(bp)
 #define XFS_BUF_V_IODONESEMA(bp) up(&bp->b_iodonesema);
 
@@ -394,8 +386,6 @@ static inline int XFS_bwrite(xfs_buf_t *
 	return error;
 }
 
-#define XFS_bdwrite(bp)		xfs_buf_iostart(bp, XBF_DELWRI | XBF_ASYNC)
-
 static inline int xfs_bdwrite(void *mp, xfs_buf_t *bp)
 {
 	bp->b_strat = xfs_bdstrat_cb;
Index: xfs-linux/linux-2.6/xfs_linux.h
===================================================================
--- xfs-linux.orig/linux-2.6/xfs_linux.h
+++ xfs-linux/linux-2.6/xfs_linux.h
@@ -152,11 +152,7 @@ BUFFER_FNS(PrivateStart, unwritten);
 		(current->flags = ((current->flags & ~(f)) | (*(sp) & (f))))
 
 #define NBPP		PAGE_SIZE
-#define DPPSHFT		(PAGE_SHIFT - 9)
 #define NDPP		(1 << (PAGE_SHIFT - 9))
-#define dtop(DD)	(((DD) + NDPP - 1) >> DPPSHFT)
-#define dtopt(DD)	((DD) >> DPPSHFT)
-#define dpoff(DD)	((DD) & (NDPP-1))
 
 #define NBBY		8		/* number of bits per byte */
 #define	NBPC		PAGE_SIZE	/* Number of bytes per click */
@@ -176,8 +172,6 @@ BUFFER_FNS(PrivateStart, unwritten);
 #define	btoct(x)	((__psunsigned_t)(x)>>BPCSHIFT)
 #define	btoc64(x)	(((__uint64_t)(x)+(NBPC-1))>>BPCSHIFT)
 #define	btoct64(x)	((__uint64_t)(x)>>BPCSHIFT)
-#define	io_btoc(x)	(((__psunsigned_t)(x)+(IO_NBPC-1))>>IO_BPCSHIFT)
-#define	io_btoct(x)	((__psunsigned_t)(x)>>IO_BPCSHIFT)
 
 /* off_t bytes to clicks */
 #define offtoc(x)       (((__uint64_t)(x)+(NBPC-1))>>BPCSHIFT)
@@ -190,7 +184,6 @@ BUFFER_FNS(PrivateStart, unwritten);
 #define	ctob(x)		((__psunsigned_t)(x)<<BPCSHIFT)
 #define btoct(x)        ((__psunsigned_t)(x)>>BPCSHIFT)
 #define	ctob64(x)	((__uint64_t)(x)<<BPCSHIFT)
-#define	io_ctob(x)	((__psunsigned_t)(x)<<IO_BPCSHIFT)
 
 /* bytes to clicks */
 #define btoc(x)         (((__psunsigned_t)(x)+(NBPC-1))>>BPCSHIFT)
Index: xfs-linux/linux-2.6/xfs_vfs.h
===================================================================
--- xfs-linux.orig/linux-2.6/xfs_vfs.h
+++ xfs-linux/linux-2.6/xfs_vfs.h
@@ -166,18 +166,8 @@ typedef struct bhv_vfsops {
 #define bhv_next_vfs_mount(b, ma,cr)		vfs_mount(b, ma,cr)
 #define bhv_next_vfs_parseargs(b, o,ma,f)	vfs_parseargs(b, o,ma,f)
 #define bhv_next_vfs_showargs(b, m)		vfs_showargs(b, m)
-#define bhv_next_vfs_unmount(b, f,cr)		vfs_unmount(b, f,cr)
-#define bhv_next_vfs_mntupdate(b, fl,args)	vfs_mntupdate(b, fl, args)
-#define bhv_next_vfs_root(b, vpp)		vfs_root(b, vpp)
 #define bhv_next_vfs_statvfs(b, sp,vp)		vfs_statvfs(b, sp,vp)
 #define bhv_next_vfs_sync(b, flag,cr)		vfs_sync(b, flag,cr)
-#define bhv_next_vfs_vget(b, vpp,fidp)		vfs_vget(b, vpp,fidp)
-#define bhv_next_vfs_dmapiops(b, p)		vfs_dmapiops(b, p)
-#define bhv_next_vfs_quotactl(b, c,id,p)	vfs_quotactl(b, c,id,p)
-#define bhv_next_vfs_get_inode(b, ino,fl)	vfs_get_inode(b, ino,fl)
-#define bhv_next_vfs_init_vnode(b, vp,b2,ul)	vfs_init_vnode(b, vp,b2,ul)
-#define bhv_next_force_shutdown(b, fl,f,l)	vfs_force_shutdown(b, fl,f,l)
-#define bhv_next_vfs_freeze(b)			vfs_freeze(b)
 
 extern int vfs_mount(bhv_desc_t *, struct xfs_mount_args *, struct cred *);
 extern int vfs_parseargs(bhv_desc_t *, char *, struct xfs_mount_args *, int);
Index: xfs-linux/linux-2.6/xfs_vnode.h
===================================================================
--- xfs-linux.orig/linux-2.6/xfs_vnode.h
+++ xfs-linux/linux-2.6/xfs_vnode.h
@@ -294,10 +294,7 @@ typedef struct bhv_vnodeops {
 #define bhv_vop_release(vp)		VOP(vop_release, vp)(VNHEAD(vp))
 #define bhv_vop_fid2(vp,fidp)		VOP(vop_fid2, vp)(VNHEAD(vp),fidp)
 #define bhv_vop_rwlock(vp,i)		VOP(vop_rwlock, vp)(VNHEAD(vp),i)
-#define bhv_vop_rwlock_try(vp,i)	VOP(vop_rwlock, vp)(VNHEAD(vp),i)
 #define bhv_vop_rwunlock(vp,i)		VOP(vop_rwunlock, vp)(VNHEAD(vp),i)
-#define bhv_vop_frlock(vp,c,fl,flags,offset,fr)				\
-		VOP(vop_frlock, vp)(VNHEAD(vp),c,fl,flags,offset,fr)
 #define bhv_vop_reclaim(vp)		VOP(vop_reclaim, vp)(VNHEAD(vp))
 #define bhv_vop_attr_get(vp, name, val, vallenp, fl, cred)		\
 		VOP(vop_attr_get, vp)(VNHEAD(vp),name,val,vallenp,fl,cred)
Index: xfs-linux/quota/xfs_quota_priv.h
===================================================================
--- xfs-linux.orig/quota/xfs_quota_priv.h
+++ xfs-linux/quota/xfs_quota_priv.h
@@ -75,7 +75,6 @@ static inline int XQMISLCKD(struct xfs_d
 
 #define xfs_qm_freelist_lock(qm)	XQMLCK(&((qm)->qm_dqfreelist))
 #define xfs_qm_freelist_unlock(qm)	XQMUNLCK(&((qm)->qm_dqfreelist))
-#define XFS_QM_IS_FREELIST_LOCKED(qm)	XQMISLCKD(&((qm)->qm_dqfreelist))
 
 /*
  * Hash into a bucket in the dquot hash table, based on <mp, id>.
@@ -170,6 +169,5 @@ for ((dqp) = (qlist)->qh_next; (dqp) != 
 #define DQFLAGTO_TYPESTR(d)	(((d)->dq_flags & XFS_DQ_USER) ? "USR" : \
 				 (((d)->dq_flags & XFS_DQ_GROUP) ? "GRP" : \
 				 (((d)->dq_flags & XFS_DQ_PROJ) ? "PRJ":"???")))
-#define DQFLAGTO_DIRTYSTR(d)	(XFS_DQ_IS_DIRTY(d) ? "DIRTY" : "NOTDIRTY")
 
 #endif	/* __XFS_QUOTA_PRIV_H__ */
Index: xfs-linux/support/radix-tree.h
===================================================================
--- xfs-linux.orig/support/radix-tree.h
+++ xfs-linux/support/radix-tree.h
@@ -24,20 +24,6 @@ struct radix_tree_root {
 	struct radix_tree_node	*rnode;
 };
 
-#define RADIX_TREE_INIT(mask)	{					\
-	.height = 0,							\
-	.rnode = NULL,							\
-}
-
-#define RADIX_TREE(name, mask) \
-	struct radix_tree_root name = RADIX_TREE_INIT(mask)
-
-#define INIT_RADIX_TREE(root, mask)					\
-do {									\
-	(root)->height = 0;						\
-	(root)->rnode = NULL;						\
-} while (0)
-
 #define RADIX_TREE_MAX_TAGS 2
 
 int radix_tree_insert(struct radix_tree_root *, unsigned long, void *);
@@ -47,7 +33,6 @@ void *radix_tree_delete(struct radix_tre
 unsigned int
 radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
 			unsigned long first_index, unsigned int max_items);
-#define radix_tree_preload(gfp_mask)	do { } while (0)
 void radix_tree_init(void);
 void *radix_tree_tag_set(struct radix_tree_root *root,
 			unsigned long index, unsigned int tag);
Index: xfs-linux/xfs_acl.h
===================================================================
--- xfs-linux.orig/xfs_acl.h
+++ xfs-linux/xfs_acl.h
@@ -72,9 +72,7 @@ extern int xfs_acl_vremove(struct bhv_vn
 #define _ACL_PERM_INVALID(perm)	((perm) & ~(ACL_READ|ACL_WRITE|ACL_EXECUTE))
 
 #define _ACL_INHERIT(c,v,d)	(xfs_acl_inherit(c,v,d))
-#define _ACL_GET_ACCESS(pv,pa)	(xfs_acl_vtoacl(pv,pa,NULL) == 0)
 #define _ACL_GET_DEFAULT(pv,pd)	(xfs_acl_vtoacl(pv,NULL,pd) == 0)
-#define _ACL_ACCESS_EXISTS	xfs_acl_vhasacl_access
 #define _ACL_DEFAULT_EXISTS	xfs_acl_vhasacl_default
 #define _ACL_XFS_IACCESS(i,m,c) (XFS_IFORK_Q(i) ? xfs_acl_iaccess(i,m,c) : -1)
 
@@ -92,9 +90,7 @@ extern int xfs_acl_vremove(struct bhv_vn
 #define _ACL_ALLOC(a)		(1)	/* successfully allocate nothing */
 #define _ACL_FREE(a)		((void)0)
 #define _ACL_INHERIT(c,v,d)	(0)
-#define _ACL_GET_ACCESS(pv,pa)	(0)
 #define _ACL_GET_DEFAULT(pv,pd)	(0)
-#define _ACL_ACCESS_EXISTS	(NULL)
 #define _ACL_DEFAULT_EXISTS	(NULL)
 #define _ACL_XFS_IACCESS(i,m,c) (-1)
 #endif
Index: xfs-linux/xfs_bmap_btree.h
===================================================================
--- xfs-linux.orig/xfs_bmap_btree.h
+++ xfs-linux/xfs_bmap_btree.h
@@ -74,9 +74,6 @@ typedef struct xfs_bmdr_block {
 
 #endif /* XFS_NATIVE_HOST */
 
-
-#define BMBT_USE_64	1
-
 typedef struct xfs_bmbt_rec_32
 {
 	__uint32_t		l0, l1, l2, l3;
Index: xfs-linux/xfs_cap.h
===================================================================
--- xfs-linux.orig/xfs_cap.h
+++ xfs-linux/xfs_cap.h
@@ -29,12 +29,6 @@ typedef struct xfs_cap_set {
 	xfs_cap_value_t	cap_inheritable;/* pass through exec */
 } xfs_cap_set_t;
 
-/* On-disk XFS extended attribute names */
-#define SGI_CAP_FILE	"SGI_CAP_FILE"
-#define SGI_CAP_FILE_SIZE	(sizeof(SGI_CAP_FILE)-1)
-#define SGI_CAP_LINUX	"SGI_CAP_LINUX"
-#define SGI_CAP_LINUX_SIZE	(sizeof(SGI_CAP_LINUX)-1)
-
 /*
  * For Linux, we take the bitfields directly from capability.h
  * and no longer attempt to keep this attribute ondisk compatible
@@ -50,19 +44,6 @@ typedef struct xfs_cap_set {
 #include <linux/posix_cap_xattr.h>
 
 struct bhv_vnode;
-
-extern int xfs_cap_vhascap(struct bhv_vnode *);
-extern int xfs_cap_vset(struct bhv_vnode *, void *, size_t);
-extern int xfs_cap_vget(struct bhv_vnode *, void *, size_t);
-extern int xfs_cap_vremove(struct bhv_vnode *);
-
-#define _CAP_EXISTS		xfs_cap_vhascap
-
-#else
-#define xfs_cap_vset(v,p,sz)	(-EOPNOTSUPP)
-#define xfs_cap_vget(v,p,sz)	(-EOPNOTSUPP)
-#define xfs_cap_vremove(v)	(-EOPNOTSUPP)
-#define _CAP_EXISTS		(NULL)
 #endif
 
 #endif	/* __KERNEL__ */
Index: xfs-linux/xfs_da_btree.h
===================================================================
--- xfs-linux.orig/xfs_da_btree.h
+++ xfs-linux/xfs_da_btree.h
@@ -72,8 +72,6 @@ typedef struct xfs_da_intnode {
 typedef struct xfs_da_node_hdr xfs_da_node_hdr_t;
 typedef struct xfs_da_node_entry xfs_da_node_entry_t;
 
-#define XFS_DA_MAXHASH	((xfs_dahash_t)-1) /* largest valid hash value */
-
 #define	XFS_LBSIZE(mp)	(mp)->m_sb.sb_blocksize
 #define	XFS_LBLOG(mp)	(mp)->m_sb.sb_blocklog
 
Index: xfs-linux/xfs_error.h
===================================================================
--- xfs-linux.orig/xfs_error.h
+++ xfs-linux/xfs_error.h
@@ -18,14 +18,6 @@
 #ifndef	__XFS_ERROR_H__
 #define	__XFS_ERROR_H__
 
-#define XFS_ERECOVER	1	/* Failure to recover log */
-#define XFS_ELOGSTAT	2	/* Failure to stat log in user space */
-#define XFS_ENOLOGSPACE	3	/* Reservation too large */
-#define XFS_ENOTSUP	4	/* Operation not supported */
-#define	XFS_ENOLSN	5	/* Can't find the lsn you asked for */
-#define XFS_ENOTFOUND	6
-#define XFS_ENOTXFS	7	/* Not XFS filesystem */
-
 #ifdef DEBUG
 #define	XFS_ERROR_NTRAP	10
 extern int	xfs_etrap[XFS_ERROR_NTRAP];
Index: xfs-linux/xfs_fs.h
===================================================================
--- xfs-linux.orig/xfs_fs.h
+++ xfs-linux/xfs_fs.h
@@ -22,8 +22,6 @@
  * SGI's XFS filesystem's major stuff (constants, structures)
  */
 
-#define XFS_NAME	"xfs"
-
 /*
  * Direct I/O attribute record used with XFS_IOC_DIOINFO
  * d_miniosz is the min xfer size, xfer size multiple and file seek offset
@@ -428,8 +426,6 @@ typedef struct xfs_handle {
 
 #define XFS_HANDLE_CMP(h1, h2)	memcmp(h1, h2, sizeof(xfs_handle_t))
 
-#define FSHSIZE		sizeof(fsid_t)
-
 /* 
  * Flags for going down operation
  */
Index: xfs-linux/xfs_sb.h
===================================================================
--- xfs-linux.orig/xfs_sb.h
+++ xfs-linux/xfs_sb.h
@@ -60,10 +60,6 @@ struct xfs_mount;
 	 XFS_SB_VERSION_LOGV2BIT | \
 	 XFS_SB_VERSION_SECTORBIT | \
 	 XFS_SB_VERSION_MOREBITSBIT)
-#define	XFS_SB_VERSION_OKSASHBITS	\
-	(XFS_SB_VERSION_NUMBITS | \
-	 XFS_SB_VERSION_REALFBITS | \
-	 XFS_SB_VERSION_OKSASHFBITS)
 #define	XFS_SB_VERSION_OKREALBITS	\
 	(XFS_SB_VERSION_NUMBITS | \
 	 XFS_SB_VERSION_OKREALFBITS | \
@@ -81,9 +77,6 @@ struct xfs_mount;
 #define XFS_SB_VERSION2_RESERVED2BIT	0x00000002
 #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
 #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
-#define XFS_SB_VERSION2_SASHFBITS	0xff000000	/* Mask: features that
-							   require changing
-							   PROM and SASH */
 
 #define	XFS_SB_VERSION2_OKREALFBITS	\
 	(XFS_SB_VERSION2_ATTR2BIT)
@@ -237,12 +230,6 @@ static inline int XFS_SB_GOOD_VERSION(xf
 }
 #endif /* __KERNEL__ */
 
-#define	XFS_SB_GOOD_SASH_VERSION(sbp)	\
-	((((sbp)->sb_versionnum >= XFS_SB_VERSION_1) && \
-	  ((sbp)->sb_versionnum <= XFS_SB_VERSION_3)) || \
-	 ((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-	  !((sbp)->sb_versionnum & ~XFS_SB_VERSION_OKSASHBITS)))
-
 static inline unsigned XFS_SB_VERSION_TONEW(unsigned v)
 {
 	return ((((v) == XFS_SB_VERSION_1) ? \
@@ -436,15 +423,6 @@ static inline void XFS_SB_VERSION_ADDATT
  * File system sector to basic block conversions.
  */
 #define XFS_FSS_TO_BB(mp,sec)	((sec) << (mp)->m_sectbb_log)
-#define XFS_BB_TO_FSS(mp,bb)	\
-	(((bb) + (XFS_FSS_TO_BB(mp,1) - 1)) >> (mp)->m_sectbb_log)
-#define XFS_BB_TO_FSST(mp,bb)	((bb) >> (mp)->m_sectbb_log)
-
-/*
- * File system sector to byte conversions.
- */
-#define XFS_FSS_TO_B(mp,sectno)	((xfs_fsize_t)(sectno) << (mp)->m_sb.sb_sectlog)
-#define XFS_B_TO_FSST(mp,b)	(((__uint64_t)(b)) >> (mp)->m_sb.sb_sectlog)
 
 /*
  * File system block to basic block conversions.
Index: xfs-linux/quota/xfs_qm.h
===================================================================
--- xfs-linux.orig/quota/xfs_qm.h
+++ xfs-linux/quota/xfs_qm.h
@@ -56,12 +56,6 @@ extern kmem_zone_t	*qm_dqtrxzone;
 #define XFS_QM_HASHSIZE_HIGH		((NBPP * 4) / sizeof(xfs_dqhash_t))
 
 /*
- * We output a cmn_err when quotachecking a quota file with more than
- * this many fsbs.
- */
-#define XFS_QM_BIG_QCHECK_NBLKS		500
-
-/*
  * This defines the unit of allocation of dquots.
  * Currently, it is just one file system block, and a 4K blk contains 30
  * (136 * 30 = 4080) dquots. It's probably not worth trying to make
Index: xfs-linux/xfs_log.h
===================================================================
--- xfs-linux.orig/xfs_log.h
+++ xfs-linux/xfs_log.h
@@ -48,16 +48,10 @@ static inline xfs_lsn_t	_lsn_cmp(xfs_lsn
  */
 
 /*
- * Flags to xfs_log_mount
- */
-#define XFS_LOG_RECOVER		0x1
-
-/*
  * Flags to xfs_log_done()
  */
 #define XFS_LOG_REL_PERM_RESERV	0x1
 
-
 /*
  * Flags to xfs_log_reserve()
  *
@@ -70,8 +64,6 @@ static inline xfs_lsn_t	_lsn_cmp(xfs_lsn
 #define XFS_LOG_SLEEP		0x0
 #define XFS_LOG_NOSLEEP		0x1
 #define XFS_LOG_PERM_RESERV	0x2
-#define XFS_LOG_RESV_ALL	(XFS_LOG_NOSLEEP|XFS_LOG_PERM_RESERV)
-
 
 /*
  * Flags to xfs_log_force()
Index: xfs-linux/xfs_log_priv.h
===================================================================
--- xfs-linux.orig/xfs_log_priv.h
+++ xfs-linux/xfs_log_priv.h
@@ -32,7 +32,6 @@ struct xfs_mount;
 #define XLOG_MIN_ICLOGS		2
 #define XLOG_MED_ICLOGS		4
 #define XLOG_MAX_ICLOGS		8
-#define XLOG_CALLBACK_SIZE	10
 #define XLOG_HEADER_MAGIC_NUM	0xFEEDbabe	/* Invalid cycle number */
 #define XLOG_VERSION_1		1
 #define XLOG_VERSION_2		2		/* Large IClogs, Log sunit */
@@ -149,9 +148,6 @@ struct xfs_mount;
 #define XLOG_WAS_CONT_TRANS	0x08	/* Cont this trans into new region */
 #define XLOG_END_TRANS		0x10	/* End a continued transaction */
 #define XLOG_UNMOUNT_TRANS	0x20	/* Unmount a filesystem transaction */
-#define XLOG_SKIP_TRANS		(XLOG_COMMIT_TRANS | XLOG_CONTINUE_TRANS | \
-				 XLOG_WAS_CONT_TRANS | XLOG_END_TRANS | \
-				 XLOG_UNMOUNT_TRANS)
 
 #ifdef __KERNEL__
 /*
Index: xfs-linux/xfs_quota.h
===================================================================
--- xfs-linux.orig/xfs_quota.h
+++ xfs-linux/xfs_quota.h
@@ -281,9 +281,6 @@ typedef struct xfs_qoff_logformat {
 				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
 				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD|\
 				 XFS_GQUOTA_ACCT)
-#define XFS_MOUNT_QUOTA_MASK	(XFS_MOUNT_QUOTA_ALL | XFS_UQUOTA_ACTIVE | \
-				 XFS_GQUOTA_ACTIVE | XFS_PQUOTA_ACTIVE)
-
 
 /*
  * The structure kept inside the xfs_trans_t keep track of dquot changes
Index: xfs-linux/linux-2.4/sv.h
===================================================================
--- xfs-linux.orig/linux-2.4/sv.h
+++ xfs-linux/linux-2.4/sv.h
@@ -33,9 +33,6 @@ typedef struct sv_s {
 } sv_t;
 
 #define SV_FIFO		0x0		/* sv_t is FIFO type */
-#define SV_LIFO		0x2		/* sv_t is LIFO type */
-#define SV_PRIO		0x4		/* sv_t is PRIO type */
-#define SV_KEYED	0x6		/* sv_t is KEYED type */
 #define SV_DEFAULT      SV_FIFO
 
 
Index: xfs-linux/linux-2.4/xfs_buf.h
===================================================================
--- xfs-linux.orig/linux-2.4/xfs_buf.h
+++ xfs-linux/linux-2.4/xfs_buf.h
@@ -359,7 +359,6 @@ BUFFER_FNS(Delay, delay)
 #define XFS_BUF_ISDONE(bp)	(!(XBF_NOT_DONE(bp)))
 
 #define XFS_BUF_BUSY(bp)	((bp)->b_flags |= XBF_FORCEIO)
-#define XFS_BUF_UNBUSY(bp)	((bp)->b_flags &= ~XBF_FORCEIO)
 #define XFS_BUF_ISBUSY(bp)	(1)
 
 #define XFS_BUF_ASYNC(bp)	((bp)->b_flags |= XBF_ASYNC)
@@ -368,7 +367,6 @@ BUFFER_FNS(Delay, delay)
 
 #define XFS_BUF_ORDERED(bp)	((bp)->b_flags |= XBF_ORDERED)
 #define XFS_BUF_UNORDERED(bp)	((bp)->b_flags &= ~XBF_ORDERED)
-#define XFS_BUF_ISORDERED(bp)	((bp)->b_flags & XBF_ORDERED)
 
 #define XFS_BUF_SHUT(bp)	do { } while (0)
 #define XFS_BUF_UNSHUT(bp)	do { } while (0)
@@ -381,10 +379,8 @@ BUFFER_FNS(Delay, delay)
 
 #define XFS_BUF_WRITE(bp)	((bp)->b_flags |= XBF_WRITE)
 #define XFS_BUF_UNWRITE(bp)	((bp)->b_flags &= ~XBF_WRITE)
-#define XFS_BUF_ISWRITE(bp)	((bp)->b_flags & XBF_WRITE)
 
 #define XFS_BUF_ISUNINITIAL(bp)	(0)
-#define XFS_BUF_UNUNINITIAL(bp)	(0)
 
 #define XFS_BUF_BP_ISMAPPED(bp)	(1)
 
@@ -425,7 +421,6 @@ BUFFER_FNS(Delay, delay)
 
 #define XFS_BUF_VALUSEMA(bp)	xfs_buf_lock_value(bp)
 #define XFS_BUF_CPSEMA(bp)	(xfs_buf_cond_lock(bp) == 0)
-#define XFS_BUF_VSEMA(bp)	xfs_buf_unlock(bp)
 #define XFS_BUF_PSEMA(bp,x)	xfs_buf_lock(bp)
 #define XFS_BUF_V_IODONESEMA(bp) up(&bp->b_iodonesema);
 
@@ -482,8 +477,6 @@ static inline int XFS_bwrite(xfs_buf_t *
 	return error;
 }
 
-#define XFS_bdwrite(bp)		xfs_buf_iostart(bp, XBF_DELWRI | XBF_ASYNC)
-
 static inline int xfs_bdwrite(void *mp, xfs_buf_t *bp)
 {
 	bp->b_strat = xfs_bdstrat_cb;
Index: xfs-linux/linux-2.4/xfs_linux.h
===================================================================
--- xfs-linux.orig/linux-2.4/xfs_linux.h
+++ xfs-linux/linux-2.4/xfs_linux.h
@@ -182,11 +182,7 @@ BUFFER_FNS(Unwritten, unwritten)
 		(current->flags = ((current->flags & ~(f)) | (*(sp) & (f))))
 
 #define NBPP		PAGE_SIZE
-#define DPPSHFT		(PAGE_SHIFT - 9)
 #define NDPP		(1 << (PAGE_SHIFT - 9))
-#define dtop(DD)	(((DD) + NDPP - 1) >> DPPSHFT)
-#define dtopt(DD)	((DD) >> DPPSHFT)
-#define dpoff(DD)	((DD) & (NDPP-1))
 
 #define NBBY		8		/* number of bits per byte */
 #define	NBPC		PAGE_SIZE	/* Number of bytes per click */
@@ -206,8 +202,6 @@ BUFFER_FNS(Unwritten, unwritten)
 #define	btoct(x)	((__psunsigned_t)(x)>>BPCSHIFT)
 #define	btoc64(x)	(((__uint64_t)(x)+(NBPC-1))>>BPCSHIFT)
 #define	btoct64(x)	((__uint64_t)(x)>>BPCSHIFT)
-#define	io_btoc(x)	(((__psunsigned_t)(x)+(IO_NBPC-1))>>IO_BPCSHIFT)
-#define	io_btoct(x)	((__psunsigned_t)(x)>>IO_BPCSHIFT)
 
 /* off_t bytes to clicks */
 #define offtoc(x)       (((__uint64_t)(x)+(NBPC-1))>>BPCSHIFT)
@@ -220,7 +214,6 @@ BUFFER_FNS(Unwritten, unwritten)
 #define	ctob(x)		((__psunsigned_t)(x)<<BPCSHIFT)
 #define btoct(x)        ((__psunsigned_t)(x)>>BPCSHIFT)
 #define	ctob64(x)	((__uint64_t)(x)<<BPCSHIFT)
-#define	io_ctob(x)	((__psunsigned_t)(x)<<IO_BPCSHIFT)
 
 /* bytes to clicks */
 #define btoc(x)         (((__psunsigned_t)(x)+(NBPC-1))>>BPCSHIFT)
Index: xfs-linux/linux-2.4/xfs_vfs.h
===================================================================
--- xfs-linux.orig/linux-2.4/xfs_vfs.h
+++ xfs-linux/linux-2.4/xfs_vfs.h
@@ -171,18 +171,8 @@ typedef struct bhv_vfsops {
 #define bhv_next_vfs_mount(b, ma,cr)		vfs_mount(b, ma,cr)
 #define bhv_next_vfs_parseargs(b, o,ma,f)	vfs_parseargs(b, o,ma,f)
 #define bhv_next_vfs_showargs(b, m)		vfs_showargs(b, m)
-#define bhv_next_vfs_unmount(b, f,cr)		vfs_unmount(b, f,cr)
-#define bhv_next_vfs_mntupdate(b, fl,args)	vfs_mntupdate(b, fl, args)
-#define bhv_next_vfs_root(b, vpp)		vfs_root(b, vpp)
 #define bhv_next_vfs_statvfs(b, sp,vp)		vfs_statvfs(b, sp,vp)
 #define bhv_next_vfs_sync(b, flag,cr)		vfs_sync(b, flag,cr)
-#define bhv_next_vfs_vget(b, vpp,fidp)		vfs_vget(b, vpp,fidp)
-#define bhv_next_vfs_dmapiops(b, p)		vfs_dmapiops(b, p)
-#define bhv_next_vfs_quotactl(b, c,id,p)	vfs_quotactl(b, c,id,p)
-#define bhv_next_vfs_get_inode(b, ino,fl)	vfs_get_inode(b, ino,fl)
-#define bhv_next_vfs_init_vnode(b, vp,b2,ul)	vfs_init_vnode(b, vp,b2,ul)
-#define bhv_next_force_shutdown(b, fl,f,l)	vfs_force_shutdown(b, fl,f,l)
-#define bhv_next_vfs_freeze(b)			vfs_freeze(b)
 
 extern int vfs_mount(bhv_desc_t *, struct xfs_mount_args *, struct cred *);
 extern int vfs_parseargs(bhv_desc_t *, char *, struct xfs_mount_args *, int);
Index: xfs-linux/linux-2.4/xfs_vnode.h
===================================================================
--- xfs-linux.orig/linux-2.4/xfs_vnode.h
+++ xfs-linux/linux-2.4/xfs_vnode.h
@@ -271,10 +271,7 @@ typedef struct bhv_vnodeops {
 #define bhv_vop_release(vp)		VOP(vop_release, vp)(VNHEAD(vp))
 #define bhv_vop_fid2(vp,fidp)		VOP(vop_fid2, vp)(VNHEAD(vp),fidp)
 #define bhv_vop_rwlock(vp,i)		VOP(vop_rwlock, vp)(VNHEAD(vp),i)
-#define bhv_vop_rwlock_try(vp,i)	VOP(vop_rwlock, vp)(VNHEAD(vp),i)
 #define bhv_vop_rwunlock(vp,i)		VOP(vop_rwunlock, vp)(VNHEAD(vp),i)
-#define bhv_vop_frlock(vp,c,fl,flags,offset,fr)				\
-		VOP(vop_frlock, vp)(VNHEAD(vp),c,fl,flags,offset,fr)
 #define bhv_vop_reclaim(vp)		VOP(vop_reclaim, vp)(VNHEAD(vp))
 #define bhv_vop_attr_get(vp, name,val,vallenp,fl,cred)			\
 		VOP(vop_attr_get, vp)(VNHEAD(vp),name,val,vallenp,fl,cred)

--------------090208020808090209090202--
