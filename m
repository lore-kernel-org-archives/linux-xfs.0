Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37294 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933538AbeAKTo1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 14:44:27 -0500
Date: Thu, 11 Jan 2018 11:44:23 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/8] xfs: remove unused buf_fsprivate3
Message-ID: <20180111194423.GC5602@magnolia>
References: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
 <1515699458-6925-4-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515699458-6925-4-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 11, 2018 at 01:37:33PM -0600, Eric Sandeen wrote:
> The buf_fsprivate3 field has no actual use, other than a pointless
> "if it's not set, set it" in xfs_buf_item_init; nobody cares after
> that.  Remove it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  libxfs/libxfs_io.h | 4 ----
>  libxfs/logitem.c   | 2 --
>  2 files changed, 6 deletions(-)
> 
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index 5acd3df..2fce04d 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -70,7 +70,6 @@ typedef struct xfs_buf {
>  	unsigned int		b_recur;
>  	void			*b_fspriv;
>  	void			*b_transp;
> -	void			*b_fsprivate3;
>  	void			*b_addr;
>  	int			b_error;
>  	const struct xfs_buf_ops *b_ops;
> @@ -111,9 +110,6 @@ enum xfs_buf_flags_t {	/* b_flags bits */
>  #define XFS_BUF_SET_ADDR(bp,blk)	((bp)->b_bn = (blk))
>  #define XFS_BUF_SET_COUNT(bp,cnt)	((bp)->b_bcount = (cnt))
>  
> -#define XFS_BUF_FSPRIVATE3(bp,type)	((type)(bp)->b_fsprivate3)
> -#define XFS_BUF_SET_FSPRIVATE3(bp,val)	(bp)->b_fsprivate3 = (void *)(val)
> -
>  #define XFS_BUF_SET_PRIORITY(bp,pri)	cache_node_set_priority( \
>  						libxfs_bcache, \
>  						(struct cache_node *)(bp), \
> diff --git a/libxfs/logitem.c b/libxfs/logitem.c
> index 0c183b5..0c50fcf 100644
> --- a/libxfs/logitem.c
> +++ b/libxfs/logitem.c
> @@ -96,8 +96,6 @@ xfs_buf_item_init(
>  	 * the first.  If we do already have one, there is
>  	 * nothing to do here so return.
>  	 */
> -	if (XFS_BUF_FSPRIVATE3(bp, xfs_mount_t *) != mp)
> -		XFS_BUF_SET_FSPRIVATE3(bp, mp);
>  	XFS_BUF_SET_BDSTRAT_FUNC(bp, xfs_bdstrat_cb);
>  	if (bp->b_fspriv != NULL) {
>  		lip = bp->b_fspriv;
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
