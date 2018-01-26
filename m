Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42609 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751531AbeAZNJP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Jan 2018 08:09:15 -0500
Date: Fri, 26 Jan 2018 08:02:16 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 04/11] xfs: CoW fork operations should only update
 quota reservations
Message-ID: <20180126130215.GA47923@bfoster.bfoster>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676030319.12349.11227408793644481553.stgit@magnolia>
 <20180125012035.GE9068@magnolia>
 <20180125130352.GB43198@bfoster.bfoster>
 <20180125182003.GH9068@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180125182003.GH9068@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 25, 2018 at 10:20:03AM -0800, Darrick J. Wong wrote:
> On Thu, Jan 25, 2018 at 08:03:53AM -0500, Brian Foster wrote:
> > On Wed, Jan 24, 2018 at 05:20:35PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Since the CoW fork only exists in memory, it is incorrect to update the
> > > on-disk quota block counts when we modify the CoW fork.  Unlike the data
> > > fork, even real extents in the CoW fork are only reservations (on-disk
> > > they're owned by the refcountbt) so they must not be tracked in the on
> > > disk quota info.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > > v2: make documentation more crisp and to the point
> > > ---
> > >  fs/xfs/libxfs/xfs_bmap.c |  118 ++++++++++++++++++++++++++++++++++++++++++----
> > >  fs/xfs/xfs_quota.h       |   14 ++++-
> > >  fs/xfs/xfs_reflink.c     |    8 ++-
> > >  3 files changed, 122 insertions(+), 18 deletions(-)
> > > 
...
> > > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > > index 82abff6..e367351 100644
> > > --- a/fs/xfs/xfs_reflink.c
> > > +++ b/fs/xfs/xfs_reflink.c
> > > @@ -599,10 +599,6 @@ xfs_reflink_cancel_cow_blocks(
> > >  					del.br_startblock, del.br_blockcount,
> > >  					NULL);
> > >  
> > > -			/* Update quota accounting */
> > > -			xfs_trans_mod_dquot_byino(*tpp, ip, XFS_TRANS_DQ_BCOUNT,
> > > -					-(long)del.br_blockcount);
> > > -
> > >  			/* Roll the transaction */
> > >  			xfs_defer_ijoin(&dfops, ip);
> > >  			error = xfs_defer_finish(tpp, &dfops);
> > > @@ -795,6 +791,10 @@ xfs_reflink_end_cow(
> > >  		if (error)
> > >  			goto out_defer;
> > >  
> > > +		/* Charge this new data fork mapping to the on-disk quota. */
> > > +		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
> > > +				(long)del.br_blockcount);
> > > +
> > 
> > Should this technically be XFS_TRANS_DQ_DELBCOUNT? The blocks obviously
> > aren't delalloc and this transaction doesn't make a quota reservation so
> > I don't think it screws up accounting. But if the transaction did make a
> > quota reservation, it seems like this would account the extent against
> > the tx reservation where it instead should recognize that cow blocks
> > have already been reserved (which is essentially what DELBCOUNT means,
> > IIUC).
> 
> Hmmm, there's a subtlety here -- we're opencoding what DELBCOUNT does,
> because the subsequent xfs_bmap_del_extent_cow unconditionally reduces
> the in-core reservation after we've mapped in the extent as if it had
> been accounted as a real extent all along.  But considering all the
> blather about how cow fork blocks are treated as incore reservations, it
> does look funny, doesn't it?
> 

Ok.. I missed that the end/del cases were tied together, then reconfused
myself over the accounting in the end_cow() path (re: our irc chat
yesterday) when reassessing that bit. So to reset my brain, we have the
following with this current patch:

- cow reserve does a delalloc and in-core dquot reservation
- cow real alloc either skips dquot adjustment if wasdel, else reduces
  the quota res acquired by the transaction by the size of the alloc[1].
  Either way we leave around an in-core quota reservation as if the blocks
  remained delalloc.
- A cancel at this point simply kills the in-core dquot reservation
  along with the cow fork blocks.
- end_cow() unmaps the current data fork blocks and decrements
  associated real quota usage (tx), remaps the cow blocks and increments
  real quota usage (tx), then kills off the in-core dquot reservation.

[1] Would this even be necessary if we just acquired a delalloc like
reservation in xfs_reflink_allocate_cow() rather than associate the
reservation with the transaction in the first place (assuming we have
enough information to cover error handling, extent manipulations and
whatnot)?

When the tx commits, this essentially has the effect of applying the
bcount delta to both the on-disk dquot and the in-core res. The former
reflects the change in the file on-disk and the latter is rectified
because the field accounts for the current real usage plus outstanding
reservation. The original cowblocks res has been dropped directly, so
the bcount delta reflects the change to the data fork.

If we instead use delbcount in end_cow(), we're telling the transaction
to drop bcount by whatever old data fork blocks were removed and that
we've converted N delalloc (cow fork, actually) blocks that already had
in-core reservation. Therefore, transaction commit updates the on-disk
dquot just the same (-dataforkblocks + delallocblocks), but delbcount
blocks have already updated the in-core dquot res so the transaction has
nothing else to do there (and so we must also not remove that
reservation in del_cow()). This approach does seem like it requires a
bit less mental gymnastics to follow because it more closely resembles
delalloc quota accounting. ;)

Another thing that I'm not sure has been considered here is whether
doing the bcount delta in the transaction and dropping the cowblocks res
from the dquot directly leaves a race window where the quota can overrun
a limit. E.g., since the transaction has to up the in-core res in the
original example at commit time, is there anything that locks out
further external reservation from the dquot between the time the in-core
res is dropped and the transaction commits?

> So perhaps the solution is to pass intent into xfs_bmap_del_extent_cow:
> if we're calling it from _end_cow then we want to hang on to the
> reservation so that delbcount can do its thing, but if we're calling
> from _cancel_cow then we're dumping the extent and reservation.
> 

Indeed. But since those are the only callers and we'd already update
delbcount from end_cow(), could we not just lift the del_cow() decrement
into the cancel_cow() function? FWIW, some extra comments around quota
manipulation in the reflink functions would also be useful for future
reference.

Brian

> --D
> 
> > 
> > Other than that the code seems Ok to me.
> > 
> > Brian
> > 
> > >  		/* Remove the mapping from the CoW fork. */
> > >  		xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
> > >  
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
