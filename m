Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED79C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbiLaANt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235580AbiLaANs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:13:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4728660EF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:13:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4BAD61CFD
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34324C433EF;
        Sat, 31 Dec 2022 00:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445626;
        bh=oX1yq6xn6FeSgY1G0NyiQ/VI83nHgV55hdWXA5Us+1Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o8SZYWHtgvjVBHCK/EfT0Of2sqWjkw4xuTa3Z2uMptouDD36Xo/WJeFyU6rUKkSkd
         Fn5VVMCCRe5mrWjO2qSL1ukbhubgj7bJFi2AuxKDtr70quzpYRlP4GtMxIgqVgSF7k
         2M+j+0XoBoNQggHnpuYwKDOFKqomdA0GoSy2j29tl8XpALVSnXNYwTq/ts72fpIa2f
         iqjPN9RK15mZHotiPTrdqRxdLnoHb8hlT3Gd7jRxC61UhOVq7DqKFwWJb3rMdhUqVV
         N6hcUYtDJdwWkoDxNX3th/u7vvGag807SXkSp53/Nc+z1KnxxDL+N1c0vMx4aqGENh
         ssG8Be3VmUOrw==
Subject: [PATCH 1/5] xfs: create a helper to decide if a file mapping targets
 the rt volume
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:45 -0800
Message-ID: <167243866577.712315.17923461730307344571.stgit@magnolia>
In-Reply-To: <167243866562.712315.18184440339100962213.stgit@magnolia>
References: <167243866562.712315.18184440339100962213.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a helper so that we can stop open-coding this decision
everywhere.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c       |    6 +++---
 libxfs/xfs_inode_fork.c |    9 +++++++++
 libxfs/xfs_inode_fork.h |    1 +
 3 files changed, 13 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index f88e95056e2..4533db87668 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4905,7 +4905,7 @@ xfs_bmap_del_extent_delay(
 
 	XFS_STATS_INC(mp, xs_del_exlist);
 
-	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
+	isrt = xfs_ifork_is_realtime(ip, whichfork);
 	del_endoff = del->br_startoff + del->br_blockcount;
 	got_endoff = got->br_startoff + got->br_blockcount;
 	da_old = startblockval(got->br_startblock);
@@ -5145,7 +5145,7 @@ xfs_bmap_del_extent_real(
 		return -ENOSPC;
 
 	flags = XFS_ILOG_CORE;
-	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
+	if (xfs_ifork_is_realtime(ip, whichfork)) {
 		xfs_filblks_t	len;
 		xfs_extlen_t	mod;
 
@@ -5410,7 +5410,7 @@ __xfs_bunmapi(
 		return 0;
 	}
 	XFS_STATS_INC(mp, xs_blk_unmap);
-	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
+	isrt = xfs_ifork_is_realtime(ip, whichfork);
 	end = start + len;
 
 	if (!xfs_iext_lookup_extent_before(ip, ifp, &end, &icur, &got)) {
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 0dd59f4eb43..9b0c786fab6 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -785,3 +785,12 @@ xfs_iext_count_upgrade(
 
 	return 0;
 }
+
+/* Decide if a file mapping is on the realtime device or not. */
+bool
+xfs_ifork_is_realtime(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	return XFS_IS_REALTIME_INODE(ip) && whichfork != XFS_ATTR_FORK;
+}
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 36a9fe3420c..c201d8ad595 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -261,6 +261,7 @@ int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
 		int nr_to_add);
 int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
 		uint nr_to_add);
+bool xfs_ifork_is_realtime(struct xfs_inode *ip, int whichfork);
 
 /* returns true if the fork has extents but they are not read in yet. */
 static inline bool xfs_need_iread_extents(struct xfs_ifork *ifp)

