Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1860729DF8
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2014 22:55:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EC7258F8035
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2014 20:55:53 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	NjYMkycp5oAcmGTv for <xfs@oss.sgi.com>;
	Tue, 29 Apr 2014 20:55:51 -0700 (PDT)
Date: Wed, 30 Apr 2014 13:55:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 9/9] repair: detect and handle attribute tree CRC errors
Message-ID: <20140430035547.GB32204@dastard>
References: <1398719099-19194-1-git-send-email-david@fromorbit.com>
	<1398719099-19194-10-git-send-email-david@fromorbit.com>
	<20140429140651.GE59046@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140429140651.GE59046@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 29, 2014 at 10:06:51AM -0400, Brian Foster wrote:
> On Tue, Apr 29, 2014 at 07:04:59AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently the attribute code will not detect and correct errors in
> > the attribute tree. It also fails to validate the CRCs and headers
> > on remote attribute blocks. Ensure that all the attribute blocks are
> > CRC checked and that the processing functions understand the correct
> > block formats for decoding.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  repair/attr_repair.c | 45 +++++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 37 insertions(+), 8 deletions(-)
> > 
> > diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> > index ba85ac2..9b57960 100644
> > --- a/repair/attr_repair.c
> > +++ b/repair/attr_repair.c
> > @@ -604,6 +604,7 @@ verify_da_path(xfs_mount_t	*mp,
> >  			libxfs_putbuf(bp);
> >  			return(1);
> >  		}
> > +
> >  		/*
> >  		 * update cursor, write out the *current* level if
> >  		 * required.  don't write out the descendant level
> > @@ -615,6 +616,8 @@ verify_da_path(xfs_mount_t	*mp,
> >  			libxfs_writebuf(cursor->level[this_level].bp, 0);
> >  		else
> >  			libxfs_putbuf(cursor->level[this_level].bp);
> > +
> > +		/* switch cursor to point at the new buffer we just read */
> >  		cursor->level[this_level].bp = bp;
> >  		cursor->level[this_level].dirty = 0;
> >  		cursor->level[this_level].bno = dabno;
> > @@ -624,6 +627,14 @@ verify_da_path(xfs_mount_t	*mp,
> >  		cursor->level[this_level].n = newnode;
> >  #endif
> >  		entry = cursor->level[this_level].index = 0;
> > +
> > +		/*
> > +		 * We want to rewrite the buffer a CRC error seeing as it
> Nit:						^ "on a CRC error ..." ?

Will fix.

> > @@ -1555,7 +1584,7 @@ process_longform_attr(
> >  	case XFS_DA_NODE_MAGIC:		/* btree-form attribute */
> >  	case XFS_DA3_NODE_MAGIC:
> >  		/* must do this now, to release block 0 before the traversal */
> > -		if (repairlinks) {
> > +		if (*repair || repairlinks) {
> >  			*repair = 1;
> >  			libxfs_writebuf(bp, 0);
> >  		} else
> 
> repairlinks incorporates a !no_modify check, but *repair does not. It's
> incremented unconditionally if we find a CRC error. I suspect this means
> we now need a !no_modify check for the writebuf/putbuf check here, as is
> done in the alternate path at the end of the function.

I'll fix it. Christoph is right, we need a helper function for this.
Thanks!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
