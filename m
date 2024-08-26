Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2127B7DA92
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 19:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724699645; cv=none; b=WkeVoJApsu/obKMXe2AfDI31Hh3ruva9a4iMgmZvoDwtGieTRdBGXzvYROUH3/ifyCVFmW7cw4vtyCppltNSJ29Da1Rct3l7E22TnTbzz7WBBp12SQWr0G4fJitKbWlctKc8EoupSbC1P8Mi9V32tQQTiAIKh9/x0vHjGT8J5Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724699645; c=relaxed/simple;
	bh=Y0uF/P4Df4nL6wKPB/AWyFjiFHuPJtYc2EkRWHhg57k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RxyxZFVt2pUktKDTvKxMNZI85ERZfjavyaVgxyERr4yACkUekm/MfRIscua/1s3V5QavdeSOWGVXbRj7c8U0E3UKm5tDCXp4DmEj6BXMQMl5mi8Cd4Ga+VV3FX+3n8Mbb/jGCPa27agL1Kp83MoyyLwkk4AATKpBNUpRoZmoheo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tfk14mb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tfk14mb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CF3C4FDE1;
	Mon, 26 Aug 2024 19:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724699644;
	bh=Y0uF/P4Df4nL6wKPB/AWyFjiFHuPJtYc2EkRWHhg57k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tfk14mb0NG0RcJfObLwojTaRncIFKP8cj1bOprVtABKAYrVDTSghtG64qJ8r+RfvS
	 WE6fkKv19IW5FDbP/jXWwAuysXsR4wEsjTsJBxrvr2uW9OtYmEnbc2MH+YiM6PgBhE
	 AQhzHw3wvqFEiE4Wqw32uIz6VjjDjAajROzrEeexQspYS6cr9vbshU1koL2F7IiWNu
	 borbzwXfra2eFBDNFr+8BfP07fR7/NP+aVrTqlZ5W26a5Zng3bq6gEhH6BjQofLYDK
	 9Dh2MSD7FKeK8W8Uik06pAPzRUhsaH6Fl+L+OTM6nUPkj2jUqLkVOM3VvphsCm0eaA
	 vpwym5EAzkDOA==
Date: Mon, 26 Aug 2024 12:14:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/24] xfs: create incore realtime group structures
Message-ID: <20240826191404.GC865349@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087433.59588.10419191726395528458.stgit@frogsfrogsfrogs>
 <ZsvEmInHRA6GVuz3@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsvEmInHRA6GVuz3@dread.disaster.area>

On Mon, Aug 26, 2024 at 09:56:08AM +1000, Dave Chinner wrote:
> On Thu, Aug 22, 2024 at 05:17:31PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create an incore object that will contain information about a realtime
> > allocation group.  This will eventually enable us to shard the realtime
> > section in a similar manner to how we shard the data section, but for
> > now just a single object for the entire RT subvolume is created.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/Makefile             |    1 
> >  fs/xfs/libxfs/xfs_format.h  |    3 +
> >  fs/xfs/libxfs/xfs_rtgroup.c |  196 ++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_rtgroup.h |  212 +++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_sb.c      |    7 +
> >  fs/xfs/libxfs/xfs_types.h   |    4 +
> >  fs/xfs/xfs_log_recover.c    |   20 ++++
> >  fs/xfs/xfs_mount.c          |   16 +++
> >  fs/xfs/xfs_mount.h          |   14 +++
> >  fs/xfs/xfs_rtalloc.c        |    6 +
> >  fs/xfs/xfs_super.c          |    1 
> >  fs/xfs/xfs_trace.c          |    1 
> >  fs/xfs/xfs_trace.h          |   38 ++++++++
> >  13 files changed, 517 insertions(+), 2 deletions(-)
> >  create mode 100644 fs/xfs/libxfs/xfs_rtgroup.c
> >  create mode 100644 fs/xfs/libxfs/xfs_rtgroup.h
> 
> Ok, how is the global address space for real time extents laid out
> across rt groups? i.e. is it sparse similar to how fsbnos and inode
> numbers are created for the data device like so?
> 
> 	fsbno = (agno << agblklog) | agbno
> 
> Or is it something different? I can't find that defined anywhere in
> this patch, so I can't determine if the unit conversion code and
> validation is correct or not...

They're not sparse like fsbnos on the data device, they're laid end to
end.  IOWs, it's a straight linear translation.  If you have an rtgroup
that is 50 blocks long, then rtgroup 1 starts at (50 * blocksize).

This patch, FWIW, refactors the existing rt code so that a !rtgroups
filesystem is represented by one large "group", with xfs_rtxnum_t now
indexing rt extents within a group.  Probably it should be renamed to
xfs_rgxnum_t.

Note that we haven't defined the rtgroup ondisk format yet, so I'll go
amend that patch to spell out the ondisk format of the brave new world.

> > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > index 4d8ca08cdd0ec..388b5cef48ca5 100644
> > --- a/fs/xfs/Makefile
> > +++ b/fs/xfs/Makefile
> > @@ -60,6 +60,7 @@ xfs-y				+= $(addprefix libxfs/, \
> >  # xfs_rtbitmap is shared with libxfs
> >  xfs-$(CONFIG_XFS_RT)		+= $(addprefix libxfs/, \
> >  				   xfs_rtbitmap.o \
> > +				   xfs_rtgroup.o \
> >  				   )
> >  
> >  # highlevel code
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 16a7bc02aa5f5..fa5cfc8265d92 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -176,6 +176,9 @@ typedef struct xfs_sb {
> >  
> >  	xfs_ino_t	sb_metadirino;	/* metadata directory tree root */
> >  
> > +	xfs_rgnumber_t	sb_rgcount;	/* number of realtime groups */
> > +	xfs_rtxlen_t	sb_rgextents;	/* size of a realtime group in rtx */
> 
> So min/max rtgroup size is defined by the sb_rextsize field? What
> redundant metadata do we end up with that allows us to validate
> the sb_rextsize field is still valid w.r.t. rtgroups geometry?
> 
> Also, rtgroup lengths are defined by "rtx counts", but the
> definitions in the xfs_mount later on are "m_rtblklog" and
> "m_rgblocks" and we use xfs_rgblock_t and rgbno all over the place.
> 
> Just from the context of this patch, it is somewhat confusing trying
> to work out what the difference is...
> 
> 
> >  	/* must be padded to 64 bit alignment */
> >  } xfs_sb_t;
> >  
> > diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
> > new file mode 100644
> > index 0000000000000..2bad1ecb811eb
> > --- /dev/null
> > +++ b/fs/xfs/libxfs/xfs_rtgroup.c
> > @@ -0,0 +1,196 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
> > + * Author: Darrick J. Wong <djwong@kernel.org>
> > + */
> > +#include "xfs.h"
> > +#include "xfs_fs.h"
> > +#include "xfs_shared.h"
> > +#include "xfs_format.h"
> > +#include "xfs_trans_resv.h"
> > +#include "xfs_bit.h"
> > +#include "xfs_sb.h"
> > +#include "xfs_mount.h"
> > +#include "xfs_btree.h"
> > +#include "xfs_alloc_btree.h"
> > +#include "xfs_rmap_btree.h"
> > +#include "xfs_alloc.h"
> > +#include "xfs_ialloc.h"
> > +#include "xfs_rmap.h"
> > +#include "xfs_ag.h"
> > +#include "xfs_ag_resv.h"
> > +#include "xfs_health.h"
> > +#include "xfs_error.h"
> > +#include "xfs_bmap.h"
> > +#include "xfs_defer.h"
> > +#include "xfs_log_format.h"
> > +#include "xfs_trans.h"
> > +#include "xfs_trace.h"
> > +#include "xfs_inode.h"
> > +#include "xfs_icache.h"
> > +#include "xfs_rtgroup.h"
> > +#include "xfs_rtbitmap.h"
> > +
> > +/*
> > + * Passive reference counting access wrappers to the rtgroup structures.  If
> > + * the rtgroup structure is to be freed, the freeing code is responsible for
> > + * cleaning up objects with passive references before freeing the structure.
> > + */
> > +struct xfs_rtgroup *
> > +xfs_rtgroup_get(
> > +	struct xfs_mount	*mp,
> > +	xfs_rgnumber_t		rgno)
> > +{
> > +	struct xfs_rtgroup	*rtg;
> > +
> > +	rcu_read_lock();
> > +	rtg = xa_load(&mp->m_rtgroups, rgno);
> > +	if (rtg) {
> > +		trace_xfs_rtgroup_get(rtg, _RET_IP_);
> > +		ASSERT(atomic_read(&rtg->rtg_ref) >= 0);
> > +		atomic_inc(&rtg->rtg_ref);
> > +	}
> > +	rcu_read_unlock();
> > +	return rtg;
> > +}
> > +
> > +/* Get a passive reference to the given rtgroup. */
> > +struct xfs_rtgroup *
> > +xfs_rtgroup_hold(
> > +	struct xfs_rtgroup	*rtg)
> > +{
> > +	ASSERT(atomic_read(&rtg->rtg_ref) > 0 ||
> > +	       atomic_read(&rtg->rtg_active_ref) > 0);
> > +
> > +	trace_xfs_rtgroup_hold(rtg, _RET_IP_);
> > +	atomic_inc(&rtg->rtg_ref);
> > +	return rtg;
> > +}
> > +
> > +void
> > +xfs_rtgroup_put(
> > +	struct xfs_rtgroup	*rtg)
> > +{
> > +	trace_xfs_rtgroup_put(rtg, _RET_IP_);
> > +	ASSERT(atomic_read(&rtg->rtg_ref) > 0);
> > +	atomic_dec(&rtg->rtg_ref);
> > +}
> > +
> > +/*
> > + * Active references for rtgroup structures. This is for short term access to
> > + * the rtgroup structures for walking trees or accessing state. If an rtgroup
> > + * is being shrunk or is offline, then this will fail to find that group and
> > + * return NULL instead.
> > + */
> > +struct xfs_rtgroup *
> > +xfs_rtgroup_grab(
> > +	struct xfs_mount	*mp,
> > +	xfs_agnumber_t		agno)
> > +{
> > +	struct xfs_rtgroup	*rtg;
> > +
> > +	rcu_read_lock();
> > +	rtg = xa_load(&mp->m_rtgroups, agno);
> > +	if (rtg) {
> > +		trace_xfs_rtgroup_grab(rtg, _RET_IP_);
> > +		if (!atomic_inc_not_zero(&rtg->rtg_active_ref))
> > +			rtg = NULL;
> > +	}
> > +	rcu_read_unlock();
> > +	return rtg;
> > +}
> > +
> > +void
> > +xfs_rtgroup_rele(
> > +	struct xfs_rtgroup	*rtg)
> > +{
> > +	trace_xfs_rtgroup_rele(rtg, _RET_IP_);
> > +	if (atomic_dec_and_test(&rtg->rtg_active_ref))
> > +		wake_up(&rtg->rtg_active_wq);
> > +}
> 
> This is all duplicates of the xfs_perag code. Can you put together a
> patchset to abstract this into a "xfs_group" and embed them in both
> the perag and and rtgroup structures?
> 
> That way we only need one set of lookup and iterator infrastructure,
> and it will work for both data and rt groups...

How will that work with perags still using the radix tree and rtgroups
using the xarray?  Yes, we should move the perags to use the xarray too
(and indeed hch already has a series on list to do that) but here's
really not the time to do that because I don't want to frontload a bunch
more core changes onto this already huge patchset.

> > +
> > +/* Compute the number of rt extents in this realtime group. */
> > +xfs_rtxnum_t
> > +xfs_rtgroup_extents(
> +	struct xfs_mount	*mp,
> > +	xfs_rgnumber_t		rgno)
> > +{
> > +	xfs_rgnumber_t		rgcount = mp->m_sb.sb_rgcount;
> > +
> > +	ASSERT(rgno < rgcount);
> > +	if (rgno == rgcount - 1)
> > +		return mp->m_sb.sb_rextents -
> > +			((xfs_rtxnum_t)rgno * mp->m_sb.sb_rgextents);
> 
> Urk. So this relies on a non-rtgroup filesystem doing a
> multiplication by zero of a field that the on-disk format does not
> understand to get the right result.  I think this is a copying a bad
> pattern we've been slowly trying to remove from the normal
> allocation group code.
> 
> > +
> > +	ASSERT(xfs_has_rtgroups(mp));
> > +	return mp->m_sb.sb_rgextents;
> > +}
> 
> We already embed the length of the rtgroup in the rtgroup structure.
> THis should be looking up the rtgroup (or being passed the rtgroup
> the caller already has) and doing the right thing. i.e.
> 
> 	if (!rtg || !xfs_has_rtgroups(rtg->rtg_mount))
> 		return mp->m_sb.sb_rextents;
> 	return rtg->rtg_extents;

xfs_rtgroup_extents is the function that we use to set rtg->rtg_extents.

> > diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> > new file mode 100644
> > index 0000000000000..2c09ecfc50328
> > --- /dev/null
> > +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> > @@ -0,0 +1,212 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +/*
> > + * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
> > + * Author: Darrick J. Wong <djwong@kernel.org>
> > + */
> > +#ifndef __LIBXFS_RTGROUP_H
> > +#define __LIBXFS_RTGROUP_H 1
> > +
> > +struct xfs_mount;
> > +struct xfs_trans;
> > +
> > +/*
> > + * Realtime group incore structure, similar to the per-AG structure.
> > + */
> > +struct xfs_rtgroup {
> > +	struct xfs_mount	*rtg_mount;
> > +	xfs_rgnumber_t		rtg_rgno;
> > +	atomic_t		rtg_ref;	/* passive reference count */
> > +	atomic_t		rtg_active_ref;	/* active reference count */
> > +	wait_queue_head_t	rtg_active_wq;/* woken active_ref falls to zero */
> 
> Yeah, that's all common with xfs_perag....
> 
> ....
> > +/*
> > + * rt group iteration APIs
> > + */
> > +static inline struct xfs_rtgroup *
> > +xfs_rtgroup_next(
> > +	struct xfs_rtgroup	*rtg,
> > +	xfs_rgnumber_t		*rgno,
> > +	xfs_rgnumber_t		end_rgno)
> > +{
> > +	struct xfs_mount	*mp = rtg->rtg_mount;
> > +
> > +	*rgno = rtg->rtg_rgno + 1;
> > +	xfs_rtgroup_rele(rtg);
> > +	if (*rgno > end_rgno)
> > +		return NULL;
> > +	return xfs_rtgroup_grab(mp, *rgno);
> > +}
> > +
> > +#define for_each_rtgroup_range(mp, rgno, end_rgno, rtg) \
> > +	for ((rtg) = xfs_rtgroup_grab((mp), (rgno)); \
> > +		(rtg) != NULL; \
> > +		(rtg) = xfs_rtgroup_next((rtg), &(rgno), (end_rgno)))
> > +
> > +#define for_each_rtgroup_from(mp, rgno, rtg) \
> > +	for_each_rtgroup_range((mp), (rgno), (mp)->m_sb.sb_rgcount - 1, (rtg))
> > +
> > +
> > +#define for_each_rtgroup(mp, rgno, rtg) \
> > +	(rgno) = 0; \
> > +	for_each_rtgroup_from((mp), (rgno), (rtg))
> 
> Yup, that's all common with xfs_perag iteration, too. Can you put
> together a patchset to unify these, please?

Here's the first part of that, to convert perags to xarrays...
https://lore.kernel.org/linux-xfs/20240821063901.650776-1-hch@lst.de/

> > +static inline bool
> > +xfs_verify_rgbno(
> > +	struct xfs_rtgroup	*rtg,
> > +	xfs_rgblock_t		rgbno)
> 
> Ok, what's the difference between and xfs_rgblock_t and a "rtx"?
> 
> OH.... Then penny just dropped - it's another "single letter
> difference that's really, really hard to spot" problem. You've
> defined "xfs_r*g*block_t" for the like a a*g*bno, but we have
> xfs_r*t*block_t for the global 64bit block number instead of a
> xfs_fsbno_t.
> 
> We just had a bug caused by exactly this sort of confusion with a
> patch that mixed xfs_[f]inobt changes together and one of the
> conversions was incorrect. Nobody spotted the single incorrect
> letter in the bigger patch, and I can see -exactly- the same sort of
> confusion happening with rtblock vs rgblock causing implicit 32/64
> bit integer promotion bugs...
> 
> > +{
> > +	struct xfs_mount	*mp = rtg->rtg_mount;
> > +
> > +	if (rgbno >= rtg->rtg_extents * mp->m_sb.sb_rextsize)
> > +		return false;
> 
> Why isn't the max valid "rgbno" stored in the rtgroup instead of
> having to multiply the extent count by extent size every time we
> have to verify a rgbno? (i.e. same as pag->block_count).
> 
> We know from the agbno verification this will be a -very- hot path,
> and so precalculating all the constants and storing them in the rtg
> should be done right from the start here.
> 
> > +	if (xfs_has_rtsb(mp) && rtg->rtg_rgno == 0 &&
> > +	    rgbno < mp->m_sb.sb_rextsize)
> > +		return false;
> 
> Same here - this value is stored in pag->min_block...
> 
> > +	return true;
> > +}
> 
> And then, if we put the max_bno and min_bno in the generic
> "xfs_group" structure, we suddenly have a generic "group bno"
> verification mechanism that is independent of whether the group
> 
> static inline bool
> xfs_verify_gbno(
>      struct xfs_group      *g,
>      xfs_gblock_t         gbno)
> {
>      struct xfs_mount        *mp = g->g_mount;
> 
>      if (gbno >= g->block_count)
>              return false;
>      if (gbno < g->min_block)
>              return false;
>      return true;
> }
> 
> And the rest of these functions fall out the same way....
> 
> 
> > +static inline xfs_rtblock_t
> > +xfs_rgno_start_rtb(
> > +	struct xfs_mount	*mp,
> > +	xfs_rgnumber_t		rgno)
> > +{
> > +	if (mp->m_rgblklog >= 0)
> > +		return ((xfs_rtblock_t)rgno << mp->m_rgblklog);
> > +	return ((xfs_rtblock_t)rgno * mp->m_rgblocks);
> > +}
> 
> Where does mp->m_rgblklog come from? That wasn't added to the
> on-disk superblock structure and it is always initialised to zero
> in this patch.
> 
> When will m_rgblklog be zero and when will it be non-zero? If it's

As I mentioned before, this patch merely ports non-rtg filesystems to
use the rtgroup structure.  m_rgblklog will be set to nonzero values
when we get to defining the ondisk rtgroup structure.

But, to cut ahead here, m_rgblklog will be set to a non-negative value
if the rtgroup size (in blocks) is a power of two.  Then these unit
conversion functions can use shifts instead of expensive multiplication
and divisions.  The same goes for rt extent to {fs,rt}block conversions.

> only going to be zero for existing non-rtg realtime systems,
> then this code makes little sense (again, relying on multiplication
> by zero to get the right result). If it's not always used for
> rtg enabled filesytsems, then the reason for that has not been
> explained and I can't work out why this would ever need to be done.

https://lore.kernel.org/linux-xfs/172437088534.60592.14072619855969226822.stgit@frogsfrogsfrogs/

> 
> > +static inline xfs_rtblock_t
> > +xfs_rgbno_to_rtb(
> > +	struct xfs_mount	*mp,
> > +	xfs_rgnumber_t		rgno,
> > +	xfs_rgblock_t		rgbno)
> > +{
> > +	return xfs_rgno_start_rtb(mp, rgno) + rgbno;
> > +}
> > +
> > +static inline xfs_rgnumber_t
> > +xfs_rtb_to_rgno(
> > +	struct xfs_mount	*mp,
> > +	xfs_rtblock_t		rtbno)
> > +{
> > +	if (!xfs_has_rtgroups(mp))
> > +		return 0;
> > +
> > +	if (mp->m_rgblklog >= 0)
> > +		return rtbno >> mp->m_rgblklog;
> > +
> > +	return div_u64(rtbno, mp->m_rgblocks);
> > +}
> 
> Ah, now I'm really confused, because m_rgblklog is completely
> bypassed for legacy rt filesystems.
> 
> And I just realised, this "if (mp->m_rgblklog >= 0)" implies that
> m_rgblklog can have negative values and there's no comments anywhere
> about why that can happen and what would trigger it. 

-1 is the magic value for "the rtgroup size is not a power of two, so
you have to use slow integer division and multiplication".

> We validate sb_agblklog during the superblock verifier, and so once
> the filesystem is mounted we never, ever need to check whether
> sb_agblklog is in range. Why is the rtblklog being handled so
> differently here?

This all could be documented better across the patches.  Originally the
incore and ondisk patches were adjacent and it was at least somewhat
easier to figure these things out, but hch really wanted to shard the
rtbitmaps, so now the patchset has grown even larger and harder to
understand if you only read one patch at a time.

> > +
> > +static inline uint64_t
> > +__xfs_rtb_to_rgbno(
> > +	struct xfs_mount	*mp,
> > +	xfs_rtblock_t		rtbno)
> > +{
> > +	uint32_t		rem;
> > +
> > +	if (!xfs_has_rtgroups(mp))
> > +		return rtbno;
> > +
> > +	if (mp->m_rgblklog >= 0)
> > +		return rtbno & mp->m_rgblkmask;
> > +
> > +	div_u64_rem(rtbno, mp->m_rgblocks, &rem);
> > +	return rem;
> > +}
> 
> Why is this function returning a uint64_t - a xfs_rgblock_t is only
> a 32 bit type...

group 0 on a !rtg filesystem can be 64-bits in block/rt count.  This is
a /very/ annoying pain point -- if you actually created such a
filesystem it actually would never work because the rtsummary file would
be created undersized due to an integer overflow, but the verifiers
never checked any of that, and due to the same underflow the rtallocator
would search the wrong places and (eventually) fall back to a dumb
linear scan.

Soooooo this is an obnoxious usecase (broken large !rtg filesystems)
that we can't just drop, though I'm pretty sure there aren't any systems
in the wild.

> > +
> > +static inline xfs_rgblock_t
> > +xfs_rtb_to_rgbno(
> > +	struct xfs_mount	*mp,
> > +	xfs_rtblock_t		rtbno)
> > +{
> > +	return __xfs_rtb_to_rgbno(mp, rtbno);
> > +}
> > +
> > +static inline xfs_daddr_t
> > +xfs_rtb_to_daddr(
> > +	struct xfs_mount	*mp,
> > +	xfs_rtblock_t		rtbno)
> > +{
> > +	return rtbno << mp->m_blkbb_log;
> > +}
> > +
> > +static inline xfs_rtblock_t
> > +xfs_daddr_to_rtb(
> > +	struct xfs_mount	*mp,
> > +	xfs_daddr_t		daddr)
> > +{
> > +	return daddr >> mp->m_blkbb_log;
> > +}
> 
> Ah. This code doesn't sparsify the xfs_rtblock_t address space for
> rtgroups. xfs_rtblock_t is still direct physical encoding of the
> location on disk.

Yes.

> I really think that needs to be changed to match how xfs_fsbno_t is
> a sparse encoding before these changes get merged. It shouldn't
> affect any of the other code in the patch set - the existing rt code
> has a rtgno of 0, so it will always be a direct physical encoding
> even when using a sparse xfs_rtblock_t address space.
> 
> All that moving to a sparse encoding means is that the addresses
> stored in the BMBT are logical addresses rather than physical
> addresses.  It should not affect any of the other code, just what
> ends up stored on disk for global 64-bit rt extent addresses...
> 
> In doing this, I think we can greatly simply all this group
> management stuff as most of the verification, type conversion and
> iteration infrastructure can then be shared between the exist perag
> and the new rtg infrastructure....
> 
> > diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> > index a8cd44d03ef64..1ce4b9eb16f47 100644
> > --- a/fs/xfs/libxfs/xfs_types.h
> > +++ b/fs/xfs/libxfs/xfs_types.h
> > @@ -9,10 +9,12 @@
> >  typedef uint32_t	prid_t;		/* project ID */
> >  
> >  typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
> > +typedef uint32_t	xfs_rgblock_t;	/* blockno in realtime group */
> 
> Is that right? The rtg length is 2^32 * rtextsize, and rtextsize can
> be 2^20 bytes:
> 
> #define XFS_MAX_RTEXTSIZE (1024 * 1024 * 1024)

No, the maximum rtgroup length is 2^32-1 blocks.

> Hence for a 4kB fsbno filesystem, the actual maximum size of an rtg
> in filesystem blocks far exceeds what we can address with a 32 bit
> variable.
> 
> If xfs_rgblock_t is actually indexing multi-fsbno rtextents, then it
> is an extent number index, not a "block" index. An extent number
> index won't overflow 32 bits (because the rtg has a max of 2^32 - 1
> rtextents)
> 
> IOWs, shouldn't this be named soemthing like:
> 
> typedef uint32_t	xfs_rgext_t;	/* extent number in realtime group */

and again, we can't do that because we emulate !rtg filesystems with a
single "rtgroup" that can be more than 2^32 rtx long.

> >  typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
> >  typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
> >  typedef uint32_t	xfs_rtxlen_t;	/* file extent length in rtextents */
> >  typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
> > +typedef uint32_t	xfs_rgnumber_t;	/* realtime group number */
> >  typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
> >  typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
> >  typedef int64_t		xfs_fsize_t;	/* bytes in a file */
> > @@ -53,7 +55,9 @@ typedef void *		xfs_failaddr_t;
> >  #define	NULLFILEOFF	((xfs_fileoff_t)-1)
> >  
> >  #define	NULLAGBLOCK	((xfs_agblock_t)-1)
> > +#define NULLRGBLOCK	((xfs_rgblock_t)-1)
> >  #define	NULLAGNUMBER	((xfs_agnumber_t)-1)
> > +#define	NULLRGNUMBER	((xfs_rgnumber_t)-1)
> 
> What's the maximum valid rtg number? We're not ever going to be
> supporting 2^32 - 2 rtgs, so what is a realistic maximum we can cap
> this at and validate it at?

/me shrugs -- the smallest AG size on the data device is 16M, which
technically speaking means that one /could/ format 2^(63-24) groups,
or order 39.

Realistically with the maximum rtgroup size of 2^31 blocks, we probably
only need 2^(63 - (31 + 10)) = 2^22 rtgroups max on a 1k fsblock fs.

> >  #define NULLCOMMITLSN	((xfs_lsn_t)-1)
> >  
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 4423dd344239b..c627cde3bb1e0 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -28,6 +28,7 @@
> >  #include "xfs_ag.h"
> >  #include "xfs_quota.h"
> >  #include "xfs_reflink.h"
> > +#include "xfs_rtgroup.h"
> >  
> >  #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
> >  
> > @@ -3346,6 +3347,7 @@ xlog_do_recover(
> >  	struct xfs_mount	*mp = log->l_mp;
> >  	struct xfs_buf		*bp = mp->m_sb_bp;
> >  	struct xfs_sb		*sbp = &mp->m_sb;
> > +	xfs_rgnumber_t		old_rgcount = sbp->sb_rgcount;
> >  	int			error;
> >  
> >  	trace_xfs_log_recover(log, head_blk, tail_blk);
> > @@ -3399,6 +3401,24 @@ xlog_do_recover(
> >  		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
> >  		return error;
> >  	}
> > +
> > +	if (sbp->sb_rgcount < old_rgcount) {
> > +		xfs_warn(mp, "rgcount shrink not supported");
> > +		return -EINVAL;
> > +	}
> > +	if (sbp->sb_rgcount > old_rgcount) {
> > +		xfs_rgnumber_t		rgno;
> > +
> > +		for (rgno = old_rgcount; rgno < sbp->sb_rgcount; rgno++) {
> > +			error = xfs_rtgroup_alloc(mp, rgno);
> > +			if (error) {
> > +				xfs_warn(mp,
> > +	"Failed post-recovery rtgroup init: %d",
> > +						error);
> > +				return error;
> > +			}
> > +		}
> > +	}
> 
> Please factor this out into a separate function with all the other
> rtgroup init/teardown code. That means we don't have to care about
> how rtgrowfs functions in recovery code, similar to the
> xfs_initialize_perag() already in this function for handling
> recovery of data device growing...
> 
> >  	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
> >  
> >  	/* Normal transactions can now occur */
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index b0ea88acdb618..e1e849101cdd4 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -36,6 +36,7 @@
> >  #include "xfs_ag.h"
> >  #include "xfs_rtbitmap.h"
> >  #include "xfs_metafile.h"
> > +#include "xfs_rtgroup.h"
> >  #include "scrub/stats.h"
> >  
> >  static DEFINE_MUTEX(xfs_uuid_table_mutex);
> > @@ -664,6 +665,7 @@ xfs_mountfs(
> >  	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> >  	uint			quotamount = 0;
> >  	uint			quotaflags = 0;
> > +	xfs_rgnumber_t		rgno;
> >  	int			error = 0;
> >  
> >  	xfs_sb_mount_common(mp, sbp);
> > @@ -830,10 +832,18 @@ xfs_mountfs(
> >  		goto out_free_dir;
> >  	}
> >  
> > +	for (rgno = 0; rgno < mp->m_sb.sb_rgcount; rgno++) {
> > +		error = xfs_rtgroup_alloc(mp, rgno);
> > +		if (error) {
> > +			xfs_warn(mp, "Failed rtgroup init: %d", error);
> > +			goto out_free_rtgroup;
> > +		}
> > +	}
> 
> Same - factor this to a xfs_rtgroup_init() function located with the
> rest of the rtgroup infrastructure...
> 
> > +
> >  	if (XFS_IS_CORRUPT(mp, !sbp->sb_logblocks)) {
> >  		xfs_warn(mp, "no log defined");
> >  		error = -EFSCORRUPTED;
> > -		goto out_free_perag;
> > +		goto out_free_rtgroup;
> >  	}
> >  
> >  	error = xfs_inodegc_register_shrinker(mp);
> > @@ -1068,7 +1078,8 @@ xfs_mountfs(
> >  	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
> >  		xfs_buftarg_drain(mp->m_logdev_targp);
> >  	xfs_buftarg_drain(mp->m_ddev_targp);
> > - out_free_perag:
> > + out_free_rtgroup:
> > +	xfs_free_rtgroups(mp, rgno);
> >  	xfs_free_perag(mp);
> >   out_free_dir:
> >  	xfs_da_unmount(mp);
> > @@ -1152,6 +1163,7 @@ xfs_unmountfs(
> >  	xfs_errortag_clearall(mp);
> >  #endif
> >  	shrinker_free(mp->m_inodegc_shrinker);
> > +	xfs_free_rtgroups(mp, mp->m_sb.sb_rgcount);
> 
> ... like you've already for the cleanup side ;)
> 
> ....
> 
> > @@ -1166,6 +1169,9 @@ xfs_rtmount_inodes(
> >  	if (error)
> >  		goto out_rele_summary;
> >  
> > +	for_each_rtgroup(mp, rgno, rtg)
> > +		rtg->rtg_extents = xfs_rtgroup_extents(mp, rtg->rtg_rgno);
> > +
> 
> This also needs to be done after recovery has initialised new rtgs
> as a result fo replaying a sb growfs modification, right?
> 
> Which leads to the next question: if there are thousands of rtgs,
> this requires walking every rtg at mount time, right? We know that
> walking thousands of static structures at mount time is a
> scalability issue, so can we please avoid this if at all possible?
> i.e. do demand loading of per-rtg metadata when it is first required
> (like we do with agf/agi information) rather than doing it all at
> mount time...

Sounds like a reasonable optimization patch...

--D

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
