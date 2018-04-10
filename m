Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53128 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753468AbeDJPIS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Apr 2018 11:08:18 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 87F9981A88A8
        for <linux-xfs@vger.kernel.org>; Tue, 10 Apr 2018 15:08:18 +0000 (UTC)
Received: from odin.usersys.redhat.com (ovpn-204-52.brq.redhat.com [10.40.204.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF5C52166BAD
        for <linux-xfs@vger.kernel.org>; Tue, 10 Apr 2018 15:08:17 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] Force log to disk before reading the AGF during a fstrim
Date: Tue, 10 Apr 2018 17:08:14 +0200
Message-Id: <20180410150814.22610-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Forcing the log to disk after reading the agf is wrong, we might be
calling xfs_log_force with XFS_LOG_SYNC with a metadata lock held.

This can cause a deadlock when racing a fstrim with a filesystem
shutdown.

The deadlock has been identified due a miscalculation bug in device-mapper
dm-thin, which returns lack of space to its users earlier than the device itself
really runs out of space, changing the device-mapper volume into an error state.

The problem happened while filling the filesystem with a single file,
triggering the bug in device-mapper, consequently causing an IO error
and shutting down the filesystem.

If such file is removed, and fstrim executed before the XFS finishes the
shut down process, the fstrim process will end up holding the buffer
lock, and going to sleep on the cil wait queue.

At this point, the shut down process will try to wake up all the threads
waiting on the cil wait queue, but for this, it will try to hold the
same buffer log already held my the fstrim, locking up the filesystem.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
Kudos to Dave who spotted it just after me telling him the process was
deadlocked on a buffer lock

 fs/xfs/xfs_discard.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index b2cde5426182..7b68e6c9a474 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -50,19 +50,19 @@ xfs_trim_extents(
 
 	pag = xfs_perag_get(mp, agno);
 
-	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
-	if (error || !agbp)
-		goto out_put_perag;
-
-	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno, XFS_BTNUM_CNT);
-
 	/*
 	 * Force out the log.  This means any transactions that might have freed
-	 * space before we took the AGF buffer lock are now on disk, and the
+	 * space before we take the AGF buffer lock are now on disk, and the
 	 * volatile disk cache is flushed.
 	 */
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error || !agbp)
+		goto out_put_perag;
+
+	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno, XFS_BTNUM_CNT);
+
 	/*
 	 * Look up the longest btree in the AGF and start with it.
 	 */
-- 
2.14.3

