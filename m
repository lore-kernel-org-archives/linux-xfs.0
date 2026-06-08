Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561A03403F1
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jun 2026 11:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780918059; cv=none; b=abwzcEZcI1pl8Epm6JSgQ07o9bnoT/B+aF2qjtBKOucnLVhnS9vbzI2X2Ry+2ZikDlVrVfRvvI5ZykiehXtz0rAJA8vNnFshLt5BJHANuWEqFVj1b+m39HPS39KTZkt2wxrPLPN/Tt9qMZ5+33ZWVIO1PYUw1RBb9ZZ/rFJKzLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780918059; c=relaxed/simple;
	bh=COONEyHnWcctyGqbuL4mKYnVWlDPkGQF2uaumArntuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sfL93xwg1Z+xrYTx4Ry3nx1tKeHAMA0hnIG1Qb/rcAUf3FHqxmmKTrhHHxO+YnwRwkUNktz+Y5eLYEkySjujLKKilUqgYHZgJsUwhfsh5RUCYG8HIqjcs7hwbs+uYcAivGvh1+SnTgnXdCYS6RdCzUvuBT+3zFh7Fsw43wL7pAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JR+Vuhqk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JR+Vuhqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E881F00893;
	Mon,  8 Jun 2026 11:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780918058;
	bh=jmTnpLJA+eNaw8wKkGMJr/yHcsvDqIxwhk1tpAAdV/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JR+VuhqkcI7O9qpDoMyc76Dkw4m8uhAtQUz82v4jnx9aghpMpGusQ3pgqu2Gh/H0h
	 chlS74WBbWyzHLqsaNV0A5ZbVqt3fFksqYy5Z2t2g+W5No4x37NMeRvLb3F24mmB01
	 TD3xp6p11jVcRc+nlGYPc3fG0MW9KdJq5mQ8wUMNF6Rmk8wwWv7vzW4i5RAIn1roSn
	 a5JmIGoioVJGkMEpRdagMWo1ZkRMuB7qrAtpaw+ok/WRp93l4agRIF7ywJZ52wYMS1
	 M1NOK3UzuMooaeHrtbBjkBSi5rZ79Lift/8x7qQRwOBm44Rzf4lDi/mf6DHDXobyr8
	 VW9W1BvmsIwYg==
Date: Mon, 8 Jun 2026 13:27:34 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: remove im_len field in struct xfs_imap
Message-ID: <aianHEyyVQ6DBJ5s@nidhogg.toxiclabs.cc>
References: <20260601124410.3508980-1-hch@lst.de>
 <20260601124410.3508980-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601124410.3508980-3-hch@lst.de>

On Mon, Jun 01, 2026 at 02:43:48PM +0200, Christoph Hellwig wrote:
> im_len is always set to the same value for a given file system,
> which makes it redundant.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Straight forward.
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_ialloc.c    | 10 +++++-----
>  fs/xfs/libxfs/xfs_inode_buf.c |  3 ++-
>  fs/xfs/libxfs/xfs_inode_buf.h |  1 -
>  fs/xfs/scrub/ialloc.c         |  4 ++--
>  fs/xfs/scrub/ialloc_repair.c  |  1 -
>  fs/xfs/scrub/inode_repair.c   | 11 +++++++----
>  fs/xfs/xfs_inode_item.c       |  3 ++-
>  7 files changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index a3fe4e5b1cdd..6ea7e96a07b4 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2552,7 +2552,6 @@ xfs_imap(
>  		XFS_INO_TO_OFFSET(mp, ino);
>  out:
>  	imap->im_blkno = xfs_agbno_to_daddr(pag, cluster_agbno);
> -	imap->im_len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
>  	imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
>  
>  	/*
> @@ -2561,12 +2560,13 @@ xfs_imap(
>  	 * read_buf and panicing when we get an error from the
>  	 * driver.
>  	 */
> -	if ((imap->im_blkno + imap->im_len) >
> +	if (imap->im_blkno +
> +	    XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster) >
>  	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
>  		xfs_alert(mp,
> -	"%s: (im_blkno (0x%llx) + im_len (0x%llx)) > sb_dblocks (0x%llx)",
> -			__func__, (unsigned long long) imap->im_blkno,
> -			(unsigned long long) imap->im_len,
> +	"%s: (im_blkno (0x%llx) + len (0x%x)) > sb_dblocks (0x%llx)",
> +			__func__, imap->im_blkno,
> +			XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster),
>  			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
>  		return -EINVAL;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 88e27d567df3..ecc50daa67ba 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -137,7 +137,8 @@ xfs_imap_to_bp(
>  	int			error;
>  
>  	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
> -			imap->im_len, 0, bpp, &xfs_inode_buf_ops);
> +			XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster),
> +			0, bpp, &xfs_inode_buf_ops);
>  	if (xfs_metadata_is_sick(error))
>  		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, imap->im_blkno),
>  				XFS_SICK_AG_INODES);
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 8d43d2641c73..54870796da41 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -15,7 +15,6 @@ struct xfs_dinode;
>   */
>  struct xfs_imap {
>  	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
> -	unsigned short	im_len;		/* length in BBs of inode chunk */
>  	unsigned short	im_boffset;	/* inode offset in block in bytes */
>  };
>  
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 911dc0f9a79d..a7192ba29262 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -395,7 +395,6 @@ xchk_iallocbt_check_cluster(
>  	 */
>  	ir_holemask = (irec->ir_holemask & cluster_mask);
>  	imap.im_blkno = xfs_agbno_to_daddr(to_perag(bs->cur->bc_group), agbno);
> -	imap.im_len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
>  	imap.im_boffset = XFS_INO_TO_OFFSET(mp, irec->ir_startino) <<
>  			mp->m_sb.sb_inodelog;
>  
> @@ -406,7 +405,8 @@ xchk_iallocbt_check_cluster(
>  	}
>  
>  	trace_xchk_iallocbt_check_cluster(to_perag(bs->cur->bc_group),
> -			irec->ir_startino, imap.im_blkno, imap.im_len,
> +			irec->ir_startino, imap.im_blkno,
> +			XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster),
>  			cluster_base, nr_inodes, cluster_mask, ir_holemask,
>  			XFS_INO_TO_OFFSET(mp, irec->ir_startino +
>  					  cluster_base));
> diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
> index 608c7022ac15..2d7b9ce968dc 100644
> --- a/fs/xfs/scrub/ialloc_repair.c
> +++ b/fs/xfs/scrub/ialloc_repair.c
> @@ -306,7 +306,6 @@ xrep_ibt_process_cluster(
>  	 * either inode btree.
>  	 */
>  	imap.im_blkno = xfs_agbno_to_daddr(sc->sa.pag, cluster_bno);
> -	imap.im_len = XFS_FSB_TO_BB(mp, igeo->blocks_per_cluster);
>  	imap.im_boffset = 0;
>  	error = xfs_imap_to_bp(mp, sc->tp, &imap, &cluster_bp);
>  	if (error)
> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> index c84657add97a..8d180673b76b 100644
> --- a/fs/xfs/scrub/inode_repair.c
> +++ b/fs/xfs/scrub/inode_repair.c
> @@ -1547,6 +1547,7 @@ xrep_dinode_core(
>  	struct xrep_inode	*ri)
>  {
>  	struct xfs_scrub	*sc = ri->sc;
> +	struct xfs_mount	*mp = sc->mp;
>  	struct xfs_buf		*bp;
>  	struct xfs_dinode	*dip;
>  	xfs_ino_t		ino = sc->sm->sm_ino;
> @@ -1559,8 +1560,10 @@ xrep_dinode_core(
>  		return error;
>  
>  	/* Read the inode cluster buffer. */
> -	error = xfs_trans_read_buf(sc->mp, sc->tp, sc->mp->m_ddev_targp,
> -			ri->imap.im_blkno, ri->imap.im_len, 0, &bp, NULL);
> +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> +			ri->imap.im_blkno,
> +			XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster),
> +			0, &bp, NULL);
>  	if (error)
>  		return error;
>  
> @@ -1583,10 +1586,10 @@ xrep_dinode_core(
>  write:
>  	/* Write out the inode. */
>  	trace_xrep_dinode_fixed(sc, dip);
> -	xfs_dinode_calc_crc(sc->mp, dip);
> +	xfs_dinode_calc_crc(mp, dip);
>  	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_DINO_BUF);
>  	xfs_trans_log_buf(sc->tp, bp, ri->imap.im_boffset,
> -			ri->imap.im_boffset + sc->mp->m_sb.sb_inodesize - 1);
> +			ri->imap.im_boffset + mp->m_sb.sb_inodesize - 1);
>  
>  	/*
>  	 * In theory, we've fixed the ondisk inode record enough that we should
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 2307ce96f753..3256495202cf 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -647,13 +647,14 @@ xfs_inode_item_format(
>  {
>  	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
>  	struct xfs_inode	*ip = iip->ili_inode;
> +	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_inode_log_format *ilf;
>  
>  	ilf = xlog_format_start(lfb, XLOG_REG_TYPE_IFORMAT);
>  	ilf->ilf_type = XFS_LI_INODE;
>  	ilf->ilf_ino = I_INO(ip);
>  	ilf->ilf_blkno = ip->i_imap.im_blkno;
> -	ilf->ilf_len = ip->i_imap.im_len;
> +	ilf->ilf_len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
>  	ilf->ilf_boffset = ip->i_imap.im_boffset;
>  	ilf->ilf_fields = XFS_ILOG_CORE;
>  	ilf->ilf_size = 2; /* format + core */
> -- 
> 2.53.0
> 
> 
