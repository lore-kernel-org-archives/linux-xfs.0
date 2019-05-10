Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42678 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbfEJVkX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 May 2019 17:40:23 -0400
Subject: Re: [PATCH V2] xfs: remove unused flags arg from getsb interfaces
From: Eric Sandeen <sandeen@sandeen.net>
References: <d678aac9-c213-36ef-1149-4d510bf85008@redhat.com>
 <e499ead7-4cbc-163e-02b3-0750f2508e51@sandeen.net>
Message-ID: <fefa6704-e4af-a6e9-d8f2-2a3e977ba2d4@sandeen.net>
Date: Fri, 10 May 2019 16:40:22 -0500
MIME-Version: 1.0
In-Reply-To: <e499ead7-4cbc-163e-02b3-0750f2508e51@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 5/10/19 11:52 AM, Eric Sandeen wrote:
> The flags value is always passed as 0 so remove the argument.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> V2: Drop the trylock that's now pointless w/o the flag.

Urk, we actually use a flag with libxfs_sb in userspace, to fail
on exit.

But I think the one caller of that (mkfs) can just test for error
and exit(1) if there's failure, to stay in sync w/ kernelspace.

-Eric

> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index e76a3e5d28d7..f1c60aa5d312 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -939,7 +939,7 @@ xfs_log_sb(
>  	struct xfs_trans	*tp)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp, 0);
> +	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp);
>  
>  	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
>  	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> @@ -1069,7 +1069,7 @@ xfs_sync_sb_buf(
>  	if (error)
>  		return error;
>  
> -	bp = xfs_trans_getsb(tp, mp, 0);
> +	bp = xfs_trans_getsb(tp, mp);
>  	xfs_log_sb(tp);
>  	xfs_trans_bhold(tp, bp);
>  	xfs_trans_set_sync(tp);
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 9329f5adbfbe..4cb7d4906c33 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -5687,7 +5687,7 @@ xlog_do_recover(
>  	 * Now that we've finished replaying all buffer and inode
>  	 * updates, re-read in the superblock and reverify it.
>  	 */
> -	bp = xfs_getsb(mp, 0);
> +	bp = xfs_getsb(mp);
>  	bp->b_flags &= ~(XBF_DONE | XBF_ASYNC);
>  	ASSERT(!(bp->b_flags & XBF_WRITE));
>  	bp->b_flags |= XBF_READ;
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 6b2bfe81dc51..70a93f3b914e 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1385,24 +1385,14 @@ xfs_mod_frextents(
>   * xfs_getsb() is called to obtain the buffer for the superblock.
>   * The buffer is returned locked and read in from disk.
>   * The buffer should be released with a call to xfs_brelse().
> - *
> - * If the flags parameter is BUF_TRYLOCK, then we'll only return
> - * the superblock buffer if it can be locked without sleeping.
> - * If it can't then we'll return NULL.
>   */
>  struct xfs_buf *
>  xfs_getsb(
> -	struct xfs_mount	*mp,
> -	int			flags)
> +	struct xfs_mount	*mp)
>  {
>  	struct xfs_buf		*bp = mp->m_sb_bp;
>  
> -	if (!xfs_buf_trylock(bp)) {
> -		if (flags & XBF_TRYLOCK)
> -			return NULL;
> -		xfs_buf_lock(bp);
> -	}
> -
> +	xfs_buf_lock(bp);
>  	xfs_buf_hold(bp);
>  	ASSERT(bp->b_flags & XBF_DONE);
>  	return bp;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index c81a5cd7c228..11073b470c41 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -465,7 +465,7 @@ extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
>  				 bool reserved);
>  extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
>  
> -extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
> +extern struct xfs_buf *xfs_getsb(xfs_mount_t *);
>  extern int	xfs_readsb(xfs_mount_t *, int);
>  extern void	xfs_freesb(xfs_mount_t *);
>  extern bool	xfs_fs_writable(struct xfs_mount *mp, int level);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 912b42f5fe4a..0746b329a937 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -452,7 +452,7 @@ xfs_trans_apply_sb_deltas(
>  	xfs_buf_t	*bp;
>  	int		whole = 0;
>  
> -	bp = xfs_trans_getsb(tp, tp->t_mountp, 0);
> +	bp = xfs_trans_getsb(tp, tp->t_mountp);
>  	sbp = XFS_BUF_TO_SBP(bp);
>  
>  	/*
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index c6e1c5704a8c..fd35da161a2b 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -203,7 +203,7 @@ xfs_trans_read_buf(
>  				      flags, bpp, ops);
>  }
>  
> -struct xfs_buf	*xfs_trans_getsb(xfs_trans_t *, struct xfs_mount *, int);
> +struct xfs_buf	*xfs_trans_getsb(xfs_trans_t *, struct xfs_mount *);
>  
>  void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
>  void		xfs_trans_bjoin(xfs_trans_t *, struct xfs_buf *);
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 7d65ebf1e847..a1764a1dbd99 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -174,8 +174,7 @@ xfs_trans_get_buf_map(
>  xfs_buf_t *
>  xfs_trans_getsb(
>  	xfs_trans_t		*tp,
> -	struct xfs_mount	*mp,
> -	int			flags)
> +	struct xfs_mount	*mp)
>  {
>  	xfs_buf_t		*bp;
>  	struct xfs_buf_log_item	*bip;
> @@ -185,7 +184,7 @@ xfs_trans_getsb(
>  	 * if tp is NULL.
>  	 */
>  	if (tp == NULL)
> -		return xfs_getsb(mp, flags);
> +		return xfs_getsb(mp);
>  
>  	/*
>  	 * If the superblock buffer already has this transaction
> @@ -203,7 +202,7 @@ xfs_trans_getsb(
>  		return bp;
>  	}
>  
> -	bp = xfs_getsb(mp, flags);
> +	bp = xfs_getsb(mp);
>  	if (bp == NULL)
>  		return NULL;
>  
> 
