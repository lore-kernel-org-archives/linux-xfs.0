Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3820DC433E4
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 15:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03FA16187E
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 15:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhCSPAl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 11:00:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39744 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230429AbhCSPAf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Mar 2021 11:00:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616166035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7QeO9iUqXIKe5giieHjMrrKzsyriKUPJvjcJgyy2tPU=;
        b=KLvuAvsQXeCxl4ewIosvarIN2RR8h8AiLm9Uc5tXitEk3fSdE4LExXIf+5AMKJ59AbTomE
        2JLZSrVBPVYqADz/u39T1JPMjVvNJbuBBdJAFEXST2VkvS1+A7BcvH5LiUqywpyRQxSu72
        BvHIxFbSFpcmCRYGYQOtIFj2TCNXQn0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-ybGtNLIsNYi4_JzbW76QRg-1; Fri, 19 Mar 2021 11:00:33 -0400
X-MC-Unique: ybGtNLIsNYi4_JzbW76QRg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54F6010866A5;
        Fri, 19 Mar 2021 15:00:32 +0000 (UTC)
Received: from bfoster (ovpn-112-98.rdu2.redhat.com [10.10.112.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB63E60CEB;
        Fri, 19 Mar 2021 15:00:31 +0000 (UTC)
Date:   Fri, 19 Mar 2021 11:00:29 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 2/2] xfs: set aside allocation btree blocks from block
 reservation
Message-ID: <YFS8jXreUd8TL2nn@bfoster>
References: <20210318161707.723742-1-bfoster@redhat.com>
 <20210318161707.723742-3-bfoster@redhat.com>
 <20210318203153.GM22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318203153.GM22100@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 18, 2021 at 01:31:53PM -0700, Darrick J. Wong wrote:
> On Thu, Mar 18, 2021 at 12:17:07PM -0400, Brian Foster wrote:
> > The blocks used for allocation btrees (bnobt and countbt) are
> > technically considered free space. This is because as free space is
> > used, allocbt blocks are removed and naturally become available for
> > traditional allocation. However, this means that a significant
> > portion of free space may consist of in-use btree blocks if free
> > space is severely fragmented.
> > 
> > On large filesystems with large perag reservations, this can lead to
> > a rare but nasty condition where a significant amount of physical
> > free space is available, but the majority of actual usable blocks
> > consist of in-use allocbt blocks. We have a record of a (~12TB, 32
> > AG) filesystem with multiple AGs in a state with ~2.5GB or so free
> > blocks tracked across ~300 total allocbt blocks, but effectively at
> > 100% full because the the free space is entirely consumed by
> > refcountbt perag reservation.
> > 
> > Such a large perag reservation is by design on large filesystems.
> > The problem is that because the free space is so fragmented, this AG
> > contributes the 300 or so allocbt blocks to the global counters as
> > free space. If this pattern repeats across enough AGs, the
> > filesystem lands in a state where global block reservation can
> > outrun physical block availability. For example, a streaming
> > buffered write on the affected filesystem continues to allow delayed
> > allocation beyond the point where writeback starts to fail due to
> > physical block allocation failures. The expected behavior is for the
> > delalloc block reservation to fail gracefully with -ENOSPC before
> > physical block allocation failure is a possibility.
> > 
> > To address this problem, introduce an in-core counter to track the
> > sum of all allocbt blocks in use by the filesystem. Use the new
> > counter to set these blocks aside at reservation time and thus
> > ensure they cannot be reserved until truly available. Since this is
> > only necessary when perag reservations are active and the counter
> > requires a read of each AGF to fully populate, only enforce on perag
> > res enabled filesystems. This allows initialization of the counter
> > at ->pagf_init time because the perag reservation init code reads
> > each AGF at mount time.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c       | 12 ++++++++++++
> >  fs/xfs/libxfs/xfs_alloc_btree.c |  2 ++
> >  fs/xfs/xfs_mount.c              | 18 +++++++++++++++++-
> >  fs/xfs/xfs_mount.h              |  6 ++++++
> >  4 files changed, 37 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 0c623d3c1036..9fa378d2724e 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -3036,6 +3036,7 @@ xfs_alloc_read_agf(
> >  	struct xfs_agf		*agf;		/* ag freelist header */
> >  	struct xfs_perag	*pag;		/* per allocation group data */
> >  	int			error;
> > +	uint32_t		allocbt_blks;
> >  
> >  	trace_xfs_alloc_read_agf(mp, agno);
> >  
> > @@ -3066,6 +3067,17 @@ xfs_alloc_read_agf(
> >  		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
> >  		pag->pagf_init = 1;
> >  		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
> > +
> > +		/*
> > +		 * Update the global in-core allocbt block counter. Filter
> > +		 * rmapbt blocks from the on-disk counter because those are
> > +		 * managed by perag reservation.
> > +		 */
> > +		if (pag->pagf_btreeblks > be32_to_cpu(agf->agf_rmap_blocks)) {
> > +			allocbt_blks = pag->pagf_btreeblks -
> > +					be32_to_cpu(agf->agf_rmap_blocks);
> > +			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
> 
> Does growfs call xfs_alloc_read_agf to set pagf_init in the perag
> structure when it adds AGs to the filesystem?  I don't /think/ that's
> a problem for this use case (since allocbt_blks should be 0 on a freshly
> initialized AG) but i was a little surprised to see block reservation
> bits here.
> 

I'm not sure it matters who reads AGFs as long as the global counter
remains consistent. For growing an existing AG, it looks like we "free"
the new space into the AG so I think that should be tracked accordingly
like any other alloc/free. For a new AG, it looks like ->agf_btreeblks
starts at 0 and then the perags would likely init through the perag res
call that runs as the final step before the growfs returns.

> The other thing is that online repair (what little of it is in the
> kernel currently) can set pagf_init = 0; is that a problem?
> 

Hmm.. if the AGF is corrupt, it seems likely that the in-core counter is
busted as well. We could do something like account the delta from pre
and post repair into the global counter, but I'd be weary of scenarios
where the AGF might have become inconsistent with the counter somehow
and the delta itself would throw it off. That might be unlikely, but
what scares me about that is we could actually break the global counter
by attempting to fix it so allocbt blocks become reservable again.

I'm not sure there's a great answer here. Perhaps the safest thing would
be to warn about an ->agf_btreeblks inconsistency that might result in
some number of "unusable" blocks until a mount cycle occurs and
resynchronizes the global counter..? That also seems to be consistent
with how we handle the superblock counters after an agf repair.

(All that said, I am somewhat hesitant to add to this unless we
determine the approach is still viable after the expected perag res
changes...).

Brian

> --D
> 
> > +		}
> >  	}
> >  #ifdef DEBUG
> >  	else if (!XFS_FORCED_SHUTDOWN(mp)) {
> > diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> > index 8e01231b308e..9f5a45f7baed 100644
> > --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> > @@ -71,6 +71,7 @@ xfs_allocbt_alloc_block(
> >  		return 0;
> >  	}
> >  
> > +	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
> >  	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agno, bno, 1, false);
> >  
> >  	xfs_trans_agbtree_delta(cur->bc_tp, 1);
> > @@ -95,6 +96,7 @@ xfs_allocbt_free_block(
> >  	if (error)
> >  		return error;
> >  
> > +	atomic64_dec(&cur->bc_mp->m_allocbt_blks);
> >  	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
> >  			      XFS_EXTENT_BUSY_SKIP_DISCARD);
> >  	xfs_trans_agbtree_delta(cur->bc_tp, -1);
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 1c97b155a8ee..29f97e909607 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -1176,6 +1176,7 @@ xfs_mod_fdblocks(
> >  	int64_t			lcounter;
> >  	long long		res_used;
> >  	s32			batch;
> > +	uint64_t		set_aside;
> >  
> >  	if (delta > 0) {
> >  		/*
> > @@ -1215,8 +1216,23 @@ xfs_mod_fdblocks(
> >  	else
> >  		batch = XFS_FDBLOCKS_BATCH;
> >  
> > +	/*
> > +	 * Set aside allocbt blocks because these blocks are tracked as free
> > +	 * space but not available for allocation. Technically this means that a
> > +	 * single reservation cannot consume all remaining free space, but the
> > +	 * ratio of allocbt blocks to usable free blocks should be rather small.
> > +	 * The tradeoff without this is that filesystems that maintain high
> > +	 * perag block reservations can over reserve physical block availability
> > +	 * and fail physical allocation, which leads to much more serious
> > +	 * problems (i.e. transaction abort, pagecache discards, etc.) than
> > +	 * slightly premature -ENOSPC.
> > +	 */
> > +	set_aside = mp->m_alloc_set_aside;
> > +	if (mp->m_has_agresv)
> > +		set_aside += atomic64_read(&mp->m_allocbt_blks);
> > +
> >  	percpu_counter_add_batch(&mp->m_fdblocks, delta, batch);
> > -	if (__percpu_counter_compare(&mp->m_fdblocks, mp->m_alloc_set_aside,
> > +	if (__percpu_counter_compare(&mp->m_fdblocks, set_aside,
> >  				     XFS_FDBLOCKS_BATCH) >= 0) {
> >  		/* we had space! */
> >  		return 0;
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index 489d9b2c53d9..041f437dc117 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -171,6 +171,12 @@ typedef struct xfs_mount {
> >  	 * extents or anything related to the rt device.
> >  	 */
> >  	struct percpu_counter	m_delalloc_blks;
> > +	/*
> > +	 * Global count of allocation btree blocks in use across all AGs. Only
> > +	 * used when perag reservation is enabled. Helps prevent block
> > +	 * reservation from attempting to reserve allocation btree blocks.
> > +	 */
> > +	atomic64_t		m_allocbt_blks;
> >  
> >  	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
> >  	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
> > -- 
> > 2.26.2
> > 
> 

