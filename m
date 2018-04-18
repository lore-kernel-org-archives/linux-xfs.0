Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:51483 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752619AbeDRApX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 20:45:23 -0400
Date: Wed, 18 Apr 2018 10:45:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't fail when converting shortform attr to long
 form during ATTR_REPLACE
Message-ID: <20180418004521.GM23861@dastard>
References: <20180418003130.GI24738@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418003130.GI24738@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, kanda.motohiro@gmail.com

On Tue, Apr 17, 2018 at 05:31:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Kanda Motohiro reported that expanding a tiny xattr into a large xattr
> fails on XFS because we remove the tiny xattr from a shortform fork and
> then try to re-add it after converting the fork to extents format having
> not removed the ATTR_REPLACE flag.  This fails because the attr is no
> longer present, causing a fs shutdown.
> 
> This is derived from the patch in his bug report, but we really
> shouldn't ignore a nonzero retval from the remove call.  Something's
> broken and we should bail out and shut down.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199119
> Reported-by: kanda.motohiro@gmail.com
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index ce4a34a..2588c73 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -511,7 +511,14 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>  		if (args->flags & ATTR_CREATE)
>  			return retval;
>  		retval = xfs_attr_shortform_remove(args);
> -		ASSERT(retval == 0);
> +		if (retval)
> +			return retval;
> +		/*
> +		 * Since we have removed the old attr here,
> +		 * further lookup will fail with ENOATTR.
> +		 * Ignore this was a replace and go on creating new attr.

The last line of that comment doesn't make sense to me. not sure
what it's meant to say...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
