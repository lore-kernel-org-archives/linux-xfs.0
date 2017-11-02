Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53340 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933371AbdKBQyV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 12:54:21 -0400
Date: Thu, 2 Nov 2017 12:54:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/18] xfs: pass an on-disk extent to
 xfs_bmbt_validate_extent
Message-ID: <20171102165419.GG16645@bfoster.bfoster>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-2-hch@lst.de>
 <20171031175311.GC7093@bfoster.bfoster>
 <20171031211520.GI4911@magnolia>
 <20171101135855.GA11709@bfoster.bfoster>
 <20171101230024.GF4922@magnolia>
 <20171102115710.GB15748@bfoster.bfoster>
 <20171102160505.GR4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102160505.GR4911@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Nov 02, 2017 at 09:05:05AM -0700, Darrick J. Wong wrote:
> On Thu, Nov 02, 2017 at 07:57:11AM -0400, Brian Foster wrote:
> > On Wed, Nov 01, 2017 at 04:00:24PM -0700, Darrick J. Wong wrote:
> > > On Wed, Nov 01, 2017 at 09:58:55AM -0400, Brian Foster wrote:
> > > > On Tue, Oct 31, 2017 at 02:15:20PM -0700, Darrick J. Wong wrote:
> > > > > On Tue, Oct 31, 2017 at 01:53:12PM -0400, Brian Foster wrote:
> > > > > > On Tue, Oct 31, 2017 at 04:22:13PM +0200, Christoph Hellwig wrote:
> > > > > > > This prepares for getting rid of the current in-memory extent format.
> > > > > > > 
> > > > > > 
> > > > > > Couldn't we port this function over to use whatever the new in-memory
> > > > > > extent format is? IOW, just have the helper check for XFS_EXT_UNWRITTEN
> > > > > > rather than the associated bit in the on-disk format..?
> > > > > 
> > > > > It's certainly possible, but in general verifiers are supposed to check
> > > > > on-disk metadata before they end up in-core, and this would seem to get
> > > > > us closer to that, right?
> > > > > 
> > > > 
> > > > Yeah, but are any of these calls actually made in a buffer verifier
> > > > path?
> > > 
> > > No.  They probably ought to be -- we can add them to the bmbt verifier and
> > > the inode fork verifier (in the magical future when those exist :P), but
> > > for now I think xfs_iread_extents is the closest we come to an "obvious"
> > > place where we load disk data into/out of its in-core representation.
> > > 
> > 
> > Ok.. I agree that verifiers are intended to check on-disk format, but I
> > still don't see how that design aspect of buffer verifiers really has
> > much bearing on this function given how it is currently used. This
> > particular block has already passed the associated buffer verifier.
> > Also, do we have any verifiers that consider fork state?
> 
> Nope.  Thinking about this a little more, the only check we care about
> wrt the bmbt records is that the unwritten flag can't be set on an attr
> fork.  We don't have enough context to know that in the buffer verifier,
> but we do know that when we're loading up the incore extent map, so we
> can at least catch that problem there.
> 
> (Similarly, the bmbt btree code has a similar layering violation in that
> we can only check bb_owner from xfs_btree_cursor context, but since we
> also have no way to push such context through to the buffer layer we're
> stuck with that for now.)
> 
> > If the goal is to check the on-disk record, perhaps at least that part
> > of this check (associated with the extent flag bit(s)) should be moved
> > to the verifier? Even with doing that, it seems there still may be a
> > need for a higher level sanity check based on the fork, and I don't see
> > any reason why that necessarily needs to use the on-disk value as
> > opposed to the in-core value. *shrug* Not that big of a deal though..
> 
> <shrug> Same feeling here.  TBH I wonder about how costly those
> unaligned be64 accesses are on things like sparc such that we should
> minimize the number of calls and just check the (probably aligned)
> incore version instead...
> 

I'm not totally sure.. I guess it's potentially a function call where an
immediate memory copy would suffice..? Anyways, that's pretty much what
caused the function to stand out to me as starting to look a little too
busy/ugly for its own good. We now have a validation helper that has to
handle unaligned accesses because its caller may or may not refer to
unaligned memory. It's not even totally clear to me when we can expect
the memory to be unaligned.. when we're referring to an on-disk inode
fork?

So rather than start to propagate that logic, much more clean to me is
to do the unaligned accesses only where necessary and fix up the error
checks to examine the read values. I don't see any logical difference
between checking the bit vs. the extent state since the unwritten bit
basically maps directly to XFS_EXT_UNWRITTEN/XFS_EXT_NORM in the incore
record.

Brian

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
> > > > > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > > > > ---
> > > > > > >  fs/xfs/libxfs/xfs_bmap.c       | 6 +++---
> > > > > > >  fs/xfs/libxfs/xfs_bmap_btree.h | 4 ++--
> > > > > > >  fs/xfs/libxfs/xfs_inode_fork.c | 9 ++++-----
> > > > > > >  3 files changed, 9 insertions(+), 10 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > > > > > index f45f05c45e15..b2b6832b9e6b 100644
> > > > > > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > > > > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > > > > > @@ -1259,14 +1259,14 @@ xfs_iread_extents(
> > > > > > >  		frp = XFS_BMBT_REC_ADDR(mp, block, 1);
> > > > > > >  		for (j = 0; j < num_recs; j++, i++, frp++) {
> > > > > > >  			xfs_bmbt_rec_host_t *trp = xfs_iext_get_ext(ifp, i);
> > > > > > > -			trp->l0 = be64_to_cpu(frp->l0);
> > > > > > > -			trp->l1 = be64_to_cpu(frp->l1);
> > > > > > > -			if (!xfs_bmbt_validate_extent(mp, whichfork, trp)) {
> > > > > > > +			if (!xfs_bmbt_validate_extent(mp, whichfork, frp)) {
> > > > > > >  				XFS_ERROR_REPORT("xfs_bmap_read_extents(2)",
> > > > > > >  						 XFS_ERRLEVEL_LOW, mp);
> > > > > > >  				error = -EFSCORRUPTED;
> > > > > > >  				goto out_brelse;
> > > > > > >  			}
> > > > > > > +			trp->l0 = be64_to_cpu(frp->l0);
> > > > > > > +			trp->l1 = be64_to_cpu(frp->l1);
> > > > > > >  			trace_xfs_read_extent(ip, i, state, _THIS_IP_);
> > > > > > >  		}
> > > > > > >  		xfs_trans_brelse(tp, bp);
> > > > > > > diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
> > > > > > > index 6f891eeb88f6..2fbfe2a24b15 100644
> > > > > > > --- a/fs/xfs/libxfs/xfs_bmap_btree.h
> > > > > > > +++ b/fs/xfs/libxfs/xfs_bmap_btree.h
> > > > > > > @@ -127,9 +127,9 @@ extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
> > > > > > >   * Check that the extent does not contain an invalid unwritten extent flag.
> > > > > > >   */
> > > > > > >  static inline bool xfs_bmbt_validate_extent(struct xfs_mount *mp, int whichfork,
> > > > > > > -		struct xfs_bmbt_rec_host *ep)
> > > > > > > +		struct xfs_bmbt_rec *ep)
> > > > > > >  {
> > > > > > > -	if (ep->l0 >> (64 - BMBT_EXNTFLAG_BITLEN) == 0)
> > > > > > > +	if (get_unaligned_be64(&ep->l0) >> (64 - BMBT_EXNTFLAG_BITLEN) == 0)
> > > > > > >  		return true;
> > > > > > >  	if (whichfork == XFS_DATA_FORK &&
> > > > > > >  	    xfs_sb_version_hasextflgbit(&mp->m_sb))
> > > > > > > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > > > > > > index bb63f38b97cc..abe601b48c9c 100644
> > > > > > > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > > > > > > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > > > > > > @@ -371,13 +371,13 @@ xfs_iformat_extents(
> > > > > > >  		dp = (xfs_bmbt_rec_t *) XFS_DFORK_PTR(dip, whichfork);
> > > > > > >  		for (i = 0; i < nex; i++, dp++) {
> > > > > > >  			xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
> > > > > > > -			ep->l0 = get_unaligned_be64(&dp->l0);
> > > > > > > -			ep->l1 = get_unaligned_be64(&dp->l1);
> > > > > > > -			if (!xfs_bmbt_validate_extent(mp, whichfork, ep)) {
> > > > > > > +			if (!xfs_bmbt_validate_extent(mp, whichfork, dp)) {
> > > > > > >  				XFS_ERROR_REPORT("xfs_iformat_extents(2)",
> > > > > > >  						 XFS_ERRLEVEL_LOW, mp);
> > > > > > >  				return -EFSCORRUPTED;
> > > > > > >  			}
> > > > > > > +			ep->l0 = get_unaligned_be64(&dp->l0);
> > > > > > > +			ep->l1 = get_unaligned_be64(&dp->l1);
> > > > > > >  			trace_xfs_read_extent(ip, i, state, _THIS_IP_);
> > > > > > >  		}
> > > > > > >  	}
> > > > > > > @@ -764,8 +764,6 @@ xfs_iextents_copy(
> > > > > > >  	for (i = 0; i < nrecs; i++) {
> > > > > > >  		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
> > > > > > >  
> > > > > > > -		ASSERT(xfs_bmbt_validate_extent(ip->i_mount, whichfork, ep));
> > > > > > > -
> > > > > > >  		start_block = xfs_bmbt_get_startblock(ep);
> > > > > > >  		if (isnullstartblock(start_block)) {
> > > > > > >  			/*
> > > > > > > @@ -779,6 +777,7 @@ xfs_iextents_copy(
> > > > > > >  		/* Translate to on disk format */
> > > > > > >  		put_unaligned_be64(ep->l0, &dp->l0);
> > > > > > >  		put_unaligned_be64(ep->l1, &dp->l1);
> > > > > > > +		ASSERT(xfs_bmbt_validate_extent(ip->i_mount, whichfork, dp));
> > > > > > >  
> > > > > > >  		dp++;
> > > > > > >  		copied++;
> > > > > > > -- 
> > > > > > > 2.14.2
> > > > > > > 
> > > > > > > --
> > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > --
> > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
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
