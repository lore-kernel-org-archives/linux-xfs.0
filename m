Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3496733AD91
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jun 2026 11:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780919132; cv=none; b=FFPSbYWa9l89B5+Zu3Z1h7kVN7ELGLYFaxVcb+dUpkOpoy7aTnHtnoT8FMajQk3QcjQ791XuX/vseWqfQFwC/nEArS8DCJIwOs4CrExph1LitG/TLDYqgmacmz8ILYtaUQ7XKUddSxfnA1pmm2vWpubiz9pLcc5pgrl3V6dt6gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780919132; c=relaxed/simple;
	bh=fd/hmeD45xntM7eXQWVFmAP9EW1A+oGJGnOEpsiYK34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MM0QD0D2gtkTr5ugpyOB2nMBgK6WfLmElH7HBA0MusMUzbcYsxQiDCXwB7C02d3U6EFhVcyzfoEuconCLu31b8GFqbcex5go2iqPN9IXlpBJqGKvJXrIxvZ38A8jzflhwjHt/iNdnfIL3ZMc0SWz+f2nHEgW7oxkFYs/Z4pBPZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LVow59EF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LVow59EF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317EC1F00893;
	Mon,  8 Jun 2026 11:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780919130;
	bh=ZPi4f3CaD6gTBADTvmhJP4CXteMWTq4c3+VagbuaPww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LVow59EF1YtpTlOMS6bQO/4LU7oAqBam1zTicDxGgBfp2M7Yk/ewa2BBpt3uzYi2J
	 xeqeja6ylpbjzlKN+VihnfAFncuz0h6ip8dc4BTEouvG4z4eLgN3TsKVv6gar/qSWi
	 bsY6i3W0/eSaGfe1maVxMDAovsS9cgLuK/U/PlNK9gV7V/8sePGNnl8r8sqsiDnw5P
	 SJXZLiWTr4sYU2qd3I6EC1uHZN8FHycbKrDlnd+hFu6iI6WrUJc8CrxhIDACydLCtn
	 z8VxDfae9BsNcTDqvudIix0j8YmwfiUf2Fwl+VloJUcr5cgu+uccrj4pqKMvvMm5Ag
	 cqlgTewPrHFXg==
Date: Mon, 8 Jun 2026 13:45:27 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: store an agbno in struct xfs_imap
Message-ID: <aiarTj8yeZY6zJe7@nidhogg.toxiclabs.cc>
References: <20260601124410.3508980-1-hch@lst.de>
 <20260601124410.3508980-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601124410.3508980-5-hch@lst.de>

On Mon, Jun 01, 2026 at 02:43:50PM +0200, Christoph Hellwig wrote:
> The xfs_imap structure is embedded into the xfs_inode, which means the
> size of it directly affects the inode size.  Replacing the xfs_daddr_t
> with an xfs_agbno_t and taking the AG information from other easily
> available sources allows us to shrink the structure including the
> typical padding from 16 bytes to 8 bytes.
> 
> As a side-effect the debugging check in xfs_imap() naturally now
> converges to a stricter variant that checks that the cluster is located
> inside a single AG, and not just inside the entire device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_ialloc.c    | 24 +++++++-----------------
>  fs/xfs/libxfs/xfs_inode_buf.c | 11 ++++++-----
>  fs/xfs/libxfs/xfs_inode_buf.h |  8 ++++----
>  fs/xfs/scrub/ialloc.c         |  8 ++++----
>  fs/xfs/scrub/ialloc_repair.c  |  3 +--
>  fs/xfs/scrub/inode_repair.c   |  3 ++-
>  fs/xfs/scrub/trace.h          | 12 ++++++------
>  fs/xfs/xfs_icache.c           |  2 +-
>  fs/xfs/xfs_inode_item.c       | 18 +++++++++++-------
>  fs/xfs/xfs_itable.c           |  2 +-
>  fs/xfs/xfs_iunlink_item.c     |  2 +-
>  11 files changed, 44 insertions(+), 49 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 18d07cf4c3e0..ffcdd1f691fd 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1075,7 +1075,7 @@ xfs_dialloc_check_ino(
>  	if (error)
>  		return -EAGAIN;
>  
> -	error = xfs_read_icluster(pag_mount(pag), tp, imap.im_blkno, &bp);
> +	error = xfs_read_icluster(pag, tp, imap.im_agbno, &bp);
>  	if (error)
>  		return -EAGAIN;
>  
> @@ -2551,23 +2551,13 @@ xfs_imap(
>  	offset = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
>  		XFS_INO_TO_OFFSET(mp, ino);
>  out:
> -	imap->im_blkno = xfs_agbno_to_daddr(pag, cluster_agbno);
> +	imap->im_agbno = cluster_agbno;
>  	imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
> -
> -	/*
> -	 * If the inode number maps to a block outside the bounds
> -	 * of the file system then return NULL rather than calling
> -	 * read_buf and panicing when we get an error from the
> -	 * driver.
> -	 */
> -	if (imap->im_blkno +
> -	    XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster) >
> -	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
> -		xfs_alert(mp,
> -	"%s: (im_blkno (0x%llx) + len (0x%x)) > sb_dblocks (0x%llx)",
> -			__func__, imap->im_blkno,
> -			XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster),
> -			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
> +	if (imap->im_agbno + M_IGEO(mp)->blocks_per_cluster >
> +	    pag_group(pag)->xg_block_count) {
> +		xfs_alert(mp, "inode cluster out of range: %u/%u > %u",
> +			imap->im_agbno, M_IGEO(mp)->blocks_per_cluster,
> +			pag_group(pag)->xg_block_count);
>  		return -EINVAL;
>  	}
>  	return 0;
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index a9864e3050cb..336ef843f2fe 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -127,19 +127,20 @@ const struct xfs_buf_ops xfs_inode_buf_ra_ops = {
>   */
>  int
>  xfs_read_icluster(
> -	struct xfs_mount	*mp,
> +	struct xfs_perag	*pag,
>  	struct xfs_trans	*tp,
> -	xfs_daddr_t		bno,
> +	xfs_agblock_t		agbno,
>  	struct xfs_buf		**bpp)
>  {
> +	struct xfs_mount	*mp = pag_mount(pag);
>  	int			error;
>  
> -	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, bno,
> +	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
> +			xfs_agbno_to_daddr(pag, agbno),
>  			XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster),
>  			0, bpp, &xfs_inode_buf_ops);
>  	if (xfs_metadata_is_sick(error))
> -		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, bno),
> -				XFS_SICK_AG_INODES);
> +		xfs_agno_mark_sick(mp, pag_agno(pag), XFS_SICK_AG_INODES);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index bcad22871b5c..57192adc7744 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -14,12 +14,12 @@ struct xfs_dinode;
>   * xfs_read_icluster() to get a buffer and dinode for a given inode.
>   */
>  struct xfs_imap {
> -	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
> -	unsigned short	im_boffset;	/* inode offset in block in bytes */
> +	xfs_agblock_t	im_agbno;	/* starting agbno of inode cluster */
> +	unsigned short	im_boffset;	/* offset in inode cluster in bytes */
>  };
>  
> -int	xfs_read_icluster(struct xfs_mount *mp, struct xfs_trans *tp,
> -		xfs_daddr_t bno, struct xfs_buf **bpp);
> +int	xfs_read_icluster(struct xfs_perag *pag, struct xfs_trans *tp,
> +		xfs_agblock_t agbno, struct xfs_buf **bpp);
>  void	xfs_dinode_calc_crc(struct xfs_mount *mp, struct xfs_dinode *dip);
>  void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
>  			  xfs_lsn_t lsn);
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index fafbf1636723..19c0b1b2a787 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -363,6 +363,7 @@ xchk_iallocbt_check_cluster(
>  	struct xfs_inobt_rec_incore	*irec,
>  	unsigned int			cluster_base)
>  {
> +	struct xfs_perag		*pag = to_perag(bs->cur->bc_group);
>  	struct xfs_imap			imap;
>  	struct xfs_mount		*mp = bs->cur->bc_mp;
>  	struct xfs_buf			*cluster_bp;
> @@ -394,7 +395,7 @@ xchk_iallocbt_check_cluster(
>  	 * ir_startino can be large enough to make im_boffset nonzero.
>  	 */
>  	ir_holemask = (irec->ir_holemask & cluster_mask);
> -	imap.im_blkno = xfs_agbno_to_daddr(to_perag(bs->cur->bc_group), agbno);
> +	imap.im_agbno = agbno;
>  	imap.im_boffset = XFS_INO_TO_OFFSET(mp, irec->ir_startino) <<
>  			mp->m_sb.sb_inodelog;
>  
> @@ -404,8 +405,7 @@ xchk_iallocbt_check_cluster(
>  		return 0;
>  	}
>  
> -	trace_xchk_iallocbt_check_cluster(to_perag(bs->cur->bc_group),
> -			irec->ir_startino, imap.im_blkno,
> +	trace_xchk_iallocbt_check_cluster(pag, irec->ir_startino, imap.im_agbno,
>  			XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster),
>  			cluster_base, nr_inodes, cluster_mask, ir_holemask,
>  			XFS_INO_TO_OFFSET(mp, irec->ir_startino +
> @@ -429,7 +429,7 @@ xchk_iallocbt_check_cluster(
>  			&XFS_RMAP_OINFO_INODES);
>  
>  	/* Grab the inode cluster buffer. */
> -	error = xfs_read_icluster(mp, bs->cur->bc_tp, imap.im_blkno,
> +	error = xfs_read_icluster(pag, bs->cur->bc_tp, imap.im_agbno,
>  			&cluster_bp);
>  	if (!xchk_btree_xref_process_error(bs->sc, bs->cur, 0, &error))
>  		return error;
> diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
> index 167f605a4962..46b1c8ac5543 100644
> --- a/fs/xfs/scrub/ialloc_repair.c
> +++ b/fs/xfs/scrub/ialloc_repair.c
> @@ -304,8 +304,7 @@ xrep_ibt_process_cluster(
>  	 * inobt because imap_to_bp directly maps the buffer without touching
>  	 * either inode btree.
>  	 */
> -	error = xfs_read_icluster(mp, sc->tp,
> -			xfs_agbno_to_daddr(sc->sa.pag, cluster_bno),
> +	error = xfs_read_icluster(sc->sa.pag, sc->tp, cluster_bno,
>  			&cluster_bp);
>  	if (error)
>  		return error;
> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> index 8d180673b76b..493dcf5cc6c1 100644
> --- a/fs/xfs/scrub/inode_repair.c
> +++ b/fs/xfs/scrub/inode_repair.c
> @@ -1561,7 +1561,8 @@ xrep_dinode_core(
>  
>  	/* Read the inode cluster buffer. */
>  	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> -			ri->imap.im_blkno,
> +			XFS_AGB_TO_DADDR(mp, XFS_INO_TO_AGNO(mp, ino),
> +					ri->imap.im_agbno),
>  			XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster),
>  			0, &bp, NULL);
>  	if (error)
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index d27c99beee13..1b7d9e07a27d 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -785,17 +785,17 @@ TRACE_EVENT(xchk_xref_error,
>  
>  TRACE_EVENT(xchk_iallocbt_check_cluster,
>  	TP_PROTO(const struct xfs_perag *pag, xfs_agino_t startino,
> -		 xfs_daddr_t map_daddr,  unsigned short map_len,
> +		 xfs_agblock_t map_agblock,  unsigned short map_len,
>  		 unsigned int chunk_ino,  unsigned int nr_inodes,
>  		 uint16_t cluster_mask, uint16_t holemask,
>  		 unsigned int cluster_ino),
> -	TP_ARGS(pag, startino, map_daddr, map_len, chunk_ino, nr_inodes,
> +	TP_ARGS(pag, startino, map_agblock, map_len, chunk_ino, nr_inodes,
>  		cluster_mask, holemask, cluster_ino),
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_agnumber_t, agno)
>  		__field(xfs_agino_t, startino)
> -		__field(xfs_daddr_t, map_daddr)
> +		__field(xfs_agblock_t, map_agblock)
>  		__field(unsigned short, map_len)
>  		__field(unsigned int, chunk_ino)
>  		__field(unsigned int, nr_inodes)
> @@ -807,7 +807,7 @@ TRACE_EVENT(xchk_iallocbt_check_cluster,
>  		__entry->dev = pag_mount(pag)->m_super->s_dev;
>  		__entry->agno = pag_agno(pag);
>  		__entry->startino = startino;
> -		__entry->map_daddr = map_daddr;
> +		__entry->map_agblock = map_agblock;
>  		__entry->map_len = map_len;
>  		__entry->chunk_ino = chunk_ino;
>  		__entry->nr_inodes = nr_inodes;
> @@ -815,11 +815,11 @@ TRACE_EVENT(xchk_iallocbt_check_cluster,
>  		__entry->holemask = holemask;
>  		__entry->cluster_ino = cluster_ino;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x startino 0x%x daddr 0x%llx bbcount 0x%x chunkino 0x%x nr_inodes %u cluster_mask 0x%x holemask 0x%x cluster_ino 0x%x",
> +	TP_printk("dev %d:%d agno 0x%x startino 0x%x agblock 0x%x bbcount 0x%x chunkino 0x%x nr_inodes %u cluster_mask 0x%x holemask 0x%x cluster_ino 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->startino,
> -		  __entry->map_daddr,
> +		  __entry->map_agblock,
>  		  __entry->map_len,
>  		  __entry->chunk_ino,
>  		  __entry->nr_inodes,
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 234c1e6974e4..9d8dd30bd927 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -663,7 +663,7 @@ xfs_iget_cache_miss(
>  	} else {
>  		struct xfs_buf		*bp;
>  
> -		error = xfs_read_icluster(mp, tp, ip->i_imap.im_blkno, &bp);
> +		error = xfs_read_icluster(pag, tp, ip->i_imap.im_agbno, &bp);
>  		if (error)
>  			goto out_destroy;
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index b4a835eb2e6d..99d6ecccdaa7 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -18,6 +18,7 @@
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
>  #include "xfs_log_priv.h"
> +#include "xfs_ag.h"
>  #include "xfs_error.h"
>  #include "xfs_rtbitmap.h"
>  
> @@ -104,6 +105,7 @@ xfs_inode_item_precommit(
>  {
>  	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
>  	struct xfs_inode	*ip = iip->ili_inode;
> +	struct xfs_mount	*mp = ip->i_mount;
>  	struct inode		*inode = VFS_I(ip);
>  	unsigned int		flags = iip->ili_dirty_flags;
>  
> @@ -124,8 +126,7 @@ xfs_inode_item_precommit(
>  	 * to upgrade this inode to bigtime format, do so now.
>  	 */
>  	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
> -	    xfs_has_bigtime(ip->i_mount) &&
> -	    !xfs_inode_has_bigtime(ip)) {
> +	    xfs_has_bigtime(mp) && !xfs_inode_has_bigtime(ip)) {
>  		ip->i_diflags2 |= XFS_DIFLAG2_BIGTIME;
>  		flags |= XFS_ILOG_CORE;
>  	}
> @@ -138,14 +139,14 @@ xfs_inode_item_precommit(
>  	 */
>  	if (ip->i_diflags & XFS_DIFLAG_RTINHERIT) {
>  		if ((ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
> -		    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_extsize) > 0) {
> +		    xfs_extlen_to_rtxmod(mp, ip->i_extsize) > 0) {
>  			ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
>  					   XFS_DIFLAG_EXTSZINHERIT);
>  			ip->i_extsize = 0;
>  			flags |= XFS_ILOG_CORE;
>  		}
>  		if ((ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
> -		    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_cowextsize) > 0) {
> +		    xfs_extlen_to_rtxmod(mp, ip->i_cowextsize) > 0) {
>  			ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
>  			ip->i_cowextsize = 0;
>  			flags |= XFS_ILOG_CORE;
> @@ -154,6 +155,7 @@ xfs_inode_item_precommit(
>  
>  	spin_lock(&iip->ili_lock);
>  	if (!iip->ili_item.li_buf) {
> +		struct xfs_perag *pag;
>  		struct xfs_buf	*bp;
>  		int		error;
>  
> @@ -167,8 +169,9 @@ xfs_inode_item_precommit(
>  		 * here.
>  		 */
>  		spin_unlock(&iip->ili_lock);
> -		error = xfs_read_icluster(ip->i_mount, tp, ip->i_imap.im_blkno,
> -				&bp);
> +		pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
> +		error = xfs_read_icluster(pag, tp, ip->i_imap.im_agbno, &bp);
> +		xfs_perag_put(pag);
>  		if (error)
>  			return error;
>  
> @@ -654,7 +657,8 @@ xfs_inode_item_format(
>  	ilf = xlog_format_start(lfb, XLOG_REG_TYPE_IFORMAT);
>  	ilf->ilf_type = XFS_LI_INODE;
>  	ilf->ilf_ino = I_INO(ip);
> -	ilf->ilf_blkno = ip->i_imap.im_blkno;
> +	ilf->ilf_blkno = XFS_AGB_TO_DADDR(mp, XFS_INODE_TO_AGNO(ip),
> +				ip->i_imap.im_agbno);
>  	ilf->ilf_len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
>  	ilf->ilf_boffset = ip->i_imap.im_boffset;
>  	ilf->ilf_fields = XFS_ILOG_CORE;
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 97f106d2b4cd..159295c63e8f 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -97,7 +97,7 @@ xfs_bulkstat_one_int(
>  	}
>  
>  	ASSERT(ip != NULL);
> -	ASSERT(ip->i_imap.im_blkno != 0);
> +	ASSERT(ip->i_imap.im_agbno != 0);
>  	inode = VFS_I(ip);
>  	vfsuid = i_uid_into_vfsuid(idmap, inode);
>  	vfsgid = i_gid_into_vfsgid(idmap, inode);
> diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
> index f8f2edea0934..d76d3f0434f1 100644
> --- a/fs/xfs/xfs_iunlink_item.c
> +++ b/fs/xfs/xfs_iunlink_item.c
> @@ -59,7 +59,7 @@ xfs_iunlink_log_dinode(
>  	int			offset;
>  	int			error;
>  
> -	error = xfs_read_icluster(tp->t_mountp, tp, ip->i_imap.im_blkno, &ibp);
> +	error = xfs_read_icluster(iup->pag, tp, ip->i_imap.im_agbno, &ibp);
>  	if (error)
>  		return error;
>  	/*
> -- 
> 2.53.0
> 
> 
