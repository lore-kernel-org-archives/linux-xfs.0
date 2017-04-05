Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53454 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751614AbdDEVs5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 17:48:57 -0400
Subject: Re: [PATCH] xfs: fold __xfs_trans_roll into xfs_trans_roll
References: <20170405185307.9846-1-hch@lst.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f7fdb4fc-3c99-2b64-66c4-0c6fa551266c@sandeen.net>
Date: Wed, 5 Apr 2017 16:48:54 -0500
MIME-Version: 1.0
In-Reply-To: <20170405185307.9846-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On 4/5/17 1:53 PM, Christoph Hellwig wrote:
> No one cares about the low-level helper anymore.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

"Nobody cares" sounds so cold-hearted.  ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_trans.c | 17 ++---------------
>  fs/xfs/xfs_trans.h |  1 -
>  2 files changed, 2 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index a280e126491f..be86e4ed23d5 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1034,17 +1034,14 @@ xfs_trans_cancel(
>   * chunk we've been working on and get a new transaction to continue.
>   */
>  int
> -__xfs_trans_roll(
> +xfs_trans_roll(
>  	struct xfs_trans	**tpp,
> -	struct xfs_inode	*dp,
> -	int			*committed)
> +	struct xfs_inode	*dp)
>  {
>  	struct xfs_trans	*trans;
>  	struct xfs_trans_res	tres;
>  	int			error;
>  
> -	*committed = 0;
> -
>  	/*
>  	 * Ensure that the inode is always logged.
>  	 */
> @@ -1070,7 +1067,6 @@ __xfs_trans_roll(
>  	if (error)
>  		return error;
>  
> -	*committed = 1;
>  	trans = *tpp;
>  
>  	/*
> @@ -1093,12 +1089,3 @@ __xfs_trans_roll(
>  		xfs_trans_ijoin(trans, dp, 0);
>  	return 0;
>  }
> -
> -int
> -xfs_trans_roll(
> -	struct xfs_trans	**tpp,
> -	struct xfs_inode	*dp)
> -{
> -	int			committed;
> -	return __xfs_trans_roll(tpp, dp, &committed);
> -}
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 2a9292df6640..a07acbf0bd8a 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -228,7 +228,6 @@ int		xfs_trans_free_extent(struct xfs_trans *,
>  				      struct xfs_efd_log_item *, xfs_fsblock_t,
>  				      xfs_extlen_t, struct xfs_owner_info *);
>  int		xfs_trans_commit(struct xfs_trans *);
> -int		__xfs_trans_roll(struct xfs_trans **, struct xfs_inode *, int *);
>  int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
>  void		xfs_trans_cancel(xfs_trans_t *);
>  int		xfs_trans_ail_init(struct xfs_mount *);
> 
