Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DD5C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235848AbiLaAD0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbiLaADZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:03:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3429F1E3CE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:03:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7CDC61CAD
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33335C433EF;
        Sat, 31 Dec 2022 00:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445003;
        bh=+HYhpZfyYB2vd2wcdhefVJL+KwZ5qWmEuAhBkMWJB4I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ca2bvk0rVNVd3aM+VsiBU7UOMEfPkeXhMK/BpdM+5cK2BvfqjyEamAMF1s96TlBe3
         iY0AW8GPfmkXRdC0KpSyh5QrVGQq3GStFjF+1Hpf/7pHKYp9PofkGuDTWG9h0Dr7nQ
         Niukx+3XQVJgEH+N5MsOuLO6FE3mrr3/H3x/sJ58H0l8u67ReNus0CSoo0Ky7qaLTD
         o+AM5esYIioolW7+CnAxkf3VaKWTSbTieKIiek8dFAjMKBSLSFMtBJzUUpMTVL5Xm1
         gCx1RABaoW0BMKgk1Euc+hDAEgfobNTGOEYs3gtugmHrC9/Avlk6Fnv11ZHyLe33S2
         wdY9f/vD8HeEw==
Subject: [PATCH 1/4] xfs: use i_prev_unlinked to distinguish inodes that are
 not on the unlinked list
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:29 -0800
Message-ID: <167243846924.701054.16997256866884327419.stgit@magnolia>
In-Reply-To: <167243846905.701054.601680294547998738.stgit@magnolia>
References: <167243846905.701054.601680294547998738.stgit@magnolia>
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
rooted in the AGI.  An upcoming enhancement to the online AGI fsck code
will need to make this distinction to check and rebuild the AGI unlinked
buckets.

This distinction is necessary because it is not sufficient to check
xfs_inode.i_nlink to decide if an inode is on the unlinked list.
Updates to i_nlink can happen while holding only ILOCK_EXCL, but updates
to an inode's position in the AGI unlinked list requires both ILOCK_EXCL
and the AGI buffer lock.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    2 +-
 fs/xfs/xfs_inode.c  |    3 ++-
 fs/xfs/xfs_inode.h  |   10 +++++++++-
 3 files changed, 12 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e94c193cd417..06b3de67d791 100644
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
index 85ce54a09d82..3788093fc81d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2143,6 +2143,7 @@ xfs_iunlink_insert_inode(
 	}
 
 	/* Point the head of the list to point to this inode. */
+	ip->i_prev_unlinked = NULLAGINO;
 	return xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index, agino);
 }
 
@@ -2245,7 +2246,7 @@ xfs_iunlink_remove_inode(
 	}
 
 	ip->i_next_unlinked = NULLAGINO;
-	ip->i_prev_unlinked = NULLAGINO;
+	ip->i_prev_unlinked = 0;
 	return error;
 }
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 34f596deb92c..177b027b8803 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -68,7 +68,15 @@ typedef struct xfs_inode {
 	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
 	struct timespec64	i_crtime;	/* time created */
 
-	/* unlinked list pointers */
+	/*
+	 * Unlinked list pointers.  These point to the next and previous inodes
+	 * in the AGI unlinked bucket list, respectively.  These fields can
+	 * only be updated with the AGI locked.
+	 *
+	 * i_next_unlinked reflects di_next_unlinked.  If i_prev_unlinked == 0,
+	 * the inode is not on the unlinked list.  If it is NULLAGINO, an AGI
+	 * bucket points at this inode.
+	 */
 	xfs_agino_t		i_next_unlinked;
 	xfs_agino_t		i_prev_unlinked;
 

