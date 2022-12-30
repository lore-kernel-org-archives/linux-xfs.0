Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A235C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbiL3WkA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3Wj7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:39:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDAE186E8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:39:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FD93B81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78CCC433EF;
        Fri, 30 Dec 2022 22:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439995;
        bh=yRKZQHxMxx7TkwVcvZwG73aBA2sDaQ3D/X6TZV34u3U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=X+OY4nYg+vc3bB+p+M9i2FlTUjm2tK0yrP12PHrgMi+6t7pia/bm9M/rrbWOdJunA
         t6K4GRSlxrQwdo8yBsb+dHHvQ0Y3HgcA3CoUDQ8TsCHYA5wO66Y9Jwo5ce7UBmbKxm
         KYItuI5J+rwzdNhjyL2cox2j5Fct3aVP4WSvkUnertgXgrBo37Og6UNk1gi7JbfU1q
         fZgqQjnRMpimTJ6R6v+3qf/tYa9pP+6FaQAY8l+ihNkiz00ocjADLExQEaQQYPLxuv
         ujuW+HnDRQWJM+JzHMZ7wJWlj21eTwnt0sTzXd2JTYiQLwF/w2YV9tF0UYs1CVV7AU
         J3tlUI0Wc6cyQ==
Subject: [PATCH 8/8] xfs: complain about bad file mapping records in the
 ondisk bmbt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:12 -0800
Message-ID: <167243827245.683855.6704050615433941645.stgit@magnolia>
In-Reply-To: <167243827121.683855.6049797551028464473.stgit@magnolia>
References: <167243827121.683855.6049797551028464473.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Similar to what we've just done for the other btrees, create a function
to log corrupt bmbt records and call it whenever we encounter a bad
record in the ondisk btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c       |   31 ++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_bmap.h       |    2 ++
 fs/xfs/libxfs/xfs_inode_fork.c |    3 ++-
 3 files changed, 34 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 45dfa5a56154..d9083cbeb20e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1099,6 +1099,34 @@ struct xfs_iread_state {
 	xfs_extnum_t		loaded;
 };
 
+int
+xfs_bmap_complain_bad_rec(
+	struct xfs_inode		*ip,
+	int				whichfork,
+	xfs_failaddr_t			fa,
+	const struct xfs_bmbt_irec	*irec)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	const char			*forkname;
+
+	switch (whichfork) {
+	case XFS_DATA_FORK:	forkname = "data"; break;
+	case XFS_ATTR_FORK:	forkname = "attr"; break;
+	case XFS_COW_FORK:	forkname = "CoW"; break;
+	default:		forkname = "???"; break;
+	}
+
+	xfs_warn(mp,
+ "Bmap BTree record corruption in inode 0x%llx %s fork detected at %pS!",
+				ip->i_ino, forkname, fa);
+	xfs_warn(mp,
+		"Offset 0x%llx, start block 0x%llx, block count 0x%llx state 0x%x",
+		irec->br_startoff, irec->br_startblock, irec->br_blockcount,
+		irec->br_state);
+
+	return -EFSCORRUPTED;
+}
+
 /* Stuff every bmbt record from this block into the incore extent map. */
 static int
 xfs_iread_bmbt_block(
@@ -1141,7 +1169,8 @@ xfs_iread_bmbt_block(
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 					"xfs_iread_extents(2)", frp,
 					sizeof(*frp), fa);
-			return -EFSCORRUPTED;
+			return xfs_bmap_complain_bad_rec(ip, whichfork, fa,
+					&new);
 		}
 		xfs_iext_insert(ip, &ir->icur, &new,
 				xfs_bmap_fork_to_state(whichfork));
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 0cd86781fcd5..7af24f2ef8a2 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -258,6 +258,8 @@ static inline uint32_t xfs_bmap_fork_to_state(int whichfork)
 
 xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *irec);
+int xfs_bmap_complain_bad_rec(struct xfs_inode *ip, int whichfork,
+		xfs_failaddr_t fa, const struct xfs_bmbt_irec *irec);
 
 int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 6b21760184d9..ff37eecec4b0 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -140,7 +140,8 @@ xfs_iformat_extents(
 				xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 						"xfs_iformat_extents(2)",
 						dp, sizeof(*dp), fa);
-				return -EFSCORRUPTED;
+				return xfs_bmap_complain_bad_rec(ip, whichfork,
+						fa, &new);
 			}
 
 			xfs_iext_insert(ip, &icur, &new, state);

