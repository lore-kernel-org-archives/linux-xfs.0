Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D407C07E9D
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 21:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiIWVp3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 17:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIWVp3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 17:45:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FAB113B54
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 14:45:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83AC160AE6
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 21:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEFAC433D6;
        Fri, 23 Sep 2022 21:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663969525;
        bh=uUbN+S6ysn9oOBCH7atIy5NXsIxDuuMkXTvYZT1Vh94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BOayeTl4wTCNLdJblefT2csgERztmTIr+Ex4RFcmq8OpwUhQXpiMHEVXXapWTnGyk
         EEOrVXb2aVLfsfIa60MQw1514qv8jVgeAIxt2hkb7KsW2/kGpK5PCTUVJs+JnUHJN4
         TFAMX/5s3cKyl0Hs5sPTLV7yJEBP/gFzbAGnpzXxhg3pRZh2N3N6ikS0fWo8ULka+m
         L6BBUu4AtMCVogtNLrIfBNO/ojjDCwMCiGttMzLog63Q7IL2JlZu4Pw/1YRtTtfbG8
         F3kQiFCCR8Z8QxY4Yq9fPPel8DjxAVp6JssP3YKJWivSmt4S9OJ0ZuuXIk75Fgh9bQ
         MnBd5ZnkFzHvg==
Date:   Fri, 23 Sep 2022 14:45:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 23/26] xfs: Filter XFS_ATTR_PARENT for getfattr
Message-ID: <Yy4o9c9w5OilCkrS@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-24-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922054458.40826-24-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 21, 2022 at 10:44:55PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Parent pointers returned to the get_fattr tool cause errors since
> the tool cannot parse parent pointers.  Fix this by filtering parent
> parent pointers from xfs_attr_list.

Yes!!  Parent pointers should /never/ be accessible by the standard VFS
xattr syscalls, nor should the XFS ATTR_MULTI calls handle them.

Changes to parent pointers are performed via separate syscalls
(link/unlink/mknod/creat/etc), and I see you've created a separate
parent pointer ioctl later on for userspace to retrieve them.  I think
this is the correct access model.

To check that assertion -- getxattr/setxattr/removexattr (and the ATTRMULTI
equivalents) are prevented from accessing parent pointers directly
because you'd have to be able to set XFS_ATTR_PARENT in
xfs_da_args.attr_filter, right?

And for the VFS to get/set/remove a parent pointer, XFS would have to
provide a struct xattr_handler with ->flags = XFS_ATTR_PARENT, which XFS
will never do, right?

And for ATTR_MULTI to touch a parent pointer, xfs_attr_filter (and the
ioctl api) would have to learn about XFS_ATTR_PARENT, which XFS will
also never do, right?

If the answers to these three questions are all yes then you're 95% of
the way to an RVB, except...

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_da_format.h |  3 +++
>  fs/xfs/xfs_attr_list.c        | 47 +++++++++++++++++++++++++++--------
>  2 files changed, 39 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index b02b67f1999e..e9c323fab6f3 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -697,6 +697,9 @@ struct xfs_attr3_leafblock {
>  #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
>  #define XFS_ATTR_NSP_ONDISK_MASK \
>  			(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
> +#define XFS_ATTR_ALL \
> +	(XFS_ATTR_LOCAL_BIT | XFS_ATTR_ROOT | XFS_ATTR_SECURE | \
> +	 XFS_ATTR_PARENT | XFS_ATTR_INCOMPLETE_BIT)
>  
>  /*
>   * Alignment for namelist and valuelist entries (since they are mixed
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index a51f7f13a352..13de597c4996 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -39,6 +39,23 @@ xfs_attr_shortform_compare(const void *a, const void *b)
>  	}
>  }
>  
> +/*
> + * Returns true or false if the parent attribute should be listed
> + */
> +static bool
> +xfs_attr_filter_parent(
> +	struct xfs_attr_list_context	*context,
> +	int				flags)
> +{
> +	if (!(flags & XFS_ATTR_PARENT))
> +		return true;
> +
> +	if (context->attr_filter & XFS_ATTR_PARENT)
> +		return true;
> +
> +	return false;

...wouldn't it suffice to do:

static inline bool
xfs_attr_filter_listent(
	struct xfs_attr_list_context    *context,
	int				flags)
{
	return context->attr_filter != (flags & XFS_ATTR_NSP_ONDISK_MASK);
}

like how xfs_ioc_attr_put_listent does?  And then...

> +}
> +
>  #define XFS_ISRESET_CURSOR(cursor) \
>  	(!((cursor)->initted) && !((cursor)->hashval) && \
>  	 !((cursor)->blkno) && !((cursor)->offset))
> @@ -90,11 +107,12 @@ xfs_attr_shortform_list(
>  							       sfe->namelen,
>  							       sfe->flags)))
>  				return -EFSCORRUPTED;
> -			context->put_listent(context,
> -					     sfe->flags,
> -					     sfe->nameval,
> -					     (int)sfe->namelen,
> -					     (int)sfe->valuelen);
> +			if (xfs_attr_filter_parent(context, sfe->flags))
> +				context->put_listent(context,
> +						     sfe->flags,
> +						     sfe->nameval,
> +						     (int)sfe->namelen,
> +						     (int)sfe->valuelen);
>  			/*
>  			 * Either search callback finished early or
>  			 * didn't fit it all in the buffer after all.
> @@ -185,11 +203,12 @@ xfs_attr_shortform_list(
>  			error = -EFSCORRUPTED;
>  			goto out;
>  		}
> -		context->put_listent(context,
> -				     sbp->flags,
> -				     sbp->name,
> -				     sbp->namelen,
> -				     sbp->valuelen);
> +		if (xfs_attr_filter_parent(context, sbp->flags))
> +			context->put_listent(context,
> +					     sbp->flags,
> +					     sbp->name,
> +					     sbp->namelen,
> +					     sbp->valuelen);
>  		if (context->seen_enough)
>  			break;
>  		cursor->offset++;
> @@ -474,8 +493,10 @@ xfs_attr3_leaf_list_int(
>  				   !xfs_attr_namecheck(mp, name, namelen,
>  						       entry->flags)))
>  			return -EFSCORRUPTED;
> -		context->put_listent(context, entry->flags,
> +		if (xfs_attr_filter_parent(context, entry->flags))
> +			context->put_listent(context, entry->flags,
>  					      name, namelen, valuelen);
> +
>  		if (context->seen_enough)
>  			break;
>  		cursor->offset++;
> @@ -539,6 +560,10 @@ xfs_attr_list(
>  	if (xfs_is_shutdown(dp->i_mount))
>  		return -EIO;
>  
> +	if (context->attr_filter == 0)
> +		context->attr_filter =
> +			XFS_ATTR_ALL & ~XFS_ATTR_PARENT;

...I think this is unnecessary since none of the callers can actually
set XFS_ATTR_PARENT in the first place, right?

--D

> +
>  	lock_mode = xfs_ilock_attr_map_shared(dp);
>  	error = xfs_attr_list_ilocked(context);
>  	xfs_iunlock(dp, lock_mode);
> -- 
> 2.25.1
> 
