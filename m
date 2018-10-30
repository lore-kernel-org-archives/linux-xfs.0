Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:63819 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727151AbeJ3UN4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 16:13:56 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gHS4k-0005bq-SB
        for linux-xfs@vger.kernel.org; Tue, 30 Oct 2018 22:20:46 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gHS4k-0001jW-Qf
        for linux-xfs@vger.kernel.org; Tue, 30 Oct 2018 22:20:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/7] Revert "xfs_repair: treat zero da btree pointers as corruption"
Date: Tue, 30 Oct 2018 22:20:37 +1100
Message-Id: <20181030112043.6034-2-david@fromorbit.com>
In-Reply-To: <20181030112043.6034-1-david@fromorbit.com>
References: <20181030112043.6034-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This reverts commit 67a79e2cc9320aaf269cd00e9c8d16892931886d.

A root LEAFN block can exist in a directory. When we convert from
leaf format (LEAF1 - internal free list) to node format (LEAFN -
external free list) the only change to the single root leaf block is
that it's magic number is changed from LEAF1 to LEAFN.

We don't actually end up with DA nodes in the tree until the LEAFN
node is split, and that requires a couple more dirents to be added
to the directory to fill the LEAFN block up completely. Then it will
split and create a DA node root block pointing to multiple LEAFN
leaf blocks.

Hence restore the old behaviour where we skip the DA node tree
rebuild if there is a LEAFN root block found as there is no tree to
rebuild.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/dir2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index 3374ae722bf9..ba5763ed3d26 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -1242,11 +1242,11 @@ process_node_dir2(
 		return 1;
 
 	/*
-	 * Directories with a root marked XFS_DIR2_LEAFN_MAGIC are corrupt
+	 * Skip directories with a root marked XFS_DIR2_LEAFN_MAGIC
 	 */
 	if (bno == 0) {
-		err_release_da_cursor(mp, &da_cursor, 0);
-		return 1;
+		release_da_cursor(mp, &da_cursor, 0);
+		return 0;
 	} else {
 		/*
 		 * Now pass cursor and bno into leaf-block processing routine.
-- 
2.19.1
