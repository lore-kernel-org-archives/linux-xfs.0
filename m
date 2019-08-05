Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49498 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfHEAgm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 20:36:42 -0400
Subject: [PATCH 16/18] xfs: scrub should set preen if attr leaf has holes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 04 Aug 2019 17:36:33 -0700
Message-ID: <156496539303.804304.4141238010910458481.stgit@magnolia>
In-Reply-To: <156496528310.804304.8105015456378794397.stgit@magnolia>
References: <156496528310.804304.8105015456378794397.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

If an attr block indicates that it could use compaction, set the preen
flag to have the attr fork rebuilt, since the attr fork rebuilder can
take care of that for us.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/attr.c    |    2 ++
 fs/xfs/scrub/dabtree.c |   15 +++++++++++++++
 fs/xfs/scrub/dabtree.h |    1 +
 fs/xfs/scrub/trace.h   |    1 +
 4 files changed, 19 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 67f42b666aad..9dcc69ecec76 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -366,6 +366,8 @@ xchk_xattr_block(
 		xchk_da_set_corrupt(ds, level);
 	if (!xchk_xattr_set_map(ds->sc, usedmap, 0, hdrsize))
 		xchk_da_set_corrupt(ds, level);
+	if (leafhdr.holes)
+		xchk_da_set_preen(ds, level);
 
 	if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 77ff9f97bcda..8a3dfe88347f 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -77,6 +77,21 @@ xchk_da_set_corrupt(
 			__return_address);
 }
 
+/* Flag a da btree node in need of optimization. */
+void
+xchk_da_set_preen(
+	struct xchk_da_btree	*ds,
+	int			level)
+{
+	struct xfs_scrub	*sc = ds->sc;
+
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
+	trace_xchk_fblock_preen(sc, ds->dargs.whichfork,
+			xfs_dir2_da_to_db(ds->dargs.geo,
+				ds->state->path.blk[level].blkno),
+			__return_address);
+}
+
 /* Find an entry at a certain level in a da btree. */
 STATIC void *
 xchk_da_btree_entry(
diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
index cb3f0003245b..b367bf87a183 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -36,6 +36,7 @@ bool xchk_da_process_error(struct xchk_da_btree *ds, int level, int *error);
 
 /* Check for da btree corruption. */
 void xchk_da_set_corrupt(struct xchk_da_btree *ds, int level);
+void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
 
 int xchk_da_btree_hash(struct xchk_da_btree *ds, int level, __be32 *hashp);
 int xchk_da_btree(struct xfs_scrub *sc, int whichfork,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 1124c86b980f..7eb166599a61 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -298,6 +298,7 @@ DEFINE_EVENT(xchk_fblock_error_class, name, \
 
 DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xchk_fblock_error);
 DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xchk_fblock_warning);
+DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xchk_fblock_preen);
 
 TRACE_EVENT(xchk_incomplete,
 	TP_PROTO(struct xfs_scrub *sc, void *ret_ip),
