Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933500AbdHYPGA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Aug 2017 11:06:00 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C256A80E7A
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 15:05:59 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A62026E502
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 15:05:59 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 6/9] xfs: skip bmbt block ino validation during owner change
Date: Fri, 25 Aug 2017 11:05:54 -0400
Message-Id: <20170825150557.43010-7-bfoster@redhat.com>
In-Reply-To: <20170825150557.43010-1-bfoster@redhat.com>
References: <20170825150557.43010-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Extent swap uses xfs_btree_visit_blocks() to fix up bmbt block
owners on v5 (!rmapbt) filesystems. The bmbt scan uses
xfs_btree_lookup_get_block() to read bmbt blocks which verifies the
current owner of the block against the parent inode of the bmbt.
This works during extent swap because the bmbt owners are updated to
the opposite inode number before the inode extent forks are swapped.

The modified bmbt blocks are marked as ordered buffers which allows
everything to commit in a single transaction. If the transaction
commits to the log and the system crashes such that recovery of the
extent swap is required, log recovery restarts the bmbt scan to fix
up any bmbt blocks that may have not been written back before the
crash. The log recovery bmbt scan occurs after the inode forks have
been swapped, however. This causes the bmbt block owner verification
to fail, leads to log recovery failure and requires xfs_repair to
zap the log to recover.

Define a new invalid inode owner flag to inform the btree block
lookup mechanism that the current inode may be invalid with respect
to the current owner of the bmbt block. Set this flag on the cursor
used for change owner scans to allow this operation to work at
runtime and during log recovery.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap_btree.c | 1 +
 fs/xfs/libxfs/xfs_btree.c      | 1 +
 fs/xfs/libxfs/xfs_btree.h      | 3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 85de225..6f05995 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -858,6 +858,7 @@ xfs_bmbt_change_owner(
 	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
 	if (!cur)
 		return -ENOMEM;
+	cur->bc_private.b.flags |= XFS_BTCUR_BPRV_INVALIDINO;
 
 	error = xfs_btree_change_owner(cur, new_owner, buffer_list);
 	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 0b7905a..d06b04d 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1791,6 +1791,7 @@ xfs_btree_lookup_get_block(
 
 	/* Check the inode owner since the verifiers don't. */
 	if (xfs_sb_version_hascrc(&cur->bc_mp->m_sb) &&
+	    !(cur->bc_private.b.flags & XFS_BTCUR_BPRV_INVALIDINO) &&
 	    (cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
 	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
 			cur->bc_private.b.ip->i_ino)
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 9c95e96..c803ddc 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -233,7 +233,8 @@ typedef struct xfs_btree_cur
 			short		forksize;	/* fork's inode space */
 			char		whichfork;	/* data or attr fork */
 			char		flags;		/* flags */
-#define	XFS_BTCUR_BPRV_WASDEL	1			/* was delayed */
+#define	XFS_BTCUR_BPRV_WASDEL		(1<<0)		/* was delayed */
+#define	XFS_BTCUR_BPRV_INVALIDINO	(1<<1)		/* for ext swap */
 		} b;
 	}		bc_private;	/* per-btree type data */
 } xfs_btree_cur_t;
-- 
2.9.5

