Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F0E2029E2C
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:52:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CFE508F8049
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:52:15 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	7iyBsQCXfCRRwPJ3 for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:52:13 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpANQ-0002zZ-Bf
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:12 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpANB-00005H-78
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:51:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 22/60] xfs: move xfs_trans_reservations to xfs_trans.h
Date: Wed, 19 Jun 2013 14:50:30 +1000
Message-Id: <1371617468-32559-23-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-1-git-send-email-david@fromorbit.com>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
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

struct xfs_trans_reservations is the only non kernel-only definition
in xfs_mount.h. Move it to xfs_trans.h so that we no longer need
xfs_mount.h in the userspace code. Most places that include
xfs_mount.h already include xfs_trans.h and xfs_trans.h is shared
with userspace, so there are no major concerns about moving this
structure there.

While in xfs-mount.h, remove the remaining two #defines that are
defined for userspace - the kernel code has a separate definition of
the macros so this is purely userspace code. This allows us to
remove the __KERNEL__ switches from xfs_mount.h entirely.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_acl.c      |    2 ++
 fs/xfs/xfs_buf.c      |    1 +
 fs/xfs/xfs_discard.c  |    1 +
 fs/xfs/xfs_mount.h    |   44 +-------------------------------------------
 fs/xfs/xfs_quotaops.c |    1 +
 fs/xfs/xfs_trans.h    |   33 +++++++++++++++++++++++++++++++++
 6 files changed, 39 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index fecdcd0..b9b9740 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -21,6 +21,8 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
 #include "xfs_sb.h"
+#include "xfs_log.h"
+#include "xfs_trans.h"
 #include "xfs_mount.h"
 #include "xfs_trace.h"
 #include <linux/slab.h>
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1b2472a..e0a6d0e 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -37,6 +37,7 @@
 #include "xfs_sb.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
+#include "xfs_trans.h"
 #include "xfs_mount.h"
 #include "xfs_trace.h"
 
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 69cf4fc..9fab41e 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -19,6 +19,7 @@
 #include "xfs_sb.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
+#include "xfs_trans.h"
 #include "xfs_mount.h"
 #include "xfs_quota.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 10761c3..dedda31 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -18,46 +18,6 @@
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
-	uint	tr_attrsetm;	/* set/create an attribute at mount time */
-	uint	tr_attrsetrt;	/* set/create an attribute at runtime */
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
 struct xlog;
 struct xfs_inode;
 struct xfs_mru_cache;
@@ -174,7 +134,7 @@ typedef struct xfs_mount {
 	int			m_ialloc_blks;	/* blocks in inode allocation */
 	int			m_inoalign_mask;/* mask sb_inoalignmt if used */
 	uint			m_qflags;	/* quota status flags */
-	xfs_trans_reservations_t m_reservations;/* precomputed res values */
+	struct xfs_trans_reservations m_reservations;/* precomputed res values */
 	__uint64_t		m_maxicount;	/* maximum inode count */
 	__uint64_t		m_resblks;	/* total reserved blocks */
 	__uint64_t		m_resblks_avail;/* available reserved blocks */
@@ -383,6 +343,4 @@ extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
 
 extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
 
-#endif	/* __KERNEL__ */
-
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 71926d6..d7e2e43 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -19,6 +19,7 @@
 #include "xfs_sb.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
+#include "xfs_trans.h"
 #include "xfs_mount.h"
 #include "xfs_quota.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 079d5a0..60427aa 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -208,6 +208,39 @@ struct xfs_log_item_desc {
 #define	XFS_TRANS_SB_REXTENTS		0x00001000
 #define	XFS_TRANS_SB_REXTSLOG		0x00002000
 
+/*
+ * structure for maintaining pre-calculated transaction reservations.
+ */
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
+	uint	tr_attrsetm;	/* set/create an attribute at mount time */
+	uint	tr_attrsetrt;	/* set/create an attribute at runtime */
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
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
