Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32820 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753890AbdFEQdu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2017 12:33:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.11 112/115] xfs: xfs_trans_alloc_empty
Date: Mon,  5 Jun 2017 18:18:25 +0200
Message-Id: <20170605153102.219732457@linuxfoundation.org>
In-Reply-To: <20170605153056.650217313@linuxfoundation.org>
References: <20170605153056.650217313@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>

4.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

This is a partial cherry-pick of commit e89c041338
("xfs: implement the GETFSMAP ioctl"), which also adds this helper, and
a great example of why feature patches should be properly split into
their parts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch: split from the larger patch for -stable]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans.c |   22 ++++++++++++++++++++++
 fs/xfs/xfs_trans.h |    2 ++
 2 files changed, 24 insertions(+)

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


