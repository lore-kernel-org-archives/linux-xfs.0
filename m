Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45966 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726324AbfGEOtT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Jul 2019 10:49:19 -0400
Date: Fri, 5 Jul 2019 10:49:17 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/6] xfs: attribute scrub should use seen_enough to pass
 error values
Message-ID: <20190705144917.GD37448@bfoster>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
 <156158200593.495944.1612838829393872431.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156158200593.495944.1612838829393872431.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 26, 2019 at 01:46:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're iterating all the attributes using the built-in xattr
> iterator, we can use the seen_enough variable to pass error codes back
> to the main scrub function instead of flattening them into 0/1.  This
> will be used in a more exciting fashion in upcoming patches.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/attr.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index dce74ec57038..f0fd26abd39d 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -83,7 +83,7 @@ xchk_xattr_listent(
>  	sx = container_of(context, struct xchk_xattr, context);
>  
>  	if (xchk_should_terminate(sx->sc, &error)) {
> -		context->seen_enough = 1;
> +		context->seen_enough = error;

It might be appropriate to update the xfs_attr_list_context structure
definition comment since 'seen_enough' is not self explanatory as an
error code..? Otherwise looks fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  		return;
>  	}
>  
> @@ -125,7 +125,7 @@ xchk_xattr_listent(
>  					     args.blkno);
>  fail_xref:
>  	if (sx->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> -		context->seen_enough = 1;
> +		context->seen_enough = XFS_ITER_ABORT;
>  	return;
>  }
>  
> @@ -464,6 +464,10 @@ xchk_xattr(
>  	error = xfs_attr_list_int_ilocked(&sx.context);
>  	if (!xchk_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
>  		goto out;
> +
> +	/* Did our listent function try to return any errors? */
> +	if (sx.context.seen_enough < 0)
> +		error = sx.context.seen_enough;
>  out:
>  	return error;
>  }
> 
