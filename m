Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5771BC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjBPUkr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBPUkq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:40:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F31D1ADE1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:40:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C63960C1A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78AB2C433EF;
        Thu, 16 Feb 2023 20:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580044;
        bh=PrfV13CNEaBOsdBwLC5kZh+ukLsf81WYNp57jNOYIYo=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=M2CPQ9YfQXZtiZ83AU91bMhYHdOhOutH3n92ZFvvl12vAEzFFaD9ByROA4O3GDGI6
         V5I9MVb25dR+LdZQT4YA8nqnNdDDd7EW7Rq1pN/u1UMXye5/mKQeh/JORiR9+2ur3A
         peKfikG18bHbhuGvJ/QG3RBtRV8GbWoQLc/ONnV9IDOP34KrwxH2bjmJOuVz1fun7c
         8FXKLaSXqQWM5NBhfobC09dudexHGJwIHQ7SiDbxKv2IIk5p/gFybG+i6DpqE2SZCT
         yqSofNlBEiSVfcWPiNSWB+JUzDj1PPdNK1k9ly6nNL9OKfeHnYXZl8g5mWfF/7airl
         2g4KTZufzXIbQ==
Date:   Thu, 16 Feb 2023 12:40:44 -0800
Subject: [PATCH 3/3] xfs: don't remove the attr fork when parent pointers are
 enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657873134.3474076.16426437706062736205.stgit@magnolia>
In-Reply-To: <167657873091.3474076.6801004934386808232.stgit@magnolia>
References: <167657873091.3474076.6801004934386808232.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When running generic/388, I observed the following .out.bad output:

_check_xfs_filesystem: filesystem on /dev/sda4 is inconsistent (r)
*** xfs_repair -n output ***
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
mismatch between format (2) and size (276) in symlink ino 37223730
bad data fork in symlink 37223730
would have cleared inode 37223730
        - agno = 2
        - agno = 3
mismatch between format (2) and size (276) in symlink ino 102725435
bad data fork in symlink 102725435
would have cleared inode 102725435
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
unknown block state, ag 1, blocks 458655-458655
unknown block state, ag 3, blocks 257772-257772
        - check for inodes claiming duplicate blocks...
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 0
mismatch between format (2) and size (276) in symlink ino 102725435
bad data fork in symlink 102725435
would have cleared inode 102725435
mismatch between format (2) and size (276) in symlink ino 37223730
bad data fork in symlink 37223730
would have cleared inode 37223730
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
user quota id 0 has bcount 1140448, expected 1140446
user quota id 0 has icount 39892, expected 39890
No modify flag set, skipping filesystem flush and exiting.

Inode 37223730 is an unlinked remote-format symlink with no xattr fork.
According to the inode verifier and xfs_repair, this symlink ought to
have a local format data fork, since 276 bytes is small enough to fit in
the immediate area.

How did we get here?  fsstress removed the symlink, which removed the
last parent pointer xattr.  There were no other xattrs, so that removal
also removed the attr fork.  This transaction got flushed to the log,
but the system went down before we could inactivate the symlink.  Log
recovery tried to inactivate this inode (since it is on the unlinked
list) but the verifier tripped over the remote value and leaked it.

Hence we ended up with a file in this odd state on a "clean" mount.  The
"obvious" fix is to prohibit erasure of the attr fork to avoid tripping
over the verifiers when pptrs are enabled.

I wonder this could be reproduced with normal xattrs and (say) a
directory?  Maybe this fix should target /any/ symlink or directory?

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index beee51ad75ce..e6c4c8b52a55 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -854,7 +854,8 @@ xfs_attr_sf_removename(
 	totsize -= size;
 	if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
-	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE))) {
+	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE)) &&
+	    !xfs_has_parent(mp)) {
 		xfs_attr_fork_remove(dp, args->trans);
 	} else {
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
@@ -863,7 +864,8 @@ xfs_attr_sf_removename(
 		ASSERT(totsize > sizeof(xfs_attr_sf_hdr_t) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
 				!xfs_has_attr2(mp) ||
-				dp->i_df.if_format == XFS_DINODE_FMT_BTREE);
+				dp->i_df.if_format == XFS_DINODE_FMT_BTREE ||
+				xfs_has_parent(mp));
 		xfs_trans_log_inode(args->trans, dp,
 					XFS_ILOG_CORE | XFS_ILOG_ADATA);
 	}

