Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24BC6C4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:25:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F493613DE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhFBW1m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 18:27:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhFBW1l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 18:27:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A7DA613AC;
        Wed,  2 Jun 2021 22:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622672758;
        bh=c0NEMI8EOHUdrLyCzdzbUWs78Qu0ACl9t4/e7uSrZXg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=P4+sU1MMpnnkUR2Gm9grxbvoT5VV+gLYsUY9Cy6rUzGLcKO55M41OwyzbqpyiEU6Y
         eH/FvdIQc3dIcQqGN2wg9eaK4lYA29gnaojmX1qQ6JrIVbfy8LNmCFz6q3sLGOUuV4
         YqGeVxDrt8sw24GtFHXmXg7wJ1F0C08nQro7tqFSu5mLeJb0oLc1dnP+D17AICvJyt
         V3rm6UwBkdDbGwLbJQhizTFDs4F4AVOdVmy4lad9fBwelUDPB8uxVmXCnjGW8VGCWn
         1T+Mzjs8L34hD9vkyNlUit4fmr+64VCpxyZ/usAD0hAeMddSjjM/WudJAfgwi0Fzun
         dO8WHn5Qd8w2w==
Subject: [PATCH 11/15] xfs: make the icwalk processing functions clean up the
 grab state
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Wed, 02 Jun 2021 15:25:57 -0700
Message-ID: <162267275779.2375284.17546006970223560395.stgit@locust>
In-Reply-To: <162267269663.2375284.15885514656776142361.stgit@locust>
References: <162267269663.2375284.15885514656776142361.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Soon we're going to be adding two new callers to the incore inode walk
code: reclaim of incore inodes, and (later) inactivation of inodes.
Both states operate on inodes that no longer have any VFS state, so we
need to move the xfs_irele calls into the processing functions.

In other words, icwalk processing functions are responsible for cleaning
up whatever state changes are made by the corresponding icwalk igrab
function that picked the inode for processing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 94dba5c1b98d..806faa8df7e9 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -811,7 +811,7 @@ xfs_dqrele_igrab(
 }
 
 /* Drop this inode's dquots. */
-static int
+static void
 xfs_dqrele_inode(
 	struct xfs_inode	*ip,
 	void			*priv)
@@ -835,7 +835,7 @@ xfs_dqrele_inode(
 		ip->i_pdquot = NULL;
 	}
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return 0;
+	xfs_irele(ip);
 }
 
 /*
@@ -861,7 +861,7 @@ xfs_dqrele_all_inodes(
 }
 #else
 # define xfs_dqrele_igrab(ip)		(false)
-# define xfs_dqrele_inode(ip, priv)	(0)
+# define xfs_dqrele_inode(ip, priv)	((void)0)
 #endif /* CONFIG_XFS_QUOTA */
 
 /*
@@ -1592,6 +1592,7 @@ xfs_blockgc_scan_inode(
 unlock:
 	if (lockflags)
 		xfs_iunlock(ip, lockflags);
+	xfs_irele(ip);
 	return error;
 }
 
@@ -1698,8 +1699,7 @@ xfs_blockgc_free_quota(
 
 /*
  * Decide if we want to grab this inode in anticipation of doing work towards
- * the goal.  If selected, the VFS must hold a reference to this inode, which
- * will be released after processing.
+ * the goal.
  */
 static inline bool
 xfs_icwalk_igrab(
@@ -1716,24 +1716,26 @@ xfs_icwalk_igrab(
 	}
 }
 
-/* Process an inode and release it.  Return -EAGAIN to skip an inode. */
+/*
+ * Process an inode.  Each processing function must handle any state changes
+ * made by the icwalk igrab function.  Return -EAGAIN to skip an inode.
+ */
 static inline int
 xfs_icwalk_process_inode(
 	enum xfs_icwalk_goal	goal,
 	struct xfs_inode	*ip,
 	void			*args)
 {
-	int			error;
+	int			error = 0;
 
 	switch (goal) {
 	case XFS_ICWALK_DQRELE:
-		error = xfs_dqrele_inode(ip, args);
+		xfs_dqrele_inode(ip, args);
 		break;
 	case XFS_ICWALK_BLOCKGC:
 		error = xfs_blockgc_scan_inode(ip, args);
 		break;
 	}
-	xfs_irele(ip);
 	return error;
 }
 

