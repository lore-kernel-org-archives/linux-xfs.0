Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DEECD29DFB
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 19:08:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CFC8F8F8037
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 17:08:31 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	FVxv8PNvMkfyR2np for <xfs@oss.sgi.com>;
	Sun, 22 Sep 2013 17:08:29 -0700 (PDT)
Date: Mon, 23 Sep 2013 10:08:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix node forward in xfs_node_toosmall
Message-ID: <20130923000824.GK12541@dastard>
References: <20130920220519.585903357@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130920220519.585903357@sgi.com>
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

On Fri, Sep 20, 2013 at 05:05:08PM -0500, Mark Tinguely wrote:
> Commit f5ea1100 cleans up the disk to host conversions for
> node directory entries, but because a variable is reused in
> xfs_node_toosmall() the next node is not correctly found.
> If the original node is small enough (<= 3/8 of the node size),
> this change may incorrectly cause a node collapse when it should
> not. That will cause an assert in xfstest generic/319:
> 
>    Assertion failed: first <= last && last < BBTOB(bp->b_length),
>    file: /root/newest/xfs/fs/xfs/xfs_trans_buf.c, line: 569
> 
> Keep the original node header to get the correct forward node.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  fs/xfs/xfs_da_btree.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Index: b/fs/xfs/xfs_da_btree.c
> ===================================================================
> --- a/fs/xfs/xfs_da_btree.c
> +++ b/fs/xfs/xfs_da_btree.c
> @@ -1163,6 +1163,7 @@ xfs_da3_node_toosmall(
>  	xfs_dablk_t		blkno;
>  	struct xfs_buf		*bp;
>  	struct xfs_da3_icnode_hdr nodehdr;
> +	struct xfs_da3_icnode_hdr firstnhdr;
>  	int			count;
>  	int			forward;
>  	int			error;
> @@ -1221,13 +1222,14 @@ xfs_da3_node_toosmall(
>  	count -= state->node_ents >> 2;
>  	count -= nodehdr.count;
>  
> +	firstnhdr = nodehdr;
>  	/* start with smaller blk num */
>  	forward = nodehdr.forw < nodehdr.back;
>  	for (i = 0; i < 2; forward = !forward, i++) {
>  		if (forward)
> -			blkno = nodehdr.forw;
> +			blkno = firstnhdr.forw;
>  		else
> -			blkno = nodehdr.back;
> +			blkno = firstnhdr.back;
>  		if (blkno == 0)
>  			continue;
>  		error = xfs_da3_node_read(state->args->trans, state->args->dp,

Yes, that definitely a bug, but I think that the change doesn't
scope correctly. The original node header doesn't need to be saved
like this - the node header decoded in the loop needs a loop-scope
variable. i.e.:

	/* start with smaller blk num */
	forward = nodehdr.forw < nodehdr.back;
	for (i = 0; i < 2; forward = !forward, i++) {
+		struct xfs_da3_icnode_hdr thdr;
+
		if (forward)
			blkno = nodehdr.forw;
		else
			blkno = nodehdr.back;
		if (blkno == 0)
			continue;
		error = xfs_da3_node_read(state->args->trans, state->args->dp,
					blkno, -1, &bp, state->args->whichfork);
		if (error)
			return(error);

		node = bp->b_addr;
-		xfs_da3_node_hdr_from_disk(&nodehdr, node);
+		xfs_da3_node_hdr_from_disk(&thdr, node);
		xfs_trans_brelse(state->args->trans, bp);

-		if (count - nodehdr.count >= 0)
+		if (count - thdr.count >= 0)
			break;  /* fits with at least 25% to spare */
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
