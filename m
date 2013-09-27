Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F24047F52
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 14:36:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 78B2DAC004
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 12:36:16 -0700 (PDT)
Received: from b.mx.filmlight.ltd.uk (b.mx.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id ud6mzjvmZyKB9c9V for
	<xfs@oss.sgi.com>; Fri, 27 Sep 2013 12:36:14 -0700 (PDT)
Subject: Re: [PATCH] xfs: fix memory leak in xfs_dir2_node_removename
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <20130927130140.640252809@sgi.com>
References: <20130927130140.640252809@sgi.com>
Date: Fri, 27 Sep 2013 20:36:13 +0100
Message-Id: <1380310573.22649.1082.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com


On Fri, 2013-09-27 at 08:01 -0500, Mark Tinguely wrote:
> plain text document attachment
> (xfs-fix-leak-in-xfs_dir2_node_removename.patch)
> Free the memory pointed to by state before returning on error from 
> xfs_dir2_node_removename.c
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
> Found by Coverity (134681) in userspace, same patch applies there
> also.
> 

Is the first hunk right ?

xfs_da_node_lookup_int called as

        error = xfs_da_node_lookup_int(state, &rval);

and returns with

        *result = retval;
        return(0);

so, on return, error == 0 and rval == an error code. The next lines:

        if (error)
                rval = error;

won't change that. But previously if rval != EEXIST you returned rval.
With the change below, you return error, which is zero.

--
Roger


>  fs/xfs/xfs_dir2_node.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> Index: b/fs/xfs/xfs_dir2_node.c
> ===================================================================
> --- a/fs/xfs/xfs_dir2_node.c
> +++ b/fs/xfs/xfs_dir2_node.c
> @@ -2131,10 +2131,9 @@ xfs_dir2_node_removename(
>  	/*
>  	 * Didn't find it, upper layer screwed up.
>  	 */
> -	if (rval != EEXIST) {
> -		xfs_da_state_free(state);
> -		return rval;
> -	}
> +	if (rval != EEXIST)
> +		goto done;
> +
>  	blk = &state->path.blk[state->path.active - 1];
>  	ASSERT(blk->magic == XFS_DIR2_LEAFN_MAGIC);
>  	ASSERT(state->extravalid);
> @@ -2145,7 +2144,7 @@ xfs_dir2_node_removename(
>  	error = xfs_dir2_leafn_remove(args, blk->bp, blk->index,
>  		&state->extrablk, &rval);
>  	if (error)
> -		return error;
> +		goto done;
>  	/*
>  	 * Fix the hash values up the btree.
>  	 */
> @@ -2160,6 +2159,7 @@ xfs_dir2_node_removename(
>  	 */
>  	if (!error)
>  		error = xfs_dir2_node_to_leaf(state);
> +done:
>  	xfs_da_state_free(state);
>  	return error;
>  }
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 
-- 
Roger Willcocks <roger@filmlight.ltd.uk>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
