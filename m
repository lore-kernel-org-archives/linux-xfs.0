Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 228117CA2
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 07:40:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A4F5CAC006
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 05:40:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VONYC9NxwaHCAHVx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2016 05:40:10 -0800 (PST)
Date: Wed, 17 Feb 2016 08:40:08 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: better xfs_trans_alloc interface
Message-ID: <20160217134006.GA4065@bfoster.bfoster>
References: <1455699159-20906-1-git-send-email-hch@lst.de>
	<1455699159-20906-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455699159-20906-2-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Feb 17, 2016 at 09:52:38AM +0100, Christoph Hellwig wrote:
> Merge xfs_trans_reserve and xfs_trans_alloc into a single function call
> that returns a transaction with all the required log and block reservations,
> and which allows passing transaction flags directly to avoid the cumbersome
> _xfs_trans_alloc interface.
> 
> While we're at it we also get rid of the transaction type argument that has
> been superflous since we stopped supporting the non-CIL logging mode.  The
> guts of it will be removed in another patch.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks like a nice cleanup to me. A couple comments...

>  fs/xfs/libxfs/xfs_attr.c   | 58 +++++++-----------------------
>  fs/xfs/libxfs/xfs_bmap.c   | 22 +++++-------
>  fs/xfs/libxfs/xfs_sb.c     |  8 ++---
>  fs/xfs/libxfs/xfs_shared.h |  5 +--
>  fs/xfs/xfs_aops.c          | 19 ++++------
>  fs/xfs/xfs_attr_inactive.c | 16 ++-------
>  fs/xfs/xfs_bmap_util.c     | 45 +++++++-----------------
>  fs/xfs/xfs_dquot.c         |  7 ++--
>  fs/xfs/xfs_file.c          |  8 ++---
>  fs/xfs/xfs_fsops.c         | 10 ++----
>  fs/xfs/xfs_inode.c         | 60 ++++++++++++-------------------
>  fs/xfs/xfs_ioctl.c         | 13 +++----
>  fs/xfs/xfs_iomap.c         | 53 +++++++++-------------------
>  fs/xfs/xfs_iops.c          | 22 +++++-------
>  fs/xfs/xfs_log_recover.c   | 10 +++---
>  fs/xfs/xfs_pnfs.c          |  7 ++--
>  fs/xfs/xfs_qm.c            |  9 ++---
>  fs/xfs/xfs_qm_syscalls.c   | 26 ++++----------
>  fs/xfs/xfs_rtalloc.c       | 21 +++++------
>  fs/xfs/xfs_symlink.c       | 16 ++++-----
>  fs/xfs/xfs_trans.c         | 88 +++++++++++++++++++++-------------------------
>  fs/xfs/xfs_trans.h         |  8 ++---
>  22 files changed, 188 insertions(+), 343 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 0d38b1d..3d9b1c48 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -599,10 +599,9 @@ xfs_setattr_nonsize(
>  			return error;
>  	}
>  
> -	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
> -	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
>  	if (error)
> -		goto out_trans_cancel;
> +		goto out_dqrele;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  
> @@ -724,8 +723,7 @@ xfs_setattr_nonsize(
>  
>  out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -out_trans_cancel:
> -	xfs_trans_cancel(tp);

This causes a transaction leak in the event of
xfs_qm_vop_chown_reserve() failure (called earlier in the function,
after transaction allocation).

> +out_dqrele:
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);
>  	return error;
...
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 748b16a..cbbef3a 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
...
> @@ -165,7 +123,7 @@ xfs_trans_dup(
>   * This does not do quota reservations. That typically is done by the
>   * caller afterwards.
>   */
> -int
> +static int
>  xfs_trans_reserve(
>  	struct xfs_trans	*tp,
>  	struct xfs_trans_res	*resp,
> @@ -219,7 +177,7 @@ xfs_trans_reserve(
>  						resp->tr_logres,
>  						resp->tr_logcount,
>  						&tp->t_ticket, XFS_TRANSACTION,
> -						permanent, tp->t_type);
> +						permanent, 0);

So this looks like it effectively breaks xlog_print_tic_res()..? I see
that is all removed in the subsequent patch, but the type still seems
like useful information in the event that an associated problem occurs
with the transaction. In fact, we just had a transaction overrun report
over the weekend (on irc) where at least I thought this was useful
(unfortunately it looks like I lost the reference to the syslog output).

Brian

>  		}
>  
>  		if (error)
> @@ -268,6 +226,42 @@ undo_blocks:
>  	return error;
>  }
>  
> +int
> +xfs_trans_alloc(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans_res	*resp,
> +	uint			blocks,
> +	uint			rtextents,
> +	uint			flags,
> +	struct xfs_trans	**tpp)
> +{
> +	struct xfs_trans	*tp;
> +	int			error;
> +
> +	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
> +		sb_start_intwrite(mp->m_super);
> +
> +	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
> +	atomic_inc(&mp->m_active_trans);
> +
> +	tp = kmem_zone_zalloc(xfs_trans_zone,
> +		(flags & XFS_TRANS_NOFS) ? KM_NOFS : KM_SLEEP);
> +	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
> +	tp->t_flags = flags;
> +	tp->t_mountp = mp;
> +	INIT_LIST_HEAD(&tp->t_items);
> +	INIT_LIST_HEAD(&tp->t_busy);
> +
> +	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> +	if (error) {
> +		xfs_trans_cancel(tp);
> +		return error;
> +	}
> +
> +	*tpp = tp;
> +	return 0;
> +}
> +
>  /*
>   * Record the indicated change to the given field for application
>   * to the file system's superblock when the transaction commits.
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index e7c49cf..9a462e8 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -90,7 +90,6 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
>   */
>  typedef struct xfs_trans {
>  	unsigned int		t_magic;	/* magic number */
> -	unsigned int		t_type;		/* transaction type */
>  	unsigned int		t_log_res;	/* amt of log space resvd */
>  	unsigned int		t_log_count;	/* count for perm log res */
>  	unsigned int		t_blk_res;	/* # of blocks resvd */
> @@ -148,10 +147,9 @@ typedef struct xfs_trans {
>  /*
>   * XFS transaction mechanism exported interfaces.
>   */
> -xfs_trans_t	*xfs_trans_alloc(struct xfs_mount *, uint);
> -xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, xfs_km_flags_t);
> -int		xfs_trans_reserve(struct xfs_trans *, struct xfs_trans_res *,
> -				  uint, uint);
> +int		xfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
> +			uint blocks, uint rtextents, uint flags,
> +			struct xfs_trans **tpp);
>  void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
>  
>  struct xfs_buf	*xfs_trans_get_buf_map(struct xfs_trans *tp,
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
