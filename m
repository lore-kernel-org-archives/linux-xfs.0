Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753090AbdHNKxz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Aug 2017 06:53:55 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D222D2FFC2F
        for <linux-xfs@vger.kernel.org>; Mon, 14 Aug 2017 10:53:54 +0000 (UTC)
Received: from hades.localdomain.com (unknown [10.43.17.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51642675BB
        for <linux-xfs@vger.kernel.org>; Mon, 14 Aug 2017 10:53:54 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] Stop searching for free slots in an inode chunk when there are none
Date: Mon, 14 Aug 2017 12:53:49 +0200
Message-Id: <20170814105349.12391-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

In a filesystem without finobt, the Space manager selects an AG to alloc a new
inode, where xfs_dialloc_ag_inobt() will search the AG for the free slot chunk.

When the new inode is in the samge AG as its parent, the btree will be searched
starting on the parent's record, and then retried from the top if no slot is
available beyond the parent's record.

To exit this loop though, xfs_dialloc_ag_inobt() relies on the fact that the
btree must have a free slot available, once its callers relied on the
agi->freecount when deciding how/where to allocate this new inode.

In the case when the agi->freecount is corrupted, showing available inodes in an
AG, when in fact there is none, this becomes an infinite loop.

Add a way to stop the loop when a free slot is not found in the btree, making
the function to fall into the whole AG scan which will then, be able to detect
the corruption and shut the filesystem down.

As pointed by Brian, this might impact performance, giving the fact we
don't reset the search distance anymore when we reach the end of the
tree, giving it fewer tries before falling back to the whole AG search, but
it will only affect searches that start within 10 records to the end of the tree.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
Changelog:

	V3: - Move searchdistance state saving out of the while loop
	    - Remove newino goto label

	V2: - Use searchdistance variable to stop the infinite loop
	      instead of adding a new mechanism

 fs/xfs/libxfs/xfs_ialloc.c | 55 +++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index d41ade5d293e..0e1cc51f05a1 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1123,6 +1123,7 @@ xfs_dialloc_ag_inobt(
 	int			error;
 	int			offset;
 	int			i, j;
+	int			searchdistance = 10;
 
 	pag = xfs_perag_get(mp, agno);
 
@@ -1149,7 +1150,6 @@ xfs_dialloc_ag_inobt(
 	if (pagno == agno) {
 		int		doneleft;	/* done, to the left */
 		int		doneright;	/* done, to the right */
-		int		searchdistance = 10;
 
 		error = xfs_inobt_lookup(cur, pagino, XFS_LOOKUP_LE, &i);
 		if (error)
@@ -1210,21 +1210,9 @@ xfs_dialloc_ag_inobt(
 		/*
 		 * Loop until we find an inode chunk with a free inode.
 		 */
-		while (!doneleft || !doneright) {
+		while (--searchdistance > 0 && (!doneleft || !doneright)) {
 			int	useleft;  /* using left inode chunk this time */
 
-			if (!--searchdistance) {
-				/*
-				 * Not in range - save last search
-				 * location and allocate a new inode
-				 */
-				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
-				pag->pagl_leftrec = trec.ir_startino;
-				pag->pagl_rightrec = rec.ir_startino;
-				pag->pagl_pagino = pagino;
-				goto newino;
-			}
-
 			/* figure out the closer block if both are valid. */
 			if (!doneleft && !doneright) {
 				useleft = pagino -
@@ -1268,26 +1256,37 @@ xfs_dialloc_ag_inobt(
 				goto error1;
 		}
 
-		/*
-		 * We've reached the end of the btree. because
-		 * we are only searching a small chunk of the
-		 * btree each search, there is obviously free
-		 * inodes closer to the parent inode than we
-		 * are now. restart the search again.
-		 */
-		pag->pagl_pagino = NULLAGINO;
-		pag->pagl_leftrec = NULLAGINO;
-		pag->pagl_rightrec = NULLAGINO;
-		xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
-		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
-		goto restart_pagno;
+		if (searchdistance <= 0) {
+			/*
+			 * Not in range - save last search
+			 * location and allocate a new inode
+			 */
+			xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+			pag->pagl_leftrec = trec.ir_startino;
+			pag->pagl_rightrec = rec.ir_startino;
+			pag->pagl_pagino = pagino;
+
+		} else {
+			/*
+			 * We've reached the end of the btree. because
+			 * we are only searching a small chunk of the
+			 * btree each search, there is obviously free
+			 * inodes closer to the parent inode than we
+			 * are now. restart the search again.
+			 */
+			pag->pagl_pagino = NULLAGINO;
+			pag->pagl_leftrec = NULLAGINO;
+			pag->pagl_rightrec = NULLAGINO;
+			xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+			goto restart_pagno;
+		}
 	}
 
 	/*
 	 * In a different AG from the parent.
 	 * See if the most recently allocated block has any free.
 	 */
-newino:
 	if (agi->agi_newino != cpu_to_be32(NULLAGINO)) {
 		error = xfs_inobt_lookup(cur, be32_to_cpu(agi->agi_newino),
 					 XFS_LOOKUP_EQ, &i);
-- 
2.13.5

