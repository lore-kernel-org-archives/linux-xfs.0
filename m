Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2345B190067
	for <linux-xfs@vger.kernel.org>; Fri, 18 Oct 2024 23:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729293110; cv=none; b=SMQjaAqNF6ked5ly97JnePc50bov+uO493tuhjyiyCimrmsXbbtWKi5si41VFFNCzAsQ7a8rHY9iUwFeLdfVM3/I7mx0FX26oHJ48Vmvodl3WsHJTKIUHLQ8Ga65hL0HDkE5Fv1SofH1jddoWwhXsTgQVzn1Bae3txOYMBfyJkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729293110; c=relaxed/simple;
	bh=nMNMMk1IPt9IalEqbwToxQvCoQAUZpGcfTi4UNdB09E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aZ75zRpRmNSMntqt5uirs7K9h/A60Dii3okdufham2MVA4M1nMNPfnECR8f6Yn5tDM+99ACrlrtnfDs0aFdJR8FKmz9jWcAcF2kX5ZuY11whDvbWFWWdxDkGZkQ7fhQe3/i4SuN+tTtBr4donwLvyAfoIoMdlebzaNL3pOEohI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vLwhWuxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vLwhWuxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98732C4CEC3;
	Fri, 18 Oct 2024 23:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729293109;
	bh=nMNMMk1IPt9IalEqbwToxQvCoQAUZpGcfTi4UNdB09E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vLwhWuxYm7KtxMlwDLgyKlPP5zlhdqQAY/YwRbTkHQIpiIMLoxS2u70FqJ7bVHnqW
	 flHvQ0PIgzepkOGsbU6/7a1xdS9lXCr1sJYd6t0ek4ueKoE/hujqtZAvF7aSFIiY/a
	 m39H4N3HfqTpqif8hnERrbVB6zWdZGBJyZ8m7ZQbBtOxnzmdOgc4hk1q6b/HG75H7v
	 yp3vL8jAoe2AyV4kUSzrY4xds5wJY7SBinPbfiX6HInRL1r5NkILQqZ7wylSyg9/NY
	 a4yv4qZlyd/3kgfqaSOOJ4+F6e8soXCgV7Tl7BYLDuYedZmPnV6ybw1XPznYkhBQaf
	 3PGLjSbQi9pBA==
Date: Fri, 18 Oct 2024 16:11:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org, Leah Rumancik <lrumancik@google.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCHBOMB 6.13 v5.1] xfs: metadata directories and realtime
 groups
Message-ID: <20241018231148.GY21853@frogsfrogsfrogs>
References: <20241017184009.GV21853@frogsfrogsfrogs>
 <ZxGdUfNuCD+/qMcw@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZxGdUfNuCD+/qMcw@dread.disaster.area>

On Fri, Oct 18, 2024 at 10:27:13AM +1100, Dave Chinner wrote:
> On Thu, Oct 17, 2024 at 11:40:09AM -0700, Darrick J. Wong wrote:
> > Hi everyone,
> > 
> > Christoph and I have been working on getting the long-delayed metadata
> > directory tree patchset into mergeable shape, and I think we're now
> > satisfied that we've gotten the code to where we want it for 6.13.
> > This time around we've included a ton of cleanups and refactorings that
> > Dave requested during the 6.12 cycle, as well as review suggestions from
> > the v5.0 series last week.  I'm jumping on a train in a couple of hours,
> > so I'm sending this out again.
> 
> What changed from the v5.0 posting of this patchset?
> 
> A change log would be really nice, because it's kinda hard to know
> what needs to be looked at when there's no indication of what has
> changed between postings of a patchset with over 130 patches in
> it.

Sorry about that.  Here's what I remember doing:

 * rebased atop 6.12-rc3 to grab some other bug fixes;
 * pulled in what I think will be hch's final growfs log recovery fix
   series;
 * renamed xg_index->xg_gno;
 * refactored the EXPERIMENTAL warning generation;
 * renamed xfs_is_metadata_inode to xfs_is_internal_inode;
 * renamed xfs_is_internal_inum to xfs_is_sb_inum;
 * moved the sb_rgblklog to the end of the superblock;
 * deleted the sb_bad_features2 removal patch;
 * added a rtg_group helper;
 * deleted xfs_sb_version_hasmetadir;
 * redid the DIFLAG2 bit declarations;

While we're on the topic, let me throw this out for anyone less
experienced than I am with large patchsets:

Don't take my word for what's changed -- I lost my photographic memory
20 years ago in a catastrophe.  Because I push all my git trees to
kernel.org and link to them in all patch submissions, did you all know
that you can just pull the branches (or the tags of that branch from the
day that I posted it) and examine the changes yourself?

$ git clone https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
$ cd linux
$ git remote add djwong https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git
$ git fetch djwong metadir_2024-10-10:metadir_2024-10-10 metadir_2024-10-17:metadir_2024-10-17
$ git diff metadir_2024-10-10..metadir_2024-10-17 fs/xfs/ | less
<large fugly diff>

This gives you the raw changes between v5.0 and v5.1, though admittedly
the 6.12-rc3 rebase adds noise to this.  For a simple update, though,
this is sufficient.  However, a much more comprehensive tool for
patchset review is to use the interdiff, which breaks down changes by
commit, including the commit message.

Make things easier on yourself:

$ git range-diff --color=always v6.12-rc2..metadir_2024-10-10 v6.12-rc3..metadir_2024-10-17 | less
  1:  3b7c108c97e70d <   -:  -------------- xfs: skip background cowblock trims on inodes open for write
  2:  0f646b6bacbb40 <   -:  -------------- xfs: don't free cowblocks from under dirty pagecache on unshare
  -:  -------------- >   1:  d41bff05a61fb5 hid: intel-ish-hid: Fix uninitialized variable 'rv' in ish_fw_xfer_direct_dma
  -:  -------------- >   2:  87b696209007b7 HID: plantronics: Workaround for an unexcepted opposite volume key
  -:  -------------- >   3:  1a5cbb526ec4b8 HID: multitouch: Add support for B2402FVA track point
  -:  -------------- >   4:  7a5ab807111434 HID: multitouch: Add quirk for HONOR MagicBook Art 14 touchpad
  -:  -------------- >   5:  c56f9ecb7fb6a3 HID: amd_sfh: Switch to device-managed dmam_alloc_coherent()
  -:  -------------- >   6:  2934b12281abf4 HID: wacom: Hardcode (non-inverted) AES pens as BTN_TOOL_PEN
  3:  14893bc044372b =   7:  5f88978ba0b0af xfs: fix simplify extent lookup in xfs_can_free_eofblocks
  4:  92926402680362 =   8:  b08231dfc010b0 xfs: don't allocate COW extents when unsharing a hole
  5:  856c2bebdbe29c =   9:  18f7eb311b5de6 iomap: share iomap_unshare_iter predicate code with fsdax
  6:  b77dfca0984d15 =  10:  ee8ad93d7e7fd2 fsdax: remove zeroing code from dax_unshare_iter
  7:  1a878a7719d64d =  11:  d476164e3dac73 fsdax: dax_unshare_iter needs to copy entire blocks
  8:  71d504f0c1212e =  12:  f099ed661b0cf6 xfs: fix integer overflow in xrep_bmap
  9:  e3685a969d9402 !  13:  f97d75a98ea620 xfs: pass the exact range to initialize to xfs_initialize_perag
    @@ Commit message
         handling.  Also pass the previous agcount so that the range that
         xfs_initialize_perag operates on is exactly defined.  That way the
         extra lookups can be avoided, and error handling can clean up the
         exact range from the old count to the last added perag structure.
     
         Signed-off-by: Christoph Hellwig <hch@lst.de>
    +    Reviewed-by: Brian Foster <bfoster@redhat.com>
         Reviewed-by: Darrick J. Wong <djwong@kernel.org>
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
     
      ## fs/xfs/libxfs/xfs_ag.c ##
     @@ fs/xfs/libxfs/xfs_ag.c: xfs_free_unused_perag_range(
      	}
      }
      
      int
      xfs_initialize_perag(
      	struct xfs_mount	*mp,
     -	xfs_agnumber_t		agcount,
    -+	xfs_agnumber_t		old_agcount,
    ++	xfs_agnumber_t		orig_agcount,
     +	xfs_agnumber_t		new_agcount,
      	xfs_rfsblock_t		dblocks,
      	xfs_agnumber_t		*maxagi)
      {
      	struct xfs_perag	*pag;
      	xfs_agnumber_t		index;
    @@ fs/xfs/libxfs/xfs_ag.c: xfs_free_unused_perag_range(
     -	for (index = 0; index < agcount; index++) {
     -		pag = xfs_perag_get(mp, index);
     -		if (pag) {
     -			xfs_perag_put(pag);
     -			continue;
     -		}
    -+	if (old_agcount >= new_agcount)
    -+		return 0;
    - 
    -+	for (index = old_agcount; index < new_agcount; index++) {
    +-
    ++	for (index = orig_agcount; index < new_agcount; index++) {
      		pag = kzalloc(sizeof(*pag), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
      		if (!pag) {
      			error = -ENOMEM;
      			goto out_unwind_new_pags;
      		}
      		pag->pag_agno = index;
    @@ fs/xfs/libxfs/xfs_ag.c: xfs_initialize_perag(
      	pag = xa_erase(&mp->m_perags, index);
      out_free_pag:
      	kfree(pag);
      out_unwind_new_pags:
     -	/* unwind any prior newly initialized pags */
     -	xfs_free_unused_perag_range(mp, first_initialised, agcount);
    -+	xfs_free_unused_perag_range(mp, old_agcount, index);
    ++	xfs_free_unused_perag_range(mp, orig_agcount, index);
      	return error;
      }
      
      static int
      xfs_get_aghdr_buf(
      	struct xfs_mount	*mp,
    @@ fs/xfs/libxfs/xfs_ag.h: __XFS_AG_OPSTATE(initialised_agi, AGI_INIT)
      __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
      
      void xfs_free_unused_perag_range(struct xfs_mount *mp, xfs_agnumber_t agstart,
      			xfs_agnumber_t agend);
     -int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
     -			xfs_rfsblock_t dcount, xfs_agnumber_t *maxagi);
    -+int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t old_agcount,
    -+		xfs_agnumber_t agcount, xfs_rfsblock_t dcount,
    ++int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t orig_agcount,
    ++		xfs_agnumber_t new_agcount, xfs_rfsblock_t dcount,
     +		xfs_agnumber_t *maxagi);
      int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
      void xfs_free_perag(struct xfs_mount *mp);
      
      /* Passive AG references */
      struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
    @@ fs/xfs/xfs_log_recover.c: xlog_do_recover(
      	xfs_daddr_t		head_blk,
      	xfs_daddr_t		tail_blk)
      {
      	struct xfs_mount	*mp = log->l_mp;
      	struct xfs_buf		*bp = mp->m_sb_bp;
      	struct xfs_sb		*sbp = &mp->m_sb;
    -+	xfs_agnumber_t		old_agcount = sbp->sb_agcount;
    ++	xfs_agnumber_t		orig_agcount = sbp->sb_agcount;
      	int			error;
      
      	trace_xfs_log_recover(log, head_blk, tail_blk);
      
      	/*
      	 * First replay the images in the log.
    @@ fs/xfs/xfs_log_recover.c: xlog_do_recover(
      
      	/* re-initialise in-core superblock and geometry structures */
      	mp->m_features |= xfs_sb_version_to_features(sbp);
      	xfs_reinit_percpu_counters(mp);
     -	error = xfs_initialize_perag(mp, sbp->sb_agcount, sbp->sb_dblocks,
     -			&mp->m_maxagi);
    -+	error = xfs_initialize_perag(mp, old_agcount, sbp->sb_agcount,
    ++	error = xfs_initialize_perag(mp, orig_agcount, sbp->sb_agcount,
     +			sbp->sb_dblocks, &mp->m_maxagi);
      	if (error) {
      		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
      		return error;
      	}
      	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 10:  e5cf520ce916d1 !  14:  903f719d34fcfe xfs: merge the perag freeing helpers
    @@ Commit message
     
         The addition RCU grace period for the error case is harmless, and the
         extra check for the AG to actually exist is not required now that the
         callers pass the exact known allocated range.
     
         Signed-off-by: Christoph Hellwig <hch@lst.de>
    +    Reviewed-by: Brian Foster <bfoster@redhat.com>
         Reviewed-by: Darrick J. Wong <djwong@kernel.org>
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
     
      ## fs/xfs/libxfs/xfs_ag.c ##
     @@ fs/xfs/libxfs/xfs_ag.c: xfs_initialize_perag_data(
      out:
    @@ fs/xfs/libxfs/xfs_ag.c: xfs_agino_range(
     -	}
     -}
     -
      int
      xfs_initialize_perag(
      	struct xfs_mount	*mp,
    - 	xfs_agnumber_t		old_agcount,
    + 	xfs_agnumber_t		orig_agcount,
      	xfs_agnumber_t		new_agcount,
      	xfs_rfsblock_t		dblocks,
     @@ fs/xfs/libxfs/xfs_ag.c: xfs_initialize_perag(
      out_remove_pag:
      	xfs_defer_drain_free(&pag->pag_intents_drain);
      	pag = xa_erase(&mp->m_perags, index);
      out_free_pag:
      	kfree(pag);
      out_unwind_new_pags:
    --	xfs_free_unused_perag_range(mp, old_agcount, index);
    -+	xfs_free_perag_range(mp, old_agcount, index);
    +-	xfs_free_unused_perag_range(mp, orig_agcount, index);
    ++	xfs_free_perag_range(mp, orig_agcount, index);
      	return error;
      }
      
      static int
      xfs_get_aghdr_buf(
      	struct xfs_mount	*mp,
    @@ fs/xfs/libxfs/xfs_ag.h: static inline bool xfs_perag_ ## name (struct xfs_perag
      __XFS_AG_OPSTATE(prefers_metadata, PREFERS_METADATA)
      __XFS_AG_OPSTATE(allows_inodes, ALLOWS_INODES)
      __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
      
     -void xfs_free_unused_perag_range(struct xfs_mount *mp, xfs_agnumber_t agstart,
     -			xfs_agnumber_t agend);
    - int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t old_agcount,
    - 		xfs_agnumber_t agcount, xfs_rfsblock_t dcount,
    + int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t orig_agcount,
    + 		xfs_agnumber_t new_agcount, xfs_rfsblock_t dcount,
      		xfs_agnumber_t *maxagi);
     +void xfs_free_perag_range(struct xfs_mount *mp, xfs_agnumber_t first_agno,
     +		xfs_agnumber_t end_agno);
      int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
     -void xfs_free_perag(struct xfs_mount *mp);
      
  -:  -------------- >  15:  c9931c16fede4f xfs: update the file system geometry after recoverying superblock buffers
  -:  -------------- >  16:  c7fb42924d5cfc xfs: error out when a superblock buffer update reduces the agcount
 11:  0349266727e03d !  17:  4143683597b355 xfs: don't use __GFP_RETRY_MAYFAIL in xfs_initialize_perag
    @@ Commit message
     
         __GFP_RETRY_MAYFAIL increases the likelyhood of allocations to fail,
         which isn't really helpful during log recovery.  Remove the flag and
         stick to the default GFP_KERNEL policies.
     
         Signed-off-by: Christoph Hellwig <hch@lst.de>
    +    Reviewed-by: Brian Foster <bfoster@redhat.com>
         Reviewed-by: Darrick J. Wong <djwong@kernel.org>
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
     
      ## fs/xfs/libxfs/xfs_ag.c ##
     @@ fs/xfs/libxfs/xfs_ag.c: xfs_initialize_perag(
    + {
    + 	struct xfs_perag	*pag;
    + 	xfs_agnumber_t		index;
      	int			error;
      
    - 	if (old_agcount >= new_agcount)
    - 		return 0;
    - 
    - 	for (index = old_agcount; index < new_agcount; index++) {
    + 	for (index = orig_agcount; index < new_agcount; index++) {
     -		pag = kzalloc(sizeof(*pag), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
     +		pag = kzalloc(sizeof(*pag), GFP_KERNEL);
      		if (!pag) {
      			error = -ENOMEM;
      			goto out_unwind_new_pags;
      		}
  -:  -------------- >  18:  df5ec223b6a8f5 xfs: update the pag for the last AG at recovery time
 12:  0076f5edd6dbf4 =  19:  7d7e4a9590f94f xfs: fix superfluous clearing of info->low in __xfs_getfsmap_datadev
 13:  e101a624bdcffa =  20:  03ed56bac848c0 xfs: remove the unused pagb_count field in struct xfs_perag
 14:  9ddb334bc9168e =  21:  5f7962965fd82f xfs: remove the unused pag_active_wq field in struct xfs_perag
 15:  39ef8ab5bda602 =  22:  112d8ffbea014b xfs: pass a pag to xfs_difree_inode_chunk
 16:  6f9cab0448e0cf =  23:  1dc56026bdc727 xfs: remove the agno argument to xfs_free_ag_extent
 17:  379cc2a546b9d2 !  24:  67afe45793efd2 xfs: add xfs_agbno_to_fsb and xfs_agbno_to_daddr helpers
    @@ fs/xfs/scrub/ialloc_repair.c: xrep_ibt_build_new_trees(
      	 * The new inode btrees will not be rooted in the AGI until we've
      	 * successfully rebuilt the tree.
      	 *
      	 * Start by setting up the inobt staging cursor.
      	 */
     -	fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno,
    --			XFS_IBT_BLOCK(sc->mp)),
    +-			XFS_IBT_BLOCK(sc->mp));
     -	xrep_newbt_init_ag(&ri->new_inobt, sc, &XFS_RMAP_OINFO_INOBT, fsbno,
     +	xrep_newbt_init_ag(&ri->new_inobt, sc, &XFS_RMAP_OINFO_INOBT,
     +			xfs_agbno_to_fsb(sc->sa.pag, XFS_IBT_BLOCK(sc->mp)),
      			XFS_AG_RESV_NONE);
      	ri->new_inobt.bload.claim_block = xrep_ibt_claim_block;
      	ri->new_inobt.bload.get_records = xrep_ibt_get_records;
    @@ fs/xfs/scrub/ialloc_repair.c: xrep_ibt_build_new_trees(
      		enum xfs_ag_resv_type	resv = XFS_AG_RESV_METADATA;
      
      		if (sc->mp->m_finobt_nores)
      			resv = XFS_AG_RESV_NONE;
      
     -		fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno,
    --				XFS_FIBT_BLOCK(sc->mp)),
    +-				XFS_FIBT_BLOCK(sc->mp));
      		xrep_newbt_init_ag(&ri->new_finobt, sc, &XFS_RMAP_OINFO_INOBT,
     -				fsbno, resv);
    -+			xfs_agbno_to_fsb(sc->sa.pag, XFS_FIBT_BLOCK(sc->mp)),
    -+			resv);
    ++				xfs_agbno_to_fsb(sc->sa.pag, XFS_FIBT_BLOCK(sc->mp)),
    ++				resv);
      		ri->new_finobt.bload.claim_block = xrep_fibt_claim_block;
      		ri->new_finobt.bload.get_records = xrep_fibt_get_records;
      
      		fino_cur = xfs_finobt_init_cursor(sc->sa.pag, NULL, NULL);
      		xfs_btree_stage_afakeroot(fino_cur, &ri->new_finobt.afake);
      		error = xfs_btree_bload_compute_geometry(fino_cur,
 18:  7f79f3a470b1c8 =  25:  45b711347cd854 xfs: add a xfs_agino_to_ino helper
 19:  cba50fae677281 =  26:  e69ef1135e5f28 xfs: pass a pag to xfs_extent_busy_{search,reuse}
 20:  024a6cabdb7ae9 =  27:  adf597075a89ae xfs: keep a reference to the pag for busy extents
 21:  32b52162c3dba6 =  28:  fba0e0c60817cb xfs: remove the mount field from struct xfs_busy_extents
 22:  773ec84322d5c2 =  29:  b92717396fc8e8 xfs: remove the unused trace_xfs_iwalk_ag trace point
 23:  052c49303528c7 =  30:  aad90eaedf5ffd xfs: remove the unused xrep_bmap_walk_rmap trace point
 24:  2a93defe3e2d4b =  31:  bcb61b3cda6344 xfs: constify pag arguments to trace points
 25:  b9e27be607b68a =  32:  d0a0824866c484 xfs: pass a perag structure to the xfs_ag_resv_init_error trace point
 26:  2f14d1eb49b8ef =  33:  8e04749eca5893 xfs: pass objects to the xfs_irec_merge_{pre,post} trace points
 27:  af30fa0e5c047f =  34:  6e43d6b40a0f52 xfs: pass the iunlink item to the xfs_iunlink_update_dinode trace point
 28:  b8506105ff71df =  35:  98942f731d99bb xfs: pass objects to the xrep_ibt_walk_rmap tracepoint
 29:  47dac51dacfc22 =  36:  94439374029288 xfs: pass the pag to the trace_xrep_calc_ag_resblks{,_btsize} trace points
 30:  1989b3c9d0b740 =  37:  bbfa12a606550d xfs: pass the pag to the xrep_newbt_extent_class tracepoints
 31:  80100167c4ad7d =  38:  a2aa3ff20dea67 xfs: convert remaining trace points to pass pag structures
 32:  cf64fd0eee77f9 !  39:  2848367eebf34b xfs: split xfs_initialize_perag
    @@ Commit message
     
         Signed-off-by: Christoph Hellwig <hch@lst.de>
         Reviewed-by: Darrick J. Wong <djwong@kernel.org>
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
     
      ## fs/xfs/libxfs/xfs_ag.c ##
    -@@ fs/xfs/libxfs/xfs_ag.c: xfs_agino_range(
    - 	xfs_agino_t		*first,
    - 	xfs_agino_t		*last)
    - {
    - 	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
    +@@ fs/xfs/libxfs/xfs_ag.c: xfs_update_last_ag_size(
    + 	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
    + 			&pag->agino_max);
    + 	xfs_perag_rele(pag);
    + 	return 0;
      }
      
     +static int
     +xfs_perag_alloc(
     +	struct xfs_mount	*mp,
     +	xfs_agnumber_t		index,
    @@ fs/xfs/libxfs/xfs_ag.c: xfs_agino_range(
     +	return error;
     +}
     +
      int
      xfs_initialize_perag(
      	struct xfs_mount	*mp,
    - 	xfs_agnumber_t		old_agcount,
    + 	xfs_agnumber_t		orig_agcount,
      	xfs_agnumber_t		new_agcount,
      	xfs_rfsblock_t		dblocks,
      	xfs_agnumber_t		*maxagi)
      {
     -	struct xfs_perag	*pag;
      	xfs_agnumber_t		index;
      	int			error;
      
    - 	if (old_agcount >= new_agcount)
    - 		return 0;
    - 
    - 	for (index = old_agcount; index < new_agcount; index++) {
    ++	if (orig_agcount >= new_agcount)
    ++		return 0;
    ++
    + 	for (index = orig_agcount; index < new_agcount; index++) {
     -		pag = kzalloc(sizeof(*pag), GFP_KERNEL);
     -		if (!pag) {
     -			error = -ENOMEM;
     +		error = xfs_perag_alloc(mp, index, new_agcount, dblocks);
     +		if (error)
      			goto out_unwind_new_pags;
    @@ fs/xfs/libxfs/xfs_ag.c: xfs_agino_range(
     -out_remove_pag:
     -	xfs_defer_drain_free(&pag->pag_intents_drain);
     -	pag = xa_erase(&mp->m_perags, index);
     -out_free_pag:
     -	kfree(pag);
      out_unwind_new_pags:
    - 	xfs_free_perag_range(mp, old_agcount, index);
    + 	xfs_free_perag_range(mp, orig_agcount, index);
      	return error;
      }
      
      static int
 33:  abe5d7df4d8e52 =  40:  4fae8e0d673593 xfs: insert the pag structures into the xarray later
 34:  03d0d8d582654e =  41:  c39d2725f56314 xfs: factor out a xfs_iwalk_args helper
 35:  fe82aa3af514ef !  42:  3a59f17f6915c5 xfs: factor out a generic xfs_group structure
    @@ Commit message
         Note that he xg_type field will only need a single bit even with
         realtime group support.  For now it fills a hole, but it might be
         worth to fold it into another field if we can use this space better.
     
         Signed-off-by: Christoph Hellwig <hch@lst.de>
         Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    -    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
     
      ## fs/xfs/Makefile ##
     @@ fs/xfs/Makefile: obj-$(CONFIG_XFS_FS)		+= xfs.o
      
      # this one should be compiled first, as the tracing macros can easily blow up
    @@ fs/xfs/libxfs/xfs_ag.c: xfs_perag_alloc(
     -	/* Active ref owned by mount indicates AG is online. */
     -	atomic_set(&pag->pag_active_ref, 1);
     -
     -	error = xa_insert(&mp->m_perags, index, pag, GFP_KERNEL);
     -	if (error) {
     -		WARN_ON_ONCE(error == -EBUSY);
    -+	error = xfs_group_insert(mp, &pag->pag_group, index, XG_TYPE_AG);
    ++	error = xfs_group_insert(mp, pag_group(pag), index, XG_TYPE_AG);
     +	if (error)
      		goto out_buf_cache_destroy;
     -	}
      
      	return 0;
      
    @@ fs/xfs/libxfs/xfs_ag.h: struct xfs_perag {
      
     +static inline struct xfs_perag *to_perag(struct xfs_group *xg)
     +{
     +	return container_of(xg, struct xfs_perag, pag_group);
     +}
     +
    ++static inline struct xfs_group *pag_group(struct xfs_perag *pag)
    ++{
    ++	return &pag->pag_group;
    ++}
    ++
     +static inline struct xfs_mount *pag_mount(const struct xfs_perag *pag)
     +{
     +	return pag->pag_group.xg_mount;
     +}
     +
     +static inline xfs_agnumber_t pag_agno(const struct xfs_perag *pag)
     +{
    -+	return pag->pag_group.xg_index;
    ++	return pag->pag_group.xg_gno;
     +}
     +
      /*
       * Per-AG operational state. These are atomic flag bits.
       */
      #define XFS_AGSTATE_AGF_INIT		0
      #define XFS_AGSTATE_AGI_INIT		1
      #define XFS_AGSTATE_PREFERS_METADATA	2
    -@@ fs/xfs/libxfs/xfs_ag.h: int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t old_agcount,
    - 		xfs_agnumber_t *maxagi);
    +@@ fs/xfs/libxfs/xfs_ag.h: int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t orig_agcount,
      void xfs_free_perag_range(struct xfs_mount *mp, xfs_agnumber_t first_agno,
      		xfs_agnumber_t end_agno);
      int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
    + int xfs_update_last_ag_size(struct xfs_mount *mp, xfs_agnumber_t prev_agcount);
      
      /* Passive AG references */
     -struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
     -struct xfs_perag *xfs_perag_hold(struct xfs_perag *pag);
     -void xfs_perag_put(struct xfs_perag *pag);
     +static inline struct xfs_perag *
    @@ fs/xfs/libxfs/xfs_ag.h: int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnum
     +}
     +
     +static inline struct xfs_perag *
     +xfs_perag_hold(
     +	struct xfs_perag	*pag)
     +{
    -+	return to_perag(xfs_group_hold(&pag->pag_group));
    ++	return to_perag(xfs_group_hold(pag_group(pag)));
     +}
     +
     +static inline void
     +xfs_perag_put(
     +	struct xfs_perag	*pag)
     +{
    -+	xfs_group_put(&pag->pag_group);
    ++	xfs_group_put(pag_group(pag));
     +}
      
      /* Active AG references */
     -struct xfs_perag *xfs_perag_grab(struct xfs_mount *, xfs_agnumber_t);
     -void xfs_perag_rele(struct xfs_perag *pag);
     +static inline struct xfs_perag *
    @@ fs/xfs/libxfs/xfs_ag.h: int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnum
     +}
     +
     +static inline void
     +xfs_perag_rele(
     +	struct xfs_perag	*pag)
     +{
    -+	xfs_group_rele(&pag->pag_group);
    ++	xfs_group_rele(pag_group(pag));
     +}
      
      /*
       * Per-ag geometry infomation and validation
       */
      xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
    @@ fs/xfs/libxfs/xfs_ag.h: xfs_ag_contains_log(struct xfs_mount *mp, xfs_agnumber_t
      	xfs_agnumber_t		end_agno)
      {
     -	struct xfs_mount	*mp = pag->pag_mount;
     +	struct xfs_mount	*mp = pag_mount(pag);
      
     -	*agno = pag->pag_agno + 1;
    -+	*agno = pag->pag_group.xg_index + 1;
    ++	*agno = pag_agno(pag) + 1;
      	xfs_perag_rele(pag);
      	while (*agno <= end_agno) {
      		pag = xfs_perag_grab(mp, *agno);
      		if (pag)
      			return pag;
      		(*agno)++;
    @@ fs/xfs/libxfs/xfs_ag.h: xfs_perag_next_wrap(
      	xfs_agnumber_t		wrap_agno)
      {
     -	struct xfs_mount	*mp = pag->pag_mount;
     +	struct xfs_mount	*mp = pag_mount(pag);
      
     -	*agno = pag->pag_agno + 1;
    -+	*agno = pag->pag_group.xg_index + 1;
    ++	*agno = pag_agno(pag) + 1;
      	xfs_perag_rele(pag);
      	while (*agno != stop_agno) {
      		if (*agno >= wrap_agno) {
      			if (restart_agno >= stop_agno)
      				break;
      			*agno = restart_agno;
    @@ fs/xfs/libxfs/xfs_group.c (new)
     +	xa_mark_t		mark,
     +	enum xfs_group_type	type)
     +{
     +	unsigned long		index = 0;
     +
     +	if (xg) {
    -+		index = xg->xg_index + 1;
    ++		index = xg->xg_gno + 1;
     +		xfs_group_rele(xg);
     +	}
     +
     +	rcu_read_lock();
     +	xg = xa_find(&mp->m_groups[type].xa, &index, ULONG_MAX, mark);
     +	if (xg) {
    @@ fs/xfs/libxfs/xfs_group.c (new)
     +	uint32_t		index,
     +	enum xfs_group_type	type)
     +{
     +	int			error;
     +
     +	xg->xg_mount = mp;
    -+	xg->xg_index = index;
    ++	xg->xg_gno = index;
     +	xg->xg_type = type;
     +
     +	/* Active ref owned by mount indicates group is online. */
     +	atomic_set(&xg->xg_active_ref, 1);
     +
     +	error = xa_insert(&mp->m_groups[type].xa, index, xg, GFP_KERNEL);
    @@ fs/xfs/libxfs/xfs_group.h (new)
     + */
     +#ifndef __LIBXFS_GROUP_H
     +#define __LIBXFS_GROUP_H 1
     +
     +struct xfs_group {
     +	struct xfs_mount	*xg_mount;
    -+	uint32_t		xg_index;
    ++	uint32_t		xg_gno;
     +	enum xfs_group_type	xg_type;
     +	atomic_t		xg_ref;		/* passive reference count */
     +	atomic_t		xg_active_ref;	/* active reference count */
     +};
     +
     +struct xfs_group *xfs_group_get(struct xfs_mount *mp, uint32_t index,
    @@ fs/xfs/libxfs/xfs_group.h (new)
     +		enum xfs_group_type type, void (*uninit)(struct xfs_group *xg));
     +int xfs_group_insert(struct xfs_mount *mp, struct xfs_group *xg,
     +		uint32_t index, enum xfs_group_type);
     +
     +#define xfs_group_set_mark(_xg, _mark) \
     +	xa_set_mark(&(_xg)->xg_mount->m_groups[(_xg)->xg_type].xa, \
    -+			(_xg)->xg_index, (_mark))
    ++			(_xg)->xg_gno, (_mark))
     +#define xfs_group_clear_mark(_xg, _mark) \
     +	xa_clear_mark(&(_xg)->xg_mount->m_groups[(_xg)->xg_type].xa, \
    -+			(_xg)->xg_index, (_mark))
    ++			(_xg)->xg_gno, (_mark))
     +#define xfs_group_marked(_mp, _type, _mark) \
     +	xa_marked(&(_mp)->m_groups[(_type)].xa, (_mark))
     +
     +#endif /* __LIBXFS_GROUP_H */
     
      ## fs/xfs/libxfs/xfs_ialloc.c ##
    @@ fs/xfs/xfs_filestream.c: xfs_filestream_pick_ag(
      		/* Keep track of the AG with the most free blocks. */
      		if (pag->pagf_freeblks > maxfree) {
      			maxfree = pag->pagf_freeblks;
      			if (max_pag)
      				xfs_perag_rele(max_pag);
     -			atomic_inc(&pag->pag_active_ref);
    -+			atomic_inc(&pag->pag_group.xg_active_ref);
    ++			atomic_inc(&pag_group(pag)->xg_active_ref);
      			max_pag = pag;
      		}
      
      		/*
      		 * The AG reference count does two things: it enforces mutual
      		 * exclusion when examining the suitability of an AG in this
    @@ fs/xfs/xfs_filestream.c: xfs_filestream_lookup_association(
      	 * the mru item cannot go away. This means we'll pin the perag with
      	 * the reference we get here even if the filestreams association is torn
      	 * down immediately after we mark the lookup as done.
      	 */
      	pag = container_of(mru, struct xfs_fstrm_item, mru)->pag;
     -	atomic_inc(&pag->pag_active_ref);
    -+	atomic_inc(&pag->pag_group.xg_active_ref);
    ++	atomic_inc(&pag_group(pag)->xg_active_ref);
      	xfs_mru_cache_done(mp->m_filestream);
      
      	trace_xfs_filestream_lookup(pag, ap->ip->i_ino);
      
      	ap->blkno = xfs_agbno_to_fsb(pag, 0);
      	xfs_bmap_adjacent(ap);
    @@ fs/xfs/xfs_filestream.c: xfs_filestream_create_association(
      	 */
      	item = kmalloc(sizeof(*item), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
      	if (!item)
      		goto out_put_fstrms;
      
     -	atomic_inc(&args->pag->pag_active_ref);
    -+	atomic_inc(&args->pag->pag_group.xg_active_ref);
    ++	atomic_inc(&pag_group(args->pag)->xg_active_ref);
      	item->pag = args->pag;
      	error = xfs_mru_cache_insert(mp->m_filestream, pino, &item->mru);
      	if (error)
      		goto out_free_item;
      	return 0;
      
    @@ fs/xfs/xfs_icache.c: xfs_perag_set_inode_tag(
      	if (was_tagged)
      		return;
      
     -	/* propagate the tag up into the perag radix tree */
     -	xa_set_mark(&mp->m_perags, pag->pag_agno, ici_tag_to_mark(tag));
     +	/* propagate the tag up into the pag xarray tree */
    -+	xfs_group_set_mark(&pag->pag_group, ici_tag_to_mark(tag));
    ++	xfs_group_set_mark(pag_group(pag), ici_tag_to_mark(tag));
      
      	/* start background work */
      	switch (tag) {
      	case XFS_ICI_RECLAIM_TAG:
     -		xfs_reclaim_work_queue(mp);
     +		xfs_reclaim_work_queue(pag_mount(pag));
    @@ fs/xfs/xfs_icache.c: xfs_perag_clear_inode_tag(
      		return;
      
     -	/* clear the tag from the perag radix tree */
     -	xa_clear_mark(&mp->m_perags, pag->pag_agno, ici_tag_to_mark(tag));
     -
     +	/* clear the tag from the pag xarray */
    -+	xfs_group_clear_mark(&pag->pag_group, ici_tag_to_mark(tag));
    ++	xfs_group_clear_mark(pag_group(pag), ici_tag_to_mark(tag));
      	trace_xfs_perag_clear_inode_tag(pag, _RET_IP_);
      }
      
      /*
       * Find the next AG after @pag, or the first AG if @pag is NULL.
       */
    @@ fs/xfs/xfs_icache.c: xfs_perag_clear_inode_tag(
     -		if (!atomic_inc_not_zero(&pag->pag_active_ref))
     -			pag = NULL;
     -	}
     -	rcu_read_unlock();
     -	return pag;
     +	return to_perag(xfs_group_grab_next_mark(mp,
    -+			pag ? &pag->pag_group : NULL,
    ++			pag ? pag_group(pag) : NULL,
     +			ici_tag_to_mark(tag), XG_TYPE_AG));
      }
      
      /*
       * When we recycle a reclaimable inode, we need to re-initialise the VFS inode
       * part of the structure. This is made more complex by the fact we store
    @@ fs/xfs/xfs_super.c: static const struct fs_context_operations xfs_context_ops =
      	mp->m_kobj.kobject.kset = xfs_kset;
      	/*
      	 * We don't create the finobt per-ag space reservation until after log
     
      ## fs/xfs/xfs_trace.c ##
     @@
    -  * Copyright (c) 2009, Christoph Hellwig
    -  * All Rights Reserved.
    -  */
    - #include "xfs.h"
    - #include "xfs_fs.h"
      #include "xfs_shared.h"
    -+#include "xfs_group.h"
      #include "xfs_bit.h"
      #include "xfs_format.h"
      #include "xfs_log_format.h"
      #include "xfs_trans_resv.h"
      #include "xfs_mount.h"
    ++#include "xfs_group.h"
      #include "xfs_defer.h"
    + #include "xfs_da_format.h"
    + #include "xfs_inode.h"
    + #include "xfs_btree.h"
    + #include "xfs_da_btree.h"
    + #include "xfs_alloc.h"
     
      ## fs/xfs/xfs_trace.h ##
     @@ fs/xfs/xfs_trace.h: struct xfs_buf_log_format;
      struct xfs_inode_log_format;
      struct xfs_bmbt_irec;
      struct xfs_btree_cur;
    @@ fs/xfs/xfs_trace.h: DECLARE_EVENT_CLASS(xfs_perag_class,
     +		__field(int, active_refcount)
     +		__field(unsigned long, caller_ip)
     +	),
     +	TP_fast_assign(
     +		__entry->dev = xg->xg_mount->m_super->s_dev;
     +		__entry->type = xg->xg_type;
    -+		__entry->agno = xg->xg_index;
    ++		__entry->agno = xg->xg_gno;
     +		__entry->refcount = atomic_read(&xg->xg_ref);
     +		__entry->active_refcount = atomic_read(&xg->xg_active_ref);
     +		__entry->caller_ip = caller_ip;
     +	),
     +	TP_printk("dev %d:%d %sno 0x%x passive refs %d active refs %d caller %pS",
     +		  MAJOR(__entry->dev), MINOR(__entry->dev),
 36:  2d7c661b35621b !  43:  6b8f92f02ee378 xfs: add a xfs_group_next_range helper
    @@ fs/xfs/libxfs/xfs_group.c: xfs_group_grab(
     +	uint32_t		end_index,
     +	enum xfs_group_type	type)
     +{
     +	uint32_t		index = start_index;
     +
     +	if (xg) {
    -+		index = xg->xg_index + 1;
    ++		index = xg->xg_gno + 1;
     +		xfs_group_rele(xg);
     +	}
     +	if (index > end_index)
     +		return NULL;
     +	return xfs_group_grab(mp, index, type);
     +}
 37:  c04a7fc3f6a1ce !  44:  c32cc407ae171f xfs: switch perag iteration from the for_each macros to a while based iterator
    @@ Commit message
     
      ## fs/xfs/libxfs/xfs_ag.h ##
     @@ fs/xfs/libxfs/xfs_ag.h: static inline void
      xfs_perag_rele(
      	struct xfs_perag	*pag)
      {
    - 	xfs_group_rele(&pag->pag_group);
    + 	xfs_group_rele(pag_group(pag));
      }
      
     +static inline struct xfs_perag *
     +xfs_perag_next_range(
     +	struct xfs_mount	*mp,
     +	struct xfs_perag	*pag,
     +	xfs_agnumber_t		start_agno,
     +	xfs_agnumber_t		end_agno)
     +{
    -+	return to_perag(xfs_group_next_range(mp, pag ? &pag->pag_group : NULL,
    ++	return to_perag(xfs_group_next_range(mp, pag ? pag_group(pag) : NULL,
     +			start_agno, end_agno, XG_TYPE_AG));
     +}
     +
     +static inline struct xfs_perag *
     +xfs_perag_next_from(
     +	struct xfs_mount	*mp,
    @@ fs/xfs/libxfs/xfs_ag.h: static inline bool
     -	struct xfs_perag	*pag,
     -	xfs_agnumber_t		*agno,
     -	xfs_agnumber_t		end_agno)
     -{
     -	struct xfs_mount	*mp = pag_mount(pag);
     -
    --	*agno = pag->pag_group.xg_index + 1;
    +-	*agno = pag_agno(pag) + 1;
     -	xfs_perag_rele(pag);
     -	while (*agno <= end_agno) {
     -		pag = xfs_perag_grab(mp, *agno);
     -		if (pag)
     -			return pag;
     -		(*agno)++;
 38:  6de1ab692f1f99 !  45:  9d40fa901cd361 xfs: move metadata health tracking to the generic group structure
    @@ fs/xfs/libxfs/xfs_ag.h: struct xfs_perag {
     
      ## fs/xfs/libxfs/xfs_group.c ##
     @@ fs/xfs/libxfs/xfs_group.c: xfs_group_insert(
      	int			error;
      
      	xg->xg_mount = mp;
    - 	xg->xg_index = index;
    + 	xg->xg_gno = index;
      	xg->xg_type = type;
      
     +#ifdef __KERNEL__
     +	spin_lock_init(&xg->xg_state_lock);
     +#endif
     +
    @@ fs/xfs/libxfs/xfs_group.c: xfs_group_insert(
      		WARN_ON_ONCE(error == -EBUSY);
     
      ## fs/xfs/libxfs/xfs_group.h ##
     @@
      struct xfs_group {
      	struct xfs_mount	*xg_mount;
    - 	uint32_t		xg_index;
    + 	uint32_t		xg_gno;
      	enum xfs_group_type	xg_type;
      	atomic_t		xg_ref;		/* passive reference count */
      	atomic_t		xg_active_ref;	/* active reference count */
     +
     +#ifdef __KERNEL__
     +	/* -- kernel only structures below this line -- */
    @@ fs/xfs/libxfs/xfs_health.h: void xfs_rt_mark_corrupt(struct xfs_mount *mp, unsig
     -void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
     -void xfs_ag_mark_corrupt(struct xfs_perag *pag, unsigned int mask);
     -void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
     -void xfs_ag_measure_sickness(struct xfs_perag *pag, unsigned int *sick,
     +void xfs_group_mark_sick(struct xfs_group *xg, unsigned int mask);
     +#define xfs_ag_mark_sick(pag, mask) \
    -+	xfs_group_mark_sick(&(pag)->pag_group, (mask))
    ++	xfs_group_mark_sick(pag_group(pag), (mask))
     +void xfs_group_mark_corrupt(struct xfs_group *xg, unsigned int mask);
     +void xfs_group_mark_healthy(struct xfs_group *xg, unsigned int mask);
     +void xfs_group_measure_sickness(struct xfs_group *xg, unsigned int *sick,
      		unsigned int *checked);
      
      void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask);
    @@ fs/xfs/libxfs/xfs_health.h: xfs_fs_has_sickness(struct xfs_mount *mp, unsigned i
     -
     -	xfs_ag_measure_sickness(pag, &sick, &checked);
     +	xfs_group_measure_sickness(xg, &sick, &checked);
      	return sick & mask;
      }
     +#define xfs_ag_has_sickness(pag, mask) \
    -+	xfs_group_has_sickness(&(pag)->pag_group, (mask))
    ++	xfs_group_has_sickness(pag_group(pag), (mask))
     +#define xfs_ag_is_healthy(pag) \
     +	(!xfs_ag_has_sickness((pag), UINT_MAX))
      
      static inline bool
      xfs_inode_has_sickness(struct xfs_inode *ip, unsigned int mask)
      {
    @@ fs/xfs/scrub/health.c: xchk_mark_all_healthy(
      	struct xfs_perag	*pag = NULL;
      
      	xfs_fs_mark_healthy(mp, XFS_SICK_FS_INDIRECT);
      	xfs_rt_mark_healthy(mp, XFS_SICK_RT_INDIRECT);
      	while ((pag = xfs_perag_next(mp, pag)))
     -		xfs_ag_mark_healthy(pag, XFS_SICK_AG_INDIRECT);
    -+		xfs_group_mark_healthy(&pag->pag_group, XFS_SICK_AG_INDIRECT);
    ++		xfs_group_mark_healthy(pag_group(pag), XFS_SICK_AG_INDIRECT);
      }
      
      /*
       * Update filesystem health assessments based on what we found and did.
       *
       * If the scrubber finds errors, we mark sick whatever's mentioned in
    @@ fs/xfs/scrub/health.c: xchk_update_health(
      				   XFS_SCRUB_OFLAG_XCORRUPT));
      	switch (type_to_health_flag[sc->sm->sm_type].group) {
      	case XHG_AG:
      		pag = xfs_perag_get(sc->mp, sc->sm->sm_agno);
      		if (bad)
     -			xfs_ag_mark_corrupt(pag, sc->sick_mask);
    -+			xfs_group_mark_corrupt(&pag->pag_group, sc->sick_mask);
    ++			xfs_group_mark_corrupt(pag_group(pag), sc->sick_mask);
      		else
     -			xfs_ag_mark_healthy(pag, sc->sick_mask);
    -+			xfs_group_mark_healthy(&pag->pag_group, sc->sick_mask);
    ++			xfs_group_mark_healthy(pag_group(pag), sc->sick_mask);
      		xfs_perag_put(pag);
      		break;
      	case XHG_INO:
      		if (!sc->ip)
      			return;
      		if (bad) {
    @@ fs/xfs/scrub/health.c: xchk_health_record(
      	xfs_rt_measure_sickness(mp, &sick, &checked);
      	if (sick & XFS_SICK_RT_PRIMARY)
      		xchk_set_corrupt(sc);
      
      	while ((pag = xfs_perag_next(mp, pag))) {
     -		xfs_ag_measure_sickness(pag, &sick, &checked);
    -+		xfs_group_measure_sickness(&pag->pag_group, &sick, &checked);
    ++		xfs_group_measure_sickness(pag_group(pag), &sick, &checked);
      		if (sick & XFS_SICK_AG_PRIMARY)
      			xchk_set_corrupt(sc);
      	}
      
      	return 0;
      }
    @@ fs/xfs/xfs_health.c: xfs_health_unmount(
      	if (xfs_is_shutdown(mp))
      		return;
      
      	/* Measure AG corruption levels. */
      	while ((pag = xfs_perag_next(mp, pag))) {
     -		xfs_ag_measure_sickness(pag, &sick, &checked);
    -+		xfs_group_measure_sickness(&pag->pag_group, &sick, &checked);
    ++		xfs_group_measure_sickness(pag_group(pag), &sick, &checked);
      		if (sick) {
     -			trace_xfs_ag_unfixed_corruption(pag, sick);
    -+			trace_xfs_group_unfixed_corruption(&pag->pag_group,
    ++			trace_xfs_group_unfixed_corruption(pag_group(pag),
     +					sick);
      			warn = true;
      		}
      	}
      
      	/* Measure realtime volume corruption levels. */
    @@ fs/xfs/xfs_health.c: xfs_ag_geom_health(
      	unsigned int			checked;
      
      	ageo->ag_sick = 0;
      	ageo->ag_checked = 0;
      
     -	xfs_ag_measure_sickness(pag, &sick, &checked);
    -+	xfs_group_measure_sickness(&pag->pag_group, &sick, &checked);
    ++	xfs_group_measure_sickness(pag_group(pag), &sick, &checked);
      	for (m = ag_map; m->sick_mask; m++) {
      		if (checked & m->sick_mask)
      			ageo->ag_checked |= m->ioctl_mask;
      		if (sick & m->sick_mask)
      			ageo->ag_sick |= m->ioctl_mask;
      	}
    @@ fs/xfs/xfs_trace.h: DEFINE_FS_CORRUPT_EVENT(xfs_fs_mark_healthy);
      	),
      	TP_fast_assign(
     -		__entry->dev = pag_mount(pag)->m_super->s_dev;
     -		__entry->agno = pag_agno(pag);
     +		__entry->dev = xg->xg_mount->m_super->s_dev;
     +		__entry->type = xg->xg_type;
    -+		__entry->index = xg->xg_index;
    ++		__entry->index = xg->xg_gno;
      		__entry->flags = flags;
      	),
     -	TP_printk("dev %d:%d agno 0x%x flags 0x%x",
     +	TP_printk("dev %d:%d %sno 0x%x flags 0x%x",
      		  MAJOR(__entry->dev), MINOR(__entry->dev),
     -		  __entry->agno, __entry->flags)
 39:  977d8de9239985 =  46:  c3192a35249c19 xfs: mark xfs_perag_intent_{hold,rele} static
 40:  c0fe3d922daf2f !  47:  959fd5f1d210aa xfs: move draining of deferred operations to the generic group structure
    @@ fs/xfs/libxfs/xfs_group.c: xfs_group_free(
      		uninit(xg);
      
      	/* drop the mount's active reference */
      	xfs_group_rele(xg);
      	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_active_ref) != 0);
     @@ fs/xfs/libxfs/xfs_group.c: xfs_group_insert(
    - 	xg->xg_index = index;
    + 	xg->xg_gno = index;
      	xg->xg_type = type;
      
      #ifdef __KERNEL__
      	spin_lock_init(&xg->xg_state_lock);
      #endif
     +	xfs_defer_drain_init(&xg->xg_intents_drain);
    @@ fs/xfs/scrub/common.c: xchk_perag_drain_and_lock(
      		 * updates.
      		 *
      		 * Obviously, this should be slanted against scrub and in favor
      		 * of runtime threads.
      		 */
     -		if (!xfs_perag_intent_busy(sa->pag))
    -+		if (!xfs_group_intent_busy(&sa->pag->pag_group))
    ++		if (!xfs_group_intent_busy(pag_group(sa->pag)))
      			return 0;
      
      		if (sa->agf_bp) {
      			xfs_trans_brelse(sc->tp, sa->agf_bp);
      			sa->agf_bp = NULL;
      		}
    @@ fs/xfs/scrub/common.c: xchk_perag_drain_and_lock(
      			sa->agi_bp = NULL;
      		}
      
      		if (!(sc->flags & XCHK_FSGATES_DRAIN))
      			return -ECHRNG;
     -		error = xfs_perag_intent_drain(sa->pag);
    -+		error = xfs_group_intent_drain(&sa->pag->pag_group);
    ++		error = xfs_group_intent_drain(pag_group(sa->pag));
      		if (error == -ERESTARTSYS)
      			error = -EINTR;
      	} while (!error);
      
      	return error;
      }
    @@ fs/xfs/xfs_drain.c: xfs_perag_intent_get(
      
      	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, fsbno));
      	if (!pag)
      		return NULL;
      
     -	xfs_perag_intent_hold(pag);
    -+	xfs_group_intent_hold(&pag->pag_group);
    ++	xfs_group_intent_hold(pag_group(pag));
      	return pag;
      }
      
      /*
       * Release our intent to update this AG's metadata, and then release our
       * passive ref to the AG.
       */
      void
      xfs_perag_intent_put(
      	struct xfs_perag	*pag)
      {
     -	xfs_perag_intent_rele(pag);
    -+	xfs_group_intent_rele(&pag->pag_group);
    ++	xfs_group_intent_rele(pag_group(pag));
      	xfs_perag_put(pag);
      }
      
      /*
       * Wait for the intent update count for this AG to hit zero.
       * Callers must not hold any AG header buffers.
    @@ fs/xfs/xfs_trace.h: TRACE_EVENT(xfs_force_shutdown,
      	TP_fast_assign(
     -		__entry->dev = pag_mount(pag)->m_super->s_dev;
     -		__entry->agno = pag_agno(pag);
     -		__entry->nr_intents = atomic_read(&pag->pag_intents_drain.dr_count);
     +		__entry->dev = xg->xg_mount->m_super->s_dev;
     +		__entry->type = xg->xg_type;
    -+		__entry->index = xg->xg_index;
    ++		__entry->index = xg->xg_gno;
     +		__entry->nr_intents =
     +			atomic_read(&xg->xg_intents_drain.dr_count);
      		__entry->caller_ip = caller_ip;
      	),
     -	TP_printk("dev %d:%d agno 0x%x intents %ld caller %pS",
     +	TP_printk("dev %d:%d %sno 0x%x intents %ld caller %pS",
 41:  7880ee1ed7d1cf !  48:  eb9bfdd5af203e xfs: move the online repair rmap hooks to the generic group structure
    @@ fs/xfs/libxfs/xfs_ag.h: struct xfs_perag {
      {
      	return container_of(xg, struct xfs_perag, pag_group);
     
      ## fs/xfs/libxfs/xfs_group.c ##
     @@ fs/xfs/libxfs/xfs_group.c: xfs_group_insert(
      	xg->xg_mount = mp;
    - 	xg->xg_index = index;
    + 	xg->xg_gno = index;
      	xg->xg_type = type;
      
      #ifdef __KERNEL__
      	spin_lock_init(&xg->xg_state_lock);
     +	xfs_hooks_init(&xg->xg_rmap_update_hooks);
      #endif
    @@ fs/xfs/libxfs/xfs_rmap.c: xfs_rmap_free(
      
      	if (!xfs_has_rmapbt(mp))
      		return 0;
      
      	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
     -	xfs_rmap_update_hook(tp, pag, XFS_RMAP_UNMAP, bno, len, false, oinfo);
    -+	xfs_rmap_update_hook(tp, &pag->pag_group, XFS_RMAP_UNMAP, bno, len,
    ++	xfs_rmap_update_hook(tp, pag_group(pag), XFS_RMAP_UNMAP, bno, len,
     +			false, oinfo);
      	error = xfs_rmap_unmap(cur, bno, len, false, oinfo);
      
      	xfs_btree_del_cursor(cur, error);
      	return error;
      }
    @@ fs/xfs/libxfs/xfs_rmap.c: xfs_rmap_alloc(
      
      	if (!xfs_has_rmapbt(mp))
      		return 0;
      
      	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
     -	xfs_rmap_update_hook(tp, pag, XFS_RMAP_MAP, bno, len, false, oinfo);
    -+	xfs_rmap_update_hook(tp, &pag->pag_group, XFS_RMAP_MAP, bno, len, false,
    ++	xfs_rmap_update_hook(tp, pag_group(pag), XFS_RMAP_MAP, bno, len, false,
     +			oinfo);
      	error = xfs_rmap_map(cur, bno, len, false, oinfo);
      
      	xfs_btree_del_cursor(cur, error);
      	return error;
      }
    @@ fs/xfs/libxfs/xfs_rmap.c: xfs_rmap_finish_one(
      	error = __xfs_rmap_finish_intent(rcur, ri->ri_type, bno,
      			ri->ri_bmap.br_blockcount, &oinfo, unwritten);
      	if (error)
      		return error;
      
     -	xfs_rmap_update_hook(tp, ri->ri_pag, ri->ri_type, bno,
    -+	xfs_rmap_update_hook(tp, &ri->ri_pag->pag_group, ri->ri_type, bno,
    - 			ri->ri_bmap.br_blockcount, unwritten, &oinfo);
    +-			ri->ri_bmap.br_blockcount, unwritten, &oinfo);
    ++	xfs_rmap_update_hook(tp, pag_group(ri->ri_pag), ri->ri_type, bno,
    ++			     ri->ri_bmap.br_blockcount, unwritten, &oinfo);
      	return 0;
      }
      
      /*
       * Don't defer an rmap if we aren't an rmap filesystem.
    +  */
     
      ## fs/xfs/libxfs/xfs_rmap.h ##
     @@ fs/xfs/libxfs/xfs_rmap.h: struct xfs_rmap_hook {
      	struct xfs_hook			rmap_hook;
      };
      
    @@ fs/xfs/scrub/rmap_repair.c: xrep_rmap_setup_scan(
      	 * AGF buffer to scan all the inodes, we need this piece to avoid
      	 * installing a stale btree.
      	 */
      	ASSERT(sc->flags & XCHK_FSGATES_RMAP);
      	xfs_rmap_hook_setup(&rr->rhook, xrep_rmapbt_live_update);
     -	error = xfs_rmap_hook_add(sc->sa.pag, &rr->rhook);
    -+	error = xfs_rmap_hook_add(&sc->sa.pag->pag_group, &rr->rhook);
    ++	error = xfs_rmap_hook_add(pag_group(sc->sa.pag), &rr->rhook);
      	if (error)
      		goto out_iscan;
      	return 0;
      
      out_iscan:
      	xchk_iscan_teardown(&rr->iscan);
    @@ fs/xfs/scrub/rmap_repair.c: STATIC void
      	struct xrep_rmap	*rr)
      {
      	struct xfs_scrub	*sc = rr->sc;
      
      	xchk_iscan_abort(&rr->iscan);
     -	xfs_rmap_hook_del(sc->sa.pag, &rr->rhook);
    -+	xfs_rmap_hook_del(&sc->sa.pag->pag_group, &rr->rhook);
    ++	xfs_rmap_hook_del(pag_group(sc->sa.pag), &rr->rhook);
      	xchk_iscan_teardown(&rr->iscan);
      	xfbtree_destroy(&rr->rmap_btree);
      	mutex_destroy(&rr->lock);
      }
      
      /* Repair the rmap btree for some AG. */
 42:  820d6f6fb9b418 !  49:  c06a1ee707712f xfs: return the busy generation from xfs_extent_busy_list_empty
    @@ Metadata
     Author: Christoph Hellwig <hch@lst.de>
     
      ## Commit message ##
         xfs: return the busy generation from xfs_extent_busy_list_empty
     
         This avoid having to poke into the internals of the busy tracking in
    -    ẋrep_setup_ag_allocbt.
    +    xrep_setup_ag_allocbt.
     
         Signed-off-by: Christoph Hellwig <hch@lst.de>
         Reviewed-by: Darrick J. Wong <djwong@kernel.org>
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
     
      ## fs/xfs/scrub/alloc_repair.c ##
 43:  51c3cd35cf939b !  50:  75dee19d4deba9 xfs: convert extent busy tracking to the generic group structure
    @@
      ## Metadata ##
     Author: Christoph Hellwig <hch@lst.de>
     
      ## Commit message ##
    -    xfs: convert extent busy tracking to the generic group structure
    +    xfs: convert extent busy tracepoints to the generic group structure
     
         Prepare for tracking busy RT extents by passing the generic group
         structure to the xfs_extent_busy_class tracepoints.
     
         Signed-off-by: Christoph Hellwig <hch@lst.de>
         Reviewed-by: Darrick J. Wong <djwong@kernel.org>
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    -    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    -    Signed-off-by: Darrick J. Wong <djwong@kernel.org>
     
      ## fs/xfs/xfs_extent_busy.c ##
     @@ fs/xfs/xfs_extent_busy.c: xfs_extent_busy_insert_list(
      	new->bno = bno;
      	new->length = len;
      	INIT_LIST_HEAD(&new->list);
      	new->flags = flags;
      
      	/* trace before insert to be able to see failed inserts */
     -	trace_xfs_extent_busy(pag, bno, len);
    -+	trace_xfs_extent_busy(&pag->pag_group, bno, len);
    ++	trace_xfs_extent_busy(pag_group(pag), bno, len);
      
      	spin_lock(&pag->pagb_lock);
      	rbp = &pag->pagb_tree.rb_node;
      	while (*rbp) {
      		parent = *rbp;
      		busyp = rb_entry(parent, struct xfs_extent_busy, rb_node);
    @@ fs/xfs/xfs_extent_busy.c: xfs_extent_busy_update_extent(
      		busyp->length = fbno - busyp->bno;
      	} else {
      		ASSERT(0);
      	}
      
     -	trace_xfs_extent_busy_reuse(pag, fbno, flen);
    -+	trace_xfs_extent_busy_reuse(&pag->pag_group, fbno, flen);
    ++	trace_xfs_extent_busy_reuse(pag_group(pag), fbno, flen);
      	return true;
      
      out_force_log:
      	spin_unlock(&pag->pagb_lock);
      	xfs_log_force(pag_mount(pag), XFS_LOG_SYNC);
     -	trace_xfs_extent_busy_force(pag, fbno, flen);
    -+	trace_xfs_extent_busy_force(&pag->pag_group, fbno, flen);
    ++	trace_xfs_extent_busy_force(pag_group(pag), fbno, flen);
      	spin_lock(&pag->pagb_lock);
      	return false;
      }
      
      /*
       * For a given extent [fbno, flen], make sure we can reuse it safely.
    @@ fs/xfs/xfs_extent_busy.c: xfs_extent_busy_trim(
      		flen = fend - fbno;
      	}
      out:
      
      	if (fbno != *bno || flen != *len) {
     -		trace_xfs_extent_busy_trim(args->pag, *bno, *len, fbno, flen);
    -+		trace_xfs_extent_busy_trim(&args->pag->pag_group, *bno, *len,
    -+				fbno, flen);
    ++		trace_xfs_extent_busy_trim(pag_group(args->pag), *bno, *len,
    ++					   fbno, flen);
      		*bno = fbno;
      		*len = flen;
      		*busy_gen = args->pag->pagb_gen;
      		ret = true;
      	}
      	spin_unlock(&args->pag->pagb_lock);
    @@ fs/xfs/xfs_extent_busy.c: xfs_extent_busy_clear_one(
      		if (do_discard &&
      		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD)) {
      			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
      			return false;
      		}
     -		trace_xfs_extent_busy_clear(pag, busyp->bno, busyp->length);
    -+		trace_xfs_extent_busy_clear(&pag->pag_group, busyp->bno,
    ++		trace_xfs_extent_busy_clear(pag_group(pag), busyp->bno,
     +				busyp->length);
      		rb_erase(&busyp->rb_node, &pag->pagb_tree);
      	}
      
      	list_del_init(&busyp->list);
      	xfs_perag_put(busyp->pag);
    @@ fs/xfs/xfs_trace.h: TRACE_EVENT(xfs_bunmap,
      	),
      	TP_fast_assign(
     -		__entry->dev = pag_mount(pag)->m_super->s_dev;
     -		__entry->agno = pag_agno(pag);
     +		__entry->dev = xg->xg_mount->m_super->s_dev;
     +		__entry->type = xg->xg_type;
    -+		__entry->agno = xg->xg_index;
    ++		__entry->agno = xg->xg_gno;
      		__entry->agbno = agbno;
      		__entry->len = len;
      	),
     -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x",
     +	TP_printk("dev %d:%d %sno 0x%x %sbno 0x%x fsbcount 0x%x",
      		  MAJOR(__entry->dev), MINOR(__entry->dev),
    @@ fs/xfs/xfs_trace.h: TRACE_EVENT(xfs_bunmap,
      	),
      	TP_fast_assign(
     -		__entry->dev = pag_mount(pag)->m_super->s_dev;
     -		__entry->agno = pag_agno(pag);
     +		__entry->dev = xg->xg_mount->m_super->s_dev;
     +		__entry->type = xg->xg_type;
    -+		__entry->agno = xg->xg_index;
    ++		__entry->agno = xg->xg_gno;
      		__entry->agbno = agbno;
      		__entry->len = len;
      		__entry->tbno = tbno;
      		__entry->tlen = tlen;
      	),
     -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x found_agbno 0x%x found_fsbcount 0x%x",
 44:  379244f2ec0c09 !  51:  9f5ec03ec09929 xfs: convert busy extent tracking to the generic group structure
    @@ fs/xfs/libxfs/xfs_alloc.c: xfs_alloc_compute_aligned(
      	xfs_extlen_t	len = foundlen;
      	xfs_extlen_t	diff;
      	bool		busy;
      
      	/* Trim busy sections out of found extent */
     -	busy = xfs_extent_busy_trim(args, &bno, &len, busy_gen);
    -+	busy = xfs_extent_busy_trim(&args->pag->pag_group, args->minlen,
    ++	busy = xfs_extent_busy_trim(pag_group(args->pag), args->minlen,
     +			args->maxlen, &bno, &len, busy_gen);
      
      	/*
      	 * If we have a largish extent that happens to start before min_agbno,
      	 * see if we can shift it into range...
      	 */
    @@ fs/xfs/libxfs/xfs_alloc.c: xfs_alloc_ag_vextent_small(
      	if (error)
      		goto error;
      	if (fbno == NULLAGBLOCK)
      		goto out;
      
     -	xfs_extent_busy_reuse(args->pag, fbno, 1,
    -+	xfs_extent_busy_reuse(&args->pag->pag_group, fbno, 1,
    ++	xfs_extent_busy_reuse(pag_group(args->pag), fbno, 1,
      			      (args->datatype & XFS_ALLOC_NOBUSY));
      
      	if (args->datatype & XFS_ALLOC_USERDATA) {
      		struct xfs_buf	*bp;
      
      		error = xfs_trans_get_buf(args->tp, args->mp->m_ddev_targp,
    @@ fs/xfs/libxfs/xfs_alloc.c: xfs_alloc_ag_vextent_exact(
      	/*
      	 * Check for overlapping busy extents.
      	 */
      	tbno = fbno;
      	tlen = flen;
     -	xfs_extent_busy_trim(args, &tbno, &tlen, &busy_gen);
    -+	xfs_extent_busy_trim(&args->pag->pag_group, args->minlen, args->maxlen,
    ++	xfs_extent_busy_trim(pag_group(args->pag), args->minlen, args->maxlen,
     +			&tbno, &tlen, &busy_gen);
      
      	/*
      	 * Give up if the start of the extent is busy, or the freespace isn't
      	 * long enough for the minimum request.
      	 */
    @@ fs/xfs/libxfs/xfs_alloc.c: xfs_alloc_ag_vextent_near(
      			 * the allocation can be retried.
      			 */
      			trace_xfs_alloc_near_busy(args);
     -			error = xfs_extent_busy_flush(args->tp, args->pag,
     -					acur.busy_gen, alloc_flags);
     +			error = xfs_extent_busy_flush(args->tp,
    -+					&args->pag->pag_group, acur.busy_gen,
    ++					pag_group(args->pag), acur.busy_gen,
     +					alloc_flags);
      			if (error)
      				goto out;
      
      			alloc_flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
      			goto restart;
    @@ fs/xfs/libxfs/xfs_alloc.c: xfs_alloc_ag_vextent_size(
      			 * the allocation can be retried.
      			 */
      			trace_xfs_alloc_size_busy(args);
     -			error = xfs_extent_busy_flush(args->tp, args->pag,
     -					busy_gen, alloc_flags);
     +			error = xfs_extent_busy_flush(args->tp,
    -+					&args->pag->pag_group, busy_gen,
    ++					pag_group(args->pag), busy_gen,
     +					alloc_flags);
      			if (error)
      				goto error0;
      
      			alloc_flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
      			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
    @@ fs/xfs/libxfs/xfs_alloc.c: xfs_alloc_ag_vextent_size(
      			 * the allocation can be retried.
      			 */
      			trace_xfs_alloc_size_busy(args);
     -			error = xfs_extent_busy_flush(args->tp, args->pag,
     -					busy_gen, alloc_flags);
     +			error = xfs_extent_busy_flush(args->tp,
    -+					&args->pag->pag_group, busy_gen,
    ++					pag_group(args->pag), busy_gen,
     +					alloc_flags);
      			if (error)
      				goto error0;
      
      			alloc_flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
      			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
    @@ fs/xfs/libxfs/xfs_alloc.c: xfs_alloc_vextent_finish(
      						  -((long)(args->len)));
      		if (error)
      			goto out_drop_perag;
      
     -		ASSERT(!xfs_extent_busy_search(args->pag, args->agbno,
     -				args->len));
    -+		ASSERT(!xfs_extent_busy_search(&args->pag->pag_group,
    ++		ASSERT(!xfs_extent_busy_search(pag_group(args->pag),
     +				args->agbno, args->len));
      	}
      
      	xfs_ag_resv_alloc_extent(args->pag, args->resv, args);
      
      	XFS_STATS_INC(mp, xs_allocx);
    @@ fs/xfs/libxfs/xfs_alloc.c: __xfs_free_extent(
      	if (error)
      		goto err_release;
      
      	if (skip_discard)
      		busy_flags |= XFS_EXTENT_BUSY_SKIP_DISCARD;
     -	xfs_extent_busy_insert(tp, pag, agbno, len, busy_flags);
    -+	xfs_extent_busy_insert(tp, &pag->pag_group, agbno, len, busy_flags);
    ++	xfs_extent_busy_insert(tp, pag_group(pag), agbno, len, busy_flags);
      	return 0;
      
      err_release:
      	xfs_trans_brelse(tp, agbp);
      	return error;
      }
    @@ fs/xfs/libxfs/xfs_alloc_btree.c: xfs_allocbt_alloc_block(
      		*stat = 0;
      		return 0;
      	}
      
      	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
     -	xfs_extent_busy_reuse(cur->bc_ag.pag, bno, 1, false);
    -+	xfs_extent_busy_reuse(&cur->bc_ag.pag->pag_group, bno, 1, false);
    ++	xfs_extent_busy_reuse(pag_group(cur->bc_ag.pag), bno, 1, false);
      
      	new->s = cpu_to_be32(bno);
      
      	*stat = 1;
      	return 0;
      }
    @@ fs/xfs/libxfs/xfs_alloc_btree.c: xfs_allocbt_free_block(
      			bno, 1);
      	if (error)
      		return error;
      
      	atomic64_dec(&cur->bc_mp->m_allocbt_blks);
     -	xfs_extent_busy_insert(cur->bc_tp, agbp->b_pag, bno, 1,
    -+	xfs_extent_busy_insert(cur->bc_tp, &agbp->b_pag->pag_group, bno, 1,
    ++	xfs_extent_busy_insert(cur->bc_tp, pag_group(agbp->b_pag), bno, 1,
      			      XFS_EXTENT_BUSY_SKIP_DISCARD);
      	return 0;
      }
      
      STATIC int
      xfs_allocbt_get_minrecs(
    @@ fs/xfs/libxfs/xfs_group.c: xfs_group_free(
      
      	/* drop the mount's active reference */
      	xfs_group_rele(xg);
     @@ fs/xfs/libxfs/xfs_group.c: xfs_group_insert(
      
      	xg->xg_mount = mp;
    - 	xg->xg_index = index;
    + 	xg->xg_gno = index;
      	xg->xg_type = type;
      
      #ifdef __KERNEL__
     +	xg->xg_busy_extents = xfs_extent_busy_alloc();
     +	if (!xg->xg_busy_extents)
     +		return -ENOMEM;
    @@ fs/xfs/libxfs/xfs_rmap_btree.c: xfs_rmapbt_alloc_block(
      	if (bno == NULLAGBLOCK) {
      		*stat = 0;
      		return 0;
      	}
      
     -	xfs_extent_busy_reuse(pag, bno, 1, false);
    -+	xfs_extent_busy_reuse(&pag->pag_group, bno, 1, false);
    ++	xfs_extent_busy_reuse(pag_group(pag), bno, 1, false);
      
      	new->s = cpu_to_be32(bno);
      	be32_add_cpu(&agf->agf_rmap_blocks, 1);
      	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
      
      	/*
    @@ fs/xfs/libxfs/xfs_rmap_btree.c: xfs_rmapbt_free_block(
      	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
      	error = xfs_alloc_put_freelist(pag, cur->bc_tp, agbp, NULL, bno, 1);
      	if (error)
      		return error;
      
     -	xfs_extent_busy_insert(cur->bc_tp, pag, bno, 1,
    -+	xfs_extent_busy_insert(cur->bc_tp, &pag->pag_group, bno, 1,
    ++	xfs_extent_busy_insert(cur->bc_tp, pag_group(pag), bno, 1,
      			      XFS_EXTENT_BUSY_SKIP_DISCARD);
      
      	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_RMAPBT, NULL, 1);
      	return 0;
      }
      
    @@ fs/xfs/scrub/alloc_repair.c: struct xrep_abt {
      
      /* Set up to repair AG free space btrees. */
      int
      xrep_setup_ag_allocbt(
      	struct xfs_scrub	*sc)
      {
    -+	struct xfs_group	*xg = &sc->sa.pag->pag_group;
    ++	struct xfs_group	*xg = pag_group(sc->sa.pag);
     +	unsigned int		busy_gen;
     +
      	/*
      	 * Make sure the busy extent list is clear because we can't put extents
      	 * on there twice.
      	 */
    @@ fs/xfs/scrub/alloc_repair.c: xrep_allocbt(
      	/*
      	 * Make sure the busy extent list is clear because we can't put extents
      	 * on there twice.  In theory we cleared this before we started, but
      	 * let's not risk the filesystem.
      	 */
     -	if (!xfs_extent_busy_list_empty(sc->sa.pag, &busy_gen)) {
    -+	if (!xfs_extent_busy_list_empty(&sc->sa.pag->pag_group, &busy_gen)) {
    ++	if (!xfs_extent_busy_list_empty(pag_group(sc->sa.pag), &busy_gen)) {
      		error = -EDEADLOCK;
      		goto out_ra;
      	}
      
      	/* Set up enough storage to handle maximally fragmented free space. */
      	descr = xchk_xfile_ag_descr(sc, "free space records");
    @@ fs/xfs/scrub/reap.c: xreap_put_freelist(
      
      	error = xfs_alloc_put_freelist(sc->sa.pag, sc->tp, sc->sa.agf_bp,
      			agfl_bp, agbno, 0);
      	if (error)
      		return error;
     -	xfs_extent_busy_insert(sc->tp, sc->sa.pag, agbno, 1,
    -+	xfs_extent_busy_insert(sc->tp, &sc->sa.pag->pag_group, agbno, 1,
    ++	xfs_extent_busy_insert(sc->tp, pag_group(sc->sa.pag), agbno, 1,
      			XFS_EXTENT_BUSY_SKIP_DISCARD);
      
      	return 0;
      }
      
      /* Are there any uncommitted reap operations? */
    @@ fs/xfs/xfs_discard.c: xfs_trim_gather_extents(
      
      		/*
      		 * If any blocks in the range are still busy, skip the
      		 * discard and try again the next time.
      		 */
     -		if (xfs_extent_busy_search(pag, fbno, flen)) {
    -+		if (xfs_extent_busy_search(&pag->pag_group, fbno, flen)) {
    ++		if (xfs_extent_busy_search(pag_group(pag), fbno, flen)) {
      			trace_xfs_discard_busy(pag, fbno, flen);
      			goto next_extent;
      		}
      
     -		xfs_extent_busy_insert_discard(pag, fbno, flen,
    -+		xfs_extent_busy_insert_discard(&pag->pag_group, fbno, flen,
    ++		xfs_extent_busy_insert_discard(pag_group(pag), fbno, flen,
      				&extents->extent_list);
      next_extent:
      		if (tcur->by_bno)
      			error = xfs_btree_increment(cur, 0, &i);
      		else
      			error = xfs_btree_decrement(cur, 0, &i);
    @@ fs/xfs/xfs_extent_busy.c
      	new->bno = bno;
      	new->length = len;
      	INIT_LIST_HEAD(&new->list);
      	new->flags = flags;
      
      	/* trace before insert to be able to see failed inserts */
    --	trace_xfs_extent_busy(&pag->pag_group, bno, len);
    +-	trace_xfs_extent_busy(pag_group(pag), bno, len);
     +	trace_xfs_extent_busy(xg, bno, len);
      
     -	spin_lock(&pag->pagb_lock);
     -	rbp = &pag->pagb_tree.rb_node;
     +	spin_lock(&eb->eb_lock);
     +	rbp = &eb->eb_tree.rb_node;
    @@ fs/xfs/xfs_extent_busy.c: xfs_extent_busy_update_extent(
      		 */
      		busyp->length = fbno - busyp->bno;
      	} else {
      		ASSERT(0);
      	}
      
    --	trace_xfs_extent_busy_reuse(&pag->pag_group, fbno, flen);
    +-	trace_xfs_extent_busy_reuse(pag_group(pag), fbno, flen);
     +	trace_xfs_extent_busy_reuse(xg, fbno, flen);
      	return true;
      
      out_force_log:
     -	spin_unlock(&pag->pagb_lock);
     -	xfs_log_force(pag_mount(pag), XFS_LOG_SYNC);
    --	trace_xfs_extent_busy_force(&pag->pag_group, fbno, flen);
    +-	trace_xfs_extent_busy_force(pag_group(pag), fbno, flen);
     -	spin_lock(&pag->pagb_lock);
     +	spin_unlock(&eb->eb_lock);
     +	xfs_log_force(xg->xg_mount, XFS_LOG_SYNC);
     +	trace_xfs_extent_busy_force(xg, fbno, flen);
     +	spin_lock(&eb->eb_lock);
      	return false;
    @@ fs/xfs/xfs_extent_busy.c: xfs_extent_busy_trim(
      
      		flen = fend - fbno;
      	}
      out:
      
      	if (fbno != *bno || flen != *len) {
    --		trace_xfs_extent_busy_trim(&args->pag->pag_group, *bno, *len,
    --				fbno, flen);
    +-		trace_xfs_extent_busy_trim(pag_group(args->pag), *bno, *len,
    +-					   fbno, flen);
     +		trace_xfs_extent_busy_trim(xg, *bno, *len, fbno, flen);
      		*bno = fbno;
      		*len = flen;
     -		*busy_gen = args->pag->pagb_gen;
     +		*busy_gen = eb->eb_gen;
      		ret = true;
    @@ fs/xfs/xfs_extent_busy.c: xfs_extent_busy_trim(
      	if (busyp->length) {
      		if (do_discard &&
      		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD)) {
      			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
      			return false;
      		}
    --		trace_xfs_extent_busy_clear(&pag->pag_group, busyp->bno,
    +-		trace_xfs_extent_busy_clear(pag_group(pag), busyp->bno,
     +		trace_xfs_extent_busy_clear(busyp->group, busyp->bno,
      				busyp->length);
     -		rb_erase(&busyp->rb_node, &pag->pagb_tree);
     +		rb_erase(&busyp->rb_node, &eb->eb_tree);
      	}
      
    @@ fs/xfs/xfs_extent_busy.c: xfs_extent_busy_clear(
     -				break;
     -			schedule();
     -		} while (1);
     -		finish_wait(&pag->pagb_wait, &wait);
     -	}
     +	while ((pag = xfs_perag_next(mp, pag)))
    -+		xfs_extent_busy_wait_group(&pag->pag_group);
    ++		xfs_extent_busy_wait_group(pag_group(pag));
      }
      
      /*
     - * Callback for list_sort to sort busy extents by the AG they reside in.
     + * Callback for list_sort to sort busy extents by the group they reside in.
       */
    @@ fs/xfs/xfs_extent_busy.c: xfs_extent_busy_ag_cmp(
      		container_of(l1, struct xfs_extent_busy, list);
      	struct xfs_extent_busy	*b2 =
      		container_of(l2, struct xfs_extent_busy, list);
      	s32 diff;
      
     -	diff = pag_agno(b1->pag) - pag_agno(b2->pag);
    -+	diff = b1->group->xg_index - b2->group->xg_index;
    ++	diff = b1->group->xg_gno - b2->group->xg_gno;
      	if (!diff)
      		diff = b1->bno - b2->bno;
      	return diff;
      }
      
     -/* Are there any busy extents in this AG? */
 45:  fcb8a8d94c8c32 !  52:  b9f74749112e46 xfs: add a generic group pointer to the btree cursor
    @@ fs/xfs/libxfs/xfs_alloc.c: xfs_alloc_complain_bad_rec(
      {
      	struct xfs_mount		*mp = cur->bc_mp;
      
      	xfs_warn(mp,
      		"%sbt record corruption in AG %d detected at %pS!",
     -		cur->bc_ops->name, pag_agno(cur->bc_ag.pag), fa);
    -+		cur->bc_ops->name, cur->bc_group->xg_index, fa);
    ++		cur->bc_ops->name, cur->bc_group->xg_gno, fa);
      	xfs_warn(mp,
      		"start block 0x%x block count 0x%x", irec->ar_startblock,
      		irec->ar_blockcount);
      	xfs_btree_mark_sick(cur);
      	return -EFSCORRUPTED;
      }
    @@ fs/xfs/libxfs/xfs_alloc_btree.c: xfs_allocbt_alloc_block(
      	if (bno == NULLAGBLOCK) {
      		*stat = 0;
      		return 0;
      	}
      
      	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
    --	xfs_extent_busy_reuse(&cur->bc_ag.pag->pag_group, bno, 1, false);
    +-	xfs_extent_busy_reuse(pag_group(cur->bc_ag.pag), bno, 1, false);
     +	xfs_extent_busy_reuse(cur->bc_group, bno, 1, false);
      
      	new->s = cpu_to_be32(bno);
      
      	*stat = 1;
      	return 0;
    @@ fs/xfs/libxfs/xfs_alloc_btree.c: xfs_allocbt_free_block(
     +	error = xfs_alloc_put_freelist(to_perag(cur->bc_group), cur->bc_tp,
     +			agbp, NULL, bno, 1);
      	if (error)
      		return error;
      
      	atomic64_dec(&cur->bc_mp->m_allocbt_blks);
    - 	xfs_extent_busy_insert(cur->bc_tp, &agbp->b_pag->pag_group, bno, 1,
    + 	xfs_extent_busy_insert(cur->bc_tp, pag_group(agbp->b_pag), bno, 1,
      			      XFS_EXTENT_BUSY_SKIP_DISCARD);
     @@ fs/xfs/libxfs/xfs_alloc_btree.c: STATIC void
      xfs_allocbt_init_ptr_from_cur(
      	struct xfs_btree_cur	*cur,
      	union xfs_btree_ptr	*ptr)
      {
      	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
      
     -	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agf->agf_seqno));
    -+	ASSERT(cur->bc_group->xg_index == be32_to_cpu(agf->agf_seqno));
    ++	ASSERT(cur->bc_group->xg_gno == be32_to_cpu(agf->agf_seqno));
      
      	if (xfs_btree_is_bno(cur->bc_ops))
      		ptr->s = agf->agf_bno_root;
      	else
      		ptr->s = agf->agf_cnt_root;
      }
    @@ fs/xfs/libxfs/xfs_alloc_btree.c: xfs_bnobt_init_cursor(
      {
      	struct xfs_btree_cur	*cur;
      
      	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_bnobt_ops,
      			mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
     -	cur->bc_ag.pag = xfs_perag_hold(pag);
    -+	cur->bc_group = xfs_group_hold(&pag->pag_group);
    ++	cur->bc_group = xfs_group_hold(pag_group(pag));
      	cur->bc_ag.agbp = agbp;
      	if (agbp) {
      		struct xfs_agf		*agf = agbp->b_addr;
      
      		cur->bc_nlevels = be32_to_cpu(agf->agf_bno_level);
      	}
    @@ fs/xfs/libxfs/xfs_alloc_btree.c: xfs_cntbt_init_cursor(
      {
      	struct xfs_btree_cur	*cur;
      
      	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_cntbt_ops,
      			mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
     -	cur->bc_ag.pag = xfs_perag_hold(pag);
    -+	cur->bc_group = xfs_group_hold(&pag->pag_group);
    ++	cur->bc_group = xfs_group_hold(pag_group(pag));
      	cur->bc_ag.agbp = agbp;
      	if (agbp) {
      		struct xfs_agf		*agf = agbp->b_addr;
      
      		cur->bc_nlevels = be32_to_cpu(agf->agf_cnt_level);
      	}
    @@ fs/xfs/libxfs/xfs_btree.c: xfs_btree_check_ptr(
      				level, index);
      			break;
      		case XFS_BTREE_TYPE_AG:
      			xfs_err(cur->bc_mp,
      "AG %u: Corrupt %sbt pointer at level %d index %d.",
     -				pag_agno(cur->bc_ag.pag), cur->bc_ops->name,
    -+				cur->bc_group->xg_index, cur->bc_ops->name,
    ++				cur->bc_group->xg_gno, cur->bc_ops->name,
      				level, index);
      			break;
      		}
      		xfs_btree_mark_sick(cur);
      	}
      
    @@ fs/xfs/libxfs/xfs_btree.c: xfs_btree_owner(
      	case XFS_BTREE_TYPE_MEM:
      		return cur->bc_mem.xfbtree->owner;
      	case XFS_BTREE_TYPE_INODE:
      		return cur->bc_ino.ip->i_ino;
      	case XFS_BTREE_TYPE_AG:
     -		return pag_agno(cur->bc_ag.pag);
    -+		return cur->bc_group->xg_index;
    ++		return cur->bc_group->xg_gno;
      	default:
      		ASSERT(0);
      		return 0;
      	}
      }
      
    @@ fs/xfs/libxfs/xfs_ialloc.c: xfs_inobt_complain_bad_rec(
      {
      	struct xfs_mount		*mp = cur->bc_mp;
      
      	xfs_warn(mp,
      		"%sbt record corruption in AG %d detected at %pS!",
     -		cur->bc_ops->name, pag_agno(cur->bc_ag.pag), fa);
    -+		cur->bc_ops->name, cur->bc_group->xg_index, fa);
    ++		cur->bc_ops->name, cur->bc_group->xg_gno, fa);
      	xfs_warn(mp,
      "start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
      		irec->ir_startino, irec->ir_count, irec->ir_freecount,
      		irec->ir_free, irec->ir_holemask);
      	xfs_btree_mark_sick(cur);
      	return -EFSCORRUPTED;
    @@ fs/xfs/libxfs/xfs_ialloc_btree.c: STATIC void
      	struct xfs_btree_cur	*cur,
      	union xfs_btree_ptr	*ptr)
      {
      	struct xfs_agi		*agi = cur->bc_ag.agbp->b_addr;
      
     -	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agi->agi_seqno));
    -+	ASSERT(cur->bc_group->xg_index == be32_to_cpu(agi->agi_seqno));
    ++	ASSERT(cur->bc_group->xg_gno == be32_to_cpu(agi->agi_seqno));
      
      	ptr->s = agi->agi_root;
      }
      
      STATIC void
      xfs_finobt_init_ptr_from_cur(
      	struct xfs_btree_cur	*cur,
      	union xfs_btree_ptr	*ptr)
      {
      	struct xfs_agi		*agi = cur->bc_ag.agbp->b_addr;
      
     -	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agi->agi_seqno));
    -+	ASSERT(cur->bc_group->xg_index == be32_to_cpu(agi->agi_seqno));
    ++	ASSERT(cur->bc_group->xg_gno == be32_to_cpu(agi->agi_seqno));
     +
      	ptr->s = agi->agi_free_root;
      }
      
      STATIC int64_t
      xfs_inobt_key_diff(
    @@ fs/xfs/libxfs/xfs_ialloc_btree.c: xfs_inobt_init_cursor(
      	struct xfs_mount	*mp = pag_mount(pag);
      	struct xfs_btree_cur	*cur;
      
      	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_inobt_ops,
      			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
     -	cur->bc_ag.pag = xfs_perag_hold(pag);
    -+	cur->bc_group = xfs_group_hold(&pag->pag_group);
    ++	cur->bc_group = xfs_group_hold(pag_group(pag));
      	cur->bc_ag.agbp = agbp;
      	if (agbp) {
      		struct xfs_agi		*agi = agbp->b_addr;
      
      		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
      	}
    @@ fs/xfs/libxfs/xfs_ialloc_btree.c: xfs_finobt_init_cursor(
      	struct xfs_mount	*mp = pag_mount(pag);
      	struct xfs_btree_cur	*cur;
      
      	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_finobt_ops,
      			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
     -	cur->bc_ag.pag = xfs_perag_hold(pag);
    -+	cur->bc_group = xfs_group_hold(&pag->pag_group);
    ++	cur->bc_group = xfs_group_hold(pag_group(pag));
      	cur->bc_ag.agbp = agbp;
      	if (agbp) {
      		struct xfs_agi		*agi = agbp->b_addr;
      
      		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
      	}
    @@ fs/xfs/libxfs/xfs_refcount.c: xfs_refcount_complain_bad_rec(
      {
      	struct xfs_mount		*mp = cur->bc_mp;
      
      	xfs_warn(mp,
       "Refcount BTree record corruption in AG %d detected at %pS!",
     -				pag_agno(cur->bc_ag.pag), fa);
    -+				cur->bc_group->xg_index, fa);
    ++				cur->bc_group->xg_gno, fa);
      	xfs_warn(mp,
      		"Start block 0x%x, block count 0x%x, references 0x%x",
      		irec->rc_startblock, irec->rc_blockcount, irec->rc_refcount);
      	xfs_btree_mark_sick(cur);
      	return -EFSCORRUPTED;
      }
    @@ fs/xfs/libxfs/xfs_refcount_btree.c: xfs_refcountbt_alloc_block(
      		goto out_error;
      	if (args.fsbno == NULLFSBLOCK) {
      		*stat = 0;
      		return 0;
      	}
     -	ASSERT(args.agno == pag_agno(cur->bc_ag.pag));
    -+	ASSERT(args.agno == cur->bc_group->xg_index);
    ++	ASSERT(args.agno == cur->bc_group->xg_gno);
      	ASSERT(args.len == 1);
      
      	new->s = cpu_to_be32(args.agbno);
      	be32_add_cpu(&agf->agf_refcount_blocks, 1);
      	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
      
    @@ fs/xfs/libxfs/xfs_refcount_btree.c: STATIC void
      	struct xfs_btree_cur	*cur,
      	union xfs_btree_ptr	*ptr)
      {
      	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
      
     -	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agf->agf_seqno));
    -+	ASSERT(cur->bc_group->xg_index == be32_to_cpu(agf->agf_seqno));
    ++	ASSERT(cur->bc_group->xg_gno == be32_to_cpu(agf->agf_seqno));
      
      	ptr->s = agf->agf_refcount_root;
      }
      
      STATIC int64_t
      xfs_refcountbt_key_diff(
    @@ fs/xfs/libxfs/xfs_refcount_btree.c: xfs_refcountbt_init_cursor(
      
      	ASSERT(pag_agno(pag) < mp->m_sb.sb_agcount);
      
      	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_refcountbt_ops,
      			mp->m_refc_maxlevels, xfs_refcountbt_cur_cache);
     -	cur->bc_ag.pag = xfs_perag_hold(pag);
    -+	cur->bc_group = xfs_group_hold(&pag->pag_group);
    ++	cur->bc_group = xfs_group_hold(pag_group(pag));
      	cur->bc_refc.nr_ops = 0;
      	cur->bc_refc.shape_changes = 0;
      	cur->bc_ag.agbp = agbp;
      	if (agbp) {
      		struct xfs_agf		*agf = agbp->b_addr;
      
    @@ fs/xfs/libxfs/xfs_rmap.c: xfs_rmap_complain_bad_rec(
      		xfs_warn(mp,
       "In-Memory Reverse Mapping BTree record corruption detected at %pS!", fa);
      	else
      		xfs_warn(mp,
       "Reverse Mapping BTree record corruption in AG %d detected at %pS!",
     -			pag_agno(cur->bc_ag.pag), fa);
    -+			cur->bc_group->xg_index, fa);
    ++			cur->bc_group->xg_gno, fa);
      	xfs_warn(mp,
      		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
      		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
      		irec->rm_blockcount);
      	xfs_btree_mark_sick(cur);
      	return -EFSCORRUPTED;
    @@ fs/xfs/libxfs/xfs_rmap_btree.c: STATIC void
      	struct xfs_btree_cur	*cur,
      	union xfs_btree_ptr	*ptr)
      {
      	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
      
     -	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agf->agf_seqno));
    -+	ASSERT(cur->bc_group->xg_index == be32_to_cpu(agf->agf_seqno));
    ++	ASSERT(cur->bc_group->xg_gno == be32_to_cpu(agf->agf_seqno));
      
      	ptr->s = agf->agf_rmap_root;
      }
      
      /*
       * Mask the appropriate parts of the ondisk key field for a key comparison.
    @@ fs/xfs/libxfs/xfs_rmap_btree.c: xfs_rmapbt_init_cursor(
      {
      	struct xfs_btree_cur	*cur;
      
      	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rmapbt_ops,
      			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
     -	cur->bc_ag.pag = xfs_perag_hold(pag);
    -+	cur->bc_group = xfs_group_hold(&pag->pag_group);
    ++	cur->bc_group = xfs_group_hold(pag_group(pag));
      	cur->bc_ag.agbp = agbp;
      	if (agbp) {
      		struct xfs_agf		*agf = agbp->b_addr;
      
      		cur->bc_nlevels = be32_to_cpu(agf->agf_rmap_level);
      	}
    @@ fs/xfs/libxfs/xfs_rmap_btree.c: xfs_rmapbt_mem_cursor(
      	cur = xfs_btree_alloc_cursor(pag_mount(pag), tp, &xfs_rmapbt_mem_ops,
      			xfs_rmapbt_maxlevels_ondisk(), xfs_rmapbt_cur_cache);
      	cur->bc_mem.xfbtree = xfbt;
      	cur->bc_nlevels = xfbt->nlevels;
      
     -	cur->bc_mem.pag = xfs_perag_hold(pag);
    -+	cur->bc_group = xfs_group_hold(&pag->pag_group);
    ++	cur->bc_group = xfs_group_hold(pag_group(pag));
      	return cur;
      }
      
      /* Create an in-memory rmap btree. */
      int
      xfs_rmapbt_mem_init(
    @@ fs/xfs/xfs_trace.h: TRACE_EVENT(xfs_btree_alloc_block,
      		case XFS_BTREE_TYPE_INODE:
      			__entry->agno = 0;
      			__entry->ino = cur->bc_ino.ip->i_ino;
      			break;
      		case XFS_BTREE_TYPE_AG:
     -			__entry->agno = pag_agno(cur->bc_ag.pag);
    -+			__entry->agno = cur->bc_group->xg_index;
    ++			__entry->agno = cur->bc_group->xg_gno;
      			__entry->ino = 0;
      			break;
      		case XFS_BTREE_TYPE_MEM:
      			__entry->agno = 0;
      			__entry->ino = 0;
      			break;
    @@ fs/xfs/xfs_trace.h: DECLARE_EVENT_CLASS(xfs_rmap_class,
      		__field(uint64_t, offset)
      		__field(unsigned long, flags)
      	),
      	TP_fast_assign(
      		__entry->dev = cur->bc_mp->m_super->s_dev;
     -		__entry->agno = pag_agno(cur->bc_ag.pag);
    -+		__entry->agno = cur->bc_group->xg_index;
    ++		__entry->agno = cur->bc_group->xg_gno;
      		__entry->agbno = agbno;
      		__entry->len = len;
      		__entry->owner = oinfo->oi_owner;
      		__entry->offset = oinfo->oi_offset;
      		__entry->flags = oinfo->oi_flags;
      		if (unwritten)
    @@ fs/xfs/xfs_trace.h: DECLARE_EVENT_CLASS(xfs_btree_error_class,
      		case XFS_BTREE_TYPE_INODE:
      			__entry->agno = 0;
      			__entry->ino = cur->bc_ino.ip->i_ino;
      			break;
      		case XFS_BTREE_TYPE_AG:
     -			__entry->agno = pag_agno(cur->bc_ag.pag);
    -+			__entry->agno = cur->bc_group->xg_index;
    ++			__entry->agno = cur->bc_group->xg_gno;
      			__entry->ino = 0;
      			break;
      		case XFS_BTREE_TYPE_MEM:
      			__entry->agno = 0;
      			__entry->ino = 0;
      			break;
    @@ fs/xfs/xfs_trace.h: TRACE_EVENT(xfs_rmap_convert_state,
      		case XFS_BTREE_TYPE_INODE:
      			__entry->agno = 0;
      			__entry->ino = cur->bc_ino.ip->i_ino;
      			break;
      		case XFS_BTREE_TYPE_AG:
     -			__entry->agno = pag_agno(cur->bc_ag.pag);
    -+			__entry->agno = cur->bc_group->xg_index;
    ++			__entry->agno = cur->bc_group->xg_gno;
      			__entry->ino = 0;
      			break;
      		case XFS_BTREE_TYPE_MEM:
      			__entry->agno = 0;
      			__entry->ino = 0;
      			break;
    @@ fs/xfs/xfs_trace.h: DECLARE_EVENT_CLASS(xfs_rmapbt_class,
      		__field(uint64_t, offset)
      		__field(unsigned int, flags)
      	),
      	TP_fast_assign(
      		__entry->dev = cur->bc_mp->m_super->s_dev;
     -		__entry->agno = pag_agno(cur->bc_ag.pag);
    -+		__entry->agno = cur->bc_group->xg_index;
    ++		__entry->agno = cur->bc_group->xg_gno;
      		__entry->agbno = agbno;
      		__entry->len = len;
      		__entry->owner = owner;
      		__entry->offset = offset;
      		__entry->flags = flags;
      	),
    @@ fs/xfs/xfs_trace.h: DECLARE_EVENT_CLASS(xfs_refcount_class,
      		__field(xfs_agblock_t, agbno)
      		__field(xfs_extlen_t, len)
      	),
      	TP_fast_assign(
      		__entry->dev = cur->bc_mp->m_super->s_dev;
     -		__entry->agno = pag_agno(cur->bc_ag.pag);
    -+		__entry->agno = cur->bc_group->xg_index;
    ++		__entry->agno = cur->bc_group->xg_gno;
      		__entry->agbno = agbno;
      		__entry->len = len;
      	),
      	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x",
      		  MAJOR(__entry->dev), MINOR(__entry->dev),
      		  __entry->agno,
    @@ fs/xfs/xfs_trace.h: TRACE_EVENT(xfs_refcount_lookup,
      		__field(xfs_agblock_t, agbno)
      		__field(xfs_lookup_t, dir)
      	),
      	TP_fast_assign(
      		__entry->dev = cur->bc_mp->m_super->s_dev;
     -		__entry->agno = pag_agno(cur->bc_ag.pag);
    -+		__entry->agno = cur->bc_group->xg_index;
    ++		__entry->agno = cur->bc_group->xg_gno;
      		__entry->agbno = agbno;
      		__entry->dir = dir;
      	),
      	TP_printk("dev %d:%d agno 0x%x agbno 0x%x cmp %s(%d)",
      		  MAJOR(__entry->dev), MINOR(__entry->dev),
      		  __entry->agno,
    @@ fs/xfs/xfs_trace.h: DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
      		__field(xfs_extlen_t, blockcount)
      		__field(xfs_nlink_t, refcount)
      	),
      	TP_fast_assign(
      		__entry->dev = cur->bc_mp->m_super->s_dev;
     -		__entry->agno = pag_agno(cur->bc_ag.pag);
    -+		__entry->agno = cur->bc_group->xg_index;
    ++		__entry->agno = cur->bc_group->xg_gno;
      		__entry->domain = irec->rc_domain;
      		__entry->startblock = irec->rc_startblock;
      		__entry->blockcount = irec->rc_blockcount;
      		__entry->refcount = irec->rc_refcount;
      	),
      	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u",
    @@ fs/xfs/xfs_trace.h: DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
      		__field(xfs_nlink_t, refcount)
      		__field(xfs_agblock_t, agbno)
      	),
      	TP_fast_assign(
      		__entry->dev = cur->bc_mp->m_super->s_dev;
     -		__entry->agno = pag_agno(cur->bc_ag.pag);
    -+		__entry->agno = cur->bc_group->xg_index;
    ++		__entry->agno = cur->bc_group->xg_gno;
      		__entry->domain = irec->rc_domain;
      		__entry->startblock = irec->rc_startblock;
      		__entry->blockcount = irec->rc_blockcount;
      		__entry->refcount = irec->rc_refcount;
      		__entry->agbno = agbno;
      	),
    @@ fs/xfs/xfs_trace.h: DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
      		__field(xfs_extlen_t, i2_blockcount)
      		__field(xfs_nlink_t, i2_refcount)
      	),
      	TP_fast_assign(
      		__entry->dev = cur->bc_mp->m_super->s_dev;
     -		__entry->agno = pag_agno(cur->bc_ag.pag);
    -+		__entry->agno = cur->bc_group->xg_index;
    ++		__entry->agno = cur->bc_group->xg_gno;
      		__entry->i1_domain = i1->rc_domain;
      		__entry->i1_startblock = i1->rc_startblock;
      		__entry->i1_blockcount = i1->rc_blockcount;
      		__entry->i1_refcount = i1->rc_refcount;
      		__entry->i2_domain = i2->rc_domain;
      		__entry->i2_startblock = i2->rc_startblock;
    @@ fs/xfs/xfs_trace.h: DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
      		__field(xfs_nlink_t, i2_refcount)
      		__field(xfs_agblock_t, agbno)
      	),
      	TP_fast_assign(
      		__entry->dev = cur->bc_mp->m_super->s_dev;
     -		__entry->agno = pag_agno(cur->bc_ag.pag);
    -+		__entry->agno = cur->bc_group->xg_index;
    ++		__entry->agno = cur->bc_group->xg_gno;
      		__entry->i1_domain = i1->rc_domain;
      		__entry->i1_startblock = i1->rc_startblock;
      		__entry->i1_blockcount = i1->rc_blockcount;
      		__entry->i1_refcount = i1->rc_refcount;
      		__entry->i2_domain = i2->rc_domain;
      		__entry->i2_startblock = i2->rc_startblock;
    @@ fs/xfs/xfs_trace.h: DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
      		__field(xfs_extlen_t, i3_blockcount)
      		__field(xfs_nlink_t, i3_refcount)
      	),
      	TP_fast_assign(
      		__entry->dev = cur->bc_mp->m_super->s_dev;
     -		__entry->agno = pag_agno(cur->bc_ag.pag);
    -+		__entry->agno = cur->bc_group->xg_index;
    ++		__entry->agno = cur->bc_group->xg_gno;
      		__entry->i1_domain = i1->rc_domain;
      		__entry->i1_startblock = i1->rc_startblock;
      		__entry->i1_blockcount = i1->rc_blockcount;
      		__entry->i1_refcount = i1->rc_refcount;
      		__entry->i2_domain = i2->rc_domain;
      		__entry->i2_startblock = i2->rc_startblock;
    @@ fs/xfs/xfs_trace.h: TRACE_EVENT(xfs_btree_commit_afakeroot,
      		__field(unsigned int, blocks)
      	),
      	TP_fast_assign(
      		__entry->dev = cur->bc_mp->m_super->s_dev;
      		__assign_str(name);
     -		__entry->agno = pag_agno(cur->bc_ag.pag);
    -+		__entry->agno = cur->bc_group->xg_index;
    ++		__entry->agno = cur->bc_group->xg_gno;
      		__entry->agbno = cur->bc_ag.afake->af_root;
      		__entry->levels = cur->bc_ag.afake->af_levels;
      		__entry->blocks = cur->bc_ag.afake->af_blocks;
      	),
      	TP_printk("dev %d:%d %sbt agno 0x%x levels %u blocks %u root %u",
      		  MAJOR(__entry->dev), MINOR(__entry->dev),
    @@ fs/xfs/xfs_trace.h: TRACE_EVENT(xfs_btree_bload_block,
      			xfs_fsblock_t	fsb = be64_to_cpu(ptr->l);
      
      			__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsb);
      			__entry->agbno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsb);
      		} else {
     -			__entry->agno = pag_agno(cur->bc_ag.pag);
    -+			__entry->agno = cur->bc_group->xg_index;
    ++			__entry->agno = cur->bc_group->xg_gno;
      			__entry->agbno = be32_to_cpu(ptr->s);
      		}
      		__entry->nr_records = nr_records;
      	),
      	TP_printk("dev %d:%d %sbt level %u block %llu/%llu agno 0x%x agbno 0x%x recs %u",
      		  MAJOR(__entry->dev), MINOR(__entry->dev),
 46:  129d23aed39519 !  53:  0d134f97131419 xfs: store a generic xfs_group pointer in xfs_getfsmap_info
    @@ fs/xfs/xfs_fsmap.c: xfs_getfsmap_helper(
      	/* Fill out the extent we found */
      	if (info->head->fmh_entries >= info->head->fmh_count)
      		return -ECANCELED;
      
      	trace_xfs_fsmap_mapping(mp, info->dev,
     -			info->pag ? pag_agno(info->pag) : NULLAGNUMBER, rec);
    -+			info->group ? info->group->xg_index : NULLAGNUMBER,
    ++			info->group ? info->group->xg_gno : NULLAGNUMBER,
     +			rec);
      
      	fmr.fmr_device = info->dev;
      	fmr.fmr_physical = rec_daddr;
      	error = xfs_fsmap_owner_from_rmap(&fmr, rec);
      	if (error)
    @@ fs/xfs/xfs_fsmap.c: __xfs_getfsmap_datadev(
      	while ((pag = xfs_perag_next_range(mp, pag, start_ag, end_ag))) {
      		/*
      		 * Set the AG high key from the fsmap high key if this
      		 * is the last AG that we're querying.
      		 */
     -		info->pag = pag;
    -+		info->group = &pag->pag_group;
    ++		info->group = pag_group(pag);
      		if (pag_agno(pag) == end_ag) {
      			info->high.rm_startblock = XFS_FSB_TO_AGBNO(mp,
      					end_fsb);
      			info->high.rm_offset = XFS_BB_TO_FSBT(mp,
      					keys[1].fmr_offset);
      			error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
 47:  31199e37b922aa <   -:  -------------- xfs: add group based bno conversion helpers
  -:  -------------- >  54:  71acb7db4c4033 xfs: add group based bno conversion helpers
 48:  0f2b550eeaa0ed !  55:  f5ba8c0b5cec17 xfs: remove xfs_group_intent_hold and xfs_group_intent_rele
    @@ fs/xfs/xfs_drain.c: static inline bool xfs_defer_drain_busy(struct xfs_defer_dra
      	struct xfs_perag	*pag;
      
      	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, fsbno));
      	if (!pag)
      		return NULL;
      
    --	xfs_group_intent_hold(&pag->pag_group);
    -+	trace_xfs_group_intent_hold(&pag->pag_group, __return_address);
    -+	xfs_defer_drain_grab(&pag->pag_group.xg_intents_drain);
    +-	xfs_group_intent_hold(pag_group(pag));
    ++	trace_xfs_group_intent_hold(pag_group(pag), __return_address);
    ++	xfs_defer_drain_grab(pag_group(pag).xg_intents_drain);
      	return pag;
      }
      
      /*
       * Release our intent to update this AG's metadata, and then release our
       * passive ref to the AG.
       */
      void
      xfs_perag_intent_put(
      	struct xfs_perag	*pag)
      {
    --	xfs_group_intent_rele(&pag->pag_group);
    -+	trace_xfs_group_intent_rele(&pag->pag_group, __return_address);
    -+	xfs_defer_drain_rele(&pag->pag_group.xg_intents_drain);
    +-	xfs_group_intent_rele(pag_group(pag));
    ++	trace_xfs_group_intent_rele(pag_group(pag), __return_address);
    ++	xfs_defer_drain_rele(pag_group(pag).xg_intents_drain);
      	xfs_perag_put(pag);
      }
      
      /*
       * Wait for the intent update count for this AG to hit zero.
       * Callers must not hold any AG header buffers.
 49:  a446b7a9c56524 !  56:  2069c49b0e8cef xfs: store a generic group structure in the intents
    @@ fs/xfs/libxfs/xfs_rmap.c: xfs_rmap_finish_one(
      
      	error = __xfs_rmap_finish_intent(rcur, ri->ri_type, bno,
      			ri->ri_bmap.br_blockcount, &oinfo, unwritten);
      	if (error)
      		return error;
      
    --	xfs_rmap_update_hook(tp, &ri->ri_pag->pag_group, ri->ri_type, bno,
    +-	xfs_rmap_update_hook(tp, pag_group(ri->ri_pag), ri->ri_type, bno,
    +-			     ri->ri_bmap.br_blockcount, unwritten, &oinfo);
     +	xfs_rmap_update_hook(tp, ri->ri_group, ri->ri_type, bno,
    - 			ri->ri_bmap.br_blockcount, unwritten, &oinfo);
    ++			ri->ri_bmap.br_blockcount, unwritten, &oinfo);
      	return 0;
      }
      
      /*
       * Don't defer an rmap if we aren't an rmap filesystem.
    +  */
     
      ## fs/xfs/libxfs/xfs_rmap.h ##
     @@ fs/xfs/libxfs/xfs_rmap.h: enum xfs_rmap_intent_type {
      struct xfs_rmap_intent {
      	struct list_head			ri_list;
      	enum xfs_rmap_intent_type		ri_type;
    @@ fs/xfs/xfs_drain.c: static inline bool xfs_defer_drain_busy(struct xfs_defer_dra
     -	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, fsbno));
     -	if (!pag)
     +	xg = xfs_group_get_by_fsb(mp, fsbno, type);
     +	if (!xg)
      		return NULL;
     -
    --	trace_xfs_group_intent_hold(&pag->pag_group, __return_address);
    --	xfs_defer_drain_grab(&pag->pag_group.xg_intents_drain);
    +-	trace_xfs_group_intent_hold(pag_group(pag), __return_address);
    +-	xfs_defer_drain_grab(pag_group(pag).xg_intents_drain);
     -	return pag;
     +	trace_xfs_group_intent_hold(xg, __return_address);
     +	xfs_defer_drain_grab(&xg->xg_intents_drain);
     +	return xg;
      }
      
    @@ fs/xfs/xfs_drain.c: static inline bool xfs_defer_drain_busy(struct xfs_defer_dra
      void
     -xfs_perag_intent_put(
     -	struct xfs_perag	*pag)
     +xfs_group_intent_put(
     +	struct xfs_group	*xg)
      {
    --	trace_xfs_group_intent_rele(&pag->pag_group, __return_address);
    --	xfs_defer_drain_rele(&pag->pag_group.xg_intents_drain);
    +-	trace_xfs_group_intent_rele(pag_group(pag), __return_address);
    +-	xfs_defer_drain_rele(pag_group(pag).xg_intents_drain);
     -	xfs_perag_put(pag);
     +	trace_xfs_group_intent_rele(xg, __return_address);
     +	xfs_defer_drain_rele(&xg->xg_intents_drain);
     +	xfs_group_put(xg);
      }
      
    @@ fs/xfs/xfs_extfree_item.c: xfs_extent_free_diff_items(
      	const struct list_head		*b)
      {
      	struct xfs_extent_free_item	*ra = xefi_entry(a);
      	struct xfs_extent_free_item	*rb = xefi_entry(b);
      
     -	return pag_agno(ra->xefi_pag) - pag_agno(rb->xefi_pag);
    -+	return ra->xefi_group->xg_index - rb->xefi_group->xg_index;
    ++	return ra->xefi_group->xg_gno - rb->xefi_group->xg_gno;
      }
      
      /* Log a free extent to the intent item. */
      STATIC void
      xfs_extent_free_log_item(
      	struct xfs_trans		*tp,
    @@ fs/xfs/xfs_refcount_item.c: xfs_refcount_update_diff_items(
      	const struct list_head		*b)
      {
      	struct xfs_refcount_intent	*ra = ci_entry(a);
      	struct xfs_refcount_intent	*rb = ci_entry(b);
      
     -	return pag_agno(ra->ri_pag) - pag_agno(rb->ri_pag);
    -+	return ra->ri_group->xg_index - rb->ri_group->xg_index;
    ++	return ra->ri_group->xg_gno - rb->ri_group->xg_gno;
      }
      
      /* Log refcount updates in the intent item. */
      STATIC void
      xfs_refcount_update_log_item(
      	struct xfs_trans		*tp,
    @@ fs/xfs/xfs_rmap_item.c: xfs_rmap_update_diff_items(
      	const struct list_head		*b)
      {
      	struct xfs_rmap_intent		*ra = ri_entry(a);
      	struct xfs_rmap_intent		*rb = ri_entry(b);
      
     -	return pag_agno(ra->ri_pag) - pag_agno(rb->ri_pag);
    -+	return ra->ri_group->xg_index - rb->ri_group->xg_index;
    ++	return ra->ri_group->xg_gno - rb->ri_group->xg_gno;
      }
      
      /* Log rmap updates in the intent item. */
      STATIC void
      xfs_rmap_update_log_item(
      	struct xfs_trans		*tp,
 50:  58b8828d14947e !  57:  f50cfc80e92451 xfs: constify the xfs_sb predicates
    @@ Commit message
         xfs: constify the xfs_sb predicates
     
         Change the xfs_sb predicates to take a const struct xfs_sb pointer
         because they do not change the superblock.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/libxfs/xfs_format.h ##
     @@ fs/xfs/libxfs/xfs_format.h: struct xfs_dsb {
       * define max. shared version we can interoperate with
       */
      #define XFS_SB_MAX_SHARED_VN	0
 51:  8506a977d0d901 !  58:  94fde8e8c74d19 xfs: constify the xfs_inode predicates
    @@ Commit message
         xfs: constify the xfs_inode predicates
     
         Change the xfs_inode predicates to take a const struct xfs_inode pointer
         because they do not change the inode.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/xfs_inode.c ##
     @@ fs/xfs/xfs_inode.c: xfs_inode_alloc_unitsize(
      	return XFS_FSB_TO_B(ip->i_mount, blocks);
      }
      
  -:  -------------- >  59:  6e55219914528e xfs: rename metadata inode predicates
  -:  -------------- >  60:  3f4162c0477f75 xfs: standardize EXPERIMENTAL warning generation
 52:  2e159aa7a2c1a7 !  61:  05dfc1dd1b85b0 xfs: define the on-disk format for the metadir feature
    @@ fs/xfs/libxfs/xfs_format.h: xfs_sb_has_ro_compat_feature(
      #define XFS_SB_FEAT_INCOMPAT_ALL \
      		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
      		 XFS_SB_FEAT_INCOMPAT_SPINODES | \
      		 XFS_SB_FEAT_INCOMPAT_META_UUID | \
      		 XFS_SB_FEAT_INCOMPAT_BIGTIME | \
      		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR | \
    -@@ fs/xfs/libxfs/xfs_format.h: xfs_sb_add_incompat_log_features(
    - static inline bool xfs_sb_version_haslogxattrs(const struct xfs_sb *sbp)
    - {
    - 	return xfs_sb_is_v5(sbp) && (sbp->sb_features_log_incompat &
    - 		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
    - }
    - 
    -+static inline bool xfs_sb_version_hasmetadir(const struct xfs_sb *sbp)
    -+{
    -+	return xfs_sb_is_v5(sbp) &&
    -+	       (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR);
    -+}
    -+
    - static inline bool
    - xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
    - {
    - 	return (ino == sbp->sb_uquotino ||
    - 		ino == sbp->sb_gquotino ||
    - 		ino == sbp->sb_pquotino);
     @@ fs/xfs/libxfs/xfs_format.h: static inline uint64_t xfs_unix_to_bigtime(time64_t unix_seconds)
      /* Convert a timestamp from the bigtime epoch to the Unix epoch. */
      static inline time64_t xfs_bigtime_to_unix(uint64_t ondisk_seconds)
      {
      	return (time64_t)ondisk_seconds - XFS_BIGTIME_EPOCH_OFFSET;
      }
    @@ fs/xfs/libxfs/xfs_format.h: static inline time64_t xfs_bigtime_to_unix(uint64_t
      struct xfs_dinode {
      	__be16		di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
      	__be16		di_mode;	/* mode and type of file */
      	__u8		di_version;	/* inode version */
      	__u8		di_format;	/* format of di_c data */
     -	__be16		di_onlink;	/* old number of links to file */
    -+	union {
    -+		__be16	di_onlink;	/* old number of links to file */
    -+		__be16	di_metatype;	/* XFS_METAFILE_* */
    -+	} __packed; /* explicit packing because arm gcc bloats this up */
    ++	__be16		di_metatype;	/* XFS_METAFILE_*; was di_onlink */
      	__be32		di_uid;		/* owner's user id */
      	__be32		di_gid;		/* owner's group id */
      	__be32		di_nlink;	/* number of links to file */
      	__be16		di_projid_lo;	/* lower part of owner's project id */
      	__be16		di_projid_hi;	/* higher part owner's project id */
      	union {
     @@ fs/xfs/libxfs/xfs_format.h: static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
    + 	 XFS_DIFLAG_EXTSZINHERIT | XFS_DIFLAG_NODEFRAG | XFS_DIFLAG_FILESTREAM)
    + 
    + /*
    +  * Values for di_flags2 These start by being exposed to userspace in the upper
       * 16 bits of the XFS_XFLAG_s range.
       */
    - #define XFS_DIFLAG2_DAX_BIT	0	/* use DAX for this inode */
    - #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
    - #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
    - #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
    +-#define XFS_DIFLAG2_DAX_BIT	0	/* use DAX for this inode */
    +-#define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
    +-#define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
    +-#define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
     -#define XFS_DIFLAG2_NREXT64_BIT 4	/* large extent counters */
    -+#define XFS_DIFLAG2_NREXT64_BIT	4	/* large extent counters */
    -+#define XFS_DIFLAG2_METADATA_BIT	63	/* filesystem metadata */
    - 
    +-
     -#define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
     -#define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
     -#define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
     -#define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
     -#define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
    -+#define XFS_DIFLAG2_DAX		(1ULL << XFS_DIFLAG2_DAX_BIT)
    -+#define XFS_DIFLAG2_REFLINK	(1ULL << XFS_DIFLAG2_REFLINK_BIT)
    -+#define XFS_DIFLAG2_COWEXTSIZE	(1ULL << XFS_DIFLAG2_COWEXTSIZE_BIT)
    -+#define XFS_DIFLAG2_BIGTIME	(1ULL << XFS_DIFLAG2_BIGTIME_BIT)
    -+#define XFS_DIFLAG2_NREXT64	(1ULL << XFS_DIFLAG2_NREXT64_BIT)
    ++/* use DAX for this inode */
    ++#define XFS_DIFLAG2_DAX_BIT		0
    ++
    ++/* file's blocks may be shared */
    ++#define XFS_DIFLAG2_REFLINK_BIT		1
    ++
    ++/* copy on write extent size hint */
    ++#define XFS_DIFLAG2_COWEXTSIZE_BIT	2
    ++
    ++/* big timestamps */
    ++#define XFS_DIFLAG2_BIGTIME_BIT		3
    ++
    ++/* large extent counters */
    ++#define XFS_DIFLAG2_NREXT64_BIT		4
     +
     +/*
     + * The inode contains filesystem metadata and can be found through the metadata
     + * directory tree.  Metadata inodes must satisfy the following constraints:
     + *
     + * - V5 filesystem (and ftype) are enabled;
    @@ fs/xfs/libxfs/xfs_format.h: static inline void xfs_dinode_put_rdev(struct xfs_di
     + * - They must never be accessed by userspace;
     + * - Metadata directory entries must have correct ftype.
     + *
     + * Superblock-rooted metadata files must have the METADATA iflag set even
     + * though they do not have a parent directory.
     + */
    ++#define XFS_DIFLAG2_METADATA_BIT	5
    ++
    ++#define XFS_DIFLAG2_DAX		(1ULL << XFS_DIFLAG2_DAX_BIT)
    ++#define XFS_DIFLAG2_REFLINK	(1ULL << XFS_DIFLAG2_REFLINK_BIT)
    ++#define XFS_DIFLAG2_COWEXTSIZE	(1ULL << XFS_DIFLAG2_COWEXTSIZE_BIT)
    ++#define XFS_DIFLAG2_BIGTIME	(1ULL << XFS_DIFLAG2_BIGTIME_BIT)
    ++#define XFS_DIFLAG2_NREXT64	(1ULL << XFS_DIFLAG2_NREXT64_BIT)
     +#define XFS_DIFLAG2_METADATA	(1ULL << XFS_DIFLAG2_METADATA_BIT)
      
      #define XFS_DIFLAG2_ANY \
      	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
     -	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
     +	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADATA)
      
      static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
      {
      	return dip->di_version >= 3 &&
      	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME));
      }
    +@@ fs/xfs/libxfs/xfs_format.h: static inline bool xfs_dinode_has_large_extent_counts(
    + 	const struct xfs_dinode *dip)
    + {
    + 	return dip->di_version >= 3 &&
    + 	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64));
    + }
    + 
    ++static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
    ++{
    ++	return dip->di_version >= 3 &&
    ++	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA));
    ++}
    ++
    + /*
    +  * Inode number format:
    +  * low inopblog bits - offset in block
    +  * next agblklog bits - block number in ag
    +  * next agno_log bits - ag number
    +  * high agno_log-agblklog-inopblog bits - 0
     
      ## fs/xfs/libxfs/xfs_inode_buf.c ##
     @@ fs/xfs/libxfs/xfs_inode_buf.c: xfs_inode_from_disk(
    - 		set_nlink(inode, be16_to_cpu(from->di_onlink));
    + 	/*
    + 	 * Convert v1 inodes immediately to v2 inode format as this is the
    + 	 * minimum inode version format we support in the rest of the code.
    + 	 * They will also be unconditionally written back to disk as v2 inodes.
    + 	 */
    + 	if (unlikely(from->di_version == 1)) {
    +-		set_nlink(inode, be16_to_cpu(from->di_onlink));
    ++		/* di_metatype used to be di_onlink */
    ++		set_nlink(inode, be16_to_cpu(from->di_metatype));
      		ip->i_projid = 0;
      	} else {
      		set_nlink(inode, be32_to_cpu(from->di_nlink));
      		ip->i_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
      					be16_to_cpu(from->di_projid_lo);
    -+		if (from->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA))
    ++		if (xfs_dinode_is_metadir(from))
     +			ip->i_metatype = be16_to_cpu(from->di_metatype);
      	}
      
      	i_uid_write(inode, be32_to_cpu(from->di_uid));
      	i_gid_write(inode, be32_to_cpu(from->di_gid));
      
    @@ fs/xfs/libxfs/xfs_inode_buf.c: xfs_inode_to_disk(
      
      	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
     -	to->di_onlink = 0;
     +	if (xfs_is_metadir_inode(ip))
     +		to->di_metatype = cpu_to_be16(ip->i_metatype);
     +	else
    -+		to->di_onlink = 0;
    ++		to->di_metatype = 0;
      
      	to->di_format = xfs_ifork_format(&ip->i_df);
      	to->di_uid = cpu_to_be32(i_uid_read(inode));
      	to->di_gid = cpu_to_be32(i_gid_read(inode));
      	to->di_projid_lo = cpu_to_be16(ip->i_projid & 0xffff);
      	to->di_projid_hi = cpu_to_be16(ip->i_projid >> 16);
    @@ fs/xfs/libxfs/xfs_inode_buf.c: xfs_dinode_verify(
      	 * ondisk inode, it would set both the ondisk di_nlink and di_onlink to
      	 * the the incore di_nlink value, which is why we cannot check for
      	 * di_nlink==0 on a V1 inode.  V2/3 inodes would get written out with
      	 * di_onlink==0, so we can check that.
      	 */
     -	if (dip->di_version >= 2) {
    +-		if (dip->di_onlink)
     +	if (dip->di_version == 2) {
    - 		if (dip->di_onlink)
    - 			return __this_address;
    -+	} else if (dip->di_version >= 3) {
    -+		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)) &&
    -+		    dip->di_onlink)
    ++		if (dip->di_metatype)
     +			return __this_address;
    ++	} else if (dip->di_version >= 3) {
    ++		if (!xfs_dinode_is_metadir(dip) && dip->di_metatype)
    + 			return __this_address;
      	}
      
      	/* don't allow invalid i_size */
      	di_size = be64_to_cpu(dip->di_size);
      	if (di_size & (1ULL << 63))
    - 		return __this_address;
    +@@ fs/xfs/libxfs/xfs_inode_buf.c: xfs_dinode_verify(
    + 	 */
    + 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0) {
    + 		if (dip->di_version > 1) {
    + 			if (dip->di_nlink)
    + 				return __this_address;
    + 		} else {
    +-			if (dip->di_onlink)
    ++			/* di_metatype used to be di_onlink */
    ++			if (dip->di_metatype)
    + 				return __this_address;
    + 		}
    + 	}
    + 
    + 	fa = xfs_dinode_verify_nrext64(mp, dip);
    + 	if (fa)
     
      ## fs/xfs/libxfs/xfs_inode_util.c ##
     @@ fs/xfs/libxfs/xfs_inode_util.c: xfs_inode_inherit_flags2(
      	if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
      		ip->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
      		ip->i_cowextsize = pip->i_cowextsize;
      	}
      	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
      		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
    -+	if (pip->i_diflags2 & XFS_DIFLAG2_METADATA)
    ++	if (xfs_is_metadir_inode(pip))
     +		ip->i_diflags2 |= XFS_DIFLAG2_METADATA;
      
      	/* Don't let invalid cowextsize hints propagate. */
      	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
      			VFS_I(ip)->i_mode, ip->i_diflags, ip->i_diflags2);
      	if (failaddr) {
    @@ fs/xfs/scrub/inode.c: xchk_dinode(
      		xchk_ino_set_preen(sc, ino);
      		prid = 0;
      		break;
      	case 2:
      	case 3:
     -		if (dip->di_onlink != 0)
    -+		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)) &&
    -+		    dip->di_onlink != 0)
    ++		if (!xfs_dinode_is_metadir(dip) && dip->di_metatype)
      			xchk_ino_set_corrupt(sc, ino);
      
      		if (dip->di_mode == 0 && sc->ip)
      			xchk_ino_set_corrupt(sc, ino);
      
      		if (dip->di_projid_hi != 0 &&
    @@ fs/xfs/scrub/inode_repair.c: xrep_dinode_mode(
     -	else
     +	if (dip->di_version < 2) {
      		dip->di_nlink = 0;
     +		return;
     +	}
     +
    -+	if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)))
    -+		dip->di_onlink = 0;
    ++	if (!xfs_dinode_is_metadir(dip))
    ++		dip->di_metatype = 0;
      }
      
      /* Fix any conflicting flags that the verifiers complain about. */
      STATIC void
      xrep_dinode_flags(
      	struct xfs_scrub	*sc,
    @@ fs/xfs/xfs_inode.h: xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned long flags
      
     +static inline bool xfs_is_metadir_inode(const struct xfs_inode *ip)
     +{
     +	return ip->i_diflags2 & XFS_DIFLAG2_METADATA;
     +}
     +
    - static inline bool xfs_is_metadata_inode(const struct xfs_inode *ip)
    + static inline bool xfs_is_internal_inode(const struct xfs_inode *ip)
      {
      	struct xfs_mount	*mp = ip->i_mount;
      
     +	/* Any file in the metadata directory tree is a metadata inode. */
     +	if (xfs_has_metadir(mp))
     +		return xfs_is_metadir_inode(ip);
    @@ fs/xfs/xfs_inode_item_recover.c: xfs_log_dinode_to_disk(
      {
      	to->di_magic = cpu_to_be16(from->di_magic);
      	to->di_mode = cpu_to_be16(from->di_mode);
      	to->di_version = from->di_version;
      	to->di_format = from->di_format;
     -	to->di_onlink = 0;
    -+	if (from->di_flags2 & XFS_DIFLAG2_METADATA)
    -+		to->di_metatype = cpu_to_be16(from->di_metatype);
    -+	else
    -+		to->di_onlink = 0;
    ++	to->di_metatype = cpu_to_be16(from->di_metatype);
      	to->di_uid = cpu_to_be32(from->di_uid);
      	to->di_gid = cpu_to_be32(from->di_gid);
      	to->di_nlink = cpu_to_be32(from->di_nlink);
      	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
      	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
      
     
    + ## fs/xfs/xfs_message.c ##
    +@@ fs/xfs/xfs_message.c: xfs_warn_experimental(
    + 			.name		= "exchange range",
    + 		},
    + 		[XFS_EXPERIMENTAL_PPTR] = {
    + 			.opstate	= XFS_OPSTATE_WARNED_PPTR,
    + 			.name		= "parent pointer",
    + 		},
    ++		[XFS_EXPERIMENTAL_METADIR] = {
    ++			.opstate	= XFS_OPSTATE_WARNED_METADIR,
    ++			.name		= "metadata directory tree",
    ++		},
    + 	};
    + 	ASSERT(feat >= 0 && feat < XFS_EXPERIMENTAL_MAX);
    + 	BUILD_BUG_ON(ARRAY_SIZE(features) != XFS_EXPERIMENTAL_MAX);
    + 
    + 	if (xfs_should_warn(mp, features[feat].opstate))
    + 		xfs_warn(mp,
    +
    + ## fs/xfs/xfs_message.h ##
    +@@ fs/xfs/xfs_message.h: enum xfs_experimental_feat {
    + 	XFS_EXPERIMENTAL_SCRUB,
    + 	XFS_EXPERIMENTAL_SHRINK,
    + 	XFS_EXPERIMENTAL_LARP,
    + 	XFS_EXPERIMENTAL_LBS,
    + 	XFS_EXPERIMENTAL_EXCHRANGE,
    + 	XFS_EXPERIMENTAL_PPTR,
    ++	XFS_EXPERIMENTAL_METADIR,
    + 
    + 	XFS_EXPERIMENTAL_MAX,
    + };
    + void xfs_warn_experimental(struct xfs_mount *mp, enum xfs_experimental_feat f);
    + 
    + #endif	/* __XFS_MESSAGE_H */
    +
      ## fs/xfs/xfs_mount.h ##
     @@ fs/xfs/xfs_mount.h: typedef struct xfs_mount {
      #define XFS_FEAT_REALTIME	(1ULL << 22)	/* realtime device present */
      #define XFS_FEAT_INOBTCNT	(1ULL << 23)	/* inobt block counts */
      #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
      #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
    @@ fs/xfs/xfs_mount.h: __XFS_HAS_FEAT(metauuid, META_UUID)
      
      /*
       * Some features are always on for v5 file systems, allow the compiler to
       * eliminiate dead code when building without v4 support.
       */
      #define __XFS_HAS_V4_FEAT(name, NAME) \
    +@@ fs/xfs/xfs_mount.h: __XFS_HAS_FEAT(nouuid, NOUUID)
    + /* Kernel has logged a warning about blocksize > pagesize on this fs. */
    + #define XFS_OPSTATE_WARNED_LBS		13
    + /* Kernel has logged a warning about exchange-range being used on this fs. */
    + #define XFS_OPSTATE_WARNED_EXCHRANGE	14
    + /* Kernel has logged a warning about parent pointers being used on this fs. */
    + #define XFS_OPSTATE_WARNED_PPTR		15
    ++/* Kernel has logged a warning about metadata dirs being used on this fs. */
    ++#define XFS_OPSTATE_WARNED_METADIR	16
    + 
    + #define __XFS_IS_OPSTATE(name, NAME) \
    + static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
    + { \
    + 	return test_bit(XFS_OPSTATE_ ## NAME, &mp->m_opstate); \
    + } \
     
      ## fs/xfs/xfs_super.c ##
     @@ fs/xfs/xfs_super.c: xfs_fs_fill_super(
      	if (xfs_has_discard(mp) && !bdev_max_discard_sectors(sb->s_bdev)) {
      		xfs_warn(mp,
      	"mounting with \"discard\" option, but the device does not support discard");
      		mp->m_features &= ~XFS_FEAT_DISCARD;
      	}
      
     +	if (xfs_has_metadir(mp))
    -+		xfs_warn(mp,
    -+"EXPERIMENTAL metadata directory feature in use. Use at your own risk!");
    ++		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_METADIR);
     +
      	if (xfs_has_reflink(mp)) {
      		if (mp->m_sb.sb_rblocks) {
      			xfs_alert(mp,
      	"reflink not compatible with realtime device!");
      			error = -EINVAL;
 53:  5cc92783e72e05 <   -:  -------------- xfs: undefine the sb_bad_features2 when metadir is enabled
 54:  e627b35d04f177 !  62:  111c18a7a0ea85 xfs: iget for metadata inodes
    @@
      ## Metadata ##
     Author: Darrick J. Wong <djwong@kernel.org>
     
      ## Commit message ##
         xfs: iget for metadata inodes
     
    -    Create a xfs_metafile_iget function for metadata inodes to ensure that
    -    when we try to iget a metadata file, the inobt thinks a metadata inode
    -    is in use and that the metadata type matches what we are expecting.
    +    Create a xfs_trans_metafile_iget function for metadata inodes to ensure
    +    that when we try to iget a metadata file, the inode is allocated and its
    +    file mode matches the metadata file type the caller expects.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
         Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/libxfs/xfs_metafile.h (new) ##
     @@
    @@ fs/xfs/xfs_icache.c: xfs_iget(
      	}
      	xfs_perag_put(pag);
      	return error;
      }
      
     +/*
    -+ * Get a metadata inode.  The metafile @type must match the inode exactly.
    -+ * Caller must supply a transaction (even if empty) to avoid livelocking if the
    -+ * inobt has a cycle.
    ++ * Get a metadata inode.
    ++ *
    ++ * The metafile type must match the file mode exactly.
     + */
     +int
     +xfs_trans_metafile_iget(
     +	struct xfs_trans	*tp,
     +	xfs_ino_t		ino,
     +	enum xfs_metafile_type	metafile_type,
    @@ fs/xfs/xfs_icache.c: xfs_iget(
     +{
     +	struct xfs_mount	*mp = tp->t_mountp;
     +	struct xfs_inode	*ip;
     +	umode_t			mode;
     +	int			error;
     +
    -+	error = xfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, 0, &ip);
    ++	error = xfs_iget(mp, tp, ino, 0, 0, &ip);
     +	if (error == -EFSCORRUPTED)
     +		goto whine;
     +	if (error)
     +		return error;
     +
     +	if (VFS_I(ip)->i_nlink == 0)
 55:  0bc05c4a7cde0f =  63:  37a63bf84cb00b xfs: load metadata directory root at mount time
 56:  bbefee90e32afc !  64:  57185abf466b59 xfs: enforce metadata inode flag
    @@ fs/xfs/scrub/common.c: xchk_iget_for_scrubbing(
      
      	/* We want to scan the inode we already had opened. */
      	if (sc->sm->sm_ino == 0 || sc->sm->sm_ino == ip_in->i_ino)
      		return xchk_install_live_inode(sc, ip_in);
      
     -	/* Reject internal metadata files and obviously bad inode numbers. */
    --	if (xfs_internal_inum(mp, sc->sm->sm_ino))
    +-	if (xfs_is_sb_inum(mp, sc->sm->sm_ino))
     +	/*
     +	 * On pre-metadir filesystems, reject internal metadata files.  For
     +	 * metadir filesystems, limited scrubbing of any file in the metadata
     +	 * directory tree by handle is allowed, because that is the only way to
     +	 * validate the lack of parent pointers in the sb-root metadata inodes.
     +	 */
    -+	if (!xfs_has_metadir(mp) && xfs_internal_inum(mp, sc->sm->sm_ino))
    ++	if (!xfs_has_metadir(mp) && xfs_is_sb_inum(mp, sc->sm->sm_ino))
      		return -ENOENT;
     +	/* Reject obviously bad inode numbers. */
      	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
      		return -ENOENT;
      
      	/* Try a safe untrusted iget. */
    @@ fs/xfs/scrub/inode.c: xchk_setup_inode(
      			return error;
      
      		return xchk_prepare_iscrub(sc);
      	}
      
     -	/* Reject internal metadata files and obviously bad inode numbers. */
    --	if (xfs_internal_inum(mp, sc->sm->sm_ino))
    +-	if (xfs_is_sb_inum(mp, sc->sm->sm_ino))
     +	/*
     +	 * On pre-metadir filesystems, reject internal metadata files.  For
     +	 * metadir filesystems, limited scrubbing of any file in the metadata
     +	 * directory tree by handle is allowed, because that is the only way to
     +	 * validate the lack of parent pointers in the sb-root metadata inodes.
     +	 */
    -+	if (!xfs_has_metadir(mp) && xfs_internal_inum(mp, sc->sm->sm_ino))
    ++	if (!xfs_has_metadir(mp) && xfs_is_sb_inum(mp, sc->sm->sm_ino))
      		return -ENOENT;
     +	/* Reject obviously bad inode numbers. */
      	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
      		return -ENOENT;
      
      	/* Try a safe untrusted iget. */
    @@ fs/xfs/scrub/inode_repair.c: xrep_dinode_flags(
      }
      
      /*
       * Blow out symlink; now it points nowhere.  We don't have to worry about
     
      ## fs/xfs/xfs_icache.c ##
    +@@ fs/xfs/xfs_icache.c: xfs_iget(
    + 	return error;
    + }
    + 
    + /*
    +  * Get a metadata inode.
    +  *
    +- * The metafile type must match the file mode exactly.
    ++ * The metafile type must match the file mode exactly, and for files in the
    ++ * metadata directory tree, it must match the inode's metatype exactly.
    +  */
    + int
    + xfs_trans_metafile_iget(
    + 	struct xfs_trans	*tp,
    + 	xfs_ino_t		ino,
    + 	enum xfs_metafile_type	metafile_type,
     @@ fs/xfs/xfs_icache.c: xfs_trans_metafile_iget(
      	if (metafile_type == XFS_METAFILE_DIR)
      		mode = S_IFDIR;
      	else
      		mode = S_IFREG;
      	if (inode_wrong_type(VFS_I(ip), mode))
 57:  b4fb353281189c !  65:  077549d591bec3 xfs: read and write metadata inode directory tree
    @@ fs/xfs/xfs_icache.c
     @@ fs/xfs/xfs_icache.c: xfs_trans_metafile_iget(
      	struct xfs_mount	*mp = tp->t_mountp;
      	struct xfs_inode	*ip;
      	umode_t			mode;
      	int			error;
      
    - 	error = xfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, 0, &ip);
    + 	error = xfs_iget(mp, tp, ino, 0, 0, &ip);
     -	if (error == -EFSCORRUPTED)
     +	if (error == -EFSCORRUPTED || error == -EINVAL)
      		goto whine;
      	if (error)
      		return error;
      
 58:  5ef41faba24ba7 =  66:  5137177126b780 xfs: disable the agi rotor for metadata inodes
 59:  dc1e6452de9240 !  67:  aaf73a065b3f72 xfs: hide metadata inodes from everyone because they are special
    @@ fs/xfs/xfs_iops.c: xfs_diflags_to_iflags(
      void
      xfs_setup_inode(
      	struct xfs_inode	*ip)
      {
      	struct inode		*inode = &ip->i_vnode;
      	gfp_t			gfp_mask;
    -+	bool			is_meta = xfs_is_metadata_inode(ip);
    ++	bool			is_meta = xfs_is_internal_inode(ip);
      
      	inode->i_ino = ip->i_ino;
      	inode->i_state |= I_NEW;
      
      	inode_sb_list_add(inode);
      	/* make the inode look hashed for the writeback code */
 60:  9e3c119af4266c =  68:  78d53e6641adf6 xfs: advertise metadata directory feature
 61:  ff8947118744d4 !  69:  b90d23e8b80940 xfs: allow bulkstat to return metadata directories
    @@ fs/xfs/xfs_itable.c: xfs_bulkstat_one_int(
      	struct xfs_bulkstat	*buf = bc->buf;
      	xfs_extnum_t		nextents;
      	int			error = -EINVAL;
      	vfsuid_t		vfsuid;
      	vfsgid_t		vfsgid;
      
    --	if (xfs_internal_inum(mp, ino))
    +-	if (xfs_is_sb_inum(mp, ino))
     -		goto out_advance;
     -
      	error = xfs_iget(mp, tp, ino,
      			 (XFS_IGET_DONTCACHE | XFS_IGET_UNTRUSTED),
      			 XFS_ILOCK_SHARED, &ip);
      	if (error == -ENOENT || error == -EINVAL)
    @@ fs/xfs/xfs_itable.c: xfs_bulkstat_one_int(
     +			goto out_advance;
     +		goto out;
     +	}
     +
      	/* If this is a private inode, don't leak its details to userspace. */
     -	if (IS_PRIVATE(inode)) {
    -+	if (IS_PRIVATE(inode) || xfs_internal_inum(mp, ino)) {
    ++	if (IS_PRIVATE(inode) || xfs_is_sb_inum(mp, ino)) {
      		xfs_iunlock(ip, XFS_ILOCK_SHARED);
      		xfs_irele(ip);
      		error = -EINVAL;
      		goto out_advance;
      	}
      
 62:  e43c5a84f8377d =  70:  5eaf4c29df8847 xfs: don't count metadata directory files to quota
 63:  4d2422ed3dcb28 =  71:  4fb1d33732709b xfs: mark quota inodes as metadata files
 64:  85e1a2a8b78774 =  72:  98b04e38475455 xfs: adjust xfs_bmap_add_attrfork for metadir
 65:  76f802d0197880 =  73:  fa0ecd8e92d317 xfs: record health problems with the metadata directory
 66:  38423576e988b9 !  74:  8a0576a871e715 xfs: refactor directory tree root predicates
    @@ fs/xfs/scrub/common.c: xchk_inode_is_allocated(
     +
     +/* Does the superblock point down to this inode? */
     +bool
     +xchk_inode_is_sb_rooted(const struct xfs_inode *ip)
     +{
     +	return xchk_inode_is_dirtree_root(ip) ||
    -+	       xfs_internal_inum(ip->i_mount, ip->i_ino);
    ++	       xfs_is_sb_inum(ip->i_mount, ip->i_ino);
     +}
     +
     +/* What is the root directory inumber for this inode? */
     +xfs_ino_t
     +xchk_inode_rootdir_inum(const struct xfs_inode *ip)
     +{
    @@ fs/xfs/scrub/inode_repair.c: xrep_inode_pptr(
     -		return 0;
     -
     -	/*
     -	 * Metadata inodes are rooted in the superblock and do not have any
     -	 * parents.
     -	 */
    --	if (xfs_is_metadata_inode(ip))
    +-	if (xfs_is_internal_inode(ip))
     +	/* Children of the superblock do not have parent pointers. */
     +	if (xchk_inode_is_sb_rooted(ip))
      		return 0;
      
      	/* Inode already has an attr fork; no further work possible here. */
      	if (xfs_inode_has_attr_fork(ip))
    @@ fs/xfs/scrub/orphanage.c: xrep_orphanage_can_adopt(
      	ASSERT(sc->ip != NULL);
      
      	if (!sc->orphanage)
      		return false;
      	if (sc->ip == sc->orphanage)
      		return false;
    --	if (xfs_internal_inum(sc->mp, sc->ip->i_ino))
    +-	if (xfs_is_sb_inum(sc->mp, sc->ip->i_ino))
     +	if (xchk_inode_is_sb_rooted(sc->ip))
     +		return false;
    -+	if (xfs_is_metadata_inode(sc->ip))
    ++	if (xfs_is_internal_inode(sc->ip))
      		return false;
      	return true;
      }
      
      /*
       * Create a new transaction to send a child to the orphanage.
    @@ fs/xfs/scrub/parent.c: xchk_pptr_looks_zapped(
     -	 * any parents.  Hence the attr fork will not be initialized, but
     -	 * there are no parent pointers that might have been zapped.
     +	 * Metadata inodes that are rooted in the superblock do not have any
     +	 * parents.  Hence the attr fork will not be initialized, but there are
     +	 * no parent pointers that might have been zapped.
      	 */
    --	if (xfs_is_metadata_inode(ip))
    +-	if (xfs_is_internal_inode(ip))
     +	if (xchk_inode_is_sb_rooted(ip))
      		return false;
      
      	/*
      	 * Linked and linkable non-rootdir files should always have an
      	 * attribute fork because that is where parent pointers are
 67:  599ed6b8b7efe1 =  75:  de5c579cddcfff xfs: do not count metadata directory files when doing online quotacheck
 68:  1d07ecba96cf19 =  76:  ab81e24a0e7765 xfs: don't fail repairs on metadata files with no attr fork
 69:  76477f9860b7d2 =  77:  5c3c5a59d7e3fa xfs: metadata files can have xattrs if metadir is enabled
 70:  600820be3c88f0 =  78:  f3f4044982526d xfs: adjust parent pointer scrubber for sb-rooted metadata files
 71:  34b13f6b9c18f2 !  79:  4ef04dca6bb7e7 xfs: fix di_metatype field of inodes that won't load
    @@ fs/xfs/scrub/inode.c: xchk_dinode(
      		 */
      		xchk_ino_set_preen(sc, ino);
      		prid = 0;
      		break;
      	case 2:
      	case 3:
    --		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)) &&
    --		    dip->di_onlink != 0)
    +-		if (!xfs_dinode_is_metadir(dip) && dip->di_metatype)
     -			xchk_ino_set_corrupt(sc, ino);
    -+		if (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)) {
    ++		if (xfs_dinode_is_metadir(dip)) {
     +			if (be16_to_cpu(dip->di_metatype) >= XFS_METAFILE_MAX)
     +				xchk_ino_set_corrupt(sc, ino);
     +		} else {
    -+			if (dip->di_onlink != 0)
    ++			if (dip->di_metatype != 0)
     +				xchk_ino_set_corrupt(sc, ino);
     +		}
      
      		if (dip->di_mode == 0 && sc->ip)
      			xchk_ino_set_corrupt(sc, ino);
      
    @@ fs/xfs/scrub/inode_repair.c: xrep_dinode_nlinks(
      {
      	if (dip->di_version < 2) {
      		dip->di_nlink = 0;
      		return;
      	}
      
    --	if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)))
    -+	if (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)) {
    +-	if (!xfs_dinode_is_metadir(dip))
    ++	if (xfs_dinode_is_metadir(dip)) {
     +		if (be16_to_cpu(dip->di_metatype) >= XFS_METAFILE_MAX)
     +			dip->di_metatype = cpu_to_be16(XFS_METAFILE_UNKNOWN);
     +	} else {
    - 		dip->di_onlink = 0;
    + 		dip->di_metatype = 0;
     +	}
      }
      
      /* Fix any conflicting flags that the verifiers complain about. */
      STATIC void
      xrep_dinode_flags(
 72:  99ba075d8d10bc =  80:  a09e505f9e33f2 xfs: scrub metadata directories
 73:  3d0a6e0f904b52 =  81:  07ae29125fb55a xfs: check the metadata directory inumber in superblocks
 74:  0584f4ffbce138 =  82:  ba818cd4f4352c xfs: move repair temporary files to the metadata directory tree
 75:  43e89a12dac115 =  83:  6d2aea9f6691bc xfs: check metadata directory file path connectivity
 76:  926b95a32fdf86 =  84:  d0dc6e601a5b26 xfs: confirm dotdot target before replacing it during a repair
 77:  5489485ca2f0a6 =  85:  25d9d5cabee352 xfs: repair metadata directory file path connectivity
 78:  5817ffec03df50 !  86:  fe3d5582a81409 xfs: clean up xfs_getfsmap_helper arguments
    @@ fs/xfs/xfs_fsmap.c: xfs_getfsmap_format(
     @@ fs/xfs/xfs_fsmap.c: xfs_getfsmap_helper(
      	/* Fill out the extent we found */
      	if (info->head->fmh_entries >= info->head->fmh_count)
      		return -ECANCELED;
      
      	trace_xfs_fsmap_mapping(mp, info->dev,
    - 			info->group ? info->group->xg_index : NULLAGNUMBER,
    + 			info->group ? info->group->xg_gno : NULLAGNUMBER,
     -			rec);
     +			frec);
      
      	fmr.fmr_device = info->dev;
     -	fmr.fmr_physical = rec_daddr;
     -	error = xfs_fsmap_owner_from_rmap(&fmr, rec);
 79:  f6b47d08f3706d !  87:  07e0f82f26cb32 xfs: create incore realtime group structures
    @@ fs/xfs/libxfs/xfs_format.h: typedef struct xfs_sb {
      } xfs_sb_t;
      
      /*
       * Superblock - on disk version.
       * Must be padded to 64 bit alignment.
     
    - ## fs/xfs/libxfs/xfs_group.c ##
    -@@
    - #include "xfs_mount.h"
    - #include "xfs_error.h"
    - #include "xfs_trace.h"
    - #include "xfs_extent_busy.h"
    - #include "xfs_group.h"
    - #include "xfs_ag.h"
    -+#include "xfs_rtgroup.h"
    - 
    - /*
    -  * Groups can have passive and active references.
    -  *
    -  * For passive references the code freeing a group is responsible for cleaning
    -  * up objects that hold the passive references (e.g. cached buffers).
    -@@ fs/xfs/libxfs/xfs_group.c: xfs_group_insert(
    - 
    - xfs_fsblock_t
    - xfs_gbno_to_fsb(
    - 	struct xfs_group	*xg,
    - 	xfs_agblock_t		gbno)
    - {
    -+	if (xg->xg_type == XG_TYPE_RTG)
    -+		return xfs_rgbno_to_rtb(to_rtg(xg), gbno);
    - 	return xfs_agbno_to_fsb(to_perag(xg), gbno);
    - }
    - 
    - xfs_daddr_t
    - xfs_gbno_to_daddr(
    - 	struct xfs_group	*xg,
    - 	xfs_agblock_t		gbno)
    - {
    -+	if (xg->xg_type == XG_TYPE_RTG)
    -+		return xfs_rtb_to_daddr(xg->xg_mount,
    -+			xfs_rgbno_to_rtb(to_rtg(xg), gbno));
    - 	return xfs_agbno_to_daddr(to_perag(xg), gbno);
    - }
    - 
    - uint32_t
    - xfs_fsb_to_gno(
    - 	struct xfs_mount	*mp,
    - 	xfs_fsblock_t		fsbno,
    - 	enum xfs_group_type	type)
    - {
    -+	if (type == XG_TYPE_RTG)
    -+		return xfs_rtb_to_rgno(mp, fsbno);
    - 	return XFS_FSB_TO_AGNO(mp, fsbno);
    - }
    - 
    - struct xfs_group *
    - xfs_group_get_by_fsb(
    - 	struct xfs_mount	*mp,
    -
      ## fs/xfs/libxfs/xfs_rtgroup.c (new) ##
     @@
     +// SPDX-License-Identifier: GPL-2.0-or-later
     +/*
     + * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
     + * Author: Darrick J. Wong <djwong@kernel.org>
    @@ fs/xfs/libxfs/xfs_rtgroup.c (new)
     +	int			error;
     +
     +	rtg = kzalloc(sizeof(struct xfs_rtgroup), GFP_KERNEL);
     +	if (!rtg)
     +		return -ENOMEM;
     +
    -+	error = xfs_group_insert(mp, &rtg->rtg_group, rgno, XG_TYPE_RTG);
    ++	error = xfs_group_insert(mp, rtg_group(rtg), rgno, XG_TYPE_RTG);
     +	if (error)
     +		goto out_free_rtg;
     +	return 0;
     +
     +out_free_rtg:
     +	kfree(rtg);
    @@ fs/xfs/libxfs/xfs_rtgroup.c (new)
     +	struct xfs_mount	*mp,
     +	xfs_rgnumber_t		rgno)
     +{
     +	return __xfs_rtgroup_extents(mp, rgno, mp->m_sb.sb_rgcount,
     +			mp->m_sb.sb_rextents);
     +}
    ++
    ++/*
    ++ * Update the rt extent count of the previous tail rtgroup if it changed during
    ++ * recovery (i.e. recovery of a growfs).
    ++ */
    ++int
    ++xfs_update_last_rtgroup_size(
    ++	struct xfs_mount	*mp,
    ++	xfs_rgnumber_t		prev_rgcount)
    ++{
    ++	struct xfs_rtgroup	*rtg;
    ++
    ++	ASSERT(prev_rgcount > 0);
    ++
    ++	rtg = xfs_rtgroup_grab(mp, prev_rgcount - 1);
    ++	if (!rtg)
    ++		return -EFSCORRUPTED;
    ++	rtg->rtg_extents = __xfs_rtgroup_extents(mp, prev_rgcount - 1,
    ++			mp->m_sb.sb_rgcount, mp->m_sb.sb_rextents);
    ++	xfs_rtgroup_rele(rtg);
    ++	return 0;
    ++}
    ++
     
      ## fs/xfs/libxfs/xfs_rtgroup.h (new) ##
     @@
     +/* SPDX-License-Identifier: GPL-2.0-or-later */
     +/*
     + * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
    @@ fs/xfs/libxfs/xfs_rtgroup.h (new)
     +
     +static inline struct xfs_rtgroup *to_rtg(struct xfs_group *xg)
     +{
     +	return container_of(xg, struct xfs_rtgroup, rtg_group);
     +}
     +
    ++static inline struct xfs_group *rtg_group(struct xfs_rtgroup *rtg)
    ++{
    ++	return &rtg->rtg_group;
    ++}
    ++
     +static inline struct xfs_mount *rtg_mount(const struct xfs_rtgroup *rtg)
     +{
     +	return rtg->rtg_group.xg_mount;
     +}
     +
     +static inline xfs_rgnumber_t rtg_rgno(const struct xfs_rtgroup *rtg)
     +{
    -+	return rtg->rtg_group.xg_index;
    ++	return rtg->rtg_group.xg_gno;
     +}
     +
     +/* Passive rtgroup references */
     +static inline struct xfs_rtgroup *
     +xfs_rtgroup_get(
     +	struct xfs_mount	*mp,
    @@ fs/xfs/libxfs/xfs_rtgroup.h (new)
     +}
     +
     +static inline struct xfs_rtgroup *
     +xfs_rtgroup_hold(
     +	struct xfs_rtgroup	*rtg)
     +{
    -+	return to_rtg(xfs_group_hold(&rtg->rtg_group));
    ++	return to_rtg(xfs_group_hold(rtg_group(rtg)));
     +}
     +
     +static inline void
     +xfs_rtgroup_put(
     +	struct xfs_rtgroup	*rtg)
     +{
    -+	xfs_group_put(&rtg->rtg_group);
    ++	xfs_group_put(rtg_group(rtg));
     +}
     +
     +/* Active rtgroup references */
     +static inline struct xfs_rtgroup *
     +xfs_rtgroup_grab(
     +	struct xfs_mount	*mp,
    @@ fs/xfs/libxfs/xfs_rtgroup.h (new)
     +}
     +
     +static inline void
     +xfs_rtgroup_rele(
     +	struct xfs_rtgroup	*rtg)
     +{
    -+	xfs_group_rele(&rtg->rtg_group);
    ++	xfs_group_rele(rtg_group(rtg));
     +}
     +
     +static inline struct xfs_rtgroup *
     +xfs_rtgroup_next_range(
     +	struct xfs_mount	*mp,
     +	struct xfs_rtgroup	*rtg,
     +	xfs_rgnumber_t		start_rgno,
     +	xfs_rgnumber_t		end_rgno)
     +{
    -+	return to_rtg(xfs_group_next_range(mp, rtg ? &rtg->rtg_group : NULL,
    ++	return to_rtg(xfs_group_next_range(mp, rtg ? rtg_group(rtg) : NULL,
     +			start_rgno, end_rgno, XG_TYPE_RTG));
     +}
     +
     +static inline struct xfs_rtgroup *
     +xfs_rtgroup_next(
     +	struct xfs_mount	*mp,
    @@ fs/xfs/libxfs/xfs_rtgroup.h (new)
     +int xfs_initialize_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t first_rgno,
     +		xfs_rgnumber_t end_rgno, xfs_rtbxlen_t rextents);
     +
     +xfs_rtxnum_t __xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno,
     +		xfs_rgnumber_t rgcount, xfs_rtbxlen_t rextents);
     +xfs_rtxnum_t xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno);
    ++
    ++int xfs_update_last_rtgroup_size(struct xfs_mount *mp,
    ++		xfs_rgnumber_t prev_rgcount);
     +#else
     +static inline void xfs_free_rtgroups(struct xfs_mount *mp,
     +		xfs_rgnumber_t first_rgno, xfs_rgnumber_t end_rgno)
     +{
     +}
     +
    @@ fs/xfs/libxfs/xfs_rtgroup.h (new)
     +		xfs_rtbxlen_t rextents)
     +{
     +	return 0;
     +}
     +
     +# define xfs_rtgroup_extents(mp, rgno)		(0)
    ++# define xfs_update_last_rtgroup_size(mp, rgno)	(-EOPNOTSUPP)
     +#endif /* CONFIG_XFS_RT */
     +
     +#endif /* __LIBXFS_RTGROUP_H */
     
      ## fs/xfs/libxfs/xfs_sb.c ##
     @@ fs/xfs/libxfs/xfs_sb.c: __xfs_sb_from_disk(
    + 		xfs_sb_quota_from_disk(to);
    + 
    + 	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
      		to->sb_metadirino = be64_to_cpu(from->sb_metadirino);
    - 		to->sb_metadirpad = be32_to_cpu(from->sb_metadirpad);
    - 	} else {
    + 	else
      		to->sb_metadirino = NULLFSINO;
    - 		to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
    - 	}
     +
     +	to->sb_rgcount = 1;
     +	to->sb_rgextents = 0;
      }
      
      void
      xfs_sb_from_disk(
      	struct xfs_sb	*to,
      	struct xfs_dsb	*from)
    -@@ fs/xfs/libxfs/xfs_sb.c: void
    +@@ fs/xfs/libxfs/xfs_sb.c: const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
    + 
    + void
      xfs_mount_sb_set_rextsize(
      	struct xfs_mount	*mp,
      	struct xfs_sb		*sbp)
      {
    ++	struct xfs_groups	*rgs = &mp->m_groups[XG_TYPE_RTG];
    ++
      	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
      	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
     +
     +	mp->m_rgblocks = 0;
     +	mp->m_rgblklog = 0;
    -+	mp->m_rgblkmask = 0;
    ++	mp->m_rgblkmask = (uint64_t)-1;
    ++
    ++	rgs->blocks = 0;
    ++	rgs->blklog = 0;
    ++	rgs->blkmask = (uint64_t)-1;
      }
      
      /*
       * xfs_mount_common
       *
       * Mount initialization code establishing various mount
    @@ fs/xfs/xfs_bmap_util.c
      }
      
      /*
       * Routine to zero an extent on disk allocated to the specific inode.
       *
     
    + ## fs/xfs/xfs_buf_item_recover.c ##
    +@@
    + #include "xfs_inode.h"
    + #include "xfs_dir2.h"
    + #include "xfs_quota.h"
    + #include "xfs_alloc.h"
    + #include "xfs_ag.h"
    + #include "xfs_sb.h"
    ++#include "xfs_rtgroup.h"
    + 
    + /*
    +  * This is the number of entries in the l_buf_cancel_table used during
    +  * recovery.
    +  */
    + #define	XLOG_BC_TABLE_SIZE	64
    +@@ fs/xfs/xfs_buf_item_recover.c: xlog_recover_do_primary_sb_buffer(
    + 	struct xfs_buf			*bp,
    + 	struct xfs_buf_log_format	*buf_f,
    + 	xfs_lsn_t			current_lsn)
    + {
    + 	struct xfs_dsb			*dsb = bp->b_addr;
    + 	xfs_agnumber_t			orig_agcount = mp->m_sb.sb_agcount;
    ++	xfs_rgnumber_t			orig_rgcount = mp->m_sb.sb_rgcount;
    + 	int				error;
    + 
    + 	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
    + 
    + 	if (orig_agcount == 0) {
    + 		xfs_alert(mp, "Trying to grow file system without AGs");
    +@@ fs/xfs/xfs_buf_item_recover.c: xlog_recover_do_primary_sb_buffer(
    + 	xfs_sb_from_disk(&mp->m_sb, dsb);
    + 
    + 	if (mp->m_sb.sb_agcount < orig_agcount) {
    + 		xfs_alert(mp, "Shrinking AG count in log recovery not supported");
    + 		return -EFSCORRUPTED;
    + 	}
    ++	if (mp->m_sb.sb_rgcount < orig_rgcount) {
    ++		xfs_warn(mp,
    ++ "Shrinking rtgroup count in log recovery not supported");
    ++		return -EFSCORRUPTED;
    ++	}
    + 
    + 	/*
    + 	 * If the last AG was grown or shrunk, we also need to update the
    + 	 * length in the in-core perag structure and values depending on it.
    + 	 */
    + 	error = xfs_update_last_ag_size(mp, orig_agcount);
    + 	if (error)
    + 		return error;
    + 
    ++	/*
    ++	 * If the last rtgroup was grown or shrunk, we also need to update the
    ++	 * length in the in-core rtgroup structure and values depending on it.
    ++	 * Ignore this on any filesystem with zero rtgroups.
    ++	 */
    ++	if (orig_rgcount > 0) {
    ++		error = xfs_update_last_rtgroup_size(mp, orig_rgcount);
    ++		if (error)
    ++			return error;
    ++	}
    ++
    + 	/*
    + 	 * Initialize the new perags, and also update various block and inode
    + 	 * allocator setting based off the number of AGs or total blocks.
    + 	 * Because of the latter this also needs to happen if the agcount did
    + 	 * not change.
    + 	 */
    +@@ fs/xfs/xfs_buf_item_recover.c: xlog_recover_do_primary_sb_buffer(
    + 			mp->m_sb.sb_dblocks, &mp->m_maxagi);
    + 	if (error) {
    + 		xfs_warn(mp, "Failed recovery per-ag init: %d", error);
    + 		return error;
    + 	}
    + 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
    ++
    ++	error = xfs_initialize_rtgroups(mp, orig_rgcount, mp->m_sb.sb_rgcount,
    ++			mp->m_sb.sb_rextents);
    ++	if (error) {
    ++		xfs_warn(mp, "Failed recovery rtgroup init: %d", error);
    ++		return error;
    ++	}
    + 	return 0;
    + }
    + 
    + /*
    +  * V5 filesystems know the age of the buffer on disk being recovered. We can
    +  * have newer objects on disk than we are replaying, and so for these cases we
    +
      ## fs/xfs/xfs_fsmap.c ##
     @@
      #include "xfs_fsmap.h"
      #include "xfs_refcount.h"
      #include "xfs_refcount_btree.h"
      #include "xfs_alloc_btree.h"
    @@ fs/xfs/xfs_fsmap.c: xfs_getfsmap_rtdev_rtbitmap(
      			return 0;
      	}
      
      	trace_xfs_fsmap_low_linear_key(mp, info->dev, start_rtb);
      	trace_xfs_fsmap_high_linear_key(mp, info->dev, end_rtb);
     
    - ## fs/xfs/xfs_log_recover.c ##
    -@@
    - #include "xfs_icache.h"
    - #include "xfs_error.h"
    - #include "xfs_buf_item.h"
    - #include "xfs_ag.h"
    - #include "xfs_quota.h"
    - #include "xfs_reflink.h"
    -+#include "xfs_rtgroup.h"
    - 
    - #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
    - 
    - STATIC int
    - xlog_find_zeroed(
    - 	struct xlog	*,
    -@@ fs/xfs/xfs_log_recover.c: xlog_do_recover(
    - 	xfs_daddr_t		tail_blk)
    - {
    - 	struct xfs_mount	*mp = log->l_mp;
    - 	struct xfs_buf		*bp = mp->m_sb_bp;
    - 	struct xfs_sb		*sbp = &mp->m_sb;
    - 	xfs_agnumber_t		old_agcount = sbp->sb_agcount;
    -+	xfs_rgnumber_t		old_rgcount = sbp->sb_rgcount;
    - 	int			error;
    - 
    - 	trace_xfs_log_recover(log, head_blk, tail_blk);
    - 
    - 	/*
    - 	 * First replay the images in the log.
    -@@ fs/xfs/xfs_log_recover.c: xlog_do_recover(
    - 	error = xfs_initialize_perag(mp, old_agcount, sbp->sb_agcount,
    - 			sbp->sb_dblocks, &mp->m_maxagi);
    - 	if (error) {
    - 		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
    - 		return error;
    - 	}
    -+
    -+	if (sbp->sb_rgcount < old_rgcount) {
    -+		xfs_warn(mp, "rgcount shrink not supported");
    -+		return -EINVAL;
    -+	}
    -+
    -+	error = xfs_initialize_rtgroups(mp, old_rgcount, sbp->sb_rgcount,
    -+			sbp->sb_rextents);
    -+	if (error) {
    -+		xfs_warn(mp, "Failed post-recovery rtgroup init: %d", error);
    -+		return error;
    -+	}
    -+
    - 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
    - 
    - 	/* Normal transactions can now occur */
    - 	clear_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
    - 	return 0;
    - }
    -
      ## fs/xfs/xfs_mount.c ##
     @@
      #include "xfs_extent_busy.h"
      #include "xfs_health.h"
      #include "xfs_trace.h"
      #include "xfs_ag.h"
    @@ fs/xfs/xfs_rtalloc.c: xfs_rtmount_inodes(
      	if (error)
      		goto out_rele_summary;
      	xfs_trans_cancel(tp);
      	return 0;
      
     
    - ## fs/xfs/xfs_super.c ##
    -@@ fs/xfs/xfs_super.c: xfs_init_fs_context(
    - 
    - 	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL | __GFP_NOFAIL);
    - 	if (!mp)
    - 		return -ENOMEM;
    - 
    - 	spin_lock_init(&mp->m_sb_lock);
    -+
    - 	for (i = 0; i < XG_TYPE_MAX; i++)
    - 		xa_init(&mp->m_groups[i].xa);
    - 	mutex_init(&mp->m_growlock);
    - 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
    - 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
    - 	mp->m_kobj.kobject.kset = xfs_kset;
    -
      ## fs/xfs/xfs_trace.c ##
     @@
      #include "xfs_exchrange.h"
      #include "xfs_parent.h"
      #include "xfs_rmap.h"
      #include "xfs_refcount.h"
 80:  7ea70384745cc4 !  88:  47daf9d3d0f33b xfs: define locking primitives for realtime groups
    @@ Commit message
         for them.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
         Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/libxfs/xfs_rtgroup.c ##
    -@@ fs/xfs/libxfs/xfs_rtgroup.c: xfs_rtgroup_extents(
    - 	struct xfs_mount	*mp,
    - 	xfs_rgnumber_t		rgno)
    - {
    - 	return __xfs_rtgroup_extents(mp, rgno, mp->m_sb.sb_rgcount,
    - 			mp->m_sb.sb_rextents);
    +@@ fs/xfs/libxfs/xfs_rtgroup.c: xfs_update_last_rtgroup_size(
    + 	rtg->rtg_extents = __xfs_rtgroup_extents(mp, prev_rgcount - 1,
    + 			mp->m_sb.sb_rgcount, mp->m_sb.sb_rextents);
    + 	xfs_rtgroup_rele(rtg);
    + 	return 0;
      }
    -+
    + 
     +/* Lock metadata inodes associated with this rt group. */
     +void
     +xfs_rtgroup_lock(
     +	struct xfs_rtgroup	*rtg,
     +	unsigned int		rtglock_flags)
     +{
    @@ fs/xfs/libxfs/xfs_rtgroup.c: xfs_rtgroup_extents(
     +
     +	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
     +		xfs_rtbitmap_trans_join(tp);
     +}
     
      ## fs/xfs/libxfs/xfs_rtgroup.h ##
    -@@ fs/xfs/libxfs/xfs_rtgroup.h: void xfs_free_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t first_rgno,
    - int xfs_initialize_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t first_rgno,
    - 		xfs_rgnumber_t end_rgno, xfs_rtbxlen_t rextents);
    - 
    +@@ fs/xfs/libxfs/xfs_rtgroup.h: int xfs_initialize_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t first_rgno,
      xfs_rtxnum_t __xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno,
      		xfs_rgnumber_t rgcount, xfs_rtbxlen_t rextents);
      xfs_rtxnum_t xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno);
    + 
    + int xfs_update_last_rtgroup_size(struct xfs_mount *mp,
    + 		xfs_rgnumber_t prev_rgcount);
     +
     +/* Lock the rt bitmap inode in exclusive mode */
     +#define XFS_RTGLOCK_BITMAP		(1U << 0)
     +/* Lock the rt bitmap inode in shared mode */
     +#define XFS_RTGLOCK_BITMAP_SHARED	(1U << 1)
     +
    @@ fs/xfs/libxfs/xfs_rtgroup.h: void xfs_free_rtgroups(struct xfs_mount *mp, xfs_rg
      static inline void xfs_free_rtgroups(struct xfs_mount *mp,
      		xfs_rgnumber_t first_rgno, xfs_rgnumber_t end_rgno)
      {
      }
      
     @@ fs/xfs/libxfs/xfs_rtgroup.h: static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
    - 		xfs_rtbxlen_t rextents)
      {
      	return 0;
      }
      
      # define xfs_rtgroup_extents(mp, rgno)		(0)
    + # define xfs_update_last_rtgroup_size(mp, rgno)	(-EOPNOTSUPP)
     +# define xfs_rtgroup_lock(rtg, gf)		((void)0)
     +# define xfs_rtgroup_unlock(rtg, gf)		((void)0)
     +# define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
      #endif /* CONFIG_XFS_RT */
      
      #endif /* __LIBXFS_RTGROUP_H */
 81:  77d65f93697271 =  89:  ff7e4bd5e6cb3b xfs: add a lockdep class key for rtgroup inodes
 82:  e977b10c0c79d5 !  90:  a34dd1c6b7e547 xfs: support caching rtgroup metadata inodes
    @@ fs/xfs/libxfs/xfs_rtgroup.h
      	/* Number of blocks in this group */
      	xfs_rtxnum_t		rtg_extents;
      };
      
      static inline struct xfs_rtgroup *to_rtg(struct xfs_group *xg)
      {
    -@@ fs/xfs/libxfs/xfs_rtgroup.h: xfs_rtxnum_t xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno);
    +@@ fs/xfs/libxfs/xfs_rtgroup.h: int xfs_update_last_rtgroup_size(struct xfs_mount *mp,
      				 XFS_RTGLOCK_BITMAP_SHARED)
      
      void xfs_rtgroup_lock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
      void xfs_rtgroup_unlock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
      void xfs_rtgroup_trans_join(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
      		unsigned int rtglock_flags);
 83:  5660af2ce4998e =  91:  e3b575cee22f27 xfs: add rtgroup-based realtime scrubbing context management
 84:  0499e82f77edcf =  92:  e39966843a4e4b xfs: add a xfs_bmap_free_rtblocks helper
 85:  a70ebd48b4e954 !  93:  83616fe841fccc xfs: add a xfs_qm_unmount_rt helper
    @@ Commit message
         RT group enabled file systems fix the bug where we pointlessly attach
         quotas to the RT bitmap and summary files.  Split the code to detach the
         quotas into a helper, make it conditional and document the differing
         behavior for RT group and pre-RT group file systems.
     
         Signed-off-by: Christoph Hellwig <hch@lst.de>
    +    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    +    Signed-off-by: Darrick J. Wong <djwong@kernel.org>
     
      ## fs/xfs/xfs_qm.c ##
     @@
      #include "xfs_ag.h"
      #include "xfs_ialloc.h"
      #include "xfs_log_priv.h"
 86:  2e7d3ea61ce914 !  94:  7ff2d24920f548 xfs: factor out a xfs_growfs_rt_alloc_blocks helper
    @@ Commit message
         xfs: factor out a xfs_growfs_rt_alloc_blocks helper
     
         Split out a helper to allocate or grow the rtbitmap and rtsummary files
         in preparation of per-RT group bitmap and summary files.
     
         Signed-off-by: Christoph Hellwig <hch@lst.de>
    +    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    +    Signed-off-by: Darrick J. Wong <djwong@kernel.org>
     
      ## fs/xfs/xfs_rtalloc.c ##
     @@ fs/xfs/xfs_rtalloc.c: xfs_last_rt_bmblock(
      	/* Skip the current block if it is exactly full. */
      	if (xfs_rtx_to_rbmword(mp, mp->m_sb.sb_rextents) != 0)
      		bmbno--;
 87:  a484e3cd332ac8 !  95:  1674cef1d1e1e9 xfs: cleanup xfs_getfsmap_rtdev_rtbitmap
    @@ Commit message
         Use mp->m_sb.sb_rblocks to calculate the end instead of sb_rextents that
         needs a conversion, use consistent names to xfs_rtblock_t types, and
         only calculated them by the time they are needed.  Remove the pointless
         "high" local variable that only has a single user.
     
         Signed-off-by: Christoph Hellwig <hch@lst.de>
    +    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    +    Signed-off-by: Darrick J. Wong <djwong@kernel.org>
     
      ## fs/xfs/xfs_fsmap.c ##
     @@ fs/xfs/xfs_fsmap.c: xfs_getfsmap_rtdev_rtbitmap(
      	const struct xfs_fsmap		*keys,
      	struct xfs_getfsmap_info	*info)
      {
 88:  2400e34b819138 !  96:  7710b65342a30e xfs: split xfs_trim_rtdev_extents
    @@ Commit message
         main validation also for RT group aware file systems.
     
         Use the fully features xfs_daddr_to_rtb helper to convert from a daddr
         to a xfs_rtblock_t to prepare for segmented addressing in RT groups.
     
         Signed-off-by: Christoph Hellwig <hch@lst.de>
    +    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    +    Signed-off-by: Darrick J. Wong <djwong@kernel.org>
     
      ## fs/xfs/xfs_discard.c ##
     @@
      #include "xfs_extent_busy.h"
      #include "xfs_trace.h"
      #include "xfs_log.h"
 89:  d4abd0205d0f68 !  97:  e0bdb91d92d21a xfs: move RT bitmap and summary information to the rtgroup
    @@ fs/xfs/xfs_fsmap.c: xfs_getfsmap_rtdev_rtbitmap(
     -	/*
     -	 * Report any gaps at the end of the rtbitmap by simulating a null
     -	 * rmap starting at the block after the end of the query range.
     -	 */
     -	info->last = true;
     -	ahigh.ar_startext = min(mp->m_sb.sb_rextents, high);
    -+		info->group = &rtg->rtg_group;
    ++		info->group = rtg_group(rtg);
     +		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
     +		error = xfs_rtalloc_query_range(rtg, tp, start_rtx, end_rtx,
     +				xfs_getfsmap_rtdev_rtbitmap_helper, info);
     +		if (error)
     +			break;
     +
 90:  59cdbb06cc8e2c =  98:  f3ac661f7548e4 xfs: support creating per-RTG files in growfs
 91:  8a372bc0019619 =  99:  363bb663843860 xfs: remove XFS_ILOCK_RT*
 92:  f83e42264bf88c = 100:  7786f78f16e09a xfs: calculate RT bitmap and summary blocks based on sb_rextents
 93:  cfbf480bb14ddb = 101:  7fbed60487d5ab xfs: factor out a xfs_growfs_rt_alloc_fake_mount helper
 94:  1b0f0a5ae90fac = 102:  7cdcd3b069e2c8 xfs: use xfs_growfs_rt_alloc_fake_mount in xfs_growfs_rt_alloc_blocks
 95:  1060a04683791b = 103:  140f03a1285d84 xfs: factor out a xfs_growfs_check_rtgeom helper
 96:  0045da06bb4302 = 104:  97e0ce5ab53e5d xfs: refactor xfs_rtbitmap_blockcount
 97:  a180642f5c550b = 105:  4b9ad78bec969b xfs: refactor xfs_rtsummary_blockcount
 98:  603b2021a39541 = 106:  35824ef9f15efb xfs: make RT extent numbers relative to the rtgroup
 99:  253a2e34a9a9a3 ! 107:  6630a15ecaf6b8 xfs: fix rt device offset calculations for FITRIM
    @@ Commit message
         Right now the address space conversion is done in units of rtblocks.
         However, a future patchset will convert xfs_rtblock_t to be a segmented
         address space (group:blkno) like the data device.  Change the conversion
         code to be done in units of daddrs since those will never be segmented.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/xfs_discard.c ##
     @@ fs/xfs/xfs_discard.c: xfs_discard_rtdev_extents(
      			start = busyp->bno;
      		length += busyp->length;
      
100:  0af14ece3bdcf9 = 108:  c6a294c0eb98a4 iomap: add a merge boundary flag
101:  25ffdf6db77142 ! 109:  44a68e7a236242 xfs: define the format of rt groups
    @@ fs/xfs/libxfs/xfs_sb.c: xfs_validate_sb_read(
      
     +/* Return the number of extents covered by a single rt bitmap file */
     +static xfs_rtbxlen_t
     +xfs_extents_per_rbm(
     +	struct xfs_sb		*sbp)
     +{
    -+	if (xfs_sb_version_hasmetadir(sbp))
    ++	if (xfs_sb_is_v5(sbp) &&
    ++	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR))
     +		return sbp->sb_rgextents;
     +	return sbp->sb_rextents;
     +}
     +
      static uint64_t
     -xfs_sb_calc_rbmblocks(
    @@ fs/xfs/libxfs/xfs_sb.c: xfs_validate_sb_write(
      	if (!xfs_verify_magic(bp, dsb->sb_magicnum)) {
      		xfs_warn(mp,
      "Superblock has bad magic number 0x%x. Not an XFS filesystem?",
      			be32_to_cpu(dsb->sb_magicnum));
      		return -EWRONGFS;
     @@ fs/xfs/libxfs/xfs_sb.c: xfs_validate_sb_common(
    - 			if (sbp->sb_metadirpad) {
      				xfs_warn(mp,
    - "Metadir superblock padding field (%d) must be zero.",
    - 						sbp->sb_metadirpad);
    + "Inode block alignment (%u) must match chunk size (%u) for sparse inodes.",
    + 					 sbp->sb_inoalignmt, align);
      				return -EINVAL;
      			}
    + 		}
     +
    ++		if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
     +			error = xfs_validate_sb_rtgroups(mp, sbp);
     +			if (error)
     +				return error;
    - 		}
    ++		}
      	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
      				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
      			xfs_notice(mp,
      "Superblock earlier than Version 5 has XFS_{P|G}QUOTA_{ENFD|CHKD} bits.");
      			return -EFSCORRUPTED;
    + 	}
     @@ fs/xfs/libxfs/xfs_sb.c: __xfs_sb_from_disk(
    + 	else
    + 		uuid_copy(&to->sb_meta_uuid, &from->sb_uuid);
    + 	/* Convert on-disk flags to in-memory flags? */
      	if (convert_xquota)
      		xfs_sb_quota_from_disk(to);
      
    - 	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
    +-	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
    ++	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
      		to->sb_metadirino = be64_to_cpu(from->sb_metadirino);
    - 		to->sb_metadirpad = be32_to_cpu(from->sb_metadirpad);
    +-	else
     +		to->sb_rgcount = be32_to_cpu(from->sb_rgcount);
     +		to->sb_rgextents = be32_to_cpu(from->sb_rgextents);
    - 	} else {
    ++	} else {
      		to->sb_metadirino = NULLFSINO;
    - 		to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
    -+		to->sb_rgcount = 1;
    -+		to->sb_rgextents = 0;
    - 	}
     -
     -	to->sb_rgcount = 1;
     -	to->sb_rgextents = 0;
    ++		to->sb_rgcount = 1;
    ++		to->sb_rgextents = 0;
    ++	}
      }
      
      void
      xfs_sb_from_disk(
      	struct xfs_sb	*to,
      	struct xfs_dsb	*from)
     @@ fs/xfs/libxfs/xfs_sb.c: xfs_sb_to_disk(
    + 			cpu_to_be32(from->sb_features_log_incompat);
    + 	to->sb_spino_align = cpu_to_be32(from->sb_spino_align);
    + 	to->sb_lsn = cpu_to_be64(from->sb_lsn);
      	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID)
      		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
      
    - 	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
    +-	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
    ++	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
      		to->sb_metadirino = cpu_to_be64(from->sb_metadirino);
    - 		to->sb_metadirpad = 0;
     +		to->sb_rgcount = cpu_to_be32(from->sb_rgcount);
     +		to->sb_rgextents = cpu_to_be32(from->sb_rgextents);
    - 	}
    ++	}
      }
      
      /*
       * If the superblock has the CRC feature bit set or the CRC field is non-null,
       * check that the CRC is valid.  We check the CRC field is non-null because a
    +  * single bit error could clear the feature bit and unused parts of the
     @@ fs/xfs/libxfs/xfs_sb.c: xfs_mount_sb_set_rextsize(
    - 	struct xfs_mount	*mp,
    - 	struct xfs_sb		*sbp)
      {
    + 	struct xfs_groups	*rgs = &mp->m_groups[XG_TYPE_RTG];
    + 
      	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
      	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
      
     -	mp->m_rgblocks = 0;
     -	mp->m_rgblklog = 0;
    --	mp->m_rgblkmask = 0;
    +-	mp->m_rgblkmask = (uint64_t)-1;
     +	mp->m_rgblocks = sbp->sb_rgextents * sbp->sb_rextsize;
     +	mp->m_rgblklog = log2_if_power2(mp->m_rgblocks);
     +	mp->m_rgblkmask = mask64_if_power2(mp->m_rgblocks);
    + 
    + 	rgs->blocks = 0;
    + 	rgs->blklog = 0;
    + 	rgs->blkmask = (uint64_t)-1;
      }
      
    - /*
    -  * xfs_mount_common
    -  *
    -  * Mount initialization code establishing various mount
     
      ## fs/xfs/libxfs/xfs_shared.h ##
     @@ fs/xfs/libxfs/xfs_shared.h: extern const struct xfs_buf_ops xfs_finobt_buf_ops;
      extern const struct xfs_buf_ops xfs_inobt_buf_ops;
      extern const struct xfs_buf_ops xfs_inode_buf_ops;
      extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
102:  7e042fef78b554 = 110:  e92e9e2929b0c1 xfs: check the realtime superblock at mount time
103:  8e5d36fb4cab32 ! 111:  22d97ce3c71cb3 xfs: update realtime super every time we update the primary fs super
    @@ fs/xfs/libxfs/xfs_rtgroup.h: void xfs_rtginode_irele(struct xfs_inode **ipp);
      static inline void xfs_free_rtgroups(struct xfs_mount *mp,
      		xfs_rgnumber_t first_rgno, xfs_rgnumber_t end_rgno)
      {
      }
      
     @@ fs/xfs/libxfs/xfs_rtgroup.h: static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
    - }
      
      # define xfs_rtgroup_extents(mp, rgno)		(0)
    + # define xfs_update_last_rtgroup_size(mp, rgno)	(-EOPNOTSUPP)
      # define xfs_rtgroup_lock(rtg, gf)		((void)0)
      # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
      # define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
     +# define xfs_update_rtsb(bp, sb_bp)	((void)0)
     +# define xfs_log_rtsb(tp, sb_bp)	(NULL)
      #endif /* CONFIG_XFS_RT */
    @@ fs/xfs/libxfs/xfs_sb.h: struct xfs_dsb;
      			struct xfs_sb *sbp);
      extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
      extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
      extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
     
      ## fs/xfs/xfs_buf_item_recover.c ##
    -@@
    - #include "xfs_log_priv.h"
    - #include "xfs_log_recover.h"
    - #include "xfs_error.h"
    - #include "xfs_inode.h"
    - #include "xfs_dir2.h"
    - #include "xfs_quota.h"
    -+#include "xfs_rtgroup.h"
    - 
    - /*
    -  * This is the number of entries in the l_buf_cancel_table used during
    -  * recovery.
    -  */
    - #define	XLOG_BC_TABLE_SIZE	64
     @@ fs/xfs/xfs_buf_item_recover.c: xlog_recover_buf_commit_pass2(
    - 		xfs_buf_stale(bp);
    - 		error = xfs_bwrite(bp);
    - 	} else {
    - 		ASSERT(bp->b_mount == mp);
    - 		bp->b_flags |= _XBF_LOGRECOVERY;
    - 		xfs_buf_delwri_queue(bp, buffer_list);
    + 	} else if ((xfs_blft_from_flags(buf_f) & XFS_BLFT_SB_BUF) &&
    + 			xfs_buf_daddr(bp) == 0) {
    + 		error = xlog_recover_do_primary_sb_buffer(mp, item, bp, buf_f,
    + 				current_lsn);
    + 		if (error)
    + 			goto out_release;
     +
    -+		/*
    -+		 * Update the rt super if we just recovered the primary fs
    -+		 * super.
    -+		 */
    -+		if (xfs_has_rtsb(mp) && bp->b_ops == &xfs_sb_buf_ops) {
    ++		/* Update the rt superblock if we have one. */
    ++		if (xfs_has_rtsb(mp) && mp->m_rtsb_bp) {
     +			struct xfs_buf	*rtsb_bp = mp->m_rtsb_bp;
     +
    -+			if (rtsb_bp) {
    -+				xfs_buf_lock(rtsb_bp);
    -+				xfs_buf_hold(rtsb_bp);
    -+				xfs_update_rtsb(rtsb_bp, bp);
    -+				rtsb_bp->b_flags |= _XBF_LOGRECOVERY;
    -+				xfs_buf_delwri_queue(rtsb_bp, buffer_list);
    -+				xfs_buf_relse(rtsb_bp);
    -+			}
    ++			xfs_buf_lock(rtsb_bp);
    ++			xfs_buf_hold(rtsb_bp);
    ++			xfs_update_rtsb(rtsb_bp, bp);
    ++			rtsb_bp->b_flags |= _XBF_LOGRECOVERY;
    ++			xfs_buf_delwri_queue(rtsb_bp, buffer_list);
    ++			xfs_buf_relse(rtsb_bp);
     +		}
    + 	} else {
    + 		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
      	}
      
    - out_release:
    - 	xfs_buf_relse(bp);
    - 	return error;
    - cancelled:
    + 	/*
    + 	 * Perform delayed write on the buffer.  Asynchronous writes will be
     
      ## fs/xfs/xfs_ioctl.c ##
     @@ fs/xfs/xfs_ioctl.c: xfs_ioc_setlabel(
      	 * immediately write these changes to sector zero for the primary, then
      	 * update all backup supers (as xfs_db does for a label change), then
      	 * invalidate the block device page cache.  This is so that any prior
104:  1e091932b37b22 = 112:  95ddb302f6847e xfs: export realtime group geometry via XFS_FSOP_GEOM
105:  0d26fb6512249c ! 113:  4bc5c380916ed3 xfs: check that rtblock extents do not break rtsupers or rtgroups
    @@ fs/xfs/libxfs/xfs_types.c
      
      /*
       * Verify that an AG block number pointer neither points outside the AG
       * nor points at static metadata.
       */
     @@ fs/xfs/libxfs/xfs_types.c: xfs_verify_dir_ino(
    - 	if (xfs_internal_inum(mp, ino))
    + 	if (xfs_is_sb_inum(mp, ino))
      		return false;
      	return xfs_verify_ino(mp, ino);
      }
      
      /*
     - * Verify that an realtime block number pointer doesn't point off the
106:  4b6f79bae8efd0 = 114:  30acedceedf58f xfs: add a helper to prevent bmap merges across rtgroup boundaries
107:  62ae0b6b3d566d = 115:  7b9f282833a444 xfs: add frextents to the lazysbcounters when rtgroups enabled
108:  3e749783f710d2 ! 116:  65c56b19b8299e xfs: convert sick_map loops to use ARRAY_SIZE
    @@ fs/xfs/xfs_health.c: static const struct ioctl_sick_map ag_map[] = {
     @@ fs/xfs/xfs_health.c: xfs_ag_geom_health(
      	unsigned int			checked;
      
      	ageo->ag_sick = 0;
      	ageo->ag_checked = 0;
      
    - 	xfs_group_measure_sickness(&pag->pag_group, &sick, &checked);
    + 	xfs_group_measure_sickness(pag_group(pag), &sick, &checked);
     -	for (m = ag_map; m->sick_mask; m++) {
     +	for_each_sick_map(ag_map, m) {
      		if (checked & m->sick_mask)
      			ageo->ag_checked |= m->ioctl_mask;
      		if (sick & m->sick_mask)
      			ageo->ag_sick |= m->ioctl_mask;
109:  e024688f13bf43 ! 117:  b0ff289ed2c9a3 xfs: record rt group metadata errors in the health system
    @@ fs/xfs/libxfs/xfs_health.h: struct xfs_da_args;
     +		unsigned int mask);
      
      void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
      		unsigned int mask);
      void xfs_group_mark_sick(struct xfs_group *xg, unsigned int mask);
      #define xfs_ag_mark_sick(pag, mask) \
    - 	xfs_group_mark_sick(&(pag)->pag_group, (mask))
    + 	xfs_group_mark_sick(pag_group(pag), (mask))
     @@ fs/xfs/libxfs/xfs_health.h: xfs_group_has_sickness(
      {
      	unsigned int		sick, checked;
      
      	xfs_group_measure_sickness(xg, &sick, &checked);
      	return sick & mask;
      }
     +
      #define xfs_ag_has_sickness(pag, mask) \
    - 	xfs_group_has_sickness(&(pag)->pag_group, (mask))
    + 	xfs_group_has_sickness(pag_group(pag), (mask))
      #define xfs_ag_is_healthy(pag) \
      	(!xfs_ag_has_sickness((pag), UINT_MAX))
      
     +#define xfs_rtgroup_has_sickness(rtg, mask) \
    -+	xfs_group_has_sickness(&(rtg)->rtg_group, (mask))
    ++	xfs_group_has_sickness(rtg_group(rtg), (mask))
     +#define xfs_rtgroup_is_healthy(rtg) \
     +	(!xfs_rtgroup_has_sickness((rtg), UINT_MAX))
     +
      static inline bool
      xfs_inode_has_sickness(struct xfs_inode *ip, unsigned int mask)
      {
    @@ fs/xfs/libxfs/xfs_rtgroup.c: xfs_rtginode_enabled(
     +xfs_rtginode_mark_sick(
     +	struct xfs_rtgroup	*rtg,
     +	enum xfs_rtg_inodes	type)
     +{
     +	const struct xfs_rtginode_ops *ops = &xfs_rtginode_ops[type];
     +
    -+	xfs_group_mark_sick(&rtg->rtg_group, ops->sick);
    ++	xfs_group_mark_sick(rtg_group(rtg), ops->sick);
     +}
     +
      /* Load and existing rtgroup inode into the rtgroup structure. */
      int
      xfs_rtginode_load(
      	struct xfs_rtgroup	*rtg,
    @@ fs/xfs/scrub/health.c: xchk_file_looks_zapped(
      	struct xfs_perag	*pag = NULL;
     +	struct xfs_rtgroup	*rtg = NULL;
      
      	xfs_fs_mark_healthy(mp, XFS_SICK_FS_INDIRECT);
     -	xfs_rt_mark_healthy(mp, XFS_SICK_RT_INDIRECT);
      	while ((pag = xfs_perag_next(mp, pag)))
    - 		xfs_group_mark_healthy(&pag->pag_group, XFS_SICK_AG_INDIRECT);
    + 		xfs_group_mark_healthy(pag_group(pag), XFS_SICK_AG_INDIRECT);
     +	while ((rtg = xfs_rtgroup_next(mp, rtg)))
    -+		xfs_group_mark_healthy(&rtg->rtg_group, XFS_SICK_RG_INDIRECT);
    ++		xfs_group_mark_healthy(rtg_group(rtg), XFS_SICK_RG_INDIRECT);
      }
      
      /*
       * Update filesystem health assessments based on what we found and did.
       *
       * If the scrubber finds errors, we mark sick whatever's mentioned in
    @@ fs/xfs/scrub/health.c: xchk_update_health(
      		break;
     -	case XHG_RT:
     +	case XHG_RTGROUP:
     +		rtg = xfs_rtgroup_get(sc->mp, sc->sm->sm_agno);
      		if (bad)
     -			xfs_rt_mark_corrupt(sc->mp, sc->sick_mask);
    -+			xfs_group_mark_corrupt(&rtg->rtg_group, sc->sick_mask);
    ++			xfs_group_mark_corrupt(rtg_group(rtg), sc->sick_mask);
      		else
     -			xfs_rt_mark_healthy(sc->mp, sc->sick_mask);
    -+			xfs_group_mark_healthy(&rtg->rtg_group, sc->sick_mask);
    ++			xfs_group_mark_healthy(rtg_group(rtg), sc->sick_mask);
     +		xfs_rtgroup_put(rtg);
      		break;
      	default:
      		ASSERT(0);
      		break;
      	}
    @@ fs/xfs/scrub/health.c: xchk_ag_btree_del_cursor_if_sick(
      
     -	xfs_rt_measure_sickness(mp, &sick, &checked);
     -	if (sick & XFS_SICK_RT_PRIMARY)
     -		xchk_set_corrupt(sc);
     -
      	while ((pag = xfs_perag_next(mp, pag))) {
    - 		xfs_group_measure_sickness(&pag->pag_group, &sick, &checked);
    + 		xfs_group_measure_sickness(pag_group(pag), &sick, &checked);
      		if (sick & XFS_SICK_AG_PRIMARY)
      			xchk_set_corrupt(sc);
      	}
      
     +	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
    -+		xfs_group_measure_sickness(&rtg->rtg_group, &sick, &checked);
    ++		xfs_group_measure_sickness(rtg_group(rtg), &sick, &checked);
     +		if (sick & XFS_SICK_RG_PRIMARY)
     +			xchk_set_corrupt(sc);
     +	}
     +
      	return 0;
      }
    @@ fs/xfs/xfs_health.c
      
      	if (xfs_is_shutdown(mp))
      		return;
      
      	/* Measure AG corruption levels. */
     -	while ((pag = xfs_perag_next(mp, pag))) {
    --		xfs_group_measure_sickness(&pag->pag_group, &sick, &checked);
    +-		xfs_group_measure_sickness(pag_group(pag), &sick, &checked);
     -		if (sick) {
    --			trace_xfs_group_unfixed_corruption(&pag->pag_group,
    +-			trace_xfs_group_unfixed_corruption(pag_group(pag),
     -					sick);
     -			warn = true;
     -		}
     -	}
     +	while ((pag = xfs_perag_next(mp, pag)))
    -+		xfs_health_unmount_group(&pag->pag_group, &warn);
    ++		xfs_health_unmount_group(pag_group(pag), &warn);
      
     -	/* Measure realtime volume corruption levels. */
     -	xfs_rt_measure_sickness(mp, &sick, &checked);
     -	if (sick) {
     -		trace_xfs_rt_unfixed_corruption(mp, sick);
     -		warn = true;
     -	}
     +	/* Measure realtime group corruption levels. */
     +	while ((rtg = xfs_rtgroup_next(mp, rtg)))
    -+		xfs_health_unmount_group(&rtg->rtg_group, &warn);
    ++		xfs_health_unmount_group(rtg_group(rtg), &warn);
      
      	/*
      	 * Measure fs corruption and keep the sample around for the warning.
      	 * See the note below for why we exempt FS_COUNTERS.
      	 */
      	xfs_fs_measure_sickness(mp, &sick, &checked);
    @@ fs/xfs/xfs_health.c: xfs_group_measure_sickness(
     +	struct xfs_rtgroup	*rtg = xfs_rtgroup_get(mp, rgno);
     +
     +	/* per-rtgroup structure not set up yet? */
     +	if (!rtg)
     +		return;
     +
    -+	xfs_group_mark_sick(&rtg->rtg_group, mask);
    ++	xfs_group_mark_sick(rtg_group(rtg), mask);
     +	xfs_rtgroup_put(rtg);
     +}
     +
      /* Mark the unhealthy parts of an inode. */
      void
      xfs_inode_mark_sick(
    @@ fs/xfs/xfs_health.c: xfgeo_health_tick(
      		xfgeo_health_tick(geo, sick, checked, m);
      
     -	xfs_rt_measure_sickness(mp, &sick, &checked);
     -	for_each_sick_map(rt_map, m)
     -		xfgeo_health_tick(geo, sick, checked, m);
     +	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
    -+		xfs_group_measure_sickness(&rtg->rtg_group, &sick, &checked);
    ++		xfs_group_measure_sickness(rtg_group(rtg), &sick, &checked);
     +		for_each_sick_map(rt_map, m)
     +			xfgeo_health_tick(geo, sick, checked, m);
     +	}
      }
      
      static const struct ioctl_sick_map ag_map[] = {
110:  9f6c3b9cda47a0 ! 118:  fdb98ad5d8818b xfs: export the geometry of realtime groups to userspace
    @@ fs/xfs/libxfs/xfs_fs.h: struct xfs_getparents_by_handle {
     +/*
     + * Output for XFS_IOC_RTGROUP_GEOMETRY
     + */
     +struct xfs_rtgroup_geometry {
     +	__u32 rg_number;	/* i/o: rtgroup number */
     +	__u32 rg_length;	/* o: length in blocks */
    -+	__u32 rg_capacity;	/* o: usable capacity in blocks */
     +	__u32 rg_sick;		/* o: sick things in ag */
     +	__u32 rg_checked;	/* o: checked metadata in ag */
     +	__u32 rg_flags;		/* i/o: flags for this ag */
    -+	__u64 rg_reserved[13];	/* o: zero */
    ++	__u32 rg_reserved[27];	/* o: zero */
     +};
     +#define XFS_RTGROUP_GEOM_SICK_SUPER	(1U << 0)  /* superblock */
     +#define XFS_RTGROUP_GEOM_SICK_BITMAP	(1U << 1)  /* rtbitmap */
     +#define XFS_RTGROUP_GEOM_SICK_SUMMARY	(1U << 2)  /* rtsummary */
     +
      /*
    @@ fs/xfs/libxfs/xfs_rtgroup.c: xfs_rtgroup_trans_join(
     +	struct xfs_rtgroup_geometry *rgeo)
     +{
     +	/* Fill out form. */
     +	memset(rgeo, 0, sizeof(*rgeo));
     +	rgeo->rg_number = rtg_rgno(rtg);
     +	rgeo->rg_length = rtg->rtg_extents * rtg_mount(rtg)->m_sb.sb_rextsize;
    -+	rgeo->rg_capacity = rgeo->rg_length;
     +	xfs_rtgroup_geom_health(rtg, rgeo);
     +	return 0;
     +}
     +
      #ifdef CONFIG_PROVE_LOCKING
      static struct lock_class_key xfs_rtginode_lock_class;
      
      static int
      xfs_rtginode_ilock_cmp_fn(
      	const struct lockdep_map	*m1,
     
      ## fs/xfs/libxfs/xfs_rtgroup.h ##
    -@@ fs/xfs/libxfs/xfs_rtgroup.h: xfs_rtxnum_t xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno);
    +@@ fs/xfs/libxfs/xfs_rtgroup.h: int xfs_update_last_rtgroup_size(struct xfs_mount *mp,
      
      void xfs_rtgroup_lock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
      void xfs_rtgroup_unlock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
      void xfs_rtgroup_trans_join(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
      		unsigned int rtglock_flags);
      
    @@ fs/xfs/libxfs/xfs_rtgroup.h: xfs_rtxnum_t xfs_rtgroup_extents(struct xfs_mount *
      int xfs_rtginode_load_parent(struct xfs_trans *tp);
      
      const char *xfs_rtginode_name(enum xfs_rtg_inodes type);
      enum xfs_metafile_type xfs_rtginode_metafile_type(enum xfs_rtg_inodes type);
      bool xfs_rtginode_enabled(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type);
     @@ fs/xfs/libxfs/xfs_rtgroup.h: static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
    - # define xfs_rtgroup_extents(mp, rgno)		(0)
    + # define xfs_update_last_rtgroup_size(mp, rgno)	(-EOPNOTSUPP)
      # define xfs_rtgroup_lock(rtg, gf)		((void)0)
      # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
      # define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
      # define xfs_update_rtsb(bp, sb_bp)	((void)0)
      # define xfs_log_rtsb(tp, sb_bp)	(NULL)
     +# define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
    @@ fs/xfs/xfs_health.c: xfs_ag_geom_health(
     +	unsigned int			sick;
     +	unsigned int			checked;
     +
     +	rgeo->rg_sick = 0;
     +	rgeo->rg_checked = 0;
     +
    -+	xfs_group_measure_sickness(&rtg->rtg_group, &sick, &checked);
    ++	xfs_group_measure_sickness(rtg_group(rtg), &sick, &checked);
     +	for_each_sick_map(rtgroup_map, m) {
     +		if (checked & m->sick_mask)
     +			rgeo->rg_checked |= m->ioctl_mask;
     +		if (sick & m->sick_mask)
     +			rgeo->rg_sick |= m->ioctl_mask;
     +	}
111:  f048d0da2ae195 ! 119:  ef8de9fe878f4b xfs: add block headers to realtime bitmap and summary blocks
    @@ Commit message
         like most every other thing in XFS.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
         Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/libxfs/xfs_format.h ##
    -@@ fs/xfs/libxfs/xfs_format.h: static inline bool xfs_dinode_has_large_extent_counts(
    +@@ fs/xfs/libxfs/xfs_format.h: static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
      
      /* Min and max rt extent sizes, specified in bytes */
      #define	XFS_MAX_RTEXTSIZE	(1024 * 1024 * 1024)	/* 1GB */
      #define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64kB */
      #define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4kB */
      
    @@ fs/xfs/libxfs/xfs_rtbitmap.h: int xfs_rtalloc_extent_is_free(struct xfs_rtgroup
      xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
      		unsigned int *rsumlevels);
      
     
      ## fs/xfs/libxfs/xfs_sb.c ##
     @@ fs/xfs/libxfs/xfs_sb.c: xfs_extents_per_rbm(
    - {
    - 	if (xfs_sb_version_hasmetadir(sbp))
    + 	if (xfs_sb_is_v5(sbp) &&
    + 	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR))
      		return sbp->sb_rgextents;
      	return sbp->sb_rextents;
      }
      
     +/*
     + * Return the payload size of a single rt bitmap block (without the metadata
     + * header if any).
     + */
     +static inline unsigned int
     +xfs_rtbmblock_size(
     +	struct xfs_sb		*sbp)
     +{
    -+	if (xfs_sb_version_hasmetadir(sbp))
    ++	if (xfs_sb_is_v5(sbp) &&
    ++	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR))
     +		return sbp->sb_blocksize - sizeof(struct xfs_rtbuf_blkinfo);
     +	return sbp->sb_blocksize;
     +}
     +
      static uint64_t
      xfs_expected_rbmblocks(
    @@ fs/xfs/libxfs/xfs_sb.c: xfs_sb_mount_common(
      	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
      	mp->m_blockmask = sbp->sb_blocksize - 1;
     -	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
     -	mp->m_blockwmask = mp->m_blockwsize - 1;
     +	mp->m_blockwsize = xfs_rtbmblock_size(sbp) >> XFS_WORDLOG;
     +	mp->m_rtx_per_rbmblock = mp->m_blockwsize << XFS_NBWORDLOG;
    + 
    + 	ags->blocks = mp->m_sb.sb_agblocks;
    + 	ags->blklog = mp->m_sb.sb_agblklog;
    + 	ags->blkmask = xfs_mask32lo(mp->m_sb.sb_agblklog);
    + 
      	xfs_mount_sb_set_rextsize(mp, sbp);
    - 
    - 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, true);
    - 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, false);
    - 	mp->m_alloc_mnr[0] = mp->m_alloc_mxr[0] / 2;
    - 	mp->m_alloc_mnr[1] = mp->m_alloc_mxr[1] / 2;
     
      ## fs/xfs/libxfs/xfs_shared.h ##
     @@ fs/xfs/libxfs/xfs_shared.h: extern const struct xfs_buf_ops xfs_dquot_buf_ra_ops;
      extern const struct xfs_buf_ops xfs_finobt_buf_ops;
      extern const struct xfs_buf_ops xfs_inobt_buf_ops;
      extern const struct xfs_buf_ops xfs_inode_buf_ops;
    @@ fs/xfs/scrub/rtsummary_repair.c: xrep_rtsummary_prep_buf(
      }
      
      /* Repair the realtime summary. */
     
      ## fs/xfs/xfs_buf_item_recover.c ##
     @@
    - #include "xfs_log_recover.h"
    - #include "xfs_error.h"
    - #include "xfs_inode.h"
      #include "xfs_dir2.h"
      #include "xfs_quota.h"
    + #include "xfs_alloc.h"
    + #include "xfs_ag.h"
    + #include "xfs_sb.h"
      #include "xfs_rtgroup.h"
     +#include "xfs_rtbitmap.h"
      
      /*
       * This is the number of entries in the l_buf_cancel_table used during
       * recovery.
112:  7c46a5a77e8b91 = 120:  9eef6f9a67abe5 xfs: encode the rtbitmap in big endian format
113:  b6c7f4f9d44d54 = 121:  bab07380b7cf5f xfs: encode the rtsummary in big endian format
114:  e034ac74cb3804 = 122:  c2290446af8946 xfs: grow the realtime section when realtime groups are enabled
115:  bb80bc870fc76f ! 123:  61b2f36ed0e863 xfs: store rtgroup information with a bmap intent
    @@ Commit message
         As a bonus, we can rework the xfs_bmap_deferred_class tracepoint to use
         the xfs_group object to figure out the type and group number, widen the
         group block number field to fit 64-bit quantities, and get rid of the
         now redundant opdev and rtblock fields.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/xfs_bmap_item.c ##
     @@ fs/xfs/xfs_bmap_item.c: xfs_bmap_update_create_done(
      	budp->bud_buip = buip;
      	budp->bud_format.bud_bui_id = buip->bui_format.bui_id;
      
    @@ fs/xfs/xfs_trace.h: TRACE_DEFINE_ENUM(XFS_BMAP_UNMAP);
     -		__entry->dev = ip->i_mount->m_super->s_dev;
     -		if (xfs_ifork_is_realtime(ip, bi->bi_whichfork)) {
     -			__entry->agno = 0;
     -			__entry->agbno = 0;
     -			__entry->rtbno = bi->bi_bmap.br_startblock;
     -			__entry->opdev = ip->i_mount->m_rtdev_targp->bt_dev;
    --		} else {
    --			__entry->agno = XFS_FSB_TO_AGNO(ip->i_mount,
     +		__entry->dev = mp->m_super->s_dev;
     +		__entry->type = bi->bi_group->xg_type;
    -+		__entry->agno = bi->bi_group->xg_index;
    -+		switch (__entry->type) {
    -+		case XG_TYPE_RTG:
    ++		__entry->agno = bi->bi_group->xg_gno;
    ++		if (bi->bi_group->xg_type == XG_TYPE_RTG &&
    ++		    !xfs_has_rtgroups(mp)) {
     +			/*
    -+			 * Use the 64-bit version of xfs_rtb_to_rgbno because
    -+			 * legacy rt filesystems can have group block numbers
    -+			 * that exceed the size of an xfs_rgblock_t.
    ++			 * Legacy rt filesystems do not have allocation groups
    ++			 * ondisk.  We emulate this incore with one gigantic
    ++			 * rtgroup whose size can exceed a 32-bit block number.
    ++			 * For this tracepoint, we report group 0 and a 64-bit
    ++			 * group block number.
     +			 */
    -+			__entry->gbno = __xfs_rtb_to_rgbno(mp,
    - 						bi->bi_bmap.br_startblock);
    ++			__entry->gbno = bi->bi_bmap.br_startblock;
    + 		} else {
    +-			__entry->agno = XFS_FSB_TO_AGNO(ip->i_mount,
    +-						bi->bi_bmap.br_startblock);
     -			__entry->agbno = XFS_FSB_TO_AGBNO(ip->i_mount,
    -+			break;
    -+		case XG_TYPE_AG:
    -+			__entry->gbno = XFS_FSB_TO_AGBNO(mp,
    - 						bi->bi_bmap.br_startblock);
    +-						bi->bi_bmap.br_startblock);
     -			__entry->rtbno = 0;
     -			__entry->opdev = __entry->dev;
    -+			break;
    -+		default:
    -+			/* should never happen */
    -+			__entry->gbno = -1ULL;
    -+			break;
    ++			__entry->gbno = xfs_fsb_to_gbno(mp,
    ++						bi->bi_bmap.br_startblock,
    ++						bi->bi_group->xg_type);
      		}
      		__entry->ino = ip->i_ino;
      		__entry->whichfork = bi->bi_whichfork;
      		__entry->l_loff = bi->bi_bmap.br_startoff;
      		__entry->l_len = bi->bi_bmap.br_blockcount;
      		__entry->l_state = bi->bi_bmap.br_state;
116:  be2705171f58d2 = 124:  478bc085b3a60b xfs: force swapext to a realtime file to use the file content exchange ioctl
117:  c7e5979d73474d ! 125:  5f8476033dd13c xfs: support logging EFIs for realtime extents
    @@ fs/xfs/xfs_trace.h: DEFINE_DEFER_PENDING_EVENT(xfs_defer_item_unpause);
      	),
      	TP_fast_assign(
      		__entry->dev = mp->m_super->s_dev;
     -		__entry->agno = XFS_FSB_TO_AGNO(mp, free->xefi_startblock);
     -		__entry->agbno = XFS_FSB_TO_AGBNO(mp, free->xefi_startblock);
     +		__entry->type = free->xefi_group->xg_type;
    -+		__entry->agno = free->xefi_group->xg_index;
    -+		if (free->xefi_group->xg_type == XG_TYPE_RTG)
    -+			__entry->agbno = xfs_rtb_to_rgbno(mp,
    -+						free->xefi_startblock);
    -+		else
    -+			__entry->agbno = XFS_FSB_TO_AGBNO(mp,
    -+						free->xefi_startblock);
    ++		__entry->agno = free->xefi_group->xg_gno;
    ++		__entry->agbno = xfs_fsb_to_gbno(mp, free->xefi_startblock,
    ++						free->xefi_group->xg_type);
      		__entry->len = free->xefi_blockcount;
      		__entry->flags = free->xefi_flags;
      	),
     -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x flags 0x%x",
     +	TP_printk("dev %d:%d %sno 0x%x gbno 0x%x fsbcount 0x%x flags 0x%x",
      		  MAJOR(__entry->dev), MINOR(__entry->dev),
118:  cc8831465c3ad7 = 126:  fc08c2da763894 xfs: support error injection when freeing rt extents
119:  bd790bec2be60c = 127:  acfd5dfbd81054 xfs: use realtime EFI to free extents when rtgroups are enabled
120:  be5d97b6f58f07 ! 128:  35979493348d2c xfs: don't merge ioends across RTGs
    @@
      ## Metadata ##
    -Author: Christoph Hellwig <hch@lst.de>
    +Author: Darrick J. Wong <djwong@kernel.org>
     
      ## Commit message ##
         xfs: don't merge ioends across RTGs
     
         Unlike AGs, RTGs don't always have metadata in their first blocks, and
         thus we don't get automatic protection from merging I/O completions
    @@ Commit message
         merged into the previous ioend.
     
         Signed-off-by: Christoph Hellwig <hch@lst.de>
         Reviewed-by: Darrick J. Wong <djwong@kernel.org>
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
     
    + ## fs/xfs/libxfs/xfs_rtgroup.h ##
    +@@ fs/xfs/libxfs/xfs_rtgroup.h: xfs_rtb_to_rgbno(
    + 	struct xfs_mount	*mp,
    + 	xfs_rtblock_t		rtbno)
    + {
    + 	return __xfs_rtb_to_rgbno(mp, rtbno);
    + }
    + 
    ++/* Is rtbno the start of a RT group? */
    ++static inline bool
    ++xfs_rtbno_is_group_start(
    ++	struct xfs_mount	*mp,
    ++	xfs_rtblock_t		rtbno)
    ++{
    ++	return (rtbno & mp->m_rgblkmask) == 0;
    ++}
    ++
    + static inline xfs_daddr_t
    + xfs_rtb_to_daddr(
    + 	struct xfs_mount	*mp,
    + 	xfs_rtblock_t		rtbno)
    + {
    + 	return rtbno << mp->m_blkbb_log;
    +
      ## fs/xfs/xfs_iomap.c ##
     @@
      #include "xfs_trans.h"
      #include "xfs_trans_space.h"
      #include "xfs_inode_item.h"
      #include "xfs_iomap.h"
    @@ fs/xfs/xfs_iomap.c: xfs_bmbt_to_iomap(
     +		/*
     +		 * Mark iomaps starting at the first sector of a RTG as merge
     +		 * boundary so that each I/O completions is contained to a
     +		 * single RTG.
     +		 */
     +		if (XFS_IS_REALTIME_INODE(ip) && xfs_has_rtgroups(mp) &&
    -+		    xfs_rtb_to_rtx(mp, imap->br_startblock) == 0 &&
    -+		    xfs_rtb_to_rtxoff(mp, imap->br_startblock) == 0)
    ++		    xfs_rtbno_is_group_start(mp, imap->br_startblock))
     +			iomap->flags |= IOMAP_F_BOUNDARY;
      	}
      	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
      	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
      	if (mapping_flags & IOMAP_DAX)
      		iomap->dax_dev = target->bt_daxdev;
121:  d6d088ad27100f = 129:  165c6c12bda9c5 xfs: make the RT allocator rtgroup aware
122:  e18f577b25f569 = 130:  609734437aedfb xfs: don't coalesce file mappings that cross rtgroup boundaries in scrub
123:  618de21edb575d = 131:  b899710c4ebb26 xfs: scrub the realtime group superblock
124:  0d863793338205 = 132:  fad59b9edfb345 xfs: repair realtime group superblock
125:  a4659344303a41 = 133:  cb213fa59295a7 xfs: scrub metadir paths for rtgroup metadata
126:  b8b0b1e9ef57ed ! 134:  a19c0cb09426c9 xfs: mask off the rtbitmap and summary inodes when metadir in use
    @@ fs/xfs/libxfs/xfs_sb.c: xfs_validate_sb_common(
      	return 0;
      }
      
      void
      xfs_sb_quota_from_disk(struct xfs_sb *sbp)
      {
    -+	if (xfs_sb_version_hasmetadir(sbp)) {
    ++	if (xfs_sb_is_v5(sbp) &&
    ++	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)) {
     +		sbp->sb_uquotino = NULLFSINO;
     +		sbp->sb_gquotino = NULLFSINO;
     +		sbp->sb_pquotino = NULLFSINO;
     +		return;
     +	}
     +
    @@ fs/xfs/libxfs/xfs_sb.c: xfs_validate_sb_common(
      	 * older mkfs doesn't initialize quota inodes to NULLFSINO. This
      	 * leads to in-core values having two different values for a quota
      	 * inode to be invalid: 0 and NULLFSINO. Change it to a single value
      	 * NULLFSINO.
      	 *
     @@ fs/xfs/libxfs/xfs_sb.c: __xfs_sb_from_disk(
    + 		xfs_sb_quota_from_disk(to);
      
      	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
      		to->sb_metadirino = be64_to_cpu(from->sb_metadirino);
    - 		to->sb_metadirpad = be32_to_cpu(from->sb_metadirpad);
      		to->sb_rgcount = be32_to_cpu(from->sb_rgcount);
      		to->sb_rgextents = be32_to_cpu(from->sb_rgextents);
     +		to->sb_rbmino = NULLFSINO;
     +		to->sb_rsumino = NULLFSINO;
      	} else {
      		to->sb_metadirino = NULLFSINO;
    - 		to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
      		to->sb_rgcount = 1;
      		to->sb_rgextents = 0;
      	}
    + }
     @@ fs/xfs/libxfs/xfs_sb.c: static void
      xfs_sb_quota_to_disk(
      	struct xfs_dsb	*to,
      	struct xfs_sb	*from)
      {
      	uint16_t	qflags = from->sb_qflags;
      
    -+	if (xfs_sb_version_hasmetadir(from)) {
    ++	if (xfs_sb_is_v5(from) &&
    ++	    (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)) {
     +		to->sb_uquotino = cpu_to_be64(0);
     +		to->sb_gquotino = cpu_to_be64(0);
     +		to->sb_pquotino = cpu_to_be64(0);
     +		return;
     +	}
     +
    @@ fs/xfs/libxfs/xfs_sb.c: static void
      
      	/*
      	 * The in-memory superblock quota state matches the v5 on-disk format so
      	 * just write them out and return
      	 */
     @@ fs/xfs/libxfs/xfs_sb.c: xfs_sb_to_disk(
    + 		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
      
      	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
      		to->sb_metadirino = cpu_to_be64(from->sb_metadirino);
    - 		to->sb_metadirpad = 0;
      		to->sb_rgcount = cpu_to_be32(from->sb_rgcount);
      		to->sb_rgextents = cpu_to_be32(from->sb_rgextents);
     +		to->sb_rbmino = cpu_to_be64(0);
     +		to->sb_rsumino = cpu_to_be64(0);
      	}
      }
127:  2f8c1c31e2e270 ! 135:  bd27b9e5f7d669 xfs: create helpers to deal with rounding xfs_fileoff_t to rtx boundaries
    @@ Commit message
     
         We're about to segment xfs_rtblock_t addresses, so we must create
         type-specific helpers to do rt extent rounding of file block offsets
         because the rtb helpers soon will not do the right thing there.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/libxfs/xfs_rtbitmap.h ##
     @@ fs/xfs/libxfs/xfs_rtbitmap.h: xfs_rtb_roundup_rtx(
      	struct xfs_mount	*mp,
      	xfs_rtblock_t		rtbno)
      {
128:  d6bf2d6f485bce ! 136:  7ec93f29d7d922 xfs: create helpers to deal with rounding xfs_filblks_t to rtx boundaries
    @@ Commit message
     
         We're about to segment xfs_rtblock_t addresses, so we must create
         type-specific helpers to do rt extent rounding of file mapping block
         lengths because the rtb helpers soon will not do the right thing there.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/libxfs/xfs_rtbitmap.c ##
     @@ fs/xfs/libxfs/xfs_rtbitmap.c: xfs_rtfree_blocks(
      {
      	struct xfs_mount	*mp = tp->t_mountp;
      	xfs_extlen_t		mod;
129:  b1bfcb3095413d ! 137:  a36f2496e1fc93 xfs: make xfs_rtblock_t a segmented address like xfs_fsblock_t
    @@ Commit message
         instead of integer division.
     
         While in theory we could continue caching the rgno shift value in
         m_rgblklog, the fact that we now always use the shift value means that
         we have an opportunity to increase the redundancy of the rt geometry by
         storing it in the ondisk superblock and adding more sb verifier code.
    -    Reuse the space vacated by sb_bad_feature2 to store the rgblklog value.
    +    Extend the sueprblock to store the rgblklog value.
    +
    +    Now that we have segmented addresses, set the correct values in
    +    m_groups[XG_TYPE_RTG] so that the xfs_group helpers work correctly.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
     
      ## fs/xfs/libxfs/xfs_bmap.c ##
     @@ fs/xfs/libxfs/xfs_bmap.c: xfs_bmap_adjacent_valid(
      	xfs_fsblock_t		y)
    @@ fs/xfs/libxfs/xfs_bmap.c: xfs_bmap_adjacent_valid(
      			xfs_rtb_to_rtx(mp, x) < mp->m_sb.sb_rgextents;
      
      	}
     
      ## fs/xfs/libxfs/xfs_format.h ##
     @@ fs/xfs/libxfs/xfs_format.h: typedef struct xfs_sb {
    - 		uint32_t	sb_bad_features2;
      
    - 		/*
    - 		 * Metadir filesystems define this field to be zero since they
    - 		 * have never had this 64-bit alignment problem.
    - 		 */
    --		uint32_t	sb_metadirpad;
    -+		struct {
    -+			uint8_t	sb_rgblklog;    /* rt group number shift */
    -+			uint8_t	sb_metadirpad0; /* zeroes */
    -+			uint16_t sb_metadirpad1; /* zeroes */
    -+		};
    - 	} __packed;
    + 	xfs_ino_t	sb_metadirino;	/* metadata directory tree root */
      
    - 	/* version 5 superblock fields start here */
    + 	xfs_rgnumber_t	sb_rgcount;	/* number of realtime groups */
    + 	xfs_rtxlen_t	sb_rgextents;	/* size of a realtime group in rtx */
      
    - 	/* feature masks */
    - 	uint32_t	sb_features_compat;
    ++	uint8_t		sb_rgblklog;    /* rt group number shift */
    ++	uint8_t		sb_pad[7];	/* zeroes */
    ++
    + 	/* must be padded to 64 bit alignment */
    + } xfs_sb_t;
    + 
    + /*
    +  * Superblock - on disk version.
    +  * Must be padded to 64 bit alignment.
     @@ fs/xfs/libxfs/xfs_format.h: struct xfs_dsb {
    - 		 * for features2 bits. Easiest just to mark it bad and not use
    - 		 * it for anything else.
    - 		 */
    - 		__be32		sb_bad_features2;
    + 	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
      
    - 		/*
    --		 * Metadir filesystems define this field to be zero since they
    --		 * have never had this 64-bit alignment problem.
    -+		 * Metadir filesystems use this space since they have never had
    -+		 * this 64-bit alignment problem.
    - 		 */
    --		__be32		sb_metadirpad;
    -+		struct {
    -+			__u8	sb_rgblklog;    /* rt group number shift */
    -+			__u8	sb_metadirpad0; /* zeroes */
    -+			__u16	sb_metadirpad1; /* zeroes */
    -+		};
    - 	} __packed;
    + 	__be64		sb_metadirino;	/* metadata directory tree root */
    + 	__be32		sb_rgcount;	/* # of realtime groups */
    + 	__be32		sb_rgextents;	/* size of rtgroup in rtx */
      
    - 	/* version 5 superblock fields start here */
    - 
    - 	/* feature masks */
    - 	__be32		sb_features_compat;
    ++	__u8		sb_rgblklog;    /* rt group number shift */
    ++	__u8		sb_pad[7];	/* zeroes */
    ++
    + 	/*
    + 	 * The size of this structure must be padded to 64 bit alignment.
    + 	 *
    + 	 * NOTE: Don't forget to update secondary_sb_whack in xfs_repair when
    + 	 * adding new fields here.
    + 	 */
    +
    + ## fs/xfs/libxfs/xfs_ondisk.h ##
    +@@ fs/xfs/libxfs/xfs_ondisk.h: xfs_check_ondisk_structs(void)
    + 	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block_shdr,	48);
    + 	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block_lhdr,	64);
    + 	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block,		72);
    + 	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
    + 	XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
    + 	XFS_CHECK_STRUCT_SIZE(struct xfs_dqblk,			136);
    +-	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			280);
    ++	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			288);
    + 	XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
    + 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_key,		4);
    + 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_rec,		16);
    + 	XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_key,		4);
    + 	XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_rec,		12);
    + 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_key,		20);
     
      ## fs/xfs/libxfs/xfs_rtbitmap.h ##
    -@@ fs/xfs/libxfs/xfs_rtbitmap.h: xfs_rtb_to_rtx(
    +@@ fs/xfs/libxfs/xfs_rtbitmap.h: struct xfs_rtalloc_args {
    + static inline xfs_rtblock_t
    + xfs_rtx_to_rtb(
    + 	struct xfs_rtgroup	*rtg,
    + 	xfs_rtxnum_t		rtx)
    + {
    + 	struct xfs_mount	*mp = rtg_mount(rtg);
    +-	xfs_rtblock_t		start = xfs_rgno_start_rtb(mp, rtg_rgno(rtg));
    ++	xfs_rtblock_t		start = xfs_group_start_fsb(rtg_group(rtg));
    + 
    + 	if (mp->m_rtxblklog >= 0)
    + 		return start + (rtx << mp->m_rtxblklog);
    + 	return start + (rtx * mp->m_sb.sb_rextsize);
    + }
    + 
    +@@ fs/xfs/libxfs/xfs_rtbitmap.h: xfs_blen_roundup_rtx(
    + /* Convert an rt block number into an rt extent number. */
    + static inline xfs_rtxnum_t
    + xfs_rtb_to_rtx(
    + 	struct xfs_mount	*mp,
    + 	xfs_rtblock_t		rtbno)
    + {
    +-	uint64_t		__rgbno = __xfs_rtb_to_rgbno(mp, rtbno);
    +-
    ++	/* open-coded 64-bit masking operation */
    ++	rtbno &= mp->m_groups[XG_TYPE_RTG].blkmask;
    + 	if (likely(mp->m_rtxblklog >= 0))
    +-		return __rgbno >> mp->m_rtxblklog;
    +-	return div_u64(__rgbno, mp->m_sb.sb_rextsize);
    ++		return rtbno >> mp->m_rtxblklog;
    ++	return div_u64(rtbno, mp->m_sb.sb_rextsize);
    + }
    + 
      /* Return the offset of an rt block number within an rt extent. */
      static inline xfs_extlen_t
      xfs_rtb_to_rtxoff(
      	struct xfs_mount	*mp,
      	xfs_rtblock_t		rtbno)
      {
    -+	uint64_t		__rgbno = __xfs_rtb_to_rgbno(mp, rtbno);
    -+
    ++	/* open-coded 64-bit masking operation */
    ++	rtbno &= mp->m_groups[XG_TYPE_RTG].blkmask;
      	if (likely(mp->m_rtxblklog >= 0))
    --		return rtbno & mp->m_rtxblkmask;
    -+		return __rgbno & mp->m_rtxblkmask;
    - 
    --	return do_div(rtbno, mp->m_sb.sb_rextsize);
    -+	return do_div(__rgbno, mp->m_sb.sb_rextsize);
    + 		return rtbno & mp->m_rtxblkmask;
    +-
    + 	return do_div(rtbno, mp->m_sb.sb_rextsize);
      }
      
      /* Round this file block offset up to the nearest rt extent size. */
      static inline xfs_rtblock_t
      xfs_fileoff_roundup_rtx(
    - 	struct xfs_mount	*mp,
     
      ## fs/xfs/libxfs/xfs_rtgroup.h ##
     @@ fs/xfs/libxfs/xfs_rtgroup.h: xfs_rtgroup_next(
    - 
    - static inline xfs_rtblock_t
    - xfs_rgno_start_rtb(
      	struct xfs_mount	*mp,
    - 	xfs_rgnumber_t		rgno)
    + 	struct xfs_rtgroup	*rtg)
      {
    + 	return xfs_rtgroup_next_range(mp, rtg, 0, mp->m_sb.sb_rgcount - 1);
    + }
    + 
    +-static inline xfs_rtblock_t
    +-xfs_rgno_start_rtb(
    +-	struct xfs_mount	*mp,
    +-	xfs_rgnumber_t		rgno)
    +-{
     -	if (mp->m_rgblklog >= 0)
     -		return ((xfs_rtblock_t)rgno << mp->m_rgblklog);
     -	return ((xfs_rtblock_t)rgno * mp->m_rgblocks);
    -+	if (!xfs_has_rtgroups(mp))
    -+		return 0;
    -+	return ((xfs_rtblock_t)rgno << mp->m_sb.sb_rgblklog);
    - }
    - 
    +-}
    +-
    +-static inline xfs_rtblock_t
    +-__xfs_rgbno_to_rtb(
    +-	struct xfs_mount	*mp,
    +-	xfs_rgnumber_t		rgno,
    +-	xfs_rgblock_t		rgbno)
    +-{
    +-	return xfs_rgno_start_rtb(mp, rgno) + rgbno;
    +-}
    +-
      static inline xfs_rtblock_t
    - __xfs_rgbno_to_rtb(
    - 	struct xfs_mount	*mp,
    - 	xfs_rgnumber_t		rgno,
    -@@ fs/xfs/libxfs/xfs_rtgroup.h: xfs_rtb_to_rgno(
    + xfs_rgbno_to_rtb(
    + 	struct xfs_rtgroup	*rtg,
    + 	xfs_rgblock_t		rgbno)
    + {
    +-	return __xfs_rgbno_to_rtb(rtg_mount(rtg), rtg_rgno(rtg), rgbno);
    ++	return xfs_gbno_to_fsb(rtg_group(rtg), rgbno);
    + }
    + 
    + static inline xfs_rgnumber_t
    + xfs_rtb_to_rgno(
      	struct xfs_mount	*mp,
      	xfs_rtblock_t		rtbno)
      {
    - 	if (!xfs_has_rtgroups(mp))
    - 		return 0;
    - 
    +-	if (!xfs_has_rtgroups(mp))
    +-		return 0;
    +-
     -	if (mp->m_rgblklog >= 0)
     -		return rtbno >> mp->m_rgblklog;
     -
     -	return div_u64(rtbno, mp->m_rgblocks);
    -+	return rtbno >> mp->m_sb.sb_rgblklog;
    - }
    - 
    - static inline uint64_t
    - __xfs_rtb_to_rgbno(
    - 	struct xfs_mount	*mp,
    - 	xfs_rtblock_t		rtbno)
    - {
    +-}
    +-
    +-static inline uint64_t
    +-__xfs_rtb_to_rgbno(
    +-	struct xfs_mount	*mp,
    +-	xfs_rtblock_t		rtbno)
    +-{
     -	uint32_t		rem;
     -
    - 	if (!xfs_has_rtgroups(mp))
    - 		return rtbno;
    - 
    +-	if (!xfs_has_rtgroups(mp))
    +-		return rtbno;
    +-
     -	if (mp->m_rgblklog >= 0)
     -		return rtbno & mp->m_rgblkmask;
     -
     -	div_u64_rem(rtbno, mp->m_rgblocks, &rem);
     -	return rem;
    -+	return rtbno & mp->m_rgblkmask;
    ++	return xfs_fsb_to_gno(mp, rtbno, XG_TYPE_RTG);
      }
      
      static inline xfs_rgblock_t
      xfs_rtb_to_rgbno(
      	struct xfs_mount	*mp,
      	xfs_rtblock_t		rtbno)
    -@@ fs/xfs/libxfs/xfs_rtgroup.h: xfs_rtb_to_rgbno(
    + {
    +-	return __xfs_rtb_to_rgbno(mp, rtbno);
    ++	return xfs_fsb_to_gbno(mp, rtbno, XG_TYPE_RTG);
    + }
    + 
    + /* Is rtbno the start of a RT group? */
    + static inline bool
    + xfs_rtbno_is_group_start(
    + 	struct xfs_mount	*mp,
    + 	xfs_rtblock_t		rtbno)
    + {
    +-	return (rtbno & mp->m_rgblkmask) == 0;
    ++	return (rtbno & mp->m_groups[XG_TYPE_RTG].blkmask) == 0;
    + }
      
      static inline xfs_daddr_t
      xfs_rtb_to_daddr(
      	struct xfs_mount	*mp,
      	xfs_rtblock_t		rtbno)
      {
     -	return rtbno << mp->m_blkbb_log;
    ++	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
     +	xfs_rgnumber_t		rgno = xfs_rtb_to_rgno(mp, rtbno);
    -+	uint64_t		start_bno = (xfs_rtblock_t)rgno * mp->m_rgblocks;
    ++	uint64_t		start_bno = (xfs_rtblock_t)rgno * g->blocks;
     +
    -+	return XFS_FSB_TO_BB(mp, start_bno + (rtbno & mp->m_rgblkmask));
    ++	return XFS_FSB_TO_BB(mp, start_bno + (rtbno & g->blkmask));
      }
      
      static inline xfs_rtblock_t
      xfs_daddr_to_rtb(
      	struct xfs_mount	*mp,
      	xfs_daddr_t		daddr)
      {
     -	return daddr >> mp->m_blkbb_log;
     +	xfs_rfsblock_t		bno = XFS_BB_TO_FSBT(mp, daddr);
     +
     +	if (xfs_has_rtgroups(mp)) {
    ++		struct xfs_groups *g = &mp->m_groups[XG_TYPE_RTG];
     +		xfs_rgnumber_t	rgno;
     +		uint32_t	rgbno;
     +
    -+		rgno = div_u64_rem(bno, mp->m_rgblocks, &rgbno);
    -+		return ((xfs_rtblock_t)rgno << mp->m_sb.sb_rgblklog) + rgbno;
    ++		rgno = div_u64_rem(bno, g->blocks, &rgbno);
    ++		return ((xfs_rtblock_t)rgno << g->blklog) + rgbno;
     +	}
     +
     +	return bno;
      }
      
      #ifdef CONFIG_XFS_RT
    @@ fs/xfs/libxfs/xfs_sb.c: xfs_validate_sb_common(
      					 sbp->sb_inoalignmt, align);
      				return -EINVAL;
      			}
      		}
      
      		if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
    --			if (sbp->sb_metadirpad) {
    -+			if (sbp->sb_metadirpad0 || sbp->sb_metadirpad1) {
    - 				xfs_warn(mp,
    --"Metadir superblock padding field (%d) must be zero.",
    --						sbp->sb_metadirpad);
    ++			if (memchr_inv(sbp->sb_pad, 0, sizeof(sbp->sb_pad))) {
    ++				xfs_warn(mp,
     +"Metadir superblock padding fields must be zero.");
    - 				return -EINVAL;
    - 			}
    - 
    ++				return -EINVAL;
    ++			}
    ++
      			error = xfs_validate_sb_rtgroups(mp, sbp);
      			if (error)
      				return error;
    + 		}
    + 	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
    + 				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
     @@ fs/xfs/libxfs/xfs_sb.c: __xfs_sb_from_disk(
      	/* Convert on-disk flags to in-memory flags? */
      	if (convert_xquota)
      		xfs_sb_quota_from_disk(to);
      
      	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
      		to->sb_metadirino = be64_to_cpu(from->sb_metadirino);
    --		to->sb_metadirpad = be32_to_cpu(from->sb_metadirpad);
     +		to->sb_rgblklog = from->sb_rgblklog;
    -+		to->sb_metadirpad0 = from->sb_metadirpad0;
    -+		to->sb_metadirpad1 = be16_to_cpu(from->sb_metadirpad1);
    ++		memcpy(to->sb_pad, from->sb_pad, sizeof(to->sb_pad));
      		to->sb_rgcount = be32_to_cpu(from->sb_rgcount);
      		to->sb_rgextents = be32_to_cpu(from->sb_rgextents);
      		to->sb_rbmino = NULLFSINO;
      		to->sb_rsumino = NULLFSINO;
      	} else {
      		to->sb_metadirino = NULLFSINO;
    @@ fs/xfs/libxfs/xfs_sb.c: xfs_sb_to_disk(
      	to->sb_lsn = cpu_to_be64(from->sb_lsn);
      	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID)
      		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
      
      	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
      		to->sb_metadirino = cpu_to_be64(from->sb_metadirino);
    --		to->sb_metadirpad = 0;
     +		to->sb_rgblklog = from->sb_rgblklog;
    -+		to->sb_metadirpad0 = 0;
    -+		to->sb_metadirpad1 = 0;
    ++		memset(to->sb_pad, 0, sizeof(to->sb_pad));
      		to->sb_rgcount = cpu_to_be32(from->sb_rgcount);
      		to->sb_rgextents = cpu_to_be32(from->sb_rgextents);
      		to->sb_rbmino = cpu_to_be64(0);
      		to->sb_rsumino = cpu_to_be64(0);
      	}
      }
    @@ fs/xfs/libxfs/xfs_sb.c: const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
      void
     -xfs_mount_sb_set_rextsize(
     +xfs_sb_mount_rextsize(
      	struct xfs_mount	*mp,
      	struct xfs_sb		*sbp)
      {
    + 	struct xfs_groups	*rgs = &mp->m_groups[XG_TYPE_RTG];
    + 
      	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
      	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
      
     -	mp->m_rgblocks = sbp->sb_rgextents * sbp->sb_rextsize;
     -	mp->m_rgblklog = log2_if_power2(mp->m_rgblocks);
     -	mp->m_rgblkmask = mask64_if_power2(mp->m_rgblocks);
    -+	if (xfs_sb_version_hasmetadir(sbp)) {
    -+		mp->m_rgblocks = sbp->sb_rgextents * sbp->sb_rextsize;
    -+		mp->m_rgblkmask = (1ULL << sbp->sb_rgblklog) - 1;
    ++	if (xfs_sb_is_v5(sbp) &&
    ++	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)) {
    ++		rgs->blocks = sbp->sb_rgextents * sbp->sb_rextsize;
    ++		rgs->blklog = mp->m_sb.sb_rgblklog;
    ++		rgs->blkmask = xfs_mask32lo(mp->m_sb.sb_rgblklog);
     +	} else {
    -+		mp->m_rgblocks = 0;
    -+		mp->m_rgblkmask = 0;
    ++		rgs->blocks = 0;
    ++		rgs->blklog = 0;
    ++		rgs->blkmask = (uint64_t)-1;
     +	}
     +}
    -+
    + 
    +-	rgs->blocks = 0;
    +-	rgs->blklog = 0;
    +-	rgs->blkmask = (uint64_t)-1;
     +/* Update incore sb rt extent size, then recompute the cached rt geometry. */
     +void
     +xfs_mount_sb_set_rextsize(
     +	struct xfs_mount	*mp,
     +	struct xfs_sb		*sbp,
     +	xfs_agblock_t		rextsize)
     +{
     +	sbp->sb_rextsize = rextsize;
    -+	if (xfs_sb_version_hasmetadir(sbp))
    ++	if (xfs_sb_is_v5(sbp) &&
    ++	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR))
     +		sbp->sb_rgblklog = xfs_compute_rgblklog(sbp->sb_rgextents,
     +							rextsize);
     +
     +	xfs_sb_mount_rextsize(mp, sbp);
      }
      
      /*
       * xfs_mount_common
       *
       * Mount initialization code establishing various mount
     @@ fs/xfs/libxfs/xfs_sb.c: xfs_sb_mount_common(
    - 	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
    - 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
    - 	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
    - 	mp->m_blockmask = sbp->sb_blocksize - 1;
    - 	mp->m_blockwsize = xfs_rtbmblock_size(sbp) >> XFS_WORDLOG;
      	mp->m_rtx_per_rbmblock = mp->m_blockwsize << XFS_NBWORDLOG;
    + 
    + 	ags->blocks = mp->m_sb.sb_agblocks;
    + 	ags->blklog = mp->m_sb.sb_agblklog;
    + 	ags->blkmask = xfs_mask32lo(mp->m_sb.sb_agblklog);
    + 
     -	xfs_mount_sb_set_rextsize(mp, sbp);
     +	xfs_sb_mount_rextsize(mp, sbp);
      
      	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, true);
      	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, false);
      	mp->m_alloc_mnr[0] = mp->m_alloc_mxr[0] / 2;
    @@ fs/xfs/libxfs/xfs_types.c: xfs_verify_dir_ino(
       * Verify that an allocated realtime device extent neither points outside
       * allocatable areas of the rtgroup, across an rtgroup boundary, nor off the
       * end of the realtime device.
     
      ## fs/xfs/scrub/agheader.c ##
     @@ fs/xfs/scrub/agheader.c: xchk_superblock(
    + 		if (xfs_sb_is_v5(&mp->m_sb))
      			v2_ok |= XFS_SB_VERSION2_CRCBIT;
      
      		if (!!(sb->sb_features2 & cpu_to_be32(~v2_ok)))
      			xchk_block_set_corrupt(sc, bp);
      
    - 		if (xfs_has_metadir(mp)) {
    --			if (sb->sb_metadirpad)
    +-		if (sb->sb_features2 != sb->sb_bad_features2)
    +-			xchk_block_set_preen(sc, bp);
    ++		if (xfs_has_metadir(mp)) {
     +			if (sb->sb_rgblklog != mp->m_sb.sb_rgblklog)
     +				xchk_block_set_corrupt(sc, bp);
    -+			if (sb->sb_metadirpad0 || sb->sb_metadirpad1)
    - 				xchk_block_set_preen(sc, bp);
    - 		} else {
    - 			if (sb->sb_features2 != sb->sb_bad_features2)
    - 				xchk_block_set_preen(sc, bp);
    - 		}
    ++			if (memchr_inv(sb->sb_pad, 0, sizeof(sb->sb_pad)))
    ++				xchk_block_set_preen(sc, bp);
    ++		} else {
    ++			if (sb->sb_features2 != sb->sb_bad_features2)
    ++				xchk_block_set_preen(sc, bp);
    ++		}
      	}
    + 
    + 	/* Check sb_features2 flags that are set at mkfs time. */
    + 	features_mask = cpu_to_be32(XFS_SB_VERSION2_LAZYSBCOUNTBIT |
    + 				    XFS_SB_VERSION2_PROJID32BIT |
    + 				    XFS_SB_VERSION2_CRCBIT |
     
      ## fs/xfs/xfs_mount.h ##
     @@ fs/xfs/xfs_mount.h: typedef struct xfs_mount {
      	int			m_bsize;	/* fs logical block size */
      	uint8_t			m_blkbit_log;	/* blocklog + NBBY */
      	uint8_t			m_blkbb_log;	/* blocklog - BBSHIFT */
    @@ fs/xfs/xfs_mount.h: typedef struct xfs_mount {
      	uint			m_blockmask;	/* sb_blocksize-1 */
      	uint			m_blockwsize;	/* sb_blocksize in words */
      	/* number of rt extents per rt bitmap block if rtgroups enabled */
      	unsigned int		m_rtx_per_rbmblock;
      	uint			m_alloc_mxr[2];	/* max alloc btree records */
      	uint			m_alloc_mnr[2];	/* min alloc btree records */
    +@@ fs/xfs/xfs_mount.h: typedef struct xfs_mount {
    + 	uint			m_allocsize_log;/* min write size log bytes */
    + 	uint			m_allocsize_blocks; /* min write size blocks */
    + 	int			m_logbufs;	/* number of log buffers */
    + 	int			m_logbsize;	/* size of each log buffer */
    + 	unsigned int		m_rsumlevels;	/* rt summary levels */
    + 	xfs_filblks_t		m_rsumblocks;	/* size of rt summary, FSBs */
    +-	uint32_t		m_rgblocks;	/* size of rtgroup in rtblocks */
    + 	int			m_fixedfsid[2];	/* unchanged for life of FS */
    + 	uint			m_qflags;	/* quota status flags */
    + 	uint64_t		m_features;	/* active filesystem features */
    + 	uint64_t		m_low_space[XFS_LOWSP_MAX];
    + 	uint64_t		m_low_rtexts[XFS_LOWSP_MAX];
    + 	uint64_t		m_rtxblkmask;	/* rt extent block mask */
    +-	uint64_t		m_rgblkmask;	/* rt group block mask */
    + 	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
    + 	struct xfs_trans_resv	m_resv;		/* precomputed res values */
    + 						/* low free space thresholds */
    + 	unsigned long		m_opstate;	/* dynamic state flags */
    + 	bool			m_always_cow;
    + 	bool			m_fail_unmount;
     
      ## fs/xfs/xfs_rtalloc.c ##
     @@ fs/xfs/xfs_rtalloc.c: xfs_growfs_rt_alloc_fake_mount(
      {
      	struct xfs_mount	*nmp;
      
130:  c9302578220751 <   -:  -------------- xfs: move the group geometry into struct xfs_groups
131:  c8f10b926b71eb <   -:  -------------- xfs: add a xfs_rtbno_is_group_start helper
132:  60a200a2474a90 ! 138:  6c43280f83a896 xfs: fix minor bug in xfs_verify_agbno
    @@
      ## Metadata ##
     Author: Darrick J. Wong <djwong@kernel.org>
     
      ## Commit message ##
    -    xfs: fix minor bug in xfs_verify_agbno
    +    xfs: adjust min_block usage in xfs_verify_agbno
     
    -    There's a minor bug in xfs_verify_agbno -- min_block ought to be the
    -    first agblock number in the AG that can be used by non-static metadata.
    -    Unfortunately, we set it to the last agblock of the static metadata.
    -    Fortunately this works due to the <= check, but this isn't technically
    -    correct.
    +    There's some weird logic in xfs_verify_agbno -- min_block ought to be
    +    the first agblock number in the AG that can be used by non-static
    +    metadata.  However, we initialize it to the last agblock of the static
    +    metadata, which works due to the <= check, even though this isn't
    +    technically correct.
     
    -    Instead, change the check to < and set it to the next agblock past the
    +    Change the check to < and set min_block to the next agblock past the
         static metadata.  This hasn't been an issue up to now, but we're going
         to move these things into the generic group struct, and this will cause
    -    problems with rtgroups, where min_block can be zero for an rtgroup.
    +    problems with rtgroups, where min_block can be zero for an rtgroup that
    +    doesn't have a rt superblock.
    +
    +    Note that there's no user-visible impact with the old logic, so this
    +    isn't a bug fix.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/libxfs/xfs_ag.c ##
     @@ fs/xfs/libxfs/xfs_ag.c: xfs_perag_alloc(
      		goto out_free_perag;
      
      	/*
    @@ fs/xfs/libxfs/xfs_ag.c: xfs_perag_alloc(
      	pag->block_count = __xfs_ag_block_count(mp, index, agcount, dblocks);
     -	pag->min_block = XFS_AGFL_BLOCK(mp);
     +	pag->min_block = XFS_AGFL_BLOCK(mp) + 1;
      	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
      			&pag->agino_max);
      
    - 	error = xfs_group_insert(mp, &pag->pag_group, index, XG_TYPE_AG);
    + 	error = xfs_group_insert(mp, pag_group(pag), index, XG_TYPE_AG);
      	if (error)
      		goto out_buf_cache_destroy;
     
      ## fs/xfs/libxfs/xfs_ag.h ##
     @@ fs/xfs/libxfs/xfs_ag.h: void xfs_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
      
133:  ff8a8ab72007ff ! 139:  0d9ba4268d7ea4 xfs: move the min and max group block numbers to xfs_group
    @@ Commit message
         Move the min and max agblock numbers to the generic xfs_group structure
         so that we can start building validators for extents within an rtgroup.
         While we're at it, use check_add_overflow for the extent length
         computation because that has much better overflow checking.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/libxfs/xfs_ag.c ##
    +@@ fs/xfs/libxfs/xfs_ag.c: xfs_update_last_ag_size(
    + 	xfs_agnumber_t		prev_agcount)
    + {
    + 	struct xfs_perag	*pag = xfs_perag_grab(mp, prev_agcount - 1);
    + 
    + 	if (!pag)
    + 		return -EFSCORRUPTED;
    +-	pag->block_count = __xfs_ag_block_count(mp, prev_agcount - 1,
    +-			mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks);
    +-	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
    ++	pag_group(pag)->xg_block_count = __xfs_ag_block_count(mp,
    ++			prev_agcount - 1, mp->m_sb.sb_agcount,
    ++			mp->m_sb.sb_dblocks);
    ++	__xfs_agino_range(mp, pag_group(pag)->xg_block_count, &pag->agino_min,
    + 			&pag->agino_max);
    + 	xfs_perag_rele(pag);
    + 	return 0;
    + }
    + 
    + static int
     @@ fs/xfs/libxfs/xfs_ag.c: xfs_perag_alloc(
      	if (error)
      		goto out_free_perag;
      
      	/*
      	 * Pre-calculated geometry
      	 */
     -	pag->block_count = __xfs_ag_block_count(mp, index, agcount, dblocks);
     -	pag->min_block = XFS_AGFL_BLOCK(mp) + 1;
     -	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
    -+	pag->pag_group.xg_block_count = __xfs_ag_block_count(mp, index, agcount,
    -+			dblocks);
    -+	pag->pag_group.xg_min_gbno = XFS_AGFL_BLOCK(mp) + 1;
    -+	__xfs_agino_range(mp, pag->pag_group.xg_block_count, &pag->agino_min,
    ++	pag_group(pag)->xg_block_count = __xfs_ag_block_count(mp, index, agcount,
    ++				dblocks);
    ++	pag_group(pag)->xg_min_gbno = XFS_AGFL_BLOCK(mp) + 1;
    ++	__xfs_agino_range(mp, pag_group(pag)->xg_block_count, &pag->agino_min,
      			&pag->agino_max);
      
    - 	error = xfs_group_insert(mp, &pag->pag_group, index, XG_TYPE_AG);
    + 	error = xfs_group_insert(mp, pag_group(pag), index, XG_TYPE_AG);
      	if (error)
      		goto out_buf_cache_destroy;
      
     @@ fs/xfs/libxfs/xfs_ag.c: xfs_ag_shrink_space(
      
      		error = -ENOSPC;
      		goto resv_init_out;
      	}
      
      	/* Update perag geometry */
     -	pag->block_count -= delta;
     -	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
    -+	pag->pag_group.xg_block_count -= delta;
    -+	__xfs_agino_range(mp, pag->pag_group.xg_block_count, &pag->agino_min,
    ++	pag_group(pag)->xg_block_count -= delta;
    ++	__xfs_agino_range(mp, pag_group(pag)->xg_block_count, &pag->agino_min,
      			&pag->agino_max);
      
      	xfs_ialloc_log_agi(*tpp, agibp, XFS_AGI_LENGTH);
      	xfs_alloc_log_agf(*tpp, agfbp, XFS_AGF_LENGTH);
      	return 0;
      
    @@ fs/xfs/libxfs/xfs_ag.c: xfs_ag_extend_space(
      	if (error)
      		return error;
      
      	/* Update perag geometry */
     -	pag->block_count = be32_to_cpu(agf->agf_length);
     -	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
    -+	pag->pag_group.xg_block_count = be32_to_cpu(agf->agf_length);
    -+	__xfs_agino_range(mp, pag->pag_group.xg_block_count, &pag->agino_min,
    ++	pag_group(pag)->xg_block_count = be32_to_cpu(agf->agf_length);
    ++	__xfs_agino_range(mp, pag_group(pag)->xg_block_count, &pag->agino_min,
      			&pag->agino_max);
      	return 0;
      }
      
      /* Retrieve AG geometry. */
      int
    @@ fs/xfs/libxfs/xfs_ag.h: xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, x
      {
     -	if (agbno >= pag->block_count)
     -		return false;
     -	if (agbno < pag->min_block)
     -		return false;
     -	return true;
    -+	return xfs_verify_gbno(&pag->pag_group, agbno);
    ++	return xfs_verify_gbno(pag_group(pag), agbno);
      }
      
      static inline bool
      xfs_verify_agbext(
      	struct xfs_perag	*pag,
      	xfs_agblock_t		agbno,
    @@ fs/xfs/libxfs/xfs_ag.h: xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, x
     -		return false;
     -
     -	if (!xfs_verify_agbno(pag, agbno))
     -		return false;
     -
     -	return xfs_verify_agbno(pag, agbno + len - 1);
    -+	return xfs_verify_gbext(&pag->pag_group, agbno, len);
    ++	return xfs_verify_gbext(pag_group(pag), agbno, len);
      }
      
      /*
       * Verify that an AG inode number pointer neither points outside the AG
       * nor points at static metadata.
       */
     
      ## fs/xfs/libxfs/xfs_group.h ##
     @@ fs/xfs/libxfs/xfs_group.h: struct xfs_group {
      	struct xfs_mount	*xg_mount;
    - 	uint32_t		xg_index;
    + 	uint32_t		xg_gno;
      	enum xfs_group_type	xg_type;
      	atomic_t		xg_ref;		/* passive reference count */
      	atomic_t		xg_active_ref;	/* active reference count */
      
     +	/* Precalculated geometry info */
     +	uint32_t		xg_block_count;	/* max usable gbno */
    @@ fs/xfs/libxfs/xfs_ialloc_btree.c: xfs_inobt_rec_check_count(
      static xfs_extlen_t
      xfs_inobt_max_size(
      	struct xfs_perag	*pag)
      {
      	struct xfs_mount	*mp = pag_mount(pag);
     -	xfs_agblock_t		agblocks = pag->block_count;
    -+	xfs_agblock_t		agblocks = pag->pag_group.xg_block_count;
    ++	xfs_agblock_t		agblocks = pag_group(pag)->xg_block_count;
      
      	/* Bail out if we're uninitialized, which can happen in mkfs. */
      	if (M_IGEO(mp)->inobt_mxr[0] == 0)
      		return 0;
      
      	/*
    @@ fs/xfs/libxfs/xfs_rtgroup.c
     +	struct xfs_rtgroup	*rtg,
     +	xfs_rgnumber_t		rgno,
     +	xfs_rgnumber_t		rgcount,
     +	xfs_rtbxlen_t		rextents)
     +{
     +	rtg->rtg_extents = __xfs_rtgroup_extents(mp, rgno, rgcount, rextents);
    -+	rtg->rtg_group.xg_block_count = rtg->rtg_extents * mp->m_sb.sb_rextsize;
    -+	rtg->rtg_group.xg_min_gbno = xfs_rtgroup_min_block(mp, rgno);
    ++	rtg_group(rtg)->xg_block_count = rtg->rtg_extents * mp->m_sb.sb_rextsize;
    ++	rtg_group(rtg)->xg_min_gbno = xfs_rtgroup_min_block(mp, rgno);
     +}
     +
      int
      xfs_rtgroup_alloc(
      	struct xfs_mount	*mp,
      	xfs_rgnumber_t		rgno,
    @@ fs/xfs/libxfs/xfs_rtgroup.c: xfs_rtgroup_alloc(
      	rtg = kzalloc(sizeof(struct xfs_rtgroup), GFP_KERNEL);
      	if (!rtg)
      		return -ENOMEM;
      
     +	xfs_rtgroup_calc_geometry(mp, rtg, rgno, rgcount, rextents);
     +
    - 	error = xfs_group_insert(mp, &rtg->rtg_group, rgno, XG_TYPE_RTG);
    + 	error = xfs_group_insert(mp, rtg_group(rtg), rgno, XG_TYPE_RTG);
      	if (error)
      		goto out_free_rtg;
      	return 0;
      
      out_free_rtg:
    +@@ fs/xfs/libxfs/xfs_rtgroup.c: xfs_update_last_rtgroup_size(
    + 
    + 	rtg = xfs_rtgroup_grab(mp, prev_rgcount - 1);
    + 	if (!rtg)
    + 		return -EFSCORRUPTED;
    + 	rtg->rtg_extents = __xfs_rtgroup_extents(mp, prev_rgcount - 1,
    + 			mp->m_sb.sb_rgcount, mp->m_sb.sb_rextents);
    ++	rtg_group(rtg)->xg_block_count = rtg->rtg_extents * mp->m_sb.sb_rextsize;
    + 	xfs_rtgroup_rele(rtg);
    + 	return 0;
    + }
    + 
    + /* Lock metadata inodes associated with this rt group. */
    + void
     @@ fs/xfs/libxfs/xfs_rtgroup.c: xfs_rtgroup_get_geometry(
      	struct xfs_rtgroup	*rtg,
      	struct xfs_rtgroup_geometry *rgeo)
      {
      	/* Fill out form. */
      	memset(rgeo, 0, sizeof(*rgeo));
      	rgeo->rg_number = rtg_rgno(rtg);
     -	rgeo->rg_length = rtg->rtg_extents * rtg_mount(rtg)->m_sb.sb_rextsize;
    -+	rgeo->rg_length = rtg->rtg_group.xg_block_count;
    - 	rgeo->rg_capacity = rgeo->rg_length;
    ++	rgeo->rg_length = rtg_group(rtg)->xg_block_count;
      	xfs_rtgroup_geom_health(rtg, rgeo);
      	return 0;
      }
      
      #ifdef CONFIG_PROVE_LOCKING
    + static struct lock_class_key xfs_rtginode_lock_class;
     
      ## fs/xfs/libxfs/xfs_rtgroup.h ##
     @@ fs/xfs/libxfs/xfs_rtgroup.h: void xfs_free_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t first_rgno,
      int xfs_initialize_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t first_rgno,
      		xfs_rgnumber_t end_rgno, xfs_rtbxlen_t rextents);
      
    @@ fs/xfs/libxfs/xfs_rtgroup.h: void xfs_free_rtgroups(struct xfs_mount *mp, xfs_rg
      		xfs_rgnumber_t rgcount, xfs_rtbxlen_t rextents);
      xfs_rtxnum_t xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno);
     +void xfs_rtgroup_calc_geometry(struct xfs_mount *mp, struct xfs_rtgroup *rtg,
     +		xfs_rgnumber_t rgno, xfs_rgnumber_t rgcount,
     +		xfs_rtbxlen_t rextents);
      
    + int xfs_update_last_rtgroup_size(struct xfs_mount *mp,
    + 		xfs_rgnumber_t prev_rgcount);
    + 
      /* Lock the rt bitmap inode in exclusive mode */
      #define XFS_RTGLOCK_BITMAP		(1U << 0)
    - /* Lock the rt bitmap inode in shared mode */
    - #define XFS_RTGLOCK_BITMAP_SHARED	(1U << 1)
    - 
     
      ## fs/xfs/scrub/agheader.c ##
     @@ fs/xfs/scrub/agheader.c: xchk_agf(
      
      	agf = sc->sa.agf_bp->b_addr;
      	pag = sc->sa.pag;
      
      	/* Check the AG length */
      	eoag = be32_to_cpu(agf->agf_length);
     -	if (eoag != pag->block_count)
    -+	if (eoag != pag->pag_group.xg_block_count)
    ++	if (eoag != pag_group(pag)->xg_block_count)
      		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
      
      	/* Check the AGF btree roots and levels */
      	agbno = be32_to_cpu(agf->agf_bno_root);
      	if (!xfs_verify_agbno(pag, agbno))
      		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
    @@ fs/xfs/scrub/agheader.c: xchk_agi(
      	agi = sc->sa.agi_bp->b_addr;
      	pag = sc->sa.pag;
      
      	/* Check the AG length */
      	eoag = be32_to_cpu(agi->agi_length);
     -	if (eoag != pag->block_count)
    -+	if (eoag != pag->pag_group.xg_block_count)
    ++	if (eoag != pag_group(pag)->xg_block_count)
      		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
      
      	/* Check btree roots and levels */
      	agbno = be32_to_cpu(agi->agi_root);
      	if (!xfs_verify_agbno(pag, agbno))
      		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
    @@ fs/xfs/scrub/agheader_repair.c: xrep_agf_init_header(
      	memcpy(old_agf, agf, sizeof(*old_agf));
      	memset(agf, 0, BBTOB(agf_bp->b_length));
      	agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
      	agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
      	agf->agf_seqno = cpu_to_be32(pag_agno(pag));
     -	agf->agf_length = cpu_to_be32(pag->block_count);
    -+	agf->agf_length = cpu_to_be32(pag->pag_group.xg_block_count);
    ++	agf->agf_length = cpu_to_be32(pag_group(pag)->xg_block_count);
      	agf->agf_flfirst = old_agf->agf_flfirst;
      	agf->agf_fllast = old_agf->agf_fllast;
      	agf->agf_flcount = old_agf->agf_flcount;
      	if (xfs_has_crc(mp))
      		uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
      
    @@ fs/xfs/scrub/agheader_repair.c: xrep_agi_init_header(
      	memcpy(old_agi, agi, sizeof(*old_agi));
      	memset(agi, 0, BBTOB(agi_bp->b_length));
      	agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
      	agi->agi_versionnum = cpu_to_be32(XFS_AGI_VERSION);
      	agi->agi_seqno = cpu_to_be32(pag_agno(pag));
     -	agi->agi_length = cpu_to_be32(pag->block_count);
    -+	agi->agi_length = cpu_to_be32(pag->pag_group.xg_block_count);
    ++	agi->agi_length = cpu_to_be32(pag_group(pag)->xg_block_count);
      	agi->agi_newino = cpu_to_be32(NULLAGINO);
      	agi->agi_dirino = cpu_to_be32(NULLAGINO);
      	if (xfs_has_crc(mp))
      		uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
      
      	/* Mark the incore AGF data stale until we're done fixing things. */
    @@ fs/xfs/scrub/repair.c: xrep_calc_ag_resblks(
      	}
      
      	/* Now grab the block counters from the AGF. */
      	error = xfs_alloc_read_agf(pag, NULL, 0, &bp);
      	if (error) {
     -		aglen = pag->block_count;
    -+		aglen = pag->pag_group.xg_block_count;
    ++		aglen = pag_group(pag)->xg_block_count;
      		freelen = aglen;
      		usedlen = aglen;
      	} else {
      		struct xfs_agf	*agf = bp->b_addr;
      
      		aglen = be32_to_cpu(agf->agf_length);
    @@ fs/xfs/scrub/repair.c: xrep_calc_ag_resblks(
      		icount = pag->agino_max - pag->agino_min + 1;
      	}
      
      	/* If the block counts are impossible, make worst-case assumptions. */
      	if (aglen == NULLAGBLOCK ||
     -	    aglen != pag->block_count ||
    -+	    aglen != pag->pag_group.xg_block_count ||
    ++	    aglen != pag_group(pag)->xg_block_count ||
      	    freelen >= aglen) {
     -		aglen = pag->block_count;
    -+		aglen = pag->pag_group.xg_block_count;
    ++		aglen = pag_group(pag)->xg_block_count;
      		freelen = aglen;
      		usedlen = aglen;
      	}
      
      	trace_xrep_calc_ag_resblks(pag, icount, aglen, freelen, usedlen);
      
    @@ fs/xfs/xfs_discard.c: xfs_trim_perag_extents(
      		.end		= end,
      		.minlen		= minlen,
      	};
      	int			error = 0;
      
     -	if (start != 0 || end != pag->block_count)
    -+	if (start != 0 || end != pag->pag_group.xg_block_count)
    ++	if (start != 0 || end != pag_group(pag)->xg_block_count)
      		tcur.by_bno = true;
      
      	do {
      		struct xfs_busy_extents	*extents;
      
      		extents = kzalloc(sizeof(*extents), GFP_KERNEL);
    @@ fs/xfs/xfs_discard.c: xfs_trim_datadev_extents(
      	start_agbno = xfs_daddr_to_agbno(mp, start);
      	end_agno = xfs_daddr_to_agno(mp, ddev_end);
      	end_agbno = xfs_daddr_to_agbno(mp, ddev_end);
      
      	while ((pag = xfs_perag_next_range(mp, pag, start_agno, end_agno))) {
     -		xfs_agblock_t	agend = pag->block_count;
    -+		xfs_agblock_t	agend = pag->pag_group.xg_block_count;
    ++		xfs_agblock_t	agend = pag_group(pag)->xg_block_count;
      
      		if (pag_agno(pag) == end_agno)
      			agend = end_agbno;
      		error = xfs_trim_perag_extents(pag, start_agbno, agend, minlen);
      		if (error)
      			last_error = error;
134:  e82b2b382f4571 ! 140:  23ef24bdaa0890 xfs: port the perag discard code to handle generic groups
    @@ Commit message
     
         Port xfs_discard_extents and its tracepoints to handle generic groups
         instead of just perags.  This is needed to enable busy extent tracking
         for rtgroups.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/xfs_discard.c ##
     @@ fs/xfs/xfs_discard.c: xfs_discard_endio(
      
      	INIT_WORK(&extents->endio_work, xfs_discard_endio_work);
      	queue_work(xfs_discard_wq, &extents->endio_work);
    @@ fs/xfs/xfs_discard.c: xfs_trim_gather_extents(
      		 * If the extent is entirely outside of the range we are
      		 * supposed to skip it.  Do not bother to trim down partially
      		 * overlapping ranges for now.
      		 */
      		if (fbno + flen < tcur->start) {
     -			trace_xfs_discard_exclude(pag, fbno, flen);
    -+			trace_xfs_discard_exclude(&pag->pag_group, fbno, flen);
    ++			trace_xfs_discard_exclude(pag_group(pag), fbno, flen);
      			goto next_extent;
      		}
      		if (fbno > tcur->end) {
     -			trace_xfs_discard_exclude(pag, fbno, flen);
    -+			trace_xfs_discard_exclude(&pag->pag_group, fbno, flen);
    ++			trace_xfs_discard_exclude(pag_group(pag), fbno, flen);
      			if (tcur->by_bno) {
      				tcur->count = 0;
      				break;
      			}
      			goto next_extent;
      		}
    @@ fs/xfs/xfs_discard.c: xfs_trim_gather_extents(
      		if (fbno + flen > tcur->end + 1)
      			flen = tcur->end - fbno + 1;
      
      		/* Too small?  Give up. */
      		if (flen < tcur->minlen) {
     -			trace_xfs_discard_toosmall(pag, fbno, flen);
    -+			trace_xfs_discard_toosmall(&pag->pag_group, fbno, flen);
    ++			trace_xfs_discard_toosmall(pag_group(pag), fbno, flen);
      			if (tcur->by_bno)
      				goto next_extent;
      			tcur->count = 0;
      			break;
      		}
      
      		/*
      		 * If any blocks in the range are still busy, skip the
      		 * discard and try again the next time.
      		 */
    - 		if (xfs_extent_busy_search(&pag->pag_group, fbno, flen)) {
    + 		if (xfs_extent_busy_search(pag_group(pag), fbno, flen)) {
     -			trace_xfs_discard_busy(pag, fbno, flen);
    -+			trace_xfs_discard_busy(&pag->pag_group, fbno, flen);
    ++			trace_xfs_discard_busy(pag_group(pag), fbno, flen);
      			goto next_extent;
      		}
      
    - 		xfs_extent_busy_insert_discard(&pag->pag_group, fbno, flen,
    + 		xfs_extent_busy_insert_discard(pag_group(pag), fbno, flen,
      				&extents->extent_list);
      next_extent:
     
      ## fs/xfs/xfs_trace.h ##
     @@ fs/xfs/xfs_trace.h: DEFINE_EVENT(xfs_log_recover_icreate_item_class, name, \
      	TP_ARGS(log, in_f))
    @@ fs/xfs/xfs_trace.h: DEFINE_EVENT(xfs_log_recover_icreate_item_class, name, \
      	),
      	TP_fast_assign(
     -		__entry->dev = pag_mount(pag)->m_super->s_dev;
     -		__entry->agno = pag_agno(pag);
     +		__entry->dev = xg->xg_mount->m_super->s_dev;
     +		__entry->type = xg->xg_type;
    -+		__entry->agno = xg->xg_index;
    ++		__entry->agno = xg->xg_gno;
      		__entry->agbno = agbno;
      		__entry->len = len;
      	),
     -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x",
     +	TP_printk("dev %d:%d %sno 0x%x gbno 0x%x fsbcount 0x%x",
      		  MAJOR(__entry->dev), MINOR(__entry->dev),
135:  8faf9e3952b8f4 ! 141:  4a556e12a7f867 xfs: implement busy extent tracking for rtgroups
    @@ Commit message
         until the rt EFIs have been committed to disk.  This way we ensure that
         space cannot be reused until all traces of the old owner are gone.
     
         As a fringe benefit, we now support -o discard on the realtime device.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/libxfs/xfs_rtbitmap.c ##
     @@
      #include "xfs_rtbitmap.h"
      #include "xfs_health.h"
      #include "xfs_sb.h"
    @@ fs/xfs/libxfs/xfs_rtbitmap.c: xfs_rtfree_blocks(
     +	error = xfs_rtfree_extent(tp, rtg, xfs_rtb_to_rtx(mp, rtbno),
      			xfs_extlen_to_rtxlen(mp, rtlen));
     +	if (error)
     +		return error;
     +
     +	if (xfs_has_rtgroups(mp))
    -+		xfs_extent_busy_insert(tp, &rtg->rtg_group,
    ++		xfs_extent_busy_insert(tp, rtg_group(rtg),
     +				xfs_rtb_to_rgbno(mp, rtbno), rtlen, 0);
     +
     +	return 0;
      }
      
      /* Find all the free records within a given range. */
    @@ fs/xfs/xfs_extent_busy.c: xfs_extent_busy_wait_group(
      	struct xfs_mount	*mp)
      {
      	struct xfs_perag	*pag = NULL;
     +	struct xfs_rtgroup	*rtg = NULL;
      
      	while ((pag = xfs_perag_next(mp, pag)))
    - 		xfs_extent_busy_wait_group(&pag->pag_group);
    + 		xfs_extent_busy_wait_group(pag_group(pag));
     +
     +	if (xfs_has_rtgroups(mp))
     +		while ((rtg = xfs_rtgroup_next(mp, rtg)))
    -+			xfs_extent_busy_wait_group(&rtg->rtg_group);
    ++			xfs_extent_busy_wait_group(rtg_group(rtg));
      }
      
      /*
       * Callback for list_sort to sort busy extents by the group they reside in.
       */
      int
    @@ fs/xfs/xfs_rtalloc.c: xfs_rtalloc_align_minmax(
     +	xfs_rgblock_t		min_rgbno = xfs_rtx_to_rgbno(rtg, start);
     +	xfs_extlen_t		minlen = xfs_rtxlen_to_extlen(mp, minlen_rtx);
     +	xfs_extlen_t		len = xfs_rtxlen_to_extlen(mp, len_rtx);
     +	xfs_extlen_t		diff;
     +	bool			busy;
     +
    -+	busy = xfs_extent_busy_trim(&rtg->rtg_group, minlen,
    ++	busy = xfs_extent_busy_trim(rtg_group(rtg), minlen,
     +			xfs_rtxlen_to_extlen(mp, maxlen_rtx), &rgbno, &len,
     +			busy_gen);
     +
     +	/*
     +	 * If we have a largish extent that happens to start before min_rgbno,
     +	 * see if we can shift it into range...
    @@ fs/xfs/xfs_rtalloc.c: xfs_rtalloc_align_minmax(
     +		 * the extent is busy.  Flush the log and wait for the busy
     +		 * situation to resolve.
     +		 */
     +		trace_xfs_rtalloc_extent_busy(args->rtg, start, minlen, maxlen,
     +				*len, prod, *rtx, busy_gen);
     +
    -+		error = xfs_extent_busy_flush(args->tp, &args->rtg->rtg_group,
    ++		error = xfs_extent_busy_flush(args->tp, rtg_group(args->rtg),
     +				busy_gen, 0);
     +		if (error)
     +			return error;
     +
     +		goto again;
     +	}
136:  4d8cc3c4c4b780 ! 142:  4602c89a37c7f9 xfs: use rtgroup busy extent list for FITRIM
    @@ Commit message
         For filesystems that have rtgroups and hence use the busy extent list
         for freed rt space, use that busy extent list so that FITRIM can issue
         discard commands asynchronously without worrying about other callers
         accidentally allocating and using space that is being discarded.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/xfs_discard.c ##
     @@
       * This also allows us to issue discards asynchronously like we do with online
       * discard, and so for fast devices fstrim will run much faster as we can have
       * multiple discard operations in flight at once, as well as pipeline the free
    @@ fs/xfs/xfs_discard.c: xfs_trim_rtextents(
     +
     +	rgbno = xfs_rtx_to_rgbno(rtg, rec->ar_startext);
     +	len = xfs_rtxlen_to_extlen(rtg_mount(rtg), rec->ar_extcount);
     +
     +	/* Ignore too small. */
     +	if (len < tr->minlen_fsb) {
    -+		trace_xfs_discard_toosmall(&rtg->rtg_group, rgbno, len);
    ++		trace_xfs_discard_toosmall(rtg_group(rtg), rgbno, len);
     +		return 0;
     +	}
     +
     +	/*
     +	 * If any blocks in the range are still busy, skip the discard and try
     +	 * again the next time.
     +	 */
    -+	if (xfs_extent_busy_search(&rtg->rtg_group, rgbno, len)) {
    -+		trace_xfs_discard_busy(&rtg->rtg_group, rgbno, len);
    ++	if (xfs_extent_busy_search(rtg_group(rtg), rgbno, len)) {
    ++		trace_xfs_discard_busy(rtg_group(rtg), rgbno, len);
     +		return 0;
     +	}
     +
    -+	xfs_extent_busy_insert_discard(&rtg->rtg_group, rgbno, len,
    ++	xfs_extent_busy_insert_discard(rtg_group(rtg), rgbno, len,
     +			&tr->extents->extent_list);
     +
     +	tr->queued++;
     +	tr->restart_rtx = rec->ar_startext + rec->ar_extcount;
     +	return 0;
     +}
137:  5ff6988a1fb623 = 143:  086b43d5254600 xfs: refactor xfs_qm_destroy_quotainos
138:  bb82e8140fda8b ! 144:  7bfbf456f18c6f xfs: use metadir for quota inodes
    @@ fs/xfs/libxfs/xfs_quota_defs.h: extern void xfs_dqblk_repair(struct xfs_mount *m
     +int xfs_dqinode_load_parent(struct xfs_trans *tp, struct xfs_inode **dpp);
     +
      #endif	/* __XFS_QUOTA_H__ */
     
      ## fs/xfs/libxfs/xfs_sb.c ##
     @@ fs/xfs/libxfs/xfs_sb.c: xfs_sb_quota_to_disk(
    - 	struct xfs_dsb	*to,
      	struct xfs_sb	*from)
      {
      	uint16_t	qflags = from->sb_qflags;
      
    - 	if (xfs_sb_version_hasmetadir(from)) {
    + 	if (xfs_sb_is_v5(from) &&
    + 	    (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)) {
     +		to->sb_qflags = cpu_to_be16(from->sb_qflags);
      		to->sb_uquotino = cpu_to_be64(0);
      		to->sb_gquotino = cpu_to_be64(0);
      		to->sb_pquotino = cpu_to_be64(0);
      		return;
      	}
139:  5ff39a31b32540 = 145:  f37c74e3569656 xfs: scrub quota file metapaths
140:  967130731d2ecb ! 146:  7c0f5543cee648 xfs: persist quota flags with metadir
    @@ fs/xfs/xfs_mount.c: xfs_mountfs(
      	 */
      	if (xfs_sb_version_haslogxattrs(&mp->m_sb))
      		xfs_set_using_logged_xattrs(mp);
     
      ## fs/xfs/xfs_mount.h ##
     @@ fs/xfs/xfs_mount.h: __XFS_HAS_FEAT(nouuid, NOUUID)
    - /* Mount time quotacheck is running */
    - #define XFS_OPSTATE_QUOTACHECK_RUNNING	10
    - /* Do we want to clear log incompat flags? */
    - #define XFS_OPSTATE_UNSET_LOG_INCOMPAT	11
    - /* Filesystem can use logged extended attributes */
    - #define XFS_OPSTATE_USE_LARP		12
    + /* Kernel has logged a warning about exchange-range being used on this fs. */
    + #define XFS_OPSTATE_WARNED_EXCHRANGE	14
    + /* Kernel has logged a warning about parent pointers being used on this fs. */
    + #define XFS_OPSTATE_WARNED_PPTR		15
    + /* Kernel has logged a warning about metadata dirs being used on this fs. */
    + #define XFS_OPSTATE_WARNED_METADIR	16
     +/* Filesystem should use qflags to determine quotaon status */
    -+#define XFS_OPSTATE_RESUMING_QUOTAON	13
    ++#define XFS_OPSTATE_RESUMING_QUOTAON	17
      
      #define __XFS_IS_OPSTATE(name, NAME) \
      static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
      { \
      	return test_bit(XFS_OPSTATE_ ## NAME, &mp->m_opstate); \
      } \
    @@ fs/xfs/xfs_super.c: xfs_fs_parse_param(
      	case Opt_discard:
      		parsing_mp->m_features |= XFS_FEAT_DISCARD;
      		return 0;
      	case Opt_nodiscard:
      		parsing_mp->m_features &= ~XFS_FEAT_DISCARD;
     @@ fs/xfs/xfs_super.c: xfs_fs_fill_super(
    - 	"EXPERIMENTAL exchange-range feature enabled. Use at your own risk!");
    + 	if (xfs_has_exchange_range(mp))
    + 		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_EXCHRANGE);
      
      	if (xfs_has_parent(mp))
    - 		xfs_warn(mp,
    - 	"EXPERIMENTAL parent pointer feature enabled. Use at your own risk!");
    + 		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_PPTR);
      
     +	/*
     +	 * If no quota mount options were provided, maybe we'll try to pick
     +	 * up the quota accounting and enforcement flags from the ondisk sb.
     +	 */
     +	if (!(mp->m_qflags & XFS_QFLAGS_MNTOPTS))
141:  65a56f7c1e941e ! 147:  2ad1720d9d783f xfs: fix chown with rt quota
    @@
      ## Metadata ##
     Author: Darrick J. Wong <djwong@kernel.org>
     
      ## Commit message ##
         xfs: fix chown with rt quota
     
    -    Make chown's quota adjustments work with realtime files.
    +    Make chown's quota adjustments work with realtime files.  This is mostly
    +    a matter of calling xfs_inode_count_blocks on a given file to figure out
    +    the number of blocks allocated to the data device and to the realtime
    +    device, and using those quantities to update the quota accounting when
    +    the id changes.  Delayed allocation reservations are moved from the old
    +    dquot's incore reservation to the new dquot's incore reservation.
     
    +    Note that there was a missing ILOCK bug in xfs_qm_dqusage_adjust that we
    +    must fix before calling xfs_iread_extents.  Prior to 2.6.37 the locking
    +    was correct, but then someone removed the ILOCK as part of a cleanup.
    +    Nobody noticed because nowhere in the git history have we ever supported
    +    rt+quota so nobody can use this.
    +
    +    I'm leaving git breadcrumbs in case anyone is desperate enough to try to
    +    backport the rtquota code to old kernels.
    +
    +    Not-Cc: <stable@vger.kernel.org> # v2.6.37
    +    Fixes: 52fda114249578 ("xfs: simplify xfs_qm_dqusage_adjust")
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/xfs_qm.c ##
     @@ fs/xfs/xfs_qm.c: xfs_qm_dqusage_adjust(
      	struct xfs_mount	*mp,
      	struct xfs_trans	*tp,
      	xfs_ino_t		ino,
142:  95f3b163f0cff4 ! 148:  d0081512b54b17 xfs: advertise realtime quota support in the xqm stat files
    @@ fs/xfs/xfs_stats.c: void xfs_stats_clearall(struct xfsstats __percpu *stats)
      
      static int xqm_proc_show(struct seq_file *m, void *v)
      {
     -	/* maximum; incore; ratio free to inuse; freelist */
     -	seq_printf(m, "%d\t%d\t%d\t%u\n",
     +	/* maximum; incore; ratio free to inuse; freelist; rtquota */
    -+	seq_printf(m, "%d\t%d\t%d\t%u\t%u\n",
    ++	seq_printf(m, "%d\t%d\t%d\t%u\t%s\n",
      		   0, counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT),
     -		   0, counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT + 1));
     +		   0, counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT + 1),
    -+#ifdef CONFIG_XFS_RT
    -+		   1
    -+#else
    -+		   0
    -+#endif
    -+		   );
    ++		   IS_ENABLED(CONFIG_XFS_RT) ? "rtquota" : "quota");
      	return 0;
      }
      
      /* legacy quota stats interface no 2 */
      static int xqmstat_proc_show(struct seq_file *m, void *v)
      {
143:  1f19733995b0d4 ! 149:  ba7f53f4f22c85 xfs: report realtime block quota limits on realtime directories
    @@ Commit message
         On the data device, calling statvfs on a projinherit directory results
         in the block and avail counts being curtailed to the project quota block
         limits, if any are set.  Do the same for realtime files or directories,
         only use the project quota rt block limits.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/xfs_qm_bhv.c ##
     @@
      #include "xfs_qm.h"
      
      
144:  0558ca10389948 ! 150:  46974f7ff9b570 xfs: create quota preallocation watermarks for realtime quota
    @@ Metadata
     Author: Darrick J. Wong <djwong@kernel.org>
     
      ## Commit message ##
         xfs: create quota preallocation watermarks for realtime quota
     
         Refactor the quota preallocation watermarking code so that it'll work
    -    for realtime quota too.
    +    for realtime quota too.  Convert the do_div calls into div_u64 for
    +    compactness.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/xfs_dquot.c ##
     @@ fs/xfs/xfs_dquot.c: xfs_qm_init_dquot_blk(
      	if (!(mp->m_qflags & qflag))
      		xfs_trans_ordered_buf(tp, bp);
      	else
    @@ fs/xfs/xfs_dquot.c: xfs_qm_init_dquot_blk(
      
     +static void
     +xfs_dquot_set_prealloc(
     +	struct xfs_dquot_pre		*pre,
     +	const struct xfs_dquot_res	*res)
     +{
    -+	uint64_t			space;
    ++	xfs_qcnt_t			space;
     +
     +	pre->q_prealloc_hi_wmark = res->hardlimit;
     +	pre->q_prealloc_lo_wmark = res->softlimit;
    -+	if (!pre->q_prealloc_lo_wmark) {
    -+		pre->q_prealloc_lo_wmark = pre->q_prealloc_hi_wmark;
    -+		do_div(pre->q_prealloc_lo_wmark, 100);
    -+		pre->q_prealloc_lo_wmark *= 95;
    -+	}
     +
    -+	space = pre->q_prealloc_hi_wmark;
    ++	space = div_u64(pre->q_prealloc_hi_wmark, 100);
    ++	if (!pre->q_prealloc_lo_wmark)
    ++		pre->q_prealloc_lo_wmark = space * 95;
     +
    -+	do_div(space, 100);
     +	pre->q_low_space[XFS_QLOWSP_1_PCNT] = space;
     +	pre->q_low_space[XFS_QLOWSP_3_PCNT] = space * 3;
     +	pre->q_low_space[XFS_QLOWSP_5_PCNT] = space * 5;
     +}
     +
      /*
145:  c003e9f97835d4 ! 151:  a0f7ece9b4d941 xfs: reserve quota for realtime files correctly
    @@ Commit message
         xfs: reserve quota for realtime files correctly
     
         Fix xfs_quota_reserve_blkres to reserve rt block quota whenever we're
         dealing with a realtime file.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/xfs_quota.h ##
     @@ fs/xfs/xfs_quota.h: extern void xfs_qm_statvfs(struct xfs_inode *, struct kstatfs *);
      extern int xfs_qm_newmount(struct xfs_mount *, uint *, uint *);
      void xfs_qm_resume_quotaon(struct xfs_mount *mp);
      extern void xfs_qm_mount_quotas(struct xfs_mount *);
146:  e3e9d353be9647 ! 152:  1d1fde3ab4498c xfs: enable realtime quota again
    @@ Metadata
      ## Commit message ##
         xfs: enable realtime quota again
     
         Enable quotas for the realtime device.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/xfs_qm.c ##
     @@ fs/xfs/xfs_qm.c: xfs_qm_mount_quotas(
      	struct xfs_mount	*mp)
      {
      	int			error = 0;
    @@ fs/xfs/xfs_qm.c: xfs_qm_mount_quotas(
     -	if (mp->m_sb.sb_rextents) {
     +	if (mp->m_sb.sb_rextents && !xfs_has_rtgroups(mp)) {
      		xfs_notice(mp, "Cannot turn on quotas for realtime filesystem");
      		mp->m_qflags = 0;
      		goto write_changes;
      	}
    -+	if (mp->m_sb.sb_rextents)
    -+		xfs_warn(mp,
    -+ "EXPERIMENTAL realtime quota feature in use. Use at your own risk!");
      
      	ASSERT(XFS_IS_QUOTA_ON(mp));
    - 
    - 	/*
    - 	 * Allocate the quotainfo structure inside the mount struct, and
    - 	 * create quotainode(s), and change/rev superblock if necessary.
     
      ## fs/xfs/xfs_rtalloc.c ##
     @@ fs/xfs/xfs_rtalloc.c: xfs_growfs_rt(
      	if (XFS_FSB_TO_B(mp, in->extsize) > XFS_MAX_RTEXTSIZE ||
      	    XFS_FSB_TO_B(mp, in->extsize) < XFS_MIN_RTEXTSIZE)
      		goto out_unlock;
147:  92744e42a01a02 = 153:  0fada4968d3e0c xfs: update sb field checks when metadir is turned on
148:  26def0c604219a = 154:  753f87be12924f xfs: enable metadata directory feature

This is why I keep suggesting to everyone with nontrivial patches to
push them to any git forge, and link to them from the email.

--D
