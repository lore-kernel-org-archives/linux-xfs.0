Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41794 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933269AbdHYWRE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 18:17:04 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7PMH32v013213
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:17:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7PMH3Gi012328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:17:03 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7PMH3ks015169
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:17:03 GMT
Subject: [PATCH 02/19] xfs: expose various functions to repair code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 Aug 2017 15:17:01 -0700
Message-ID: <150369942177.9957.4757848629478852004.stgit@magnolia>
In-Reply-To: <150369940879.9957.6303798184036268321.stgit@magnolia>
References: <150369940879.9957.6303798184036268321.stgit@magnolia>
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
index 6ec2655..b7d4a1b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -147,7 +147,7 @@ xfs_inobt_get_rec(
 /*
  * Insert a single inobt record. Cursor must already point to desired location.
  */
-STATIC int
+int
 xfs_inobt_insert_rec(
 	struct xfs_btree_cur	*cur,
 	uint16_t		holemask,
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 7a26cf7..42b8c34 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -177,6 +177,9 @@ int xfs_ialloc_has_inode_record(struct xfs_btree_cur *cur, xfs_agino_t low,
 		xfs_agino_t high, bool *exists);
 int xfs_ialloc_count_inodes(struct xfs_btree_cur *cur, xfs_agino_t *count,
 		xfs_agino_t *freecount);
+int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
+		uint8_t count, int32_t freecount, xfs_inofree_t free,
+		int *stat);
 
 int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
 
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 728133f..dc3fbcb 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -88,7 +88,7 @@ xfs_refcount_lookup_ge(
 }
 
 /* Convert on-disk record to in-core format. */
-static inline void
+void
 xfs_refcount_btrec_to_irec(
 	union xfs_btree_rec		*rec,
 	struct xfs_refcount_irec	*irec)
@@ -148,7 +148,7 @@ xfs_refcount_update(
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

