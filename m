Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43476 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfFXP6t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 11:58:49 -0400
Date: Mon, 24 Jun 2019 08:58:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/12] xfs: remove XFS_TRANS_NOFS
Message-ID: <20190624155821.GM5387@magnolia>
References: <20190624055253.31183-1-hch@lst.de>
 <20190624055253.31183-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624055253.31183-7-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jun 24, 2019 at 07:52:47AM +0200, Christoph Hellwig wrote:
> Instead of a magic flag for xfs_trans_alloc, just ensure all callers
> that can't relclaim through the file system use memalloc_nofs_save to
> set the per-task nofs flag.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hmm this finally fixes up the mess I left where COW fork cleanup
sometimes needs nofs and other times doesn't... :)

> ---
>  fs/xfs/libxfs/xfs_shared.h |  1 -
>  fs/xfs/xfs_aops.c          | 12 +++++++++---
>  fs/xfs/xfs_file.c          | 12 +++++++++---
>  fs/xfs/xfs_iomap.c         |  2 +-
>  fs/xfs/xfs_reflink.c       |  4 ++--
>  fs/xfs/xfs_trans.c         |  4 +---
>  6 files changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index 4e909791aeac..1f2b5a0c71b4 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -65,7 +65,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>  #define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
>  #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
>  #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
> -#define XFS_TRANS_NOFS		0x80	/* pass KM_NOFS to kmem_alloc */
>  /*
>   * LOWMODE is used by the allocator to activate the lowspace algorithm - when
>   * free space is running low the extent allocator may choose to allocate an
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 93a760f13017..633baaaff7ae 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -138,8 +138,7 @@ xfs_setfilesize_trans_alloc(
>  	struct xfs_trans	*tp;
>  	int			error;
>  
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0,
> -				XFS_TRANS_NOFS, &tp);
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
>  	if (error)
>  		return error;
>  
> @@ -236,6 +235,7 @@ STATIC void
>  xfs_end_ioend(
>  	struct xfs_ioend	*ioend)
>  {
> +	unsigned int		nofs_flag = memalloc_nofs_save();
>  	struct list_head	ioend_list;
>  	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
>  	xfs_off_t		offset = ioend->io_offset;
> @@ -282,6 +282,8 @@ xfs_end_ioend(
>  		list_del_init(&ioend->io_list);
>  		xfs_destroy_ioend(ioend, error);
>  	}
> +
> +	memalloc_nofs_restore(nofs_flag);
>  }
>  
>  /*
> @@ -663,8 +665,12 @@ xfs_submit_ioend(
>  	    (ioend->io_fork == XFS_COW_FORK ||
>  	     ioend->io_type != IOMAP_UNWRITTEN) &&
>  	    xfs_ioend_is_append(ioend) &&
> -	    !ioend->io_append_trans)
> +	    !ioend->io_append_trans) {
> +		unsigned nofs_flag = memalloc_nofs_save();

unsigned int?  Seeing as you use that everywhere else...

--D

> +
>  		status = xfs_setfilesize_trans_alloc(ioend);
> +		memalloc_nofs_restore(nofs_flag);
> +	}
>  
>  	ioend->io_bio->bi_private = ioend;
>  	ioend->io_bio->bi_end_io = xfs_end_bio;
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 916a35cae5e9..f2d806ef8f06 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -379,6 +379,7 @@ xfs_dio_write_end_io(
>  	struct inode		*inode = file_inode(iocb->ki_filp);
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	loff_t			offset = iocb->ki_pos;
> +	unsigned int		nofs_flag;
>  	int			error = 0;
>  
>  	trace_xfs_end_io_direct_write(ip, offset, size);
> @@ -395,10 +396,11 @@ xfs_dio_write_end_io(
>  	 */
>  	XFS_STATS_ADD(ip->i_mount, xs_write_bytes, size);
>  
> +	nofs_flag = memalloc_nofs_save();
>  	if (flags & IOMAP_DIO_COW) {
>  		error = xfs_reflink_end_cow(ip, offset, size);
>  		if (error)
> -			return error;
> +			goto out;
>  	}
>  
>  	/*
> @@ -407,8 +409,10 @@ xfs_dio_write_end_io(
>  	 * earlier allows a racing dio read to find unwritten extents before
>  	 * they are converted.
>  	 */
> -	if (flags & IOMAP_DIO_UNWRITTEN)
> -		return xfs_iomap_write_unwritten(ip, offset, size, true);
> +	if (flags & IOMAP_DIO_UNWRITTEN) {
> +		error = xfs_iomap_write_unwritten(ip, offset, size, true);
> +		goto out;
> +	}
>  
>  	/*
>  	 * We need to update the in-core inode size here so that we don't end up
> @@ -430,6 +434,8 @@ xfs_dio_write_end_io(
>  		spin_unlock(&ip->i_flags_lock);
>  	}
>  
> +out:
> +	memalloc_nofs_restore(nofs_flag);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 6b29452bfba0..461ea023b910 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -782,7 +782,7 @@ xfs_iomap_write_unwritten(
>  		 * complete here and might deadlock on the iolock.
>  		 */
>  		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
> -				XFS_TRANS_RESERVE | XFS_TRANS_NOFS, &tp);
> +				XFS_TRANS_RESERVE, &tp);
>  		if (error)
>  			return error;
>  
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 680ae7662a78..0b23c2b29609 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -572,7 +572,7 @@ xfs_reflink_cancel_cow_range(
>  
>  	/* Start a rolling transaction to remove the mappings */
>  	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_write,
> -			0, 0, XFS_TRANS_NOFS, &tp);
> +			0, 0, 0, &tp);
>  	if (error)
>  		goto out;
>  
> @@ -631,7 +631,7 @@ xfs_reflink_end_cow_extent(
>  
>  	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
> -			XFS_TRANS_RESERVE | XFS_TRANS_NOFS, &tp);
> +			XFS_TRANS_RESERVE, &tp);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 0746b329a937..21228d7455af 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -264,9 +264,7 @@ xfs_trans_alloc(
>  	 * GFP_NOFS allocation context so that we avoid lockdep false positives
>  	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
>  	 */
> -	tp = kmem_zone_zalloc(xfs_trans_zone,
> -		(flags & XFS_TRANS_NOFS) ? KM_NOFS : KM_SLEEP);
> -
> +	tp = kmem_zone_zalloc(xfs_trans_zone, KM_SLEEP);
>  	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
>  		sb_start_intwrite(mp->m_super);
>  
> -- 
> 2.20.1
> 
