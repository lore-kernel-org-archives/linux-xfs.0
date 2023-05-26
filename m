Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C89C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjEZBHp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbjEZBHj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:07:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569FFE59
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:07:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D76C610A2
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD8BC433D2;
        Fri, 26 May 2023 01:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063232;
        bh=Qtq0Z5b9loT2ON5WdMs9ulZfRsrNPUMaql9+JbZsNiA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=oWho1RMVRUG8bpVVUOmkkJ8v9kvzOItq4hKWlLR7VXsVxlTMp1XQkp2hEH6Drt6C5
         Ivujeek9x6JnkQanLvRIK45Q3OF4oZw9fenebg00uFQKB58SEY1EwZ8vLWw/Y7XbI/
         MiRFaNrsELk8l1ygHS+jdlbfdOOJjUV0mb9ePTueqLzrJ7E3Nq5vUmURluibgqJwoW
         b9MwTGqxMKO+dIqK0PKJjYNx2huWooBOtwNw51jhUtPwDW1scU8NkwI08lrb7T+X05
         eOqMCFgYsrXuoN6e6RFaKUP76LUoY2c5lW9DHQppdAX1k2cJDlt2/BxjaYme48cX7z
         OL0v81AI7fYnw==
Date:   Thu, 25 May 2023 18:07:11 -0700
Subject: [PATCH 1/4] xfs: create a helper to decide if a file mapping targets
 the rt volume
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506062313.3733354.2473059117167242981.stgit@frogsfrogsfrogs>
In-Reply-To: <168506062293.3733354.11070133195917318351.stgit@frogsfrogsfrogs>
References: <168506062293.3733354.11070133195917318351.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_bmap.c       |    6 +++---
 fs/xfs/libxfs/xfs_inode_fork.c |    9 +++++++++
 fs/xfs/libxfs/xfs_inode_fork.h |    1 +
 fs/xfs/scrub/bmap.c            |    2 +-
 4 files changed, 14 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b126d26cea4d..1e49ed208ef1 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4884,7 +4884,7 @@ xfs_bmap_del_extent_delay(
 
 	XFS_STATS_INC(mp, xs_del_exlist);
 
-	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
+	isrt = xfs_ifork_is_realtime(ip, whichfork);
 	del_endoff = del->br_startoff + del->br_blockcount;
 	got_endoff = got->br_startoff + got->br_blockcount;
 	da_old = startblockval(got->br_startblock);
@@ -5124,7 +5124,7 @@ xfs_bmap_del_extent_real(
 		return -ENOSPC;
 
 	flags = XFS_ILOG_CORE;
-	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
+	if (xfs_ifork_is_realtime(ip, whichfork)) {
 		xfs_filblks_t	len;
 		xfs_extlen_t	mod;
 
@@ -5389,7 +5389,7 @@ __xfs_bunmapi(
 		return 0;
 	}
 	XFS_STATS_INC(mp, xs_blk_unmap);
-	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
+	isrt = xfs_ifork_is_realtime(ip, whichfork);
 	end = start + len;
 
 	if (!xfs_iext_lookup_extent_before(ip, ifp, &end, &icur, &got)) {
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index f32f02c414ac..f295fba3a61a 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -801,3 +801,12 @@ xfs_iext_count_upgrade(
 
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
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 535be5c03689..ebeb925be09d 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -262,6 +262,7 @@ int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
 		int nr_to_add);
 int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
 		uint nr_to_add);
+bool xfs_ifork_is_realtime(struct xfs_inode *ip, int whichfork);
 
 /* returns true if the fork has extents but they are not read in yet. */
 static inline bool xfs_need_iread_extents(const struct xfs_ifork *ifp)
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 0f66313f9769..da1bbd0bf225 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -865,7 +865,7 @@ xchk_bmap(
 	if (!ifp)
 		goto out;
 
-	info.is_rt = whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip);
+	info.is_rt = xfs_ifork_is_realtime(ip, whichfork);
 	info.whichfork = whichfork;
 	info.is_shared = whichfork == XFS_DATA_FORK && xfs_is_reflink_inode(ip);
 	info.sc = sc;

