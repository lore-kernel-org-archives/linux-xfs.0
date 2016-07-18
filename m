Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DFC6F7CA0
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2016 20:21:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 586B1AC003
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2016 18:21:32 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	n2CinRfOLOeEOzxk for <xfs@oss.sgi.com>;
	Sun, 17 Jul 2016 18:21:25 -0700 (PDT)
Date: Mon, 18 Jul 2016 11:21:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 044/119] xfs: propagate bmap updates to rmapbt
Message-ID: <20160718012122.GA1922@dastard>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612655409.12839.4069768871045909071.stgit@birch.djwong.org>
	<20160715183356.GD55338@bfoster.bfoster>
	<20160716072621.GC21529@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160716072621.GC21529@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Sat, Jul 16, 2016 at 12:26:21AM -0700, Darrick J. Wong wrote:
> On Fri, Jul 15, 2016 at 02:33:56PM -0400, Brian Foster wrote:
> > On Thu, Jun 16, 2016 at 06:22:34PM -0700, Darrick J. Wong wrote:
> > > When we map, unmap, or convert an extent in a file's data or attr
> > > fork, schedule a respective update in the rmapbt.  Previous versions
> > > of this patch required a 1:1 correspondence between bmap and rmap,
> > > but this is no longer true.
> > > 
> > > v2: Remove the 1:1 correspondence requirement now that we have the
> > > ability to make interval queries against the rmapbt.  Update the
> > > commit message to reflect the broad restructuring of this patch.
> > > Fix the bmap shift code to adjust the rmaps correctly.
> > > 
> > > v3: Use the deferred operations code to handle redo operations
> > > atomically and deadlock free.  Plumb in all five rmap actions
> > > (map, unmap, convert extent, alloc, free); we'll use the first
> > > three now for file data, and reflink will want the last two.
> > > Add an error injection site to test log recovery.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
.....
> > > + * superblock and the AGF because we'll always grab them in the same
> > > + * order.
> > > + */
> > > +int
> > > +xfs_rmap_finish_one(
> > > +	struct xfs_trans		*tp,
> > > +	enum xfs_rmap_intent_type	type,
> > > +	__uint64_t			owner,
> > > +	int				whichfork,
> > > +	xfs_fileoff_t			startoff,
> > > +	xfs_fsblock_t			startblock,
> > > +	xfs_filblks_t			blockcount,
> > > +	xfs_exntst_t			state,
> > > +	struct xfs_btree_cur		**pcur)
> > > +{
> > > +	struct xfs_mount		*mp = tp->t_mountp;
> > > +	struct xfs_btree_cur		*rcur;
> > > +	struct xfs_buf			*agbp = NULL;
> > > +	int				error = 0;
> > > +	xfs_agnumber_t			agno;
> > > +	struct xfs_owner_info		oinfo;
> > > +	xfs_agblock_t			bno;
> > > +	bool				unwritten;
> > > +
> > > +	agno = XFS_FSB_TO_AGNO(mp, startblock);
> > > +	ASSERT(agno != NULLAGNUMBER);
> > > +	bno = XFS_FSB_TO_AGBNO(mp, startblock);
> > > +
> > > +	trace_xfs_rmap_deferred(mp, agno, type, bno, owner, whichfork,
> > > +			startoff, blockcount, state);
> > > +
> > > +	if (XFS_TEST_ERROR(false, mp,
> > > +			XFS_ERRTAG_RMAP_FINISH_ONE,
> > > +			XFS_RANDOM_RMAP_FINISH_ONE))
> > > +		return -EIO;
> > > +
> > > +	/*
> > > +	 * If we haven't gotten a cursor or the cursor AG doesn't match
> > > +	 * the startblock, get one now.
> > > +	 */
> > > +	rcur = *pcur;
> > > +	if (rcur != NULL && rcur->bc_private.a.agno != agno) {
> > > +		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
> > > +		rcur = NULL;
> > > +		*pcur = NULL;
> > > +	}
> > > +	if (rcur == NULL) {
> > > +		error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
> > 
> > Comment? Why is this here? (Maybe we should rename that function while
> > we're at it..)
> 
> /*
>  * Ensure the freelist is of a sufficient length to provide for any btree
>  * splits that could happen when we make changes to the rmapbt.
>  */
> 
> (I don't know why the function has that name; Dave supplied it.)

I named it that way because it was common code factored out of
xfs_free_extent() for use by multiple callers on the extent freeing
side of things. Feel free to name it differently if you can think of
something more appropriate.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
