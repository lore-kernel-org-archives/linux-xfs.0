Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA4EC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbiL3Xnt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235734AbiL3XnR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:43:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8C31E3DE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:43:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8DF761C17
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450ABC433EF;
        Fri, 30 Dec 2022 23:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443789;
        bh=pBJRWSCjQhKKT1SogExQt9tTLg1TrQVAN7iuqpG/lVI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=stXYq6io8NzHWgKq4OnfihioEcJluGVdocFLSGgdXnA5Wl2MU0A2uhhUX9YI499jK
         lMsLIYPuh8A5w48i0aP+/enzVCFDPIyaP3U+xrMI7YwmKSSP61ynwNAn9g7Nkh5Ek3
         y72vj8tX3/QL4bs6YYHhsMa5P/BWC+UTSDPaOVDBnniEQqSR7/JeaKXBIJMWihmXh/
         Kzhu3/qHrMIFUdpJMIchZYj0Q0ZBzInaIB1HKTyRi2wFb5kwNym7D1vfdRdAlI2fqH
         Wbv7oxiSmOws2DGJaPWwOHU+smi/uiFRsio+oO9MYRV7UkBtn7OXB1rgotHCLpYMF4
         /R56mO9iSfb9w==
Subject: [PATCH 1/4] xfs: create a helper to decide if a file mapping targets
 the rt volume
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:30 -0800
Message-ID: <167243841017.696748.13179340079909837496.stgit@magnolia>
In-Reply-To: <167243840997.696748.11741067698987523110.stgit@magnolia>
References: <167243840997.696748.11741067698987523110.stgit@magnolia>
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
 fs/xfs/scrub/bmap.c            |    4 ++--
 4 files changed, 15 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b658373bedc7..89cbd9b563ff 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4912,7 +4912,7 @@ xfs_bmap_del_extent_delay(
 
 	XFS_STATS_INC(mp, xs_del_exlist);
 
-	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
+	isrt = xfs_ifork_is_realtime(ip, whichfork);
 	del_endoff = del->br_startoff + del->br_blockcount;
 	got_endoff = got->br_startoff + got->br_blockcount;
 	da_old = startblockval(got->br_startblock);
@@ -5152,7 +5152,7 @@ xfs_bmap_del_extent_real(
 		return -ENOSPC;
 
 	flags = XFS_ILOG_CORE;
-	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
+	if (xfs_ifork_is_realtime(ip, whichfork)) {
 		xfs_filblks_t	len;
 		xfs_extlen_t	mod;
 
@@ -5417,7 +5417,7 @@ __xfs_bunmapi(
 		return 0;
 	}
 	XFS_STATS_INC(mp, xs_blk_unmap);
-	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
+	isrt = xfs_ifork_is_realtime(ip, whichfork);
 	end = start + len;
 
 	if (!xfs_iext_lookup_extent_before(ip, ifp, &end, &icur, &got)) {
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 6d23add33de9..c2cc3c193ffc 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -787,3 +787,12 @@ xfs_iext_count_upgrade(
 
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
index 36a9fe3420cd..c201d8ad5957 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -261,6 +261,7 @@ int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
 		int nr_to_add);
 int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
 		uint nr_to_add);
+bool xfs_ifork_is_realtime(struct xfs_inode *ip, int whichfork);
 
 /* returns true if the fork has extents but they are not read in yet. */
 static inline bool xfs_need_iread_extents(struct xfs_ifork *ifp)
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 93fb88ca5f28..150b8c40b809 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -711,7 +711,7 @@ xchk_bmap_check_rmaps(
 		return 0;
 
 	/* Don't support realtime rmap checks yet. */
-	if (XFS_IS_REALTIME_INODE(sc->ip) && whichfork == XFS_DATA_FORK)
+	if (xfs_ifork_is_realtime(sc->ip, whichfork))
 		return 0;
 
 	ASSERT(xfs_ifork_ptr(sc->ip, whichfork) != NULL);
@@ -796,7 +796,7 @@ xchk_bmap(
 	if (!ifp)
 		goto out;
 
-	info.is_rt = whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip);
+	info.is_rt = xfs_ifork_is_realtime(ip, whichfork);
 	info.whichfork = whichfork;
 	info.is_shared = whichfork == XFS_DATA_FORK && xfs_is_reflink_inode(ip);
 	info.sc = sc;

