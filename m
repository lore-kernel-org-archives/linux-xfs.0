Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752358AbdKVMVC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Nov 2017 07:21:02 -0500
Date: Wed, 22 Nov 2017 07:21:01 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: tr_ifree transaction log reservation calculation
Message-ID: <20171122122100.GA9984@bfoster.bfoster>
References: <20171121150557.GA5014@bfoster.bfoster>
 <0a9b47ba-a41e-3b96-981f-f04f9e2ab11c@hpe.com>
 <20171121173557.GB6004@bfoster.bfoster>
 <20171122022645.GR5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171122022645.GR5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Mark Tinguely <mark.tinguely@hpe.com>, linux-xfs@vger.kernel.org

On Wed, Nov 22, 2017 at 01:26:45PM +1100, Dave Chinner wrote:
> On Tue, Nov 21, 2017 at 12:35:57PM -0500, Brian Foster wrote:
> > cc linux-xfs
> > 
> > On Tue, Nov 21, 2017 at 10:51:10AM -0600, Mark Tinguely wrote:
> > > STATIC uint
> > > xfs_calc_ifree_reservation(
> > >         struct xfs_mount        *mp)
> > > {
> > >         return XFS_DQUOT_LOGRES(mp) +
> > >                 mp->m_sb.sb_inodesize +
> > >                 mp->m_sb.sb_sectsize +
> > >                 mp->m_sb.sb_sectsize +
> > >                 XFS_FSB_TO_B(mp, 1) +
> > >                 MAX((__uint16_t)XFS_FSB_TO_B(mp, 1),
> > >                     XFS_INODE_CLUSTER_SIZE(mp)) +
> > >                 128 * 5 +
> > >                 XFS_ALLOCFREE_LOG_RES(mp, 1) +
> > >                 128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
> > >                        XFS_ALLOCFREE_LOG_COUNT(mp, 1));
> > > }
> > > ...
> > 
> > Indeed, this looks fairly similar to the line cited above from the
> > current code (modulo the xfs_calc_buf_res() refactoring).
> 
> Right, the refactoring should have been a straight conversion of the
> code - and not change any of the reservations. If they were wrong
> before the refactoring, they will still be wrong now.
> 
> > I'm curious
> > why we only consider the buffer overhead (i.e., 128 bytes *
> > ->m_in_maxlevels) of the ->m_in_maxlevels value rather than the full
> > buffer size.
> 
> That just looks like a bug. Earlier on in the calculation we
> take into account:
> 
>  *    the inode btree entry: block size
> ....
> 		xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
> 
> So we've accounted for the AGI btree block the record being modified
> exists in. But we don't account for tree shape changes....
> 
> .... and, as usual, knowing the history of the code tells me the
> probable reason why the reservation is like this.
> 
> i.e. inodes could not be removed from disk when the original
> reservation was defined.  Once allocated, they never got
> removed, so an ifree transaction only ever touched the inode btree
> block the chunk record was in. So, a quick dive into history from
> the XFS archive with git blame:
> 

Ah, I wasn't aware of that. That definitely helps explain the current
reservation.

> 814994f5c75f6 (Adam Sweeney     1994-09-23  * In freeing an inode we can modify:
> 814994f5c75f6 (Adam Sweeney     1994-09-23  *    the inode being freed: inode size
> 814994f5c75f6 (Adam Sweeney     1994-09-23  *    the super block free inode counter: sector size
> 814994f5c75f6 (Adam Sweeney     1994-09-23  *    the agi hash list and counters: sector size
> 814994f5c75f6 (Adam Sweeney     1994-09-23  *    the inode btree entry: block size
> cd235688e046e (Adam Sweeney     1995-08-31  *    the on disk inode before ours in the agi hash list: inode cluster size
> 254f6311ed1b7 (Steve Lord       2003-10-06  *    the inode btree: max depth * blocksize
> 254f6311ed1b7 (Steve Lord       2003-10-06  *    the allocation btrees: 2 trees * (max depth - 1) * block size
> 814994f5c75f6 (Adam Sweeney     1994-09-23  */       
> d3c15dd08b409 (Russell Cattelan 2003-04-15 #define  XFS_CALC_IFREE_LOG_RES(mp) \
> 814994f5c75f6 (Adam Sweeney     1994-09-23  ((mp)->m_sb.sb_inodesize + \
> 814994f5c75f6 (Adam Sweeney     1994-09-23   (mp)->m_sb.sb_sectsize + \
> 814994f5c75f6 (Adam Sweeney     1994-09-23   (mp)->m_sb.sb_sectsize + \
> 814994f5c75f6 (Adam Sweeney     1994-09-23   XFS_FSB_TO_B((mp), 1) + \
> 0139225509eb1 (Steve Lord       2001-09-11   MAX((__uint16_t)XFS_FSB_TO_B((mp), 1), XFS_INODE_CLUSTER_SIZE(mp)) + \
> 254f6311ed1b7 (Steve Lord       2003-10-06   (128 * 5) + \
> 254f6311ed1b7 (Steve Lord       2003-10-06    (128 * (2 + XFS_IALLOC_BLOCKS(mp) + XFS_IN_MAXLEVELS(mp) + \
> 254f6311ed1b7 (Steve Lord       2003-10-06     XFS_ALLOCFREE_LOG_COUNT(mp, 1))))
> 254f6311ed1b7 (Steve Lord       2003-10-06           
> 
> Without even looking I know what those 2003 changes were. For
> everyone else:
> 
> 254f6311ed1b Implement deletion of inode clusters in XFS.
> 
> So, yeah, this looks like a bug in the original reservation
> calculation for freeing inode clusters. I suspect it got messed up
> because the buffers covering XFS_IALLOC_BLOCKS (the inode chunk) get
> marked stale and so their contents are not logged. That means just
> the header+blf is logged and so the reservation is correct for them.
> that isn't the case for the inobt blocks themselves, however.
> 

Yep, that's what I figured for ->m_ialloc_blks.

> i.e.  it should be calculating:
> 
> ....
>  *	the inode chunk blocks are stale, so only headers get logged
>  *	the inode btree: max depth * blocksize
> ....
> 	xfs_calc_buf_res(2 + mp->m_ialloc_blks, 0) +
> 	xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
> ....
> 

Sounds about right.. though I think we should also replace the old
single block reservation ("the inode btree entry: block size") as well
since that is now a subset of the m_in_maxlevels res.

> I'm still not 100% sure what the extra "2 +" is accounting for
> there, though, so to be safe that migh need to be accounted as full
> blocks, not log headers.
> 

Same.. there is still a bit of cruft in this calculation that really
isn't clear. That +2 is one part and then there's another
xfs_calc_buf_res(1, 0) right before the m_ialloc_blks line. The fact
that it's a separate line implies it is logically separate, but who
knows.

I suppose I'll keep that line as is, replace the inobt entry bit with
the full inobt calculation (as above), keep the +2 associated with the
inobt calculation and run some tests on that.

> Good find, Brian!
> 
> Of course, that doesn't mean it will fix the transaction overrun
> being reported because it's overrunning the freespace tree
> reservations rather than the inobt reservation. It certainly won't
> hurt, though. :P
> 

Right.. technically this is a separate issue but I actually think it may
end up resolving the overrun in most cases. I tested a quick hack to
change the 0 in the existing code to XFS_FSB_TO_B(mp, 1) before I
realized that the m_ialloc_blks part still needs to be separate. That
survived all my tests, but it's also larger than what we've settled on
here. I think the overrun has been within m_in_maxlevels blocks worth of
bytes in most cases. I do recall seeing occasional larger instances,
however, I just don't recall the exact numbers. I'll give this some
testing and see if we need to also bolt on some kind of agfl fixup
limit.

Thanks for the feedback!

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
