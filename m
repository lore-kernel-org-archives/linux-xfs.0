Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5C0D57F53
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 08:36:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2AE96304059
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 06:36:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RCSe8YdgCzo1UnZJ for
	<xfs@oss.sgi.com>; Thu, 08 May 2014 06:36:41 -0700 (PDT)
Date: Thu, 8 May 2014 09:36:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: remove XFS_TRANS_RESERVE in collapse range
Message-ID: <20140508133637.GB47272@bfoster.bfoster>
References: <002601cf6aa2$c59cd670$50d68350$@samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <002601cf6aa2$c59cd670$50d68350$@samsung.com>
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
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: xfs@oss.sgi.com

On Thu, May 08, 2014 at 06:49:14PM +0900, Namjae Jeon wrote:
> There is no need to dip into reserve pool. Reserve pool is used for much
> more important things. And xfs_trans_reserve will never return ENOSPC
> because punch hole is already done. If we get ENOSPC, collapse range
> will be simply failed.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 296160b..91a43c5 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1519,7 +1519,6 @@ xfs_collapse_file_space(
>  
>  	while (!error && !done) {
>  		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
> -		tp->t_flags |= XFS_TRANS_RESERVE;

Makes sense.

>  		/*
>  		 * We would need to reserve permanent block for transaction.
>  		 * This will come into picture when after shifting extent into
> @@ -1529,7 +1528,7 @@ xfs_collapse_file_space(
>  		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
>  				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
>  		if (error) {
> -			ASSERT(error == ENOSPC || XFS_FORCED_SHUTDOWN(mp));
> +			ASSERT(XFS_FORCED_SHUTDOWN(mp));

The xfs_trans_reserve() call still reserves XFS_DIOSTRAT_SPACE_RES()
blocks, so therefore I think ENOSPC is still a possibility. The question
is probably whether or not we need to reserve blocks for this
transaction.

Making a pass through the code... we have the possibility of deleting a
btree record in xfs_bmap_shift_extents(). This in turn could potentially
free a btree block, which frees space. I _think_ this could mean we
want to keep the block reservation because we update the free space
trees, but I suppose that could be handled by the freelist...

Perhaps Dave can confirm which direction we should go here..?

Brian

>  			xfs_trans_cancel(tp, 0);
>  			break;
>  		}
> -- 
> 1.7.11-rc0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
