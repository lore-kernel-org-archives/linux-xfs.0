Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127F870CCB
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 16:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710434137; cv=none; b=P4gubsn9TlO+tp0GQvFJ1f7vpXu2MOPtDegSCuvZHI3nKAaP32JO+7rEqUfapDH+dr+NVLCoW7aog7x99aS43rzLGx3t4xh9VLpDaAlm3SjrNDTkYNW6YgErfJaEO30WHS1g+SClM/Xs9I6wdVyjcbIWulnga1qB93VbYgmwhVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710434137; c=relaxed/simple;
	bh=xaEyNSwtFswPn2Er96KW1azwSMaxfvaPZyJCT7hxQQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uR6pJRiLE3sEqMCOSQM0sADKquH34QSn3rHVEcSEgBD2XvYysDxmspMpekLQZVwxjt8V4gwpIx/xF7SUKYTHIdfX1kO/NCRBgDGIR1zy5FBwS95mS5dN5YiAWwl30UJl9UfmqQ0vpjZPx3BzyTl2J99Gop+DM+qCel3WDsJzsbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uzl7DOSu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uzl7DOSu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710434135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NRB9vTG1kKTwVMuM3USj3EPm7GRoeAkz+vXVY9ZBgmA=;
	b=Uzl7DOSuIu0SFgCyYBG/ZMRqYaUnz4IIZl86IqbXSYOB/uOyKc1OZ4oQtzPQePp3yCSXSc
	Bjwrhg301HHDXUbos9Z1P2sOxd2h2GoYgrKxyRRZQleQUk3kF/1o88pkRVGxjM58WsHk/g
	xNJL3qpysTbjGy7pCyXFAPmQqFNeJdA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-145-aCbUAVERNsOXa_PuAry4Qw-1; Thu,
 14 Mar 2024 12:35:31 -0400
X-MC-Unique: aCbUAVERNsOXa_PuAry4Qw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F40B3C025AC;
	Thu, 14 Mar 2024 16:35:31 +0000 (UTC)
Received: from redhat.com (unknown [10.22.16.77])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A8128492BD1;
	Thu, 14 Mar 2024 16:35:30 +0000 (UTC)
Date: Thu, 14 Mar 2024 11:35:29 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_repair: sync bulkload data structures with
 kernel newbt code
Message-ID: <ZfMnUfcxF0641dqF@redhat.com>
References: <171029434322.2065697.15834513610979167624.stgit@frogsfrogsfrogs>
 <171029434355.2065697.8914601331036024173.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029434355.2065697.8914601331036024173.stgit@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Tue, Mar 12, 2024 at 07:14:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A lot of the code in repair/bulkload.c was backwardsported from new code
> that eventually turned into newbt.c in online repair.  Since the offline
> repair version got merged upstream years before the online repair code,
> we now need to bring the offline version up to date with the kernel
> again.
> 
> Right now, the bulkload.c code is just a fancy way to track space
> extents that are fed to it by its callers.  The only caller, of course,
> is phase 5, which builds new btrees in AG space that wasn't claimed by
> any other data structure.  Hence there's no need to allocate
> reservations out of the bnobt or put them back there.
> 
> However, the next patch adds the ability to generate new file-based
> btrees.  For that we need to reorganize the code to allocate and free
> space for new file-based btrees.  Let's just crib from the kernel
> version.  Make each bulkload space reservation hold a reference to an AG
> and track the space reservation in terms of per-AG extents instead of
> fsblock extents.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
>  libxfs/libxfs_api_defs.h |    1 +
>  repair/agbtree.c         |   22 +++++++++++-----
>  repair/bulkload.c        |   63 +++++++++++++++++++++++++++++++++-------------
>  repair/bulkload.h        |   12 +++++----
>  repair/phase5.c          |    2 +
>  5 files changed, 69 insertions(+), 31 deletions(-)
> 
> 
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 36afc5d0234d..28960317ab6b 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -149,6 +149,7 @@
>  #define xfs_log_sb			libxfs_log_sb
>  #define xfs_mode_to_ftype		libxfs_mode_to_ftype
>  #define xfs_perag_get			libxfs_perag_get
> +#define xfs_perag_hold			libxfs_perag_hold
>  #define xfs_perag_put			libxfs_perag_put
>  #define xfs_prealloc_blocks		libxfs_prealloc_blocks
>  
> diff --git a/repair/agbtree.c b/repair/agbtree.c
> index e014e216e0a5..c6f0512fe7de 100644
> --- a/repair/agbtree.c
> +++ b/repair/agbtree.c
> @@ -77,13 +77,17 @@ reserve_agblocks(
>  	uint32_t		nr_blocks)
>  {
>  	struct extent_tree_node	*ext_ptr;
> +	struct xfs_perag	*pag;
>  	uint32_t		blocks_allocated = 0;
>  	uint32_t		len;
>  	int			error;
>  
> +	pag = libxfs_perag_get(mp, agno);
> +	if (!pag)
> +		do_error(_("could not open perag structure for agno 0x%x\n"),
> +				agno);
> +
>  	while (blocks_allocated < nr_blocks)  {
> -		xfs_fsblock_t	fsbno;
> -
>  		/*
>  		 * Grab the smallest extent and use it up, then get the
>  		 * next smallest.  This mimics the init_*_cursor code.
> @@ -94,8 +98,8 @@ reserve_agblocks(
>  
>  		/* Use up the extent we've got. */
>  		len = min(ext_ptr->ex_blockcount, nr_blocks - blocks_allocated);
> -		fsbno = XFS_AGB_TO_FSB(mp, agno, ext_ptr->ex_startblock);
> -		error = bulkload_add_blocks(&btr->newbt, fsbno, len);
> +		error = bulkload_add_extent(&btr->newbt, pag,
> +				ext_ptr->ex_startblock, len);
>  		if (error)
>  			do_error(_("could not set up btree reservation: %s\n"),
>  				strerror(-error));
> @@ -113,6 +117,7 @@ reserve_agblocks(
>  	fprintf(stderr, "blocks_allocated = %d\n",
>  		blocks_allocated);
>  #endif
> +	libxfs_perag_put(pag);
>  	return blocks_allocated == nr_blocks;
>  }
>  
> @@ -155,18 +160,21 @@ finish_rebuild(
>  	int			error;
>  
>  	for_each_bulkload_reservation(&btr->newbt, resv, n) {
> +		xfs_fsblock_t	fsbno;
> +
>  		if (resv->used == resv->len)
>  			continue;
>  
> -		error = bitmap_set(lost_blocks, resv->fsbno + resv->used,
> -				   resv->len - resv->used);
> +		fsbno = XFS_AGB_TO_FSB(mp, resv->pag->pag_agno,
> +				resv->agbno + resv->used);
> +		error = bitmap_set(lost_blocks, fsbno, resv->len - resv->used);
>  		if (error)
>  			do_error(
>  _("Insufficient memory saving lost blocks, err=%d.\n"), error);
>  		resv->used = resv->len;
>  	}
>  
> -	bulkload_destroy(&btr->newbt, 0);
> +	bulkload_commit(&btr->newbt);
>  }
>  
>  /*
> diff --git a/repair/bulkload.c b/repair/bulkload.c
> index 0117f69416cf..18158c397f56 100644
> --- a/repair/bulkload.c
> +++ b/repair/bulkload.c
> @@ -23,39 +23,64 @@ bulkload_init_ag(
>  }
>  
>  /* Designate specific blocks to be used to build our new btree. */
> -int
> +static int
>  bulkload_add_blocks(
> -	struct bulkload		*bkl,
> -	xfs_fsblock_t		fsbno,
> -	xfs_extlen_t		len)
> +	struct bulkload			*bkl,
> +	struct xfs_perag		*pag,
> +	const struct xfs_alloc_arg	*args)
>  {
> -	struct bulkload_resv	*resv;
> +	struct xfs_mount		*mp = bkl->sc->mp;
> +	struct bulkload_resv		*resv;
>  
> -	resv = kmem_alloc(sizeof(struct bulkload_resv), KM_MAYFAIL);
> +	resv = kmalloc(sizeof(struct bulkload_resv), GFP_KERNEL);
>  	if (!resv)
>  		return ENOMEM;
>  
>  	INIT_LIST_HEAD(&resv->list);
> -	resv->fsbno = fsbno;
> -	resv->len = len;
> +	resv->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
> +	resv->len = args->len;
>  	resv->used = 0;
> +	resv->pag = libxfs_perag_hold(pag);
> +
>  	list_add_tail(&resv->list, &bkl->resv_list);
> -	bkl->nr_reserved += len;
> -
> +	bkl->nr_reserved += args->len;
>  	return 0;
>  }
>  
> +/*
> + * Add an extent to the new btree reservation pool.  Callers are required to
> + * reap this reservation manually if the repair is cancelled.  @pag must be a
> + * passive reference.
> + */
> +int
> +bulkload_add_extent(
> +	struct bulkload		*bkl,
> +	struct xfs_perag	*pag,
> +	xfs_agblock_t		agbno,
> +	xfs_extlen_t		len)
> +{
> +	struct xfs_mount	*mp = bkl->sc->mp;
> +	struct xfs_alloc_arg	args = {
> +		.tp		= NULL, /* no autoreap */
> +		.oinfo		= bkl->oinfo,
> +		.fsbno		= XFS_AGB_TO_FSB(mp, pag->pag_agno, agbno),
> +		.len		= len,
> +		.resv		= XFS_AG_RESV_NONE,
> +	};
> +
> +	return bulkload_add_blocks(bkl, pag, &args);
> +}
> +
>  /* Free all the accounting info and disk space we reserved for a new btree. */
>  void
> -bulkload_destroy(
> -	struct bulkload		*bkl,
> -	int			error)
> +bulkload_commit(
> +	struct bulkload		*bkl)
>  {
>  	struct bulkload_resv	*resv, *n;
>  
>  	list_for_each_entry_safe(resv, n, &bkl->resv_list, list) {
>  		list_del(&resv->list);
> -		kmem_free(resv);
> +		kfree(resv);
>  	}
>  }
>  
> @@ -67,7 +92,8 @@ bulkload_claim_block(
>  	union xfs_btree_ptr	*ptr)
>  {
>  	struct bulkload_resv	*resv;
> -	xfs_fsblock_t		fsb;
> +	struct xfs_mount	*mp = cur->bc_mp;
> +	xfs_agblock_t		agbno;
>  
>  	/*
>  	 * The first item in the list should always have a free block unless
> @@ -84,7 +110,7 @@ bulkload_claim_block(
>  	 * decreasing order, which hopefully results in leaf blocks ending up
>  	 * together.
>  	 */
> -	fsb = resv->fsbno + resv->used;
> +	agbno = resv->agbno + resv->used;
>  	resv->used++;
>  
>  	/* If we used all the blocks in this reservation, move it to the end. */
> @@ -92,9 +118,10 @@ bulkload_claim_block(
>  		list_move_tail(&resv->list, &bkl->resv_list);
>  
>  	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> -		ptr->l = cpu_to_be64(fsb);
> +		ptr->l = cpu_to_be64(XFS_AGB_TO_FSB(mp, resv->pag->pag_agno,
> +								agbno));
>  	else
> -		ptr->s = cpu_to_be32(XFS_FSB_TO_AGBNO(cur->bc_mp, fsb));
> +		ptr->s = cpu_to_be32(agbno);
>  	return 0;
>  }
>  
> diff --git a/repair/bulkload.h b/repair/bulkload.h
> index a84e99b8c892..f4790e3b3de6 100644
> --- a/repair/bulkload.h
> +++ b/repair/bulkload.h
> @@ -17,8 +17,10 @@ struct bulkload_resv {
>  	/* Link to list of extents that we've reserved. */
>  	struct list_head	list;
>  
> -	/* FSB of the block we reserved. */
> -	xfs_fsblock_t		fsbno;
> +	struct xfs_perag	*pag;
> +
> +	/* AG block of the block we reserved. */
> +	xfs_agblock_t		agbno;
>  
>  	/* Length of the reservation. */
>  	xfs_extlen_t		len;
> @@ -51,11 +53,11 @@ struct bulkload {
>  
>  void bulkload_init_ag(struct bulkload *bkl, struct repair_ctx *sc,
>  		const struct xfs_owner_info *oinfo);
> -int bulkload_add_blocks(struct bulkload *bkl, xfs_fsblock_t fsbno,
> -		xfs_extlen_t len);
> -void bulkload_destroy(struct bulkload *bkl, int error);
>  int bulkload_claim_block(struct xfs_btree_cur *cur, struct bulkload *bkl,
>  		union xfs_btree_ptr *ptr);
> +int bulkload_add_extent(struct bulkload *bkl, struct xfs_perag *pag,
> +		xfs_agblock_t agbno, xfs_extlen_t len);
> +void bulkload_commit(struct bulkload *bkl);
>  void bulkload_estimate_ag_slack(struct repair_ctx *sc,
>  		struct xfs_btree_bload *bload, unsigned int free);
>  
> diff --git a/repair/phase5.c b/repair/phase5.c
> index d6b8168ea776..b0e208f95af5 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -194,7 +194,7 @@ fill_agfl(
>  	for_each_bulkload_reservation(&btr->newbt, resv, n) {
>  		xfs_agblock_t	bno;
>  
> -		bno = XFS_FSB_TO_AGBNO(mp, resv->fsbno + resv->used);
> +		bno = resv->agbno + resv->used;
>  		while (resv->used < resv->len &&
>  		       *agfl_idx < libxfs_agfl_size(mp)) {
>  			agfl_bnos[(*agfl_idx)++] = cpu_to_be32(bno++);
> 
> 

