Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730674AbfGWPAW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Jul 2019 11:00:22 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F1A4C307D9CE
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2019 15:00:21 +0000 (UTC)
Received: from pegasus.maiolino.com (ovpn-204-213.brq.redhat.com [10.40.204.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60BD8104B4FC
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2019 15:00:21 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs: Do not free xfs_extent_busy from inside a spinlock
Date: Tue, 23 Jul 2019 17:00:17 +0200
Message-Id: <20190723150017.31891-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_extent_busy_clear_one() calls kmem_free() with the pag spinlock
locked.

Fix this by adding a new temporary list, and, make
xfs_extent_busy_clear_one() to move the extent_busy items to this new
list, instead of freeing them.

Free the objects in the temporary list after we drop the pagb_lock

Reported-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_extent_busy.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 0ed68379e551..0a7dcf03340b 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -523,7 +523,8 @@ STATIC void
 xfs_extent_busy_clear_one(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
-	struct xfs_extent_busy	*busyp)
+	struct xfs_extent_busy	*busyp,
+	struct list_head	*list)
 {
 	if (busyp->length) {
 		trace_xfs_extent_busy_clear(mp, busyp->agno, busyp->bno,
@@ -531,8 +532,7 @@ xfs_extent_busy_clear_one(
 		rb_erase(&busyp->rb_node, &pag->pagb_tree);
 	}
 
-	list_del_init(&busyp->list);
-	kmem_free(busyp);
+	list_move(&busyp->list, list);
 }
 
 static void
@@ -565,6 +565,7 @@ xfs_extent_busy_clear(
 	struct xfs_perag	*pag = NULL;
 	xfs_agnumber_t		agno = NULLAGNUMBER;
 	bool			wakeup = false;
+	LIST_HEAD(busy_list);
 
 	list_for_each_entry_safe(busyp, n, list, list) {
 		if (busyp->agno != agno) {
@@ -580,13 +581,18 @@ xfs_extent_busy_clear(
 		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD)) {
 			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
 		} else {
-			xfs_extent_busy_clear_one(mp, pag, busyp);
+			xfs_extent_busy_clear_one(mp, pag, busyp, &busy_list);
 			wakeup = true;
 		}
 	}
 
 	if (pag)
 		xfs_extent_busy_put_pag(pag, wakeup);
+
+	list_for_each_entry_safe(busyp, n, &busy_list, list) {
+		list_del_init(&busyp->list);
+		kmem_free(busyp);
+	}
 }
 
 /*
-- 
2.20.1
