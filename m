Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A952AC6FA91
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Sep 2022 00:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiIUAxy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 20:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiIUAxx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 20:53:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4C4796B9
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 17:53:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02231B82DD1
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 00:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC512C433D6;
        Wed, 21 Sep 2022 00:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663721628;
        bh=/2cCDKZRY3SXt0G/OcB98tp+f44sHBVtWYxP2fjELAQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L+gyIJcFBaEAuifDXOP89G2cxrv09lKYSMtC+x3PgSicb2SCCWyey8uaAJ6v44yQk
         FgsFvRNl+ASMSd4RAKgSTRpV4IObM+6RhRaLpfrFkIntk0c4V+n4ib3St2fo27plzD
         mLyz8J/0GPHiE2C2wYF6WKi4f/sWrhEA30M31MRpP9DYh8XJ8rvEUth1ylb8SI/ZQh
         P4bqGsLcprSnc4mzfV4HXQbTxUOj57kN15h+ayKgIkkCCmdQ4BDAFbSc7zNKTEhCYK
         d4t/5ohs1cP6Kt2vKB3NXGb5quYdYPA8CDC88HHoQE/iV67+kCfZEQ72N+wk9tKXoz
         UUHk2q+PYLF8w==
Date:   Tue, 20 Sep 2022 17:53:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Stephen Zhang <starzhangzsd@gmail.com>
Cc:     dchinner@redhat.com, chandan.babu@oracle.com,
        zhangshida@kylinos.cn, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: rearrange the logic and remove the broken
 comment for xfs_dir2_isxx
Message-ID: <YypgnAWbZi9ZUZEW@magnolia>
References: <20220918065026.1207016-1-zhangshida@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220918065026.1207016-1-zhangshida@kylinos.cn>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 18, 2022 at 02:50:26PM +0800, Stephen Zhang wrote:
> xfs_dir2_isleaf is used to see if the directory is a single-leaf
> form directory instead, as commented right above the function.
> 
> Besides getting rid of the broken comment, we rearrange the logic by
> converting everything over to standard formatting and conventions,
> at the same time, to make it easier to understand and self documenting.
> 
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
> Changes from v1:
> - v1 is only designed to fix the broken comment, while v2 rearranges the
>   logic in addition to that, which is suggested by Dave.
> ---
>  fs/xfs/libxfs/xfs_dir2.c  | 50 +++++++++++++++++++++++----------------
>  fs/xfs/libxfs/xfs_dir2.h  |  4 ++--
>  fs/xfs/scrub/dir.c        |  2 +-
>  fs/xfs/xfs_dir2_readdir.c |  2 +-
>  4 files changed, 34 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 76eedc2756b3..33738165d67d 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -261,7 +261,7 @@ xfs_dir_createname(
>  {
>  	struct xfs_da_args	*args;
>  	int			rval;
> -	int			v;		/* type-checking value */
> +	bool			v;		/* type-checking value */
>  
>  	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
>  
> @@ -357,7 +357,7 @@ xfs_dir_lookup(
>  {
>  	struct xfs_da_args	*args;
>  	int			rval;
> -	int			v;	  /* type-checking value */
> +	bool			v;	  /* type-checking value */
>  	int			lock_mode;
>  
>  	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
> @@ -435,7 +435,7 @@ xfs_dir_removename(
>  {
>  	struct xfs_da_args	*args;
>  	int			rval;
> -	int			v;		/* type-checking value */
> +	bool			v;		/* type-checking value */
>  
>  	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
>  	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
> @@ -493,7 +493,7 @@ xfs_dir_replace(
>  {
>  	struct xfs_da_args	*args;
>  	int			rval;
> -	int			v;		/* type-checking value */
> +	bool			v;		/* type-checking value */
>  
>  	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
>  
> @@ -610,19 +610,23 @@ xfs_dir2_grow_inode(
>  int
>  xfs_dir2_isblock(
>  	struct xfs_da_args	*args,
> -	int			*vp)	/* out: 1 is block, 0 is not block */
> +	bool			*isblock)
>  {
> -	xfs_fileoff_t		last;	/* last file offset */
> -	int			rval;
> +	struct xfs_mount	*mp = args->dp->i_mount;
> +	xfs_fileoff_t		eof;
> +	int			error;
>  
> -	if ((rval = xfs_bmap_last_offset(args->dp, &last, XFS_DATA_FORK)))
> -		return rval;
> -	rval = XFS_FSB_TO_B(args->dp->i_mount, last) == args->geo->blksize;
> -	if (XFS_IS_CORRUPT(args->dp->i_mount,
> -			   rval != 0 &&
> -			   args->dp->i_disk_size != args->geo->blksize))
> +	error = xfs_bmap_last_offset(args->dp, &eof, XFS_DATA_FORK);
> +	if (error)
> +		return error;
> +
> +	*isblock = false;
> +	if (XFS_FSB_TO_B(mp, eof) != args->geo->blksize)
> +		return 0;
> +
> +	*isblock = true;
> +	if (XFS_IS_CORRUPT(mp, args->dp->i_disk_size != args->geo->blksize))
>  		return -EFSCORRUPTED;
> -	*vp = rval;
>  	return 0;

Stylistic note: One has to be careful with these functions that pass out
a value /and/ potentially return a negative errno -- one has to be
careful about specifying whether or not callers should expect the out
parameter to be set if an errno is returned.  I think it looks slightly
better to see things like:

	if (XFS_FSB_TO_B(mp, eof) != args->geo->blksize) {
		*isblock = false;
		return 0;
	}

	if (XFS_IS_CORRUPT(mp, args->dp->i_disk_size != args->geo->blksize))
		return -EFSCORRUPTED;

	*isblock = true;
	return 0;


But for this patch that really doesn't matter, so:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


>  }
>  
> @@ -632,14 +636,20 @@ xfs_dir2_isblock(
>  int
>  xfs_dir2_isleaf(
>  	struct xfs_da_args	*args,
> -	int			*vp)	/* out: 1 is block, 0 is not block */
> +	bool			*isleaf)
>  {
> -	xfs_fileoff_t		last;	/* last file offset */
> -	int			rval;
> +	xfs_fileoff_t		eof;
> +	int			error;
>  
> -	if ((rval = xfs_bmap_last_offset(args->dp, &last, XFS_DATA_FORK)))
> -		return rval;
> -	*vp = last == args->geo->leafblk + args->geo->fsbcount;
> +	error = xfs_bmap_last_offset(args->dp, &eof, XFS_DATA_FORK);
> +	if (error)
> +		return error;
> +
> +	*isleaf = false;
> +	if (eof != args->geo->leafblk + args->geo->fsbcount)
> +		return 0;
> +
> +	*isleaf = true;
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index b6df3c34b26a..dd39f17dd9a9 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -61,8 +61,8 @@ extern int xfs_dir2_sf_to_block(struct xfs_da_args *args);
>  /*
>   * Interface routines used by userspace utilities
>   */
> -extern int xfs_dir2_isblock(struct xfs_da_args *args, int *r);
> -extern int xfs_dir2_isleaf(struct xfs_da_args *args, int *r);
> +extern int xfs_dir2_isblock(struct xfs_da_args *args, bool *isblock);
> +extern int xfs_dir2_isleaf(struct xfs_da_args *args, bool *isleaf);
>  extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
>  				struct xfs_buf *bp);
>  
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 5abb5fdb71d9..b9c5764e7437 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -676,7 +676,7 @@ xchk_directory_blocks(
>  	xfs_dablk_t		dabno;
>  	xfs_dir2_db_t		last_data_db = 0;
>  	bool			found;
> -	int			is_block = 0;
> +	bool			is_block = false;
>  	int			error;
>  
>  	/* Ignore local format directories. */
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index e295fc8062d8..9f3ceb461515 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -512,7 +512,7 @@ xfs_readdir(
>  {
>  	struct xfs_da_args	args = { NULL };
>  	unsigned int		lock_mode;
> -	int			isblock;
> +	bool			isblock;
>  	int			error;
>  
>  	trace_xfs_readdir(dp);
> -- 
> 2.27.0
> 
