Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42010 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751281AbdBFRIc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Feb 2017 12:08:32 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH v2] xfs: correct null checks and error processing in xfs_initialize_perag
Date: Mon,  6 Feb 2017 11:08:30 -0600
Message-Id: <20170206170830.26194-1-billodo@redhat.com>
In-Reply-To: <20170128191957.13851-1-billodo@redhat.com>
References: <20170128191957.13851-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

If pag cannot be allocated, the current error exit path will trip
a null pointer deference error when calling xfs_buf_hash_destroy
with a null pag.  Fix this by adding a new error exit labels and
jumping to those accordingly, avoiding the hash destroy and
unnecessary kmem_free on pag.

Up to three things need to be properly unwound:

1) pag memory allocation
2) xfs_buf_hash_init
3) radix_tree_insert

For any given iteration through the loop, any of the above which
succeed must be unwound for /this/ pag, and then all prior
initialized pags must be unwound.

Fixes CoverityScan CID#1397628 ("Dereference after null check")

Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
v2: correct jump to out_hash_destroy for case where hash is initialized.
    use NULLAGNUMBER to simplify first_initialised loop logic.

 fs/xfs/xfs_mount.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 9b9540d..3c28af1 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -187,7 +187,7 @@ xfs_initialize_perag(
 	xfs_agnumber_t	*maxagi)
 {
 	xfs_agnumber_t	index;
-	xfs_agnumber_t	first_initialised = 0;
+	xfs_agnumber_t	first_initialised = NULLAGNUMBER;
 	xfs_perag_t	*pag;
 	int		error = -ENOMEM;
 
@@ -202,22 +202,20 @@ xfs_initialize_perag(
 			xfs_perag_put(pag);
 			continue;
 		}
-		if (!first_initialised)
-			first_initialised = index;
 
 		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
 		if (!pag)
-			goto out_unwind;
+			goto out_unwind_new_pags;
 		pag->pag_agno = index;
 		pag->pag_mount = mp;
 		spin_lock_init(&pag->pag_ici_lock);
 		mutex_init(&pag->pag_ici_reclaim_lock);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 		if (xfs_buf_hash_init(pag))
-			goto out_unwind;
+			goto out_free_pag;
 
 		if (radix_tree_preload(GFP_NOFS))
-			goto out_unwind;
+			goto out_hash_destroy;
 
 		spin_lock(&mp->m_perag_lock);
 		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
@@ -225,10 +223,13 @@ xfs_initialize_perag(
 			spin_unlock(&mp->m_perag_lock);
 			radix_tree_preload_end();
 			error = -EEXIST;
-			goto out_unwind;
+			goto out_hash_destroy;
 		}
 		spin_unlock(&mp->m_perag_lock);
 		radix_tree_preload_end();
+		/* first new pag is fully initialized */
+		if (first_initialised == NULLAGNUMBER)
+			first_initialised = index;
 	}
 
 	index = xfs_set_inode_alloc(mp, agcount);
@@ -239,10 +240,13 @@ xfs_initialize_perag(
 	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
 	return 0;
 
-out_unwind:
+out_hash_destroy:
 	xfs_buf_hash_destroy(pag);
+out_free_pag:
 	kmem_free(pag);
-	for (; index > first_initialised; index--) {
+out_unwind_new_pags:
+	/* unwind any prior newly initialized pags */
+	while (index-- >= first_initialised && index != NULLAGNUMBER) {
 		pag = radix_tree_delete(&mp->m_perag_tree, index);
 		xfs_buf_hash_destroy(pag);
 		kmem_free(pag);
-- 
2.9.3

