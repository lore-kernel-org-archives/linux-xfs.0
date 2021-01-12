Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5903CC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 01:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B74222D07
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 01:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729104AbhALBiC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:38:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729127AbhALBiC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 20:38:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AD6822D07;
        Tue, 12 Jan 2021 01:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610415441;
        bh=56daIi4GTYqj6mqVHnosE9Wp8Su5q+BSpiI+5YgpMgw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OVAZc9Q1IwkerNfvAnVk2BEVPYCAg7JVGyAlTjKs5U06Z+fypeXxf1/iUDVEp3yf/
         iPcIBU4MAY3Lh+pQhyYIwcLzbQnUcY1ry6Nwe+UgYW7ymTqGqRs7FuC9IiTS5HteJ/
         JVNNsSoXGoJDAQzr7TZeU1ZFD1lvHPyXoWZ3o696w6DbA9StOvOP+DuP8p5ioGmbe9
         UlT2zwa0nhH3v6lh6Q6hwldCkH3IJAnFrqx+QuA64x26gg7/IDGNeFN8Y5//+0DAMI
         gyTnQD5OfUSk0FPgbXTO6LOVOpJ1fDfaZQuS1POs5S6BIDv3WodiE/Qd0FP/bS9F/S
         6EiUHhenJbDDg==
Date:   Mon, 11 Jan 2021 17:37:13 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com, hch@lst.de,
        allison.henderson@oracle.com
Subject: Re: [PATCH V14 06/16] xfs: Check for extent overflow when renaming
 dir entries
Message-ID: <20210112013713.GL1164246@magnolia>
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
 <20210110160720.3922965-7-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210110160720.3922965-7-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 10, 2021 at 09:37:10PM +0530, Chandan Babu R wrote:
> A rename operation is essentially a directory entry remove operation
> from the perspective of parent directory (i.e. src_dp) of rename's
> source. Hence the only place where we check for extent count overflow
> for src_dp is in xfs_bmap_del_extent_real(). xfs_bmap_del_extent_real()
> returns -ENOSPC when it detects a possible extent count overflow and in
> response, the higher layers of directory handling code do the following:
> 1. Data/Free blocks: XFS lets these blocks linger until a future remove
>    operation removes them.
> 2. Dabtree blocks: XFS swaps the blocks with the last block in the Leaf
>    space and unmaps the last block.
> 
> For target_dp, there are two cases depending on whether the destination
> directory entry exists or not.
> 
> When destination directory entry does not exist (i.e. target_ip ==
> NULL), extent count overflow check is performed only when transaction
> has a non-zero sized space reservation associated with it.  With a
> zero-sized space reservation, XFS allows a rename operation to continue
> only when the directory has sufficient free space in its data/leaf/free
> space blocks to hold the new entry.
> 
> When destination directory entry exists (i.e. target_ip != NULL), all
> we need to do is change the inode number associated with the already
> existing entry. Hence there is no need to perform an extent count
> overflow check.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks good,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c |  3 +++
>  fs/xfs/xfs_inode.c       | 44 +++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 46 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 6c8f17a0e247..8ebe5f13279c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5160,6 +5160,9 @@ xfs_bmap_del_extent_real(
>  		 * until a future remove operation. Dabtree blocks would be
>  		 * swapped with the last block in the leaf space and then the
>  		 * new last block will be unmapped.
> +		 *
> +		 * The above logic also applies to the source directory entry of
> +		 * a rename operation.
>  		 */
>  		error = xfs_iext_count_may_overflow(ip, whichfork, 1);
>  		if (error) {
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 4cc787cc4eee..f0a6d528cbc4 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3116,6 +3116,35 @@ xfs_rename(
>  	/*
>  	 * Check for expected errors before we dirty the transaction
>  	 * so we can return an error without a transaction abort.
> +	 *
> +	 * Extent count overflow check:
> +	 *
> +	 * From the perspective of src_dp, a rename operation is essentially a
> +	 * directory entry remove operation. Hence the only place where we check
> +	 * for extent count overflow for src_dp is in
> +	 * xfs_bmap_del_extent_real(). xfs_bmap_del_extent_real() returns
> +	 * -ENOSPC when it detects a possible extent count overflow and in
> +	 * response, the higher layers of directory handling code do the
> +	 * following:
> +	 * 1. Data/Free blocks: XFS lets these blocks linger until a
> +	 *    future remove operation removes them.
> +	 * 2. Dabtree blocks: XFS swaps the blocks with the last block in the
> +	 *    Leaf space and unmaps the last block.
> +	 *
> +	 * For target_dp, there are two cases depending on whether the
> +	 * destination directory entry exists or not.
> +	 *
> +	 * When destination directory entry does not exist (i.e. target_ip ==
> +	 * NULL), extent count overflow check is performed only when transaction
> +	 * has a non-zero sized space reservation associated with it.  With a
> +	 * zero-sized space reservation, XFS allows a rename operation to
> +	 * continue only when the directory has sufficient free space in its
> +	 * data/leaf/free space blocks to hold the new entry.
> +	 *
> +	 * When destination directory entry exists (i.e. target_ip != NULL), all
> +	 * we need to do is change the inode number associated with the already
> +	 * existing entry. Hence there is no need to perform an extent count
> +	 * overflow check.
>  	 */
>  	if (target_ip == NULL) {
>  		/*
> @@ -3126,6 +3155,12 @@ xfs_rename(
>  			error = xfs_dir_canenter(tp, target_dp, target_name);
>  			if (error)
>  				goto out_trans_cancel;
> +		} else {
> +			error = xfs_iext_count_may_overflow(target_dp,
> +					XFS_DATA_FORK,
> +					XFS_IEXT_DIR_MANIP_CNT(mp));
> +			if (error)
> +				goto out_trans_cancel;
>  		}
>  	} else {
>  		/*
> @@ -3283,9 +3318,16 @@ xfs_rename(
>  	if (wip) {
>  		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
>  					spaceres);
> -	} else
> +	} else {
> +		/*
> +		 * NOTE: We don't need to check for extent count overflow here
> +		 * because the dir remove name code will leave the dir block in
> +		 * place if the extent count would overflow.
> +		 */
>  		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
>  					   spaceres);
> +	}
> +
>  	if (error)
>  		goto out_trans_cancel;
>  
> -- 
> 2.29.2
> 
