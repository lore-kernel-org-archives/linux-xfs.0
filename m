Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42568 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751073AbdCAQrX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Mar 2017 11:47:23 -0500
Date: Wed, 1 Mar 2017 11:56:46 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/9] xfs: add a couple of queries to iterate free extents
 in the rtbitmap
Message-ID: <20170301165645.GA3312@bfoster.bfoster>
References: <148830755018.22089.4423076490708341523.stgit@birch.djwong.org>
 <148830758195.22089.11914775154975299005.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148830758195.22089.11914775154975299005.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@djwong.org>

On Tue, Feb 28, 2017 at 10:46:22AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add _query_range and _query_all functions to the realtime bitmap
> allocator.  These two functions are similar in usage to the btree
> functions with the same name and will be used for getfsmap and scrub.
> 
> Signed-off-by: Darrick J. Wong <djwong@djwong.org>
> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c |   70 ++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_rtalloc.h         |   22 ++++++++++++-
>  2 files changed, 90 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index ea45584..e47b99e 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
...
> diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
> index 355dd9e..b0d2761 100644
> --- a/fs/xfs/xfs_rtalloc.h
> +++ b/fs/xfs/xfs_rtalloc.h
> @@ -23,6 +23,16 @@
>  struct xfs_mount;
>  struct xfs_trans;
>  
> +struct xfs_rtalloc_rec {
> +	xfs_rtblock_t		ar_startblock;
> +	xfs_rtblock_t		ar_blockcount;
> +};
> +
> +typedef int (*xfs_rtalloc_query_range_fn)(
> +	struct xfs_trans	*tp,
> +	struct xfs_rtalloc_rec	*rec,
> +	void			*priv);
> +
>  #ifdef CONFIG_XFS_RT
>  /*
>   * Function prototypes for exported functions.
> @@ -119,13 +129,21 @@ int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,

FWIW, this hunk (below) didn't apply cleanly to my for-next branch.
It's straightforward to apply manually, so I'm not sure what the
conflict was. Whitespace perhaps? Just FYI.

Otherwise the rest looks fine to me. I'm not terribly familiar with the
rt stuff, so FWIW:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
>  		     xfs_rtblock_t start, xfs_extlen_t len,
>  		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
> -
> -
> +int xfs_rtalloc_query_range(struct xfs_trans *tp,
> +			    struct xfs_rtalloc_rec *low_rec,
> +			    struct xfs_rtalloc_rec *high_rec,
> +			    xfs_rtalloc_query_range_fn fn,
> +			    void *priv);
> +int xfs_rtalloc_query_all(struct xfs_trans *tp,
> +			  xfs_rtalloc_query_range_fn fn,
> +			  void *priv);
>  #else
>  # define xfs_rtallocate_extent(t,b,min,max,l,a,f,p,rb)  (ENOSYS)
>  # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
>  # define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
>  # define xfs_growfs_rt(mp,in)                           (ENOSYS)
> +# define xfs_rtalloc_query_range(t,l,h,f,p)             (ENOSYS)
> +# define xfs_rtalloc_query_all(t,f,p)                   (ENOSYS)
>  static inline int		/* error */
>  xfs_rtmount_init(
>  	xfs_mount_t	*mp)	/* file system mount structure */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
