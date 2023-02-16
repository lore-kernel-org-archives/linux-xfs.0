Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23B1AC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjBPVC0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjBPVCZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:02:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91DB4D606
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:02:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A15EB826BA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A047C433EF;
        Thu, 16 Feb 2023 21:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581342;
        bh=rISdAqbnC6MnxgB7Wv3rwsQ4zrQIcNsV1+cIf6kwnXQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=FuGYdwaW+yjNBDE7MuQI6QU861eCovvqyXk4+LdV3VKPuhcuJofwUL26sMyIDHZWU
         8TGCMcJ1zClNkbJ5j4NOd1P6aMhrOmytXqGPg2ZwT9528W4Og2uOh2IWg15g7NPkNY
         Lcwr3Fjwgs3+4Lyj4PMphe+g2FMDIn+fmsx3F/nICsszeAo+U/utNyL7Qz6YNDvO0O
         bys9+TBkJ21goqH6joYIYFA2In4lPgNzDLMUD/cFqxoUbdoy5HRAAOHQzl+c++3rWN
         lCLsrEk4GQ/HIIo3dggIeZZATrkAp44bRGpYF6e/WxXKwVxkQfHV4CGhIwMoiuMmEP
         waZNTCsmOB9Kg==
Date:   Thu, 16 Feb 2023 13:02:21 -0800
Subject: [PATCH 3/6] libxfs: create new files with attr forks if necessary
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879935.3476911.5056578529876837289.stgit@magnolia>
In-Reply-To: <167657879895.3476911.2211427543938389071.stgit@magnolia>
References: <167657879895.3476911.2211427543938389071.stgit@magnolia>
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
index 49cb2326..cffd8a63 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -736,14 +736,18 @@ void
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
index 6525f63d..bea5f1c7 100644
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

