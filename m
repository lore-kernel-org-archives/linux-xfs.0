Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6D52C032C
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 04:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780375629; cv=none; b=ZiuSxHbQ0rDbMD2hEYFnQRkl81nZ4r8OnIIJwykVME+YmKWGzkHHhRFYY+8HK2rRvcjuBjP0WJWARXdfvnvSOPGNUHqqMBq5rhpROT1+uK6P/48sQPKBqZBuRAC51LZCjZpj0t5JRWY4SamudlwAsZpL0uiJnZRhUYSCgjf+QC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780375629; c=relaxed/simple;
	bh=H8xOeDbMZzltesm8KNwMoTwORSbEiJMcSELcakS1ECo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jSp7pXvJWh4TP34jXTU6uFguw2IGG5p9atFxyx2IzkssQVFpyF/B4Kmq28chHTr0cNv7I8GLHSBEebE7lMqtyPIVEHfEkjrfK/PsHx62EUGyZgvh3UXok+fpn4q/ALqOq9Ng5Le38Gf05r3VdZi+5rmyViqBZ5BGd8FMhUnL+LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=akOxXmwS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="akOxXmwS"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C507F1F00893;
	Tue,  2 Jun 2026 04:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780375627;
	bh=kYth9mg2dJ0aJMq4q3c7OAMb9LbhxY+4UllfE2yCrwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=akOxXmwSyHZdSt9HBJ3xUH+GZo8YpbVK08pw/OXo1QTD11htakd7bjvdlPKeuQNjZ
	 b6cW/TyC2fpHuS1tAUJkJuyai/a606kais0Nvso46gAKn4MZGkiA8znaHm6gj6cl1c
	 s8xDNphotL/6LuRxRSX32PaayE/qUBjiuivJbYiETQHs6EmUSOGd0O1W2hu4H97Kr9
	 9MhINIQ8mS+mWaW/4neMEhLREra0rYkRPMQWjXfyfs2ctc/IJDRDjYbCCsfY1WcXTt
	 StsJk+MSHQx3Sh6ecpCc5XcAyob+mvTno60yyrBfirAkZOXUD6bKpWE2N7CSAr/hEc
	 l5BDKrg0lxipA==
Date: Mon, 1 Jun 2026 21:47:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: massage xfs_imap_to_bp into xfs_read_icluster
Message-ID: <20260602044707.GP6078@frogsfrogsfrogs>
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

Hmm.  Most of the code I've looked at in xfs uses "bno" for
xfs_{fs,ag,rt,rg}block_t variables.

Though for xfs_daddr_t values it's less clear -- half seem to use bno,
the rest just call it daddr.  Maybe this function should s/bno/daddr/ ?

Don't really care either, though.

--D

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
