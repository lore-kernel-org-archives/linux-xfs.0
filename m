Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40758 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751551AbeFVVVd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 17:21:33 -0400
Date: Fri, 22 Jun 2018 14:21:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 4/8] xfs: don't allow insert-range to shift extents past
 the maximum offset
Message-ID: <20180622212104.GT4838@magnolia>
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
 <152960588873.26246.17582272219031862067.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152960588873.26246.17582272219031862067.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Allison Henderson <allison.henderson@oracle.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Zorro Lang reports that generic/485 blows an assert on a filesystem with
512 byte blocks.  The test tries to fallocate a post-eof extent at the
maximum file size and calls insert range to shift the extents right by
two blocks.  On a 512b block filesystem this causes startoff to overflow
the 54-bit startoff field, leading to the assert.

Therefore, always check the rightmost extent to see if it would overflow
prior to invoking the insert range machinery.

Reported-by: zlang@redhat.com
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=200137
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
v2: use xfs_bmap_last_extent, move macro defs to headers
---
 fs/xfs/libxfs/xfs_bmap.c   |   26 ++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h   |    2 ++
 fs/xfs/libxfs/xfs_format.h |    2 ++
 fs/xfs/xfs_bmap_util.c     |    4 ++++
 4 files changed, 34 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 01628f0c9a0c..7205268b30bc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5780,6 +5780,32 @@ xfs_bmap_collapse_extents(
 	return error;
 }
 
+/* Make sure we won't be right-shifting an extent past the maximum bound. */
+int
+xfs_bmap_can_insert_extents(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		off,
+	xfs_fileoff_t		shift)
+{
+	struct xfs_bmbt_irec	got;
+	int			is_empty;
+	int			error = 0;
+
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return -EIO;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	error = xfs_bmap_last_extent(NULL, ip, XFS_DATA_FORK, &got, &is_empty);
+	if (!error && !is_empty && got.br_startoff >= off &&
+	    ((got.br_startoff + shift) & BMBT_STARTOFF_MASK) < got.br_startoff)
+		error = -EINVAL;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	return error;
+}
+
 int
 xfs_bmap_insert_extents(
 	struct xfs_trans	*tp,
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 99dddbd0fcc6..9b49ddf99c41 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -227,6 +227,8 @@ int	xfs_bmap_collapse_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
 		bool *done, xfs_fsblock_t *firstblock,
 		struct xfs_defer_ops *dfops);
+int	xfs_bmap_can_insert_extents(struct xfs_inode *ip, xfs_fileoff_t off,
+		xfs_fileoff_t shift);
 int	xfs_bmap_insert_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
 		bool *done, xfs_fileoff_t stop_fsb, xfs_fsblock_t *firstblock,
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 7b4a43deb83e..059bc44c27e8 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1529,6 +1529,8 @@ typedef struct xfs_bmdr_block {
 #define BMBT_STARTBLOCK_BITLEN	52
 #define BMBT_BLOCKCOUNT_BITLEN	21
 
+#define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
+
 typedef struct xfs_bmbt_rec {
 	__be64			l0, l1;
 } xfs_bmbt_rec_t;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index c195b9d857af..bb417156e3bf 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1383,6 +1383,10 @@ xfs_insert_file_space(
 
 	trace_xfs_insert_file_space(ip);
 
+	error = xfs_bmap_can_insert_extents(ip, stop_fsb, shift_fsb);
+	if (error)
+		return error;
+
 	error = xfs_prepare_shift(ip, offset);
 	if (error)
 		return error;
