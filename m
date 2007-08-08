Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Aug 2007 16:40:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l78Nekbm025082
	for <xfs@oss.sgi.com>; Wed, 8 Aug 2007 16:40:49 -0700
Date: Thu, 9 Aug 2007 09:40:44 +1000
From: David Chinner <dgc@sgi.com>
Subject: Review: Factor some common freelist checks
Message-ID: <20070808234043.GT12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Suggested by Tim - don't duplicate the code used to check
the longest available extent on the freelist.

[we've got to clean up this header include mess.]

Signed-off-by: Dave Chinner <dgc@sgi.com>

---
 fs/xfs/dmapi/xfs_dm.c          |    2 +-
 fs/xfs/dmapi/xfs_dm_bhv.c      |    2 +-
 fs/xfs/dmapi/xfs_dm_fsops.c    |    2 +-
 fs/xfs/linux-2.6/xfs_ioctl.c   |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c    |    2 +-
 fs/xfs/linux-2.6/xfs_ksyms.c   |    2 +-
 fs/xfs/linux-2.6/xfs_lrw.c     |    2 +-
 fs/xfs/linux-2.6/xfs_super.c   |    2 +-
 fs/xfs/linux-2.6/xfs_vfs.c     |    2 +-
 fs/xfs/quota/xfs_dquot.c       |    2 +-
 fs/xfs/quota/xfs_dquot_item.c  |    2 +-
 fs/xfs/quota/xfs_qm.c          |    2 +-
 fs/xfs/quota/xfs_qm_bhv.c      |    2 +-
 fs/xfs/quota/xfs_qm_ksyms.c    |    2 +-
 fs/xfs/quota/xfs_qm_stats.c    |    2 +-
 fs/xfs/quota/xfs_qm_syscalls.c |    2 +-
 fs/xfs/quota/xfs_trans_dquot.c |    2 +-
 fs/xfs/xfs_alloc.c             |    7 ++-----
 fs/xfs/xfs_alloc.h             |   19 +++++++++++++++++--
 fs/xfs/xfs_bmap.c              |   12 ++----------
 fs/xfs/xfs_filestream.c        |    9 ++-------
 fs/xfs/xfs_iomap.c             |    2 +-
 22 files changed, 41 insertions(+), 42 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_alloc.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_alloc.c	2007-06-25 13:56:20.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_alloc.c	2007-06-25 14:06:05.123181552 +1000
@@ -1858,15 +1858,12 @@ xfs_alloc_fix_freelist(
 	}
 
 	if (!(flags & XFS_ALLOC_FLAG_FREEING)) {
-		need = XFS_MIN_FREELIST_PAG(pag, mp);
-		delta = need > pag->pagf_flcount ? need - pag->pagf_flcount : 0;
 		/*
 		 * If it looks like there isn't a long enough extent, or enough
 		 * total blocks, reject it.
 		 */
-		longest = (pag->pagf_longest > delta) ?
-			(pag->pagf_longest - delta) :
-			(pag->pagf_flcount > 0 || pag->pagf_longest > 0);
+		need = XFS_MIN_FREELIST_PAG(pag, mp);
+		xfs_alloc_min_freelist(mp, pag, &longest);
 		if ((args->minlen + args->alignment + args->minalignslop - 1) >
 				longest ||
 		    ((int)(pag->pagf_freeblks + pag->pagf_flcount -
Index: 2.6.x-xfs-new/fs/xfs/xfs_alloc.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_alloc.h	2007-05-22 19:04:51.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_alloc.h	2007-06-25 14:14:13.627226544 +1000
@@ -19,8 +19,6 @@
 #define	__XFS_ALLOC_H__
 
 struct xfs_buf;
-struct xfs_mount;
-struct xfs_perag;
 struct xfs_trans;
 
 /*
@@ -207,6 +205,23 @@ xfs_alloc_clear_busy(xfs_trans_t *tp,
 		xfs_agnumber_t ag,
 		int idx);
 
+/*
+ * Determine the longest free extent available in the AG supplied
+ */
+STATIC_INLINE void
+xfs_alloc_min_freelist(
+	xfs_mount_t	*mp,
+	xfs_perag_t	*pag,
+	xfs_extlen_t	*longest)
+{
+	xfs_extlen_t	need, delta;
+
+	need = XFS_MIN_FREELIST_PAG(pag, mp);
+	delta = need > pag->pagf_flcount ? need - pag->pagf_flcount : 0;
+	*longest = (pag->pagf_longest > delta) ?
+		  (pag->pagf_longest - delta) :
+		  (pag->pagf_flcount > 0 || pag->pagf_longest > 0);
+}
 
 #endif	/* __KERNEL__ */
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_bmap.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bmap.c	2007-06-25 13:56:11.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_bmap.c	2007-06-25 14:11:19.905965882 +1000
@@ -2703,9 +2703,6 @@ xfs_bmap_btalloc(
 	xfs_agnumber_t	startag;
 	xfs_alloc_arg_t	args;
 	xfs_extlen_t	blen;
-	xfs_extlen_t	delta;
-	xfs_extlen_t	longest;
-	xfs_extlen_t	need;
 	xfs_extlen_t	nextminlen = 0;
 	xfs_perag_t	*pag;
 	int		nullfb;		/* true if ap->firstblock isn't set */
@@ -2787,13 +2784,8 @@ xfs_bmap_btalloc(
 			 * See xfs_alloc_fix_freelist...
 			 */
 			if (pag->pagf_init) {
-				need = XFS_MIN_FREELIST_PAG(pag, mp);
-				delta = need > pag->pagf_flcount ?
-					need - pag->pagf_flcount : 0;
-				longest = (pag->pagf_longest > delta) ?
-					(pag->pagf_longest - delta) :
-					(pag->pagf_flcount > 0 ||
-					 pag->pagf_longest > 0);
+				xfs_extlen_t	longest;
+				xfs_alloc_min_freelist(mp, pag, &longest);
 				if (blen < longest)
 					blen = longest;
 			} else
Index: 2.6.x-xfs-new/fs/xfs/xfs_filestream.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_filestream.c	2007-06-22 18:07:15.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_filestream.c	2007-06-25 14:11:11.355085273 +1000
@@ -140,7 +140,7 @@ _xfs_filestream_pick_ag(
 	xfs_extlen_t	minlen)
 {
 	int		err, trylock, nscan;
-	xfs_extlen_t	delta, longest, need, free, minfree, maxfree = 0;
+	xfs_extlen_t	longest, free, minfree, maxfree = 0;
 	xfs_agnumber_t	ag, max_ag = NULLAGNUMBER;
 	struct xfs_perag *pag;
 
@@ -186,12 +186,7 @@ _xfs_filestream_pick_ag(
 			goto next_ag;
 		}
 
-		need = XFS_MIN_FREELIST_PAG(pag, mp);
-		delta = need > pag->pagf_flcount ? need - pag->pagf_flcount : 0;
-		longest = (pag->pagf_longest > delta) ?
-		          (pag->pagf_longest - delta) :
-		          (pag->pagf_flcount > 0 || pag->pagf_longest > 0);
-
+		xfs_alloc_min_freelist(mp, pag, &longest);
 		if (((minlen && longest >= minlen) ||
 		     (!minlen && pag->pagf_freeblks >= minfree)) &&
 		    (!pag->pagf_metadata || !(flags & XFS_PICK_USERDATA) ||
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2007-06-20 17:59:36.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ioctl.c	2007-06-25 14:13:21.298075718 +1000
@@ -24,9 +24,9 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_alloc.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
+#include "xfs_alloc.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-05-29 16:18:03.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_iops.c	2007-06-25 14:13:02.976473863 +1000
@@ -24,10 +24,10 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_alloc.h"
 #include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
+#include "xfs_alloc.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_lrw.c	2007-06-20 17:53:36.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_lrw.c	2007-06-25 14:14:30.457023840 +1000
@@ -24,10 +24,10 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_alloc.h"
 #include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
+#include "xfs_alloc.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.c	2007-06-20 17:53:35.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c	2007-06-25 14:14:43.087370791 +1000
@@ -25,10 +25,10 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_alloc.h"
 #include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
+#include "xfs_alloc.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vfs.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_vfs.c	2007-01-16 10:54:16.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vfs.c	2007-06-25 14:14:56.941557595 +1000
@@ -25,9 +25,9 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_imap.h"
-#include "xfs_alloc.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
+#include "xfs_alloc.h"
 #include "xfs_quota.h"
 
 int
Index: 2.6.x-xfs-new/fs/xfs/xfs_iomap.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iomap.c	2007-06-08 21:36:26.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_iomap.c	2007-06-25 14:12:09.347493741 +1000
@@ -24,10 +24,10 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_alloc.h"
 #include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
+#include "xfs_alloc.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
Index: 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/dmapi/xfs_dm.c	2007-06-08 21:36:26.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm.c	2007-06-25 14:19:43.936003898 +1000
@@ -26,9 +26,9 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_alloc.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
+#include "xfs_alloc.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm_bhv.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/dmapi/xfs_dm_bhv.c	2007-01-16 10:54:14.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm_bhv.c	2007-06-25 14:16:45.923295350 +1000
@@ -26,9 +26,9 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_alloc.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
+#include "xfs_alloc.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
Index: 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm_fsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/dmapi/xfs_dm_fsops.c	2007-01-16 10:54:14.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm_fsops.c	2007-06-25 14:18:12.523963285 +1000
@@ -26,9 +26,9 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_alloc.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
+#include "xfs_alloc.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-06-25 13:56:20.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ksyms.c	2007-06-25 14:15:49.646659958 +1000
@@ -27,10 +27,10 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_alloc.h"
 #include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
+#include "xfs_alloc.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: 2.6.x-xfs-new/fs/xfs/quota/xfs_dquot.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/quota/xfs_dquot.c	2007-06-25 13:56:20.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/quota/xfs_dquot.c	2007-06-25 14:19:04.513160782 +1000
@@ -24,10 +24,10 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_alloc.h"
 #include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
+#include "xfs_alloc.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
Index: 2.6.x-xfs-new/fs/xfs/quota/xfs_dquot_item.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/quota/xfs_dquot_item.c	2007-06-25 13:56:20.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/quota/xfs_dquot_item.c	2007-06-25 14:19:21.906884992 +1000
@@ -24,10 +24,10 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_alloc.h"
 #include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
+#include "xfs_alloc.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
Index: 2.6.x-xfs-new/fs/xfs/quota/xfs_qm.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/quota/xfs_qm.c	2007-06-25 13:56:20.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/quota/xfs_qm.c	2007-06-25 14:21:29.450325544 +1000
@@ -25,10 +25,10 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_alloc.h"
 #include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
+#include "xfs_alloc.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
Index: 2.6.x-xfs-new/fs/xfs/quota/xfs_qm_bhv.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/quota/xfs_qm_bhv.c	2007-02-07 13:24:32.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/quota/xfs_qm_bhv.c	2007-06-25 14:20:21.775098823 +1000
@@ -25,10 +25,10 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_alloc.h"
 #include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
+#include "xfs_alloc.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
Index: 2.6.x-xfs-new/fs/xfs/quota/xfs_qm_ksyms.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/quota/xfs_qm_ksyms.c	2007-01-16 10:54:16.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/quota/xfs_qm_ksyms.c	2007-06-25 14:21:01.018011537 +1000
@@ -24,10 +24,10 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_alloc.h"
 #include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
+#include "xfs_alloc.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
Index: 2.6.x-xfs-new/fs/xfs/quota/xfs_qm_stats.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/quota/xfs_qm_stats.c	2007-02-07 13:24:32.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/quota/xfs_qm_stats.c	2007-06-25 14:21:14.844219110 +1000
@@ -24,10 +24,10 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_alloc.h"
 #include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
+#include "xfs_alloc.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
Index: 2.6.x-xfs-new/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/quota/xfs_qm_syscalls.c	2007-03-29 19:03:30.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/quota/xfs_qm_syscalls.c	2007-06-25 14:18:28.637854830 +1000
@@ -27,10 +27,10 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_alloc.h"
 #include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
+#include "xfs_alloc.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
Index: 2.6.x-xfs-new/fs/xfs/quota/xfs_trans_dquot.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/quota/xfs_trans_dquot.c	2007-03-29 19:03:30.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/quota/xfs_trans_dquot.c	2007-06-25 14:18:48.239290090 +1000
@@ -24,10 +24,10 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_alloc.h"
 #include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
+#include "xfs_alloc.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
