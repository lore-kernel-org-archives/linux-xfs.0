Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60402 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729239AbfAKMaf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Jan 2019 07:30:35 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7B19979709
        for <linux-xfs@vger.kernel.org>; Fri, 11 Jan 2019 12:30:34 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30AFE5C25A
        for <linux-xfs@vger.kernel.org>; Fri, 11 Jan 2019 12:30:34 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/4] xfs: validate writeback mapping using data fork seq counter
Date: Fri, 11 Jan 2019 07:30:31 -0500
Message-Id: <20190111123032.31538-4-bfoster@redhat.com>
In-Reply-To: <20190111123032.31538-1-bfoster@redhat.com>
References: <20190111123032.31538-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The writeback code caches the current extent mapping across multiple
xfs_do_writepage() calls to avoid repeated lookups for sequential
pages backed by the same extent. This is known to be slightly racy
with extent fork changes in certain difficult to reproduce
scenarios. The cached extent is trimmed to within EOF to help avoid
the most common vector for this problem via speculative
preallocation management, but this is a band-aid that does not
address the fundamental problem.

Now that we have an xfs_ifork sequence counter mechanism used to
facilitate COW writeback, we can use the same mechanism to validate
consistency between the data fork and cached writeback mappings. On
its face, this is somewhat of a big hammer approach because any
change to the data fork invalidates any mapping currently cached by
a writeback in progress regardless of whether the data fork change
overlaps with the range under writeback. In practice, however, the
impact of this approach is minimal in most cases.

First, data fork changes (delayed allocations) caused by sustained
sequential buffered writes are amortized across speculative
preallocations. This means that a cached mapping won't be
invalidated by each buffered write of a common file copy workload,
but rather only on less frequent allocation events. Second, the
extent tree is always entirely in-core so an additional lookup of a
usable extent mostly costs a shared ilock cycle and in-memory tree
lookup. This means that a cached mapping reval is relatively cheap
compared to the I/O itself. Third, spurious invalidations don't
impact ioend construction. This means that even if the same extent
is revalidated multiple times across multiple writepage instances,
we still construct and submit the same size ioend (and bio) if the
blocks are physically contiguous.

Update struct xfs_writepage_ctx with a new field to hold the
sequence number of the data fork associated with the currently
cached mapping. Check the wpc seqno against the data fork when the
mapping is validated and reestablish the mapping whenever the fork
has changed since the mapping was cached. This ensures that
writeback always uses a valid extent mapping and thus prevents lost
writebacks and stale delalloc block problems.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_aops.c  | 8 ++++++--
 fs/xfs/xfs_iomap.c | 4 ++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index d9048bcea49c..33a1be5df99f 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -29,6 +29,7 @@
 struct xfs_writepage_ctx {
 	struct xfs_bmbt_irec    imap;
 	unsigned int		io_type;
+	unsigned int		data_seq;
 	unsigned int		cow_seq;
 	struct xfs_ioend	*ioend;
 };
@@ -347,7 +348,8 @@ xfs_map_blocks(
 	 * out that ensures that we always see the current value.
 	 */
 	imap_valid = offset_fsb >= wpc->imap.br_startoff &&
-		     offset_fsb < wpc->imap.br_startoff + wpc->imap.br_blockcount;
+		     offset_fsb < wpc->imap.br_startoff + wpc->imap.br_blockcount &&
+		     wpc->data_seq == READ_ONCE(ip->i_df.if_seq);
 	if (imap_valid &&
 	    (!xfs_inode_has_cow_data(ip) ||
 	     wpc->io_type == XFS_IO_COW ||
@@ -417,6 +419,7 @@ xfs_map_blocks(
 	 */
 	if (!xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &icur, &imap))
 		imap.br_startoff = end_fsb;	/* fake a hole past EOF */
+	wpc->data_seq = READ_ONCE(ip->i_df.if_seq);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	if (imap.br_startoff > offset_fsb) {
@@ -454,7 +457,8 @@ xfs_map_blocks(
 	return 0;
 allocate_blocks:
 	error = xfs_iomap_write_allocate(ip, whichfork, offset, &imap,
-			&wpc->cow_seq);
+			whichfork == XFS_COW_FORK ?
+					 &wpc->cow_seq : &wpc->data_seq);
 	if (error)
 		return error;
 	ASSERT(whichfork == XFS_COW_FORK || cow_fsb == NULLFILEOFF ||
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 27c93b5f029d..0401e33d4e8f 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -681,7 +681,7 @@ xfs_iomap_write_allocate(
 	int		whichfork,
 	xfs_off_t	offset,
 	xfs_bmbt_irec_t *imap,
-	unsigned int	*cow_seq)
+	unsigned int	*seq)
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	struct xfs_ifork *ifp = XFS_IFORK_PTR(ip, whichfork);
@@ -798,7 +798,7 @@ xfs_iomap_write_allocate(
 				goto error0;
 
 			if (whichfork == XFS_COW_FORK)
-				*cow_seq = READ_ONCE(ifp->if_seq);
+				*seq = READ_ONCE(ifp->if_seq);
 			xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		}
 
-- 
2.17.2
