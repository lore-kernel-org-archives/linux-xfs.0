Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5FCC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 18:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69B3D60FC3
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 18:42:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhJUSpK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Oct 2021 14:45:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230020AbhJUSpJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Oct 2021 14:45:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56BFE6120C;
        Thu, 21 Oct 2021 18:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634841773;
        bh=ywiTVmsI9AH5614oEhWEOvn/bzUh3xNab5Fy2mYWJXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZfaqEsBYJ3yp25l5NNpaTmGh5aAVy812GrvZWCBpzJGeDR1os6tBajv/XN0QwrH0U
         qa9Dtk2YgdIJno/DeaxvAD2Vpxq4jKqm5qtgCA7ID+4mY0O15vY8s2z8LtAnIUIwDJ
         gx8i+wMvZPKuGCZEKStFyo2O14SGQolvUrsVtaFtRd6OtSub8RTu+t9KxUe5VlXwO6
         q5sQFgA4pllKtW1U2E72QweLqgLz/E6dk2PKMPhimmo/jh+Ncpl1ErD3d6WGBnXUw9
         6Hp92oxTDgEcdfnAkKa6eWP70jRrA8B332whHxIMAwUH78DSv5Oc6NR9rs36lYV4H9
         4XaPp9uIclR9Q==
Date:   Thu, 21 Oct 2021 11:42:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: punch out data fork delalloc blocks on COW
 writeback failure
Message-ID: <20211021184253.GW24307@magnolia>
References: <20211021163330.1886516-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021163330.1886516-1-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 21, 2021 at 12:33:30PM -0400, Brian Foster wrote:
> If writeback I/O to a COW extent fails, the COW fork blocks are
> punched out and the data fork blocks left alone. It is possible for
> COW fork blocks to overlap non-shared data fork blocks (due to
> cowextsz hint prealloc), however, and writeback unconditionally maps
> to the COW fork whenever blocks exist at the corresponding offset of
> the page undergoing writeback. This means it's quite possible for a
> COW fork extent to overlap delalloc data fork blocks, writeback to
> convert and map to the COW fork blocks, writeback to fail, and
> finally for ioend completion to cancel the COW fork blocks and leave
> stale data fork delalloc blocks around in the inode. The blocks are
> effectively stale because writeback failure also discards dirty page
> state.
> 
> If this occurs, it is likely to trigger assert failures, free space
> accounting corruption and failures in unrelated file operations. For
> example, a subsequent reflink attempt of the affected file to a new
> target file will trip over the stale delalloc in the source file and
> fail. Several of these issues are occasionally reproduced by
> generic/648, but are reproducible on demand with the right sequence
> of operations and timely I/O error injection.
> 
> To fix this problem, update the ioend failure path to also punch out
> underlying data fork delalloc blocks on I/O error. This is analogous
> to the writeback submission failure path in xfs_discard_page() where
> we might fail to map data fork delalloc blocks and consistent with
> the successful COW writeback completion path, which is responsible
> for unmapping from the data fork and remapping in COW fork blocks.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Note that I have an fstest to reproduce this problem reliably that I'll
> post to the list shortly.

Yay!

> Brian
> 
>  fs/xfs/xfs_aops.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 34fc6148032a..c8c15c3c3147 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -82,6 +82,7 @@ xfs_end_ioend(
>  	struct iomap_ioend	*ioend)
>  {
>  	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> +	struct xfs_mount	*mp = ip->i_mount;
>  	xfs_off_t		offset = ioend->io_offset;
>  	size_t			size = ioend->io_size;
>  	unsigned int		nofs_flag;
> @@ -97,18 +98,26 @@ xfs_end_ioend(
>  	/*
>  	 * Just clean up the in-memory structures if the fs has been shut down.
>  	 */
> -	if (xfs_is_shutdown(ip->i_mount)) {
> +	if (xfs_is_shutdown(mp)) {
>  		error = -EIO;
>  		goto done;
>  	}
>  
>  	/*
> -	 * Clean up any COW blocks on an I/O error.
> +	 * Clean up all COW blocks and underlying data fork delalloc blocks on
> +	 * I/O error. The delalloc punch is required because this ioend was
> +	 * mapped to blocks in the COW fork and the associated pages are no
> +	 * longer dirty. If we don't remove delalloc blocks here, they become
> +	 * stale and can corrupt free space accounting on unmount.
>  	 */
>  	error = blk_status_to_errno(ioend->io_bio->bi_status);
>  	if (unlikely(error)) {
> -		if (ioend->io_flags & IOMAP_F_SHARED)
> +		if (ioend->io_flags & IOMAP_F_SHARED) {
>  			xfs_reflink_cancel_cow_range(ip, offset, size, true);
> +			xfs_bmap_punch_delalloc_range(ip,
> +						      XFS_B_TO_FSBT(mp, offset),
> +						      XFS_B_TO_FSB(mp, size));

This looks correct to me.  I'll give this a spin with your testcase and
report back.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +		}
>  		goto done;
>  	}
>  
> -- 
> 2.31.1
> 
