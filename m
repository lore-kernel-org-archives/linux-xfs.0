Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:54859 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727008AbeK1P2o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 10:28:44 -0500
Date: Wed, 28 Nov 2018 15:28:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix PAGE_MASK usage in xfs_free_file_space
Message-ID: <20181128042827.GH6311@dastard>
References: <20181127234334.GB8125@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127234334.GB8125@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Nov 27, 2018 at 03:43:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit e53c4b598, I *tried* to teach xfs to force writeback when we
> fzero/fpunch right up to EOF so that if EOF is in the middle of a page,
> the post-EOF part of the page gets zeroed before we return to userspace.
> Unfortunately, I missed the part where PAGE_MASK is ~(PAGE_SIZE - 1),
> which means that we totally fail to zero if we're fpunching and EOF is
> within the first page.  Worse yet, the same PAGE_MASK thinko plagues the
> filemap_write_and_wait_range call, so we'd initiate writeback of the
> entire file, which (mostly) masked the thinko.
> 
> Drop the tricky PAGE_MASK and replace it with correct usage of PAGE_SIZE
> and the proper rounding macros.
> 
> Fixes: e53c4b598 ("xfs: ensure post-EOF zeroing happens after zeroing part of a file")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_util.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 404e581f1ea1..1ee8c5539fa4 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1126,9 +1126,9 @@ xfs_free_file_space(
>  	 * page could be mmap'd and iomap_zero_range doesn't do that for us.
>  	 * Writeback of the eof page will do this, albeit clumsily.
>  	 */
> -	if (offset + len >= XFS_ISIZE(ip) && ((offset + len) & PAGE_MASK)) {
> +	if (offset + len >= XFS_ISIZE(ip) && offset_in_page(offset + len) > 0) {
>  		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
> -				(offset + len) & ~PAGE_MASK, LLONG_MAX);
> +				round_down(offset + len, PAGE_SIZE), LLONG_MAX);

Looks fine. I think I tripped over this in my bs > ps series and
changed it to round_down(..., max(bs, ps)), but that's not necessary
here...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
