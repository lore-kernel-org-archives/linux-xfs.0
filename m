Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44570 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751183AbdHCPTW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Aug 2017 11:19:22 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3BB967DD0A
        for <linux-xfs@vger.kernel.org>; Thu,  3 Aug 2017 15:19:22 +0000 (UTC)
Received: from hades.localdomain.com (ovpn-204-197.brq.redhat.com [10.40.204.197])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81096782D5
        for <linux-xfs@vger.kernel.org>; Thu,  3 Aug 2017 15:19:21 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] Stop searching for free slots in an inode chunk when there are none
Date: Thu,  3 Aug 2017 17:19:15 +0200
Message-Id: <20170803151915.7861-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

In a filesystem without finobt, the Space manager selects an AG to alloc a new
inode, where xfs_dialloc_ag_inobt() will search the AG for the free slot chunk.

When the new inode is in the samge AG as its parent, the btree will be
searched starting on the parent's record, and then retried from the top
if no slot is available beyond the parent's record.

To exit this loop though, xfs_dialloc_ag_inobt(), relies on the fact that the
btree must have a free slot available, once its callers relied on the
agi->freecount when deciding how/where to allocate this new inode.

In the case when the agi->freecount is corrupted, showing available
inodes in an AG, when in fact there is none, this becomes an infinite
loop.

Add a way to stop the loop when a free slot is not found in the btree,
making the function to fall into the whole AG scan which will then, be
able to detect the corruption and shut the filesystem down.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

I have a xfstest to catch this agi->freecount corruption case, I'll send it to
the list soon.

 fs/xfs/libxfs/xfs_ialloc.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index d41ade5d293e..8ebe0d89bdc5 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1123,6 +1123,7 @@ xfs_dialloc_ag_inobt(
 	int			error;
 	int			offset;
 	int			i, j;
+	int			retry = true; /* Search tree from the top */
 
 	pag = xfs_perag_get(mp, agno);
 
@@ -1205,6 +1206,12 @@ xfs_dialloc_ag_inobt(
 			error = xfs_ialloc_next_rec(cur, &rec, &doneright, 0);
 			if (error)
 				goto error1;
+
+			/*
+			 * We've already scanned the whole btree, no need to
+			 * retry the search.
+			 */
+			retry = false;
 		}
 
 		/*
@@ -1268,19 +1275,23 @@ xfs_dialloc_ag_inobt(
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
+		if (retry) {
+			/*
+			 * We've reached the end of the btree. because
+			 * we are only searching a small chunk of the
+			 * btree each search, there must be free
+			 * inodes (unless something is corrupted)
+			 * closer to the parent inode than we
+			 * are now. restart the search again.
+			 */
+			pag->pagl_pagino = NULLAGINO;
+			pag->pagl_leftrec = NULLAGINO;
+			pag->pagl_rightrec = NULLAGINO;
+			xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+
+			goto restart_pagno;
+		}
 	}
 
 	/*
-- 
2.13.3

