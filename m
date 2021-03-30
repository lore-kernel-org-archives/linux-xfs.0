Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBCAAC433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 05:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8353261935
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 05:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhC3Fbe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 01:31:34 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:55909 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230223AbhC3FbD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 01:31:03 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 567641AE80A
        for <linux-xfs@vger.kernel.org>; Tue, 30 Mar 2021 16:31:02 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lR6xx-008N4Z-C9
        for linux-xfs@vger.kernel.org; Tue, 30 Mar 2021 16:31:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lR6xx-005cnk-4b
        for linux-xfs@vger.kernel.org; Tue, 30 Mar 2021 16:31:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: inode fork allocation depends on XFS_IFEXTENT flag
Date:   Tue, 30 Mar 2021 16:30:57 +1100
Message-Id: <20210330053059.1339949-3-david@fromorbit.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210330053059.1339949-1-david@fromorbit.com>
References: <20210330053059.1339949-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=BYqOHQL4v3tMcFTdoaQA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

XFS_IFEXTENT has two incompatible meanings to the code. The first
meaning is that the fork is in extent format, the second meaning is
that the extent list has been read into memory.

When the inode fork is in extent format, we automatically read the
extent list into memory and indexed by the inode extent btree when
the inode is brought into memory off disk. Hence we set the flag to
mean both "in extent format and in memory". That requires all new
fork allocations where the default state is "extent format with zero
extents" to set the XFS_IFEXTENT to indicate we've initialised the
in-memory state even though we've really done no such thing.

This fixes a scrub regression because it assumes XFS_IFEXTENT means
"on disk format" and not "read into memory" and e6a688c33238 assumed
it mean "read into memory". In reality, the XFS_IFEXTENT flag needs
to be split up into two flags - one for the on disk fork format and
one for the in-memory "extent btree has been populated" state.

Fixes: e6a688c33238 ("xfs: initialise attr fork on inode create")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 1 -
 fs/xfs/libxfs/xfs_inode_fork.c | 9 +++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5574d345d066..2f72849c05f9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1095,7 +1095,6 @@ xfs_bmap_add_attrfork(
 	ASSERT(ip->i_afp == NULL);
 
 	ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
-	ip->i_afp->if_flags = XFS_IFEXTENTS;
 	logflags = 0;
 	switch (ip->i_df.if_format) {
 	case XFS_DINODE_FMT_LOCAL:
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 1851d6f266d0..03e1a21848eb 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -292,6 +292,15 @@ xfs_ifork_alloc(
 	ifp = kmem_cache_zalloc(xfs_ifork_zone, GFP_NOFS | __GFP_NOFAIL);
 	ifp->if_format = format;
 	ifp->if_nextents = nextents;
+
+	/*
+	 * If this is a caller initialising a newly created fork, we need to
+	 * set XFS_IFEXTENTS to indicate the fork state is completely up to
+	 * date. Otherwise it is up to the caller to initialise the in-memory
+	 * state of the inode fork from the on-disk state.
+	 */
+	if (format == XFS_DINODE_FMT_EXTENTS && nextents == 0)
+		ifp->if_flags |= XFS_IFEXTENTS;
 	return ifp;
 }
 
-- 
2.31.0

