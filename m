Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59438 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750916AbeBWCG7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 21:06:59 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1N22UY7151111
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:06:59 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2ga9bpg2ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:06:59 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1N21wNF017421
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:01:58 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1N21wfj016140
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:01:58 GMT
Subject: [PATCH 02/20] xfs: expose various functions to repair code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Feb 2018 18:01:57 -0800
Message-ID: <151935131727.22097.7401876151750781961.stgit@magnolia>
In-Reply-To: <151935130484.22097.9694510081310029779.stgit@magnolia>
References: <151935130484.22097.9694510081310029779.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Expose various helpers that the repair code will want to use.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc.c   |    2 +-
 fs/xfs/libxfs/xfs_ialloc.h   |    3 +++
 fs/xfs/libxfs/xfs_refcount.c |    4 ++--
 fs/xfs/libxfs/xfs_refcount.h |    5 +++++
 4 files changed, 11 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 0e2cf5f..fcbf09f 100644
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
index bee68c2..100532d 100644
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

