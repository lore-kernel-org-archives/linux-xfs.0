Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57934 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCla (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:41:30 -0400
Subject: [PATCH 3/9] xfs: expose various functions to repair code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:41:11 -0700
Message-ID: <152401927098.11792.3751174007636562617.stgit@magnolia>
In-Reply-To: <152401924595.11792.16954598133403059881.stgit@magnolia>
References: <152401924595.11792.16954598133403059881.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Expose various helpers that the repair code will want to use.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c   |    2 +-
 fs/xfs/libxfs/xfs_ialloc.h   |    3 +++
 fs/xfs/libxfs/xfs_refcount.c |    4 ++--
 fs/xfs/libxfs/xfs_refcount.h |    5 +++++
 4 files changed, 11 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index de627fa..4ca4ff7 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -148,7 +148,7 @@ xfs_inobt_get_rec(
 /*
  * Insert a single inobt record. Cursor must already point to desired location.
  */
-STATIC int
+int
 xfs_inobt_insert_rec(
 	struct xfs_btree_cur	*cur,
 	uint16_t		holemask,
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index c5402bb..77fffce 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -176,6 +176,9 @@ int xfs_ialloc_has_inode_record(struct xfs_btree_cur *cur, xfs_agino_t low,
 		xfs_agino_t high, bool *exists);
 int xfs_ialloc_count_inodes(struct xfs_btree_cur *cur, xfs_agino_t *count,
 		xfs_agino_t *freecount);
+int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
+		uint8_t count, int32_t freecount, xfs_inofree_t free,
+		int *stat);
 
 int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
 void xfs_ialloc_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 560e284..f94bac7 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -89,7 +89,7 @@ xfs_refcount_lookup_ge(
 }
 
 /* Convert on-disk record to in-core format. */
-static inline void
+void
 xfs_refcount_btrec_to_irec(
 	union xfs_btree_rec		*rec,
 	struct xfs_refcount_irec	*irec)
@@ -149,7 +149,7 @@ xfs_refcount_update(
  * by [bno, len, refcount].
  * This either works (return 0) or gets an EFSCORRUPTED error.
  */
-STATIC int
+int
 xfs_refcount_insert(
 	struct xfs_btree_cur		*cur,
 	struct xfs_refcount_irec	*irec,
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 2a731ac..5856abb 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -85,5 +85,10 @@ static inline xfs_fileoff_t xfs_refcount_max_unmap(int log_res)
 
 extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
+union xfs_btree_rec;
+extern void xfs_refcount_btrec_to_irec(union xfs_btree_rec *rec,
+		struct xfs_refcount_irec *irec);
+extern int xfs_refcount_insert(struct xfs_btree_cur *cur,
+		struct xfs_refcount_irec *irec, int *stat);
 
 #endif	/* __XFS_REFCOUNT_H__ */

