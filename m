Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DB9947F52
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 11:44:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6BBAEAC004
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 09:44:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 1NUvDsOnPhngUKBm for <xfs@oss.sgi.com>;
	Fri, 27 Sep 2013 09:44:23 -0700 (PDT)
Message-ID: <5245B5E5.7000206@sandeen.net>
Date: Fri, 27 Sep 2013 11:44:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix memory leak in xfs_dir2_node_removename
References: <20130927130140.640252809@sgi.com>
In-Reply-To: <20130927130140.640252809@sgi.com>
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

On 9/27/13 8:01 AM, Mark Tinguely wrote:
> Free the memory pointed to by state before returning on error from 
> xfs_dir2_node_removename.c
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
> Found by Coverity (134681) in userspace, same patch applies there
> also.

Heh, looks like that one has been around since the dawn of time, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

how do we handle the matching userspace fixes, separate patch to
be explicit?  Wait for the next syncup?

Thanks,
-Eric

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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
