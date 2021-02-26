Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18745C433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 05:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9B7764EE2
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 05:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhBZFDX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 00:03:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:43116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229745AbhBZFDW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Feb 2021 00:03:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 489CB64ED3;
        Fri, 26 Feb 2021 05:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614315761;
        bh=1sb0cbpb9xth2k2LHCbOdiIC7blfi7SLqoH3Unc3r0U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cEELs+Hxw7ZvpyPHR1dwwZe/RT76lp/RbRgBdmXTDsGnwNB660S59EQqWJmeWX2iz
         PqinR825mguBF+BgctsUloxb4HLN24d1OGV1zuutIXPrw5U04zakJy1J0l3vSyzN0q
         SEYNykhkFUDajv0NxltW1CzjkJ1srR73N8447WuIW/4YHcCn75ClfbAC7K6cO2q1Qh
         CvVpVqC5z2k6ngRplnSuKjhr7nWxkeIyvTh4m315rfwx87WSHUCTFg9r4JCpC8SESP
         d5RODy2B6THJRcYiUwMQPjgXTMTXoQU1BKpMqtrrCgyf4frt04haFjFAowPbGMUTfT
         XdyQDjn1mVJww==
Date:   Thu, 25 Feb 2021 21:02:41 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 17/22] xfs: Skip flip flags for delayed attrs
Message-ID: <20210226050241.GZ7272@magnolia>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-18-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-18-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:43AM -0700, Allison Henderson wrote:
> This is a clean up patch that skips the flip flag logic for delayed attr
> renames.  Since the log replay keeps the inode locked, we do not need to
> worry about race windows with attr lookups.  So we can skip over
> flipping the flag and the extra transaction roll for it
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

I wonder, have you done much performance analysis of the old vs. new
xattr code paths?  Does skipping the extra step + roll make attr
operations faster?

This looks pretty straightforward though:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c      | 51 +++++++++++++++++++++++++------------------
>  fs/xfs/libxfs/xfs_attr_leaf.c |  3 ++-
>  2 files changed, 32 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index e4c1b4b..666cc69 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -337,6 +337,7 @@ xfs_attr_set_iter(
>  	struct xfs_da_state		*state = NULL;
>  	int				forkoff, error = 0;
>  	int				retval = 0;
> +	struct xfs_mount		*mp = args->dp->i_mount;
>  
>  	/* State machine switch */
>  	switch (dac->dela_state) {
> @@ -470,16 +471,21 @@ xfs_attr_set_iter(
>  		 * "old" attr and clear the incomplete flag on the "new" attr.
>  		 */
>  
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
> @@ -588,17 +594,21 @@ xfs_attr_set_iter(
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
> @@ -1277,7 +1287,6 @@ int xfs_attr_node_addname_work(
>  	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
>  	 * flag means that we will find the "old" attr, not the "new" one.
>  	 */
> -	args->attr_filter |= XFS_ATTR_INCOMPLETE;
>  	state = xfs_da_state_alloc(args);
>  	state->inleaf = 0;
>  	error = xfs_da3_node_lookup_int(state, &retval);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 3780141..ec707bd 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1486,7 +1486,8 @@ xfs_attr3_leaf_add_work(
>  	if (tmp)
>  		entry->flags |= XFS_ATTR_LOCAL;
>  	if (args->op_flags & XFS_DA_OP_RENAME) {
> -		entry->flags |= XFS_ATTR_INCOMPLETE;
> +		if (!xfs_hasdelattr(mp))
> +			entry->flags |= XFS_ATTR_INCOMPLETE;
>  		if ((args->blkno2 == args->blkno) &&
>  		    (args->index2 <= args->index)) {
>  			args->index2++;
> -- 
> 2.7.4
> 
