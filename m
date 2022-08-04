Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5FEC19F2A
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 17:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbiHDRfQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 13:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiHDRfN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 13:35:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C7E119
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 10:35:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 758CA61554
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 17:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8048C433B5;
        Thu,  4 Aug 2022 17:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659634509;
        bh=R+bt3suEoOySCtiRtbFnZrBXDNVkV4nkCIeQ39IqBt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BWBtF3f9R+hrqGnSyvANHTEJzY70TiTqL5um1oVwlbJdCGTjD/MPWYiPAeVxAmOcj
         XLBik0kDa9M45//SXfb0UQHVSHNqIWdZuQ0obEOoTGDgSQBszT493I5OtsyGmWaXsF
         0jDsj+NSJOuu7e0WEfkw1EJWkpbkGF+iPS2vjpXKXRKsWijdB9/DYz2ZvXGAfm1pYR
         MmvVMF6mNjqRVov694Nom16SExCplZoTcf/uWbXQ9+kQ3WRdLEOXjLIDlOW7tLKbb5
         ruKGqvZYBs71MctwWZYP/kERbqXExCs7XlzALcGAINr85t3zKRyn80y0LoZYxZVUDJ
         02w2LujTd1JVw==
Date:   Thu, 4 Aug 2022 10:35:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Wengang Wang <wen.gang.wang@oracle.com>
Subject: Re: [PATCH V2] xfs: Fix false ENOSPC when performing direct write on
 a delalloc extent in cow fork
Message-ID: <YuwDTcZbq0lrOlUL@magnolia>
References: <20220713073057.1098781-1-chandan.babu@oracle.com>
 <20220713104551.1704084-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713104551.1704084-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 13, 2022 at 04:15:51PM +0530, Chandan Babu R wrote:
> On a higly fragmented filesystem a Direct IO write can fail with -ENOSPC error
> even though the filesystem has sufficient number of free blocks.

Oops, I totally didn't notice this patch.  Sorry about that. :(

> This occurs if the file offset range on which the write operation is being
> performed has a delalloc extent in the cow fork and this delalloc extent
> begins much before the Direct IO range.
> 
> In such a scenario, xfs_reflink_allocate_cow() invokes xfs_bmapi_write() to
> allocate the blocks mapped by the delalloc extent. The extent thus allocated
> may not cover the beginning of file offset range on which the Direct IO write
> was issued. Hence xfs_reflink_allocate_cow() ends up returning -ENOSPC.
> 
> The following script reliably recreates the bug described above.
> 
>   #!/usr/bin/bash
> 
>   device=/dev/loop0
>   shortdev=$(basename $device)
> 
>   mntpnt=/mnt/
>   file1=${mntpnt}/file1
>   file2=${mntpnt}/file2
>   fragmentedfile=${mntpnt}/fragmentedfile
>   punchprog=/root/repos/xfstests-dev/src/punch-alternating
> 
>   errortag=/sys/fs/xfs/${shortdev}/errortag/bmap_alloc_minlen_extent
> 
>   umount $device > /dev/null 2>&1
> 
>   echo "Create FS"
>   mkfs.xfs -f -m reflink=1 $device > /dev/null 2>&1
>   if [[ $? != 0 ]]; then
>   	echo "mkfs failed."
>   	exit 1
>   fi
> 
>   echo "Mount FS"
>   mount $device $mntpnt > /dev/null 2>&1
>   if [[ $? != 0 ]]; then
>   	echo "mount failed."
>   	exit 1
>   fi
> 
>   echo "Create source file"
>   xfs_io -f -c "pwrite 0 32M" $file1 > /dev/null 2>&1
> 
>   sync
> 
>   echo "Create Reflinked file"
>   xfs_io -f -c "reflink $file1" $file2 &>/dev/null
> 
>   echo "Set cowextsize"
>   xfs_io -c "cowextsize 16M" $file1 > /dev/null 2>&1
> 
>   echo "Fragment FS"
>   xfs_io -f -c "pwrite 0 64M" $fragmentedfile > /dev/null 2>&1
>   sync
>   $punchprog $fragmentedfile
> 
>   echo "Allocate block sized extent from now onwards"
>   echo -n 1 > $errortag
> 
>   echo "Create 16MiB delalloc extent in CoW fork"
>   xfs_io -c "pwrite 0 4k" $file1 > /dev/null 2>&1
> 
>   sync
> 
>   echo "Direct I/O write at offset 12k"
>   xfs_io -d -c "pwrite 12k 8k" $file1
> 
> This commit fixes the bug by invoking xfs_bmapi_write() in a loop until disk
> blocks are allocated for atleast the starting file offset of the Direct IO
> write range.
> 
> Fixes: 3c68d44a2b49 ("xfs: allocate direct I/O COW blocks in iomap_begin")
> Reported-and-Root-caused-by: Wengang Wang <wen.gang.wang@oracle.com>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
> Changelog:
>     V1 -> V2:
>     1. Add Fixes tag.
>     
>  fs/xfs/xfs_reflink.c | 225 +++++++++++++++++++++++++++++++++++--------
>  1 file changed, 187 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index e7a7c00d93be..ab7a39244920 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -340,9 +340,41 @@ xfs_find_trim_cow_extent(
>  	return 0;
>  }
>  
> -/* Allocate all CoW reservations covering a range of blocks in a file. */
> -int
> -xfs_reflink_allocate_cow(
> +static int
> +xfs_reflink_convert_unwritten(
> +	struct xfs_inode	*ip,
> +	struct xfs_bmbt_irec	*imap,
> +	struct xfs_bmbt_irec	*cmap,
> +	bool			convert_now)
> +{
> +	xfs_fileoff_t		offset_fsb = imap->br_startoff;
> +	xfs_filblks_t		count_fsb = imap->br_blockcount;
> +	int			error;
> +
> +	/*
> +	 * cmap might larger than imap due to cowextsize hint.
> +	 */
> +	xfs_trim_extent(cmap, offset_fsb, count_fsb);
> +
> +	/*
> +	 * COW fork extents are supposed to remain unwritten until we're ready
> +	 * to initiate a disk write.  For direct I/O we are going to write the
> +	 * data and need the conversion, but for buffered writes we're done.
> +	 */
> +	if (!convert_now || cmap->br_state == XFS_EXT_NORM)
> +		return 0;
> +
> +	trace_xfs_reflink_convert_cow(ip, cmap);
> +
> +	error = xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
> +	if (!error)
> +		cmap->br_state = XFS_EXT_NORM;
> +
> +	return error;
> +}
> +
> +static int
> +xfs_reflink_alloc_cow_unwritten(

Hmm.  If @convert_now is set, then upon successful return, cmap is a
written extent, right?  I think a better name for this function is
xfs_reflink_fill_cow_hole, since that's what it's doing.

>  	struct xfs_inode	*ip,
>  	struct xfs_bmbt_irec	*imap,
>  	struct xfs_bmbt_irec	*cmap,
> @@ -351,33 +383,17 @@ xfs_reflink_allocate_cow(
>  	bool			convert_now)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	xfs_fileoff_t		offset_fsb = imap->br_startoff;
> -	xfs_filblks_t		count_fsb = imap->br_blockcount;
>  	struct xfs_trans	*tp;
> -	int			nimaps, error = 0;
> -	bool			found;
>  	xfs_filblks_t		resaligned;
> -	xfs_extlen_t		resblks = 0;
> -
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -	if (!ip->i_cowfp) {
> -		ASSERT(!xfs_is_reflink_inode(ip));
> -		xfs_ifork_init_cow(ip);
> -	}
> -
> -	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
> -	if (error || !*shared)
> -		return error;
> -	if (found)
> -		goto convert;
> +	xfs_extlen_t		resblks;
> +	int			nimaps;
> +	int			error;
> +	bool			found;
>  
>  	resaligned = xfs_aligned_fsb_count(imap->br_startoff,
>  		imap->br_blockcount, xfs_get_cowextsz_hint(ip));
>  	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
>  
> -	xfs_iunlock(ip, *lockmode);
> -	*lockmode = 0;

Hmmm.  This piece effectively moves to this function's caller, which
means that the parent unlocks the inode and the child maybe relocks it.
The ILOCK handling in this whole call chain is already confusing enough
as we pass *lockmode around to avoid relocking ILOCK for an
xfs_trans_alloc* error return; could we try to contain lock state
cycling to single functions, please?

IOWs, leave this hunk here and don't add it to xfs_reflink_allocate_cow.
I'll have more to say about this in the delalloc conversion function
below.

> -
>  	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks, 0,
>  			false, &tp);
>  	if (error)
> @@ -385,17 +401,17 @@ xfs_reflink_allocate_cow(
>  
>  	*lockmode = XFS_ILOCK_EXCL;
>  
> -	/*
> -	 * Check for an overlapping extent again now that we dropped the ilock.
> -	 */
>  	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
>  	if (error || !*shared)
>  		goto out_trans_cancel;
> +
>  	if (found) {
>  		xfs_trans_cancel(tp);
>  		goto convert;
>  	}
>  
> +	ASSERT(cmap->br_startoff > imap->br_startoff);
> +
>  	/* Allocate the entire reservation as unwritten blocks. */
>  	nimaps = 1;
>  	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
> @@ -415,19 +431,9 @@ xfs_reflink_allocate_cow(
>  	 */
>  	if (nimaps == 0)
>  		return -ENOSPC;
> +
>  convert:
> -	xfs_trim_extent(cmap, offset_fsb, count_fsb);
> -	/*
> -	 * COW fork extents are supposed to remain unwritten until we're ready
> -	 * to initiate a disk write.  For direct I/O we are going to write the
> -	 * data and need the conversion, but for buffered writes we're done.
> -	 */
> -	if (!convert_now || cmap->br_state == XFS_EXT_NORM)
> -		return 0;
> -	trace_xfs_reflink_convert_cow(ip, cmap);
> -	error = xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
> -	if (!error)
> -		cmap->br_state = XFS_EXT_NORM;
> +	error = xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
>  	return error;

Nit: "return xfs_reflink_convert_unwritten(...);"

>  
>  out_trans_cancel:
> @@ -435,6 +441,149 @@ xfs_reflink_allocate_cow(
>  	return error;
>  }
>  
> +static int
> +xfs_replace_delalloc_cow_extent(

This is a rather long name, which would get even longer if it were
namespaced "xfs_reflink_*" like the rest of the functions in this file.

How about xfs_reflink_fill_delalloc?

> +	struct xfs_inode	*ip,
> +	struct xfs_bmbt_irec	*imap,
> +	struct xfs_bmbt_irec	*cmap,
> +	bool			*shared,
> +	uint			*lockmode,
> +	bool			convert_now)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
> +	int			nimaps;
> +	int			error;
> +	bool			found;
> +
> +	while (1) {
> +		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, 0, 0,
> +				false, &tp);
> +		if (error)
> +			return error;
> +
> +		*lockmode = XFS_ILOCK_EXCL;
> +
> +		error = xfs_find_trim_cow_extent(ip, imap, cmap, shared,
> +						&found);
> +		if (error || !*shared)
> +			goto out_trans_cancel;
> +
> +		if (found) {
> +			xfs_trans_cancel(tp);
> +			goto convert;

Question: If @found is true here, do we need to check that cmap covers
at least one block of imap?  I /think/ the answer is "no", because @cmap
will be set to whatever's in the cow fork at imap->br_startoff, and if
it's a real extent (written or not) then there's no delalloc reservation
to fill and we can move on to the next step.

Also: "break" instead of a goto?

> +		}
> +
> +		ASSERT(isnullstartblock(cmap->br_startblock) ||
> +			cmap->br_startblock == DELAYSTARTBLOCK);
> +
> +		/*
> +		 * Replace delalloc reservation with an unwritten extent.
> +		 */
> +		nimaps = 1;
> +		error = xfs_bmapi_write(tp, ip, cmap->br_startoff,
> +			cmap->br_blockcount,
> +			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0, cmap,
> +			&nimaps);

Indenting here ^^^^ (two spaces for a continuation, please.)

> +		if (error)
> +			goto out_trans_cancel;
> +
> +		xfs_inode_set_cowblocks_tag(ip);
> +		error = xfs_trans_commit(tp);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * Allocation succeeded but the requested range was not even partially
> +		 * satisfied?  Bail out!
> +		 */
> +		if (nimaps == 0)
> +			return -ENOSPC;
> +
> +		if (cmap->br_startoff + cmap->br_blockcount > imap->br_startoff)
> +			break;
> +
> +		xfs_iunlock(ip, *lockmode);
> +		*lockmode = 0;
> +	}

If the iunlock in xfs_reflink_allocate_cow were eliminated, then this
whole loop could turn into:

	do {
		xfs_iunlock(...);
		xfs_trans_alloc_inode(...);
		/* stuff */
	} while (cmap->br_startoff + cmap->br_blockcount <= imap->br_startoff);

> +
> +convert:
> +	error = xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
> +	return error;

return xfs_reflink_convert_unwritten(...);

> +
> +out_trans_cancel:
> +	xfs_trans_cancel(tp);
> +	return error;
> +}
> +
> +
> +/* Allocate all CoW reservations covering a range of blocks in a file. */
> +int
> +xfs_reflink_allocate_cow(
> +	struct xfs_inode	*ip,
> +	struct xfs_bmbt_irec	*imap,
> +	struct xfs_bmbt_irec	*cmap,
> +	bool			*shared,
> +	uint			*lockmode,
> +	bool			convert_now)
> +{
> +	int			error;
> +	bool			found;
> +
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +	if (!ip->i_cowfp) {
> +		ASSERT(!xfs_is_reflink_inode(ip));
> +		xfs_ifork_init_cow(ip);
> +	}
> +
> +	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
> +	if (error || !*shared)
> +		return error;
> +
> +	/*
> +	 * We have to deal with one of the following 2 cases,
> +	 * 1. No extent in CoW fork and shared extent in Data fork.
> +	 * 2. CoW fork has one of the following:
> +	 *    - Unwritten/written extent in CoW fork.
> +	 *    - Delalloc extent in CoW fork; An extent may or may not be present
> +	 *      in the Data fork.
> +	 */

I think this comment is a bit redundant with the hunks below it.

> +
> +	if (found) {
> +		/*
> +		 * CoW fork has a real extent; Convert it to written if is an
> +		 * unwritten extent.
> +		 */
> +		error = xfs_reflink_convert_unwritten(ip, imap, cmap,
> +				convert_now);
> +		return error;
> +	}
> +
> +	xfs_iunlock(ip, *lockmode);
> +	*lockmode = 0;

Move this to xfs_reflink_alloc_cow_unwritten and
xfs_replace_delalloc_cow_extent so that we're not unlocking in one
function and relocking in another.

> +	if (cmap->br_startoff > imap->br_startoff) {
> +		/*
> +		 * CoW fork does not have an extent. Hence, allocate a real
> +		 * extent in the CoW fork.
> +		 */
> +		error = xfs_reflink_alloc_cow_unwritten(ip, imap, cmap, shared,
> +				lockmode, convert_now);
> +	} else if (isnullstartblock(cmap->br_startblock) ||
> +		cmap->br_startblock == DELAYSTARTBLOCK) {
> +		/*
> +		 * CoW fork has a delalloc extent. Replace it with a real
> +		 * extent.
> +		 */
> +		error = xfs_replace_delalloc_cow_extent(ip, imap, cmap, shared,
> +				lockmode, convert_now);

Also, this would be a bit easier to read if each if case was its own:

	if (foo) {
		return XXX;
	}
	if (bar) {
		return YYY;
	}

> +	} else {
> +		ASSERT(0);
> +	}
> +
> +	return error;
> +}
> +
>  /*
>   * Cancel CoW reservations for some block range of an inode.
>   *
> -- 
> 2.35.1
> 

How about this for a v2 patch?

--D

From: Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH] xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork

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
---
 fs/xfs/xfs_reflink.c |  201 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 166 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 724806c7ce3e..b310cbaebe76 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -341,9 +341,41 @@ xfs_find_trim_cow_extent(
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
@@ -352,25 +384,12 @@ xfs_reflink_allocate_cow(
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
@@ -386,17 +405,17 @@ xfs_reflink_allocate_cow(
 
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
@@ -416,26 +435,138 @@ xfs_reflink_allocate_cow(
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
+	if (found) {
+		/* CoW fork has a real extent */
+		return xfs_reflink_convert_unwritten(ip, imap, cmap,
+				convert_now);
+	}
+
+	if (cmap->br_startoff > imap->br_startoff) {
+		/*
+		 * CoW fork does not have an extent and data extent is shared.
+		 * Hence, allocate a real extent in the CoW fork.
+		 */
+		return xfs_reflink_fill_cow_hole(ip, imap, cmap, shared,
+				lockmode, convert_now);
+	}
+
+	if (isnullstartblock(cmap->br_startblock) ||
+	    cmap->br_startblock == DELAYSTARTBLOCK) {
+		/*
+		 * CoW fork has a delalloc reservation. Replace it with a real
+		 * extent.  There may or may not be a data fork mapping.
+		 */
+		return xfs_reflink_fill_delalloc(ip, imap, cmap, shared,
+				lockmode, convert_now);
+	}
+
+	/* Shouldn't get here. */
+	ASSERT(0);
+	return -EFSCORRUPTED;
+}
+
 /*
  * Cancel CoW reservations for some block range of an inode.
  *
