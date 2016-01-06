Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7B6E17F37
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 21:28:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5949D304067
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 19:28:41 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	CtpxS77AmbwXMkrW for <xfs@oss.sgi.com>;
	Tue, 05 Jan 2016 19:28:35 -0800 (PST)
Date: Wed, 6 Jan 2016 14:28:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V3] xfs: eliminate committed arg from xfs_bmap_finish
Message-ID: <20160106032832.GG21461@dastard>
References: <56441B8E.6070603@redhat.com> <5644BEF8.6070201@sandeen.net>
	<568C131C.9080907@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <568C131C.9080907@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Jan 05, 2016 at 01:01:48PM -0600, Eric Sandeen wrote:
> Calls to xfs_bmap_finish() and xfs_trans_ijoin(), and the
> associated comments were replicated several times across
> the attribute code, all dealing with what to do if the
> transaction was or wasn't committed.
> 
> And in that replicated code, an ASSERT() test of an
> uninitialized variable occurs in several locations:
> 
> 	error = xfs_attr_thing(&args);
> 	if (!error) {
> 		error = xfs_bmap_finish(&args.trans, args.flist,
> 					&committed);
> 	}
> 	if (error) {
> 		ASSERT(committed);
> 
> If the first xfs_attr_thing() failed, we'd skip the xfs_bmap_finish,
> never set "committed", and then test it in the ASSERT.
> 
> Fix this up by moving the committed state internal to xfs_bmap_finish,
> and add a new inode argument.  If an inode is passed in, it is passed
> through to __xfs_trans_roll() and joined to the transaction there if
> the transaction was committed.
> 
> xfs_qm_dqalloc() was a little unique in that it called bjoin rather
> than ijoin, but as Dave points out we can detect the committed state
> but checking whether (*tpp != tp).
> 
> Addresses-Coverity-Id: 102360
> Addresses-Coverity-Id: 102361
> Addresses-Coverity-Id: 102363
> Addresses-Coverity-Id: 102364
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
>  libxfs/xfs_attr.c        |  114 +++++------------------------------------------
>  libxfs/xfs_attr_remote.c |   25 ----------
>  libxfs/xfs_bmap.c        |    6 --
>  libxfs/xfs_bmap.h        |    2 
>  xfs_bmap_util.c          |   28 ++++-------
>  xfs_dquot.c              |   12 ++--
>  xfs_inode.c              |   22 ++-------
>  xfs_iomap.c              |   10 +---
>  xfs_rtalloc.c            |    3 -
>  xfs_symlink.c            |   12 ----
>  10 files changed, 50 insertions(+), 184 deletions(-)

Nice!

A few really minor things (repeated) to clean up the code being
touched a bit more.

> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index f949818..e16aa32 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -207,7 +207,7 @@ xfs_attr_set(
>  	struct xfs_trans_res	tres;
>  	xfs_fsblock_t		firstblock;
>  	int			rsvd = (flags & ATTR_ROOT) != 0;
> -	int			error, err2, committed, local;
> +	int			error, err2, local;
>  
>  	XFS_STATS_INC(mp, xs_attr_set);
>  
> @@ -335,24 +335,15 @@ xfs_attr_set(
>  		xfs_bmap_init(args.flist, args.firstblock);
>  		error = xfs_attr_shortform_to_leaf(&args);
>  		if (!error) {
> -			error = xfs_bmap_finish(&args.trans, args.flist,
> -						&committed);
> +			error = xfs_bmap_finish(&args.trans, args.flist, dp);
>  		}

You can kill the {} on this if as well. (repeats)

> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -91,32 +91,32 @@ xfs_zero_extent(
>   * last due to locking considerations.  We never free any extents in
>   * the first transaction.
>   *
> - * Return 1 if the given transaction was committed and a new one
> - * started, and 0 otherwise in the committed parameter.
> + * If an inode *ip is provided, rejoin it to the transaction if
> + * the transaction was committed.
>   */
>  int						/* error */
>  xfs_bmap_finish(
>  	struct xfs_trans		**tp,	/* transaction pointer addr */
>  	struct xfs_bmap_free		*flist,	/* i/o: list extents to free */
> -	int				*committed)/* xact committed or not */
> +	xfs_inode_t			*ip)

struct xfs_inode

> @@ -1071,7 +1067,7 @@ xfs_alloc_file_space(
>  		/*
>  		 * Complete the transaction
>  		 */
> -		error = xfs_bmap_finish(&tp, &free_list, &committed);
> +		error = xfs_bmap_finish(&tp, &free_list, NULL);
>  		if (error) {
>  			goto error0;
>  		}

Kill the {} here while touching the line above.

> @@ -1353,7 +1348,7 @@ xfs_free_file_space(
>  		/*
>  		 * complete the transaction
>  		 */
> -		error = xfs_bmap_finish(&tp, &free_list, &committed);
> +		error = xfs_bmap_finish(&tp, &free_list, NULL);
>  		if (error) {
>  			goto error0;
>  		}

And here.

> +	int		nmaps, error;
>  	xfs_buf_t	*bp;
>  	xfs_trans_t	*tp = *tpp;
>  
> @@ -379,11 +379,11 @@ xfs_qm_dqalloc(
>  
>  	xfs_trans_bhold(tp, bp);
>  
> -	if ((error = xfs_bmap_finish(tpp, &flist, &committed))) {
> +	if ((error = xfs_bmap_finish(tpp, &flist, NULL)))
>  		goto error1;
> -	}

	error = xfs_bmap_finish(tpp, &flist, NULL);
	if (error)
		goto error1;

> @@ -1841,7 +1835,7 @@ xfs_inactive_ifree(
>  	 * Just ignore errors at this point.  There is nothing we can do except
>  	 * to try to keep going. Make sure it's not a silent error.
>  	 */
> -	error = xfs_bmap_finish(&tp,  &free_list, &committed);
> +	error = xfs_bmap_finish(&tp,  &free_list, NULL);
				    ^^
You can fix the extra whitespace here, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
