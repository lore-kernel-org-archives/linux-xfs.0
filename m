Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34652C433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Feb 2021 15:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC26964EAF
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Feb 2021 15:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhB1PUc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Feb 2021 10:20:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230499AbhB1PUZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Feb 2021 10:20:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614525537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U44m9JD0ZD9K8JzPrywU61p9UpMv/fAQpa9yuISWNp4=;
        b=IAnIgzhRljQI23oDqr5KHmT2kk5Hl9xzH+992BflDTwyuoEjz0QBQysoaklBph9YhJFZ9X
        f07oH7nKRKiqHxdDEkGIEEdEjIfCZrZyKr5124V7pE5uLlhhRYJ0B3pJS+HVru/suVRfnV
        zyo4knhIlXjBJWBQmfQB6NcinMWTHK8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-oYYAXxuaObeVkSYSrhFioQ-1; Sun, 28 Feb 2021 10:18:55 -0500
X-MC-Unique: oYYAXxuaObeVkSYSrhFioQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABE9E6D4E6;
        Sun, 28 Feb 2021 15:18:54 +0000 (UTC)
Received: from bfoster (ovpn-113-120.rdu2.redhat.com [10.10.113.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 36C3E5C1D5;
        Sun, 28 Feb 2021 15:18:54 +0000 (UTC)
Date:   Sun, 28 Feb 2021 10:18:52 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: set aside allocation btree blocks from block
 reservation
Message-ID: <YDu0XF4yGI5nKoKN@bfoster>
References: <20210222152108.896178-1-bfoster@redhat.com>
 <20210222183408.GB7272@magnolia>
 <20210223121017.GA946926@bfoster>
 <20210224181453.GP7272@magnolia>
 <YDfgsLyjXRwZI8JS@bfoster>
 <20210226190149.GC7272@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210226190149.GC7272@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 26, 2021 at 11:01:49AM -0800, Darrick J. Wong wrote:
> On Thu, Feb 25, 2021 at 12:38:56PM -0500, Brian Foster wrote:
> > On Wed, Feb 24, 2021 at 10:14:53AM -0800, Darrick J. Wong wrote:
> > > On Tue, Feb 23, 2021 at 07:10:17AM -0500, Brian Foster wrote:
> > > > On Mon, Feb 22, 2021 at 10:34:08AM -0800, Darrick J. Wong wrote:
> > > > > On Mon, Feb 22, 2021 at 10:21:08AM -0500, Brian Foster wrote:
> > > > > > The blocks used for allocation btrees (bnobt and countbt) are
> > > > > > technically considered free space. This is because as free space is
> > > > > > used, allocbt blocks are removed and naturally become available for
> > > > > > traditional allocation. However, this means that a significant
> > > > > > portion of free space may consist of in-use btree blocks if free
> > > > > > space is severely fragmented.
> > > > > > 
> > > > > > On large filesystems with large perag reservations, this can lead to
> > > > > > a rare but nasty condition where a significant amount of physical
> > > > > > free space is available, but the majority of actual usable blocks
> > > > > > consist of in-use allocbt blocks. We have a record of a (~12TB, 32
> > > > > > AG) filesystem with multiple AGs in a state with ~2.5GB or so free
> > > > > > blocks tracked across ~300 total allocbt blocks, but effectively at
> > > > > > 100% full because the the free space is entirely consumed by
> > > > > > refcountbt perag reservation.
> > > 
> > > Hmm.  I'm still a bit confused by what's going on here.  Free space is
> > > heavily fragmented and the bnobt/cntbt are very large, but what actually
> > > triggers the (bug? customer escalation?) report?  Did the fs go offline?
> > > Did fsync() suddenly start emitting errors?
> > > 
> > 
> > It's a very odd scenario.. The original bug report complains about a
> > shutdown in the xfs_btree_insert() code because of a record insertion
> > failure. This is a bmbt record insertion on COW I/O completion
> > (xfs_reflink_end_cow()) where we are remapping from the COW fork to the
> > data fork. I believe the user was beating this fs against -ENOSPC for
> 
> Heh, knowing some of my customers I bet I'll encounter this in 5..4...
> 

It's just a matter of time. :) FWIW, upping the global reserve block
pool (after freeing up a bit of space) seemed an effective workaround
for the particular case I investigated. That at least allowed the user
to run to -ENOSPC gracefully (why they want to do that, I still have no
idea.. :P).

...
> > > Ahh, ok.  I think I grok what this patch does now.  XFS (prior to per-ag
> > > space reservations) counts all the space used by the free space btrees
> > > as free space, which means that a delalloc reservation expects to be
> > > able to consume both the free space in the tree as well as the tree
> > > itself.
> > > 
> > > Now we use the free space btrees to hold space for future metadata
> > > expansions, so the expectation above no longer holds.  Hence subtracting
> > > agf_btreeblks from fdblocks at mount time.
> > > 
> > > With that in mind, the finobt and rmapbt reservations are no different
> > > from the refcountbt reservation -- the unused-but-reserved space for all
> > > three reservations are held in the free space btrees, so they all need
> > > this now.  The answer to my question is "yes, they need it too".
> > > 
> > 
> > Ok, that sounds reasonable.
> > 
> > > With that in mind, should xfs_ag_resv_init be responsible for
> > > subtracting agf_btreeblocks from fdblocks if there are any reservations?
> > > 
> > 
> > I'd have to think it through as the perag res code tends to confuse me,
> > but at a glance that sounds like a potential option. That said, what's
> > the advantage? Would that imply that subsequent runtime allocbt
> > allocations need also pass through xfs_mod_fdblocks()? I admit I'm a
> > little weary of fundamentally changing how blocks for core structures
> > like the allocbt are tracked, particularly for such an unlikely corner
> > case. For that reason, I do like the simplicity of the track and set
> > aside model...
> 
> I was thinking of something simpler than creating a new XFS_AG_RESV
> type, if that's what you were thinking.
> 

No, I was just thinking of adding this change in __xfs_ag_resv_init():

@@ -197,7 +197,7 @@ __xfs_ag_resv_init(
                 * subtract the entire reservation from fdblocks so that we
                 * always have blocks available for rmapbt expansion.
                 */
-               hidden_space = ask;
+               hidden_space = ask - used;
                break;
        case XFS_AG_RESV_METADATA:
                /*

... and then update the feature check in xfs_mod_fdblocks() to include
rmapbt.

FWIW, I was able to reproduce the double accounting issue on a
filesystem with many rmapbt entries. Thanks for catching that. The above
seems to avoid it (in a quick test with a large, prexisting rmapbt at
mount time at least).

> Now that we know that we have to subtract the free space btree blocks
> from fdblocks for any AG that has a reservation, I think it makes the
> most sense to wrap the m_btree_blks accounting code in xfs_ag_resv.c.
> 
> bool xfs_ag_has_resv(struct xfs_perag *pag)
> {
> 	return  pag->pag_meta_resv.ar_asked > 0 ||
> 		pag->pag_rmapbt_resv.ar_asked > 0;
> }
> 
> void xfs_ag_resv_allocbt_delta(struct xfs_perag *pag, s64 delta)
> {
> 	if (xfs_ag_has_resv(pag))
> 		atomic64_add(delta, &mp->m_btree_blks);
> }
> 
> And call that from xfs_allocbt_{alloc,free}_block.
> 

That looks reasonable to me. I'd probably open code the feature check in
the delta() helper just because having a has_resv() predicate that
doesn't technically cover all of the "has reservation" cases (i.e.
finobt) urks me a bit.

> Then move the initialization of m_btree_blks from the pagf_init code
> into xfs_ag_resv_init, because that function already knows whether or
> not we made reservations, and therefore how much to add to m_btree_blks.
> 
> 	/* Create the metadata reservation. */
> 	if (pag->pag_meta_resv.ar_asked == 0) {...}
> 
> 	/* Create the RMAPBT metadata reservation */
> 	if (pag->pag_rmapbt_resv.ar_asked == 0) {...}
> 
> 	/*
> 	 * Blocks reserved for metadata btree reservations are held in
> 	 * the free space btree, which effectively means that the free
> 	 * space btrees themselves become part of the reservation.  Add
> 	 * the size of /only/ the free space btrees to what we withhold
> 	 * from the fdblocks count that we present to userspace.  (We
> 	 * already reserved the space that the rmapbt wants.)
> 	 */
> 	if (xfs_ag_has_resv(pag)) {
> 		xfs_alloc_pagf_init(...);
> 
> 		allocbt_resv =  pag->pagf_btreeblks -
> 				pag->pag_rmapbt_resv.ar_asked;
> 
> 		atomic64_add(allocbt_resv, &mp->m_btree_blks);
> 	}
> 

I'm not following this part... So we've calculated and acquired the
reflink/rmapbt reservations at this point. This code subtracts the AG
rmapbt reservation calculation from the existing btree block count, then
adds that value to the btree block counter..? Hmm.. did you mean for
this to subtract .ar_used instead of .ar_asked..? If so, does this not
similarly double charge the rmapbt blocks that might be used after this
point (in fact I'm wondering the same thing about my tweak above)?

> > > > > > counter to set these blocks aside at reservation time and thus
> > > > > > ensure they cannot be allocated until truly available. Since this is
> > > > > > only necessary when large reflink perag reservations are in place
> > > > > > and the counter requires a read of each AGF to fully populate, only
> > > > > > enforce on reflink enabled filesystems. This allows initialization
> > > > > > of the counter at ->pagf_init time because the refcountbt perag
> > > > > > reservation init code reads each AGF at mount time.
> 
> By the way, should we be subtracting m_btree_blks from b_avail in
> statvfs?
> 

My understanding is that this space should continue to be presented as
free space (so I don't think so..?).

> > > > > > 
> > > > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > > ---
> > > > > > 
> > > > > > v2:
> > > > > > - Use an atomic counter instead of a percpu counter.
> > > > > > v1: https://lore.kernel.org/linux-xfs/20210217132339.651020-1-bfoster@redhat.com/
> > > > > > 
> > > > > >  fs/xfs/libxfs/xfs_alloc.c |  3 +++
> > > > > >  fs/xfs/xfs_mount.c        | 15 ++++++++++++++-
> > > > > >  fs/xfs/xfs_mount.h        |  6 ++++++
> > > > > >  3 files changed, 23 insertions(+), 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > > > > index 0c623d3c1036..fb3d36cad173 100644
> > > > > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > > > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > > > > @@ -2746,6 +2746,7 @@ xfs_alloc_get_freelist(
> > > > > >  	if (btreeblk) {
> > > > > >  		be32_add_cpu(&agf->agf_btreeblks, 1);
> > > > > >  		pag->pagf_btreeblks++;
> > > > > > +		atomic64_inc(&mp->m_btree_blks);
> > > > > >  		logflags |= XFS_AGF_BTREEBLKS;
> > > > > >  	}
> > > > > >  
> > > > > > @@ -2853,6 +2854,7 @@ xfs_alloc_put_freelist(
> > > > > >  	if (btreeblk) {
> > > > > >  		be32_add_cpu(&agf->agf_btreeblks, -1);
> > > > > >  		pag->pagf_btreeblks--;
> > > > > > +		atomic64_dec(&mp->m_btree_blks);
> > > > > >  		logflags |= XFS_AGF_BTREEBLKS;
> > > > > >  	}
> > > > > >  
> > > > > > @@ -3055,6 +3057,7 @@ xfs_alloc_read_agf(
> > > > > >  	if (!pag->pagf_init) {
> > > > > >  		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
> > > > > >  		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
> > > > > > +		atomic64_add(pag->pagf_btreeblks, &mp->m_btree_blks);
> > > 
> > > Come to think of it, this isn't quite correct -- rmapbt blocks are
> > > counted in agf_btreeblks and separately in agf_rmap_blocks.  At mount
> > > time, the rmapbt per-ag reservation subtracts the entire rmapbt
> > > reservation from fdblocks (not just agf_rmap_blocks), so this
> > > effectively double-charges fdblocks for the rmap btree.
> > > 
> > 
> > Not sure I follow.. this counter just tracks the sum of of
> > ->agf_btreeblks. I see what you mean that __xfs_ag_resv_init() doesn't
> > subtract the used value for XFS_AG_RESV_RMAPBT. So are you saying that
> > some portion of this total btree block counter includes
> > ->agf_rmap_blocks, those blocks have been already reserved, and
> > therefore should not be part of set_aside in xfs_mod_fdblocks()?
> 
> Yes.
> 
> > If so, I _think_ I follow, and I suspect that would require a separate
> > global counter to remove the rmap blocks from the set_aside bit. That
> > said, I am a little confused by the rmapbt reservation in this regard.
> > It sounds like it already double accounts at mount time by reserving
> > already used blocks.
> 
> It doesn't double count, because the blocks used by the rmapbt are (for
> better or worse) accounted on disk in exactly the same way as the free
> space btree blocks.  IOWs, the blocks used by the rmap btree are not
> subtracted from fdblocks.
> 

Ok.

> > If that is because those blocks are always shown as free (thus used
> > blocks are not actually double accounted), does that mean we could
> > drop the used portion of the mount time reservation by including the
> > used blocks in the set_aside value instead?
> 
> Er... I thought the set_aside value is static?
> 

Well it is currently. This patch adds ->m_free_blks to the current set
aside so it effectively becomes a dynamic value. IIUC, the purpose of
the "set aside" is not much to be static or not, but as a mechanism to
track/enforce reservation of blocks that are technically accounted as
free but not reservable. The allocbt blocks happen to be in that state
transiently, hence that portion of the calculation is dynamic.

Brian

> --D
> 
> > Brian
> > 
> > > --D
> > > 
> > > > > >  		pag->pagf_flcount = be32_to_cpu(agf->agf_flcount);
> > > > > >  		pag->pagf_longest = be32_to_cpu(agf->agf_longest);
> > > > > >  		pag->pagf_levels[XFS_BTNUM_BNOi] =
> > > > > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > > > > index 52370d0a3f43..16482e02da01 100644
> > > > > > --- a/fs/xfs/xfs_mount.c
> > > > > > +++ b/fs/xfs/xfs_mount.c
> > > > > > @@ -1178,6 +1178,7 @@ xfs_mod_fdblocks(
> > > > > >  	int64_t			lcounter;
> > > > > >  	long long		res_used;
> > > > > >  	s32			batch;
> > > > > > +	uint64_t		set_aside = mp->m_alloc_set_aside;
> > > > > >  
> > > > > >  	if (delta > 0) {
> > > > > >  		/*
> > > > > > @@ -1217,8 +1218,20 @@ xfs_mod_fdblocks(
> > > > > >  	else
> > > > > >  		batch = XFS_FDBLOCKS_BATCH;
> > > > > >  
> > > > > > +	/*
> > > > > > +	 * Set aside allocbt blocks on reflink filesystems because COW remaps
> > > > > > +	 * can dip into the reserved block pool. This is problematic if free
> > > > > > +	 * space is fragmented and m_fdblocks tracks a significant number of
> > > > > > +	 * allocbt blocks. Note this also ensures the counter is accurate before
> > > > > > +	 * the filesystem is active because perag reservation reads all AGFs at
> > > > > > +	 * mount time. The only call prior to that is to populate the reserve
> > > > > > +	 * pool itself.
> > > > > > +	 */
> > > > > > +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> > > > > > +		set_aside += atomic64_read(&mp->m_btree_blks);
> > > > > > +
> > > > > >  	percpu_counter_add_batch(&mp->m_fdblocks, delta, batch);
> > > > > > -	if (__percpu_counter_compare(&mp->m_fdblocks, mp->m_alloc_set_aside,
> > > > > > +	if (__percpu_counter_compare(&mp->m_fdblocks, set_aside,
> > > > > >  				     XFS_FDBLOCKS_BATCH) >= 0) {
> > > > > >  		/* we had space! */
> > > > > >  		return 0;
> > > > > > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > > > > > index 659ad95fe3e0..70e1dd6b538a 100644
> > > > > > --- a/fs/xfs/xfs_mount.h
> > > > > > +++ b/fs/xfs/xfs_mount.h
> > > > > > @@ -170,6 +170,12 @@ typedef struct xfs_mount {
> > > > > >  	 * extents or anything related to the rt device.
> > > > > >  	 */
> > > > > >  	struct percpu_counter	m_delalloc_blks;
> > > > > > +	/*
> > > > > > +	 * Optional count of btree blocks in use across all AGs. Only used when
> > > > > > +	 * reflink is enabled. Helps prevent block reservation from attempting
> > > > > > +	 * to reserve allocation btree blocks.
> > > > > > +	 */
> > > > > > +	atomic64_t		m_btree_blks;
> > > > > >  
> > > > > >  	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
> > > > > >  	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
> > > > > > -- 
> > > > > > 2.26.2
> > > > > > 
> > > > > 
> > > > 
> > > 
> > 
> 

