Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBAD9C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241716AbjEZBeS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbjEZBeS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:34:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17979189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:34:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A126260ADA
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1B1C433D2;
        Fri, 26 May 2023 01:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064856;
        bh=O0J1XpI8qOzvuLi04lpi0/njYas6bR5c/4iIi1k/Uek=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=huP3PFCq0PE+WBdf2Rl4vIbpzPPBqFWwjKL+llaBZd6eyedh8K2wwM3jBeNtMZgZU
         VkLxJggxwIvATWGOb6DIVfErvdCSP79IyoKu3YLWW1Xv/VcJpTKNza0obD5WLcDwel
         9ZwpmR+p2dsMCiXOAyR21onjKSPAG8sWF9b3vs8QcIfst9yEGLDgdWuS+rTiX9qSHN
         M/RZ8NkyRL0VpfReT1V05uvDZ2lUISIOauX7zYk+GjoBHzJOlmec+ay1mclNzEw/iC
         TFVocER0czUwQXpc6/DL3lKSnQY2148McVETjTgZNVPPAGJLdWuKrAUk0ODspXjGvb
         wCaaZ5cR07nSA==
Date:   Thu, 25 May 2023 18:34:15 -0700
Subject: [PATCH 1/7] xfs: use i_prev_unlinked to distinguish inodes that are
 not on the unlinked list
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506067244.3737555.3197415134115363631.stgit@frogsfrogsfrogs>
In-Reply-To: <168506067222.3737555.8668637245740627164.stgit@frogsfrogsfrogs>
References: <168506067222.3737555.8668637245740627164.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Alter the definition of i_prev_unlinked slightly to make it more obvious
when an inode with 0 link count is not part of the iunlink bucket lists
rooted in the AGI.  The upcoming directory repair code needs to be able
to make this distinction to decide if a zero link count directory should
be moved to the orphanage or allowed to inactivate.  An upcoming
enhancement to the online AGI fsck code will need this distinction to
check and rebuild the AGI unlinked buckets.

This distinction is necessary because it is not sufficient to check
inode.i_nlink to decide if an inode is on the unlinked list.  Updates to
i_nlink can happen while holding only ILOCK_EXCL, but updates to an
inode's position in the AGI unlinked list (which happen after the nlink
update) requires both ILOCK_EXCL and the AGI buffer lock.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    2 +-
 fs/xfs/xfs_inode.c  |    3 ++-
 fs/xfs/xfs_inode.h  |   20 +++++++++++++++++++-
 3 files changed, 22 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 402f4b22de56..149e4c62b0c3 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -114,7 +114,7 @@ xfs_inode_alloc(
 	INIT_LIST_HEAD(&ip->i_ioend_list);
 	spin_lock_init(&ip->i_ioend_lock);
 	ip->i_next_unlinked = NULLAGINO;
-	ip->i_prev_unlinked = NULLAGINO;
+	ip->i_prev_unlinked = 0;
 
 	return ip;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3af180a917b5..04c4cd6c4cda 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2050,6 +2050,7 @@ xfs_iunlink_insert_inode(
 	}
 
 	/* Point the head of the list to point to this inode. */
+	ip->i_prev_unlinked = NULLAGINO;
 	return xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index, agino);
 }
 
@@ -2152,7 +2153,7 @@ xfs_iunlink_remove_inode(
 	}
 
 	ip->i_next_unlinked = NULLAGINO;
-	ip->i_prev_unlinked = NULLAGINO;
+	ip->i_prev_unlinked = 0;
 	return error;
 }
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 56955f642288..3b8470c2db7b 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -68,8 +68,21 @@ typedef struct xfs_inode {
 	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
 	struct timespec64	i_crtime;	/* time created */
 
-	/* unlinked list pointers */
+	/*
+	 * Unlinked list pointers.  These point to the next and previous inodes
+	 * in the AGI unlinked bucket list, respectively.  These fields can
+	 * only be updated with the AGI locked.
+	 *
+	 * i_next_unlinked caches di_next_unlinked.
+	 */
 	xfs_agino_t		i_next_unlinked;
+
+	/*
+	 * If the inode is not on an unlinked list, this field is zero.  If the
+	 * inode is the first element in an unlinked list, this field is
+	 * NULLAGINO.  Otherwise, i_prev_unlinked points to the previous inode
+	 * in the unlinked list.
+	 */
 	xfs_agino_t		i_prev_unlinked;
 
 	/* VFS inode */
@@ -81,6 +94,11 @@ typedef struct xfs_inode {
 	struct list_head	i_ioend_list;
 } xfs_inode_t;
 
+static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)
+{
+	return ip->i_prev_unlinked != 0;
+}
+
 static inline bool xfs_inode_has_attr_fork(struct xfs_inode *ip)
 {
 	return ip->i_forkoff > 0;

