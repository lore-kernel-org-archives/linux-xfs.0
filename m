Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Jul 2008 19:24:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6T2Nvgv008221
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 19:23:58 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id MAA12656 for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:25:09 +1000
Date: Tue, 29 Jul 2008 12:25:45 +1000
Subject: [REVIEW] Update kernel headers to compile in userspace (libxfs)
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.ue07o7wt3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

There's been some changes in the headers that fail to compile in
user-land. This patch #ifdef __KERNEL__ these things as none of
them are actually used/required in user-space.

---
  fs/xfs/xfs_ag.h         |    2 ++
  fs/xfs/xfs_dir2_block.h |    2 ++
  fs/xfs/xfs_dir2_leaf.h  |    2 ++
  fs/xfs/xfs_dir2_sf.h    |    2 ++
  fs/xfs/xfs_inode_item.h |    5 ++---
  5 files changed, 10 insertions(+), 3 deletions(-)

Index: 2.6.x-xfs/fs/xfs/xfs_ag.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_ag.h
+++ 2.6.x-xfs/fs/xfs/xfs_ag.h
@@ -196,11 +196,13 @@ typedef struct xfs_perag
  	spinlock_t	pagb_lock;	/* lock for pagb_list */
  #endif
  	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
+#ifdef __KERNEL__
  	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */

  	int		pag_ici_init;	/* incore inode cache initialised */
  	rwlock_t	pag_ici_lock;	/* incore inode lock */
  	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
+#endif
  } xfs_perag_t;

  #define	XFS_AG_MAXLEVELS(mp)		((mp)->m_ag_maxlevels)
Index: 2.6.x-xfs/fs/xfs/xfs_dir2_block.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_dir2_block.h
+++ 2.6.x-xfs/fs/xfs/xfs_dir2_block.h
@@ -80,8 +80,10 @@ xfs_dir2_block_leaf_p(xfs_dir2_block_tai
   * Function declarations.
   */
  extern int xfs_dir2_block_addname(struct xfs_da_args *args);
+#ifdef __KERNEL__
  extern int xfs_dir2_block_getdents(struct xfs_inode *dp, void *dirent,
  				   xfs_off_t *offset, filldir_t filldir);
+#endif
  extern int xfs_dir2_block_lookup(struct xfs_da_args *args);
  extern int xfs_dir2_block_removename(struct xfs_da_args *args);
  extern int xfs_dir2_block_replace(struct xfs_da_args *args);
Index: 2.6.x-xfs/fs/xfs/xfs_dir2_leaf.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_dir2_leaf.h
+++ 2.6.x-xfs/fs/xfs/xfs_dir2_leaf.h
@@ -232,9 +232,11 @@ extern void xfs_dir2_leaf_compact(struct
  extern void xfs_dir2_leaf_compact_x1(struct xfs_dabuf *bp, int *indexp,
  				     int *lowstalep, int *highstalep,
  				     int *lowlogp, int *highlogp);
+#ifdef __KERNEL__
  extern int xfs_dir2_leaf_getdents(struct xfs_inode *dp, void *dirent,
  				  size_t bufsize, xfs_off_t *offset,
  				  filldir_t filldir);
+#endif
  extern int xfs_dir2_leaf_init(struct xfs_da_args *args, xfs_dir2_db_t bno,
  			      struct xfs_dabuf **bpp, int magic);
  extern void xfs_dir2_leaf_log_ents(struct xfs_trans *tp, struct xfs_dabuf  
*bp,
Index: 2.6.x-xfs/fs/xfs/xfs_dir2_sf.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_dir2_sf.h
+++ 2.6.x-xfs/fs/xfs/xfs_dir2_sf.h
@@ -169,8 +169,10 @@ extern int xfs_dir2_block_to_sf(struct x
  				int size, xfs_dir2_sf_hdr_t *sfhp);
  extern int xfs_dir2_sf_addname(struct xfs_da_args *args);
  extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
+#ifdef __KERNEL__
  extern int xfs_dir2_sf_getdents(struct xfs_inode *dp, void *dirent,
  				xfs_off_t *offset, filldir_t filldir);
+#endif
  extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
  extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
  extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
Index: 2.6.x-xfs/fs/xfs/xfs_inode_item.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_inode_item.h
+++ 2.6.x-xfs/fs/xfs/xfs_inode_item.h
@@ -168,6 +168,8 @@ static inline int xfs_ilog_fext(int w)
  	return (w == XFS_DATA_FORK ? XFS_ILOG_DEXT : XFS_ILOG_AEXT);
  }

+#ifdef __KERNEL__
+
  static inline int xfs_inode_clean(xfs_inode_t *ip)
  {
  	return (!ip->i_itemp ||
@@ -175,9 +177,6 @@ static inline int xfs_inode_clean(xfs_in
  	       !ip->i_update_core;
  }

-
-#ifdef __KERNEL__
-
  extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
  extern void xfs_inode_item_destroy(struct xfs_inode *);
  extern void xfs_iflush_done(struct xfs_buf *, xfs_inode_log_item_t *);
