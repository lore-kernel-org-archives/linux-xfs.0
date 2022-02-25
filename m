Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66ACDC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Feb 2022 05:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbiBYFLl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 00:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiBYFLk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 00:11:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F962692EA
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 21:11:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B93F618F3
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 05:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75D7C340E7;
        Fri, 25 Feb 2022 05:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645765868;
        bh=lZA8OKJ4cGzlw2KDNJtrOfWA/0sQNcavyBgHxSLXD5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YaTzTAU03P/efoM+2UKQ/z0SLZ17Tgj1znQF70gZQ6A1S1+PKeTWT+NlkEUFjLEhb
         W0EESk+y8GLK6kHdB3jUG1VbPFdV6sQ6ye1pVk+G3odO4R0REMKrqlFF78vvQfeYBs
         kZ2H4UMynQNm74+62uk8bdkAoVud/5aqp+oCij4gkvtU1TKY26hxHbcgSw+Pi0m/MU
         eGwnXVRuha57Gz3wy2w8picxakAyhvZ5zyWMYE8E70kVt2UQLP9XEkTIlktWeMKQBv
         +o5emHNKjp8e6+CgzGcsIi+RceBgjLsA2Xneho3dvsucZ4soVXDdFPE9I8KZZ9bvvz
         UWWmBw22SP49Q==
Date:   Thu, 24 Feb 2022 21:11:07 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V6 14/17] xfs: Conditionally upgrade existing inodes to
 use 64-bit extent counters
Message-ID: <20220225051107.GL8338@magnolia>
References: <20220224130211.1346088-1-chandan.babu@oracle.com>
 <20220224130211.1346088-15-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224130211.1346088-15-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 24, 2022 at 06:32:08PM +0530, Chandan Babu R wrote:
> This commit upgrades inodes to use 64-bit extent counters when they are read
> from disk. Inodes are upgraded only when the filesystem instance has
> XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag set.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Yay!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c       |  3 ++-
>  fs/xfs/libxfs/xfs_bmap.c       |  5 ++---
>  fs/xfs/libxfs/xfs_inode_fork.c | 37 ++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
>  fs/xfs/xfs_bmap_item.c         |  3 ++-
>  fs/xfs/xfs_bmap_util.c         | 10 ++++-----
>  fs/xfs/xfs_dquot.c             |  2 +-
>  fs/xfs/xfs_iomap.c             |  5 +++--
>  fs/xfs/xfs_reflink.c           |  5 +++--
>  fs/xfs/xfs_rtalloc.c           |  2 +-
>  10 files changed, 58 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 23523b802539..03a358930d74 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -774,7 +774,8 @@ xfs_attr_set(
>  		return error;
>  
>  	if (args->value || xfs_inode_hasattr(dp)) {
> -		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
> +		error = xfs_trans_inode_ensure_nextents(&args->trans, dp,
> +				XFS_ATTR_FORK,
>  				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
>  		if (error)
>  			goto out_trans_cancel;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index be7f8ebe3cd5..3a3c99ef7f13 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4523,14 +4523,13 @@ xfs_bmapi_convert_delalloc(
>  		return error;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
>  
> -	error = xfs_iext_count_may_overflow(ip, whichfork,
> +	error = xfs_trans_inode_ensure_nextents(&tp, ip, whichfork,
>  			XFS_IEXT_ADD_NOSPLIT_CNT);
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	xfs_trans_ijoin(tp, ip, 0);
> -
>  	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
>  	    bma.got.br_startoff > offset_fsb) {
>  		/*
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index a3a3b54f9c55..d1d065abeac3 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -757,3 +757,40 @@ xfs_iext_count_may_overflow(
>  
>  	return 0;
>  }
> +
> +/*
> + * Ensure that the inode has the ability to add the specified number of
> + * extents.  Caller must hold ILOCK_EXCL and have joined the inode to
> + * the transaction.  Upon return, the inode will still be in this state
> + * upon return and the transaction will be clean.
> + */
> +int
> +xfs_trans_inode_ensure_nextents(
> +	struct xfs_trans	**tpp,
> +	struct xfs_inode	*ip,
> +	int			whichfork,
> +	int			nr_to_add)
> +{
> +	int			error;
> +
> +	error = xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
> +	if (!error)
> +		return 0;
> +
> +	/*
> +	 * Try to upgrade if the extent count fields aren't large
> +	 * enough.
> +	 */
> +	if (!xfs_has_nrext64(ip->i_mount) ||
> +	    (ip->i_diflags2 & XFS_DIFLAG2_NREXT64))
> +		return error;
> +
> +	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
> +	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
> +
> +	error = xfs_trans_roll(tpp);
> +	if (error)
> +		return error;
> +
> +	return xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
> +}
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 8e6221e32660..65265ca51b0d 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -286,6 +286,8 @@ int xfs_ifork_verify_local_data(struct xfs_inode *ip);
>  int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
>  int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
>  		int nr_to_add);
> +int xfs_trans_inode_ensure_nextents(struct xfs_trans **tpp,
> +		struct xfs_inode *ip, int whichfork, int nr_to_add);
>  
>  /* returns true if the fork has extents but they are not read in yet. */
>  static inline bool xfs_need_iread_extents(struct xfs_ifork *ifp)
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index e1f4d7d5a011..27bc16a2b09b 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -505,7 +505,8 @@ xfs_bui_item_recover(
>  	else
>  		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
>  
> -	error = xfs_iext_count_may_overflow(ip, whichfork, iext_delta);
> +	error = xfs_trans_inode_ensure_nextents(&tp, ip, whichfork,
> +			iext_delta);
>  	if (error)
>  		goto err_cancel;
>  
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index eb2e387ba528..8d86d8d5ad88 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -855,7 +855,7 @@ xfs_alloc_file_space(
>  		if (error)
>  			break;
>  
> -		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +		error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
>  				XFS_IEXT_ADD_NOSPLIT_CNT);
>  		if (error)
>  			goto error;
> @@ -910,7 +910,7 @@ xfs_unmap_extent(
>  	if (error)
>  		return error;
>  
> -	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
>  			XFS_IEXT_PUNCH_HOLE_CNT);
>  	if (error)
>  		goto out_trans_cancel;
> @@ -1191,7 +1191,7 @@ xfs_insert_file_space(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
>  			XFS_IEXT_PUNCH_HOLE_CNT);
>  	if (error)
>  		goto out_trans_cancel;
> @@ -1418,7 +1418,7 @@ xfs_swap_extent_rmap(
>  			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
>  
>  			if (xfs_bmap_is_real_extent(&uirec)) {
> -				error = xfs_iext_count_may_overflow(ip,
> +				error = xfs_trans_inode_ensure_nextents(&tp, ip,
>  						XFS_DATA_FORK,
>  						XFS_IEXT_SWAP_RMAP_CNT);
>  				if (error)
> @@ -1426,7 +1426,7 @@ xfs_swap_extent_rmap(
>  			}
>  
>  			if (xfs_bmap_is_real_extent(&irec)) {
> -				error = xfs_iext_count_may_overflow(tip,
> +				error = xfs_trans_inode_ensure_nextents(&tp, tip,
>  						XFS_DATA_FORK,
>  						XFS_IEXT_SWAP_RMAP_CNT);
>  				if (error)
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 5afedcbc78c7..193a2e66efc7 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -320,7 +320,7 @@ xfs_dquot_disk_alloc(
>  		goto err_cancel;
>  	}
>  
> -	error = xfs_iext_count_may_overflow(quotip, XFS_DATA_FORK,
> +	error = xfs_trans_inode_ensure_nextents(&tp, quotip, XFS_DATA_FORK,
>  			XFS_IEXT_ADD_NOSPLIT_CNT);
>  	if (error)
>  		goto err_cancel;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index e552ce541ec2..4078d5324090 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -250,7 +250,8 @@ xfs_iomap_write_direct(
>  	if (error)
>  		return error;
>  
> -	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, nr_exts);
> +	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
> +			nr_exts);
>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -553,7 +554,7 @@ xfs_iomap_write_unwritten(
>  		if (error)
>  			return error;
>  
> -		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +		error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
>  				XFS_IEXT_WRITE_UNWRITTEN_CNT);
>  		if (error)
>  			goto error_on_bmapi_transaction;
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index db70060e7bf6..9d4fd2b160ff 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -615,7 +615,7 @@ xfs_reflink_end_cow_extent(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
>  			XFS_IEXT_REFLINK_END_COW_CNT);
>  	if (error)
>  		goto out_cancel;
> @@ -1117,7 +1117,8 @@ xfs_reflink_remap_extent(
>  	if (dmap_written)
>  		++iext_delta;
>  
> -	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, iext_delta);
> +	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
> +			iext_delta);
>  	if (error)
>  		goto out_cancel;
>  
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 379ef99722c5..4d24977d6a47 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -806,7 +806,7 @@ xfs_growfs_rt_alloc(
>  		xfs_trans_ijoin(tp, ip, 0);
>  		unlock_inode = true;
>  
> -		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +		error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
>  				XFS_IEXT_ADD_NOSPLIT_CNT);
>  		if (error)
>  			goto out_trans_cancel;
> -- 
> 2.30.2
> 
