Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E44EBCE79A4
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjIYV6g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjIYV6g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:58:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E44FAF
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:58:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0957C433C7;
        Mon, 25 Sep 2023 21:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679109;
        bh=y2f8W9okw1GD2wst7y7PBA7gfPURcgfnxpu78wY6KHM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=thNyRGs5WealxD7+TnuPdpZ+Jljz5JB0aljs6kuB/xlHYbgBdr5lrBsyVfHmqcQr5
         oaGZZopUFHahyNgX2sGzqz7Yv0VW7O1gZXzEmwEe+4NMi2boE1Y56nurLvXBXfZk9t
         GqP1CCEIbOYW/TETVqH48WBJV1f9uQ2rGGOITIIa4/HFCGxMssRH5B6Oc1DMp6bsNz
         RSQFXoRt8D7Dz/DvwQbH+mBa1GNnLBPxuUKRKGhMuTPCsk+rSbQBUni/HcGTTXdWjD
         kp/s9MEc97w9tW25GfhxUz6UI7MRi6CQgRtMKLLvIIQL+LQJidlJryvvCFWb67yjmI
         HqIwZks/Sb8Sg==
Subject: [PATCH 3/5] xfs: switch to multigrain timestamps
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:58:29 -0700
Message-ID: <169567910940.2318286.3159215838085969856.stgit@frogsfrogsfrogs>
In-Reply-To: <169567909240.2318286.10628058261852886648.stgit@frogsfrogsfrogs>
References: <169567909240.2318286.10628058261852886648.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Source kernel commit: e44df2664746aed8b6dd5245eb711a0ce33c5cf5

Enable multigrain timestamps, which should ensure that there is an
apparent change to the timestamp whenever it has been written after
being actively observed via getattr.

Also, anytime the mtime changes, the ctime must also change, and those
are now the only two options for xfs_trans_ichgtime. Have that function
unconditionally bump the ctime, and ASSERT that XFS_ICHGTIME_CHG is
always set.

Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Message-Id: <20230807-mgctime-v7-11-d1dec143a704@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 include/xfs_inode.h      |   12 ++++++++++--
 libxfs/xfs_trans_inode.c |    6 +++---
 2 files changed, 13 insertions(+), 5 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 39b1bee8444..af8939ca259 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -89,6 +89,16 @@ static inline struct timespec64 inode_set_ctime_to_ts(struct inode *inode,
 	return ts;
 }
 
+extern struct timespec64 current_time(struct inode *inode);
+
+static inline struct timespec64 inode_set_ctime_current(struct inode *inode)
+{
+	struct timespec64 now = current_time(inode);
+
+	inode_set_ctime_to_ts(inode, now);
+	return now;
+}
+
 typedef struct xfs_inode {
 	struct cache_node	i_node;
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
@@ -271,8 +281,6 @@ extern void	libxfs_trans_ichgtime(struct xfs_trans *,
 				struct xfs_inode *, int);
 extern int	libxfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
 
-extern struct timespec64 current_time(struct inode *inode);
-
 /* Inode Cache Interfaces */
 extern int	libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 				uint, struct xfs_inode **);
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index ca8e823762c..7a6ecb5db0d 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -59,12 +59,12 @@ xfs_trans_ichgtime(
 	ASSERT(tp);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
-	tv = current_time(inode);
+	/* If the mtime changes, then ctime must also change */
+	ASSERT(flags & XFS_ICHGTIME_CHG);
 
+	tv = inode_set_ctime_current(inode);
 	if (flags & XFS_ICHGTIME_MOD)
 		inode->i_mtime = tv;
-	if (flags & XFS_ICHGTIME_CHG)
-		inode_set_ctime_to_ts(inode, tv);
 	if (flags & XFS_ICHGTIME_CREATE)
 		ip->i_crtime = tv;
 }

