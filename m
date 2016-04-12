Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B47F37CA0
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 20:16:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 64048304059
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 18:16:33 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id efxK50ijjAUMfb5x (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Apr 2016 18:16:30 -0700 (PDT)
Date: Mon, 11 Apr 2016 18:16:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: bmap btree changes should update rmap btree
Message-ID: <20160412011626.GA11156@birch.djwong.org>
References: <1459201425-31773-1-git-send-email-david@fromorbit.com>
	<20160411233407.GA7967@birch.djwong.org>
	<20160412000901.GI567@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160412000901.GI567@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <xfs@oss.sgi.com>

[should have kicked this onto the lists...]

(This is a thread that started from a reposting of one of the rmap patches
("xfs: bmap btree changes should update rmap btree"), with the change that
xfs_rmap_intent should use list_head instead of an open-coded list.)

On Tue, Apr 12, 2016 at 10:09:01AM +1000, Dave Chinner wrote:
> On Mon, Apr 11, 2016 at 04:34:07PM -0700, Darrick J. Wong wrote:
> > On Tue, Mar 29, 2016 at 08:43:45AM +1100, Dave Chinner wrote:
> > > From: "Darrick J. Wong" <darrick.wong@oracle.com>
> > > 
> > > Any update to a file's bmap should make the corresponding change to
> > > the rmapbt.  On a reflink filesystem, this is absolutely required
> > > because a given (file data) physical block can have multiple owners
> > > and the only sane way to find an rmap given a bmap is if there is a
> > > 1:1 correspondence.
> > > 
> > > (At some point we can optimize this for non-reflink filesystems
> > > because regular merge still works there.)
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_alloc.c |  73 +++++---
> > >  fs/xfs/libxfs/xfs_alloc.h |   3 +
> > >  fs/xfs/libxfs/xfs_rmap.c  | 467 +++++++++++++++++++++++++++++++++++++++++++++-
> > >  3 files changed, 512 insertions(+), 31 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > index 585ebfa..1d82e65 100644
> > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > @@ -2766,35 +2766,30 @@ error0:
> > >  	return error;
> > >  }
> > >  
> > > -/*
> > > - * Free an extent.
> > > - * Just break up the extent address and hand off to xfs_free_ag_extent
> > > - * after fixing up the freelist.
> > > - */
> > > -int				/* error */
> > > -xfs_free_extent(
> > > -	xfs_trans_t	*tp,	/* transaction pointer */
> > > -	xfs_fsblock_t	bno,	/* starting block number of extent */
> > > -	xfs_extlen_t	len,	/* length of extent */
> > > -	struct xfs_owner_info	*oinfo)	/* extent owner */
> > > +int
> > > +xfs_free_extent_fix_freelist(
> > > +	struct xfs_trans	*tp,
> > > +	xfs_agnumber_t		agno,
> > > +	xfs_agblock_t		agbno,
> > > +	xfs_extlen_t		len,
> > > +	struct xfs_buf		**agbp)
> > 
> > Does xfs_alloc_fix_freelist() need to have args.agbno set?  AFAICT it doesn't,
> > and the function works fine if we leave out agbno/len args and keep the
> > range checks in xfs_free_extent.
> 
> It doesn't right now, but it could conceivably be used as a target
> block for allocation that adds blocks to the free list. There are
> also other functions that the args are passed through to, so I'd
> prefer to have the agbno set than have code that assumes it is valid
> do something unexpected....
> 
> > OTOH maybe we want the checks to happen before we touch anything?
> 
> That too.
> 
> > > -	/* Not yet implemented, just cancel until implemented */
> > > +	struct xfs_rmap_intent	*free = NULL;
> > > +	struct xfs_btree_cur	*rcur = NULL;
> > > +	struct xfs_buf		*agbp = NULL;
> > > +	int			error = 0;
> > > +	xfs_agnumber_t		agno;
> > > +
> > > +	if (rlist->rl_count == 0)
> > > +		return 0;
> > > +
> > > +	/* sort the list into ascending AG order */
> > > +	list_sort(mp, &rlist->rl_list, xfs_rmap_free_list_cmp);
> > > +
> > > +	while (list_empty(&rlist->rl_list)) {
> .....
> > > @@ -599,7 +1059,6 @@ __xfs_rmap_add(
> > >  	*new = *ri;
> > >  	INIT_LIST_HEAD(&new->ri_list);
> > >  
> > > -	/* XXX: ordering will be needed */
> > >  	list_add(&new->ri_list, &rlist->rl_list);
> > 
> > This needs to be list_add_tail so that the rmap operations happen in order.
> 
> Ah, no, it doesn't. The list_sort() before we process it destroys
> any order we create here.

I think list_sort() is supposed to maintain list order if the compare fn
returns zero.  From lib/list_sort.c:

/*
<snip>
 * The comparison function @cmp must return a negative value if @a
 * should sort before @b, and a positive value if @a should sort after
 * @b. If @a and @b are equivalent, and their original relative
 * ordering is to be preserved, @cmp must return 0.
 */

>From my (admittedly flimsy) testing of list_sort() it looks like it does
preserve the order of rmap_intents that have the same agno.  I looked at
the source code and I think that assertion should hold.

I could be wrong about that, however...

> > If
> > we do a collapse range of 2 blocks at offset 32, say, then we end up with
> > unmap($pblk, $ino, 32, 16) and map($pblk-2, $ino, 30, 16) in the deferred list.
> > We don't want the map to happen before the unmap because that results in two
> > rmaps covering the same range of logical offset, which causes problems in
> > generic/145.

I forgot to mention this, but the ordering requirement only applies within a
single rmapbt -- if the map/unmap operations apply to different AGs, no
confusion will result from out-of-order execution.

> Then we have a problem here, because now you have two dimensions of
> ordering - by agno and by operational order. There were no comments
> about this list requiring operational ordering, so I didn't take
> that into account when changing the way this worked.

To be fair, the ordering requirement didn't exist until I got rid of the
'rmap mirrors bmbt' thing a couple of days ago.  I hadn't planned out how
this thing would work until after the last patch posting, so it's no wonder
that neither of us were aware. :)

> I'd suggest that the list_sort compare function could take this into
> account, and order overlapping operations appropriately (e.g. unmap
> before map). You could even put a sequence number in the rmap list
> entry so that when sorting we know what order they were added to the
> rmap list and then overlaps could be resolved in the sort function
> easily...

I /think/ we're fine with just the list_add_tail...

...if not, /me wonders if we could skip the list_sort and just roll the
transaction every time we have to go from a higher AG to a lower AG.  I think
the rmap update intent log items will help us to redo the metadata operations
if we crash.

<shrug> Doesn't /seem/ to be causing any extra problems with the test suite.
Anyway I'll keep squinting at list_sort.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
