Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B12233F377
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 11:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779102288; cv=none; b=T2ZuRbPMeeGTFiDVNiJf1sjvoa92Fb8pldJEhHxCNDNsqJjq+0bgwmSXLP6aSE6MVmfCjSJkNCF9Dc8sNDA1Zp5RH4wMamqgJ5gYrUOVfFpEgOCFyJbqpVWqizGTZKLPgwWq4TMre6cQ3dtaNgpPHmkpkJKMdsxFudQwH/kpS68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779102288; c=relaxed/simple;
	bh=aA4cX+ot04rkTONXzLwvQvyXDEhJtVVe4Tg8yRe1lBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UINctJdddcwN96jaXhgPquwoClnNOmRg3Qmk5mdJrbijPeoaIVs4jYpQGM0L5p5WIKZqZXPQvS1Cezh0zdAuPl9gSC3GdjZNGbUo1912eIzRuWQXHPIbDZyEO3l7H9nC/4kq+KipqdmAUZOKs2hFIle5nc5djwRSGVVFbYDmM0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o87EYH31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o87EYH31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0357C2BCB7;
	Mon, 18 May 2026 11:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779102287;
	bh=aA4cX+ot04rkTONXzLwvQvyXDEhJtVVe4Tg8yRe1lBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o87EYH31cirB/B/CiF9Jcz29KqbR1L1K4CyV0xbt4Mv0x96QssbH7BQraduomGlC3
	 FuwKVBOvnXbew5PpIEU5dw+q6uuVrp386VrKombqBk5Fk0W4rV/5QTAF7BeajxBXd5
	 b+S/rDfgyLW/bwKy0e0dGceNzVtpBS14NZymEhnvghZUYAhLipXmhxNDvzz6dhmxHO
	 aw3nvzBoZ89WYFyFs1Me8LE5bZ1xfCG00JVUk3MxDOSEX236Mxs5YzeRLzcD2iTlc+
	 6smbPVQj3CH/NgytwjQyYOwwo+sf10yOHlmUbxaR2RlpisHDoQB4vwCJB3Q4nu1Rbv
	 pzPZT9nnVrSnw==
Date: Mon, 18 May 2026 13:04:43 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: add a XFS_INODE_TO_AGINO helper
Message-ID: <agryRoypSFzaeZJL@nidhogg.toxiclabs.cc>
References: <20260515135103.4042407-1-hch@lst.de>
 <20260515135103.4042407-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515135103.4042407-3-hch@lst.de>

On Fri, May 15, 2026 at 03:50:23PM +0200, Christoph Hellwig wrote:
> Add a shortcut for the common XFS_INO_TO_AGINO(mp, ip->i_ino) pattern.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_format.h     |  2 ++
>  fs/xfs/libxfs/xfs_inode_util.c |  5 ++---
>  fs/xfs/scrub/agheader_repair.c | 10 +++-------
>  fs/xfs/scrub/trace.h           | 10 +++++-----
>  fs/xfs/xfs_icache.c            | 10 +++++-----
>  fs/xfs/xfs_inode.c             |  2 +-
>  fs/xfs/xfs_trace.h             | 12 +++++-------
>  7 files changed, 23 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 36a00c174f1e..f812c6782492 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1280,6 +1280,8 @@ static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
>  	XFS_INO_TO_AGNO((ip)->i_mount, (ip)->i_ino)
>  #define	XFS_INO_TO_AGINO(mp,i)		\
>  	((xfs_agino_t)(i) & XFS_INO_MASK(XFS_INO_AGINO_BITS(mp)))
> +#define	XFS_INODE_TO_AGINO(ip)		\
> +	XFS_INO_TO_AGINO((ip)->i_mount, (ip)->i_ino)
>  #define	XFS_INO_TO_AGBNO(mp,i)		\
>  	(((xfs_agblock_t)(i) >> XFS_INO_OFFSET_BITS(mp)) & \
>  		XFS_INO_MASK(XFS_INO_AGBNO_BITS(mp)))
> diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
> index b478d16c0e20..f42935fe693d 100644
> --- a/fs/xfs/libxfs/xfs_inode_util.c
> +++ b/fs/xfs/libxfs/xfs_inode_util.c
> @@ -462,10 +462,9 @@ xfs_iunlink_insert_inode(
>  	struct xfs_buf		*agibp,
>  	struct xfs_inode	*ip)
>  {
> -	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_agi		*agi = agibp->b_addr;
>  	xfs_agino_t		next_agino;
> -	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> +	xfs_agino_t		agino = XFS_INODE_TO_AGINO(ip);
>  	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
>  	int			error;
>  
> @@ -551,7 +550,7 @@ xfs_iunlink_remove_inode(
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_agi		*agi = agibp->b_addr;
> -	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> +	xfs_agino_t		agino = XFS_INODE_TO_AGINO(ip);
>  	xfs_agino_t		head_agino;
>  	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
>  	int			error;
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index c8d54ce6e363..53c6d68ac638 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -1134,18 +1134,14 @@ xrep_iunlink_visit(
>  	struct xrep_agi		*ragi,
>  	unsigned int		batch_idx)
>  {
> -	struct xfs_mount	*mp = ragi->sc->mp;
>  	struct xfs_inode	*ip = ragi->lookup_batch[batch_idx];
> -	xfs_agino_t		agino;
> -	unsigned int		bucket;
> +	xfs_agino_t		agino = XFS_INODE_TO_AGINO(ip);
> +	unsigned int		bucket = agino % XFS_AGI_UNLINKED_BUCKETS;
>  	int			error;
>  
>  	ASSERT(XFS_INODE_TO_AGNO(ip) == pag_agno(ragi->sc->sa.pag));
>  	ASSERT(xfs_inode_on_unlinked_list(ip));
>  
> -	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> -	bucket = agino % XFS_AGI_UNLINKED_BUCKETS;
> -
>  	trace_xrep_iunlink_visit(ragi->sc->sa.pag, bucket,
>  			ragi->iunlink_heads[bucket], ip);
>  
> @@ -1214,7 +1210,7 @@ xrep_iunlink_mark_incore(
>  			if (XFS_INODE_TO_AGNO(ip) != pag_agno(pag))
>  				continue;
>  			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
> -			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
> +			if (first_index < XFS_INODE_TO_AGINO(ip))
>  				done = true;
>  		}
>  
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 6c684e9433db..f607ac5fb953 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -3443,7 +3443,7 @@ TRACE_EVENT(xrep_iunlink_visit,
>  	TP_fast_assign(
>  		__entry->dev = pag_mount(pag)->m_super->s_dev;
>  		__entry->agno = pag_agno(pag);
> -		__entry->agino = XFS_INO_TO_AGINO(pag_mount(pag), ip->i_ino);
> +		__entry->agino = XFS_INODE_TO_AGINO(ip);
>  		__entry->bucket = bucket;
>  		__entry->bucket_agino = bucket_agino;
>  		__entry->prev_agino = ip->i_prev_unlinked;
> @@ -3474,7 +3474,7 @@ TRACE_EVENT(xrep_iunlink_reload_next,
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
>  		__entry->agno = XFS_INODE_TO_AGNO(ip);
> -		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
> +		__entry->agino = XFS_INODE_TO_AGINO(ip);
>  		__entry->old_prev_agino = ip->i_prev_unlinked;
>  		__entry->prev_agino = prev_agino;
>  		__entry->next_agino = ip->i_next_unlinked;
> @@ -3504,7 +3504,7 @@ TRACE_EVENT(xrep_iunlink_reload_ondisk,
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
>  		__entry->agno = XFS_INODE_TO_AGNO(ip);
> -		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
> +		__entry->agino = XFS_INODE_TO_AGINO(ip);
>  		__entry->nlink = VFS_I(ip)->i_nlink;
>  		__entry->next_agino = ip->i_next_unlinked;
>  	),
> @@ -3591,7 +3591,7 @@ TRACE_EVENT(xrep_iunlink_relink_next,
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
>  		__entry->agno = XFS_INODE_TO_AGNO(ip);
> -		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
> +		__entry->agino = XFS_INODE_TO_AGINO(ip);
>  		__entry->next_agino = ip->i_next_unlinked;
>  		__entry->new_next_agino = next_agino;
>  	),
> @@ -3617,7 +3617,7 @@ TRACE_EVENT(xrep_iunlink_relink_prev,
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
>  		__entry->agno = XFS_INODE_TO_AGNO(ip);
> -		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
> +		__entry->agino = XFS_INODE_TO_AGINO(ip);
>  		__entry->prev_agino = ip->i_prev_unlinked;
>  		__entry->new_prev_agino = prev_agino;
>  	),
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 73f06bb13075..d0bc8ea79d40 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -397,7 +397,7 @@ xfs_iget_recycle(
>  	 */
>  	ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
>  	ip->i_flags |= XFS_INEW;
> -	xfs_perag_clear_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
> +	xfs_perag_clear_inode_tag(pag, XFS_INODE_TO_AGINO(ip),
>  			XFS_ICI_RECLAIM_TAG);
>  	inode_state_assign_raw(inode, I_NEW);
>  	spin_unlock(&ip->i_flags_lock);
> @@ -1288,7 +1288,7 @@ xfs_blockgc_set_iflag(
>  	pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
>  	spin_lock(&pag->pag_ici_lock);
>  
> -	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
> +	xfs_perag_set_inode_tag(pag, XFS_INODE_TO_AGINO(ip),
>  			XFS_ICI_BLOCKGC_TAG);
>  
>  	spin_unlock(&pag->pag_ici_lock);
> @@ -1325,7 +1325,7 @@ xfs_blockgc_clear_iflag(
>  	pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
>  	spin_lock(&pag->pag_ici_lock);
>  
> -	xfs_perag_clear_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
> +	xfs_perag_clear_inode_tag(pag, XFS_INODE_TO_AGINO(ip),
>  			XFS_ICI_BLOCKGC_TAG);
>  
>  	spin_unlock(&pag->pag_ici_lock);
> @@ -1803,7 +1803,7 @@ xfs_icwalk_ag(
>  			if (XFS_INODE_TO_AGNO(ip) != pag_agno(pag))
>  				continue;
>  			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
> -			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
> +			if (first_index < XFS_INODE_TO_AGINO(ip))
>  				done = true;
>  		}
>  
> @@ -1921,7 +1921,7 @@ xfs_inodegc_set_reclaimable(
>  	trace_xfs_inode_set_reclaimable(ip);
>  	ip->i_flags &= ~(XFS_NEED_INACTIVE | XFS_INACTIVATING);
>  	ip->i_flags |= XFS_IRECLAIMABLE;
> -	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
> +	xfs_perag_set_inode_tag(pag, XFS_INODE_TO_AGINO(ip),
>  			XFS_ICI_RECLAIM_TAG);
>  
>  	spin_unlock(&ip->i_flags_lock);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 8a25cefaa17f..f9015a1c6bd8 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2859,7 +2859,7 @@ xfs_inode_reload_unlinked_bucket(
>  	struct xfs_agi		*agi;
>  	struct xfs_perag	*pag;
>  	xfs_agnumber_t		agno = XFS_INODE_TO_AGNO(ip);
> -	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> +	xfs_agino_t		agino = XFS_INODE_TO_AGINO(ip);
>  	xfs_agino_t		prev_agino, next_agino;
>  	unsigned int		bucket;
>  	bool			foundit = false;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index cd8b85dac7a8..6767e50b643d 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4504,8 +4504,7 @@ TRACE_EVENT(xfs_iunlink_update_dinode,
>  	TP_fast_assign(
>  		__entry->dev = pag_mount(iup->pag)->m_super->s_dev;
>  		__entry->agno = pag_agno(iup->pag);
> -		__entry->agino =
> -			XFS_INO_TO_AGINO(iup->ip->i_mount, iup->ip->i_ino);
> +		__entry->agino = XFS_INODE_TO_AGINO(iup->ip);
>  		__entry->old_ptr = old_ptr;
>  		__entry->new_ptr = iup->next_agino;
>  	),
> @@ -4530,7 +4529,7 @@ TRACE_EVENT(xfs_iunlink_reload_next,
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
>  		__entry->agno = XFS_INODE_TO_AGNO(ip);
> -		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
> +		__entry->agino = XFS_INODE_TO_AGINO(ip);
>  		__entry->prev_agino = ip->i_prev_unlinked;
>  		__entry->next_agino = ip->i_next_unlinked;
>  	),
> @@ -4553,7 +4552,7 @@ TRACE_EVENT(xfs_inode_reload_unlinked_bucket,
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
>  		__entry->agno = XFS_INODE_TO_AGNO(ip);
> -		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
> +		__entry->agino = XFS_INODE_TO_AGINO(ip);
>  	),
>  	TP_printk("dev %d:%d agno 0x%x agino 0x%x bucket %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> @@ -4573,7 +4572,7 @@ DECLARE_EVENT_CLASS(xfs_ag_inode_class,
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
>  		__entry->agno = XFS_INODE_TO_AGNO(ip);
> -		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
> +		__entry->agino = XFS_INODE_TO_AGINO(ip);
>  	),
>  	TP_printk("dev %d:%d agno 0x%x agino 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> @@ -4770,8 +4769,7 @@ TRACE_EVENT(xfs_btree_commit_ifakeroot,
>  		__entry->dev = cur->bc_mp->m_super->s_dev;
>  		__assign_str(name);
>  		__entry->agno = XFS_INODE_TO_AGNO(cur->bc_ino.ip);
> -		__entry->agino = XFS_INO_TO_AGINO(cur->bc_mp,
> -					cur->bc_ino.ip->i_ino);
> +		__entry->agino = XFS_INODE_TO_AGINO(cur->bc_ino.ip);
>  		__entry->levels = cur->bc_ino.ifake->if_levels;
>  		__entry->blocks = cur->bc_ino.ifake->if_blocks;
>  		__entry->whichfork = cur->bc_ino.whichfork;
> -- 
> 2.53.0
> 
> 
