Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0489C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbiLaBo6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236014AbiLaBo4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:44:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF93F026
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:44:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08EA761C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6054AC433D2;
        Sat, 31 Dec 2022 01:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451095;
        bh=/sLgTPi/17aYf5liPwmZU0WzbYvqUKOSw10HU69+sf4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NwbRhL8jwDAyGUtyu6W9YhFy602FVnWfr/2NUM5n03pzOPwXrCb4hoxnPPQ1sa67e
         UzIg879RRlcAvfcQdPkBk/C7/1z2lRqW/po5bHF/o0bBx28wtN0pBEU6JgrksoWtUL
         AsZpeuHE8SacxjGCSh0Qobl2ScxugDIqEiUuSjRKXXjxOUnJOt12Gy4D/iODCNqPvP
         YSWW5zyhp8iGn7DVW1g2OkOMjJ9P2YuBDE0jLNn279XpqE2OEB7voanxSv3TILYbn2
         ihyA8tgIWIMVndT4psSC7Z/fZYzn6iRzRPRHw50/JukX9m30779V1XXSqDCkKfzA3I
         FbrDVc9Doxkiw==
Subject: [PATCH 31/38] xfs: walk the rt reverse mapping tree when rebuilding
 rmap
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:20 -0800
Message-ID: <167243870045.715303.13233266513206700894.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're rebuilding the data device rmap, if we encounter an "rmap"
format fork, we have to walk the (realtime) rmap btree inode to build
the appropriate mappings.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rmap_repair.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)


diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index ed937e461bf8..86c5338a12b9 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -30,6 +30,8 @@
 #include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_ag.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_rtgroup.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -496,6 +498,38 @@ xrep_rmap_scan_iext(
 	return xrep_rmap_stash_accumulated(rf);
 }
 
+static int
+xrep_rmap_scan_rtrmapbt(
+	struct xrep_rmap_ifork	*rf,
+	struct xfs_inode	*ip)
+{
+	struct xfs_scrub	*sc = rf->rr->sc;
+	struct xfs_btree_cur	*cur;
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
+	int			error;
+
+	if (rf->whichfork != XFS_DATA_FORK)
+		return -EFSCORRUPTED;
+
+	for_each_rtgroup(sc->mp, rgno, rtg) {
+		if (ip == rtg->rtg_rmapip) {
+			cur = xfs_rtrmapbt_init_cursor(sc->mp, sc->tp, rtg, ip);
+			error = xrep_rmap_scan_iroot_btree(rf, cur);
+			xfs_btree_del_cursor(cur, error);
+			xfs_rtgroup_put(rtg);
+			return error;
+		}
+	}
+
+	/*
+	 * We shouldn't find an rmap format inode that isn't associated with
+	 * an rtgroup!
+	 */
+	ASSERT(0);
+	return -EFSCORRUPTED;
+}
+
 /* Find all the extents from a given AG in an inode fork. */
 STATIC int
 xrep_rmap_scan_ifork(
@@ -525,6 +559,8 @@ xrep_rmap_scan_ifork(
 		error = xrep_rmap_scan_bmbt(&rf, ip, &mappings_done);
 		if (error || mappings_done)
 			return error;
+	} else if (ifp->if_format == XFS_DINODE_FMT_RMAP) {
+		return xrep_rmap_scan_rtrmapbt(&rf, ip);
 	} else if (ifp->if_format != XFS_DINODE_FMT_EXTENTS) {
 		return 0;
 	}

