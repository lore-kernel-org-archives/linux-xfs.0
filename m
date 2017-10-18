Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29965 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751343AbdJRXAQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2017 19:00:16 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 14/17] xfs: remove parent pointers in unlink
Date: Wed, 18 Oct 2017 15:55:30 -0700
Message-Id: <1508367333-3237-15-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Allison Henderson <allison.henderson@oracle.com>

From: Dave Chinner <dchinner@redhat.com>

[bfoster: rebase, use VFS inode generation]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t
	   implemented xfs_attr_remove_parent]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c   | 15 +++++++++++++++
 fs/xfs/libxfs/xfs_parent.c | 22 ++++++++++++++++++++++
 fs/xfs/xfs_attr.h          |  7 +++++++
 fs/xfs/xfs_inode.c         | 10 +++++++++-
 fs/xfs/xfs_qm.c            |  2 +-
 fs/xfs/xfs_qm.h            |  1 +
 6 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e7692ef..7547eb7 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -42,6 +42,7 @@
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
+#include "xfs_qm.h"
 
 /*
  * xfs_attr.c
@@ -571,6 +572,20 @@ xfs_attr_set_deferred(
 	return 0;
 }
 
+int
+xfs_attr_remove_parent(
+	struct xfs_trans		*tp,
+	struct xfs_inode		*dp,
+	struct xfs_parent_name_rec	*rec,
+	int				reclen,
+	struct xfs_defer_ops		*dfops,
+	xfs_fsblock_t			*firstblock)
+{
+	int flags = ATTR_PARENT;
+
+	return xfs_attr_remove_deferred(dp, dfops, (char *) rec, reclen, flags);
+}
+
 /*
  * Generic handler routine to remove a name from an attribute list.
  * Transitions attribute list from Btree to shortform as necessary.
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 0707336..ca695c4 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -139,3 +139,25 @@ xfs_parent_add(
 
 	return xfs_parent_add_nrec(tp, child, &nrec, dfops, firstblock);
 }
+
+/*
+ * Remove a parent record from a child inode.
+ */
+int
+xfs_parent_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*parent,
+	struct xfs_inode	*child,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_defer_ops	*dfops,
+	xfs_fsblock_t		*firstblock)
+{
+	struct xfs_parent_name_rec rec;
+
+	rec.p_ino = cpu_to_be64(parent->i_ino);
+	rec.p_gen = cpu_to_be32(VFS_I(parent)->i_generation);
+	rec.p_diroffset = cpu_to_be32(diroffset);
+
+	return xfs_attr_remove_parent(tp, child, &rec, sizeof(rec),
+				      dfops, firstblock);
+}
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index acb6157..7a3bf8b 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -207,4 +207,11 @@ int xfs_attr_set_parent(struct xfs_trans *tp, struct xfs_inode *ip,
 			const char *value, int valuelen,
 			struct xfs_defer_ops *dfops, xfs_fsblock_t *firstblock);
 
+int xfs_parent_remove(struct xfs_trans *tp, struct xfs_inode *parent,
+		      struct xfs_inode *child, xfs_dir2_dataptr_t diroffset,
+		      struct xfs_defer_ops *dfops, xfs_fsblock_t *firstblock);
+int xfs_attr_remove_parent(struct xfs_trans *tp, struct xfs_inode *ip,
+			struct xfs_parent_name_rec *rec, int reclen,
+			struct xfs_defer_ops *dfops, xfs_fsblock_t *firstblock);
+
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 51b623b..a360c3d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2612,6 +2612,7 @@ xfs_remove(
 	struct xfs_defer_ops	dfops;
 	xfs_fsblock_t           first_block;
 	uint			resblks;
+	uint32_t		dir_offset;
 
 	trace_xfs_remove(dp, name);
 
@@ -2692,12 +2693,19 @@ xfs_remove(
 
 	xfs_defer_init(&dfops, &first_block);
 	error = xfs_dir_removename(tp, dp, name, ip->i_ino, &first_block,
-				   &dfops, resblks, NULL);
+				   &dfops, resblks, &dir_offset);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_bmap_cancel;
 	}
 
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		error = xfs_parent_remove(tp, dp, ip, dir_offset, &dfops,
+					  &first_block);
+		if (error)
+			goto out_bmap_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 010a13a..a047f0f 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -307,7 +307,7 @@ xfs_qm_dqattach_one(
 	return 0;
 }
 
-static bool
+bool
 xfs_qm_need_dqattach(
 	struct xfs_inode	*ip)
 {
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 2975a82..9976369 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -176,6 +176,7 @@ extern int		xfs_qm_scall_setqlim(struct xfs_mount *, xfs_dqid_t, uint,
 					struct qc_dqblk *);
 extern int		xfs_qm_scall_quotaon(struct xfs_mount *, uint);
 extern int		xfs_qm_scall_quotaoff(struct xfs_mount *, uint);
+extern bool		xfs_qm_need_dqattach(struct xfs_inode *ip);
 
 static inline struct xfs_def_quota *
 xfs_get_defquota(struct xfs_dquot *dqp, struct xfs_quotainfo *qi)
-- 
2.7.4

