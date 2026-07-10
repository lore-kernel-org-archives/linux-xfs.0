Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3177C38655B;
	Fri, 10 Jul 2026 05:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783661827; cv=none; b=SLNq6Ok3EQdvZVSFD7KjK4euKXlQaAAteWMyhLmyGybPDnFjVMN7MI37w4kLkIYrCTMdTdFP276ETg+shGoEHzjttSNm3aQ3tWBwoUNZhUC1BkmtD8RVeUtdOAr61YEKIAWunAXKsF7fR7E3dW3GeaCpe2Ttx1qxfHBRdpRipOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783661827; c=relaxed/simple;
	bh=iIQ1LPUs+suUCCue0K5r0vvVv2S/htxMmSc1PAVMiBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fRwWDA90DYQhr91kG1YZFXqyxQ60fVLQQcljas8h5528s1BzS9C7Xiy8PV8plwCRExUFZ9SlxXKuiKDWk/Fhjvne08FN4iWWaLBDJNcOhiw/ec29MbE612DthVizS5Ch5lYBXz6c+up5pt0UdIHc7774U2s/RMomyRLXbxuZXfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C32DF68BEB; Fri, 10 Jul 2026 07:37:01 +0200 (CEST)
Date: Fri, 10 Jul 2026 07:37:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: don't replace the wrong part of the cow fork
Message-ID: <20260710053701.GA7392@lst.de>
References: <178366080946.1173468.2461850065055339934.stgit@frogsfrogsfrogs> <178366081014.1173468.1923355584342845630.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178366081014.1173468.1923355584342845630.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 09, 2026 at 10:21:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out that xfs_iext_lookup_extent can return a @got where
> got->br_startoff < startoff.  In this case, xrep_cow_replace_range
> replaces the entire mapping instead of just the part that had been
> marked bad in the bitmap, but advances the bitmap cursor in
> xrep_cow_replace by the amount replaced.  As a result, we fail to
> replace the end of the bad range, and replace part of the good range.
> 
> Fix this by rewriting the replace method to handle replacing the middle
> of a cow fork mapping.  This we do by returning both the current mapping
> as @got, and the subset of the mapping that we want to replace as @rep,
> using @rep to store the results of the new allocation, and comparing
> @rep to @got to figure out the exact transformations needed.
> 
> Cc: <stable@vger.kernel.org> # v6.8
> Fixes: dbbdbd0086320a ("xfs: repair problems in CoW forks")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> ---
>  fs/xfs/scrub/trace.h      |   28 ++++--
>  fs/xfs/scrub/cow_repair.c |  203 +++++++++++++++++++++++++++++----------------
>  2 files changed, 148 insertions(+), 83 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 1b7d9e07a27d3d..d48a6db5b5f308 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -2672,9 +2672,9 @@ TRACE_EVENT(xrep_cow_mark_file_range,
>  );
>  
>  TRACE_EVENT(xrep_cow_replace_mapping,
> -	TP_PROTO(struct xfs_inode *ip, const struct xfs_bmbt_irec *irec,
> -		 xfs_fsblock_t new_startblock, xfs_extlen_t new_blockcount),
> -	TP_ARGS(ip, irec, new_startblock, new_blockcount),
> +	TP_PROTO(struct xfs_inode *ip, const struct xfs_bmbt_irec *got,
> +		 const struct xfs_bmbt_irec *rep),
> +	TP_ARGS(ip, got, rep),
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_ino_t, ino)
> @@ -2682,28 +2682,34 @@ TRACE_EVENT(xrep_cow_replace_mapping,
>  		__field(xfs_fileoff_t, startoff)
>  		__field(xfs_filblks_t, blockcount)
>  		__field(xfs_exntst_t, state)
> +		__field(xfs_fileoff_t, new_startoff)
>  		__field(xfs_fsblock_t, new_startblock)
>  		__field(xfs_extlen_t, new_blockcount)
> +		__field(xfs_exntst_t, new_state)
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
>  		__entry->ino = I_INO(ip);
> -		__entry->startoff = irec->br_startoff;
> -		__entry->startblock = irec->br_startblock;
> -		__entry->blockcount = irec->br_blockcount;
> -		__entry->state = irec->br_state;
> -		__entry->new_startblock = new_startblock;
> -		__entry->new_blockcount = new_blockcount;
> +		__entry->startoff = got->br_startoff;
> +		__entry->startblock = got->br_startblock;
> +		__entry->blockcount = got->br_blockcount;
> +		__entry->state = got->br_state;
> +		__entry->new_startoff = rep->br_startoff;
> +		__entry->new_startblock = rep->br_startblock;
> +		__entry->new_blockcount = rep->br_blockcount;
> +		__entry->new_state = rep->br_state;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx startoff 0x%llx startblock 0x%llx fsbcount 0x%llx state 0x%x new_startblock 0x%llx new_fsbcount 0x%x",
> +	TP_printk("dev %d:%d ino 0x%llx startoff 0x%llx startblock 0x%llx fsbcount 0x%llx state 0x%x new_startoff 0x%llx new_startblock 0x%llx new_fsbcount 0x%x new_state 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->startoff,
>  		  __entry->startblock,
>  		  __entry->blockcount,
>  		  __entry->state,
> +		  __entry->new_startoff,
>  		  __entry->new_startblock,
> -		  __entry->new_blockcount)
> +		  __entry->new_blockcount,
> +		  __entry->new_state)
>  );
>  
>  TRACE_EVENT(xrep_cow_free_staging,
> diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
> index 0075b6d5a1b5ff..ca3405a26b641c 100644
> --- a/fs/xfs/scrub/cow_repair.c
> +++ b/fs/xfs/scrub/cow_repair.c
> @@ -80,12 +80,6 @@ struct xrep_cow {
>  	unsigned int		next_bno;
>  };
>  
> -/* CoW staging extent. */
> -struct xrep_cow_extent {
> -	xfs_fsblock_t		fsbno;
> -	xfs_extlen_t		len;
> -};
> -
>  /*
>   * Mark the part of the file range that corresponds to the given physical
>   * space.  Caller must ensure that the physical range is within xc->irec.
> @@ -401,22 +395,21 @@ xrep_cow_find_bad_rt(
>  STATIC int
>  xrep_cow_alloc(
>  	struct xfs_scrub	*sc,
> -	xfs_extlen_t		maxlen,
> -	struct xrep_cow_extent	*repl)
> +	struct xfs_bmbt_irec	*del)
>  {
>  	struct xfs_alloc_arg	args = {
>  		.tp		= sc->tp,
>  		.mp		= sc->mp,
>  		.oinfo		= XFS_RMAP_OINFO_SKIP_UPDATE,
>  		.minlen		= 1,
> -		.maxlen		= maxlen,
> +		.maxlen		= del->br_blockcount,
>  		.prod		= 1,
>  		.resv		= XFS_AG_RESV_NONE,
>  		.datatype	= XFS_ALLOC_USERDATA,
>  	};
>  	int			error;
>  
> -	error = xfs_trans_reserve_more(sc->tp, maxlen, 0);
> +	error = xfs_trans_reserve_more(sc->tp, del->br_blockcount, 0);
>  	if (error)
>  		return error;
>  
> @@ -428,8 +421,8 @@ xrep_cow_alloc(
>  
>  	xfs_refcount_alloc_cow_extent(sc->tp, false, args.fsbno, args.len);
>  
> -	repl->fsbno = args.fsbno;
> -	repl->len = args.len;
> +	del->br_startblock = args.fsbno;
> +	del->br_blockcount = args.len;
>  	return 0;
>  }
>  
> @@ -440,10 +433,12 @@ xrep_cow_alloc(
>  STATIC int
>  xrep_cow_alloc_rt(
>  	struct xfs_scrub	*sc,
> -	xfs_extlen_t		maxlen,
> -	struct xrep_cow_extent	*repl)
> +	struct xfs_bmbt_irec	*del)
>  {
> -	xfs_rtxlen_t		maxrtx = xfs_rtb_to_rtx(sc->mp, maxlen);
> +	xfs_fsblock_t		fsbno;
> +	xfs_rtxlen_t		maxrtx =
> +		min(U32_MAX, xfs_blen_to_rtbxlen(sc->mp, del->br_blockcount));
> +	xfs_extlen_t		len;
>  	int			error;
>  
>  	error = xfs_trans_reserve_more(sc->tp, 0, maxrtx);
> @@ -451,11 +446,14 @@ xrep_cow_alloc_rt(
>  		return error;
>  
>  	error = xfs_rtallocate_rtgs(sc->tp, NULLRTBLOCK, 1, maxrtx, 1, false,
> -			false, &repl->fsbno, &repl->len);
> +			false, &fsbno, &len);
>  	if (error)
>  		return error;
>  
> -	xfs_refcount_alloc_cow_extent(sc->tp, true, repl->fsbno, repl->len);
> +	xfs_refcount_alloc_cow_extent(sc->tp, true, fsbno, len);
> +
> +	del->br_startblock = fsbno;
> +	del->br_blockcount = len;
>  	return 0;
>  }
>  
> @@ -469,19 +467,19 @@ static inline int
>  xrep_cow_find_mapping(
>  	struct xrep_cow		*xc,
>  	struct xfs_iext_cursor	*icur,
> -	xfs_fileoff_t		startoff,
> -	struct xfs_bmbt_irec	*got)
> +	xfs_fileoff_t		badoff,
> +	xfs_extlen_t		badlen,
> +	struct xfs_bmbt_irec	*got,
> +	struct xfs_bmbt_irec	*rep)
>  {
>  	struct xfs_inode	*ip = xc->sc->ip;
>  	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
>  
> -	if (!xfs_iext_lookup_extent(ip, ifp, startoff, icur, got))
> +	if (!xfs_iext_lookup_extent(ip, ifp, badoff, icur, got))
>  		goto bad;
> +	memcpy(rep, got, sizeof(*rep));
>  
> -	if (got->br_startoff > startoff)
> -		goto bad;
> -
> -	if (got->br_blockcount == 0)
> +	if (got->br_startoff > badoff)
>  		goto bad;
>  
>  	if (isnullstartblock(got->br_startblock))
> @@ -490,6 +488,24 @@ xrep_cow_find_mapping(
>  	if (xfs_bmap_is_written_extent(got))
>  		goto bad;
>  
> +	if (got->br_startoff < badoff) {
> +		const int64_t	delta = badoff - got->br_startoff;
> +
> +		rep->br_blockcount -= delta;
> +		rep->br_startoff += delta;
> +		rep->br_startblock += delta;
> +	}
> +
> +	if (got->br_startoff + got->br_blockcount > badoff + badlen) {
> +		const int64_t	delta = (got->br_startoff + got->br_blockcount) -
> +					(badoff + badlen);
> +
> +		rep->br_blockcount -= delta;

Overly long line here.  Although I'm not even sure what the point is in
this local delta variable that is only used once anyay.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
