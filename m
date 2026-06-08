Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1FC339863
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jun 2026 11:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780918326; cv=none; b=Jf8nGD5JQiamwOtZZc0xN8RaQZvmyP7gsbujF412yTnDuOdmzwTi220FJk6lyyraNS5TLa1E9CrtVbRr+vJDNerPbMWDxGZohR9J8c4zbhC9IGzR7dKh88tg1wajaqWnsZd178NGDKNG/lv/KjPYUAQuuyQ7eZuTOpXlAZQ7ngs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780918326; c=relaxed/simple;
	bh=JyE6my2b+i3YdAvZ1r4qqow63fRY+FfuP3E81sz+K48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hjvwX6WTyFYVCq4r0+zF3OP0uvC21hT/WTQwAcvIa2q8ksPX5nW3CLLAr8pe71Sh0S6yif+rEI12r2s3uk/ZUYSbPcFrTXZwStE4+4VhUA2joz3/AfPoZUIeHGgxrPlE3vlmq3G7sR035zy/rgsjK75G3TpM1rGM2GMCd5wMtYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Orrzig1H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Orrzig1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3D71F00893;
	Mon,  8 Jun 2026 11:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780918324;
	bh=hpdmxb1zKLAScSpbcpRvtRWjwnkvGqDvUCELb41qzPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Orrzig1H8gqnzRVinpb/gPu8RI0SVrDIP+/UpfoxeL8veQjeDsNEcspykEEhgelQF
	 XWKJVb8rKHZUVl0+WDhxqeN0KL8URCyBKgYEk/Fy3hTP0K/4UGeqYEZT3PQvXJo/EX
	 r9x74muJBQ4UWGyH/Y8GRZ7OiYf+WgPYn9vURsA6YLYuVu+PUnLTy09LAB2xALa7qV
	 z8gLzm2dm+pkAJSY8DFK8V8xn1+NuRcPQo+0HX3q3r+9OUYJheI8rDzcPkE3Oj31M/
	 VWO6wrUFgID9Xn1/ngpB1EJufH09pelA6+Nd0Ke1OlnFVI664fx4q/JHN60OC1bNv5
	 iSu6qYHqG/8dA==
Date: Mon, 8 Jun 2026 13:32:01 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: massage xfs_imap_to_bp into xfs_read_icluster
Message-ID: <aiaoKWVzm5qRYmiT@nidhogg.toxiclabs.cc>
References: <20260601124410.3508980-1-hch@lst.de>
 <20260601124410.3508980-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601124410.3508980-4-hch@lst.de>

On Mon, Jun 01, 2026 at 02:43:49PM +0200, Christoph Hellwig wrote:
> xfs_imap_to_bp only uses the im_blkno field from struct xfs_imap, so pass
> that directly.  Rename the function to xfs_read_icluster, which describes
> the functionality much better and matches other helpers like xfs_read_agf
> and xfs_read_agi.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/libxfs/xfs_ialloc.c    |  2 +-
>  fs/xfs/libxfs/xfs_inode_buf.c | 12 +++++-------
>  fs/xfs/libxfs/xfs_inode_buf.h |  6 +++---
>  fs/xfs/scrub/ialloc.c         |  3 ++-
>  fs/xfs/scrub/ialloc_repair.c  |  7 +++----
>  fs/xfs/xfs_icache.c           |  2 +-
>  fs/xfs/xfs_inode_item.c       |  3 ++-
>  fs/xfs/xfs_iunlink_item.c     |  2 +-
>  8 files changed, 18 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 6ea7e96a07b4..18d07cf4c3e0 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1075,7 +1075,7 @@ xfs_dialloc_check_ino(
>  	if (error)
>  		return -EAGAIN;
>  
> -	error = xfs_imap_to_bp(pag_mount(pag), tp, &imap, &bp);
> +	error = xfs_read_icluster(pag_mount(pag), tp, imap.im_blkno, &bp);
>  	if (error)
>  		return -EAGAIN;
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index ecc50daa67ba..a9864e3050cb 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -123,24 +123,22 @@ const struct xfs_buf_ops xfs_inode_buf_ra_ops = {
>  
>  
>  /*
> - * This routine is called to map an inode to the buffer containing the on-disk
> - * version of the inode.  It returns a pointer to the buffer containing the
> - * on-disk inode in the bpp parameter.
> + * Read the inode cluster at @bno and return it in @bpp.
>   */
>  int
> -xfs_imap_to_bp(
> +xfs_read_icluster(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
> -	struct xfs_imap		*imap,
> +	xfs_daddr_t		bno,
>  	struct xfs_buf		**bpp)
>  {
>  	int			error;
>  
> -	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
> +	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, bno,
>  			XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster),
>  			0, bpp, &xfs_inode_buf_ops);
>  	if (xfs_metadata_is_sick(error))
> -		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, imap->im_blkno),
> +		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, bno),
>  				XFS_SICK_AG_INODES);
>  	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 54870796da41..bcad22871b5c 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -11,15 +11,15 @@ struct xfs_dinode;
>  
>  /*
>   * Inode location information.  Stored in the inode and passed to
> - * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
> + * xfs_read_icluster() to get a buffer and dinode for a given inode.
>   */
>  struct xfs_imap {
>  	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
>  	unsigned short	im_boffset;	/* inode offset in block in bytes */
>  };
>  
> -int	xfs_imap_to_bp(struct xfs_mount *mp, struct xfs_trans *tp,
> -		       struct xfs_imap *imap, struct xfs_buf **bpp);
> +int	xfs_read_icluster(struct xfs_mount *mp, struct xfs_trans *tp,
> +		xfs_daddr_t bno, struct xfs_buf **bpp);
>  void	xfs_dinode_calc_crc(struct xfs_mount *mp, struct xfs_dinode *dip);
>  void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
>  			  xfs_lsn_t lsn);
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index a7192ba29262..fafbf1636723 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -429,7 +429,8 @@ xchk_iallocbt_check_cluster(
>  			&XFS_RMAP_OINFO_INODES);
>  
>  	/* Grab the inode cluster buffer. */
> -	error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap, &cluster_bp);
> +	error = xfs_read_icluster(mp, bs->cur->bc_tp, imap.im_blkno,
> +			&cluster_bp);
>  	if (!xchk_btree_xref_process_error(bs->sc, bs->cur, 0, &error))
>  		return error;
>  
> diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
> index 2d7b9ce968dc..167f605a4962 100644
> --- a/fs/xfs/scrub/ialloc_repair.c
> +++ b/fs/xfs/scrub/ialloc_repair.c
> @@ -287,7 +287,6 @@ xrep_ibt_process_cluster(
>  	struct xrep_ibt		*ri,
>  	xfs_agblock_t		cluster_bno)
>  {
> -	struct xfs_imap		imap;
>  	struct xfs_buf		*cluster_bp;
>  	struct xfs_scrub	*sc = ri->sc;
>  	struct xfs_mount	*mp = sc->mp;
> @@ -305,9 +304,9 @@ xrep_ibt_process_cluster(
>  	 * inobt because imap_to_bp directly maps the buffer without touching
>  	 * either inode btree.
>  	 */
> -	imap.im_blkno = xfs_agbno_to_daddr(sc->sa.pag, cluster_bno);
> -	imap.im_boffset = 0;
> -	error = xfs_imap_to_bp(mp, sc->tp, &imap, &cluster_bp);
> +	error = xfs_read_icluster(mp, sc->tp,
> +			xfs_agbno_to_daddr(sc->sa.pag, cluster_bno),
> +			&cluster_bp);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 6f19e751bb8a..234c1e6974e4 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -663,7 +663,7 @@ xfs_iget_cache_miss(
>  	} else {
>  		struct xfs_buf		*bp;
>  
> -		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp);
> +		error = xfs_read_icluster(mp, tp, ip->i_imap.im_blkno, &bp);
>  		if (error)
>  			goto out_destroy;
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 3256495202cf..b4a835eb2e6d 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -167,7 +167,8 @@ xfs_inode_item_precommit(
>  		 * here.
>  		 */
>  		spin_unlock(&iip->ili_lock);
> -		error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, &bp);
> +		error = xfs_read_icluster(ip->i_mount, tp, ip->i_imap.im_blkno,
> +				&bp);
>  		if (error)
>  			return error;
>  
> diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
> index c8817112d49d..f8f2edea0934 100644
> --- a/fs/xfs/xfs_iunlink_item.c
> +++ b/fs/xfs/xfs_iunlink_item.c
> @@ -59,7 +59,7 @@ xfs_iunlink_log_dinode(
>  	int			offset;
>  	int			error;
>  
> -	error = xfs_imap_to_bp(tp->t_mountp, tp, &ip->i_imap, &ibp);
> +	error = xfs_read_icluster(tp->t_mountp, tp, ip->i_imap.im_blkno, &ibp);
>  	if (error)
>  		return error;
>  	/*
> -- 
> 2.53.0
> 
> 
