Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59470 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727401AbfAKMae (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Jan 2019 07:30:34 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 17BD15F758
        for <linux-xfs@vger.kernel.org>; Fri, 11 Jan 2019 12:30:34 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFC905C25A
        for <linux-xfs@vger.kernel.org>; Fri, 11 Jan 2019 12:30:33 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/4] xfs: update fork seq counter on data fork changes
Date: Fri, 11 Jan 2019 07:30:30 -0500
Message-Id: <20190111123032.31538-3-bfoster@redhat.com>
In-Reply-To: <20190111123032.31538-1-bfoster@redhat.com>
References: <20190111123032.31538-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The sequence counter in the xfs_ifork structure is only updated on
COW forks. This is because the counter is currently only used to
optimize out repetitive COW fork checks at writeback time.

Tweak the extent code to update the seq counter regardless of the
fork type in preparation for using this counter on data forks as
well.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_iext_tree.c  | 13 ++++++-------
 fs/xfs/libxfs/xfs_inode_fork.h |  2 +-
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 771dd072015d..bc690f2409fa 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -614,16 +614,15 @@ xfs_iext_realloc_root(
 }
 
 /*
- * Increment the sequence counter if we are on a COW fork.  This allows
- * the writeback code to skip looking for a COW extent if the COW fork
- * hasn't changed.  We use WRITE_ONCE here to ensure the update to the
- * sequence counter is seen before the modifications to the extent
- * tree itself take effect.
+ * Increment the sequence counter on extent tree changes. If we are on a COW
+ * fork, this allows the writeback code to skip looking for a COW extent if the
+ * COW fork hasn't changed. We use WRITE_ONCE here to ensure the update to the
+ * sequence counter is seen before the modifications to the extent tree itself
+ * take effect.
  */
 static inline void xfs_iext_inc_seq(struct xfs_ifork *ifp, int state)
 {
-	if (state & BMAP_COWFORK)
-		WRITE_ONCE(ifp->if_seq, READ_ONCE(ifp->if_seq) + 1);
+	WRITE_ONCE(ifp->if_seq, READ_ONCE(ifp->if_seq) + 1);
 }
 
 void
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 60361d2d74a1..00c62ce170d0 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -14,7 +14,7 @@ struct xfs_dinode;
  */
 struct xfs_ifork {
 	int			if_bytes;	/* bytes in if_u1 */
-	unsigned int		if_seq;		/* cow fork mod counter */
+	unsigned int		if_seq;		/* fork mod counter */
 	struct xfs_btree_block	*if_broot;	/* file's incore btree root */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	unsigned char		if_flags;	/* per-fork flags */
-- 
2.17.2
