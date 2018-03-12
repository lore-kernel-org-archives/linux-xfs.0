Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751229AbeCLNMB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Mar 2018 09:12:01 -0400
Date: Mon, 12 Mar 2018 09:11:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC] xfs: convert between packed and unpacked agfls
 on-demand
Message-ID: <20180312131157.GA29810@bfoster.bfoster>
References: <20180307192451.24196-1-bfoster@redhat.com>
 <20180308140354.pk25gd54cqjzbecs@odin.usersys.redhat.com>
 <20180309131628.GA3445@bfoster.bfoster>
 <20180309173318.GD18989@magnolia>
 <20180309183727.GA17046@bfoster.bfoster>
 <20180309190832.GH18989@magnolia>
 <20180309212031.GA19019@bfoster.bfoster>
 <20180309223757.GA4865@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180309223757.GA4865@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

On Fri, Mar 09, 2018 at 02:37:57PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 09, 2018 at 04:20:31PM -0500, Brian Foster wrote:
> > On Fri, Mar 09, 2018 at 11:08:32AM -0800, Darrick J. Wong wrote:
> > > On Fri, Mar 09, 2018 at 01:37:28PM -0500, Brian Foster wrote:
> > > > On Fri, Mar 09, 2018 at 09:33:18AM -0800, Darrick J. Wong wrote:
...
> > 
> > > However, the borked AGFLs have questionable metadata (is it corrupt, or
> > > is it just improperly padded?) and the number of blocks is probably
> > > small, so leaking ~10 blocks per AG probably isn't going to kill us.
> > > Even if the agfl is totally full on a 4k sector disk, 1000 blocks is
> > > still only 4MB.
> > > 
> > 
> > Yep. More of an issue if users go back and forth causing multiple such
> > resets, but honestly, if we warn loudly enough about it and users don't
> > run repair in that situation you get what you get.
> 
> I bet that'll happen more than we want it to. :/
> 

Yeah, but that argument can be applied no matter what we do. How many
users are going to continue to bounce back and forth between differently
padded kernels that don't have any of this magic we're currently
designing? Probably more than we want. ;)

All this work isn't really fixing a bug IMO. It's more of a mitigation
strategy to turn a known problem with nasty side effects into something
more deterministic/predictable. Given that, I think there's a line for
each potential solution that's just not worth crossing.

For example, I don't think it's a big deal if the best available
solution makes it difficult/impossible to handle the case on a
filesystem that was moved with a dirty log or if we can't cover the case
where the fs doesn't have enough blocks to reset/refill an agfl. I don't
think it's worth changing high level behavior for the sake of this
problem and I don't think it's worth doing something that's overly
(subjective) complex (which isn't to say the problem is easy to solve,
clearly it is not).

> > > > It also sounds like there was some general performance related concern
> > > > over mount time scans. My initial distaste for that was more from a
> > > > code/overkill perspective, I hadn't really considered the performance
> > > > aspect.
> > > > 
> > > > Given that, perhaps an on-demand reset with a "Corrupted AGFL, tossed
> > > > $flcount blocks, unmount and run xfs_repair if you ever want to see them
> > > > again" warning might not be so bad. It works the same whether the kernel
> > > > is packed, unpacked or the agfl is just borked, and therefore the test
> > > > matrix is much simpler as well. Hmmmm...
> > > 
> > > Something occurred to me late yesterday while talking to Eric about his
> > > patch to do the unlinked inode recovery.  For a reflinked filesystem, we
> > > already iterate every AG at mount time to clean out all the stale CoW
> > > staging extents.  Given that we already take the performance hit to walk
> > > all the AGs, perhaps it makes sense to combine the stale cow, unlinked
> > > inode, and bad-pad agf scans into a single pass?
> > > 
> > 
> > Is that necessary on every refcountbt=1 mount or only after an unclean
> > shutdown? (If the former, I'm wondering if the better question is how
> > could we limit that going forward..? ;).
> 
> It should only be necessary to go scanning for stale cows if we had to
> recover the log, but for the initial merge I figured it better to be
> conservative and always scan for crud rather than risk letting it
> accumulate like the unlinked inodes. :)
> 

Ok. Regardless of whether we'd continue to do that long term or not,
that kind of speaks to the point of not adding more mount scan stuff
purely based on the fact that we already do it for something else.

> That said, we don't clean out cow mappings when we freeze the fs, so
> on the assumption that freezing leaves us with a clean log, I thought it
> necessary to scan for stale cows at any rw-mount/remount-rw opportunity.
> That assumption turned out not to be true, but otoh Eric is trying to
> push us towards not having to recover snapshots, I think.
> 

Yeah.. sounds familiar. IIRC, the historical reason for dirtying the log
on freeze was to ensure unlinked inode cleanup after a crash..

> I'm also unenthusiastic about flushing what could be gigabytes worth of
> cow preallocations on every fs freeze just to reduce mount time if we
> happen to crash while the fs is frozen.  The increased fragmentation
> that can happen due to the flush hits us every day, whereas crashes are
> infrequent.
> 

Indeed, makes sense. Though on the flipside, we'll already reclaim cow
blocks for any inode that isn't dirty on the 5 minute background
scanner. An fs freeze is likely less frequent than that, no? I guess it
depends on how active the fs is with cow operations.

One simple option might be to conditionally dirty the log if cowblocks
are present and perhaps consider a tunable for users who want to run a
cowblocks scan on freeze. Anyways, that's probably a separate
discussion.

> > With regard to unlinked inodes, I've been thinking about turning that
> > into a background operation for a little while, I just haven't got
> > around to it yet. While the initial patches makes sense, I'm wondering
> > if that's something we could ultimately kick off at mount time that
> > doesn't necessarily have to be synchronous with the mount itself (but
> > this is all not really paged in my head atm).
> 
> This doesn't seem too difficult, since we can walk the unlinked list and
> zap the inodes that have zero usage count, I think.  Though there's
> always going to be people who complain about weird slowdowns after
> mount if we make it asynchronous -- look at the ext4 lazy initialization
> stuff. :)
> 

That's not quite how I would envision it working. I'd expect it to work
something like the background eofblocks reclaim and I'd also expect
everything to still be cleaned up properly on a clean unmount. Alas, I
haven't looked into the details yet so it's probably not worth getting
too much into the weeds for something that doesn't exist yet.

> CoW is harder since we don't track whether some cow fork extent maps to
> the block or if it's stale and can go away now.
> 
> > In my mind, it seems a bit of a shame to do an explicit mount time scan
> > only to use a risky hack (like the reset, or either of our previous
> > patches, etc.) when we could do something clean like enforce a read-only
> > mount. The latter would obviously require serialization with the mount.
> > With an on-demand approach, we probably don't want to randomly
> > transition to read-only or shutdown, so the reset + warn thing seems
> > more amenable to me.
> 
> <nod> I've been mulling over rewriting your previous rfc patch that put
> all the scanning/lifting in {get,put}_freelist but having it reset the
> agfl instead of doing the swizzling stuff.
> 

Something to be careful of... emptying the agfl obviously means the
subsequent fixup is a btree block allocation. That may limit the context
of where the fixup can be performed. IOW, deferring it to
_get_freelist() might no longer be safe. Instead, I think we'd have to
implement it such that the on-disk flcount is completely untrusted when
the mismatch is detected.

Part of me is wondering whether we could actually do a tx-less reset
(not refill) on agfl read. Would a subsequent fix_freelist() log all the
right bits to maintain crash consistency? We could just repeat the reset
if nothing changes before a crash. Otherwise, perhaps we'd have to run
it in fix_freelist() context.

> > I'm not against the mount scan for this particular issue as much as
> > turning it into this infrastructural thing where we seemingly keep
> > adding crap to it over time. The potential for abuse of that over time
> > makes me cringe a bit, but tbh I haven't gone and actually tested mount
> > time scans on large AG count systems to see if it's really that bad.
> 
> It's not too bad if you aren't growfs happy but it is noticeable on my
> slow disky laptops.  Admittedly I haven't tried it on these monster
> 10000 AG filesystems I keep hearing about. :P
> 

I think those setups tend to come from configurations where users want
to construct small base/installation images and grow them on deployment
for whatever reason. That tends to come with its own set of problems.

Brian

> > > Granted you do make the point that we've been leaking unlinked inodes on
> > > rootfses for ages with little trouble, but in the long run I think we'd
> > > prefer to clean up the filesystem leftovers.
> > > 
> > 
> > ISTM that the long run solution for the AGFL thing is online repair..?
> 
> That is the goal. :)
> 
> --D
> 
> > Brian
> > 
> > > --D
> > > 
> > > > Brian
> > > > 
> > > > > --D
> > > > > 
> > > > > > Brian
> > > > > > 
> > > > > > > But still, just as reinforcement, this is just a guess, and I have no idea if
> > > > > > > this is feasible or not, but in case I'm completely nuts, I'll learn something
> > > > > > > new :)
> > > > > > > 
> > > > > > > Cheers.
> > > > > > > 
> > > > > > > > Brian
> > > > > > > > 
> > > > > > > >  fs/xfs/libxfs/xfs_alloc.c | 147 +++++++++++++++++++++++++++++++++++++++++++++-
> > > > > > > >  fs/xfs/xfs_mount.h        |   1 +
> > > > > > > >  fs/xfs/xfs_trace.h        |  18 ++++++
> > > > > > > >  3 files changed, 164 insertions(+), 2 deletions(-)
> > > > > > > > 
> > > > > > > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > > > > > > index c02781a4c091..31330996e31c 100644
> > > > > > > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > > > > > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > > > > > > @@ -2054,6 +2054,136 @@ xfs_alloc_space_available(
> > > > > > > >  }
> > > > > > > >  
> > > > > > > >  /*
> > > > > > > > + * Estimate the on-disk agfl size based on the agf state. A size mismatch due to
> > > > > > > > + * padding is only significant if the agfl wraps around the end or refers to an
> > > > > > > > + * invalid first/last value.
> > > > > > > > + */
> > > > > > > > +static int
> > > > > > > > +xfs_agfl_ondisk_size(
> > > > > > > > +	struct xfs_mount	*mp,
> > > > > > > > +	int			first,
> > > > > > > > +	int			last,
> > > > > > > > +	int			count)
> > > > > > > > +{
> > > > > > > > +	int			active = count;
> > > > > > > > +	int			agfl_size = XFS_AGFL_SIZE(mp);
> > > > > > > > +	bool			wrapped = (first > last) ? true : false;
> > > > > > > > +
> > > > > > > > +	if (count && last >= first)
> > > > > > > > +		active = last - first + 1;
> > > > > > > > +	else if (count)
> > > > > > > > +		active = agfl_size - first + last + 1;
> > > > > > > > +
> > > > > > > > +	if (wrapped && active == count + 1)
> > > > > > > > +		agfl_size--;
> > > > > > > > +	else if ((wrapped && active == count - 1) ||
> > > > > > > > +		 first == agfl_size || last == agfl_size)
> > > > > > > > +		agfl_size++;
> > > > > > > > +
> > > > > > > > +	/*
> > > > > > > > +	 * We can't discern the packing problem from certain forms of corruption
> > > > > > > > +	 * that may look exactly the same. To minimize the chance of mistaking
> > > > > > > > +	 * corruption for a size mismatch, clamp the size to known valid values.
> > > > > > > > +	 * A packed header agfl has 119 entries and the older unpacked format
> > > > > > > > +	 * has one less.
> > > > > > > > +	 */
> > > > > > > > +	if (agfl_size < 118 || agfl_size > 119)
> > > > > > > > +		agfl_size = XFS_AGFL_SIZE(mp);
> > > > > > > > +
> > > > > > > > +	return agfl_size;
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +static bool
> > > > > > > > +xfs_agfl_need_padfix(
> > > > > > > > +	struct xfs_mount	*mp,
> > > > > > > > +	struct xfs_agf		*agf)
> > > > > > > > +{
> > > > > > > > +	int			f = be32_to_cpu(agf->agf_flfirst);
> > > > > > > > +	int			l = be32_to_cpu(agf->agf_fllast);
> > > > > > > > +	int			c = be32_to_cpu(agf->agf_flcount);
> > > > > > > > +
> > > > > > > > +	if (!xfs_sb_version_hascrc(&mp->m_sb))
> > > > > > > > +		return false;
> > > > > > > > +
> > > > > > > > +	return xfs_agfl_ondisk_size(mp, f, l, c) != XFS_AGFL_SIZE(mp);
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +static int
> > > > > > > > +xfs_agfl_check_padfix(
> > > > > > > > +	struct xfs_trans	*tp,
> > > > > > > > +	struct xfs_buf		*agbp,
> > > > > > > > +	struct xfs_buf		*agflbp,
> > > > > > > > +	struct xfs_perag	*pag)
> > > > > > > > +{
> > > > > > > > +	struct xfs_mount	*mp = tp->t_mountp;
> > > > > > > > +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
> > > > > > > > +	__be32			*agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
> > > > > > > > +	int			agfl_size = XFS_AGFL_SIZE(mp);
> > > > > > > > +	int			ofirst, olast, osize;
> > > > > > > > +	int			nfirst, nlast;
> > > > > > > > +	int			logflags = 0;
> > > > > > > > +	int			startoff = 0;
> > > > > > > > +
> > > > > > > > +	if (!pag->pagf_needpadfix)
> > > > > > > > +		return 0;
> > > > > > > > +
> > > > > > > > +	ofirst = nfirst = be32_to_cpu(agf->agf_flfirst);
> > > > > > > > +	olast = nlast = be32_to_cpu(agf->agf_fllast);
> > > > > > > > +	osize = xfs_agfl_ondisk_size(mp, ofirst, olast, pag->pagf_flcount);
> > > > > > > > +
> > > > > > > > +	/*
> > > > > > > > +	 * If the on-disk agfl is smaller than what the kernel expects, the
> > > > > > > > +	 * last slot of the on-disk agfl is a gap with bogus data. Move the
> > > > > > > > +	 * first valid block into the gap and bump the pointer.
> > > > > > > > +	 */
> > > > > > > > +	if (osize < agfl_size) {
> > > > > > > > +		ASSERT(pag->pagf_flcount != 0);
> > > > > > > > +		agfl_bno[agfl_size - 1] = agfl_bno[ofirst];
> > > > > > > > +		startoff = (char *) &agfl_bno[agfl_size - 1] - (char *) agflbp->b_addr;
> > > > > > > > +		nfirst++;
> > > > > > > > +		goto done;
> > > > > > > > +	}
> > > > > > > > +
> > > > > > > > +	/*
> > > > > > > > +	 * Otherwise, the on-disk agfl is larger than what the current kernel
> > > > > > > > +	 * expects. If empty, just fix up the first and last pointers. If not,
> > > > > > > > +	 * move the inaccessible block to the end of the valid range.
> > > > > > > > +	 */
> > > > > > > > +	nfirst = do_mod(nfirst, agfl_size);
> > > > > > > > +	if (pag->pagf_flcount == 0) {
> > > > > > > > +		nlast = (nfirst == 0 ? agfl_size - 1 : nfirst - 1);
> > > > > > > > +		goto done;
> > > > > > > > +	}
> > > > > > > > +	if (nlast != agfl_size)
> > > > > > > > +		nlast++;
> > > > > > > > +	nlast = do_mod(nlast, agfl_size);
> > > > > > > > +	agfl_bno[nlast] = agfl_bno[osize - 1];
> > > > > > > > +	startoff = (char *) &agfl_bno[nlast] - (char *) agflbp->b_addr;
> > > > > > > > +
> > > > > > > > +done:
> > > > > > > > +	if (nfirst != ofirst) {
> > > > > > > > +		agf->agf_flfirst = cpu_to_be32(nfirst);
> > > > > > > > +		logflags |= XFS_AGF_FLFIRST;
> > > > > > > > +	}
> > > > > > > > +	if (nlast != olast) {
> > > > > > > > +		agf->agf_fllast = cpu_to_be32(nlast);
> > > > > > > > +		logflags |= XFS_AGF_FLLAST;
> > > > > > > > +	}
> > > > > > > > +	if (startoff) {
> > > > > > > > +		xfs_trans_buf_set_type(tp, agflbp, XFS_BLFT_AGFL_BUF);
> > > > > > > > +		xfs_trans_log_buf(tp, agflbp, startoff,
> > > > > > > > +				  startoff + sizeof(xfs_agblock_t) - 1);
> > > > > > > > +	}
> > > > > > > > +	if (logflags)
> > > > > > > > +		xfs_alloc_log_agf(tp, agbp, logflags);
> > > > > > > > +
> > > > > > > > +	trace_xfs_agfl_padfix(mp, osize, agfl_size);
> > > > > > > > +	pag->pagf_needpadfix = false;
> > > > > > > > +
> > > > > > > > +	return 0;
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +/*
> > > > > > > >   * Decide whether to use this allocation group for this allocation.
> > > > > > > >   * If so, fix up the btree freelist's size.
> > > > > > > >   */
> > > > > > > > @@ -2258,6 +2388,12 @@ xfs_alloc_get_freelist(
> > > > > > > >  	if (error)
> > > > > > > >  		return error;
> > > > > > > >  
> > > > > > > > +	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
> > > > > > > > +	error = xfs_agfl_check_padfix(tp, agbp, agflbp, pag);
> > > > > > > > +	if (error) {
> > > > > > > > +		xfs_perag_put(pag);
> > > > > > > > +		return error;
> > > > > > > > +	}
> > > > > > > >  
> > > > > > > >  	/*
> > > > > > > >  	 * Get the block number and update the data structures.
> > > > > > > > @@ -2269,7 +2405,6 @@ xfs_alloc_get_freelist(
> > > > > > > >  	if (be32_to_cpu(agf->agf_flfirst) == XFS_AGFL_SIZE(mp))
> > > > > > > >  		agf->agf_flfirst = 0;
> > > > > > > >  
> > > > > > > > -	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
> > > > > > > >  	be32_add_cpu(&agf->agf_flcount, -1);
> > > > > > > >  	xfs_trans_agflist_delta(tp, -1);
> > > > > > > >  	pag->pagf_flcount--;
> > > > > > > > @@ -2376,11 +2511,18 @@ xfs_alloc_put_freelist(
> > > > > > > >  	if (!agflbp && (error = xfs_alloc_read_agfl(mp, tp,
> > > > > > > >  			be32_to_cpu(agf->agf_seqno), &agflbp)))
> > > > > > > >  		return error;
> > > > > > > > +
> > > > > > > > +	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
> > > > > > > > +	error = xfs_agfl_check_padfix(tp, agbp, agflbp, pag);
> > > > > > > > +	if (error) {
> > > > > > > > +		xfs_perag_put(pag);
> > > > > > > > +		return error;
> > > > > > > > +	}
> > > > > > > > +
> > > > > > > >  	be32_add_cpu(&agf->agf_fllast, 1);
> > > > > > > >  	if (be32_to_cpu(agf->agf_fllast) == XFS_AGFL_SIZE(mp))
> > > > > > > >  		agf->agf_fllast = 0;
> > > > > > > >  
> > > > > > > > -	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
> > > > > > > >  	be32_add_cpu(&agf->agf_flcount, 1);
> > > > > > > >  	xfs_trans_agflist_delta(tp, 1);
> > > > > > > >  	pag->pagf_flcount++;
> > > > > > > > @@ -2588,6 +2730,7 @@ xfs_alloc_read_agf(
> > > > > > > >  		pag->pagb_count = 0;
> > > > > > > >  		pag->pagb_tree = RB_ROOT;
> > > > > > > >  		pag->pagf_init = 1;
> > > > > > > > +		pag->pagf_needpadfix = xfs_agfl_need_padfix(mp, agf);
> > > > > > > >  	}
> > > > > > > >  #ifdef DEBUG
> > > > > > > >  	else if (!XFS_FORCED_SHUTDOWN(mp)) {
> > > > > > > > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > > > > > > > index e0792d036be2..78a6377a9b38 100644
> > > > > > > > --- a/fs/xfs/xfs_mount.h
> > > > > > > > +++ b/fs/xfs/xfs_mount.h
> > > > > > > > @@ -353,6 +353,7 @@ typedef struct xfs_perag {
> > > > > > > >  	char		pagi_inodeok;	/* The agi is ok for inodes */
> > > > > > > >  	uint8_t		pagf_levels[XFS_BTNUM_AGF];
> > > > > > > >  					/* # of levels in bno & cnt btree */
> > > > > > > > +	bool		pagf_needpadfix;
> > > > > > > >  	uint32_t	pagf_flcount;	/* count of blocks in freelist */
> > > > > > > >  	xfs_extlen_t	pagf_freeblks;	/* total free blocks */
> > > > > > > >  	xfs_extlen_t	pagf_longest;	/* longest free space */
> > > > > > > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > > > > > > index 945de08af7ba..c7a3bcd6cc4a 100644
> > > > > > > > --- a/fs/xfs/xfs_trace.h
> > > > > > > > +++ b/fs/xfs/xfs_trace.h
> > > > > > > > @@ -3339,6 +3339,24 @@ TRACE_EVENT(xfs_trans_resv_calc,
> > > > > > > >  		  __entry->logflags)
> > > > > > > >  );
> > > > > > > >  
> > > > > > > > +TRACE_EVENT(xfs_agfl_padfix,
> > > > > > > > +	TP_PROTO(struct xfs_mount *mp, int osize, int nsize),
> > > > > > > > +	TP_ARGS(mp, osize, nsize),
> > > > > > > > +	TP_STRUCT__entry(
> > > > > > > > +		__field(dev_t, dev)
> > > > > > > > +		__field(int, osize)
> > > > > > > > +		__field(int, nsize)
> > > > > > > > +	),
> > > > > > > > +	TP_fast_assign(
> > > > > > > > +		__entry->dev = mp->m_super->s_dev;
> > > > > > > > +		__entry->osize = osize;
> > > > > > > > +		__entry->nsize = nsize;
> > > > > > > > +	),
> > > > > > > > +	TP_printk("dev %d:%d old size %d new size %d",
> > > > > > > > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > > > > > > > +		  __entry->osize, __entry->nsize)
> > > > > > > > +);
> > > > > > > > +
> > > > > > > >  #endif /* _TRACE_XFS_H */
> > > > > > > >  
> > > > > > > >  #undef TRACE_INCLUDE_PATH
> > > > > > > > -- 
> > > > > > > > 2.13.6
> > > > > > > > 
> > > > > > > > --
> > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > 
> > > > > > > -- 
> > > > > > > Carlos
> > > > > > > --
> > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > --
> > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
