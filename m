Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59142 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCoL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:44:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2fVoe010568
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:10 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2hdrxnrjxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:10 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2i90O020700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:09 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2i9p2032163
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:09 GMT
Subject: [PATCH 22/24] xfs: scrub should set preen if attr leaf has holes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:44:08 -0700
Message-ID: <152401944855.12079.927032724388733057.stgit@magnolia>
In-Reply-To: <152401930978.12079.2000682561964128780.stgit@magnolia>
References: <152401930978.12079.2000682561964128780.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If an attr block indicates that it could use compaction, set the preen
flag to have the attr fork rebuilt, since the attr fork rebuilder can
take care of that for us.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/attr.c    |    2 ++
 fs/xfs/scrub/dabtree.c |   15 +++++++++++++++
 fs/xfs/scrub/dabtree.h |    1 +
 fs/xfs/scrub/trace.h   |    1 +
 4 files changed, 19 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 7ee2ffe..8589939 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -306,6 +306,8 @@ xfs_scrub_xattr_block(
 		xfs_scrub_da_set_corrupt(ds, level);
 	if (!xfs_scrub_xattr_set_map(ds->sc, usedmap, 0, hdrsize))
 		xfs_scrub_da_set_corrupt(ds, level);
+	if (leafhdr.holes)
+		xfs_scrub_da_set_preen(ds, level);
 
 	if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index bffdb7d..d11364d 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -99,6 +99,21 @@ xfs_scrub_da_set_corrupt(
 			__return_address);
 }
 
+/* Flag a da btree node in need of optimization. */
+void
+xfs_scrub_da_set_preen(
+	struct xfs_scrub_da_btree	*ds,
+	int				level)
+{
+	struct xfs_scrub_context	*sc = ds->sc;
+
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
+	trace_xfs_scrub_fblock_preen(sc, ds->dargs.whichfork,
+			xfs_dir2_da_to_db(ds->dargs.geo,
+				ds->state->path.blk[level].blkno),
+			__return_address);
+}
+
 /* Find an entry at a certain level in a da btree. */
 STATIC void *
 xfs_scrub_da_btree_entry(
diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
index d31468d..681f82f 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -50,6 +50,7 @@ bool xfs_scrub_da_process_error(struct xfs_scrub_da_btree *ds, int level, int *e
 
 /* Check for da btree corruption. */
 void xfs_scrub_da_set_corrupt(struct xfs_scrub_da_btree *ds, int level);
+void xfs_scrub_da_set_preen(struct xfs_scrub_da_btree *ds, int level);
 
 int xfs_scrub_da_btree_hash(struct xfs_scrub_da_btree *ds, int level,
 			    __be32 *hashp);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 794d56b..1e25cc1 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -244,6 +244,7 @@ DEFINE_EVENT(xfs_scrub_fblock_error_class, name, \
 
 DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xfs_scrub_fblock_error);
 DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xfs_scrub_fblock_warning);
+DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xfs_scrub_fblock_preen);
 
 TRACE_EVENT(xfs_scrub_incomplete,
 	TP_PROTO(struct xfs_scrub_context *sc, void *ret_ip),

