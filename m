Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D4CCDB47E
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 20:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346890AbjJKUdw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 16:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbjJKUdw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 16:33:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7246791
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 13:33:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0296FC433C7;
        Wed, 11 Oct 2023 20:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697056431;
        bh=v696LvSTywrtI1ag9RMPn67t9nyQkopAT6GrlOVRAvk=;
        h=Date:From:To:Cc:Subject:From;
        b=gLFTLxgrgssbRA+bXMHUAMB0n18Dyzit8AwfIZUzkR/Yt/iQLYz3INuhniXcqExPa
         IwhOj9pQXSgIXnVL71IkVkjoDKGVadMtbFzDnl4AF+jmcN71qOJVWu22TEA7HuNLeP
         r2xYmeXmxqWNoDGxN/bxSzT/lJnKsbfrhwtzoOEpZXk/BLPMQacb+r42tBLAdlm7R/
         bmCsEz4jfarHhDBs7vkJRSP6W/NFTiOrVBlUqR6nlLxz90ssP9u/tb5G2hohMTtwG4
         XZvK6qkhUHNjk0zgRvzzYJ4azdZnw0/NHDXkEmi5S4KbLWMJgn+Ow4TBgeZbgvxRGa
         pb52+f8B9MveQ==
Date:   Wed, 11 Oct 2023 13:33:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     cheng.lin130@zte.com.cn, david@fromorbit.com,
        linux-xfs@vger.kernel.org, jiang.yong5@zte.com.cn,
        wang.liang82@zte.com.cn, liu.dong3@zte.com.cn
Subject: [PATCH] xfs: pin inodes that would otherwise overflow link count
Message-ID: <20231011203350.GY21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The VFS inc_nlink function does not explicitly check for integer
overflows in the i_nlink field.  Instead, it checks the link count
against s_max_links in the vfs_{link,create,rename} functions.  XFS
sets the maximum link count to 2.1 billion, so integer overflows should
not be a problem.

However.  It's possible that online repair could find that a file has
more than four billion links, particularly if the link count got
corrupted while creating hardlinks to the file.  The di_nlinkv2 field is
not large enough to store a value larger than 2^32, so we ought to
define a magic pin value of ~0U which means that the inode never gets
deleted.  This will prevent a UAF error if the repair finds this
situation and users begin deleting links to the file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    6 ++++++
 fs/xfs/scrub/nlinks.c      |    8 ++++----
 fs/xfs/scrub/repair.c      |   12 ++++++------
 fs/xfs/xfs_inode.c         |   28 +++++++++++++++++++++++-----
 4 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 6409dd22530f2..320522b887bb3 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -896,6 +896,12 @@ static inline uint xfs_dinode_size(int version)
  */
 #define	XFS_MAXLINK		((1U << 31) - 1U)
 
+/*
+ * Any file that hits the maximum ondisk link count should be pinned to avoid
+ * a use-after-free situation.
+ */
+#define XFS_NLINK_PINNED	(~0U)
+
 /*
  * Values for di_format
  *
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4db2c2a6538d6..30604e11182c4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -910,15 +910,25 @@ xfs_init_new_inode(
  */
 static int			/* error */
 xfs_droplink(
-	xfs_trans_t *tp,
-	xfs_inode_t *ip)
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
 {
+	struct inode		*inode = VFS_I(ip);
+
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
-	drop_nlink(VFS_I(ip));
+	if (inode->i_nlink == 0) {
+		xfs_info_ratelimited(tp->t_mountp,
+ "Inode 0x%llx link count dropped below zero.  Pinning link count.",
+				ip->i_ino);
+		set_nlink(inode, XFS_NLINK_PINNED);
+	}
+	if (inode->i_nlink != XFS_NLINK_PINNED)
+		drop_nlink(inode);
+
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	if (VFS_I(ip)->i_nlink)
+	if (inode->i_nlink)
 		return 0;
 
 	return xfs_iunlink(tp, ip);
@@ -932,9 +942,17 @@ xfs_bumplink(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip)
 {
+	struct inode		*inode = VFS_I(ip);
+
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
-	inc_nlink(VFS_I(ip));
+	if (inode->i_nlink == XFS_NLINK_PINNED - 1)
+		xfs_info_ratelimited(tp->t_mountp,
+ "Inode 0x%llx link count exceeded maximum.  Pinning link count.",
+				ip->i_ino);
+	if (inode->i_nlink != XFS_NLINK_PINNED)
+		inc_nlink(inode);
+
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
