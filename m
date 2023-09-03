Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94A1C71153
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Sep 2023 16:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244593AbjICQQA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Sep 2023 12:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237525AbjICQP7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2023 12:15:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B656FE
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2023 09:15:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 201A8B80CBC
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2023 16:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0850C433C8;
        Sun,  3 Sep 2023 16:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693757753;
        bh=kX4HjjOlhHvSfAJGEjhU20SCloKVFQtqpwSPJx8FQDE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EJDbXcu74cfZR3X1hQUSBpW905MehSQ9a6TAs9Yvu6X+H7GbbsbkKo3sd/ST0vVzD
         LnjJuJ5JyKuhfYKt+brDJCYXVGVNFarZHsPNjIMr+Qcnoa95oSm0+hEj1jaxUgFXGw
         +2iUKo+BcYtKmQwsI1+gWX/PmBr39pG8LncDH3k3YKM51mFqFz/7+hepNuMd1OyWTD
         lK2ybJCCYVvhSoo/KtDhu7WlWNrnFBRhY1/6POtzOB7Le+gWAnRwfhGptcuMrEF+q5
         6wMbZxc0X0znScZnJE2jMMeeixNN4I6AFFOoLMRmyDy1yk3eeVjW1LN2xOZ2CK35v2
         58L3CT/CWh69w==
Subject: [PATCH 1/3] xfs: use i_prev_unlinked to distinguish inodes that are
 not on the unlinked list
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Sun, 03 Sep 2023 09:15:53 -0700
Message-ID: <169375775334.3323693.5974014335978928981.stgit@frogsfrogsfrogs>
In-Reply-To: <169375774749.3323693.18063212270653101716.stgit@frogsfrogsfrogs>
References: <169375774749.3323693.18063212270653101716.stgit@frogsfrogsfrogs>
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
rooted in the AGI.  This distinction is necessary because it is not
sufficient to check inode.i_nlink to decide if an inode is on the
unlinked list.  Updates to i_nlink can happen while holding only
ILOCK_EXCL, but updates to an inode's position in the AGI unlinked list
(which happen after the nlink update) requires both ILOCK_EXCL and the
AGI buffer lock.

The next few patches will make it possible to reload an entire unlinked
bucket list when we're walking the inode table or performing handle
operations and need more than the ability to iget the last inode in the
chain.

The upcoming directory repair code also needs to be able to make this
distinction to decide if a zero link count directory should be moved to
the orphanage or allowed to inactivate.  An upcoming enhancement to the
online AGI fsck code will need this distinction to check and rebuild the
AGI unlinked buckets.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    2 +-
 fs/xfs/xfs_inode.c  |    3 ++-
 fs/xfs/xfs_inode.h  |   20 +++++++++++++++++++-
 3 files changed, 22 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 30d7454a9b93..3c210ac83713 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -113,7 +113,7 @@ xfs_inode_alloc(
 	INIT_LIST_HEAD(&ip->i_ioend_list);
 	spin_lock_init(&ip->i_ioend_lock);
 	ip->i_next_unlinked = NULLAGINO;
-	ip->i_prev_unlinked = NULLAGINO;
+	ip->i_prev_unlinked = 0;
 
 	return ip;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3e3df3d8bcdd..6cd2f29b540a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2015,6 +2015,7 @@ xfs_iunlink_insert_inode(
 	}
 
 	/* Point the head of the list to point to this inode. */
+	ip->i_prev_unlinked = NULLAGINO;
 	return xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index, agino);
 }
 
@@ -2117,7 +2118,7 @@ xfs_iunlink_remove_inode(
 	}
 
 	ip->i_next_unlinked = NULLAGINO;
-	ip->i_prev_unlinked = NULLAGINO;
+	ip->i_prev_unlinked = 0;
 	return error;
 }
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 7547caf2f2ab..65aae8925509 100644
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

