Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Jul 2008 18:28:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6T1S22x005745
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 18:28:04 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id LAA10766 for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 11:29:14 +1000
Date: Tue, 29 Jul 2008 11:29:36 +1000
Subject: [REVIEW] Cleanup more dir v1 macros and stuff
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.ue043mr13jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Well, it seems I found a few remnants (cookie crumbs) of dirv1 stuff
in the kernel! This patch removes those remnants!


---
  fs/xfs/xfs_da_btree.h |   20 --------------------
  fs/xfs/xfs_mount.h    |    1 -
  fs/xfs/xfsidbg.c      |    5 ++---
  3 files changed, 2 insertions(+), 24 deletions(-)

Index: 2.6.x-xfs/fs/xfs/xfs_da_btree.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_da_btree.h
+++ 2.6.x-xfs/fs/xfs/xfs_da_btree.h
@@ -72,27 +72,7 @@ typedef struct xfs_da_intnode {
  typedef struct xfs_da_node_hdr xfs_da_node_hdr_t;
  typedef struct xfs_da_node_entry xfs_da_node_entry_t;

-#define XFS_DA_MAXHASH	((xfs_dahash_t)-1) /* largest valid hash value */
-
  #define	XFS_LBSIZE(mp)	(mp)->m_sb.sb_blocksize
-#define	XFS_LBLOG(mp)	(mp)->m_sb.sb_blocklog
-
-#define	XFS_DA_MAKE_BNOENTRY(mp,bno,entry)	\
-	(((bno) << (mp)->m_dircook_elog) | (entry))
-#define	XFS_DA_MAKE_COOKIE(mp,bno,entry,hash)	\
-	(((xfs_off_t)XFS_DA_MAKE_BNOENTRY(mp, bno, entry) << 32) | (hash))
-#define	XFS_DA_COOKIE_HASH(mp,cookie)		((xfs_dahash_t)cookie)
-#define	XFS_DA_COOKIE_BNO(mp,cookie)		\
-	((((xfs_off_t)(cookie) >> 31) == -1LL ? \
-		(xfs_dablk_t)0 : \
-		(xfs_dablk_t)((xfs_off_t)(cookie) >> \
-				((mp)->m_dircook_elog + 32))))
-#define	XFS_DA_COOKIE_ENTRY(mp,cookie)		\
-	((((xfs_off_t)(cookie) >> 31) == -1LL ?	\
-		(xfs_dablk_t)0 : \
-		(xfs_dablk_t)(((xfs_off_t)(cookie) >> 32) & \
-				((1 << (mp)->m_dircook_elog) - 1))))
-

  /*========================================================================
   * Btree searching and modification structure definitions.
Index: 2.6.x-xfs/fs/xfs/xfs_mount.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_mount.h
+++ 2.6.x-xfs/fs/xfs/xfs_mount.h
@@ -267,7 +267,6 @@ typedef struct xfs_mount {
  	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
  	xfs_buftarg_t		*m_logdev_targp;/* ptr to log device */
  	xfs_buftarg_t		*m_rtdev_targp;	/* ptr to rt device */
-	__uint8_t		m_dircook_elog;	/* log d-cookie entry bits */
  	__uint8_t		m_blkbit_log;	/* blocklog + NBBY */
  	__uint8_t		m_blkbb_log;	/* blocklog - BBSHIFT */
  	__uint8_t		m_agno_log;	/* log #ag's */
Index: 2.6.x-xfs/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfsidbg.c
+++ 2.6.x-xfs/fs/xfs/xfsidbg.c
@@ -6330,9 +6330,8 @@ xfsidbg_xmount(xfs_mount_t *mp)
  	kdb_printf("rsumlevels 0x%x rsumsize 0x%x rbmip 0x%p rsumip 0x%p\n",
  		mp->m_rsumlevels, mp->m_rsumsize, mp->m_rbmip, mp->m_rsumip);
  	kdb_printf("rootip 0x%p\n", mp->m_rootip);
-	kdb_printf("dircook_elog %d blkbit_log %d blkbb_log %d agno_log %d\n",
-		mp->m_dircook_elog, mp->m_blkbit_log, mp->m_blkbb_log,
-		mp->m_agno_log);
+	kdb_printf("blkbit_log %d blkbb_log %d agno_log %d\n",
+		mp->m_blkbit_log, mp->m_blkbb_log, mp->m_agno_log);
  	kdb_printf("agino_log %d inode cluster size %d\n",
  		mp->m_agino_log, mp->m_inode_cluster_size);
  	kdb_printf("blockmask 0x%x blockwsize 0x%x blockwmask 0x%x\n",
