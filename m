Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B984B7F9F
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 15:32:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7C7318F804C
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 13:32:48 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wmjlPU7DUnL7UHC3 for <xfs@oss.sgi.com>;
	Wed, 02 Oct 2013 13:32:46 -0700 (PDT)
Date: Thu, 3 Oct 2013 06:32:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: fix memory leak in xfs_dir2_node_removename
Message-ID: <20131002203241.GV12541@dastard>
References: <20131002125110.745269864@sgi.com>
	<20131002125409.826742020@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131002125409.826742020@sgi.com>
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

On Wed, Oct 02, 2013 at 07:51:11AM -0500, Mark Tinguely wrote:
> Fix the leak of kernel memory in xfs_dir2_node_removename()
> when xfs_dir2_leafn_remove() returns an error code.
> 
> Found by Coverity in userspace same patch applies there also.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  v2 corrected bad return code as pointed out by Roger Willcocks.
> 
>  fs/xfs/xfs_dir2_node.c |   14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> Index: b/fs/xfs/xfs_dir2_node.c
> ===================================================================
> --- a/fs/xfs/xfs_dir2_node.c
> +++ b/fs/xfs/xfs_dir2_node.c
> @@ -2105,12 +2105,12 @@ xfs_dir2_node_lookup(
>   */
>  int						/* error */
>  xfs_dir2_node_removename(
> -	xfs_da_args_t		*args)		/* operation arguments */
> +	struct xfs_da_args	*args)		/* operation arguments */
>  {
> -	xfs_da_state_blk_t	*blk;		/* leaf block */
> +	struct xfs_da_state_blk	*blk;		/* leaf block */
>  	int			error;		/* error return value */
>  	int			rval;		/* operation return value */
> -	xfs_da_state_t		*state;		/* btree cursor */
> +	struct xfs_da_state	*state;		/* btree cursor */
>  
>  	trace_xfs_dir2_node_removename(args);
>  
> @@ -2132,9 +2132,10 @@ xfs_dir2_node_removename(
>  	 * Didn't find it, upper layer screwed up.
>  	 */
>  	if (rval != EEXIST) {
> -		xfs_da_state_free(state);
> -		return rval;
> +		error = rval;
> +		goto done;

Can you make this something like "out_free"? We tend to name jump
labels according to the action that needs to be taken, like
"out_unlock", "error_trans_cancel", etc...

Also, this code is now "funky" in how it handles rval. it will do
this:

        /*
         * Look up the entry we're deleting, set up the cursor.
         */
        error = xfs_da3_node_lookup_int(state, &rval);
        if (error)
                rval = error;
        /*
         * Didn't find it, upper layer screwed up.
         */
        if (rval != EEXIST) {
		error = rval;
                goto out_free;
        }

That's kind funky with the reassignment of rval if there's an error.
Better would be:

        /* Look up the entry we're deleting, set up the cursor. */
        error = xfs_da3_node_lookup_int(state, &rval);
        if (error)
                goto out_free;

        /* Didn't find it, upper layer screwed up. */
	if (rval != EEXIST) {
		error = rval;
		goto out_free;
	}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
