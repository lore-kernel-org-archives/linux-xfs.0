Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59728 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750969AbeECSHL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 14:07:11 -0400
Subject: [PATCH 09/12] xfs: clean up scrub usage of KM_NOFS
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 May 2018 11:06:51 -0700
Message-ID: <152537081095.16676.17433484200511069545.stgit@magnolia>
In-Reply-To: <152537075334.16676.10600900179473864298.stgit@magnolia>
References: <152537075334.16676.10600900179473864298.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

All scrub code runs in transaction context, which means that memory
allocations are automatically run in PF_MEMALLOC_NOFS context.  It's
therefore unnecessary to pass in KM_NOFS to allocation routines, so
clean them all out.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/scrub/agheader.c |    3 ++-
 fs/xfs/scrub/btree.c    |    2 +-
 fs/xfs/scrub/refcount.c |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index cd24ac56c21e..831acc0a328f 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -795,7 +795,8 @@ xfs_scrub_agfl(
 	}
 	memset(&sai, 0, sizeof(sai));
 	sai.sz_entries = agflcount;
-	sai.entries = kmem_zalloc(sizeof(xfs_agblock_t) * agflcount, KM_NOFS);
+	sai.entries = kmem_zalloc(sizeof(xfs_agblock_t) * agflcount,
+			KM_MAYFAIL);
 	if (!sai.entries) {
 		error = -ENOMEM;
 		goto out;
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 54218168c8f9..ea972dab1485 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -442,7 +442,7 @@ xfs_scrub_btree_check_owner(
 	 */
 	if (cur->bc_btnum == XFS_BTNUM_BNO || cur->bc_btnum == XFS_BTNUM_RMAP) {
 		co = kmem_alloc(sizeof(struct check_owner),
-				KM_MAYFAIL | KM_NOFS);
+				KM_MAYFAIL);
 		if (!co)
 			return -ENOMEM;
 		co->level = level;
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 913b0a190e68..324a5f159145 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -150,7 +150,7 @@ xfs_scrub_refcountbt_rmap_check(
 		 * so we don't need insertion sort here.
 		 */
 		frag = kmem_alloc(sizeof(struct xfs_scrub_refcnt_frag),
-				KM_MAYFAIL | KM_NOFS);
+				KM_MAYFAIL);
 		if (!frag)
 			return -ENOMEM;
 		memcpy(&frag->rm, rec, sizeof(frag->rm));

