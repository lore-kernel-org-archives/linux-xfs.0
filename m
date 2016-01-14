Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 08AB17F55
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 11:32:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8D61CAC004
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 09:32:48 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2hRzuskEfIdwj9Bx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2016 09:32:47 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id D7D811204B7
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 17:32:46 +0000 (UTC)
Date: Thu, 14 Jan 2016 12:32:45 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: remove unused function definitions
Message-ID: <20160114173244.GD11448@bfoster.bfoster>
References: <5696CDB1.3060404@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5696CDB1.3060404@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 13, 2016 at 04:20:33PM -0600, Eric Sandeen wrote:
> Old leftovers.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index b25bb9a..961e647 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -27,7 +27,6 @@ extern struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
>  extern void	xfs_perag_put(struct xfs_perag *pag);
>  extern int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
>  
> -extern void	xfs_sb_calc_crc(struct xfs_buf *bp);
>  extern void	xfs_log_sb(struct xfs_trans *tp);
>  extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
>  extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
> diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
> index 1b6a98b..f32713f 100644
> --- a/fs/xfs/xfs_fsops.h
> +++ b/fs/xfs/xfs_fsops.h
> @@ -25,6 +25,5 @@ extern int xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
>  extern int xfs_reserve_blocks(xfs_mount_t *mp, __uint64_t *inval,
>  				xfs_fsop_resblks_t *outval);
>  extern int xfs_fs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
> -extern int xfs_fs_log_dummy(struct xfs_mount *mp);
>  
>  #endif	/* __XFS_FSOPS_H__ */
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index b570984..a4e03ab 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -327,7 +327,6 @@ extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
>  				 bool reserved);
>  extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
>  
> -extern int	xfs_mount_log_sb(xfs_mount_t *);
>  extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
>  extern int	xfs_readsb(xfs_mount_t *, int);
>  extern void	xfs_freesb(xfs_mount_t *);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
