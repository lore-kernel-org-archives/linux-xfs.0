Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 943187F50
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 06:53:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 831FC8F8040
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 04:53:17 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jsrqkx5PNSkgDIR8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Jan 2016 04:53:16 -0800 (PST)
Date: Thu, 7 Jan 2016 07:53:14 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: bmapbt checking on debug kernels too expensive
Message-ID: <20160107125314.GC33327@bfoster.bfoster>
References: <1452123087-13892-1-git-send-email-david@fromorbit.com>
	<1452123087-13892-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1452123087-13892-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 07, 2016 at 10:31:27AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> For large sparse or fragmented files, checking every single entry in
> the bmapbt on every operation is prohibitively expensive. Especially
> as such checks rarely discover problems during normal operations on
> high extent coutn files. Our regression tests don't tend to exercise

	      count

> files with hundreds of thousands to millions of extents, so mostly
> this isn't noticed.
> 
> However, trying to run things like xfs_mdrestore of large filesystem
> dumps on a debug kernel quickly becomes impossible as the CPU is
> completely burnt up repeatedly walking the sparse file bmapbt that
> is generated for every allocation that is made.
> 
> Hence, if the file has more than 10,000 extents, just don't bother
> with walking the tree to check it exhaustively. The btree code has
> checks that ensure that the newly inserted/removed/modified record
> is correctly ordered, so the entrie tree walk in thses cases has

						   these

> limited additional value.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 7388495..bc7e7d5 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -325,9 +325,11 @@ xfs_check_block(
>  
>  /*
>   * Check that the extents for the inode ip are in the right order in all
> - * btree leaves.
> + * btree leaves. THis becomes prohibitively expensive for large extent count

		    This

Reviewed-by: Brian Foster <bfoster@redhat.com>

> + * files, so don't bother with inodes that have more than 10,000 extents in
> + * them. The btree record ordering checks will still be done, so for such large
> + * bmapbt constructs that is going to catch most corruptions.
>   */
> -
>  STATIC void
>  xfs_bmap_check_leaf_extents(
>  	xfs_btree_cur_t		*cur,	/* btree cursor or null */
> @@ -352,6 +354,10 @@ xfs_bmap_check_leaf_extents(
>  		return;
>  	}
>  
> +	/* skip large extent count inodes */
> +	if (ip->i_d.di_nextents > 10000)
> +		return;
> +
>  	bno = NULLFSBLOCK;
>  	mp = ip->i_mount;
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
