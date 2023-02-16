Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B35C5C6379F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjBPVBI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjBPVBI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:01:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76D8505E5
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:01:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76D04B82962
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB3FC433EF;
        Thu, 16 Feb 2023 21:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581264;
        bh=TmSfSTkU+atxB1+XLNFJ+JmXNa/5JRppVl3vzzG6hYU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=WTlt9cr5IDQG18JEOEoxs3G8YfEdrCq5XwtBuxaLTec62pbZRp7lImR+CWopvkcPs
         fgjj6j+UGKTzS4xvsBpcbP+Ynmx60KpLtsEWSzDZhbr8tVDqPL9N7gqdHnwfmBce9p
         DXcyqzRF4Nw+ZAvMPv5klYLcPxPNpbc41aH7btdevqfFX2RFrqUz2AmgmhuZ1U4prE
         ru/rnQQwAL5IgwBnVckUbbutggWg0iTeSUoUcYu+cw7Uu/CKmhHG/bPc8Oxc8uSVV+
         PeJ8jHQZzLA0UYCQfNfxS2jWYyCe1KMK2ceZPvK7O/CApZ+rICeVUMi1LaeT71yNWx
         l2k9RztyqO+YA==
Date:   Thu, 16 Feb 2023 13:01:03 -0800
Subject: [PATCH 4/6] xfs: don't remove the attr fork when parent pointers are
 enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879587.3476725.1856410589948339842.stgit@magnolia>
In-Reply-To: <167657879533.3476725.4672667573997149436.stgit@magnolia>
References: <167657879533.3476725.4672667573997149436.stgit@magnolia>
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
 libxfs/xfs_attr_leaf.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 6cac2531..6391f6ab 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -851,7 +851,8 @@ xfs_attr_sf_removename(
 	totsize -= size;
 	if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
-	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE))) {
+	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE)) &&
+	    !xfs_has_parent(mp)) {
 		xfs_attr_fork_remove(dp, args->trans);
 	} else {
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
@@ -860,7 +861,8 @@ xfs_attr_sf_removename(
 		ASSERT(totsize > sizeof(xfs_attr_sf_hdr_t) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
 				!xfs_has_attr2(mp) ||
-				dp->i_df.if_format == XFS_DINODE_FMT_BTREE);
+				dp->i_df.if_format == XFS_DINODE_FMT_BTREE ||
+				xfs_has_parent(mp));
 		xfs_trans_log_inode(args->trans, dp,
 					XFS_ILOG_CORE | XFS_ILOG_ADATA);
 	}

