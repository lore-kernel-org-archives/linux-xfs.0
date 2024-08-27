Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FFA38C
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 00:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724720261; cv=none; b=mFZXUD1Kjjd7IFI0ELuicneT+KDJFFWCHBWNcjkvoye9RicOBt2RXce8HPuF04Bve312CBXySRO821vCl9eZeOHTXNySNfVqREMQVnvO9yT5rvaeSlC2+ovD8xOCpsuUKJWMjwKHN+EVBeNXKoK5jeBEQ9kkKrc2/rg00SbNUE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724720261; c=relaxed/simple;
	bh=X7uEknKgWGyyIibGum8oTWB6ZBm/Us2SeBPb4hvaZ9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CKY2be7donoUwE6ECYU/LsmPCByYaQbgUoY6L4VPjY/EbT+J7PZLDw+hSwpB6UgGCiFuaS+8bS/Ed45nqO45Rbsa9sfI2QTY4DpnJF4xMUm0vbwMSOiMqCrRZDaETzxsCH+iOyYO7TyRpdo5Kzo381mFuuqX7O/Sk9QpRcLLB4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=EoroAJDW; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="EoroAJDW"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-202089e57d8so31367185ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 17:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724720259; x=1725325059; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sbxkl8BEbQOsSNMTC6o4Em8tv3SfoXeyiB8DKwu8Fa0=;
        b=EoroAJDWyLfT9OJLxy9zjFmWDbMl0skAHn8Trs4tqaspQ1l4e8kkrlmRh9aMMSEzEx
         78zveDkCtXY99QvU0PPOpkWmqwEMq0OgGQy0wNdqR3H69lmv1jx78PNT9xZYFwpMkE2/
         KvY2APjxeuI//3MJxa2Bn31hA6vbjIxgVHLrUeFYTommIuG4N6Aj+IrnJ9VKvhfLTWdn
         QaYtCH+43uKkQRZJdlurWeWmVBXo3EARTJOO3aUHn73RQfhdidfIoW3AduZb5jht9oRi
         r+hFgIzu8sdTzPJFp796yebmJxQ8P+JOafwB3UtlnH6aGfIIFaUncCdaQ6ndrLEtEEk3
         1seQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724720259; x=1725325059;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sbxkl8BEbQOsSNMTC6o4Em8tv3SfoXeyiB8DKwu8Fa0=;
        b=E6UahqGfHV3mb9Yyc42Iopt1vmXcLHhoTVSARjtsI9xjZuIVQBF1clsyxXtwfloGan
         EKOhw72MzAMDeXT615lTSfAaH5E5A5wGaMhbeyfxV2Nd9bneksc8e9xA+TSTA3D0F6VL
         gY5qeHJY9YbRIrnDyukenM+kDSsJGMZHQDWDEoRsON4/mS5OiOhtgu1i1eJTY1xz+WSL
         Z/NaYICNUjexUP9eaXtaiGkyXN/LuNz1bz6Ih/LCsrlCWnHr68lTU7jCOczDvjxh2d1r
         3UABP55FYFzezRDXe9kGeptagO1TM5ugxUh+3lzImvXUK3GhJQp7OeHOE32K4+9v9czo
         RmsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdm1GP6KzSaJmajjJ5qPpNQj9LxMxpcrRBtiDw6h8cV7LgpvZadR5+8CBZ8Pu4wgW2jx7IkpP8SaA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyN2HSeZyKK7s4J+AVURlOKfVJaU1aetCu/ehsx5+wIC4GjImV
	dA9sG4+jt4kAJdDDOlJ6yCcB/QoRgY/dnJu50G3haOyUIRtep0H5l7SFWQ56Q9GVDoLZY06PZCx
	n
X-Google-Smtp-Source: AGHT+IGh+mTKFIKNVix8jtjxgeF/xqEbkNoG21p0nFYLBfX6rHtHPnB5CB/cnRDKpZpoB3axKJP0pQ==
X-Received: by 2002:a17:903:22cb:b0:1fb:2ebc:d16b with SMTP id d9443c01a7336-204ddcaee6bmr18838265ad.7.1724720258856;
        Mon, 26 Aug 2024 17:57:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20385567912sm73043405ad.33.2024.08.26.17.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 17:57:38 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sikWc-00DyXg-2X;
	Tue, 27 Aug 2024 10:57:34 +1000
Date: Tue, 27 Aug 2024 10:57:34 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/24] xfs: create incore realtime group structures
Message-ID: <Zs0kfidzTGC7KACX@dread.disaster.area>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087433.59588.10419191726395528458.stgit@frogsfrogsfrogs>
 <ZsvEmInHRA6GVuz3@dread.disaster.area>
 <20240826191404.GC865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826191404.GC865349@frogsfrogsfrogs>

On Mon, Aug 26, 2024 at 12:14:04PM -0700, Darrick J. Wong wrote:
> On Mon, Aug 26, 2024 at 09:56:08AM +1000, Dave Chinner wrote:
> > On Thu, Aug 22, 2024 at 05:17:31PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Create an incore object that will contain information about a realtime
> > > allocation group.  This will eventually enable us to shard the realtime
> > > section in a similar manner to how we shard the data section, but for
> > > now just a single object for the entire RT subvolume is created.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/Makefile             |    1 
> > >  fs/xfs/libxfs/xfs_format.h  |    3 +
> > >  fs/xfs/libxfs/xfs_rtgroup.c |  196 ++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/libxfs/xfs_rtgroup.h |  212 +++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/libxfs/xfs_sb.c      |    7 +
> > >  fs/xfs/libxfs/xfs_types.h   |    4 +
> > >  fs/xfs/xfs_log_recover.c    |   20 ++++
> > >  fs/xfs/xfs_mount.c          |   16 +++
> > >  fs/xfs/xfs_mount.h          |   14 +++
> > >  fs/xfs/xfs_rtalloc.c        |    6 +
> > >  fs/xfs/xfs_super.c          |    1 
> > >  fs/xfs/xfs_trace.c          |    1 
> > >  fs/xfs/xfs_trace.h          |   38 ++++++++
> > >  13 files changed, 517 insertions(+), 2 deletions(-)
> > >  create mode 100644 fs/xfs/libxfs/xfs_rtgroup.c
> > >  create mode 100644 fs/xfs/libxfs/xfs_rtgroup.h
> > 
> > Ok, how is the global address space for real time extents laid out
> > across rt groups? i.e. is it sparse similar to how fsbnos and inode
> > numbers are created for the data device like so?
> > 
> > 	fsbno = (agno << agblklog) | agbno
> > 
> > Or is it something different? I can't find that defined anywhere in
> > this patch, so I can't determine if the unit conversion code and
> > validation is correct or not...
> 
> They're not sparse like fsbnos on the data device, they're laid end to
> end.  IOWs, it's a straight linear translation.  If you have an rtgroup
> that is 50 blocks long, then rtgroup 1 starts at (50 * blocksize).

Yes, I figured that out later. I think that's less than optimal,
because it essentially repeats the problems we have with AGs being
fixed size without the potential for fixing it easily. i.e. the
global sharded fsbno address space is sparse, so we can actually
space out the sparse address regions to allow future flexibility in
group size and location work.

By having the rtgroup addressing being purely physical, we're
completely stuck with fixed sized rtgroups and there is no way
around that. IOWs, the physical address space sharding repeats the
existing grow and shrink problems we have with the existing fixed
size AGs.

We're discussing how to use the sparse fsbno addressing to allow
resizing of AGs, but we will not be able to do that at all with
rtgroups as they stand. The limitation is a 64 bit global rt extent
address is essential the physical address of the extent in the block
device LBA space.

> 
> This patch, FWIW, refactors the existing rt code so that a !rtgroups
> filesystem is represented by one large "group", with xfs_rtxnum_t now
> indexing rt extents within a group. 

Right, we can do that regardless of whether we use logical or
physical addressing for the global rtbno for sharded rtgroup layout.
the rtgno of 0 for that rtg always results in logical = physical
addressing.

> Probably it should be renamed to xfs_rgxnum_t.

That might be a good idea.

> Note that we haven't defined the rtgroup ondisk format yet, so I'll go
> amend that patch to spell out the ondisk format of the brave new world.

Yes, please! That would have made working out all the differences
between all the combinations of rt, rtx, rg, num, len, blk, etc a
whole lot easier to work out.

> > > +struct xfs_rtgroup *
> > > +xfs_rtgroup_grab(
> > > +	struct xfs_mount	*mp,
> > > +	xfs_agnumber_t		agno)
> > > +{
> > > +	struct xfs_rtgroup	*rtg;
> > > +
> > > +	rcu_read_lock();
> > > +	rtg = xa_load(&mp->m_rtgroups, agno);
> > > +	if (rtg) {
> > > +		trace_xfs_rtgroup_grab(rtg, _RET_IP_);
> > > +		if (!atomic_inc_not_zero(&rtg->rtg_active_ref))
> > > +			rtg = NULL;
> > > +	}
> > > +	rcu_read_unlock();
> > > +	return rtg;
> > > +}
> > > +
> > > +void
> > > +xfs_rtgroup_rele(
> > > +	struct xfs_rtgroup	*rtg)
> > > +{
> > > +	trace_xfs_rtgroup_rele(rtg, _RET_IP_);
> > > +	if (atomic_dec_and_test(&rtg->rtg_active_ref))
> > > +		wake_up(&rtg->rtg_active_wq);
> > > +}
> > 
> > This is all duplicates of the xfs_perag code. Can you put together a
> > patchset to abstract this into a "xfs_group" and embed them in both
> > the perag and and rtgroup structures?
> > 
> > That way we only need one set of lookup and iterator infrastructure,
> > and it will work for both data and rt groups...
> 
> How will that work with perags still using the radix tree and rtgroups
> using the xarray?  Yes, we should move the perags to use the xarray too
> (and indeed hch already has a series on list to do that) but here's
> really not the time to do that because I don't want to frontload a bunch
> more core changes onto this already huge patchset.

Let's first assume they both use xarray (that's just a matter of
time, yes?) so it's easier to reason about. Then we have something
like this:

/*
 * xfs_group - a contiguous 32 bit block address space group
 */
struct xfs_group {
	struct xarray		xarr;
	u32			num_groups;
};

struct xfs_group_item {
	struct xfs_group	*group; /* so put/rele don't need any other context */
	u32			gno;
	atomic_t		passive_refs;
	atomic_t		active_refs;
	wait_queue_head_t	active_wq;
	unsigned long		opstate;

	u32			blocks;		/* length in fsb */
	u32			extents;	/* length in extents */
	u32			blk_log;	/* extent size in fsb */

	/* limits for min/max valid addresses */
	u32			max_addr;
	u32			min_addr;
};

And then we define:

struct xfs_perag {
	struct xfs_group_item	g;

	/* perag specific stuff follows */
	....
};

struct xfs_rtgroup {
	struct xfs_group_item	g;

	/* rtg specific stuff follows */
	.....

}

And then a couple of generic macros:

#define to_grpi(grpi, gi)	container_of((gi), typeof(grpi), g)
#define to_gi(grpi)		(&(grpi)->g)

though this might be better as just typed macros:

#define gi_to_pag(gi)	container_of((gi), struct xfs_perag, g)
#define gi_to_rtg(gi)	container_of((gi), struct xfs_rtgroup, g)

And then all the grab/rele/get/put stuff becomes:

	rtg = to_grpi(rtg, xfs_group_grab(mp->m_rtgroups, rgno));
	pag = to_grpi(pag, xfs_group_grab(mp->m_perags, agno));
	....
	xfs_group_put(&rtg->g);
	xfs_group_put(&pag->g);


or

	rtg = gi_to_rtg(xfs_group_grab(mp->m_rtgroups, rgno));
	pag = gi_to_pag(xfs_group_grab(mp->m_perags, agno));
	....
	xfs_group_put(&rtg->g);
	xfs_group_put(&pag->g);


then we pass the group to each of the "for_each_group..." iterators
like so:

	for_each_group(&mp->m_perags, agno, pag) {
		/* do stuff with pag */
	}

or
	for_each_group(&mp->m_rtgroups, rtgno, rtg) {
		/* do stuff with rtg */
	}

And we use typeof() and container_of() to access the group structure
within the pag/rtg. Something like:

#define to_grpi(grpi, gi)	container_of((gi), typeof(grpi), g)
#define to_gi(grpi)		(&(grpi)->g)

#define for_each_group(grp, gno, grpi)					\
	(gno) = 0;							\
	for ((grpi) = to_grpi((grpi), xfs_group_grab((grp), (gno)));	\
	     (grpi) != NULL;						\
	     (grpi) = to_grpi(grpi, xfs_group_next((grp), to_gi(grpi),	\
					&(gno), (grp)->num_groups))

And now we essentially have common group infrstructure for
access, iteration, geometry and address verification purposes...

> 
> > > +
> > > +/* Compute the number of rt extents in this realtime group. */
> > > +xfs_rtxnum_t
> > > +xfs_rtgroup_extents(
> > +	struct xfs_mount	*mp,
> > > +	xfs_rgnumber_t		rgno)
> > > +{
> > > +	xfs_rgnumber_t		rgcount = mp->m_sb.sb_rgcount;
> > > +
> > > +	ASSERT(rgno < rgcount);
> > > +	if (rgno == rgcount - 1)
> > > +		return mp->m_sb.sb_rextents -
> > > +			((xfs_rtxnum_t)rgno * mp->m_sb.sb_rgextents);
> > 
> > Urk. So this relies on a non-rtgroup filesystem doing a
> > multiplication by zero of a field that the on-disk format does not
> > understand to get the right result.  I think this is a copying a bad
> > pattern we've been slowly trying to remove from the normal
> > allocation group code.
> > 
> > > +
> > > +	ASSERT(xfs_has_rtgroups(mp));
> > > +	return mp->m_sb.sb_rgextents;
> > > +}
> > 
> > We already embed the length of the rtgroup in the rtgroup structure.
> > THis should be looking up the rtgroup (or being passed the rtgroup
> > the caller already has) and doing the right thing. i.e.
> > 
> > 	if (!rtg || !xfs_has_rtgroups(rtg->rtg_mount))
> > 		return mp->m_sb.sb_rextents;
> > 	return rtg->rtg_extents;
> 
> xfs_rtgroup_extents is the function that we use to set rtg->rtg_extents.

That wasn't clear from the context of the patch. Perhaps a better
name xfs_rtgroup_calc_extents() to indicate that it is a setup
function, not something that should be regularly called at runtime?

> 
> > > +static inline xfs_rtblock_t
> > > +xfs_rgno_start_rtb(
> > > +	struct xfs_mount	*mp,
> > > +	xfs_rgnumber_t		rgno)
> > > +{
> > > +	if (mp->m_rgblklog >= 0)
> > > +		return ((xfs_rtblock_t)rgno << mp->m_rgblklog);
> > > +	return ((xfs_rtblock_t)rgno * mp->m_rgblocks);
> > > +}
> > 
> > Where does mp->m_rgblklog come from? That wasn't added to the
> > on-disk superblock structure and it is always initialised to zero
> > in this patch.
> > 
> > When will m_rgblklog be zero and when will it be non-zero? If it's
> 
> As I mentioned before, this patch merely ports non-rtg filesystems to
> use the rtgroup structure.  m_rgblklog will be set to nonzero values
> when we get to defining the ondisk rtgroup structure.

Yeah, which makes some of the context in the patch hard to
understand... :/

> But, to cut ahead here, m_rgblklog will be set to a non-negative value
> if the rtgroup size (in blocks) is a power of two.  Then these unit
> conversion functions can use shifts instead of expensive multiplication
> and divisions.  The same goes for rt extent to {fs,rt}block conversions.

yeah, so mp->m_rgblklog is not equivalent of mp->m_agblklog at all.
It took me some time to understand that - the names are the same,
they are used in similar address conversions, but they have
completely different functions.

I suspect we need some better naming here, regardless of the
rtgroups global address space layout discussion...

> > > +
> > > +static inline uint64_t
> > > +__xfs_rtb_to_rgbno(
> > > +	struct xfs_mount	*mp,
> > > +	xfs_rtblock_t		rtbno)
> > > +{
> > > +	uint32_t		rem;
> > > +
> > > +	if (!xfs_has_rtgroups(mp))
> > > +		return rtbno;
> > > +
> > > +	if (mp->m_rgblklog >= 0)
> > > +		return rtbno & mp->m_rgblkmask;
> > > +
> > > +	div_u64_rem(rtbno, mp->m_rgblocks, &rem);
> > > +	return rem;
> > > +}
> > 
> > Why is this function returning a uint64_t - a xfs_rgblock_t is only
> > a 32 bit type...
> 
> group 0 on a !rtg filesystem can be 64-bits in block/rt count.  This is
> a /very/ annoying pain point -- if you actually created such a
> filesystem it actually would never work because the rtsummary file would
> be created undersized due to an integer overflow, but the verifiers
> never checked any of that, and due to the same underflow the rtallocator
> would search the wrong places and (eventually) fall back to a dumb
> linear scan.
> 
> Soooooo this is an obnoxious usecase (broken large !rtg filesystems)
> that we can't just drop, though I'm pretty sure there aren't any systems
> in the wild.

Ugh. That definitely needs to be a comment somewhere in the code to
explain this. :/

> > > diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> > > index a8cd44d03ef64..1ce4b9eb16f47 100644
> > > --- a/fs/xfs/libxfs/xfs_types.h
> > > +++ b/fs/xfs/libxfs/xfs_types.h
> > > @@ -9,10 +9,12 @@
> > >  typedef uint32_t	prid_t;		/* project ID */
> > >  
> > >  typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
> > > +typedef uint32_t	xfs_rgblock_t;	/* blockno in realtime group */
> > 
> > Is that right? The rtg length is 2^32 * rtextsize, and rtextsize can
> > be 2^20 bytes:
> > 
> > #define XFS_MAX_RTEXTSIZE (1024 * 1024 * 1024)
> 
> No, the maximum rtgroup length is 2^32-1 blocks.

I couldn't tell if the max length was being defined as the maximum
number of rt extents that the rtgroup could index, of whether it was
the maximum number of filesystem blocks (i.e. data device fsblock
size) tha an rtgroup could index...


> > Hence for a 4kB fsbno filesystem, the actual maximum size of an rtg
> > in filesystem blocks far exceeds what we can address with a 32 bit
> > variable.
> > 
> > If xfs_rgblock_t is actually indexing multi-fsbno rtextents, then it
> > is an extent number index, not a "block" index. An extent number
> > index won't overflow 32 bits (because the rtg has a max of 2^32 - 1
> > rtextents)
> > 
> > IOWs, shouldn't this be named soemthing like:
> > 
> > typedef uint32_t	xfs_rgext_t;	/* extent number in realtime group */
> 
> and again, we can't do that because we emulate !rtg filesystems with a
> single "rtgroup" that can be more than 2^32 rtx long.

*nod*

> > >  typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
> > >  typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
> > >  typedef uint32_t	xfs_rtxlen_t;	/* file extent length in rtextents */
> > >  typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
> > > +typedef uint32_t	xfs_rgnumber_t;	/* realtime group number */
> > >  typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
> > >  typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
> > >  typedef int64_t		xfs_fsize_t;	/* bytes in a file */
> > > @@ -53,7 +55,9 @@ typedef void *		xfs_failaddr_t;
> > >  #define	NULLFILEOFF	((xfs_fileoff_t)-1)
> > >  
> > >  #define	NULLAGBLOCK	((xfs_agblock_t)-1)
> > > +#define NULLRGBLOCK	((xfs_rgblock_t)-1)
> > >  #define	NULLAGNUMBER	((xfs_agnumber_t)-1)
> > > +#define	NULLRGNUMBER	((xfs_rgnumber_t)-1)
> > 
> > What's the maximum valid rtg number? We're not ever going to be
> > supporting 2^32 - 2 rtgs, so what is a realistic maximum we can cap
> > this at and validate it at?
> 
> /me shrugs -- the smallest AG size on the data device is 16M, which
> technically speaking means that one /could/ format 2^(63-24) groups,
> or order 39.
> 
> Realistically with the maximum rtgroup size of 2^31 blocks, we probably
> only need 2^(63 - (31 + 10)) = 2^22 rtgroups max on a 1k fsblock fs.

Right, those are the theoretical maximums. Practically speaking,
though, mkfs and mount iteration of all AGs means millions to
billions of IOs need to be done before the filesystem can even be
fully mounted. Hence the practical limit to AG count is closer to a
few tens of thousands, not hundreds of billions.

Hence I'm wondering if we should actually cap the maximum number of
rtgroups. WE're just about at BS > PS, so with a 64k block size a
single rtgroup can index 2^32 * 2^16 bytes which puts individual
rtgs at 256TB in size. Unless there are use cases for rtgroup sizes
smaller than a few GBs, I just don't see the need for support
theoretical maximum counts on tiny block size filesystems. Thirty
thousand rtgs at 256TB per rtg puts us at 64 bit device size limits,
and we hit those limits on 4kB block sizes at around 500,000 rtgs.

So do we need to support millions of rtgs? I'd say no....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
