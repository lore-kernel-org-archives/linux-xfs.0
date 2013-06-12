Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 18B747FD5
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:37:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EC2078F8037
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:37:01 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	FVdZ9xAUSLsqubKM for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 03:37:00 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UmiQ3-0001BT-Cl
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:47 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UmiQ3-0006mo-6E
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/22] libxfs: move the transaction reservation structures
Date: Wed, 12 Jun 2013 20:36:17 +1000
Message-Id: <1371033394-26006-6-git-send-email-david@fromorbit.com>
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

To prepare for getting rid of xfs_mount.h, we need to move the
definition of the struct for pre-calculated transaction reservations
out of xfs_mount.h. Move it to xfs_trans.h along with all the other
transaction reservation definitions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h    |    5 ++---
 include/xfs_mount.h |   30 ------------------------------
 include/xfs_trans.h |   30 ++++++++++++++++++++++++++++++
 mkfs/maxtrres.c     |    2 +-
 4 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 900b115..9ab9604 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -58,6 +58,7 @@
 #include <xfs/xfs_trace.h>
 #include <xfs/xfs_symlink.h>
 #include <xfs/xfs_icreate_item.h>
+#include <xfs/xfs_trans.h>
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
@@ -202,7 +203,7 @@ typedef struct xfs_mount {
 	int			m_ialloc_blks;	/* blocks in inode allocation */
 	int			m_litino;	/* size of inode union area */
 	int			m_inoalign_mask;/* mask sb_inoalignmt if used */
-	xfs_trans_reservations_t m_reservations;/* precomputed res values */
+	struct xfs_trans_reservations m_reservations;/* precomputed res values */
 	__uint64_t		m_maxicount;	/* maximum inode count */
 	int			m_dalign;	/* stripe unit */
 	int			m_swidth;	/* stripe width */
@@ -436,8 +437,6 @@ typedef struct xfs_buf_log_item {
 	xfs_buf_log_format_t	bli_format;	/* in-log header */
 } xfs_buf_log_item_t;
 
-#include <xfs/xfs_trans.h>
-
 typedef struct xfs_trans {
 	unsigned int	t_type;			/* transaction type */
 	unsigned int	t_log_res;		/* amt of log space resvd */
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index e609b5f..ce0adfb 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -18,36 +18,6 @@
 #ifndef __XFS_MOUNT_H__
 #define	__XFS_MOUNT_H__
 
-typedef struct xfs_trans_reservations {
-	uint	tr_write;	/* extent alloc trans */
-	uint	tr_itruncate;	/* truncate trans */
-	uint	tr_rename;	/* rename trans */
-	uint	tr_link;	/* link trans */
-	uint	tr_remove;	/* unlink trans */
-	uint	tr_symlink;	/* symlink trans */
-	uint	tr_create;	/* create trans */
-	uint	tr_mkdir;	/* mkdir trans */
-	uint	tr_ifree;	/* inode free trans */
-	uint	tr_ichange;	/* inode update trans */
-	uint	tr_growdata;	/* fs data section grow trans */
-	uint	tr_swrite;	/* sync write inode trans */
-	uint	tr_addafork;	/* cvt inode to attributed trans */
-	uint	tr_writeid;	/* write setuid/setgid file */
-	uint	tr_attrinval;	/* attr fork buffer invalidation */
-	uint	tr_attrsetm;    /* set/create an attribute at mount time */
-	uint	tr_attrsetrt;   /* set/create an attribute at runtime */
-	uint	tr_attrrm;	/* remove an attribute */
-	uint	tr_clearagi;	/* clear bad agi unlinked ino bucket */
-	uint	tr_growrtalloc;	/* grow realtime allocations */
-	uint	tr_growrtzero;	/* grow realtime zeroing */
-	uint	tr_growrtfree;	/* grow realtime freeing */
-	uint	tr_qm_sbchange;	/* change quota flags */
-	uint	tr_qm_setqlim;	/* adjust quota limits */
-	uint	tr_qm_dqalloc;	/* allocate quota on disk */
-	uint	tr_qm_quotaoff;	/* turn quota off */
-	uint	tr_qm_equotaoff;/* end of turn quota off */
-	uint	tr_sb;		/* modify superblock */
-} xfs_trans_reservations_t;
 
 #ifndef __KERNEL__
 
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 36a0026..78074f3 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -209,6 +209,36 @@ struct xfs_log_item_desc {
 #define	XFS_TRANS_SB_REXTENTS		0x00001000
 #define	XFS_TRANS_SB_REXTSLOG		0x00002000
 
+struct xfs_trans_reservations {
+	uint	tr_write;	/* extent alloc trans */
+	uint	tr_itruncate;	/* truncate trans */
+	uint	tr_rename;	/* rename trans */
+	uint	tr_link;	/* link trans */
+	uint	tr_remove;	/* unlink trans */
+	uint	tr_symlink;	/* symlink trans */
+	uint	tr_create;	/* create trans */
+	uint	tr_mkdir;	/* mkdir trans */
+	uint	tr_ifree;	/* inode free trans */
+	uint	tr_ichange;	/* inode update trans */
+	uint	tr_growdata;	/* fs data section grow trans */
+	uint	tr_swrite;	/* sync write inode trans */
+	uint	tr_addafork;	/* cvt inode to attributed trans */
+	uint	tr_writeid;	/* write setuid/setgid file */
+	uint	tr_attrinval;	/* attr fork buffer invalidation */
+	uint	tr_attrsetm;    /* set/create an attribute at mount time */
+	uint	tr_attrsetrt;   /* set/create an attribute at runtime */
+	uint	tr_attrrm;	/* remove an attribute */
+	uint	tr_clearagi;	/* clear bad agi unlinked ino bucket */
+	uint	tr_growrtalloc;	/* grow realtime allocations */
+	uint	tr_growrtzero;	/* grow realtime zeroing */
+	uint	tr_growrtfree;	/* grow realtime freeing */
+	uint	tr_qm_sbchange;	/* change quota flags */
+	uint	tr_qm_setqlim;	/* adjust quota limits */
+	uint	tr_qm_dqalloc;	/* allocate quota on disk */
+	uint	tr_qm_quotaoff;	/* turn quota off */
+	uint	tr_qm_equotaoff;/* end of turn quota off */
+	uint	tr_sb;		/* modify superblock */
+};
 
 /*
  * Per-extent log reservation for the allocation btree changes
diff --git a/mkfs/maxtrres.c b/mkfs/maxtrres.c
index d571d77..373e582 100644
--- a/mkfs/maxtrres.c
+++ b/mkfs/maxtrres.c
@@ -56,7 +56,7 @@ max_trans_res_by_mount(
 {
 	uint				*p;
 	int				rval;
-	xfs_trans_reservations_t	*tr = &mp->m_reservations;
+	struct xfs_trans_reservations	*tr = &mp->m_reservations;
 
 	for (rval = 0, p = (uint *)tr; p < (uint *)(tr + 1); p++) {
 		if ((int)*p > rval)
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
