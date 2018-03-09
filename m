Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43412 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932377AbeCIRdz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Mar 2018 12:33:55 -0500
Date: Fri, 9 Mar 2018 09:33:18 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC] xfs: convert between packed and unpacked agfls
 on-demand
Message-ID: <20180309173318.GD18989@magnolia>
References: <20180307192451.24196-1-bfoster@redhat.com>
 <20180308140354.pk25gd54cqjzbecs@odin.usersys.redhat.com>
 <20180309131628.GA3445@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180309131628.GA3445@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Mar 09, 2018 at 08:16:28AM -0500, Brian Foster wrote:
> On Thu, Mar 08, 2018 at 03:03:54PM +0100, Carlos Maiolino wrote:
> > Hi,
> > 
> > On Wed, Mar 07, 2018 at 02:24:51PM -0500, Brian Foster wrote:
> > > Disliked-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > Sent as RFC for the time being. This tests Ok on a straight xfstests run
> > > and also seems to pass Darrick's agfl fixup tester (thanks) both on
> > > upstream and on a rhel7 kernel with some minor supporting hacks.
> > > 
> > > I tried to tighten up the logic a bit to reduce the odds of mistaking
> > > actual corruption for a padding mismatch as much as possible. E.g.,
> > > limit to cases where the agfl is wrapped, make sure we don't mistake a
> > > corruption that looks like an agfl with 120 entries on a packed kernel,
> > > etc.
> > > 
> > > While I do prefer an on-demand fixup approach to a mount time scan, ISTM
> > > that in either case it's impossible to completely eliminate the risk of
> > > confusing corruption with a padding mismatch so long as we're doing a
> > > manual agfl fixup. The more I think about that the more I really dislike
> > > doing this. :(
> > > 
> > > After some IRC discussion with djwong and sandeen, I'm wondering if the
> > > existence of 'xfs_repair -d' is a good enough last resort for those
> > > users who might be bit by unexpected padding issues on a typical
> > > upgrade. If so, we could fall back to a safer mount-time detection model
> > > that enforces a read-only mount and let the user run repair. The
> > > supposition is that those who aren't prepared to repair via a ramdisk or
> > > whatever should be able to 'xfs_repair -d' a rootfs that is mounted
> > > read-only provided agfl padding is the only inconsistency. 
> > > 
> > > Eric points out that we can still write an unmount record for a
> > > read-only mount, but I'm not sure that would be a problem if repair only
> > > needs to fix the agfl. xfs_repair shouldn't touch the log unless there's
> > > a recovery issue or it needs to be reformatted to update the LSN, both
> > > of which seem to qualify as "you have more problems than agfl padding
> > > and need to run repair anyways" to me. Thoughts?
> > > 
> > 
> > Sorry if this may sound stupid, but in the possibility this can help the issue,
> > or at least me learning something new.
> > 
> > ISTM this issue is all related to the way xfs_agfl packing. I read the commit
> > log where packed attribute was added to xfs_agfl, and I was wondering...
> > 
> > What are the implications of breaking up the lsn field in xfs_agfl, in 2 __be32?
> > Merge it together in a 64bit field when reading it from disk, or split it when
> > writing to?
> > It seems to me this would avoid the size difference we are seeing now in 32/64
> > bit systems, and avoid such risk of confusion when trying to discern between a
> > corrupted agfl and a padding mismatch.
> > 
> 
> I'm not following how you'd accomplish the latter..? We already have the
> packed attribute in place, so the padding is fixed with that. This
> effort has to do with trying to fix up an agfl written by an older
> kernel without the padding fix. My understanding is that the xfs_agfl
> header looks exactly the same on-disk in either case, the issue is a
> broken size calculation that causes the older kernel to not see/use one
> last slot in the agfl. If the agfl has wrapped and a newer kernel loads
> the same on-disk structure, it has no means to know whether the content
> of the final slot is a valid block or a "gap" left by an older kernel
> other than to check whether flcount matches the active count from
> flfirst -> fllast (and that's where potential confusion over a padding
> issue vs other corruption comes into play).

Your understanding is correct.

Sez me, who is watching the fsck.xfs -f discussion just in case that can
be turned into a viable option quickly.

..and wondering what if we /did/ just implement Dave's suggestion from
years ago where if the flcount doesn't match we just reset the agfl and
call fix_freelist to refill it with fresh blocks... it would suck to
leak blocks, though.  Obviously, if the fs has rmap enabled then we can
just rebuild it on the spot via xfs_repair_agfl() (see patch on mailing
list).

--D

> Brian
> 
> > But still, just as reinforcement, this is just a guess, and I have no idea if
> > this is feasible or not, but in case I'm completely nuts, I'll learn something
> > new :)
> > 
> > Cheers.
> > 
> > > Brian
> > > 
> > >  fs/xfs/libxfs/xfs_alloc.c | 147 +++++++++++++++++++++++++++++++++++++++++++++-
> > >  fs/xfs/xfs_mount.h        |   1 +
> > >  fs/xfs/xfs_trace.h        |  18 ++++++
> > >  3 files changed, 164 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > index c02781a4c091..31330996e31c 100644
> > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > @@ -2054,6 +2054,136 @@ xfs_alloc_space_available(
> > >  }
> > >  
> > >  /*
> > > + * Estimate the on-disk agfl size based on the agf state. A size mismatch due to
> > > + * padding is only significant if the agfl wraps around the end or refers to an
> > > + * invalid first/last value.
> > > + */
> > > +static int
> > > +xfs_agfl_ondisk_size(
> > > +	struct xfs_mount	*mp,
> > > +	int			first,
> > > +	int			last,
> > > +	int			count)
> > > +{
> > > +	int			active = count;
> > > +	int			agfl_size = XFS_AGFL_SIZE(mp);
> > > +	bool			wrapped = (first > last) ? true : false;
> > > +
> > > +	if (count && last >= first)
> > > +		active = last - first + 1;
> > > +	else if (count)
> > > +		active = agfl_size - first + last + 1;
> > > +
> > > +	if (wrapped && active == count + 1)
> > > +		agfl_size--;
> > > +	else if ((wrapped && active == count - 1) ||
> > > +		 first == agfl_size || last == agfl_size)
> > > +		agfl_size++;
> > > +
> > > +	/*
> > > +	 * We can't discern the packing problem from certain forms of corruption
> > > +	 * that may look exactly the same. To minimize the chance of mistaking
> > > +	 * corruption for a size mismatch, clamp the size to known valid values.
> > > +	 * A packed header agfl has 119 entries and the older unpacked format
> > > +	 * has one less.
> > > +	 */
> > > +	if (agfl_size < 118 || agfl_size > 119)
> > > +		agfl_size = XFS_AGFL_SIZE(mp);
> > > +
> > > +	return agfl_size;
> > > +}
> > > +
> > > +static bool
> > > +xfs_agfl_need_padfix(
> > > +	struct xfs_mount	*mp,
> > > +	struct xfs_agf		*agf)
> > > +{
> > > +	int			f = be32_to_cpu(agf->agf_flfirst);
> > > +	int			l = be32_to_cpu(agf->agf_fllast);
> > > +	int			c = be32_to_cpu(agf->agf_flcount);
> > > +
> > > +	if (!xfs_sb_version_hascrc(&mp->m_sb))
> > > +		return false;
> > > +
> > > +	return xfs_agfl_ondisk_size(mp, f, l, c) != XFS_AGFL_SIZE(mp);
> > > +}
> > > +
> > > +static int
> > > +xfs_agfl_check_padfix(
> > > +	struct xfs_trans	*tp,
> > > +	struct xfs_buf		*agbp,
> > > +	struct xfs_buf		*agflbp,
> > > +	struct xfs_perag	*pag)
> > > +{
> > > +	struct xfs_mount	*mp = tp->t_mountp;
> > > +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
> > > +	__be32			*agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
> > > +	int			agfl_size = XFS_AGFL_SIZE(mp);
> > > +	int			ofirst, olast, osize;
> > > +	int			nfirst, nlast;
> > > +	int			logflags = 0;
> > > +	int			startoff = 0;
> > > +
> > > +	if (!pag->pagf_needpadfix)
> > > +		return 0;
> > > +
> > > +	ofirst = nfirst = be32_to_cpu(agf->agf_flfirst);
> > > +	olast = nlast = be32_to_cpu(agf->agf_fllast);
> > > +	osize = xfs_agfl_ondisk_size(mp, ofirst, olast, pag->pagf_flcount);
> > > +
> > > +	/*
> > > +	 * If the on-disk agfl is smaller than what the kernel expects, the
> > > +	 * last slot of the on-disk agfl is a gap with bogus data. Move the
> > > +	 * first valid block into the gap and bump the pointer.
> > > +	 */
> > > +	if (osize < agfl_size) {
> > > +		ASSERT(pag->pagf_flcount != 0);
> > > +		agfl_bno[agfl_size - 1] = agfl_bno[ofirst];
> > > +		startoff = (char *) &agfl_bno[agfl_size - 1] - (char *) agflbp->b_addr;
> > > +		nfirst++;
> > > +		goto done;
> > > +	}
> > > +
> > > +	/*
> > > +	 * Otherwise, the on-disk agfl is larger than what the current kernel
> > > +	 * expects. If empty, just fix up the first and last pointers. If not,
> > > +	 * move the inaccessible block to the end of the valid range.
> > > +	 */
> > > +	nfirst = do_mod(nfirst, agfl_size);
> > > +	if (pag->pagf_flcount == 0) {
> > > +		nlast = (nfirst == 0 ? agfl_size - 1 : nfirst - 1);
> > > +		goto done;
> > > +	}
> > > +	if (nlast != agfl_size)
> > > +		nlast++;
> > > +	nlast = do_mod(nlast, agfl_size);
> > > +	agfl_bno[nlast] = agfl_bno[osize - 1];
> > > +	startoff = (char *) &agfl_bno[nlast] - (char *) agflbp->b_addr;
> > > +
> > > +done:
> > > +	if (nfirst != ofirst) {
> > > +		agf->agf_flfirst = cpu_to_be32(nfirst);
> > > +		logflags |= XFS_AGF_FLFIRST;
> > > +	}
> > > +	if (nlast != olast) {
> > > +		agf->agf_fllast = cpu_to_be32(nlast);
> > > +		logflags |= XFS_AGF_FLLAST;
> > > +	}
> > > +	if (startoff) {
> > > +		xfs_trans_buf_set_type(tp, agflbp, XFS_BLFT_AGFL_BUF);
> > > +		xfs_trans_log_buf(tp, agflbp, startoff,
> > > +				  startoff + sizeof(xfs_agblock_t) - 1);
> > > +	}
> > > +	if (logflags)
> > > +		xfs_alloc_log_agf(tp, agbp, logflags);
> > > +
> > > +	trace_xfs_agfl_padfix(mp, osize, agfl_size);
> > > +	pag->pagf_needpadfix = false;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +/*
> > >   * Decide whether to use this allocation group for this allocation.
> > >   * If so, fix up the btree freelist's size.
> > >   */
> > > @@ -2258,6 +2388,12 @@ xfs_alloc_get_freelist(
> > >  	if (error)
> > >  		return error;
> > >  
> > > +	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
> > > +	error = xfs_agfl_check_padfix(tp, agbp, agflbp, pag);
> > > +	if (error) {
> > > +		xfs_perag_put(pag);
> > > +		return error;
> > > +	}
> > >  
> > >  	/*
> > >  	 * Get the block number and update the data structures.
> > > @@ -2269,7 +2405,6 @@ xfs_alloc_get_freelist(
> > >  	if (be32_to_cpu(agf->agf_flfirst) == XFS_AGFL_SIZE(mp))
> > >  		agf->agf_flfirst = 0;
> > >  
> > > -	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
> > >  	be32_add_cpu(&agf->agf_flcount, -1);
> > >  	xfs_trans_agflist_delta(tp, -1);
> > >  	pag->pagf_flcount--;
> > > @@ -2376,11 +2511,18 @@ xfs_alloc_put_freelist(
> > >  	if (!agflbp && (error = xfs_alloc_read_agfl(mp, tp,
> > >  			be32_to_cpu(agf->agf_seqno), &agflbp)))
> > >  		return error;
> > > +
> > > +	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
> > > +	error = xfs_agfl_check_padfix(tp, agbp, agflbp, pag);
> > > +	if (error) {
> > > +		xfs_perag_put(pag);
> > > +		return error;
> > > +	}
> > > +
> > >  	be32_add_cpu(&agf->agf_fllast, 1);
> > >  	if (be32_to_cpu(agf->agf_fllast) == XFS_AGFL_SIZE(mp))
> > >  		agf->agf_fllast = 0;
> > >  
> > > -	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
> > >  	be32_add_cpu(&agf->agf_flcount, 1);
> > >  	xfs_trans_agflist_delta(tp, 1);
> > >  	pag->pagf_flcount++;
> > > @@ -2588,6 +2730,7 @@ xfs_alloc_read_agf(
> > >  		pag->pagb_count = 0;
> > >  		pag->pagb_tree = RB_ROOT;
> > >  		pag->pagf_init = 1;
> > > +		pag->pagf_needpadfix = xfs_agfl_need_padfix(mp, agf);
> > >  	}
> > >  #ifdef DEBUG
> > >  	else if (!XFS_FORCED_SHUTDOWN(mp)) {
> > > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > > index e0792d036be2..78a6377a9b38 100644
> > > --- a/fs/xfs/xfs_mount.h
> > > +++ b/fs/xfs/xfs_mount.h
> > > @@ -353,6 +353,7 @@ typedef struct xfs_perag {
> > >  	char		pagi_inodeok;	/* The agi is ok for inodes */
> > >  	uint8_t		pagf_levels[XFS_BTNUM_AGF];
> > >  					/* # of levels in bno & cnt btree */
> > > +	bool		pagf_needpadfix;
> > >  	uint32_t	pagf_flcount;	/* count of blocks in freelist */
> > >  	xfs_extlen_t	pagf_freeblks;	/* total free blocks */
> > >  	xfs_extlen_t	pagf_longest;	/* longest free space */
> > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > index 945de08af7ba..c7a3bcd6cc4a 100644
> > > --- a/fs/xfs/xfs_trace.h
> > > +++ b/fs/xfs/xfs_trace.h
> > > @@ -3339,6 +3339,24 @@ TRACE_EVENT(xfs_trans_resv_calc,
> > >  		  __entry->logflags)
> > >  );
> > >  
> > > +TRACE_EVENT(xfs_agfl_padfix,
> > > +	TP_PROTO(struct xfs_mount *mp, int osize, int nsize),
> > > +	TP_ARGS(mp, osize, nsize),
> > > +	TP_STRUCT__entry(
> > > +		__field(dev_t, dev)
> > > +		__field(int, osize)
> > > +		__field(int, nsize)
> > > +	),
> > > +	TP_fast_assign(
> > > +		__entry->dev = mp->m_super->s_dev;
> > > +		__entry->osize = osize;
> > > +		__entry->nsize = nsize;
> > > +	),
> > > +	TP_printk("dev %d:%d old size %d new size %d",
> > > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > > +		  __entry->osize, __entry->nsize)
> > > +);
> > > +
> > >  #endif /* _TRACE_XFS_H */
> > >  
> > >  #undef TRACE_INCLUDE_PATH
> > > -- 
> > > 2.13.6
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > -- 
> > Carlos
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
