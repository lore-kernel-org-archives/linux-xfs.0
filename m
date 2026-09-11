Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9D034252D
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 14:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138390; cv=none; b=jDJdNQZFOONit4BAynCkmhUZaQ4xugcu/J3BA0roe+ur9OZqPv8M7/8v8aAixor0naqIVJw2IrXG9kBN5iFbLlvczrhkCxufylEipITLi6zM8x5DTzLz+fjbamP5mrw/buzMzEkqfVmXYfSxVMzKS2azj5NVoL09yUfwvlM44yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138390; c=relaxed/simple;
	bh=h/yBTRrQ/sPCXf3mMvOJemR8PXQqelqfqF1zWb6tZ94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pxjuYeCukE1HxDGYcT8UCWTf+573a8ixn9jb1BBEK6GsVonWOwO4qz4tHbagOO4PDqZ4EryAOXuhQPWykxePxtUR9FwrIRG/dwBpFw/LtisAZ0FFXuxoChD9c33OEam3mXo+XB8kT2KUTnMzEtt7ARayV9RbbI3hNYfdo6cISpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cJ1MB8IO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cJ1MB8IO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 466FB1F000FF;
	Fri, 11 Sep 2026 14:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789138388;
	bh=N2luEGE5NhU9Uq2IwDMxXytNK1jV5e4CmZakHyibOd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cJ1MB8IOCvXo41K4rtPWoW1R7yElEP0RG4dtUWUOCf1UE0g6SLORiiZd314RSWwZl
	 FeH1pcFAsiJEZnFQ0KJkwkuHOdgsmAg+N4/AR+QB8jpCIDPAlg25OYmAkhL4UJNtMo
	 SVonVBugZi+A4zybjqi4usuxXYFM8hWDflKZINCKXd1YEV5r+7UXsWVlcDjjVoRNlx
	 v7yCjSJKyFGlJWDxeLKRbJsPxx0RDBYKKZbw7oKab/V0VkCHYuLj3ZdI481dnt0sN+
	 XPujtmUiySb9bF5iuzci9f86Kb2XvCQ8o5D9cS0rXTdRPxWQ4KAc97io8yqM9MbLIt
	 X/uB07vE0bChw==
Date: Fri, 11 Sep 2026 07:53:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] libxfs: remove buftarg member aliases
Message-ID: <20260911145307.GC6265@frogsfrogsfrogs>
References: <20260911144559.1959740-1-hch@lst.de>
 <20260911144559.1959740-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911144559.1959740-4-hch@lst.de>

On Fri, Sep 11, 2026 at 04:45:44PM +0200, Christoph Hellwig wrote:
> Remove the #defines giving historic IRIX names to the ddev/logdev/rtdev
> buftargs in struct xfs_mount and use the current kernel names everywhere.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

<shudder> macros goway :)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  include/xfs_mount.h  |  3 ---
>  libxfs/init.c        | 12 ++++++------
>  libxfs/trans.c       |  4 ++--
>  libxfs/util.c        |  2 +-
>  mkfs/xfs_mkfs.c      |  4 ++--
>  repair/attr_repair.c | 11 ++++++-----
>  repair/da_util.c     |  2 +-
>  repair/dino_chunks.c |  8 ++++----
>  repair/dinode.c      |  8 ++++----
>  repair/phase3.c      |  2 +-
>  repair/phase5.c      |  6 +++---
>  repair/prefetch.c    |  4 ++--
>  repair/quotacheck.c  |  2 +-
>  repair/rt.c          |  2 +-
>  repair/scan.c        | 16 +++++++++-------
>  15 files changed, 43 insertions(+), 43 deletions(-)
> 
> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index 5a714333c16e..0dea578ee3a5 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -102,9 +102,6 @@ typedef struct xfs_mount {
>  	struct xfs_buftarg	*m_ddev_targp;
>  	struct xfs_buftarg	*m_logdev_targp;
>  	struct xfs_buftarg	*m_rtdev_targp;
> -#define m_dev		m_ddev_targp
> -#define m_logdev	m_logdev_targp
> -#define m_rtdev		m_rtdev_targp
>  	uint8_t			m_dircook_elog;	/* log d-cookie entry bits */
>  	uint8_t			m_blkbit_log;	/* blocklog + NBBY */
>  	uint8_t			m_blkbb_log;	/* blocklog - BBSHIFT */
> diff --git a/libxfs/init.c b/libxfs/init.c
> index a47e610934e9..97c4755dd131 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -331,7 +331,7 @@ rtmount_init(
>  			(unsigned long long) mp->m_sb.sb_rblocks);
>  		return -1;
>  	}
> -	error = libxfs_buf_read(mp->m_rtdev, d - XFS_FSB_TO_BB(mp, 1),
> +	error = libxfs_buf_read(mp->m_rtdev_targp, d - XFS_FSB_TO_BB(mp, 1),
>  			XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
>  	if (error) {
>  		fprintf(stderr, _("%s: realtime size check failed\n"),
> @@ -679,7 +679,7 @@ check_many_rtgroups(
>  	xfs_daddr_t		d;
>  	int			error;
>  
> -	if (!mp->m_rtdev->bt_bdev) {
> +	if (!mp->m_rtdev_targp->bt_bdev) {
>  		fprintf(stderr, _("%s: no rt device, ignoring rgcount %u\n"),
>  				progname, sbp->sb_rgcount);
>  		if (!xfs_is_debugger(mp))
> @@ -690,8 +690,8 @@ check_many_rtgroups(
>  	}
>  
>  	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
> -	error = libxfs_buf_read(mp->m_rtdev, d - XFS_FSB_TO_BB(mp, 1), 1, 0,
> -			&bp, NULL);
> +	error = libxfs_buf_read(mp->m_rtdev_targp, d - XFS_FSB_TO_BB(mp, 1), 1,
> +			0, &bp, NULL);
>  	if (!error) {
>  		libxfs_buf_relse(bp);
>  		return true;
> @@ -806,7 +806,7 @@ libxfs_mount(
>  		return mp;
>  
>  	/* device size checks must pass unless we're a debugger. */
> -	error = libxfs_buf_read(mp->m_dev, d - XFS_FSS_TO_BB(mp, 1),
> +	error = libxfs_buf_read(mp->m_ddev_targp, d - XFS_FSS_TO_BB(mp, 1),
>  			XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
>  	if (error) {
>  		fprintf(stderr, _("%s: data size check failed\n"), progname);
> @@ -848,7 +848,7 @@ libxfs_mount(
>  	 * read the first one and let the user know to check the geometry.
>  	 */
>  	if (sbp->sb_agcount > 1000000) {
> -		error = libxfs_buf_read(mp->m_dev,
> +		error = libxfs_buf_read(mp->m_ddev_targp,
>  				XFS_AG_DADDR(mp, sbp->sb_agcount - 1, 0), 1,
>  				0, &bp, NULL);
>  		if (error) {
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index c89b035ffeaf..88022c2fc9c2 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -500,7 +500,7 @@ libxfs_trans_getsb(
>  	if (tp == NULL)
>  		return libxfs_getsb(mp);
>  
> -	bp = xfs_trans_buf_item_match(tp, mp->m_dev, &map, 1);
> +	bp = xfs_trans_buf_item_match(tp, mp->m_ddev_targp, &map, 1);
>  	if (bp != NULL) {
>  		ASSERT(bp->b_transp == tp);
>  		bip = bp->b_log_item;
> @@ -529,7 +529,7 @@ libxfs_trans_getrtsb(
>  	int			len = XFS_FSS_TO_BB(mp, 1);
>  	DEFINE_SINGLE_BUF_MAP(map, XFS_SB_DADDR, len);
>  
> -	bp = xfs_trans_buf_item_match(tp, mp->m_rtdev, &map, 1);
> +	bp = xfs_trans_buf_item_match(tp, mp->m_rtdev_targp, &map, 1);
>  	if (bp != NULL) {
>  		ASSERT(bp->b_transp == tp);
>  		bip = bp->b_log_item;
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 6cbbe9056eba..fae8fce484b7 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -527,7 +527,7 @@ libxfs_file_write(
>  		    map.br_state == XFS_EXT_UNWRITTEN)
>  			return -EINVAL;
>  
> -		error = libxfs_buf_get(mp->m_dev,
> +		error = libxfs_buf_get(mp->m_ddev_targp,
>  				XFS_FSB_TO_DADDR(mp, map.br_startblock),
>  				XFS_FSB_TO_BB(mp, map.br_blockcount),
>  				&bp);
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 4f11c9de339c..714cd3cda8ca 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -5666,7 +5666,7 @@ rewrite_secondary_superblocks(
>  	int			error;
>  
>  	/* rewrite the last superblock */
> -	error = -libxfs_buf_read(mp->m_dev,
> +	error = -libxfs_buf_read(mp->m_ddev_targp,
>  			XFS_AGB_TO_DADDR(mp, mp->m_sb.sb_agcount - 1,
>  				XFS_SB_DADDR),
>  			XFS_FSS_TO_BB(mp, 1), 0, &buf, &xfs_sb_buf_ops);
> @@ -5686,7 +5686,7 @@ rewrite_secondary_superblocks(
>  	if (mp->m_sb.sb_agcount <= 2)
>  		return;
>  
> -	error = -libxfs_buf_read(mp->m_dev,
> +	error = -libxfs_buf_read(mp->m_ddev_targp,
>  			XFS_AGB_TO_DADDR(mp, (mp->m_sb.sb_agcount - 1) / 2,
>  				XFS_SB_DADDR),
>  			XFS_FSS_TO_BB(mp, 1), 0, &buf, &xfs_sb_buf_ops);
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index fe4089026cae..982dc838ee55 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -443,9 +443,10 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
>  			clearit = 1;
>  			break;
>  		}
> -		error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
> -				XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE,
> -				&bp, &xfs_attr3_rmt_buf_ops);
> +		error = -libxfs_buf_read(mp->m_ddev_targp,
> +				XFS_FSB_TO_DADDR(mp, bno), XFS_FSB_TO_BB(mp, 1),
> +				LIBXFS_READBUF_SALVAGE, &bp,
> +				&xfs_attr3_rmt_buf_ops);
>  		if (error) {
>  			do_warn(
>  	_("can't read remote block for attributes of inode %" PRIu64 "\n"), ino);
> @@ -879,7 +880,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
>  			goto error_out;
>  		}
>  
> -		error = -libxfs_buf_read(mp->m_dev,
> +		error = -libxfs_buf_read(mp->m_ddev_targp,
>  				XFS_FSB_TO_DADDR(mp, dev_bno),
>  				XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE,
>  				&bp, &xfs_attr3_leaf_buf_ops);
> @@ -1217,7 +1218,7 @@ process_longform_attr(
>  		return 1;
>  	}
>  
> -	error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
> +	error = -libxfs_buf_read(mp->m_ddev_targp, XFS_FSB_TO_DADDR(mp, bno),
>  			XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE, &bp,
>  			&xfs_da3_node_buf_ops);
>  	if (error) {
> diff --git a/repair/da_util.c b/repair/da_util.c
> index 7f94f4012062..c0625b312fc6 100644
> --- a/repair/da_util.c
> +++ b/repair/da_util.c
> @@ -64,7 +64,7 @@ da_read_buf(
>  		map[i].bm_bn = XFS_FSB_TO_DADDR(mp, bmp[i].startblock);
>  		map[i].bm_len = XFS_FSB_TO_BB(mp, bmp[i].blockcount);
>  	}
> -	libxfs_buf_read_map(mp->m_dev, map, nex, LIBXFS_READBUF_SALVAGE,
> +	libxfs_buf_read_map(mp->m_ddev_targp, map, nex, LIBXFS_READBUF_SALVAGE,
>  			&bp, ops);
>  	if (map != map_array)
>  		free(map);
> diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
> index 932eaf63f474..6b261a1e99bf 100644
> --- a/repair/dino_chunks.c
> +++ b/repair/dino_chunks.c
> @@ -43,9 +43,9 @@ check_aginode_block(
>  	 * tree and we wouldn't be here and we stale the buffers out
>  	 * so no one else will overlap them.
>  	 */
> -	error = -libxfs_buf_read(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, agbno),
> -			XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE, &bp,
> -			NULL);
> +	error = -libxfs_buf_read(mp->m_ddev_targp,
> +			XFS_AGB_TO_DADDR(mp, agno, agbno), XFS_FSB_TO_BB(mp, 1),
> +			LIBXFS_READBUF_SALVAGE, &bp, NULL);
>  	if (error) {
>  		do_warn(_("cannot read agbno (%u/%u), disk block %" PRId64 "\n"),
>  			agno, agbno, XFS_AGB_TO_DADDR(mp, agno, agbno));
> @@ -699,7 +699,7 @@ process_inode_chunk(
>  		pftrace("about to read off %llu in AG %d",
>  			XFS_AGB_TO_DADDR(mp, agno, agbno), agno);
>  
> -		error = -libxfs_buf_read(mp->m_dev,
> +		error = -libxfs_buf_read(mp->m_ddev_targp,
>  				XFS_AGB_TO_DADDR(mp, agno, agbno),
>  				XFS_FSB_TO_BB(mp,
>  					M_IGEO(mp)->blocks_per_cluster),
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 48939f8bd159..243fcf7a19f4 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -956,8 +956,8 @@ get_agino_buf(
>  		cluster_agino, cluster_daddr, cluster_blks);
>  #endif
>  
> -	error = -libxfs_buf_read(mp->m_dev, cluster_daddr, cluster_blks, 0,
> -			&bp, &xfs_inode_buf_ops);
> +	error = -libxfs_buf_read(mp->m_ddev_targp, cluster_daddr, cluster_blks,
> +			0, &bp, &xfs_inode_buf_ops);
>  	if (error) {
>  		do_warn(_("cannot read inode (%u/%u), disk block %" PRIu64 "\n"),
>  			agno, cluster_agino, cluster_daddr);
> @@ -1733,7 +1733,7 @@ process_quota_inode(
>  		fsbno = blkmap_get(blkmap, qbno);
>  		dqid = (xfs_dqid_t)qbno * dqperchunk;
>  
> -		error = -libxfs_buf_read(mp->m_dev,
> +		error = -libxfs_buf_read(mp->m_ddev_targp,
>  				XFS_FSB_TO_DADDR(mp, fsbno), dqchunklen,
>  				LIBXFS_READBUF_SALVAGE, &bp,
>  				&xfs_dquot_buf_ops);
> @@ -1845,7 +1845,7 @@ _("cannot read inode %" PRIu64 ", file block %d, NULL disk block\n"),
>  
>  		byte_cnt = XFS_FSB_TO_B(mp, blk_cnt);
>  
> -		error = -libxfs_buf_read(mp->m_dev,
> +		error = -libxfs_buf_read(mp->m_ddev_targp,
>  				XFS_FSB_TO_DADDR(mp, fsbno), BTOBB(byte_cnt),
>  				LIBXFS_READBUF_SALVAGE, &bp,
>  				&xfs_symlink_buf_ops);
> diff --git a/repair/phase3.c b/repair/phase3.c
> index 6ec616d9b31d..64a2c961b080 100644
> --- a/repair/phase3.c
> +++ b/repair/phase3.c
> @@ -30,7 +30,7 @@ process_agi_unlinked(
>  	int			agi_dirty = 0;
>  	int			error;
>  
> -	error = -libxfs_buf_read(mp->m_dev,
> +	error = -libxfs_buf_read(mp->m_ddev_targp,
>  			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
>  			mp->m_sb.sb_sectsize / BBSIZE, LIBXFS_READBUF_SALVAGE,
>  			&bp, &xfs_agi_buf_ops);
> diff --git a/repair/phase5.c b/repair/phase5.c
> index e44c26885717..019772346eb1 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -135,7 +135,7 @@ build_agi(
>  	int			i;
>  	int			error;
>  
> -	error = -libxfs_buf_get(mp->m_dev,
> +	error = -libxfs_buf_get(mp->m_ddev_targp,
>  			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
>  			mp->m_sb.sb_sectsize / BBSIZE, &agi_buf);
>  	if (error)
> @@ -228,7 +228,7 @@ build_agf_agfl(
>  	__be32			*freelist;
>  	int			error;
>  
> -	error = -libxfs_buf_get(mp->m_dev,
> +	error = -libxfs_buf_get(mp->m_ddev_targp,
>  			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
>  			mp->m_sb.sb_sectsize / BBSIZE, &agf_buf);
>  	if (error)
> @@ -314,7 +314,7 @@ build_agf_agfl(
>  		platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
>  
>  	/* initialise the AGFL, then fill it if there are blocks left over. */
> -	error = -libxfs_buf_get(mp->m_dev,
> +	error = -libxfs_buf_get(mp->m_ddev_targp,
>  			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
>  			mp->m_sb.sb_sectsize / BBSIZE, &agfl_buf);
>  	if (error)
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 8cd3416fa568..3d26636e5e56 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -121,7 +121,7 @@ pf_queue_io(
>  	 * the lock holder is either reading it from disk himself or
>  	 * completely overwriting it this behaviour is perfectly fine.
>  	 */
> -	error = -libxfs_buf_get_map(mp->m_dev, map, nmaps,
> +	error = -libxfs_buf_get_map(mp->m_ddev_targp, map, nmaps,
>  			LIBXFS_GETBUF_TRYLOCK, &bp);
>  	if (error)
>  		return;
> @@ -275,7 +275,7 @@ pf_scan_lbtree(
>  	int			rc;
>  	int			error;
>  
> -	error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, dbno),
> +	error = -libxfs_buf_read(mp->m_ddev_targp, XFS_FSB_TO_DADDR(mp, dbno),
>  			XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE, &bp,
>  			&xfs_bmbt_buf_ops);
>  	if (error)
> diff --git a/repair/quotacheck.c b/repair/quotacheck.c
> index fc7e3864654c..e13092dfcae8 100644
> --- a/repair/quotacheck.c
> +++ b/repair/quotacheck.c
> @@ -369,7 +369,7 @@ qc_walk_dquot_extent(
>  		unsigned int	dqnr;
>  		uint64_t	dqid;
>  
> -		error = -libxfs_buf_read(mp->m_dev,
> +		error = -libxfs_buf_read(mp->m_ddev_targp,
>  				XFS_FSB_TO_DADDR(mp, map->br_startblock + bno),
>  				dqchunklen, 0, &bp, &xfs_dquot_buf_ops);
>  		if (error) {
> diff --git a/repair/rt.c b/repair/rt.c
> index 3e51c9b5eb4b..b5b9d4fdc536 100644
> --- a/repair/rt.c
> +++ b/repair/rt.c
> @@ -255,7 +255,7 @@ check_rtfile_contents(
>  			break;
>  		}
>  
> -		error = -libxfs_buf_read_uncached(mp->m_dev,
> +		error = -libxfs_buf_read_uncached(mp->m_ddev_targp,
>  				XFS_FSB_TO_DADDR(mp, map.br_startblock),
>  				XFS_FSB_TO_BB(mp, 1), 0, &bp,
>  				xfs_rtblock_ops(mp, type));
> diff --git a/repair/scan.c b/repair/scan.c
> index 7d22ff378484..865983d6c9e0 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -102,8 +102,9 @@ scan_sbtree(
>  	struct xfs_buf	*bp;
>  	int		error;
>  
> -	error = salvage_buffer(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, root),
> -			XFS_FSB_TO_BB(mp, 1), &bp, ops);
> +	error = salvage_buffer(mp->m_ddev_targp,
> +			XFS_AGB_TO_DADDR(mp, agno, root),XFS_FSB_TO_BB(mp, 1),
> +			&bp, ops);
>  	if (error) {
>  		do_error(_("can't read btree block %d/%d\n"), agno, root);
>  		return;
> @@ -161,7 +162,7 @@ scan_lbtree(
>  	int		dirty = 0;
>  	bool		badcrc = false;
>  
> -	err = salvage_buffer(mp->m_dev, XFS_FSB_TO_DADDR(mp, root),
> +	err = salvage_buffer(mp->m_ddev_targp, XFS_FSB_TO_DADDR(mp, root),
>  			XFS_FSB_TO_BB(mp, 1), &bp, ops);
>  	if (err) {
>  		do_error(_("can't read btree block %d/%d\n"),
> @@ -3030,7 +3031,7 @@ scan_freelist(
>  	if (be32_to_cpu(agf->agf_flcount) == 0)
>  		return;
>  
> -	error = salvage_buffer(mp->m_dev,
> +	error = salvage_buffer(mp->m_ddev_targp,
>  			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
>  			XFS_FSS_TO_BB(mp, 1), &agflbuf, &xfs_agfl_buf_ops);
>  	if (error) {
> @@ -3312,7 +3313,8 @@ scan_ag(
>  		return;
>  	}
>  
> -	error = salvage_buffer(mp->m_dev, XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
> +	error = salvage_buffer(mp->m_ddev_targp,
> +			XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
>  			XFS_FSS_TO_BB(mp, 1), &sbbuf, &xfs_sb_buf_ops);
>  	if (error) {
>  		objname = _("root superblock");
> @@ -3322,7 +3324,7 @@ scan_ag(
>  		do_warn(_("superblock has bad CRC for ag %d\n"), agno);
>  	libxfs_sb_from_disk(sb, sbbuf->b_addr);
>  
> -	error = salvage_buffer(mp->m_dev,
> +	error = salvage_buffer(mp->m_ddev_targp,
>  			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
>  			XFS_FSS_TO_BB(mp, 1), &agfbuf, &xfs_agf_buf_ops);
>  	if (error) {
> @@ -3333,7 +3335,7 @@ scan_ag(
>  		do_warn(_("agf has bad CRC for ag %d\n"), agno);
>  	agf = agfbuf->b_addr;
>  
> -	error = salvage_buffer(mp->m_dev,
> +	error = salvage_buffer(mp->m_ddev_targp,
>  			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
>  			XFS_FSS_TO_BB(mp, 1), &agibuf, &xfs_agi_buf_ops);
>  	if (error) {
> -- 
> 2.53.0
> 
> 
