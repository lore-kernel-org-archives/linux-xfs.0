Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF573C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjDFTjJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237250AbjDFTjJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:39:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3FEE50
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:39:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBD1060EFE
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E987C433D2;
        Thu,  6 Apr 2023 19:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809947;
        bh=1KEN42LiXPBKOY3IuYH/aqO+L+wW1zQtez9mGWda0vw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=B1cjzVRYWeqwCZ0BllIA+H1hYJl7Kd0zoWoaUNlLdogBUQiJu3BqNkvWNq/DnUGpD
         e0CFvba4ob+5iPYxzxzjhn2j19hb04d4EKNFQUgwc+5Xa25nqINMEJyIJ5xHRHEn/p
         7C6f27MhdsxN14V92EC0OwinPUYl46M1vfuuFpycDVx/p6qmlP80+RxO4forbou45R
         0evStWDF1UW3XfdF390Eq/fB04Bbit/NBviETI/vZT/yVAIGQsSS9+jq6W5Qv10ehe
         pJ8+T+u5qoPbiAcwPXw469RqBfSbSC28Qa+IALN9DBfPBLXI54XCr0CMpllxZgJTXQ
         pkgpPcCiytmmw==
Date:   Thu, 06 Apr 2023 12:39:06 -0700
Subject: [PATCH 29/32] libxfs: create new files with attr forks if necessary
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827939.616793.12522854598295807492.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
References: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
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
index 59cd547d6..101b77602 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -746,14 +746,18 @@ void
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
index 6525f63de..bea5f1c71 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -322,6 +322,20 @@ libxfs_init_new_inode(
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

