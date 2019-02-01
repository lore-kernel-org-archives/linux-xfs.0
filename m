Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46982 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726972AbfBAOc5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Feb 2019 09:32:57 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B425D5D61C
        for <linux-xfs@vger.kernel.org>; Fri,  1 Feb 2019 14:32:57 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C0965D9D1
        for <linux-xfs@vger.kernel.org>; Fri,  1 Feb 2019 14:32:57 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 2/6] xfs: update fork seq counter on data fork changes
Date: Fri,  1 Feb 2019 09:32:52 -0500
Message-Id: <20190201143256.43232-3-bfoster@redhat.com>
In-Reply-To: <20190201143256.43232-1-bfoster@redhat.com>
References: <20190201143256.43232-1-bfoster@redhat.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
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
