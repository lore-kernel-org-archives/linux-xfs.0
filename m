Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E2EC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241794AbjEZBet (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbjEZBet (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:34:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF6A194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:34:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D51F961A8E
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48612C433D2;
        Fri, 26 May 2023 01:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064887;
        bh=B76GCO8MD8qx7r2mI6SrFrxz6nKG1fnTkZ6EQAXXqWQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=c/wbuTAE0wfdNbfo7eWFuIU5PuPSzV8vuiWl7gwfQdmbXctNji9WZaJTGDZrntXnZ
         09hW3g6s3Ko5QcsPtkaYhXG/NkNl2tHg4ScfUxmIotC7dh6MyatM5DB7KBPUTBEtqG
         JewMgCgik1n66dMdzu56r+Zh5JGfYU1aM+pvF5UY9ZbnivcM/7okcnhuuK7CGW8WYu
         WcGwCyoic7sBxKPpLEL7BAK3fVI0Exx9Yi12zl32E4Bg2OuhZRASWaydkLhaq3iV68
         mOINjaMTzYzwHvV4tnFnfJQufkR3nmEGc/m4R1DC7yfMHaQPVS/xVqiORAPhf36nZ/
         IE26Rqcq7zeFA==
Date:   Thu, 25 May 2023 18:34:46 -0700
Subject: [PATCH 3/7] xfs: update the unlinked list when repairing link counts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506067274.3737555.1013121183647061882.stgit@frogsfrogsfrogs>
In-Reply-To: <168506067222.3737555.8668637245740627164.stgit@frogsfrogsfrogs>
References: <168506067222.3737555.8668637245740627164.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're repairing the link counts of a file, we must ensure either
that the file has zero link count and is on the unlinked list; or that
it has nonzero link count and is not on the unlinked list.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/nlinks_repair.c |   42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index 9ab098d85d17..db878b948710 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -17,6 +17,7 @@
 #include "xfs_iwalk.h"
 #include "xfs_ialloc.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
@@ -36,6 +37,20 @@
  * inode is locked.
  */
 
+/* Remove an inode from the unlinked list. */
+STATIC int
+xrep_nlinks_iunlink_remove(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_perag	*pag;
+	int			error;
+
+	pag = xfs_perag_get(sc->mp, XFS_INO_TO_AGNO(sc->mp, sc->ip->i_ino));
+	error = xfs_iunlink_remove(sc->tp, pag, sc->ip);
+	xfs_perag_put(pag);
+	return error;
+}
+
 /*
  * Correct the link count of the given inode.  Because we have to grab locks
  * and resources in a certain order, it's possible that this will be a no-op.
@@ -99,16 +114,25 @@ xrep_nlinks_repair_inode(
 	}
 
 	/*
-	 * We did not find any links to this inode.  If the inode agrees, we
-	 * have nothing further to do.  If not, the inode has a nonzero link
-	 * count and we don't have anywhere to graft the child onto.  Dropping
-	 * a live inode's link count to zero can cause unexpected shutdowns in
-	 * inactivation, so leave it alone.
+	 * If this inode is linked from the directory tree and on the unlinked
+	 * list, remove it from the unlinked list.
 	 */
-	if (total_links == 0) {
-		if (actual_nlink != 0)
-			trace_xrep_nlinks_unfixable_inode(mp, ip, &obs);
-		goto out_trans;
+	if (total_links > 0 && xfs_inode_on_unlinked_list(ip)) {
+		error = xrep_nlinks_iunlink_remove(sc);
+		if (error)
+			goto out_trans;
+		dirty = true;
+	}
+
+	/*
+	 * If this inode is not linked from the directory tree yet not on the
+	 * unlinked list, put it on the unlinked list.
+	 */
+	if (total_links == 0 && !xfs_inode_on_unlinked_list(ip)) {
+		error = xfs_iunlink(sc->tp, ip);
+		if (error)
+			goto out_trans;
+		dirty = true;
 	}
 
 	/* Commit the new link count if it changed. */

