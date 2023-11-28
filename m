Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7000C44361
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 21:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bec43fKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6B4C433C8;
	Tue, 28 Nov 2023 21:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701206038;
	bh=WMsE3pJsXs+45E/gQH/p3334LfWKqEpOob+lcWfu60c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bec43fKpRsLje3lH2QArsPZ2Q/ZDgYeLQ9neNVD08MPB41wrp2RSMT28zUfpZ+EN0
	 S1reixSnsqMaxc+FAhagg59iOJjb7nv6h0oKbNL1bhTIBFvPgFYFvA8VPr1n+HbxXW
	 B0V43by5XbgtOJUdP+xscYKX3ynfJ29LZMmmAuQ33f5YLThg/siDDSeCgrlIZ+l270
	 JQF123Wco60H2ZCyDA7ONImQ8L9SYDOsJEBCuz+gE8QW/9szu8AiWng4nFD5QhKOlJ
	 +1a1bIIuTq6QjQ8xK/c8Qbegmg7RP0Q6d07CKLHVtYjPoPQ7xjF/buiuTJplpkqVWA
	 Vgv3lKq5LoAVw==
Date: Tue, 28 Nov 2023 13:13:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: repair free space btrees
Message-ID: <20231128211358.GB4167244@frogsfrogsfrogs>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
 <170086927042.2770967.1697193414262580501.stgit@frogsfrogsfrogs>
 <ZWYDASlIqLQvk9Wh@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZWYDASlIqLQvk9Wh@infradead.org>

On Tue, Nov 28, 2023 at 07:10:57AM -0800, Christoph Hellwig wrote:
> A highlevel question on how blocks are (re)used here.
> 
>  - xrep_abt_find_freespace accounts the old allocbt blocks as freespace
>    per the comment, although as far as I understand  the code in
>    xrep_abt_walk_rmap the allocbt blocks aren't actually added to the
>    free_records xfarray, but recorded into the old_allocbt_blocks
>    bitmap (btw, why are we using different data structures for them?)

The old free space btree blocks are tracked via old_allocbt_blocks so
that we can reap the space after committing the new btree roots.
Reaping cross-references the set regions in the bitmap against the
rmapbt records so that we don't free crosslinked blocks.

This is a big difference from xfs_repair, which constructs a free space
map by walking the directory / bmbt trees and builds completely new
indexes in the gaps.  It gets away with that because it's building
all the space metadata in the AG, not just the free space btrees.

The next question you might have is why there's old_allocbt_blocks and
not_allocbt_blocks -- this is due to us using the AGFL to supply the
bnobt, cntbt, and rmapbt's alloc_block routines.  Hence the blocks
tracked by all four data structures are all RMAP_OWN_AG, and we have to
do a bit of bitmap work to subtract the rmapbt and AGFL blocks from all
the OWN_AG records to end up with the blocks that we think are owned by
the free space btrees.

>  - xrep_abt_reserve_space seems to allocate space for the new alloc
>    btrees by popping the first entry of ->free_records until it has
>    enough space.

Correct.

>  - what happens if the AG is so full and fragmented that we do not
>    have space to create a second set of allocbts without tearing down
>    the old ones first?

xrep_abt_reserve_space returns -ENOSPC, so we throw away all the incore
records and throw the errno out to userspace.  Across all the btree
rebuilding code, the block reservation step happens as the very last
thing before we start writing btree blocks, so it's still possible to
back out cleanly.

> I've also got a whole bunch of nitpicks that mostly don't require an
> immediate action and/or about existing code that just grows more users
> here:

Heh.

> > +int
> > +xrep_allocbt(
> > +	struct xfs_scrub	*sc)
> > +{
> > +	struct xrep_abt		*ra;
> > +	struct xfs_mount	*mp = sc->mp;
> > +	char			*descr;
> > +	int			error;
> > +
> > +	/* We require the rmapbt to rebuild anything. */
> > +	if (!xfs_has_rmapbt(mp))
> > +		return -EOPNOTSUPP;
> 
> Shoudn't this be checked by the .has callback in struct xchk_meta_ops?

No.  Checking doesn't require the rmapbt because all we do is walk the
bnobt/cntbt records and cross-reference them with whatever metadata we
can find.

A stronger check would scan the AG to build a second recordset of the
free space and compare that against what's on disk.  However, that would
be much slower, and Dave wanted scans to be fast because corruptions are
supposed to be the edge case. :)

The weaker checking also means we can scrub old filesystems, even if we
still require xfs_repair to fix them.

> > +	/* Set up enough storage to handle maximally fragmented free space. */
> > +	descr = xchk_xfile_ag_descr(sc, "free space records");
> > +	error = xfarray_create(descr, mp->m_sb.sb_agblocks / 2,
> > +			sizeof(struct xfs_alloc_rec_incore),
> > +			&ra->free_records);
> > +	kfree(descr);
> 
> Commenting on a new user of old code here, but why doesn't
> xfarray_create simply take a format string so that we don't need the
> separate allocatiom and kasprintf here?

I didn't want to spend the brainpower to figure out how to make the
macro and va_args crud work to support pushing both from xrep_allocbt ->
xfarray_create -> xfile_create.  I don't know how to make that stuff
nest short of adding a kas- variant of xfile_create.

Seeing as we don't install xfiles into the file descriptor table anyway,
the labels are only visible via ftrace, and not procfs.  I decided that
cleanliness here wasn't a high enough priority.

> > +	/*
> > +	 * We must update sm_type temporarily so that the tree-to-tree cross
> > +	 * reference checks will work in the correct direction, and also so
> > +	 * that tracing will report correctly if there are more errors.
> > +	 */
> > +	sc->sm->sm_type = XFS_SCRUB_TYPE_BNOBT;
> > +	error = xchk_bnobt(sc);
> 
> So xchk_bnobt is a tiny wrapper around xchk_allocbt, which is a small
> wrapper around xchk_btree that basіally de-multiplex the argument
> pass in by xchk_bnobt again.  This is existing code not newly added,
> but the call chain looks a bit odd to me.

Yeah.  I suppose one way to clean that up would be to export
xchk_allocbt to the dispatch table in scrub.c instead of
xchk_{bno,cnt}bt and figure out which btree we want from sm_type.

Way back when I was designing scrub I thought that repair would be
separate for each btree type, but that turned out not to be the case.
Hence the awkwardness in the call chains.

> > +/*
> > + * Add an extent to the new btree reservation pool.  Callers are required to
> > + * reap this reservation manually if the repair is cancelled.  @pag must be a
> > + * passive reference.
> > + */
> > +int
> > +xrep_newbt_add_extent(
> > +	struct xrep_newbt	*xnr,
> > +	struct xfs_perag	*pag,
> > +	xfs_agblock_t		agbno,
> > +	xfs_extlen_t		len)
> > +{
> > +	struct xfs_mount	*mp = xnr->sc->mp;
> > +	struct xfs_alloc_arg	args = {
> > +		.tp		= NULL, /* no autoreap */
> > +		.oinfo		= xnr->oinfo,
> > +		.fsbno		= XFS_AGB_TO_FSB(mp, pag->pag_agno, agbno),
> > +		.len		= len,
> > +		.resv		= xnr->resv,
> > +	};
> > +
> > +	return xrep_newbt_add_blocks(xnr, pag, &args);
> > +}
> 
> I don't quite understand what this helper adds, and the _blocks vs
> _extent naming is a bit confusing.

This wrapper simplifes the interface to xrep_newbt_add_blocks so that
external callers don't have to know which magic values of xfs_alloc_arg
are actually used by xrep_newbt_add_blocks and therefore need to be set.

For all the other repair functions, they have to allocate space from the
free space btree, so xrep_newbt_add_blocks is passed the full
_alloc_args as returned by the allocator to xrep_newbt_alloc_ag_blocks.

> > +#define for_each_xrep_newbt_reservation(xnr, resv, n)	\
> > +	list_for_each_entry_safe((resv), (n), &(xnr)->resv_list, list)
> 
> I have to admit that I find the open code list_for_each_entry_safe
> easier to follow than such wrappers.

The funny part is that I don't even use it in newbt.c.  Maybe it's time
to get rid of it.

$ git grep for_each_xrep_newbt_reservation fs
fs/xfs/scrub/alloc_repair.c:568:        for_each_xrep_newbt_reservation(&ra->new_bnobt, resv, n) {
fs/xfs/scrub/alloc_repair.c:575:        for_each_xrep_newbt_reservation(&ra->new_bnobt, resv, n) {
fs/xfs/scrub/newbt.h:60:#define for_each_xrep_newbt_reservation(xnr, resv, n)   \
fs/xfs/scrub/rmap_repair.c:1126:        for_each_xrep_newbt_reservation(&rr->new_btree, resv, n) {

> > +/* Initialize all the btree cursors for an AG repair. */
> > +void
> > +xrep_ag_btcur_init(
> > +	struct xfs_scrub	*sc,
> > +	struct xchk_ag		*sa)
> > +{
> 
> As far as I can tell this basically sets up cursors for all the
> btrees except the one that we want to repair, and the one that
> goes along with for the alloc and ialloc pairs?  Maybe just spell
> that out for clarity.

Done.

--D
