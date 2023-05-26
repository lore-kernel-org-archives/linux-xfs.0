Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C92C7EE2F
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbjEZC2z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbjEZC2y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:28:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DA39B
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:28:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA3BE64C57
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7F7C4339C;
        Fri, 26 May 2023 02:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068132;
        bh=lJJ4DACK1m6otcHwC0gnlXrzdkBajhtIFQco8dKHqJY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=KZzTkwmsHLqKi738Xbo6cz+Z86HpdaW8MUp8qFMHd+FDvWfi5fjWdfYvUcPgJ9n7t
         5Ey8gAUhsLqKpWsu1mjKgqx+agI5ZtiK9p2W8POPdtm2G1+/EdtFeAuzFALJ9NIQv1
         TEp0wdSGo5Y+it1CDoWS0+kCCICcfbQWBG++eM/pJNhRRjuhXmcOvj24cMPvl8vD4M
         vKIwKt89Y2PZGDEZutG/+XZTXnDGNDEA8q3fZTdU3Ttiwyz059zvd2/rjz4t5ZbDUV
         /pNUfy18d9FMGS1B/rwxwOyXy9xijYTpNVfEjJyV0nlkUeCqAjI6qZawh94v7oLrgs
         z0dT8bHC/qI7g==
Date:   Thu, 25 May 2023 19:28:51 -0700
Subject: [PATCH 27/30] libxfs: create new files with attr forks if necessary
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078255.3749421.6274535805643049447.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
References: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create new files with attr forks if they're going to have parent
pointers.  In the next patch we'll fix mkfs to use the same parent
creation functions as the kernel, so we're going to need this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c |    4 ++++
 libxfs/util.c |   14 ++++++++++++++
 2 files changed, 18 insertions(+)


diff --git a/libxfs/init.c b/libxfs/init.c
index 26b578134c7..1d28c7b3824 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -819,14 +819,18 @@ void
 libxfs_compute_all_maxlevels(
 	struct xfs_mount	*mp)
 {
+	struct xfs_ino_geometry *igeo = M_IGEO(mp);
+
 	xfs_alloc_compute_maxlevels(mp);
 	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
 	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
+	igeo->attr_fork_offset = xfs_bmap_compute_attr_offset(mp);
 	xfs_ialloc_setup_geometry(mp);
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
 	xfs_agbtree_compute_maxlevels(mp);
+
 }
 
 /*
diff --git a/libxfs/util.c b/libxfs/util.c
index febbd84ab92..75166508d06 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -340,6 +340,20 @@ libxfs_init_new_inode(
 		ASSERT(0);
 	}
 
+	/*
+	 * If we need to create attributes immediately after allocating the
+	 * inode, initialise an empty attribute fork right now. We use the
+	 * default fork offset for attributes here as we don't know exactly what
+	 * size or how many attributes we might be adding. We can do this
+	 * safely here because we know the data fork is completely empty and
+	 * this saves us from needing to run a separate transaction to set the
+	 * fork offset in the immediate future.
+	 */
+	if (xfs_has_parent(tp->t_mountp) && xfs_has_attr(tp->t_mountp)) {
+		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
+		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
+	}
+
 	/*
 	 * Log the new values stuffed into the inode.
 	 */

