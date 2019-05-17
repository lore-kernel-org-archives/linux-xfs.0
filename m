Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54392 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfEQVMA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 17:12:00 -0400
Subject: Re: [PATCH 3/3] xfsprogs: remove unused flags arg from getsb
 interfaces
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
 <9807c398-8bfe-367f-3f45-0ff3d5ad84f9@sandeen.net>
From: Allison Collins <allison.henderson@oracle.com>
Message-ID: <cb1ff021-c170-1c4b-a94a-5e8ca84f281a@oracle.com>
Date: Fri, 17 May 2019 14:09:36 -0700
MIME-Version: 1.0
In-Reply-To: <9807c398-8bfe-367f-3f45-0ff3d5ad84f9@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 5/16/19 10:46 AM, Eric Sandeen wrote:
> The flags value is always* passed as 0 so remove the argument.
> 
> *mkfs.xfs is the sole exception; it passes a flag to fail on read
> error, but we can easily detect the error and exit from main()
> manually instead.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok to me.

Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
> 
> (This one might actually come in via a libxfs merge instead)
> 
> diff --git a/include/xfs_trans.h b/include/xfs_trans.h
> index d32acc9e..953da5d1 100644
> --- a/include/xfs_trans.h
> +++ b/include/xfs_trans.h
> @@ -87,7 +87,7 @@ void	xfs_trans_cancel(struct xfs_trans *);
>   /* cancel dfops associated with a transaction */
>   void xfs_defer_cancel(struct xfs_trans *);
>   
> -struct xfs_buf *xfs_trans_getsb(struct xfs_trans *, struct xfs_mount *, int);
> +struct xfs_buf *xfs_trans_getsb(struct xfs_trans *, struct xfs_mount *);
>   
>   void	xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
>   void	xfs_trans_log_inode (struct xfs_trans *, struct xfs_inode *,
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index 8fa2c2c5..4dc4d5f3 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -177,7 +177,7 @@ extern void	libxfs_putbuf (xfs_buf_t *);
>   
>   extern void	libxfs_readbuf_verify(struct xfs_buf *bp,
>   			const struct xfs_buf_ops *ops);
> -extern xfs_buf_t *xfs_getsb(struct xfs_mount *, int);
> +extern xfs_buf_t *xfs_getsb(struct xfs_mount *);
>   extern void	libxfs_bcache_purge(void);
>   extern void	libxfs_bcache_free(void);
>   extern void	libxfs_bcache_flush(void);
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 8d6f958a..132ed0a9 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -476,10 +476,10 @@ libxfs_trace_putbuf(const char *func, const char *file, int line, xfs_buf_t *bp)
>   
>   
>   xfs_buf_t *
> -xfs_getsb(xfs_mount_t *mp, int flags)
> +xfs_getsb(xfs_mount_t *mp)
>   {
>   	return libxfs_readbuf(mp->m_ddev_targp, XFS_SB_DADDR,
> -				XFS_FSS_TO_BB(mp, 1), flags, &xfs_sb_buf_ops);
> +				XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
>   }
>   
>   kmem_zone_t			*xfs_buf_zone;
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 5ef0c055..9e49def0 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -628,8 +628,7 @@ xfs_trans_get_buf_map(
>   xfs_buf_t *
>   xfs_trans_getsb(
>   	xfs_trans_t		*tp,
> -	xfs_mount_t		*mp,
> -	int			flags)
> +	xfs_mount_t		*mp)
>   {
>   	xfs_buf_t		*bp;
>   	xfs_buf_log_item_t	*bip;
> @@ -637,7 +636,7 @@ xfs_trans_getsb(
>   	DEFINE_SINGLE_BUF_MAP(map, XFS_SB_DADDR, len);
>   
>   	if (tp == NULL)
> -		return xfs_getsb(mp, flags);
> +		return xfs_getsb(mp);
>   
>   	bp = xfs_trans_buf_item_match(tp, mp->m_dev, &map, 1);
>   	if (bp != NULL) {
> @@ -648,7 +647,7 @@ xfs_trans_getsb(
>   		return bp;
>   	}
>   
> -	bp = xfs_getsb(mp, flags);
> +	bp = xfs_getsb(mp);
>   #ifdef XACT_DEBUG
>   	fprintf(stderr, "trans_get_sb buffer %p, transaction %p\n", bp, tp);
>   #endif
> diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
> index f1e2ba57..a1857e10 100644
> --- a/libxfs/xfs_sb.c
> +++ b/libxfs/xfs_sb.c
> @@ -915,7 +915,7 @@ xfs_log_sb(
>   	struct xfs_trans	*tp)
>   {
>   	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp, 0);
> +	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp);
>   
>   	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
>   	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> @@ -1045,7 +1045,7 @@ xfs_sync_sb_buf(
>   	if (error)
>   		return error;
>   
> -	bp = xfs_trans_getsb(tp, mp, 0);
> +	bp = xfs_trans_getsb(tp, mp);
>   	xfs_log_sb(tp);
>   	xfs_trans_bhold(tp, bp);
>   	xfs_trans_set_sync(tp);
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 09106648..647e2bc2 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -4123,7 +4123,11 @@ main(
>   	/*
>   	 * Mark the filesystem ok.
>   	 */
> -	buf = libxfs_getsb(mp, LIBXFS_EXIT_ON_FAILURE);
> +	buf = libxfs_getsb(mp);
> +	if (!buf) {
> +		fprintf(stderr, _("couldn't get superblock\n"));
> +		exit(1);
> +	}
>   	(XFS_BUF_TO_SBP(buf))->sb_inprogress = 0;
>   	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
>   
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 0f6a8395..8ad32365 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -2177,7 +2177,7 @@ sync_sb(xfs_mount_t *mp)
>   {
>   	xfs_buf_t	*bp;
>   
> -	bp = libxfs_getsb(mp, 0);
> +	bp = libxfs_getsb(mp);
>   	if (!bp)
>   		do_error(_("couldn't get superblock\n"));
>   
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 9657503f..4000b3e6 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -1044,7 +1044,7 @@ _("Warning:  project quota information would be cleared.\n"
>   	/*
>   	 * Clear the quota flags if they're on.
>   	 */
> -	sbp = libxfs_getsb(mp, 0);
> +	sbp = libxfs_getsb(mp);
>   	if (!sbp)
>   		do_error(_("couldn't get superblock\n"));
>   
> 
