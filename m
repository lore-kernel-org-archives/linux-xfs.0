Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB79C35DF5
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 09:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 990DE21744
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 09:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgBYJVa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 04:21:30 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:59746 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726867AbgBYJVa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 04:21:30 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DC8223A2B2D;
        Tue, 25 Feb 2020 20:21:22 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j6WP4-0007us-5L; Tue, 25 Feb 2020 20:21:22 +1100
Date:   Tue, 25 Feb 2020 20:21:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 16/19] xfs: Simplify xfs_attr_set_iter
Message-ID: <20200225092122.GK10776@dread.disaster.area>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-17-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223020611.1802-17-allison.henderson@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=NbAEnV_rIWBo99No2akA:9
        a=sF15wFxuq4E-j2l5:21 a=LxOBVDF-yqvvc8_b:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 22, 2020 at 07:06:08PM -0700, Allison Collins wrote:
> Delayed attribute mechanics make frequent use of goto statements.  We can use this
> to further simplify xfs_attr_set_iter.  Because states tend to fall between if
> conditions, we can invert the if logic and jump to the goto. This helps to reduce
> indentation and simplify things.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 71 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 42 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 30a16fe..dd935ff 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -254,6 +254,19 @@ xfs_attr_try_sf_addname(
>  }
>  
>  /*
> + * Check to see if the attr should be upgraded from non-existent or shortform to
> + * single-leaf-block attribute list.
> + */
> +static inline bool
> +xfs_attr_fmt_needs_update(
> +	struct xfs_inode    *dp)

Can we use *ip for the inode in newly factored code helpers like
this?

> +{
> +	return dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
> +	      (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> +	      dp->i_d.di_anextents == 0);
> +}
> +
> +/*
>   * Set the attribute specified in @args.
>   */
>  int
> @@ -342,40 +355,40 @@ xfs_attr_set_iter(
>  	}
>  
>  	/*
> -	 * If the attribute list is non-existent or a shortform list,
> -	 * upgrade it to a single-leaf-block attribute list.
> +	 * If the attribute list is already in leaf format, jump straight to
> +	 * leaf handling.  Otherwise, try to add the attribute to the shortform
> +	 * list; if there's no room then convert the list to leaf format and try
> +	 * again.
>  	 */
> -	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
> -	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -	     dp->i_d.di_anextents == 0)) {
> +	if (!xfs_attr_fmt_needs_update(dp))
> +		goto add_leaf;

The logic seems inverted to me here, but that really indicates a
sub-optimal function name. It's really checking if the attribute
fork is empty or in shortform format. Hence:

	if (!xfs_attr_is_shortform(dp))
		goto add_leaf;

> -		/*
> -		 * Try to add the attr to the attribute list in the inode.
> -		 */
> -		error = xfs_attr_try_sf_addname(dp, args);
> +	/*
> +	 * Try to add the attr to the attribute list in the inode.
> +	 */
> +	error = xfs_attr_try_sf_addname(dp, args);
>  
> -		/* Should only be 0, -EEXIST or ENOSPC */
> -		if (error != -ENOSPC)
> -			return error;
> +	/* Should only be 0, -EEXIST or ENOSPC */
> +	if (error != -ENOSPC)
> +		return error;
>  
> -		/*
> -		 * It won't fit in the shortform, transform to a leaf block.
> -		 * GROT: another possible req'mt for a double-split btree op.
> -		 */
> -		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
> -		if (error)
> -			return error;
> +	/*
> +	 * It won't fit in the shortform, transform to a leaf block.
> +	 * GROT: another possible req'mt for a double-split btree op.
> +	 */
> +	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
> +	if (error)
> +		return error;
>  
> -		/*
> -		 * Prevent the leaf buffer from being unlocked so that a
> -		 * concurrent AIL push cannot grab the half-baked leaf
> -		 * buffer and run into problems with the write verifier.
> -		 */
> -		xfs_trans_bhold(args->trans, *leaf_bp);
> -		args->dac.flags |= XFS_DAC_FINISH_TRANS;
> -		args->dac.dela_state = XFS_DAS_ADD_LEAF;
> -		return -EAGAIN;
> -	}
> +	/*
> +	 * Prevent the leaf buffer from being unlocked so that a
> +	 * concurrent AIL push cannot grab the half-baked leaf
> +	 * buffer and run into problems with the write verifier.
> +	 */
> +	xfs_trans_bhold(args->trans, *leaf_bp);
> +	args->dac.flags |= XFS_DAC_FINISH_TRANS;
> +	args->dac.dela_state = XFS_DAS_ADD_LEAF;
> +	return -EAGAIN;

Heh. This is an example of exactly why I think this should be
factored into functions first. Move all the code you just
re-indented into xfs_attr_set_shortform(), and the goto disappears
because this code becomes:

	if (xfs_attr_is_shortform(dp))
		return xfs_attr_set_shortform(dp, args);

add_leaf:

That massively improves the readability of the code - it separates
the operation implementation from the decision logic nice and
cleanly, and lends itself to being implemented in the delayed attr
state machine without needing gotos at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
