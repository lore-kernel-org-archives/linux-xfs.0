Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57032 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753442AbeE3Tb6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 15:31:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4UJQ132011822
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:31:58 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2j9ev84287-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:31:57 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4UJVvU0004658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:31:57 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4UJVusK031502
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:31:57 GMT
Subject: [PATCH 12/14] xfs: scrub should set preen if attr leaf has holes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 30 May 2018 12:31:55 -0700
Message-ID: <152770871579.11611.6307283952838589766.stgit@magnolia>
In-Reply-To: <152770863951.11611.5866814627357136911.stgit@magnolia>
References: <152770863951.11611.5866814627357136911.stgit@magnolia>
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
index ac25d624286e..ce27357a8dd1 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -307,6 +307,8 @@ xfs_scrub_xattr_block(
 		xfs_scrub_da_set_corrupt(ds, level);
 	if (!xfs_scrub_xattr_set_map(ds->sc, usedmap, 0, hdrsize))
 		xfs_scrub_da_set_corrupt(ds, level);
+	if (leafhdr.holes)
+		xfs_scrub_da_set_preen(ds, level);
 
 	if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index bffdb7dc09bf..d11364d48286 100644
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
index d31468d68cef..681f82faee3e 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -50,6 +50,7 @@ bool xfs_scrub_da_process_error(struct xfs_scrub_da_btree *ds, int level, int *e
 
 /* Check for da btree corruption. */
 void xfs_scrub_da_set_corrupt(struct xfs_scrub_da_btree *ds, int level);
+void xfs_scrub_da_set_preen(struct xfs_scrub_da_btree *ds, int level);
 
 int xfs_scrub_da_btree_hash(struct xfs_scrub_da_btree *ds, int level,
 			    __be32 *hashp);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 794d56bb1af8..1e25cc1cf34b 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -244,6 +244,7 @@ DEFINE_EVENT(xfs_scrub_fblock_error_class, name, \
 
 DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xfs_scrub_fblock_error);
 DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xfs_scrub_fblock_warning);
+DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xfs_scrub_fblock_preen);
 
 TRACE_EVENT(xfs_scrub_incomplete,
 	TP_PROTO(struct xfs_scrub_context *sc, void *ret_ip),

