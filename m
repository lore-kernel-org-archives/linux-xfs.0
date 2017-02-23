Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227145836.tozkfng3pk4y37uf@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from aserp1040.oracle.com ([141.146.126.69]:39853 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751199AbdBWUoU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Feb 2017 15:44:20 -0500
Date: Thu, 23 Feb 2017 12:44:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/8] xfs: introduce the XFS_IOC_GETFSMAP ioctl
Message-ID: <20170223204405.GI5846@birch.djwong.org>
References: <148738063792.29384.10681837280402457846.stgit@birch.djwong.org>
 <148738066907.29384.8419135817879528959.stgit@birch.djwong.org>
 <20170222150246.GB53025@bfoster.bfoster>
 <20170222211757.GH5846@birch.djwong.org>
 <20170223144542.GA57349@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170223144542.GA57349@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 23, 2017 at 09:45:43AM -0500, Brian Foster wrote:
> On Wed, Feb 22, 2017 at 01:17:57PM -0800, Darrick J. Wong wrote:
> > On Wed, Feb 22, 2017 at 10:02:47AM -0500, Brian Foster wrote:
> > > On Fri, Feb 17, 2017 at 05:17:49PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Introduce a new ioctl that uses the reverse mapping btree to return
> > > > information about the physical layout of the filesystem.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > 
> > > Mostly looks good, though there's a decent amount of indirection here so
> > > I'll probably need another pass through it. Mostly minor comments, a
> > > couple potential issues and some questions..
> > 
> > <nod>
> > 
> > > >  fs/xfs/Makefile        |    1 
> > > >  fs/xfs/libxfs/xfs_fs.h |   13 +
> > > >  fs/xfs/xfs_fsmap.c     |  782 ++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/xfs_fsmap.h     |   51 +++
> > > >  fs/xfs/xfs_ioctl.c     |  103 ++++++
> > > >  fs/xfs/xfs_ioctl32.c   |    2 
> > > >  fs/xfs/xfs_trace.h     |   85 +++++
> > > >  fs/xfs/xfs_trans.c     |   22 +
> > > >  fs/xfs/xfs_trans.h     |    2 
> > > >  9 files changed, 1061 insertions(+)
> > > >  create mode 100644 fs/xfs/xfs_fsmap.c
> > > >  create mode 100644 fs/xfs/xfs_fsmap.h
> > > > 
> > > > 
> ...
> > > > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > > > index b72dc82..095bdf0 100644
> > > > --- a/fs/xfs/libxfs/xfs_fs.h
> > > > +++ b/fs/xfs/libxfs/xfs_fs.h
> ...
> > > > +	/*
> > > > +	 * Filter out records that start before our startpoint, if the
> > > > +	 * caller requested that.
> > > > +	 */
> > > > +	if (xfs_getfsmap_rec_before_low_key(info, rec)) {
> > > > +		rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
> > > > +		if (info->next_daddr < rec_daddr)
> > > > +			info->next_daddr = rec_daddr;
> > > > +		return XFS_BTREE_QUERY_RANGE_CONTINUE;
> > > > +	}
> > > > +
> > > > +	/*
> > > > +	 * If the caller passed in a length with the low record and
> > > > +	 * the record represents a file data extent, we incremented
> > > > +	 * the offset in the low key by the length in the hopes of
> > > > +	 * finding reverse mappings for the physical blocks we just
> > > > +	 * saw.  We did /not/ increment next_daddr by the length
> > > > +	 * because the range query would not be able to find shared
> > > > +	 * extents within the same physical block range.
> > > > +	 *
> > > > +	 * However, the extent we've been fed could have a startblock
> > > > +	 * past the passed-in low record.  If this is the case,
> > > > +	 * advance next_daddr to the end of the passed-in low record
> > > > +	 * so we don't report the extent prior to this extent as
> > > > +	 * free.
> > > > +	 */
> > > > +	key_end = info->rkey_low->fmr_physical + info->rkey_low->fmr_length;
> > > > +	if (info->dev == info->rkey_low->fmr_device &&
> > > > +	    info->next_daddr < key_end && rec_daddr >= key_end)
> > > > +		info->next_daddr = key_end;
> > > > +
> > > 
> > > Hmm, so I think I follow what this is trying to do..
> > > 
> > > In the case where we left off on a file mapping, we bump the offset of
> > > the passed in low key but next_daddr remains at the same physical block
> > > because we could have more mappings there. If we don't, however, and the
> > > next mapping occurs at a higher physical block, we need to make sure we
> > > don't map the previous range as free space. So we bump next_daddr here
> > > to make sure that if free space does exist, it shown to start at the end
> > > of the previous mapping. Yes?
> > 
> > Yes.
> > 
> > > If I'm following that correctly, what about the case where we have
> > > bumped fmr_physical? It doesn't look like we've reset fmr_length, so
> > > couldn't this cause us to skip legitimate free space if for e.g. the
> > > current record is much farther ahead?
> > 
> > rkey_low->fmr_{physical,length} are from the low key passed in from
> > userspace, and therefore, key_end is the physical end of the unadjusted
> > low key provided by userspace.
> > 
> 
> Ok, so in xfs_getfsmap() we have rkey_low/high from the userspace
> header. The local dkeys array is initialized from these values, bumped
> as necessary based on the userspace low key, and then truncated per
> device. We also set info.rkey_low based on the userspace value and
> info.next_daddr based on the (potentially bumped) physical offset.
> 
> We call into xfs_getfsmap_datadev() with dkeys and the info object.
> Here we set up info->low/high based on the device keys, now truncated as
> appropriate for the per-ag walk, and run the query based on
> info->low/high. We pass the info object along to the rmap query...
> 
> We ultimately get here in xfs_getfsmap_helper() with the info object and
> the visited record. key_end is calculated based on info->rkey_low, which
> as you point out, is the unmodified key from userspace. The 'if
> (info->next_daddr < key_end)' check basically means 'if the low key is
> file data,' because that's the case where we've bumped the file offset
> rather than the physical offset. The 'rec_daddr >= key_end' check means
> that we have no more records at the physical offset of the low key, and
> we now have to fix up next_daddr (of which the primary purpose is to
> detect free space ranges in the gaps of rmapbt records) lest we
> mistakenly report a free space record for the previous range...

Correct.

> > dkey[0] is the low key after its fmr_physical/fmr_offset value has been
> > adjusted; and next_daddr's first value is dkey[0].fmr_physical.
> > Therefore, next_daddr points to the first block of the low key in the
> > data fsmap case; or points to the next block after the low key in all
> > other cases.
> > 
> > So to answer your question quickly, key_end is always computed from
> > non-bumped values.
> > 
> 
> Makes sense now, provided I'm following the logic correctly above..
> thanks. I think I just lost track of what keys are what.
> 
> (It sure would be nice to make this easier to follow somehow, but my
> brain hurts and I can't really think of anything more clear atm... :P).

I'll enhance the comments for xfs_getfsmap() to discuss all the keys and
*_daddr counters floating around, and how they interact.

> > This is kind of confusing, so let's work a few examples...
> > 
> > Say userspace gives us head->fmh_keys = [(8:0, 24, 8, OWN_INOBT, 0), (-1)].
> > That means that the last record userspace saw was 8 sectors of inobt
> > starting at sector 24.  Then set info.rkey_low = &head->fmh_keys[0].
> > Because inobt is a special owner, dkeys[0] = (8:0, 32, 8, OWN_INOBT, 0),
> > and next_daddr = 32.  We should probably decrease the length from 8 to 0
> > but the length is not a key field so it doesn't really matter.
> > 
> > Say that _getfsmap_helper is passed the rmap (8:0, 64, 8, OWN_REFCOUNT, 0).
> > When we get to line 318, set key_end = 24 + 8.
> > 
> > The test
> > if (devices match && next_daddr < key_end && rec_daddr >= key_end)
> > becomes
> > if (devices match && 32 < 32 && we don't care after this point)
> > 
> > So the branch test is false and we don't set next_daddr = key_end.
> > We synthesize an fsmap record for free space spanning sector 32 to 64,
> > emit the OWN_REFCOUNT record, and set next_daddr = 72 and move on.
> > 
> 
> Makes sense...
> 
> > [If you're wondering how it works for regular data extents, keep
> > reading.]
> > 
> > Second example: fmh_keys = [(8:0, 24, 16, 128, 0), (-1)].  Now we have
> > that userspace last saw 16 sectors of file data (inode 128, offset 0)
> > starting at block 24.  We again set info.rkey_low = &head->fmh_keys[0].
> > Because the lowkey is a data extent, dkeys[0] = (8:0, 24, 16, 128, 16),
> > and next_daddr = 24.
> > 
> 
> So we've bumped the file offset only and kept next_daddr equivalent as
> it is safe to expect more mappings for the same physical offset..
> 
> > The first rmap passed to _getfsmap_helper is the same (8:0, 24, 16, 128,
> > 0) that we emitted as the last fsmap returned from the previous getfsmap
> > call, because we started the query_range at dkeys[0].physical, which is
> > 24.  xfs_getfsmap_rec_before_low_key notices that the key of this record
> > is less than the rkey_low that was passed in and so increments
> > next_daddr to 40.
> > 
> 
> So the rmapbt query doesn't incorporate the full getfsmap key in the
> search and we thus we have to include finer grained filtering..? If so,
> I think this bit could be noted explicitly in the comment..

It's a funny quirk of how queries have to work when record keys contain
multiple overlapping ranges interacting with the current design of
query_range.

rmap tuple format is still (start, length, owner, offset).

Say you have the rmaps (24, 8, 128, 0) and (30, 10, 128, 8).  The low
key of the first rmap is (24, 128, 0) and the high key is (31, 128, 7).
That way you can query the rmapbt for start == 27 and it'll return the
above rmap.  _btree_query_range was designed to return any record
overlapping with any part of the interval, even if the record start or
record end themselves are not within the interval.

However, if you want to look for the next tuple after (24, 8, 128, 0)
you can't just tell it to search for (31...) because 31 > 30 and it'll
miss that second rmap.  You can however tell it to search (24, 128, 8)
and ignore any records if any part of the low key is not greater than
the low search key.

Theoretically, we could enhance query_range to take an operator so that
you could tell it to return any record overlapping with any part of the
interval so long as the start of the record is strictly greater than the
start of the query interval.

FWIW the comment for _btree_query_range says it returns all records
overlapping with the interval passed in.

> Also, I'm kind of wondering why we couldn't have just set next_daddr to
> 40 in the first place based on the low key. Is there some other corner
> case that breaks..?

Aha, looking through my notes, the original version also used next_daddr
(buggily) to decide if a record actually started before the bumped low
key so that it could ignore it.  Subsequent revisions created an
explicit test function (_getfsmap_rec_before_low_key) so you're right,
we can set next_daddr to 40 (fmh_keys[0]->fmr_physical + fmr_length) for
the first loop iteration and zero for subsequent iterations.  With that
the key_end business also goes away.

> > Assuming _getfsmap_helper is passed the same refcount rmap as before.
> > rec_daddr = 64, and when we get to line 318, key_end = 24 + 16.
> > 
> > The test is now:
> > if (devices match && 40 < 40 && 64 >= 40)
> > So we leave next_daddr at 40.
> > 
> > The correct output here is to synthesize an fsmap record for free space
> > between 40-64, and then to emit the refcount record at 64.
> > 
> > Third example: fmh_keys = [(8:0, 24, 16, 128, 0), (-1)] and next_daddr = 24
> > as before.  _getfsmap_helper again sees (8:0, 24, 16, 128, 0) and sets
> > next_daddr = 40.
> > 
> > This time, however, _getfsmap_helper is passed (8:0, 32, 8, 129, 0),
> > which is 8 sectors of inode 129's data at offset 0.  rec_daddr = 32,
> > key_end = 24 + 16 as before.
> > 
> > The test is now:
> > if (devices match && 40 < 40 && 32 >= 40)
> > So we again leave next_daddr at 40, then emit the fsmap for inode 129.
> > 
> 
> Thanks for the explanation.
> 
> ...
> > > > +/* Execute a getfsmap query against the log device. */
> > > > +STATIC int
> > > > +xfs_getfsmap_logdev(
> > > > +	struct xfs_trans		*tp,
> > > > +	struct xfs_fsmap		*keys,
> > > > +	struct xfs_getfsmap_info	*info)
> > > > +{
> > > > +	struct xfs_mount		*mp = tp->t_mountp;
> > > > +	struct xfs_fsmap		*dkey_low = keys;
> > > > +	struct xfs_btree_cur		cur;
> > > > +	struct xfs_rmap_irec		rmap;
> > > > +	int				error;
> > > > +
> > > > +	/* Set up search keys */
> > > > +	info->low.rm_startblock = XFS_BB_TO_FSBT(mp, dkey_low->fmr_physical);
> > > > +	info->low.rm_offset = XFS_BB_TO_FSBT(mp, dkey_low->fmr_offset);
> > > > +	error = xfs_fsmap_owner_to_rmap(keys, &info->low);
> > > > +	if (error)
> > > > +		return error;
> > > > +	info->low.rm_blockcount = 0;
> > > > +	xfs_getfsmap_set_irec_flags(&info->low, dkey_low);
> > > > +
> > > > +	error = xfs_fsmap_owner_to_rmap(keys + 1, &info->high);
> > > > +	if (error)
> > > > +		return error;
> > > > +	info->high.rm_startblock = -1U;
> > > > +	info->high.rm_owner = ULLONG_MAX;
> > > > +	info->high.rm_offset = ULLONG_MAX;
> > > > +	info->high.rm_blockcount = 0;
> > > > +	info->high.rm_flags = XFS_RMAP_KEY_FLAGS | XFS_RMAP_REC_FLAGS;
> > > > +	info->missing_owner = XFS_FMR_OWN_FREE;
> > > > +
> > > > +	trace_xfs_fsmap_low_key(mp, info->dev, info->agno,
> > > > +			info->low.rm_startblock,
> > > > +			info->low.rm_blockcount,
> > > > +			info->low.rm_owner,
> > > > +			info->low.rm_offset);
> > > > +
> > > > +	trace_xfs_fsmap_high_key(mp, info->dev, info->agno,
> > > > +			info->high.rm_startblock,
> > > > +			info->high.rm_blockcount,
> > > > +			info->high.rm_owner,
> > > > +			info->high.rm_offset);
> > > > +
> > > > +
> > > > +	if (dkey_low->fmr_physical > 0)
> > > > +		return 0;
> > > > +
> > > 
> > > A comment to point out we're fabricating an rmap record here would be
> > 
> > Ok.
> > 
> > > nice. Also, (how) do we handle/report internal log blocks?
> > 
> > The AG containing the log will have an rmapbt record for RMAP_OWN_LOG,
> > so that'll be in with the datadev records.
> > 
> 
> Ok, I recall now that the internal log is basically just permanently
> allocated space in whatever AG covers it.
> 
> > > > +	rmap.rm_startblock = 0;
> > > > +	rmap.rm_blockcount = mp->m_sb.sb_logblocks;
> > > > +	rmap.rm_owner = XFS_RMAP_OWN_LOG;
> > > > +	rmap.rm_offset = 0;
> > > > +	rmap.rm_flags = 0;
> > > > +
> > > > +	cur.bc_mp = mp;
> > > > +	cur.bc_tp = tp;
> > > > +	return xfs_getfsmap_rtdev_helper(&cur, &rmap, info);
> > > > +}
> > > > +
> ...
> > > > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > > > index c67cfb4..bbe1b58 100644
> > > > --- a/fs/xfs/xfs_ioctl.c
> > > > +++ b/fs/xfs/xfs_ioctl.c
> ...
> > > > +STATIC int
> > > > +xfs_ioc_getfsmap(
> > > > +	struct xfs_inode	*ip,
> > > > +	void			__user *arg)
> > > > +{
> > > > +	struct getfsmap_info	info;
> > > > +	struct xfs_fsmap_head	xhead = {0};
> > > > +	struct fsmap_head	head;
> > > > +	bool			aborted = false;
> > > > +	int			error;
> > > > +
> ...
> > > > +	xhead.fmh_iflags = head.fmh_iflags;
> > > > +	xhead.fmh_count = head.fmh_count;
> > > > +	xfs_fsmap_to_internal(&xhead.fmh_keys[0], &head.fmh_keys[0]);
> > > > +	xfs_fsmap_to_internal(&xhead.fmh_keys[1], &head.fmh_keys[1]);
> > > > +
> > > > +	trace_xfs_getfsmap_low_key(ip->i_mount,
> > > > +			xhead.fmh_keys[0].fmr_device,
> > > > +			xhead.fmh_keys[0].fmr_physical,
> > > > +			xhead.fmh_keys[0].fmr_length,
> > > > +			xhead.fmh_keys[0].fmr_owner,
> > > > +			xhead.fmh_keys[0].fmr_offset,
> > > > +			xhead.fmh_keys[0].fmr_flags);
> > > > +
> > > > +	trace_xfs_getfsmap_high_key(ip->i_mount,
> > > > +			xhead.fmh_keys[1].fmr_device,
> > > > +			xhead.fmh_keys[1].fmr_physical,
> > > > +			xhead.fmh_keys[1].fmr_length,
> > > > +			xhead.fmh_keys[1].fmr_owner,
> > > > +			xhead.fmh_keys[1].fmr_offset,
> > > > +			xhead.fmh_keys[1].fmr_flags);
> > > > +
> > > 
> > > Hmm.. could we combine these into one call that looks like:
> > > 
> > > 	trace_xfs_getfsmap(mp, &fmh_keys[0], &fmh_keys[1]);
> > > 
> > > ... and has the trace handler pull the relevant data out of the key
> > > structure (same comment for the similar trace_xfs_fsmap*())?
> > 
> > I'd prefer to leave it as-is, because passing struct xfs_fsmap into a
> > tracepoint requires every file that includes xfs_trace.h to also include
> > xfs_fsmap.h to get the structure definition.
> > 
> 
> I think you can get around that with a structure declaration in
> xfs_trace.h, as the only code that actually requires the full definition
> is xfs_trace.c. If that works, that could at least reduce the tracepoint
> calls to a couple lines of code, even if we retain the independent
> low/high key tp's.

But then we'd have two definitions of the same structure, and anyone
touching xfs_fsmap would have to remember to update both.  I think it's
fine to pass pointers to core libxfs/*format.h structures directly into
tracepoints, but fsmap is on the periphery.

> > For debugging I also prefer only logging one big structure per
> > tracepoint, though I'm more willing to combine the two into one big
> > trace.  Also, as far as trace reporting goes, what do you think of:
> > 
> > xfs_io-1441  [002]  2363.403451: xfs_getfsmap_low_key: dev 8:80 keydev 0:0 block 0 len 0 owner 0 offset 0 flags 0x0
> > xfs_io-1441  [002]  2363.403521: xfs_getfsmap_high_key: dev 8:80 keydev 4095:1048575 block 36028797018963967 len 0 owner -1 offset 36028797018963967 flags 0xffffffff
> > 
> > versus:
> > 
> > xfs_io-1441  [002]  2363.403451: xfs_getfsmap_key: dev 8:80 lkeydev 0:0 lblock 0 llen 0 lowner 0 loffset 0 lflags 0x0 hkeydev 4095:1048575 hblock 36028797018963967 hlen 0 howner -1 hoffset 36028797018963967 hflags 0xffffffff
> > 
> > It's harder for me to dig through the second version of that for the
> > high key data since the column offset of hkeydev depends on the low key
> > contents.
> > 
> 
> Ok, seems reasonable. I guess I try to think of tracepoints as more
> event oriented than data oriented, but they're still just tracepoints so
> no big deal.
> 
> > > > +	info.mp = ip->i_mount;
> > > > +	info.data = ((__force struct fsmap_head *)arg)->fmh_recs;
> > > > +	error = xfs_getfsmap(ip->i_mount, &xhead, xfs_getfsmap_format, &info);
> > > > +	if (error == XFS_BTREE_QUERY_RANGE_ABORT) {
> > > > +		error = 0;
> > > > +		aborted = true;
> > > > +	} else if (error)
> > > > +		return error;
> > > > +
> > > > +	/* If we didn't abort, set the "last" flag in the last fmx */
> > > > +	if (!aborted && xhead.fmh_entries) {
> > > > +		info.data--;
> > > > +		info.last_flags |= FMR_OF_LAST;
> > > 
> > > Isn't this kind of implied by a short return? It looks like if a real
> > > error occurs at any point during the search, we just return the error. I
> > > guess there is still the case where the remaining mappings exactly match
> > > the number of entries in the data structure passed in and you'd have to
> > > make another call to identify EOF.
> > 
> > Yep.
> > 
> > > If we do want the flag, I'm also wondering why we couldn't stuff it in
> > > oflags in the header. Is there some reason I'm not yet aware of why we
> > > want the LAST flag in the flags of the last entry?
> > 
> > Basically I'm copying the LAST flag from fiemap/bmapx, for which you
> > could make the same argument.  I'm trying to mirror the same semantics
> > and the same meaning. :)
> > 
> 
> Ok, kind of figured that since bmap has the similar flag. I just wanted
> to bring it up because it looks like we require some roundabout support
> code to actually place it into the record flags after the fact. I
> suppose this is more of an API design matter anyways.

Yeah, it's tricky to reason around this because I'm not really familiar
with the reasons why those other ioctls have LAST flags.  I too figure
that the implementations either fill up the buffer to the maximum extent
possible or return an error.

--D

> 
> Brian
> 
> > ATM the sole real user of OF_LAST is scrub, which during the data block
> > verification phase will use the flag as a shortcut for "ok, this is the
> > last rmap entry we're going to see; kick off any IO that we've queued
> > but were holding onto just in case the next extent is contiguous".
> > 
> > The OF_LAST flag applies to just that last fsmap record, so (at least
> > in my mind) it belongs in the fsmap record, not the fsmap header.
> > Also, from the perspective of a userspace iterator of the fsmap data,
> > the iterator function would have to know that "OH_LAST means that I need
> > to communicate last-record status to the function I'm being passed, but
> > the fsmap record does not itself have a last flag, so lastness becomes a
> > second out-of-band parameter".  Easier just to build it into the
> > specific record it applies to.
> > 
> > xfs_scrub could get by without the flag at all, I suppose.
> > 
> > Thanks for working on the review, I really appreciate it. :)
> > 
> > --D
> > 
> > > Brian
> > > 
> > > > +		if (copy_to_user(&info.data->fmr_flags, &info.last_flags,
> > > > +				sizeof(info.last_flags)))
> > > > +			return -EFAULT;
> > > > +	}
> > > > +
> > > > +	/* copy back header */
> > > > +	head.fmh_entries = xhead.fmh_entries;
> > > > +	head.fmh_oflags = xhead.fmh_oflags;
> > > > +	if (copy_to_user(arg, &head, sizeof(struct fsmap_head)))
> > > > +		return -EFAULT;
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  int
> > > >  xfs_ioc_swapext(
> > > >  	xfs_swapext_t	*sxp)
> > > > @@ -1787,6 +1887,9 @@ xfs_file_ioctl(
> > > >  	case XFS_IOC_GETBMAPX:
> > > >  		return xfs_ioc_getbmapx(ip, arg);
> > > >  
> > > > +	case FS_IOC_GETFSMAP:
> > > > +		return xfs_ioc_getfsmap(ip, arg);
> > > > +
> > > >  	case XFS_IOC_FD_TO_HANDLE:
> > > >  	case XFS_IOC_PATH_TO_HANDLE:
> > > >  	case XFS_IOC_PATH_TO_FSHANDLE: {
> > > > diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> > > > index 7c49938..fa0bc4d 100644
> > > > --- a/fs/xfs/xfs_ioctl32.c
> > > > +++ b/fs/xfs/xfs_ioctl32.c
> > > > @@ -20,6 +20,7 @@
> > > >  #include <linux/mount.h>
> > > >  #include <linux/slab.h>
> > > >  #include <linux/uaccess.h>
> > > > +#include <linux/fsmap.h>
> > > >  #include "xfs.h"
> > > >  #include "xfs_fs.h"
> > > >  #include "xfs_format.h"
> > > > @@ -554,6 +555,7 @@ xfs_file_compat_ioctl(
> > > >  	case XFS_IOC_GOINGDOWN:
> > > >  	case XFS_IOC_ERROR_INJECTION:
> > > >  	case XFS_IOC_ERROR_CLEARALL:
> > > > +	case FS_IOC_GETFSMAP:
> > > >  		return xfs_file_ioctl(filp, cmd, p);
> > > >  #ifndef BROKEN_X86_ALIGNMENT
> > > >  	/* These are handled fine if no alignment issues */
> > > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > > index d3d11905..125d568 100644
> > > > --- a/fs/xfs/xfs_trace.h
> > > > +++ b/fs/xfs/xfs_trace.h
> > > > @@ -3270,6 +3270,91 @@ DEFINE_INODE_IREC_EVENT(xfs_swap_extent_rmap_remap);
> > > >  DEFINE_INODE_IREC_EVENT(xfs_swap_extent_rmap_remap_piece);
> > > >  DEFINE_INODE_ERROR_EVENT(xfs_swap_extent_rmap_error);
> > > >  
> > > > +/* fsmap traces */
> > > > +DECLARE_EVENT_CLASS(xfs_fsmap_class,
> > > > +	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_agnumber_t agno,
> > > > +		 xfs_fsblock_t bno, xfs_filblks_t len, __uint64_t owner,
> > > > +		 __uint64_t offset),
> > > > +	TP_ARGS(mp, keydev, agno, bno, len, owner, offset),
> > > > +	TP_STRUCT__entry(
> > > > +		__field(dev_t, dev)
> > > > +		__field(dev_t, keydev)
> > > > +		__field(xfs_agnumber_t, agno)
> > > > +		__field(xfs_fsblock_t, bno)
> > > > +		__field(xfs_filblks_t, len)
> > > > +		__field(__uint64_t, owner)
> > > > +		__field(__uint64_t, offset)
> > > > +	),
> > > > +	TP_fast_assign(
> > > > +		__entry->dev = mp->m_super->s_dev;
> > > > +		__entry->keydev = new_decode_dev(keydev);
> > > > +		__entry->agno = agno;
> > > > +		__entry->bno = bno;
> > > > +		__entry->len = len;
> > > > +		__entry->owner = owner;
> > > > +		__entry->offset = offset;
> > > > +	),
> > > > +	TP_printk("dev %d:%d keydev %d:%d agno %u bno %llu len %llu owner %lld offset 0x%llx\n",
> > > > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > > > +		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
> > > > +		  __entry->agno,
> > > > +		  __entry->bno,
> > > > +		  __entry->len,
> > > > +		  __entry->owner,
> > > > +		  __entry->offset)
> > > > +)
> > > > +#define DEFINE_FSMAP_EVENT(name) \
> > > > +DEFINE_EVENT(xfs_fsmap_class, name, \
> > > > +	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_agnumber_t agno, \
> > > > +		 xfs_fsblock_t bno, xfs_filblks_t len, __uint64_t owner, \
> > > > +		 __uint64_t offset), \
> > > > +	TP_ARGS(mp, keydev, agno, bno, len, owner, offset))
> > > > +DEFINE_FSMAP_EVENT(xfs_fsmap_low_key);
> > > > +DEFINE_FSMAP_EVENT(xfs_fsmap_high_key);
> > > > +DEFINE_FSMAP_EVENT(xfs_fsmap_mapping);
> > > > +
> > > > +DECLARE_EVENT_CLASS(xfs_getfsmap_class,
> > > > +	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_daddr_t block,
> > > > +		 xfs_daddr_t len, __uint64_t owner, __uint64_t offset,
> > > > +		 __uint64_t flags),
> > > > +	TP_ARGS(mp, keydev, block, len, owner, offset, flags),
> > > > +	TP_STRUCT__entry(
> > > > +		__field(dev_t, dev)
> > > > +		__field(dev_t, keydev)
> > > > +		__field(xfs_daddr_t, block)
> > > > +		__field(xfs_daddr_t, len)
> > > > +		__field(__uint64_t, owner)
> > > > +		__field(__uint64_t, offset)
> > > > +		__field(__uint64_t, flags)
> > > > +	),
> > > > +	TP_fast_assign(
> > > > +		__entry->dev = mp->m_super->s_dev;
> > > > +		__entry->keydev = new_decode_dev(keydev);
> > > > +		__entry->block = block;
> > > > +		__entry->len = len;
> > > > +		__entry->owner = owner;
> > > > +		__entry->offset = offset;
> > > > +		__entry->flags = flags;
> > > > +	),
> > > > +	TP_printk("dev %d:%d keydev %d:%d block %llu len %llu owner %lld offset %llu flags 0x%llx\n",
> > > > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > > > +		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
> > > > +		  __entry->block,
> > > > +		  __entry->len,
> > > > +		  __entry->owner,
> > > > +		  __entry->offset,
> > > > +		  __entry->flags)
> > > > +)
> > > > +#define DEFINE_GETFSMAP_EVENT(name) \
> > > > +DEFINE_EVENT(xfs_getfsmap_class, name, \
> > > > +	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_daddr_t block, \
> > > > +		 xfs_daddr_t len, __uint64_t owner, __uint64_t offset, \
> > > > +		 __uint64_t flags), \
> > > > +	TP_ARGS(mp, keydev, block, len, owner, offset, flags))
> > > > +DEFINE_GETFSMAP_EVENT(xfs_getfsmap_low_key);
> > > > +DEFINE_GETFSMAP_EVENT(xfs_getfsmap_high_key);
> > > > +DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
> > > > +
> > > >  #endif /* _TRACE_XFS_H */
> > > >  
> > > >  #undef TRACE_INCLUDE_PATH
> > > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > > index 70f42ea..a280e12 100644
> > > > --- a/fs/xfs/xfs_trans.c
> > > > +++ b/fs/xfs/xfs_trans.c
> > > > @@ -263,6 +263,28 @@ xfs_trans_alloc(
> > > >  }
> > > >  
> > > >  /*
> > > > + * Create an empty transaction with no reservation.  This is a defensive
> > > > + * mechanism for routines that query metadata without actually modifying
> > > > + * them -- if the metadata being queried is somehow cross-linked (think a
> > > > + * btree block pointer that points higher in the tree), we risk deadlock.
> > > > + * However, blocks grabbed as part of a transaction can be re-grabbed.
> > > > + * The verifiers will notice the corrupt block and the operation will fail
> > > > + * back to userspace without deadlocking.
> > > > + *
> > > > + * Note the zero-length reservation; this transaction MUST be cancelled
> > > > + * without any dirty data.
> > > > + */
> > > > +int
> > > > +xfs_trans_alloc_empty(
> > > > +	struct xfs_mount		*mp,
> > > > +	struct xfs_trans		**tpp)
> > > > +{
> > > > +	struct xfs_trans_res		resv = {0};
> > > > +
> > > > +	return xfs_trans_alloc(mp, &resv, 0, 0, XFS_TRANS_NO_WRITECOUNT, tpp);
> > > > +}
> > > > +
> > > > +/*
> > > >   * Record the indicated change to the given field for application
> > > >   * to the file system's superblock when the transaction commits.
> > > >   * For now, just store the change in the transaction structure.
> > > > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > > > index 61b7fbd..98024cb 100644
> > > > --- a/fs/xfs/xfs_trans.h
> > > > +++ b/fs/xfs/xfs_trans.h
> > > > @@ -159,6 +159,8 @@ typedef struct xfs_trans {
> > > >  int		xfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
> > > >  			uint blocks, uint rtextents, uint flags,
> > > >  			struct xfs_trans **tpp);
> > > > +int		xfs_trans_alloc_empty(struct xfs_mount *mp,
> > > > +			struct xfs_trans **tpp);
> > > >  void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
> > > >  
> > > >  struct xfs_buf	*xfs_trans_get_buf_map(struct xfs_trans *tp,
> > > > 
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
