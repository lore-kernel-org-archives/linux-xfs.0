Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751487AbeENK01 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 May 2018 06:26:27 -0400
Date: Mon, 14 May 2018 06:26:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 8/8] xfs: teach xfs_bmapi_remap to accept some bmapi flags
Message-ID: <20180514102625.GB8919@bfoster.bfoster>
References: <152597988038.25215.9276761144353662866.stgit@magnolia>
 <152597993604.25215.2923117604057991749.stgit@magnolia>
 <20180511152026.GI105683@bfoster.bfoster>
 <20180511231403.GJ11261@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180511231403.GJ11261@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, May 11, 2018 at 04:14:03PM -0700, Darrick J. Wong wrote:
> On Fri, May 11, 2018 at 11:20:27AM -0400, Brian Foster wrote:
> > On Thu, May 10, 2018 at 12:18:56PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Teach xfs_bmapi_remap how to map in unwritten extent and to skip rmap
> > > updates.  This enables us to rebuild real and unwritten extents from the
> > > rmapbt.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_bmap.c |    9 +++++++--
> > >  1 file changed, 7 insertions(+), 2 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > index b63e15a114f3..7660efb5beb0 100644
> > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > @@ -4543,7 +4543,9 @@ xfs_bmapi_remap(
> > >  	ASSERT(len > 0);
> > >  	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
> > >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > > -	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK)));
> > > +	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC |
> > > +			   XFS_BMAPI_NORMAP)));
> > > +	ASSERT(!(flags & XFS_BMAPI_ATTRFORK) || !(flags & XFS_BMAPI_PREALLOC));
> > 
> > A little confusing.. how about something like?
> > 
> > 	ASSERT((flags & XFS_BMAPI_ATTRFORK|XFS_BMAPI_PREALLOC) !=
> > 		XFS_BMAPI_ATTRFORK|XFS_BMAPI_PREALLOC);
> 
> Ok.
> 
> > >  
> > >  	if (unlikely(XFS_TEST_ERROR(
> > >  	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> > > @@ -4581,7 +4583,10 @@ xfs_bmapi_remap(
> > >  	got.br_startoff = bno;
> > >  	got.br_startblock = startblock;
> > >  	got.br_blockcount = len;
> > > -	got.br_state = XFS_EXT_NORM;
> > > +	if (flags & XFS_BMAPI_PREALLOC)
> > > +		got.br_state = XFS_EXT_UNWRITTEN;
> > > +	else
> > > +		got.br_state = XFS_EXT_NORM;
> > 
> > It's hard to see the wider picture without any users of this, but I do
> > notice that the one current caller appears to have everything passed
> > down to it to construct an xfs_bmbt_irec (in fact the data appears to
> > come from an irec in the first place).
> 
> Later on in the online repair series (which I will send out after the
> review for this series concludes) I'll make use of xfs_bmapi_remap to
> reconstruct the bmbt from the rmap, which is why I've been busy adding
> BMAPI_ATTRFORK, BMAPI_NORMAP, and BMAPI_PREALLOC to this function.
> 
> This patch[1] in my branch demonstrates the new uses of this function.
> 

Thanks. FWIW, this caller also looks like it ultimately passes down data
from an xfs_bmbt_irec. Perhaps this or some of the others would need a
local copy of the record to handle incremental/partial calls as such,
but I wonder how much code would be cleaned out by just passing down an
irec directly rather than unrolling the fields and turning it back into
an xfs_bmbt_irec in xfs_bmapi_remap(). But that's a cleanup for another
patch...

Brian

> --D
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=djwong-devel&id=7d8601ba8a938179ec0dae18b8a0848122eaf5e5
> 
> > Brian
> > 
> > >  
> > >  	error = xfs_bmap_add_extent_hole_real(tp, ip, whichfork, &icur,
> > >  			&cur, &got, &firstblock, dfops, &logflags, flags);
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
