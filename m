Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D12C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 12:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05821613F5
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 12:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbhDVMmh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Apr 2021 08:42:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235791AbhDVMmh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Apr 2021 08:42:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619095322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ovw/2m/wLtyhjGEu0MdAquXKfEdw03shckt0fuWG4tg=;
        b=QvPXfmgG87oVEzYCgy17oEqpXamCA0lXvbtjYImnSpsUUh/mSHh4/qGgoOLAvIM49vHeUr
        1w1cySX/KNJqf6MHxo1ks58+LeB+0CLRVx7zQO1bqTbLi20pC8M3+sxbwjZkUWyUW61MYB
        j/hZyLhopPtQB8YjgLaDeUrUZS2RYxM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-Uih4s9mgMLGXMUUXR3aUhw-1; Thu, 22 Apr 2021 08:42:00 -0400
X-MC-Unique: Uih4s9mgMLGXMUUXR3aUhw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF81B343A0;
        Thu, 22 Apr 2021 12:41:59 +0000 (UTC)
Received: from bfoster (ovpn-112-25.rdu2.redhat.com [10.10.112.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 593985D9C6;
        Thu, 22 Apr 2021 12:41:59 +0000 (UTC)
Date:   Thu, 22 Apr 2021 08:41:57 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 2/2] xfs: set aside allocation btree blocks from block
 reservation
Message-ID: <YIFvFRqivOKI+g6Q@bfoster>
References: <20210412133059.1186634-1-bfoster@redhat.com>
 <20210412133059.1186634-3-bfoster@redhat.com>
 <20210414010018.GX3957620@magnolia>
 <YH8AREVEgNThztFf@bfoster>
 <20210421234031.GT3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421234031.GT3122264@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 21, 2021 at 04:40:31PM -0700, Darrick J. Wong wrote:
> On Tue, Apr 20, 2021 at 12:24:36PM -0400, Brian Foster wrote:
> > On Tue, Apr 13, 2021 at 06:00:18PM -0700, Darrick J. Wong wrote:
> > > On Mon, Apr 12, 2021 at 09:30:59AM -0400, Brian Foster wrote:
> > > > The blocks used for allocation btrees (bnobt and countbt) are
> > > > technically considered free space. This is because as free space is
> > > > used, allocbt blocks are removed and naturally become available for
> > > > traditional allocation. However, this means that a significant
> > > > portion of free space may consist of in-use btree blocks if free
> > > > space is severely fragmented.
> > > > 
> > > > On large filesystems with large perag reservations, this can lead to
> > > > a rare but nasty condition where a significant amount of physical
> > > > free space is available, but the majority of actual usable blocks
> > > > consist of in-use allocbt blocks. We have a record of a (~12TB, 32
> > > > AG) filesystem with multiple AGs in a state with ~2.5GB or so free
> > > > blocks tracked across ~300 total allocbt blocks, but effectively at
> > > > 100% full because the the free space is entirely consumed by
> > > > refcountbt perag reservation.
> > > > 
> > > > Such a large perag reservation is by design on large filesystems.
> > > > The problem is that because the free space is so fragmented, this AG
> > > > contributes the 300 or so allocbt blocks to the global counters as
> > > > free space. If this pattern repeats across enough AGs, the
> > > > filesystem lands in a state where global block reservation can
> > > > outrun physical block availability. For example, a streaming
> > > > buffered write on the affected filesystem continues to allow delayed
> > > > allocation beyond the point where writeback starts to fail due to
> > > > physical block allocation failures. The expected behavior is for the
> > > > delalloc block reservation to fail gracefully with -ENOSPC before
> > > > physical block allocation failure is a possibility.
> > > > 
> > > > To address this problem, introduce an in-core counter to track the
> > > > sum of all allocbt blocks in use by the filesystem. Use the new
> > > > counter to set these blocks aside at reservation time and thus
> > > > ensure they cannot be reserved until truly available. Since this is
> > > > only necessary when perag reservations are active and the counter
> > > > requires a read of each AGF to fully populate, only enforce on perag
> > > > res enabled filesystems. This allows initialization of the counter
> > > > at ->pagf_init time because the perag reservation init code reads
> > > > each AGF at mount time.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_alloc.c       | 12 ++++++++++++
> > > >  fs/xfs/libxfs/xfs_alloc_btree.c |  2 ++
> > > >  fs/xfs/xfs_mount.c              | 18 +++++++++++++++++-
> > > >  fs/xfs/xfs_mount.h              |  6 ++++++
> > > >  4 files changed, 37 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > > index aaa19101bb2a..144e2d68245c 100644
> > > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > > @@ -3036,6 +3036,7 @@ xfs_alloc_read_agf(
> > > >  	struct xfs_agf		*agf;		/* ag freelist header */
> > > >  	struct xfs_perag	*pag;		/* per allocation group data */
> > > >  	int			error;
> > > > +	uint32_t		allocbt_blks;
> > > >  
> > > >  	trace_xfs_alloc_read_agf(mp, agno);
> > > >  
> > > > @@ -3066,6 +3067,17 @@ xfs_alloc_read_agf(
> > > >  		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
> > > >  		pag->pagf_init = 1;
> > > >  		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
> > > > +
> > > > +		/*
> > > > +		 * Update the global in-core allocbt block counter. Filter
> > > > +		 * rmapbt blocks from the on-disk counter because those are
> > > > +		 * managed by perag reservation.
> > > > +		 */
> > > > +		if (pag->pagf_btreeblks > be32_to_cpu(agf->agf_rmap_blocks)) {
> > > > +			allocbt_blks = pag->pagf_btreeblks -
> > > > +					be32_to_cpu(agf->agf_rmap_blocks);
> > > > +			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
> > > 
> > > This part is still bothering me.  The bug you're trying to fix is an
> > > oversight in the per-AG reservation code where I forgot to account for
> > > the fact that freespace btree blocks referencing reserved free space are
> > > themselves not available for allocation, and are thus reserved.
> > > 
> > 
> > Sort of. These blocks are not available for allocation, but they are
> > actually in use while still being accounted as free space. They are not
> > held as "reserved" at any point in the manner a perag reservation (or
> > delalloc extent) is.
> > 
> > FWIW, I don't necessarily consider this an oversight of perag
> > reservation as much as that the perag reservation can expose a problem
> > with in-use allocbt blocks being accounted as free blocks. It allows the
> > user to create conditions where the majority of unreserved && free
> > fdblocks are actually in-use allocbt blocks. The allocbt block
> > accounting is by design, however, because these blocks naturally become
> > available as extents are freed. This is essentially the gap that this
> > patch tries to close.. to preserve the higher level allocbt block
> > accounting (i.e.  remaining as free from the user perspective) without
> > allowing them to be incorrectly reserved.
> 
> <nod> That part I agree with...
> 
> > > xfs_ag_resv_init already has all the data it needs to know if we
> > > actually made a reservation, and xfs_ag_resv.c is where we put all the
> > > knowledge around how incore space reservations work.  This code adjusts
> > > an incore space reservation count, so why isn't it in xfs_ag_resv_init?
> > > 
> > 
> > ->m_allocbt_blks is just a straight counter for in-use allocbt blocks.
> > It's not a reservation of any kind. The code above simply adjusts the
> > counter based on allocbt modifications. The policy side of things is the
> > change to xfs_mod_fdblocks() that factors the allocbt count into the
> > blocks actually available for a given block reservation attempt. Based
> > on that, I'm not sure why the code would live in xfs_ag_resv_init()..?
> > I'm also not totally clear on whether you're asking about physical code
> > location vs. about a potential alternative implementation.
> 
> Just physical code location; see below.
> 
> > FWIW, I did think a little bit about using a perag reservation for
> > allocbt blocks earlier on, but IIRC it looked overcomplicated and I
> > didn't want to get into potentially changing how allocbt blocks are
> > accounted for what amounts to a corner case. If you had something else
> > in mind, can you please elaborate?
> 
> ...I really only meant to suggest moving the part that reads the AGF and
> adds (btreeblks - rmapblocks) to mp->m_alloc_blks to xfs_ag_resv_init,
> not a total redesign of the whole patch.
> 

Ok..

> > > I also think that not giving back the m_allocbt_blks diversion when we
> > > tear down the incore reservation is leaving a logic bomb for someone to
> > > trip over in the future.  I can't tell if omitting that actually results
> > > in a difference in behavior, but it still doesn't smell right...
> > > 
> > 
> > As above, ->m_allocbt_blks is just a counter. That's why it is modified
> > unconditionally. It just represents an in-core sum of what is tracked in
> > the AGF headers. The flag from patch 1 primarily exists to indicate that
> > the counter has been fully initialized by virtue of reading in all AGF
> > headers at mount time (which in turn only happens when we have a perag
> > res). I'm not sure it makes sense to artificially reset either (though
> > I think it's debatable whether the mp flag is required).
> > 
> > Brian
> 
> Something like this, maybe?
> 
> --D
> 
>  fs/xfs/libxfs/xfs_ag_resv.c     |   50 ++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_alloc_btree.c |    2 ++
>  fs/xfs/xfs_mount.c              |   18 +++++++++++++-
>  fs/xfs/xfs_mount.h              |    6 +++++
>  4 files changed, 74 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index 2bb1fdf9b349..8aa6b3d3276f 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -159,6 +159,41 @@ __xfs_ag_resv_free(
>  	return error;
>  }
>  
> +/* Hide freespace btree blocks that might be used to hold reserved blocks. */
> +static inline int
> +xfs_ag_resv_hide_allocbt_blocks(
> +	struct xfs_perag	*pag,
> +	struct xfs_trans	*tp,
> +	bool			setup)
> +{
> +	struct xfs_mount	*mp = pag->pag_mount;
> +	xfs_agnumber_t		agno = pag->pag_agno;
> +	struct xfs_buf		*agf_bp;
> +	struct xfs_agf		*agf;
> +	s64			delta;
> +	unsigned int		rmap_blocks;
> +	int			error;
> +
> +	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agf_bp);
> +	if (error)
> +		return error;
> +
> +	agf = agf_bp->b_addr;
> +	rmap_blocks = be32_to_cpu(agf->agf_rmap_blocks);
> +
> +	/*
> +	 * Update the global in-core allocbt block counter.  Filter rmapbt
> +	 * blocks from the on-disk counter because those are managed by perag
> +	 * reservation.
> +	 */
> +	delta = (s64)pag->pagf_btreeblks - rmap_blocks;
> +	if (delta > 0)
> +		atomic64_add(setup ? delta : -delta, &mp->m_allocbt_blks);
> +
> +	xfs_trans_brelse(tp, agf_bp);
> +	return 0;
> +}
> +

Hm, Ok. I don't see any technical or functional problem with doing
something like this, but this concerns me in that it sort of deviates
from the intent of ->m_allocbt_blks being pure mechanism. I.e., the act
of changing it is intended to be for the purpose of reflecting what is
on-disk, not necessarily to hide or unhide blocks. It has that effect
with this patch, but I don't see any reason to artificially prevent
something else from using the counter as such in the future. In fact if
we did do something like this, I'd probably want to at least rethink the
variable name to make it clear it's some kind of dynamic reservation as
opposed to an accounting mechanism.

With all of that in mind, the initialization is located in the perag
init code because that is clearly and explicitly implemented as a
(one-time) init of in-core counters related to the AGF. Technically that
behavior is similar to your patch to the ag_resv code, but that code
supports the ability to init/release reservation and so does introduce a
bit of an impedance mismatch. I also don't think we should ever modify
->m_allocbt_blks for any reason other than to initialize from what is
on-disk or track allocbt block allocs/frees, much for the same reason we
don't ever mutate ->m_fdblocks outside of the intended use case of
allocating/freeing blocks (this is also why I was using ->m_fdblocks as
a reference for your previous questions on how to deal with scrub). It's
not a reservation or policy of any kind, just a summarized counter of
preexisting per-ag accounting.

So all in all, this seems like unnecessary subsystem boundary crossing
to me. It also looks like about double the amount of code, fwiw. I
originally considered sending this as two patches but opted not to just
because the xfs_mod_fdblocks() change didn't seem worth an independent
patch. Based on this feedback, I'm thinking it might make more sense to
do that now. I might even split it into three if I can if for nothing
else but to more clearly document that the relationship to perag res is
actually quite tenuous (and thus is something we should probably remove
if we end up fixing the mount time full AG scan behavior as you and Dave
were discussing back on a previous version of this patch).

Brian

>  /* Free a per-AG reservation. */
>  int
>  xfs_ag_resv_free(
> @@ -167,6 +202,13 @@ xfs_ag_resv_free(
>  	int				error;
>  	int				err2;
>  
> +	if (xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_asked ||
> +	    xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_asked) {
> +		error = xfs_ag_resv_hide_allocbt_blocks(pag, NULL, false);
> +		if (error)
> +			return error;
> +	}
> +
>  	error = __xfs_ag_resv_free(pag, XFS_AG_RESV_RMAPBT);
>  	err2 = __xfs_ag_resv_free(pag, XFS_AG_RESV_METADATA);
>  	if (err2 && !error)
> @@ -322,8 +364,14 @@ xfs_ag_resv_init(
>  	       pag->pagf_freeblks + pag->pagf_flcount);
>  #endif
>  out:
> -	if (has_resv)
> +	if (has_resv) {
>  		mp->m_has_agresv = true;
> +		/* XXX probably shouldn't clobber error here */
> +		error = xfs_ag_resv_hide_allocbt_blocks(pag, tp, true);
> +		if (error)
> +			return error;
> +	}
> +
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 8e01231b308e..9f5a45f7baed 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -71,6 +71,7 @@ xfs_allocbt_alloc_block(
>  		return 0;
>  	}
>  
> +	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
>  	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agno, bno, 1, false);
>  
>  	xfs_trans_agbtree_delta(cur->bc_tp, 1);
> @@ -95,6 +96,7 @@ xfs_allocbt_free_block(
>  	if (error)
>  		return error;
>  
> +	atomic64_dec(&cur->bc_mp->m_allocbt_blks);
>  	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
>  			      XFS_EXTENT_BUSY_SKIP_DISCARD);
>  	xfs_trans_agbtree_delta(cur->bc_tp, -1);
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index cb1e2c4702c3..1f835c375a89 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1188,6 +1188,7 @@ xfs_mod_fdblocks(
>  	int64_t			lcounter;
>  	long long		res_used;
>  	s32			batch;
> +	uint64_t		set_aside;
>  
>  	if (delta > 0) {
>  		/*
> @@ -1227,8 +1228,23 @@ xfs_mod_fdblocks(
>  	else
>  		batch = XFS_FDBLOCKS_BATCH;
>  
> +	/*
> +	 * Set aside allocbt blocks because these blocks are tracked as free
> +	 * space but not available for allocation. Technically this means that a
> +	 * single reservation cannot consume all remaining free space, but the
> +	 * ratio of allocbt blocks to usable free blocks should be rather small.
> +	 * The tradeoff without this is that filesystems that maintain high
> +	 * perag block reservations can over reserve physical block availability
> +	 * and fail physical allocation, which leads to much more serious
> +	 * problems (i.e. transaction abort, pagecache discards, etc.) than
> +	 * slightly premature -ENOSPC.
> +	 */
> +	set_aside = mp->m_alloc_set_aside;
> +	if (mp->m_has_agresv)
> +		set_aside += atomic64_read(&mp->m_allocbt_blks);
> +
>  	percpu_counter_add_batch(&mp->m_fdblocks, delta, batch);
> -	if (__percpu_counter_compare(&mp->m_fdblocks, mp->m_alloc_set_aside,
> +	if (__percpu_counter_compare(&mp->m_fdblocks, set_aside,
>  				     XFS_FDBLOCKS_BATCH) >= 0) {
>  		/* we had space! */
>  		return 0;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 8847ffd29777..80b9f37f65e6 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -171,6 +171,12 @@ typedef struct xfs_mount {
>  	 * extents or anything related to the rt device.
>  	 */
>  	struct percpu_counter	m_delalloc_blks;
> +	/*
> +	 * Global count of allocation btree blocks in use across all AGs. Only
> +	 * used when perag reservation is enabled. Helps prevent block
> +	 * reservation from attempting to reserve allocation btree blocks.
> +	 */
> +	atomic64_t		m_allocbt_blks;
>  
>  	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
>  	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
> 

