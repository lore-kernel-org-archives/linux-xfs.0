Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933227AbdCGUlC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Mar 2017 15:41:02 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AED13804FE
        for <linux-xfs@vger.kernel.org>; Tue,  7 Mar 2017 15:15:04 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3] xfs: use iomap new flag for newly allocated delalloc blocks
Date: Tue,  7 Mar 2017 10:15:01 -0500
Message-Id: <1488899701-11051-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Xiong Zhou <xzhou@redhat.com>

Commit fa7f138 ("xfs: clear delalloc and cache on buffered write
failure") fixed one regression in the iomap error handling code and
exposed another. The fundamental problem is that if a buffered write
is a rewrite of preexisting delalloc blocks and the write fails, the
failure handling code can punch out preexisting blocks with valid
file data.

This was reproduced directly by sub-block writes in the LTP
kernel/syscalls/write/write03 test. A first 100 byte write allocates
a single block in a file. A subsequent 100 byte write fails and
punches out the block, including the data successfully written by
the previous write.

To address this problem, update the ->iomap_begin() handler to
distinguish newly allocated delalloc blocks from preexisting
delalloc blocks via the IOMAP_F_NEW flag. Use this flag in the
->iomap_end() handler to decide when a failed or short write should
punch out delalloc blocks.

This introduces the subtle requirement that ->iomap_begin() should
never combine newly allocated delalloc blocks with existing blocks
in the resulting iomap descriptor. This can occur when a new
delalloc reservation merges with a neighboring extent that is part
of the current write, for example. Therefore, update
xfs_bmapi_reserve_delalloc() to conditionally return the allocated
record along with the updated 'got' record and map the former into
the iomap.  This ensures that preexisting delalloc blocks are always
handled as "found" blocks and not punched out on a failed rewrite.

Reported-by: Xiong Zhou <xzhou@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v3
- Add params around IOMAP_F_NEW check.
- Add comment for xfs_bmapi_reserve_delalloc().
v2: http://www.spinics.net/lists/linux-xfs/msg04685.html
- Use arec param rather than bmapi flag in xfs_bmapi_reserve_delalloc().
v1: http://www.spinics.net/lists/linux-xfs/msg04604.html

 fs/xfs/libxfs/xfs_bmap.c | 20 +++++++++++++++++++-
 fs/xfs/libxfs/xfs_bmap.h |  3 ++-
 fs/xfs/xfs_iomap.c       | 34 +++++++++++++++++++++++++---------
 fs/xfs/xfs_reflink.c     |  2 +-
 4 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a9c66d4..35426aa 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4150,6 +4150,20 @@ xfs_bmapi_read(
 	return 0;
 }
 
+/*
+ * Add a delayed allocation extent to an inode. Blocks are reserved from the
+ * global pool and the extent inserted into the inode in-core extent tree.
+ *
+ * On entry, got refers to the first extent beyond the offset of the extent to
+ * allocate or eof is specified if no such extent exists. On return, got refers
+ * to the post-allocation extent, which may have been merged with contiguous
+ * extents. If specified, the optional arec output parameter is populated with
+ * only the newly allocated portion of the extent. arec may refer to a subset of
+ * the extent in the inode. It is useful for callers that must distinguish newly
+ * allocated blocks from preexisting delalloc blocks within the range of the
+ * allocation request (in order to properly handle buffered write failure, for
+ * example).
+ */
 int
 xfs_bmapi_reserve_delalloc(
 	struct xfs_inode	*ip,
@@ -4159,7 +4173,8 @@ xfs_bmapi_reserve_delalloc(
 	xfs_filblks_t		prealloc,
 	struct xfs_bmbt_irec	*got,
 	xfs_extnum_t		*lastx,
-	int			eof)
+	int			eof,
+	struct xfs_bmbt_irec	*arec)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
@@ -4236,6 +4251,9 @@ xfs_bmapi_reserve_delalloc(
 	got->br_startblock = nullstartblock(indlen);
 	got->br_blockcount = alen;
 	got->br_state = XFS_EXT_NORM;
+	if (arec)
+		*arec = *got;
+
 	xfs_bmap_add_extent_hole_delay(ip, whichfork, lastx, got);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index cdef87d..c61f2a7 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -243,7 +243,8 @@ int	xfs_bmap_shift_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
 int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
-		struct xfs_bmbt_irec *got, xfs_extnum_t *lastx, int eof);
+		struct xfs_bmbt_irec *got, xfs_extnum_t *lastx, int eof,
+		struct xfs_bmbt_irec *arec);
 
 enum xfs_bmap_intent_type {
 	XFS_BMAP_MAP = 1,
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 41662fb..535d96d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -531,7 +531,7 @@ xfs_file_iomap_begin_delay(
 		XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	xfs_fileoff_t		end_fsb;
 	int			error = 0, eof = 0;
-	struct xfs_bmbt_irec	got;
+	struct xfs_bmbt_irec	got, arec;
 	xfs_extnum_t		idx;
 	xfs_fsblock_t		prealloc_blocks = 0;
 
@@ -613,7 +613,8 @@ xfs_file_iomap_begin_delay(
 
 retry:
 	error = xfs_bmapi_reserve_delalloc(ip, XFS_DATA_FORK, offset_fsb,
-			end_fsb - offset_fsb, prealloc_blocks, &got, &idx, eof);
+			end_fsb - offset_fsb, prealloc_blocks, &got, &idx,
+			eof, &arec);
 	switch (error) {
 	case 0:
 		break;
@@ -630,6 +631,15 @@ xfs_file_iomap_begin_delay(
 		goto out_unlock;
 	}
 
+	/*
+	 * IOMAP_F_NEW controls whether we punch out delalloc blocks if the
+	 * write happens to fail, which means we can't combine newly allocated
+	 * blocks with preexisting delalloc blocks in the same iomap. got may
+	 * have been merged with contiguous extents, so use arec to map only the
+	 * newly allocated blocks.
+	 */
+	got = arec;
+	iomap->flags = IOMAP_F_NEW;
 	trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
 done:
 	if (isnullstartblock(got.br_startblock))
@@ -1071,16 +1081,22 @@ xfs_file_iomap_end_delalloc(
 	struct xfs_inode	*ip,
 	loff_t			offset,
 	loff_t			length,
-	ssize_t			written)
+	ssize_t			written,
+	struct iomap		*iomap)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		start_fsb;
 	xfs_fileoff_t		end_fsb;
 	int			error = 0;
 
-	/* behave as if the write failed if drop writes is enabled */
-	if (xfs_mp_drop_writes(mp))
+	/*
+	 * Behave as if the write failed if drop writes is enabled. Set the NEW
+	 * flag to force delalloc cleanup.
+	 */
+	if (xfs_mp_drop_writes(mp)) {
+		iomap->flags |= IOMAP_F_NEW;
 		written = 0;
+	}
 
 	/*
 	 * start_fsb refers to the first unused block after a short write. If
@@ -1094,14 +1110,14 @@ xfs_file_iomap_end_delalloc(
 	end_fsb = XFS_B_TO_FSB(mp, offset + length);
 
 	/*
-	 * Trim back delalloc blocks if we didn't manage to write the whole
-	 * range reserved.
+	 * Trim delalloc blocks if they were allocated by this write and we
+	 * didn't manage to write the whole range.
 	 *
 	 * We don't need to care about racing delalloc as we hold i_mutex
 	 * across the reserve/allocate/unreserve calls. If there are delalloc
 	 * blocks in the range, they are ours.
 	 */
-	if (start_fsb < end_fsb) {
+	if ((iomap->flags & IOMAP_F_NEW) && start_fsb < end_fsb) {
 		truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
 					 XFS_FSB_TO_B(mp, end_fsb) - 1);
 
@@ -1131,7 +1147,7 @@ xfs_file_iomap_end(
 {
 	if ((flags & IOMAP_WRITE) && iomap->type == IOMAP_DELALLOC)
 		return xfs_file_iomap_end_delalloc(XFS_I(inode), offset,
-				length, written);
+				length, written, iomap);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index da6d08f..c29cc08 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -313,7 +313,7 @@ xfs_reflink_reserve_cow(
 		return error;
 
 	error = xfs_bmapi_reserve_delalloc(ip, XFS_COW_FORK, imap->br_startoff,
-			imap->br_blockcount, 0, &got, &idx, eof);
+			imap->br_blockcount, 0, &got, &idx, eof, NULL);
 	if (error == -ENOSPC || error == -EDQUOT)
 		trace_xfs_reflink_cow_enospc(ip, imap);
 	if (error)
-- 
2.7.4

