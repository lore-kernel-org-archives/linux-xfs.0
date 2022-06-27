Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD43C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 00:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiF0Ann (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 20:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiF0Anm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 20:43:42 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4CFB52DE3
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 17:43:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8BF6D5ECB52
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 10:43:39 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5cqo-00BTzg-Cx
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 10:43:38 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5cqo-000uaC-Bd
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 10:43:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/9] xfs: track the iunlink list pointer in the xfs_inode
Date:   Mon, 27 Jun 2022 10:43:29 +1000
Message-Id: <20220627004336.217366-3-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627004336.217366-1-david@fromorbit.com>
References: <20220627004336.217366-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62b8fd3b
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=dG43qa4CsSl2A0r3zAsA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Having direct access to the i_next_unlinked pointer in unlinked
inodes greatly simplifies the processing of inodes on the unlinked
list. We no longer need to look up the inode buffer just to find
next inode in the list if the xfs_inode is in memory. These
improvements will be realised over upcoming patches as other
dependencies on the inode buffer for unlinked list processing are
removed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |  3 ++-
 fs/xfs/xfs_inode.c            |  5 ++++-
 fs/xfs/xfs_inode.h            |  3 +++
 fs/xfs/xfs_log_recover.c      | 16 +---------------
 4 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 3b1b63f9d886..d05a3294020a 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -230,7 +230,8 @@ xfs_inode_from_disk(
 	ip->i_nblocks = be64_to_cpu(from->di_nblocks);
 	ip->i_extsize = be32_to_cpu(from->di_extsize);
 	ip->i_forkoff = from->di_forkoff;
-	ip->i_diflags	= be16_to_cpu(from->di_flags);
+	ip->i_diflags = be16_to_cpu(from->di_flags);
+	ip->i_next_unlinked = be32_to_cpu(from->di_next_unlinked);
 
 	if (from->di_dmevmask || from->di_dmstate)
 		xfs_iflags_set(ip, XFS_IPRESERVE_DM_FIELDS);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2a371c3431c9..c507370bd885 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2098,7 +2098,8 @@ xfs_iunlink_update_inode(
 
 	/* Make sure the old pointer isn't garbage. */
 	old_value = be32_to_cpu(dip->di_next_unlinked);
-	if (!xfs_verify_agino_or_null(mp, pag->pag_agno, old_value)) {
+	if (old_value != ip->i_next_unlinked ||
+	    !xfs_verify_agino_or_null(mp, pag->pag_agno, old_value)) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
 				sizeof(*dip), __this_address);
 		error = -EFSCORRUPTED;
@@ -2167,6 +2168,7 @@ xfs_iunlink_insert_inode(
 		if (error)
 			return error;
 		ASSERT(old_agino == NULLAGINO);
+		ip->i_next_unlinked = next_agino;
 
 		/*
 		 * agino has been unlinked, add a backref from the next inode
@@ -2366,6 +2368,7 @@ xfs_iunlink_remove_inode(
 	error = xfs_iunlink_update_inode(tp, ip, pag, NULLAGINO, &next_agino);
 	if (error)
 		return error;
+	ip->i_next_unlinked = NULLAGINO;
 
 	/*
 	 * If there was a backref pointing from the next inode back to this
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 7be6f8e705ab..8e2a33c6cbe2 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -68,6 +68,9 @@ typedef struct xfs_inode {
 	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
 	struct timespec64	i_crtime;	/* time created */
 
+	/* unlinked list pointers */
+	xfs_agino_t		i_next_unlinked;
+
 	/* VFS inode */
 	struct inode		i_vnode;	/* embedded VFS inode */
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5f7e4e6e33ce..f360b46533a6 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2673,8 +2673,6 @@ xlog_recover_process_one_iunlink(
 	xfs_agino_t			agino,
 	int				bucket)
 {
-	struct xfs_buf			*ibp;
-	struct xfs_dinode		*dip;
 	struct xfs_inode		*ip;
 	xfs_ino_t			ino;
 	int				error;
@@ -2684,27 +2682,15 @@ xlog_recover_process_one_iunlink(
 	if (error)
 		goto fail;
 
-	/*
-	 * Get the on disk inode to find the next inode in the bucket.
-	 */
-	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &ibp);
-	if (error)
-		goto fail_iput;
-	dip = xfs_buf_offset(ibp, ip->i_imap.im_boffset);
-
 	xfs_iflags_clear(ip, XFS_IRECOVERY);
 	ASSERT(VFS_I(ip)->i_nlink == 0);
 	ASSERT(VFS_I(ip)->i_mode != 0);
 
 	/* setup for the next pass */
-	agino = be32_to_cpu(dip->di_next_unlinked);
-	xfs_buf_relse(ibp);
-
+	agino = ip->i_next_unlinked;
 	xfs_irele(ip);
 	return agino;
 
- fail_iput:
-	xfs_irele(ip);
  fail:
 	/*
 	 * We can't read in the inode this bucket points to, or this inode
-- 
2.36.1

