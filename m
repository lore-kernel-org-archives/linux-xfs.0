Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B747410E6
	for <linux-xfs@vger.kernel.org>; Fri,  1 Dec 2023 01:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxuOUayo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C1BC433C7;
	Fri,  1 Dec 2023 01:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701394739;
	bh=v130UcrUJ1IBxwcyvxs0T1iJlmtN3ThcX4Wnq27YW7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AxuOUayo2/3ODsJw4nJTyI8ppDOIU5EVRBo7j5IBlkYFA+HyKC0ywCO/Yg1zudnv7
	 3TQP3z8jDdXazVJZ/swlYOLpFyojEhX5Z+NJKQFOAYKBvBPH/Qqgm+ci+1L1HH1gRG
	 keQB9qm1AehKE8Jw2SyrU/UuAzIELO1trFel1R+p5pNs+fXbh7T+OAGBYAwcUh2yI9
	 SsSA84oLES7ygoHgYM8iHU9SMedWAHWfPMvJb359dvydgDGV3USgqGnXDadPegoAam
	 peYEg5Wl6x8DAPioRUx0Oz1idNN20QdCebd7qFYPHGV+1MGRQIzc+SquxTfowUcWcp
	 x8Clf3nMemdaQ==
Date: Thu, 30 Nov 2023 17:38:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: repair inode fork block mapping data structures
Message-ID: <20231201013858.GT361584@frogsfrogsfrogs>
References: <170086927899.2771366.12096620230080096884.stgit@frogsfrogsfrogs>
 <170086927942.2771366.11233494127863883983.stgit@frogsfrogsfrogs>
 <ZWgYrIDVl992ZIsO@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWgYrIDVl992ZIsO@infradead.org>

On Wed, Nov 29, 2023 at 09:07:56PM -0800, Christoph Hellwig wrote:
> On Fri, Nov 24, 2023 at 03:53:25PM -0800, Darrick J. Wong wrote:
> > +static int
> > +xrep_bmap_extent_cmp(
> > +	const void			*a,
> > +	const void			*b)
> > +{
> > +	xfs_fileoff_t			ao;
> > +	xfs_fileoff_t			bo;
> > +
> > +	ao = xfs_bmbt_disk_get_startoff((struct xfs_bmbt_rec *)a);
> > +	bo = xfs_bmbt_disk_get_startoff((struct xfs_bmbt_rec *)b);
> 
> It would be nice if we could just have local variables for the
> xfs_bmbt_recs and not need casts.  I guess for that
> xfs_bmbt_disk_get_startoff would need to take a const argument?
> 
> Probably something for later.

Oh!  Apparently xfs_bmbt_disk_get_startoff does take a const struct
pointer now.

> > +	if (whichfork == XFS_ATTR_FORK)
> > +		return 0;
> 
> Nit: I'd probably just split the data fork specific validation
> into a separate helper to keep things nicely organized.
> 
> > +	/*
> > +	 * No need to waste time scanning for shared extents if the inode is
> > +	 * already marked.
> > +	 */
> > +	if (whichfork == XFS_DATA_FORK && xfs_is_reflink_inode(sc->ip))
> > +		rb->shared_extents = true;
> 
> The comment doesn't seem to match the code.

Ooof, that state handling needs tightening up.  There are three states,
really -- "irrelevant to this repair", "set the iflag", and "no idea, do
a scan".  That first state is open-coded in _discover_shared, which is
wasteful because that is decidable in xrep_bmap.

> 
> > +/*
> > + * Try to reserve more blocks for a transaction.
> > + *
> > + * This is for callers that need to attach resources to a transaction, scan
> > + * those resources to determine the space reservation requirements, and then
> > + * modify the attached resources.  In other words, online repair.  This can
> > + * fail due to ENOSPC, so the caller must be able to cancel the transaction
> > + * without shutting down the fs.
> > + */
> > +int
> > +xfs_trans_reserve_more(
> > +	struct xfs_trans	*tp,
> > +	unsigned int		blocks,
> > +	unsigned int		rtextents)
> 
> This basically seems to duplicate xfs_trans_reserve except that it skips
> the log reservation.  What about just allowing to pass a NULL resp
> agument to xfs_trans_reserve to skip the log reservation and reuse the
> code?

Hmm.  Maybe not a NULL resp, but an empty one looks like it would work
fine with less code duplication.

> Otherwise this looks good to me.

Cool!  Thanks for reviewing!

--D
