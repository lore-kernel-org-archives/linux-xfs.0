Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C32C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90AE161A22
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237376AbhCXSH0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237391AbhCXSHM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:07:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D89C261A1E;
        Wed, 24 Mar 2021 18:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616609232;
        bh=HEGFMMiCvRYaAfj34Cn3qYrcU48iI1CdNiacYY5OPsc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=izK6sZlUuHAGY3KlGWRXLG0W4YC4MugRnE5MF6s3NQ/0HZe8gmv4TIJv0gDEnlegq
         oAR/OWvK6kAj0qkhO9uj92NE64S466vWEyHvl8V3no9EqsXrwCR9h/LWP2XCDdTVJs
         VNMK5B/htGIRj/x1L7Ivd4TP5gztklHcqMEGjAgmz2k5uIBqe+0frMmnMbYbmjpyFn
         aJK8FTDycW+3JBc1s0ayr21Ak14n2VTqAW6aQRlMKanozSCPQkk3H9nW8AmfNX+UU8
         PaEzUoYSh2e2MMmHW49pnjR6rmhJ9biPQOZzT+4CX5q43LKappe34lSoTSMCu8O8ON
         wVuWLWpEkcojQ==
Date:   Wed, 24 Mar 2021 11:07:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/18] xfs: split xfs_imap_to_bp
Message-ID: <20210324180711.GZ22100@magnolia>
References: <20210324142129.1011766-1-hch@lst.de>
 <20210324142129.1011766-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324142129.1011766-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 03:21:12PM +0100, Christoph Hellwig wrote:
> Split looking up the dinode from xfs_imap_to_bp, which can be
> significantly simplified as a result.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Oh good, I always thought the dipp parameter was gross.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c   | 27 ++++-----------------------
>  fs/xfs/libxfs/xfs_inode_buf.h   |  5 ++---
>  fs/xfs/libxfs/xfs_trans_inode.c |  3 +--
>  fs/xfs/scrub/ialloc.c           |  3 +--
>  fs/xfs/xfs_icache.c             |  6 +++---
>  fs/xfs/xfs_inode.c              |  6 ++++--
>  fs/xfs/xfs_log_recover.c        |  3 ++-
>  7 files changed, 17 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 4d7410e49db41b..af5ee8bd7e6ac9 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -124,37 +124,18 @@ const struct xfs_buf_ops xfs_inode_buf_ra_ops = {
>  /*
>   * This routine is called to map an inode to the buffer containing the on-disk
>   * version of the inode.  It returns a pointer to the buffer containing the
> - * on-disk inode in the bpp parameter, and in the dipp parameter it returns a
> - * pointer to the on-disk inode within that buffer.
> - *
> - * If a non-zero error is returned, then the contents of bpp and dipp are
> - * undefined.
> + * on-disk inode in the bpp parameter.
>   */
>  int
>  xfs_imap_to_bp(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
>  	struct xfs_imap		*imap,
> -	struct xfs_dinode       **dipp,
> -	struct xfs_buf		**bpp,
> -	uint			buf_flags)
> +	struct xfs_buf		**bpp)
>  {
> -	struct xfs_buf		*bp;
> -	int			error;
> -
> -	buf_flags |= XBF_UNMAPPED;
> -	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
> -				   (int)imap->im_len, buf_flags, &bp,
> +	return xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
> +				   imap->im_len, XBF_UNMAPPED, bpp,
>  				   &xfs_inode_buf_ops);
> -	if (error) {
> -		ASSERT(error != -EAGAIN || (buf_flags & XBF_TRYLOCK));
> -		return error;
> -	}
> -
> -	*bpp = bp;
> -	if (dipp)
> -		*dipp = xfs_buf_offset(bp, imap->im_boffset);
> -	return 0;
>  }
>  
>  static inline struct timespec64 xfs_inode_decode_bigtime(uint64_t ts)
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index ef5eaf33d146ff..9e1ae38380b3c0 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -47,9 +47,8 @@ struct xfs_imap {
>  	unsigned short	im_boffset;	/* inode offset in block in bytes */
>  };
>  
> -int	xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
> -		       struct xfs_imap *, struct xfs_dinode **,
> -		       struct xfs_buf **, uint);
> +int	xfs_imap_to_bp(struct xfs_mount *mp, struct xfs_trans *tp,
> +		       struct xfs_imap *imap, struct xfs_buf **bpp);
>  void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
>  void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
>  			  xfs_lsn_t lsn);
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index 90f1d564505270..4f02cb439ab57e 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -164,8 +164,7 @@ xfs_trans_log_inode(
>  		 * here.
>  		 */
>  		spin_unlock(&iip->ili_lock);
> -		error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, NULL,
> -					&bp, 0);
> +		error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, &bp);
>  		if (error) {
>  			xfs_force_shutdown(ip->i_mount, SHUTDOWN_META_IO_ERROR);
>  			return;
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 6517d67e8d51f8..1644199c29a815 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -212,7 +212,6 @@ xchk_iallocbt_check_cluster(
>  {
>  	struct xfs_imap			imap;
>  	struct xfs_mount		*mp = bs->cur->bc_mp;
> -	struct xfs_dinode		*dip;
>  	struct xfs_buf			*cluster_bp;
>  	unsigned int			nr_inodes;
>  	xfs_agnumber_t			agno = bs->cur->bc_ag.agno;
> @@ -278,7 +277,7 @@ xchk_iallocbt_check_cluster(
>  			&XFS_RMAP_OINFO_INODES);
>  
>  	/* Grab the inode cluster buffer. */
> -	error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap, &dip, &cluster_bp, 0);
> +	error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap, &cluster_bp);
>  	if (!xchk_btree_xref_process_error(bs->sc, bs->cur, 0, &error))
>  		return error;
>  
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 1d7720a0c068b7..266fb77ac5608c 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -505,14 +505,14 @@ xfs_iget_cache_miss(
>  	    (flags & XFS_IGET_CREATE) && !(mp->m_flags & XFS_MOUNT_IKEEP)) {
>  		VFS_I(ip)->i_generation = prandom_u32();
>  	} else {
> -		struct xfs_dinode	*dip;
>  		struct xfs_buf		*bp;
>  
> -		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &bp, 0);
> +		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp);
>  		if (error)
>  			goto out_destroy;
>  
> -		error = xfs_inode_from_disk(ip, dip);
> +		error = xfs_inode_from_disk(ip,
> +				xfs_buf_offset(bp, ip->i_imap.im_boffset));
>  		if (!error)
>  			xfs_buf_set_ref(bp, XFS_INO_REF);
>  		xfs_trans_brelse(tp, bp);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 46a861d55e487b..3fa332a1d24f9f 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2051,9 +2051,10 @@ xfs_iunlink_update_inode(
>  
>  	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
>  
> -	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp, 0);
> +	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &ibp);
>  	if (error)
>  		return error;
> +	dip = xfs_buf_offset(ibp, ip->i_imap.im_boffset);
>  
>  	/* Make sure the old pointer isn't garbage. */
>  	old_value = be32_to_cpu(dip->di_next_unlinked);
> @@ -2178,13 +2179,14 @@ xfs_iunlink_map_ino(
>  		return error;
>  	}
>  
> -	error = xfs_imap_to_bp(mp, tp, imap, dipp, bpp, 0);
> +	error = xfs_imap_to_bp(mp, tp, imap, bpp);
>  	if (error) {
>  		xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
>  				__func__, error);
>  		return error;
>  	}
>  
> +	*dipp = xfs_buf_offset(*bpp, imap->im_boffset);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 97f31308de03b9..31348e660cd65b 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2683,9 +2683,10 @@ xlog_recover_process_one_iunlink(
>  	/*
>  	 * Get the on disk inode to find the next inode in the bucket.
>  	 */
> -	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &ibp, 0);
> +	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &ibp);
>  	if (error)
>  		goto fail_iput;
> +	dip = xfs_buf_offset(ibp, ip->i_imap.im_boffset);
>  
>  	xfs_iflags_clear(ip, XFS_IRECOVERY);
>  	ASSERT(VFS_I(ip)->i_nlink == 0);
> -- 
> 2.30.1
> 
