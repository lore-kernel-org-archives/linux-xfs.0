Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A3FC8C7
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 01:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724723760; cv=none; b=CH8y6vSYvwgLLQPS4AZbEPHDQDl7j3wcaxaUYI2t8YJ7EQxYGVTbqjDYoo5j6YIjmDenmyUnrjIHGDcQTtUJ44qLrtVnf89MxyV/nnSr6Bl1Z/8BNIlyeUAAure0Fww5SRYDudIaXLe6WEEA0IzksSitEFEkonibyW7RN4aWkIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724723760; c=relaxed/simple;
	bh=D0fZtkz++/4ZlOiXOP0CBp2/2XdvUbb3G00SH5QJHSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jqkcjqNAbBFaf0QawLcoSPHCQ74CTFiQHapX9pUcR3RUNG+sOoM/LqXLG9ntEnJ5Ea/X1QSuXXqzrhSRG8syQe3cQ4P2TD6YSetKJ5mCR9EKCjgCivZVf80+iexySapPq5eGDOCkwxwq5RsfNsbh+7mEa1svb7TaRbw9vTEO3Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EJQkz/tG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EJQkz/tG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71E1C8B7AF;
	Tue, 27 Aug 2024 01:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724723759;
	bh=D0fZtkz++/4ZlOiXOP0CBp2/2XdvUbb3G00SH5QJHSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EJQkz/tGJf1ZWaS54udW3+/0VWZEkR+KmAyqxhl5wilxGmp4ou70kZWGWBr22ItXZ
	 cfUcXj/KC9Cc5zpPrtqf8a9wzXZ96g4J0/HNipUjkRR5fgui8JhD3uY/aPRo/5koop
	 gXvaZJtoA84PtB+aSrqWRIWouPxUB2ojvcJv71oRFe3iUV7jQXD8aYIL7FfbhvsvCu
	 nGvGsBl81g+Tx8a409+eIpqZGqYPZYE7fRkKXofuieHo7N1E97aAFgZ8b9uO7rIcCM
	 /7auwdQZSL9MH4DtQuq7/xxPOC4e8oRWh7dH7DWF2rV/krk8DjYhX5JawGv1MD3d35
	 XBLqMVe4RGjXQ==
Date: Mon, 26 Aug 2024 18:55:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/24] xfs: create incore realtime group structures
Message-ID: <20240827015558.GD6082@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087433.59588.10419191726395528458.stgit@frogsfrogsfrogs>
 <ZsvEmInHRA6GVuz3@dread.disaster.area>
 <20240826191404.GC865349@frogsfrogsfrogs>
 <Zs0kfidzTGC7KACX@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs0kfidzTGC7KACX@dread.disaster.area>

On Tue, Aug 27, 2024 at 10:57:34AM +1000, Dave Chinner wrote:
> On Mon, Aug 26, 2024 at 12:14:04PM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 26, 2024 at 09:56:08AM +1000, Dave Chinner wrote:
> > > On Thu, Aug 22, 2024 at 05:17:31PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Create an incore object that will contain information about a realtime
> > > > allocation group.  This will eventually enable us to shard the realtime
> > > > section in a similar manner to how we shard the data section, but for
> > > > now just a single object for the entire RT subvolume is created.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  fs/xfs/Makefile             |    1 
> > > >  fs/xfs/libxfs/xfs_format.h  |    3 +
> > > >  fs/xfs/libxfs/xfs_rtgroup.c |  196 ++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/libxfs/xfs_rtgroup.h |  212 +++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/libxfs/xfs_sb.c      |    7 +
> > > >  fs/xfs/libxfs/xfs_types.h   |    4 +
> > > >  fs/xfs/xfs_log_recover.c    |   20 ++++
> > > >  fs/xfs/xfs_mount.c          |   16 +++
> > > >  fs/xfs/xfs_mount.h          |   14 +++
> > > >  fs/xfs/xfs_rtalloc.c        |    6 +
> > > >  fs/xfs/xfs_super.c          |    1 
> > > >  fs/xfs/xfs_trace.c          |    1 
> > > >  fs/xfs/xfs_trace.h          |   38 ++++++++
> > > >  13 files changed, 517 insertions(+), 2 deletions(-)
> > > >  create mode 100644 fs/xfs/libxfs/xfs_rtgroup.c
> > > >  create mode 100644 fs/xfs/libxfs/xfs_rtgroup.h
> > > 
> > > Ok, how is the global address space for real time extents laid out
> > > across rt groups? i.e. is it sparse similar to how fsbnos and inode
> > > numbers are created for the data device like so?
> > > 
> > > 	fsbno = (agno << agblklog) | agbno
> > > 
> > > Or is it something different? I can't find that defined anywhere in
> > > this patch, so I can't determine if the unit conversion code and
> > > validation is correct or not...
> > 
> > They're not sparse like fsbnos on the data device, they're laid end to
> > end.  IOWs, it's a straight linear translation.  If you have an rtgroup
> > that is 50 blocks long, then rtgroup 1 starts at (50 * blocksize).
> 
> Yes, I figured that out later. I think that's less than optimal,
> because it essentially repeats the problems we have with AGs being
> fixed size without the potential for fixing it easily. i.e. the
> global sharded fsbno address space is sparse, so we can actually
> space out the sparse address regions to allow future flexibility in
> group size and location work.
> 
> By having the rtgroup addressing being purely physical, we're
> completely stuck with fixed sized rtgroups and there is no way
> around that. IOWs, the physical address space sharding repeats the
> existing grow and shrink problems we have with the existing fixed
> size AGs.
> 
> We're discussing how to use the sparse fsbno addressing to allow
> resizing of AGs, but we will not be able to do that at all with
> rtgroups as they stand. The limitation is a 64 bit global rt extent
> address is essential the physical address of the extent in the block
> device LBA space.

<nod> I /think/ it's pretty simple to convert the rtgroups rtblock
numbers to sparse ala xfs_fsblock_t -- all we have to do is make sure
that mp->m_rgblklog is set to highbit64(rtgroup block count) and then
delete all the multiply/divide code, just like we do on the data device.

The thing I *don't* know is how will this affect hch's zoned device
support -- he's mentioned that rtgroups will eventually have both a size
and a "capacity" to keep the zones aligned to groups, or groups aligned
to zones, I don't remember which.  I don't know if segmenting
br_startblock for rt mappings makes things better or worse for that.

> > This patch, FWIW, refactors the existing rt code so that a !rtgroups
> > filesystem is represented by one large "group", with xfs_rtxnum_t now
> > indexing rt extents within a group. 
> 
> Right, we can do that regardless of whether we use logical or
> physical addressing for the global rtbno for sharded rtgroup layout.
> the rtgno of 0 for that rtg always results in logical = physical
> addressing.
> 
> > Probably it should be renamed to xfs_rgxnum_t.
> 
> That might be a good idea.
> 
> > Note that we haven't defined the rtgroup ondisk format yet, so I'll go
> > amend that patch to spell out the ondisk format of the brave new world.
> 
> Yes, please! That would have made working out all the differences
> between all the combinations of rt, rtx, rg, num, len, blk, etc a
> whole lot easier to work out.

<Nod> I'll go work all that out.

> > > > +struct xfs_rtgroup *
> > > > +xfs_rtgroup_grab(
> > > > +	struct xfs_mount	*mp,
> > > > +	xfs_agnumber_t		agno)
> > > > +{
> > > > +	struct xfs_rtgroup	*rtg;
> > > > +
> > > > +	rcu_read_lock();
> > > > +	rtg = xa_load(&mp->m_rtgroups, agno);
> > > > +	if (rtg) {
> > > > +		trace_xfs_rtgroup_grab(rtg, _RET_IP_);
> > > > +		if (!atomic_inc_not_zero(&rtg->rtg_active_ref))
> > > > +			rtg = NULL;
> > > > +	}
> > > > +	rcu_read_unlock();
> > > > +	return rtg;
> > > > +}
> > > > +
> > > > +void
> > > > +xfs_rtgroup_rele(
> > > > +	struct xfs_rtgroup	*rtg)
> > > > +{
> > > > +	trace_xfs_rtgroup_rele(rtg, _RET_IP_);
> > > > +	if (atomic_dec_and_test(&rtg->rtg_active_ref))
> > > > +		wake_up(&rtg->rtg_active_wq);
> > > > +}
> > > 
> > > This is all duplicates of the xfs_perag code. Can you put together a
> > > patchset to abstract this into a "xfs_group" and embed them in both
> > > the perag and and rtgroup structures?
> > > 
> > > That way we only need one set of lookup and iterator infrastructure,
> > > and it will work for both data and rt groups...
> > 
> > How will that work with perags still using the radix tree and rtgroups
> > using the xarray?  Yes, we should move the perags to use the xarray too
> > (and indeed hch already has a series on list to do that) but here's
> > really not the time to do that because I don't want to frontload a bunch
> > more core changes onto this already huge patchset.
> 
> Let's first assume they both use xarray (that's just a matter of
> time, yes?) so it's easier to reason about. Then we have something
> like this:
> 
> /*
>  * xfs_group - a contiguous 32 bit block address space group
>  */
> struct xfs_group {
> 	struct xarray		xarr;
> 	u32			num_groups;
> };

Ah, that's the group head.  I might call this struct xfs_groups?

So ... would it theoretically make more sense to use an rhashtable here?
Insofar as the only place that totally falls down is if you want to
iterate tagged groups; and that's only done for AGs.

I'm ok with using an xarray here, fwiw.

> struct xfs_group_item {
> 	struct xfs_group	*group; /* so put/rele don't need any other context */
> 	u32			gno;
> 	atomic_t		passive_refs;
> 	atomic_t		active_refs;
> 	wait_queue_head_t	active_wq;
> 	unsigned long		opstate;
> 
> 	u32			blocks;		/* length in fsb */
> 	u32			extents;	/* length in extents */
> 	u32			blk_log;	/* extent size in fsb */
> 
> 	/* limits for min/max valid addresses */
> 	u32			max_addr;
> 	u32			min_addr;
> };

Yeah, that's pretty much what I had in the prototype that I shredded an
hour ago.

> And then we define:
> 
> struct xfs_perag {
> 	struct xfs_group_item	g;
> 
> 	/* perag specific stuff follows */
> 	....
> };
> 
> struct xfs_rtgroup {
> 	struct xfs_group_item	g;
> 
> 	/* rtg specific stuff follows */
> 	.....
> 
> }
> 
> And then a couple of generic macros:
> 
> #define to_grpi(grpi, gi)	container_of((gi), typeof(grpi), g)
> #define to_gi(grpi)		(&(grpi)->g)
> 
> though this might be better as just typed macros:
> 
> #define gi_to_pag(gi)	container_of((gi), struct xfs_perag, g)
> #define gi_to_rtg(gi)	container_of((gi), struct xfs_rtgroup, g)
> 
> And then all the grab/rele/get/put stuff becomes:
> 
> 	rtg = to_grpi(rtg, xfs_group_grab(mp->m_rtgroups, rgno));
> 	pag = to_grpi(pag, xfs_group_grab(mp->m_perags, agno));
> 	....
> 	xfs_group_put(&rtg->g);
> 	xfs_group_put(&pag->g);
> 
> 
> or
> 
> 	rtg = gi_to_rtg(xfs_group_grab(mp->m_rtgroups, rgno));
> 	pag = gi_to_pag(xfs_group_grab(mp->m_perags, agno));
> 	....
> 	xfs_group_put(&rtg->g);
> 	xfs_group_put(&pag->g);
> 
> 
> then we pass the group to each of the "for_each_group..." iterators
> like so:
> 
> 	for_each_group(&mp->m_perags, agno, pag) {
> 		/* do stuff with pag */
> 	}
> 
> or
> 	for_each_group(&mp->m_rtgroups, rtgno, rtg) {
> 		/* do stuff with rtg */
> 	}
> 
> And we use typeof() and container_of() to access the group structure
> within the pag/rtg. Something like:
> 
> #define to_grpi(grpi, gi)	container_of((gi), typeof(grpi), g)
> #define to_gi(grpi)		(&(grpi)->g)
> 
> #define for_each_group(grp, gno, grpi)					\
> 	(gno) = 0;							\
> 	for ((grpi) = to_grpi((grpi), xfs_group_grab((grp), (gno)));	\
> 	     (grpi) != NULL;						\
> 	     (grpi) = to_grpi(grpi, xfs_group_next((grp), to_gi(grpi),	\
> 					&(gno), (grp)->num_groups))
> 
> And now we essentially have common group infrstructure for
> access, iteration, geometry and address verification purposes...

<nod> That's pretty much what I had drafted, albeit with different
helper macros since I kept the for_each_{perag,rtgroup} things around
for type safety.  Though I think for_each_perag just becomes:

#define for_each_perag(mp, agno, pag) \
	for_each_group((mp)->m_perags, (agno), (pag))

Right?

> > 
> > > > +
> > > > +/* Compute the number of rt extents in this realtime group. */
> > > > +xfs_rtxnum_t
> > > > +xfs_rtgroup_extents(
> > > +	struct xfs_mount	*mp,
> > > > +	xfs_rgnumber_t		rgno)
> > > > +{
> > > > +	xfs_rgnumber_t		rgcount = mp->m_sb.sb_rgcount;
> > > > +
> > > > +	ASSERT(rgno < rgcount);
> > > > +	if (rgno == rgcount - 1)
> > > > +		return mp->m_sb.sb_rextents -
> > > > +			((xfs_rtxnum_t)rgno * mp->m_sb.sb_rgextents);
> > > 
> > > Urk. So this relies on a non-rtgroup filesystem doing a
> > > multiplication by zero of a field that the on-disk format does not
> > > understand to get the right result.  I think this is a copying a bad
> > > pattern we've been slowly trying to remove from the normal
> > > allocation group code.
> > > 
> > > > +
> > > > +	ASSERT(xfs_has_rtgroups(mp));
> > > > +	return mp->m_sb.sb_rgextents;
> > > > +}
> > > 
> > > We already embed the length of the rtgroup in the rtgroup structure.
> > > THis should be looking up the rtgroup (or being passed the rtgroup
> > > the caller already has) and doing the right thing. i.e.
> > > 
> > > 	if (!rtg || !xfs_has_rtgroups(rtg->rtg_mount))
> > > 		return mp->m_sb.sb_rextents;
> > > 	return rtg->rtg_extents;
> > 
> > xfs_rtgroup_extents is the function that we use to set rtg->rtg_extents.
> 
> That wasn't clear from the context of the patch. Perhaps a better
> name xfs_rtgroup_calc_extents() to indicate that it is a setup
> function, not something that should be regularly called at runtime?

<nod>

> > 
> > > > +static inline xfs_rtblock_t
> > > > +xfs_rgno_start_rtb(
> > > > +	struct xfs_mount	*mp,
> > > > +	xfs_rgnumber_t		rgno)
> > > > +{
> > > > +	if (mp->m_rgblklog >= 0)
> > > > +		return ((xfs_rtblock_t)rgno << mp->m_rgblklog);
> > > > +	return ((xfs_rtblock_t)rgno * mp->m_rgblocks);
> > > > +}
> > > 
> > > Where does mp->m_rgblklog come from? That wasn't added to the
> > > on-disk superblock structure and it is always initialised to zero
> > > in this patch.
> > > 
> > > When will m_rgblklog be zero and when will it be non-zero? If it's
> > 
> > As I mentioned before, this patch merely ports non-rtg filesystems to
> > use the rtgroup structure.  m_rgblklog will be set to nonzero values
> > when we get to defining the ondisk rtgroup structure.
> 
> Yeah, which makes some of the context in the patch hard to
> understand... :/
> 
> > But, to cut ahead here, m_rgblklog will be set to a non-negative value
> > if the rtgroup size (in blocks) is a power of two.  Then these unit
> > conversion functions can use shifts instead of expensive multiplication
> > and divisions.  The same goes for rt extent to {fs,rt}block conversions.
> 
> yeah, so mp->m_rgblklog is not equivalent of mp->m_agblklog at all.
> It took me some time to understand that - the names are the same,
> they are used in similar address conversions, but they have
> completely different functions.
> 
> I suspect we need some better naming here, regardless of the
> rtgroups global address space layout discussion...

Or just make xfs_rtblock_t sparse, in which case I think m_rgblklog
usage patterns become exactly the same as m_agblklog.

> > > > +
> > > > +static inline uint64_t
> > > > +__xfs_rtb_to_rgbno(
> > > > +	struct xfs_mount	*mp,
> > > > +	xfs_rtblock_t		rtbno)
> > > > +{
> > > > +	uint32_t		rem;
> > > > +
> > > > +	if (!xfs_has_rtgroups(mp))
> > > > +		return rtbno;
> > > > +
> > > > +	if (mp->m_rgblklog >= 0)
> > > > +		return rtbno & mp->m_rgblkmask;
> > > > +
> > > > +	div_u64_rem(rtbno, mp->m_rgblocks, &rem);
> > > > +	return rem;
> > > > +}
> > > 
> > > Why is this function returning a uint64_t - a xfs_rgblock_t is only
> > > a 32 bit type...
> > 
> > group 0 on a !rtg filesystem can be 64-bits in block/rt count.  This is
> > a /very/ annoying pain point -- if you actually created such a
> > filesystem it actually would never work because the rtsummary file would
> > be created undersized due to an integer overflow, but the verifiers
> > never checked any of that, and due to the same underflow the rtallocator
> > would search the wrong places and (eventually) fall back to a dumb
> > linear scan.
> > 
> > Soooooo this is an obnoxious usecase (broken large !rtg filesystems)
> > that we can't just drop, though I'm pretty sure there aren't any systems
> > in the wild.
> 
> Ugh. That definitely needs to be a comment somewhere in the code to
> explain this. :/

Well it's all in the commit that fixed the rtsummary for those things.

> > > > diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> > > > index a8cd44d03ef64..1ce4b9eb16f47 100644
> > > > --- a/fs/xfs/libxfs/xfs_types.h
> > > > +++ b/fs/xfs/libxfs/xfs_types.h
> > > > @@ -9,10 +9,12 @@
> > > >  typedef uint32_t	prid_t;		/* project ID */
> > > >  
> > > >  typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
> > > > +typedef uint32_t	xfs_rgblock_t;	/* blockno in realtime group */
> > > 
> > > Is that right? The rtg length is 2^32 * rtextsize, and rtextsize can
> > > be 2^20 bytes:
> > > 
> > > #define XFS_MAX_RTEXTSIZE (1024 * 1024 * 1024)
> > 
> > No, the maximum rtgroup length is 2^32-1 blocks.
> 
> I couldn't tell if the max length was being defined as the maximum
> number of rt extents that the rtgroup could index, of whether it was
> the maximum number of filesystem blocks (i.e. data device fsblock
> size) tha an rtgroup could index...

The max rtgroup length is defined in blocks; the min is defined in rt
extents.  I might want to bump up the minimum a bit, but I think
Christoph should weigh in on that first -- I think his zns patchset
currently assigns one rtgroup to each zone?  Because he was muttering
about how 130,000x 256MB rtgroups really sucks.  Would it be very messy
to have a minimum size of (say) 1GB?

> > > Hence for a 4kB fsbno filesystem, the actual maximum size of an rtg
> > > in filesystem blocks far exceeds what we can address with a 32 bit
> > > variable.
> > > 
> > > If xfs_rgblock_t is actually indexing multi-fsbno rtextents, then it
> > > is an extent number index, not a "block" index. An extent number
> > > index won't overflow 32 bits (because the rtg has a max of 2^32 - 1
> > > rtextents)
> > > 
> > > IOWs, shouldn't this be named soemthing like:
> > > 
> > > typedef uint32_t	xfs_rgext_t;	/* extent number in realtime group */
> > 
> > and again, we can't do that because we emulate !rtg filesystems with a
> > single "rtgroup" that can be more than 2^32 rtx long.
> 
> *nod*
> 
> > > >  typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
> > > >  typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
> > > >  typedef uint32_t	xfs_rtxlen_t;	/* file extent length in rtextents */
> > > >  typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
> > > > +typedef uint32_t	xfs_rgnumber_t;	/* realtime group number */
> > > >  typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
> > > >  typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
> > > >  typedef int64_t		xfs_fsize_t;	/* bytes in a file */
> > > > @@ -53,7 +55,9 @@ typedef void *		xfs_failaddr_t;
> > > >  #define	NULLFILEOFF	((xfs_fileoff_t)-1)
> > > >  
> > > >  #define	NULLAGBLOCK	((xfs_agblock_t)-1)
> > > > +#define NULLRGBLOCK	((xfs_rgblock_t)-1)
> > > >  #define	NULLAGNUMBER	((xfs_agnumber_t)-1)
> > > > +#define	NULLRGNUMBER	((xfs_rgnumber_t)-1)
> > > 
> > > What's the maximum valid rtg number? We're not ever going to be
> > > supporting 2^32 - 2 rtgs, so what is a realistic maximum we can cap
> > > this at and validate it at?
> > 
> > /me shrugs -- the smallest AG size on the data device is 16M, which
> > technically speaking means that one /could/ format 2^(63-24) groups,
> > or order 39.
> > 
> > Realistically with the maximum rtgroup size of 2^31 blocks, we probably
> > only need 2^(63 - (31 + 10)) = 2^22 rtgroups max on a 1k fsblock fs.
> 
> Right, those are the theoretical maximums. Practically speaking,
> though, mkfs and mount iteration of all AGs means millions to
> billions of IOs need to be done before the filesystem can even be
> fully mounted. Hence the practical limit to AG count is closer to a
> few tens of thousands, not hundreds of billions.
> 
> Hence I'm wondering if we should actually cap the maximum number of
> rtgroups. WE're just about at BS > PS, so with a 64k block size a
> single rtgroup can index 2^32 * 2^16 bytes which puts individual
> rtgs at 256TB in size. Unless there are use cases for rtgroup sizes
> smaller than a few GBs, I just don't see the need for support
> theoretical maximum counts on tiny block size filesystems. Thirty
> thousand rtgs at 256TB per rtg puts us at 64 bit device size limits,
> and we hit those limits on 4kB block sizes at around 500,000 rtgs.
> 
> So do we need to support millions of rtgs? I'd say no....

...but we might.  Christoph, how gnarly does zns support get if you have
to be able to pack multiple SMR zones into a single rtgroup?

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
