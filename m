Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51064 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751167AbdFCNL7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:11:59 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/23] xfs: xfs_trans_alloc_empty
Date: Sat,  3 Jun 2017 15:10:57 +0200
Message-Id: <20170603131103.23712-18-hch@lst.de>
In-Reply-To: <20170603131103.23712-1-hch@lst.de>
References: <20170603131103.23712-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

This is a partial cherry-pick of commit e89c041338
("xfs: implement the GETFSMAP ioctl"), which also adds this helper, and
a great example of why feature patches should be properly split into
their parts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch: split from the larger patch for -stable]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans.c | 22 ++++++++++++++++++++++
 fs/xfs/xfs_trans.h |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 70f42ea86dfb..a280e126491f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -263,6 +263,28 @@ xfs_trans_alloc(
 }
 
 /*
+ * Create an empty transaction with no reservation.  This is a defensive
+ * mechanism for routines that query metadata without actually modifying
+ * them -- if the metadata being queried is somehow cross-linked (think a
+ * btree block pointer that points higher in the tree), we risk deadlock.
+ * However, blocks grabbed as part of a transaction can be re-grabbed.
+ * The verifiers will notice the corrupt block and the operation will fail
+ * back to userspace without deadlocking.
+ *
+ * Note the zero-length reservation; this transaction MUST be cancelled
+ * without any dirty data.
+ */
+int
+xfs_trans_alloc_empty(
+	struct xfs_mount		*mp,
+	struct xfs_trans		**tpp)
+{
+	struct xfs_trans_res		resv = {0};
+
+	return xfs_trans_alloc(mp, &resv, 0, 0, XFS_TRANS_NO_WRITECOUNT, tpp);
+}
+
+/*
  * Record the indicated change to the given field for application
  * to the file system's superblock when the transaction commits.
  * For now, just store the change in the transaction structure.
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 1646f659b60f..2a9292df6640 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -158,6 +158,8 @@ typedef struct xfs_trans {
 int		xfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
 			uint blocks, uint rtextents, uint flags,
 			struct xfs_trans **tpp);
+int		xfs_trans_alloc_empty(struct xfs_mount *mp,
+			struct xfs_trans **tpp);
 void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
 
 struct xfs_buf	*xfs_trans_get_buf_map(struct xfs_trans *tp,
-- 
2.11.0

