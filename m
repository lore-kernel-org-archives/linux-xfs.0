Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9F3C001DF
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 17:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbjHDRLR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbjHDRK7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 13:10:59 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCB649F0
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2023 10:10:46 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-112-100.bstnma.fios.verizon.net [173.48.112.100])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 374HAUpx018435
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 4 Aug 2023 13:10:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1691169032; bh=euCSBHqrCSTxpKioaTNv1/QoCEx4QA6JUd7a9fl3J+M=;
        h=From:Subject:Date:Message-Id:MIME-Version;
        b=dUr1JXoJ5V/jgTi3QkmZxaqogXdNX/fiT30TlJRzcs90Ei+j/8OTntEDiuSJPzK2e
         efE/RCbzZOFn0r1XddtJxl+eaRpKYALLv8QGJ5TfW5OZJk0PWx7uouyUkltljMtyXB
         ul72AWxeVlKIEwAA0k+LsfFzKA2ON+FaIytoTL5n4aGIHgWsjBGnLllmBjnA5ZoNxf
         5Hr2eAGget148cnZ5Q3V7rYZvLqZgGfk5PEEYogmE5FAMR2AYjAgl1nYoUvgI/qFrg
         3SHQ/8Gx/t5IaqOoQauZvcch+WGICjVT1mN48FshNqPQP3lUYKy3bmCjwbt8mhtqm7
         FkGtMaDPB2X4g==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 071CD15C04F4; Fri,  4 Aug 2023 13:10:30 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, djwong@kernel.org, chandan.babu@oracle.com,
        leah.rumancik@gmail.com, Wengang Wang <wen.gang.wang@oracle.com>
Subject: [PATCH CANDIDATE v5.15 4/9] xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork
Date:   Fri,  4 Aug 2023 13:10:14 -0400
Message-Id: <20230804171019.1392900-4-tytso@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230804171019.1392900-1-tytso@mit.edu>
References: <20230802205747.GE358316@mit.edu>
 <20230804171019.1392900-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandan.babu@oracle.com>

commit d62113303d691bcd8d0675ae4ac63e7769afc56c upstream.

On a higly fragmented filesystem a Direct IO write can fail with -ENOSPC error
even though the filesystem has sufficient number of free blocks.

This occurs if the file offset range on which the write operation is being
performed has a delalloc extent in the cow fork and this delalloc extent
begins much before the Direct IO range.

In such a scenario, xfs_reflink_allocate_cow() invokes xfs_bmapi_write() to
allocate the blocks mapped by the delalloc extent. The extent thus allocated
may not cover the beginning of file offset range on which the Direct IO write
was issued. Hence xfs_reflink_allocate_cow() ends up returning -ENOSPC.

The following script reliably recreates the bug described above.

  #!/usr/bin/bash

  device=/dev/loop0
  shortdev=$(basename $device)

  mntpnt=/mnt/
  file1=${mntpnt}/file1
  file2=${mntpnt}/file2
  fragmentedfile=${mntpnt}/fragmentedfile
  punchprog=/root/repos/xfstests-dev/src/punch-alternating

  errortag=/sys/fs/xfs/${shortdev}/errortag/bmap_alloc_minlen_extent

  umount $device > /dev/null 2>&1

  echo "Create FS"
  mkfs.xfs -f -m reflink=1 $device > /dev/null 2>&1
  if [[ $? != 0 ]]; then
  	echo "mkfs failed."
  	exit 1
  fi

  echo "Mount FS"
  mount $device $mntpnt > /dev/null 2>&1
  if [[ $? != 0 ]]; then
  	echo "mount failed."
  	exit 1
  fi

  echo "Create source file"
  xfs_io -f -c "pwrite 0 32M" $file1 > /dev/null 2>&1

  sync

  echo "Create Reflinked file"
  xfs_io -f -c "reflink $file1" $file2 &>/dev/null

  echo "Set cowextsize"
  xfs_io -c "cowextsize 16M" $file1 > /dev/null 2>&1

  echo "Fragment FS"
  xfs_io -f -c "pwrite 0 64M" $fragmentedfile > /dev/null 2>&1
  sync
  $punchprog $fragmentedfile

  echo "Allocate block sized extent from now onwards"
  echo -n 1 > $errortag

  echo "Create 16MiB delalloc extent in CoW fork"
  xfs_io -c "pwrite 0 4k" $file1 > /dev/null 2>&1

  sync

  echo "Direct I/O write at offset 12k"
  xfs_io -d -c "pwrite 12k 8k" $file1

This commit fixes the bug by invoking xfs_bmapi_write() in a loop until disk
blocks are allocated for atleast the starting file offset of the Direct IO
write range.

Fixes: 3c68d44a2b49 ("xfs: allocate direct I/O COW blocks in iomap_begin")
Reported-and-Root-caused-by: Wengang Wang <wen.gang.wang@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: slight editing to make the locking less grody, and fix some style things]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c | 198 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 163 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 628ce65d02bb..793bdf5ac2f7 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -340,9 +340,41 @@ xfs_find_trim_cow_extent(
 	return 0;
 }
 
-/* Allocate all CoW reservations covering a range of blocks in a file. */
-int
-xfs_reflink_allocate_cow(
+static int
+xfs_reflink_convert_unwritten(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*imap,
+	struct xfs_bmbt_irec	*cmap,
+	bool			convert_now)
+{
+	xfs_fileoff_t		offset_fsb = imap->br_startoff;
+	xfs_filblks_t		count_fsb = imap->br_blockcount;
+	int			error;
+
+	/*
+	 * cmap might larger than imap due to cowextsize hint.
+	 */
+	xfs_trim_extent(cmap, offset_fsb, count_fsb);
+
+	/*
+	 * COW fork extents are supposed to remain unwritten until we're ready
+	 * to initiate a disk write.  For direct I/O we are going to write the
+	 * data and need the conversion, but for buffered writes we're done.
+	 */
+	if (!convert_now || cmap->br_state == XFS_EXT_NORM)
+		return 0;
+
+	trace_xfs_reflink_convert_cow(ip, cmap);
+
+	error = xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
+	if (!error)
+		cmap->br_state = XFS_EXT_NORM;
+
+	return error;
+}
+
+static int
+xfs_reflink_fill_cow_hole(
 	struct xfs_inode	*ip,
 	struct xfs_bmbt_irec	*imap,
 	struct xfs_bmbt_irec	*cmap,
@@ -351,25 +383,12 @@ xfs_reflink_allocate_cow(
 	bool			convert_now)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	xfs_fileoff_t		offset_fsb = imap->br_startoff;
-	xfs_filblks_t		count_fsb = imap->br_blockcount;
 	struct xfs_trans	*tp;
-	int			nimaps, error = 0;
-	bool			found;
 	xfs_filblks_t		resaligned;
-	xfs_extlen_t		resblks = 0;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	if (!ip->i_cowfp) {
-		ASSERT(!xfs_is_reflink_inode(ip));
-		xfs_ifork_init_cow(ip);
-	}
-
-	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
-	if (error || !*shared)
-		return error;
-	if (found)
-		goto convert;
+	xfs_extlen_t		resblks;
+	int			nimaps;
+	int			error;
+	bool			found;
 
 	resaligned = xfs_aligned_fsb_count(imap->br_startoff,
 		imap->br_blockcount, xfs_get_cowextsz_hint(ip));
@@ -385,17 +404,17 @@ xfs_reflink_allocate_cow(
 
 	*lockmode = XFS_ILOCK_EXCL;
 
-	/*
-	 * Check for an overlapping extent again now that we dropped the ilock.
-	 */
 	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
 	if (error || !*shared)
 		goto out_trans_cancel;
+
 	if (found) {
 		xfs_trans_cancel(tp);
 		goto convert;
 	}
 
+	ASSERT(cmap->br_startoff > imap->br_startoff);
+
 	/* Allocate the entire reservation as unwritten blocks. */
 	nimaps = 1;
 	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
@@ -415,26 +434,135 @@ xfs_reflink_allocate_cow(
 	 */
 	if (nimaps == 0)
 		return -ENOSPC;
+
 convert:
-	xfs_trim_extent(cmap, offset_fsb, count_fsb);
-	/*
-	 * COW fork extents are supposed to remain unwritten until we're ready
-	 * to initiate a disk write.  For direct I/O we are going to write the
-	 * data and need the conversion, but for buffered writes we're done.
-	 */
-	if (!convert_now || cmap->br_state == XFS_EXT_NORM)
-		return 0;
-	trace_xfs_reflink_convert_cow(ip, cmap);
-	error = xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
-	if (!error)
-		cmap->br_state = XFS_EXT_NORM;
+	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
+
+out_trans_cancel:
+	xfs_trans_cancel(tp);
 	return error;
+}
+
+static int
+xfs_reflink_fill_delalloc(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*imap,
+	struct xfs_bmbt_irec	*cmap,
+	bool			*shared,
+	uint			*lockmode,
+	bool			convert_now)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			nimaps;
+	int			error;
+	bool			found;
+
+	do {
+		xfs_iunlock(ip, *lockmode);
+		*lockmode = 0;
+
+		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, 0, 0,
+				false, &tp);
+		if (error)
+			return error;
+
+		*lockmode = XFS_ILOCK_EXCL;
+
+		error = xfs_find_trim_cow_extent(ip, imap, cmap, shared,
+				&found);
+		if (error || !*shared)
+			goto out_trans_cancel;
+
+		if (found) {
+			xfs_trans_cancel(tp);
+			break;
+		}
+
+		ASSERT(isnullstartblock(cmap->br_startblock) ||
+		       cmap->br_startblock == DELAYSTARTBLOCK);
+
+		/*
+		 * Replace delalloc reservation with an unwritten extent.
+		 */
+		nimaps = 1;
+		error = xfs_bmapi_write(tp, ip, cmap->br_startoff,
+				cmap->br_blockcount,
+				XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0,
+				cmap, &nimaps);
+		if (error)
+			goto out_trans_cancel;
+
+		xfs_inode_set_cowblocks_tag(ip);
+		error = xfs_trans_commit(tp);
+		if (error)
+			return error;
+
+		/*
+		 * Allocation succeeded but the requested range was not even
+		 * partially satisfied?  Bail out!
+		 */
+		if (nimaps == 0)
+			return -ENOSPC;
+	} while (cmap->br_startoff + cmap->br_blockcount <= imap->br_startoff);
+
+	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
 	return error;
 }
 
+/* Allocate all CoW reservations covering a range of blocks in a file. */
+int
+xfs_reflink_allocate_cow(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*imap,
+	struct xfs_bmbt_irec	*cmap,
+	bool			*shared,
+	uint			*lockmode,
+	bool			convert_now)
+{
+	int			error;
+	bool			found;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	if (!ip->i_cowfp) {
+		ASSERT(!xfs_is_reflink_inode(ip));
+		xfs_ifork_init_cow(ip);
+	}
+
+	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
+	if (error || !*shared)
+		return error;
+
+	/* CoW fork has a real extent */
+	if (found)
+		return xfs_reflink_convert_unwritten(ip, imap, cmap,
+				convert_now);
+
+	/*
+	 * CoW fork does not have an extent and data extent is shared.
+	 * Allocate a real extent in the CoW fork.
+	 */
+	if (cmap->br_startoff > imap->br_startoff)
+		return xfs_reflink_fill_cow_hole(ip, imap, cmap, shared,
+				lockmode, convert_now);
+
+	/*
+	 * CoW fork has a delalloc reservation. Replace it with a real extent.
+	 * There may or may not be a data fork mapping.
+	 */
+	if (isnullstartblock(cmap->br_startblock) ||
+	    cmap->br_startblock == DELAYSTARTBLOCK)
+		return xfs_reflink_fill_delalloc(ip, imap, cmap, shared,
+				lockmode, convert_now);
+
+	/* Shouldn't get here. */
+	ASSERT(0);
+	return -EFSCORRUPTED;
+}
+
 /*
  * Cancel CoW reservations for some block range of an inode.
  *
-- 
2.31.0

