Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:52738 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728244AbeHMKqV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Aug 2018 06:46:21 -0400
Received: by mail-wm0-f65.google.com with SMTP id o11-v6so7859853wmh.2
        for <linux-xfs@vger.kernel.org>; Mon, 13 Aug 2018 01:05:11 -0700 (PDT)
Date: Mon, 13 Aug 2018 10:05:08 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 4/6] xfs: fix buffer state management in
 xrep_findroot_block
Message-ID: <20180813080508.ocnhzyke6jfvhxrb@odin.usersys.redhat.com>
References: <153400169747.27471.4044680761841034489.stgit@magnolia>
 <153400172200.27471.13133656951315541955.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153400172200.27471.13133656951315541955.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Aug 11, 2018 at 08:35:22AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We don't quite handle buffer state properly in online repair's findroot
> routine.  If the buffer is already in-core we don't want to trash its
> b_ops and state, so first we should try _get_buf to grab the buffer.  If
> the buffer is loaded, we only want to verify the structure of the buffer
> since it could be dirty and the crc hasn't yet been recalculated.
> 
> Only if the buffer hasn't been read in should try _read_buf, and if we
> were the ones who read the buffer then we must be careful to oneshot the
> buffer so that a subsequent _read_buf won't find a buffer with no ops.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/scrub/repair.c |   67 +++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 54 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 97c3077fb005..fae50dced8bc 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -697,6 +697,7 @@ xrep_findroot_block(
>  	struct xfs_mount		*mp = ri->sc->mp;
>  	struct xfs_buf			*bp;
>  	struct xfs_btree_block		*btblock;
> +	xfs_failaddr_t			fa;
>  	xfs_daddr_t			daddr;
>  	int				block_level;
>  	int				error;
> @@ -718,28 +719,68 @@ xrep_findroot_block(
>  			return error;
>  	}
>  
> -	error = xfs_trans_read_buf(mp, ri->sc->tp, mp->m_ddev_targp, daddr,
> -			mp->m_bsize, 0, &bp, NULL);
> -	if (error)
> -		return error;
> -
>  	/*
> -	 * Does this look like a block matching our fs and higher than any
> -	 * other block we've found so far?  If so, reattach buffer verifiers
> -	 * so the AIL won't complain if the buffer is also dirty.
> +	 * Try to grab the buffer, on the off chance it's already in memory.
> +	 * If the buffer doesn't have the DONE flag set it hasn't been read
> +	 * into memory yet.  Drop the buffer and read the buffer with NULL
> +	 * b_ops.  (This could race with another read_buf.)  If we get the
> +	 * buffer back with NULL b_ops then we know that there weren't any
> +	 * other readers.  There's a risk we won't match the buffer with any
> +	 * of the findroot prototypes, so we want to encourage the buffer layer
> +	 * to drop the buffer as soon as possible.
>  	 */
> +	bp = xfs_trans_get_buf(ri->sc->tp, mp->m_ddev_targp, daddr,
> +			mp->m_bsize, 0);
> +	if (!bp)
> +		return -ENOMEM;
> +	if (!(bp->b_flags & XBF_DONE)) {
> +		xfs_trans_brelse(ri->sc->tp, bp);
> +
> +		error = xfs_trans_read_buf(mp, ri->sc->tp, mp->m_ddev_targp,
> +				daddr, mp->m_bsize, 0, &bp, NULL);
> +		if (error)
> +			return error;
> +		if (!bp->b_ops)
> +			xfs_buf_oneshot(bp);
> +	}
> +
> +	/* Does this look like a block matching our fs? */
>  	btblock = XFS_BUF_TO_BLOCK(bp);
>  	if (be32_to_cpu(btblock->bb_magic) != fab->magic)
>  		goto out;
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
>  	    !uuid_equal(&btblock->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
>  		goto out;
> -	bp->b_ops = fab->buf_ops;
>  
> -	/* Make sure we pass the verifiers. */
> -	bp->b_ops->verify_read(bp);
> -	if (bp->b_error)
> -		goto out;
> +	/*
> +	 * We've matched this buffer by magic number to this findroot
> +	 * prototype.  If there are no buffer ops attached, attach the one
> +	 * specified by the prototype.  Otherwise, the buffer ops must match
> +	 * the prototype.   We don't want to disturb existing b_ops.
> +	 */
> +	if (bp->b_ops) {
> +		if (bp->b_ops != fab->buf_ops)
> +			goto out;
> +		/*
> +		 * If the buffer was already incore (on a v5 fs) then it should
> +		 * already have had b_ops assigned.  Call ->verify_struct to
> +		 * check the structure.  Avoid checking the CRC because we
> +		 * don't calculate CRCs until the buffer is written by the log.
> +		 */
> +		fa = bp->b_ops->verify_struct(bp);
> +		if (fa)
> +			goto out;
> +	} else {
> +		/*
> +		 * If we have to assign buffer ops, that means that nobody's
> +		 * checked the buffer structure or its CRC.  Do both now by
> +		 * calling ->verify_read.
> +		 */
> +		bp->b_ops = fab->buf_ops;
> +		bp->b_ops->verify_read(bp);
> +		if (bp->b_error)
> +			goto out;
> +	}
>  
>  	/* If we've recorded a root candidate... */
>  	block_level = xfs_btree_get_level(btblock);
> 

-- 
Carlos
