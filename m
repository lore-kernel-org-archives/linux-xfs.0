Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC934C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 19:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B129960F9B
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 19:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbhG1TSG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 15:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230333AbhG1TSG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 15:18:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F08860F46;
        Wed, 28 Jul 2021 19:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627499884;
        bh=/CDHdtfpzYBVz6l06R6h3LDvRs3N2JhZlBOTijs8Mdg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GucY9WbMG6NcqEAdfyKsTCk8GJypCuQypN0OK4rsMA7W/SWvm1eb0YlxXyM27B9in
         dpDykT7Z3eke0KFQYWRSHGh21HIqKtCTOzslFQ7d3ZJ5cwdvb1UyB4YNLRJuNUH/Ow
         n2US2Ca8OwNdY7T0LVj8JZ7Wevx2I48eelW7JTb68eDv5i+y3JT+IRrw0wg3rIbMeb
         Tqbh7pR1DgL46DFHgmDJ+2OLPD3yt5/tYJOJSW7L7x36IPOki1hJuNya+DUDUhom08
         New0H/MjTUtA3b/4kXRG0RtBJmqHfnvfWWfo4f3MHCYS4t6gsmbsTVWzNsbmr6NG3H
         gzrP0RqPpNCWg==
Date:   Wed, 28 Jul 2021 12:18:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 10/16] RFC xfs: Skip flip flags for delayed attrs
Message-ID: <20210728191803.GD3601443@magnolia>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-11-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727062053.11129-11-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 11:20:47PM -0700, Allison Henderson wrote:
> This is a clean up patch that skips the flip flag logic for delayed attr
> renames.  Since the log replay keeps the inode locked, we do not need to
> worry about race windows with attr lookups.  So we can skip over
> flipping the flag and the extra transaction roll for it
> 
> RFC: In the last review, folks asked for some performance analysis, so I
> did a few perf captures with and with out this patch.  What I found was
> that there wasnt very much difference at all between having the patch or
> not having it.  Of the time we do spend in the affected code, the
> percentage is small.  Most of the time we spend about %0.03 of the time
> in this function, with or with out the patch.  Occasionally we get a
> 0.02%, though not often.  So I think this starts to challenge needing
> this patch at all. This patch was requested some number of reviews ago,
> be perhaps in light of the findings, it may no longer be of interest.
> 
>      0.03%     0.00%  fsstress  [xfs]               [k] xfs_attr_set_iter
> 
> Keep it or drop it?
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

/me hates it when he notices things after review... :/

> ---
>  fs/xfs/libxfs/xfs_attr.c      | 51 +++++++++++++++++++++++++------------------
>  fs/xfs/libxfs/xfs_attr_leaf.c |  3 ++-
>  2 files changed, 32 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 11d8081..eee219c6 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -355,6 +355,7 @@ xfs_attr_set_iter(
>  	struct xfs_inode		*dp = args->dp;
>  	struct xfs_buf			*bp = NULL;
>  	int				forkoff, error = 0;
> +	struct xfs_mount		*mp = args->dp->i_mount;
>  
>  	/* State machine switch */
>  	switch (dac->dela_state) {
> @@ -476,16 +477,21 @@ xfs_attr_set_iter(
>  		 * In a separate transaction, set the incomplete flag on the
>  		 * "old" attr and clear the incomplete flag on the "new" attr.
>  		 */
> -		error = xfs_attr3_leaf_flipflags(args);
> -		if (error)
> -			return error;
> -		/*
> -		 * Commit the flag value change and start the next trans in
> -		 * series.
> -		 */
> -		dac->dela_state = XFS_DAS_FLIP_LFLAG;
> -		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
> -		return -EAGAIN;
> +		if (!xfs_hasdelattr(mp)) {

More nitpicking: this should be gated directly on the log incompat
feature check, not the LARP knob...

		if (!xfs_sb_version_haslogxattrs(&mp->m_sb)) {

> +			error = xfs_attr3_leaf_flipflags(args);
> +			if (error)
> +				return error;
> +			/*
> +			 * Commit the flag value change and start the next trans
> +			 * in series.
> +			 */
> +			dac->dela_state = XFS_DAS_FLIP_LFLAG;
> +			trace_xfs_attr_set_iter_return(dac->dela_state,
> +						       args->dp);
> +			return -EAGAIN;
> +		}
> +
> +		/* fallthrough */
>  	case XFS_DAS_FLIP_LFLAG:
>  		/*
>  		 * Dismantle the "old" attribute/value pair by removing a
> @@ -587,17 +593,21 @@ xfs_attr_set_iter(
>  		 * In a separate transaction, set the incomplete flag on the
>  		 * "old" attr and clear the incomplete flag on the "new" attr.
>  		 */
> -		error = xfs_attr3_leaf_flipflags(args);
> -		if (error)
> -			goto out;
> -		/*
> -		 * Commit the flag value change and start the next trans in
> -		 * series
> -		 */
> -		dac->dela_state = XFS_DAS_FLIP_NFLAG;
> -		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
> -		return -EAGAIN;
> +		if (!xfs_hasdelattr(mp)) {

...and here...

> +			error = xfs_attr3_leaf_flipflags(args);
> +			if (error)
> +				goto out;
> +			/*
> +			 * Commit the flag value change and start the next trans
> +			 * in series
> +			 */
> +			dac->dela_state = XFS_DAS_FLIP_NFLAG;
> +			trace_xfs_attr_set_iter_return(dac->dela_state,
> +						       args->dp);
> +			return -EAGAIN;
> +		}
>  
> +		/* fallthrough */
>  	case XFS_DAS_FLIP_NFLAG:
>  		/*
>  		 * Dismantle the "old" attribute/value pair by removing a
> @@ -1241,7 +1251,6 @@ xfs_attr_node_addname_clear_incomplete(
>  	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
>  	 * flag means that we will find the "old" attr, not the "new" one.
>  	 */
> -	args->attr_filter |= XFS_ATTR_INCOMPLETE;

Why is this removed from the query arguments?  If we're going to skip
the INCOMPLETE flag dance, I would have thought that you'd change the
XFS_DAS_CLR_FLAG case to omit xfs_attr_node_addname_clear_incomplete if
the logged xattr feature is set?

>  	state = xfs_da_state_alloc(args);
>  	state->inleaf = 0;
>  	error = xfs_da3_node_lookup_int(state, &retval);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index b910bd2..a9116ee 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1482,7 +1482,8 @@ xfs_attr3_leaf_add_work(
>  	if (tmp)
>  		entry->flags |= XFS_ATTR_LOCAL;
>  	if (args->op_flags & XFS_DA_OP_RENAME) {
> -		entry->flags |= XFS_ATTR_INCOMPLETE;
> +		if (!xfs_hasdelattr(mp))

Same change here as above.

--D

> +			entry->flags |= XFS_ATTR_INCOMPLETE;
>  		if ((args->blkno2 == args->blkno) &&
>  		    (args->index2 <= args->index)) {
>  			args->index2++;
> -- 
> 2.7.4
> 
