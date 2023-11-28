Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149D744360
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 21:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LpUzFQ2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC19C433C7;
	Tue, 28 Nov 2023 21:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701207444;
	bh=DNOfZUfIUI0+r2TYfbjO4K0EeJH9dgoHxdWW5JulAfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LpUzFQ2o69tin+61FK9QtaraphovwIg779kVDbQ4+Bvgh5fusIj4vnJ90P2rdb2lX
	 2IRHwZ2DjvmFiI5HfpXAxVZhrzc6R9cOyMqE850h8OpX7V+6z0xwqAJ9IqEIABOlRm
	 5ERM1GsNPqtStQnqaTdhu0+NIgf2Zxa9aJEqvhnMCRiqwyZvh6EmnAzkE+/Sd05W/7
	 WPUGBXvEITdsgqz1Xgyy2sWldeI/UT45tpMYYQdJdJON1d2X1CHyZM4xIACGVbOEwX
	 sAaxY965K2ML0854ZR4rjHhmHmP9UhTlXxZ8ap6b8FsD0o8OTggnCMiAoZbNt1ghmc
	 NcpRQ4ZG74Q9A==
Date: Tue, 28 Nov 2023 13:37:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: repair inode btrees
Message-ID: <20231128213723.GC4167244@frogsfrogsfrogs>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
 <170086927060.2770967.9879944169477785031.stgit@frogsfrogsfrogs>
 <ZWYN4MvhQDhFWqHO@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWYN4MvhQDhFWqHO@infradead.org>

On Tue, Nov 28, 2023 at 07:57:20AM -0800, Christoph Hellwig wrote:
> This generally looks good to me.
> 
> A bunch of my superficial comments to the previous patch apply
> here as well, but I'm not going to repeat them, but I have a bunch of
> new just as nitpicky ones:

I already fixed the nitpicks from yesterday. :)

> > +	uint64_t				realfree;
> >  
> > +	if (!xfs_inobt_issparse(irec->ir_holemask))
> > +		realfree = irec->ir_free;
> > +	else
> > +		realfree = irec->ir_free & xfs_inobt_irec_to_allocmask(irec);
> 
> Nit:
> 
> I'd write this as:
> 
> 
> 	uint64_t				realfree = irec->ir_free;
> 
> 	if (xfs_inobt_issparse(irec->ir_holemask))
> 		realfree &= xfs_inobt_irec_to_allocmask(irec);
> 	return hweight64(realfree);
> 
> to simplify the logic a bit (and yes, I see the sniplet was just copied
> out of an existing function).

Ok.

> > +/* Record extents that belong to inode btrees. */
> > +STATIC int
> > +xrep_ibt_walk_rmap(
> > +	struct xfs_btree_cur		*cur,
> > +	const struct xfs_rmap_irec	*rec,
> > +	void				*priv)
> > +{
> > +	struct xrep_ibt			*ri = priv;
> > +	struct xfs_mount		*mp = cur->bc_mp;
> > +	struct xfs_ino_geometry		*igeo = M_IGEO(mp);
> > +	xfs_agblock_t			cluster_base;
> > +	int				error = 0;
> > +
> > +	if (xchk_should_terminate(ri->sc, &error))
> > +		return error;
> > +
> > +	if (rec->rm_owner == XFS_RMAP_OWN_INOBT)
> > +		return xrep_ibt_record_old_btree_blocks(ri, rec);
> > +
> > +	/* Skip extents which are not owned by this inode and fork. */
> > +	if (rec->rm_owner != XFS_RMAP_OWN_INODES)
> > +		return 0;
> 
> The "Skip extents.." comment is clearly wrong and looks like it got
> here by accident.

Yep.  "Skip mappings that are not inode records.", sorry about that.

> And may ocaml-trained ind screams for a switch
> statement and another helper for the rest of the functin body here:
> 
> 	switch (rec->rm_owner) {
> 	case XFS_RMAP_OWN_INOBT:
> 		return xrep_ibt_record_old_btree_blocks(ri, rec);
> 	case XFS_RMAP_OWN_INODES:
> 		return xrep_ibt_record_inode_blocks(mp, ri, rec);
> 	default:
> 		return 0;

Sounds good to me.

> > +	/* If we have a record ready to go, add it to the array. */
> > +	if (ri->rie.ir_startino == NULLAGINO)
> > +		return 0;
> > +
> > +	return xrep_ibt_stash(ri);
> > +}
> 
> Superficial, but having the logic inverted from the comment makes
> my brain a little dizzy.  Anything again:
> 
> 	if (ri->rie.ir_startino != NULLAGINO)
> 		error = xrep_ibt_stash(ri);
> 
> 	return error;
> 
> ?

Done.

> > +/* Make sure the records do not overlap in inumber address space. */
> > +STATIC int
> > +xrep_ibt_check_startino(
> 
> Would xrep_ibt_check_overlap be a better name here?

Yes!  Thank you for the suggestion.

--D

> 
> 
