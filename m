Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:38613 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751442AbeFEKmL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 06:42:11 -0400
Received: by mail-wm0-f65.google.com with SMTP id m129-v6so4110239wmb.3
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jun 2018 03:42:10 -0700 (PDT)
Date: Tue, 5 Jun 2018 12:42:07 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 4/6 v2] xfs: validate btree records on retreival
Message-ID: <20180605104207.3qlaudozsmjrize7@odin.usersys.redhat.com>
References: <20180605062423.4877-1-david@fromorbit.com>
 <20180605062423.4877-5-david@fromorbit.com>
 <20180605064043.GH10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605064043.GH10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

>  	union xfs_btree_rec	*rec;
>  	int			error;
>  
> @@ -222,12 +224,28 @@ xfs_alloc_get_rec(
>  	if (error || !(*stat))
>  		return error;
>  	if (rec->alloc.ar_blockcount == 0)
> -		return -EFSCORRUPTED;
> +		goto out_bad_rec;
>  
>  	*bno = be32_to_cpu(rec->alloc.ar_startblock);
>  	*len = be32_to_cpu(rec->alloc.ar_blockcount);
>  
> -	return error;
> +	/* check for valid extent range, including overflow */
> +	if (!xfs_verify_agbno(mp, agno, *bno))
> +		goto out_bad_rec;
> +	if (*bno > *bno + *len)
> +		goto out_bad_rec;
> +	if (!xfs_verify_agbno(mp, agno, *bno + *len - 1))
> +		goto out_bad_rec;
> +
> +	return 0;
> +
> +out_bad_rec:
> +	xfs_warn(mp,
> +		"%s Freespace BTree record corruption in AG %d detected!",
> +		cur->bc_btnum == XFS_BTNUM_BNO ? "Block" : "Size", agno);
> +	xfs_warn(mp,
> +		"start block 0x%x block count 0x%x", *bno, *len);
> +	return -EFSCORRUPTED;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index ec5ea02b5553..3f551eb29157 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -121,16 +121,45 @@ xfs_inobt_get_rec(
>  	struct xfs_inobt_rec_incore	*irec,
>  	int				*stat)
>  {
> +	struct xfs_mount		*mp = cur->bc_mp;
> +	xfs_agnumber_t			agno = cur->bc_private.a.agno;
>  	union xfs_btree_rec		*rec;
>  	int				error;
> +	uint64_t			realfree;
>  
>  	error = xfs_btree_get_rec(cur, &rec, stat);
>  	if (error || *stat == 0)
>  		return error;
>  
> -	xfs_inobt_btrec_to_irec(cur->bc_mp, rec, irec);
> +	xfs_inobt_btrec_to_irec(mp, rec, irec);
> +
> +	if (!xfs_verify_agino(mp, agno, irec->ir_startino))
> +		goto out_bad_rec;
> +	if (irec->ir_count < XFS_INODES_PER_HOLEMASK_BIT ||
> +	    irec->ir_count > XFS_INODES_PER_CHUNK)
> +		goto out_bad_rec;
> +	if (irec->ir_freecount > XFS_INODES_PER_CHUNK)
> +		goto out_bad_rec;
> +
> +	/* if there are no holes, return the first available offset */
> +	if (!xfs_inobt_issparse(irec->ir_holemask))
> +		realfree = irec->ir_free;
> +	else
> +		realfree = irec->ir_free & xfs_inobt_irec_to_allocmask(irec);
> +	if (hweight64(realfree) != irec->ir_freecount)
> +		goto out_bad_rec;
>  
>  	return 0;
> +
> +out_bad_rec:
> +	xfs_warn(mp,
> +		"%s Inode BTree record corruption in AG %d detected!",
> +		cur->bc_btnum == XFS_BTNUM_INO ? "Used" : "Free", agno);
> +	xfs_warn(mp,
> +"start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
> +		irec->ir_startino, irec->ir_count, irec->ir_freecount,
> +		irec->ir_free, irec->ir_holemask);
> +	return -EFSCORRUPTED;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index ed5704c7dcf5..9a2a2004af24 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -111,16 +111,51 @@ xfs_refcount_get_rec(
>  	struct xfs_refcount_irec	*irec,
>  	int				*stat)
>  {
> +	struct xfs_mount		*mp = cur->bc_mp;
> +	xfs_agnumber_t			agno = cur->bc_private.a.agno;
>  	union xfs_btree_rec		*rec;
>  	int				error;
> +	xfs_agblock_t			realstart;
>  
>  	error = xfs_btree_get_rec(cur, &rec, stat);
> -	if (!error && *stat == 1) {
> -		xfs_refcount_btrec_to_irec(rec, irec);
> -		trace_xfs_refcount_get(cur->bc_mp, cur->bc_private.a.agno,
> -				irec);
> +	if (error || !*stat)
> +		return error;
> +
> +	xfs_refcount_btrec_to_irec(rec, irec);
> +
> +	agno = cur->bc_private.a.agno;
> +	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
> +		goto out_bad_rec;
> +
> +	/* handle special COW-staging state */
> +	realstart = irec->rc_startblock;
> +	if (realstart & XFS_REFC_COW_START) {
> +		if (irec->rc_refcount != 1)
> +			goto out_bad_rec;
> +		realstart &= ~XFS_REFC_COW_START;
>  	}
> -	return error;
> +
> +	/* check for valid extent range, including overflow */
> +	if (!xfs_verify_agbno(mp, agno, realstart))
> +		goto out_bad_rec;
> +	if (realstart > realstart + irec->rc_blockcount)

I am not sure if I'm right, but I thought this ought to be ">="?

Other than that, you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos
