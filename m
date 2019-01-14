Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35664 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726595AbfANPe0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jan 2019 10:34:26 -0500
Date: Mon, 14 Jan 2019 10:34:23 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: validate writeback mapping using data fork seq
 counter
Message-ID: <20190114153422.GA3148@bfoster>
References: <20190111123032.31538-1-bfoster@redhat.com>
 <20190111123032.31538-4-bfoster@redhat.com>
 <20190113214905.GB4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190113214905.GB4205@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 14, 2019 at 08:49:05AM +1100, Dave Chinner wrote:
> On Fri, Jan 11, 2019 at 07:30:31AM -0500, Brian Foster wrote:
> > The writeback code caches the current extent mapping across multiple
> > xfs_do_writepage() calls to avoid repeated lookups for sequential
> > pages backed by the same extent. This is known to be slightly racy
> > with extent fork changes in certain difficult to reproduce
> > scenarios. The cached extent is trimmed to within EOF to help avoid
> > the most common vector for this problem via speculative
> > preallocation management, but this is a band-aid that does not
> > address the fundamental problem.
> > 
> > Now that we have an xfs_ifork sequence counter mechanism used to
> > facilitate COW writeback, we can use the same mechanism to validate
> > consistency between the data fork and cached writeback mappings. On
> > its face, this is somewhat of a big hammer approach because any
> > change to the data fork invalidates any mapping currently cached by
> > a writeback in progress regardless of whether the data fork change
> > overlaps with the range under writeback. In practice, however, the
> > impact of this approach is minimal in most cases.
> > 
> > First, data fork changes (delayed allocations) caused by sustained
> > sequential buffered writes are amortized across speculative
> > preallocations. This means that a cached mapping won't be
> > invalidated by each buffered write of a common file copy workload,
> > but rather only on less frequent allocation events. Second, the
> > extent tree is always entirely in-core so an additional lookup of a
> > usable extent mostly costs a shared ilock cycle and in-memory tree
> > lookup. This means that a cached mapping reval is relatively cheap
> > compared to the I/O itself. Third, spurious invalidations don't
> > impact ioend construction. This means that even if the same extent
> > is revalidated multiple times across multiple writepage instances,
> > we still construct and submit the same size ioend (and bio) if the
> > blocks are physically contiguous.
> > 
> > Update struct xfs_writepage_ctx with a new field to hold the
> > sequence number of the data fork associated with the currently
> > cached mapping. Check the wpc seqno against the data fork when the
> > mapping is validated and reestablish the mapping whenever the fork
> > has changed since the mapping was cached. This ensures that
> > writeback always uses a valid extent mapping and thus prevents lost
> > writebacks and stale delalloc block problems.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_aops.c  | 8 ++++++--
> >  fs/xfs/xfs_iomap.c | 4 ++--
> >  2 files changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index d9048bcea49c..33a1be5df99f 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -29,6 +29,7 @@
> >  struct xfs_writepage_ctx {
> >  	struct xfs_bmbt_irec    imap;
> >  	unsigned int		io_type;
> > +	unsigned int		data_seq;
> >  	unsigned int		cow_seq;
> >  	struct xfs_ioend	*ioend;
> >  };
> > @@ -347,7 +348,8 @@ xfs_map_blocks(
> >  	 * out that ensures that we always see the current value.
> >  	 */
> >  	imap_valid = offset_fsb >= wpc->imap.br_startoff &&
> > -		     offset_fsb < wpc->imap.br_startoff + wpc->imap.br_blockcount;
> > +		     offset_fsb < wpc->imap.br_startoff + wpc->imap.br_blockcount &&
> > +		     wpc->data_seq == READ_ONCE(ip->i_df.if_seq);
> >  	if (imap_valid &&
> >  	    (!xfs_inode_has_cow_data(ip) ||
> >  	     wpc->io_type == XFS_IO_COW ||
> 
> I suspect this next "if (imap_valid) ..." logic needs to be updated,
> too. i.e. the next line is checking if the cow_seq has not changed.
> 

I'm not quite sure what you're getting at here. By "next," do you mean
the one you've quoted or the post-lock cycle check (a re-check at the
latter point makes sense to me). Otherwise the imap check is
intentionally distinct from the COW seq check because these control
independent bits of subsequent logic (in certain cases).

That said, now that I look at it again this logic is rather convoluted
because imap_valid doesn't necessarily refer to the data fork (e.g., if
->imap is a cow fork extent). So yeah, this all should probably be
refactored...

> i.e. I think wrapping this up in a helper (again!) might make more
> sense:
> 
> static bool
> xfs_imap_valid(
> 	struct xfs_inode	*ip,
> 	struct xfs_writepage_ctx *wpc,
> 	xfs_fileoff_t		offset_fsb)
> {
> 	if (offset_fsb < wpc->imap.br_startoff)
> 		return false;
> 	if (offset_fsb >= wpc->imap.br_startoff + wpc->imap.br_blockcount)
> 		return false;
> 	if (wpc->data_seq != READ_ONCE(ip->i_df.if_seq)
> 		return false;
> 	if (!xfs_inode_has_cow_data(ip))
> 		return true;
> 	if (wpc->io_type != XFS_IO_COW)
> 		return true;
> 	if (wpc->cow_seq != READ_ONCE(ip->i_cowfp->if_seq)
> 		return false;
> 	return true;
> }
> 

I think you mean 'if (io_type == XFS_IO_COW)'? Otherwise this seems
reasonable, though I think the logic suffers a bit from the same problem
as above. How about with the following tweaks (and comments to try and
make this easier to follow)?

static bool
xfs_imap_valid()
{
	if (offset_fsb < wpc->imap.br_startoff)
		return false;
	if (offset_fsb >= wpc->imap.br_startoff + wpc->imap.br_blockcount)
		return false;
	/* a valid range is sufficient for COW mappings */
	if (wpc->io_type == XFS_IO_COW)
		return true;

	/*
	 * Not a COW mapping. Revalidate across changes in either the
	 * data or COW fork ...
	 */
	if (wpc->data_seq != READ_ONCE(ip->i_df.if_seq)
		return false;
	if (xfs_inode_has_cow_data(ip) &&
	    wpc->cow_seq != READ_ONCE(ip->i_cowfp->if_seq)
		return false;

	return true;
}

I think that technically we could skip the == XFS_IO_COW check and we'd
just be more conservative by essentially applying the same fork change
logic we are for the data fork, but that's not really the intent of this
patch.

> and then put the shutdown check before we check the map for validity
> (i.e. don't continue to write to the cached map after a shutdown has
> been triggered):
> 

Ack.

> 	if (XFS_FORCED_SHUTDOWN(mp))
> 		return -EIO;
> 
> 	if (xfs_imap_valid(ip, wpc, offset_fsb))
> 		return 0;
> 
> 
> > @@ -417,6 +419,7 @@ xfs_map_blocks(
> >  	 */
> >  	if (!xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &icur, &imap))
> >  		imap.br_startoff = end_fsb;	/* fake a hole past EOF */
> > +	wpc->data_seq = READ_ONCE(ip->i_df.if_seq);
> >  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> >  
> >  	if (imap.br_startoff > offset_fsb) {
> > @@ -454,7 +457,8 @@ xfs_map_blocks(
> >  	return 0;
> >  allocate_blocks:
> >  	error = xfs_iomap_write_allocate(ip, whichfork, offset, &imap,
> > -			&wpc->cow_seq);
> > +			whichfork == XFS_COW_FORK ?
> > +					 &wpc->cow_seq : &wpc->data_seq);
> >  	if (error)
> >  		return error;
> >  	ASSERT(whichfork == XFS_COW_FORK || cow_fsb == NULLFILEOFF ||
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index 27c93b5f029d..0401e33d4e8f 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -681,7 +681,7 @@ xfs_iomap_write_allocate(
> >  	int		whichfork,
> >  	xfs_off_t	offset,
> >  	xfs_bmbt_irec_t *imap,
> > -	unsigned int	*cow_seq)
> > +	unsigned int	*seq)
> >  {
> >  	xfs_mount_t	*mp = ip->i_mount;
> >  	struct xfs_ifork *ifp = XFS_IFORK_PTR(ip, whichfork);
> > @@ -798,7 +798,7 @@ xfs_iomap_write_allocate(
> >  				goto error0;
> >  
> >  			if (whichfork == XFS_COW_FORK)
> > -				*cow_seq = READ_ONCE(ifp->if_seq);
> > +				*seq = READ_ONCE(ifp->if_seq);
> >  			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >  		}
> 
> One of the things that limits xfs_iomap_write_allocate() efficiency
> is the mitigations for races against truncate. i.e. the huge comment that
> starts:
> 
> 	       /*
> 		* it is possible that the extents have changed since
> 		* we did the read call as we dropped the ilock for a
> 		* while. We have to be careful about truncates or hole
> 		* punchs here - we are not allowed to allocate
> 		* non-delalloc blocks here.
> ....
> 

Hmm, Ok... so this fix goes a ways back to commit e4143a1cf5 ("[XFS] Fix
transaction overrun during writeback."). It sounds like the issue was an
instance of the "attempt to convert delalloc blocks ends up doing
physical allocation" problem (which results in a transaction overrun).

> Now that we can detect that the extents have changed in the data
> fork, we can go back to allocating multiple extents per
> xfs_bmapi_write() call by doing a sequence number check after we
> lock the inode. If the sequence number does not match what was
> passed in or returned from the previous loop, we return -EAGAIN.
> 

I'm not familiar with this particular instance of this problem (we've
certainly had other instances of the same thing), but the surrounding
context of this code has changed quite a bit. Most notably is
XFS_BMAPI_DELALLOC, which was intended to mitigate this problem by
disallowing real allocation in such calls.

> Hmmm, looking at the existing -EAGAIN case, I suspect this isn't
> handled correctly by xfs_map_blocks() anymore. i.e. it just returns
> the error which can lead to discarding the page rather than checking
> to see if the there was a valid map allocated. I think there's some
> followup work here (another patch series). :/
> 

Ok. At the moment, that error looks like it should only happen if we're
past EOF..? Either way, the XFS_BMAPI_DELALLOC thing still can result in
an error so it probably makes sense to tie a seqno check to -EAGAIN and
handle it properly in the caller.

Hmm, given that we can really only handle one extent at a time up
through the caller (as also noted in the big comment you quoted) and
that this series introduces more aggressive revalidation as it is, I am
wondering what real value there is in doing more delalloc conversions
here than technically required. ISTM that removing some of this i_size
checking code and doing the seqno based kickback may actually be
cleaner. I'll need to have a closer look from an optimization
perspective when the correctness issues are dealt with.

I also could have sworn I removed that whichfork check from
xfs_iomap_write_allocate(), but apparently not... ;P

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
