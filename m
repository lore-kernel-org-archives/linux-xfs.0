Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ED35C7F3F
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 18:27:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CBD69304053
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 16:27:30 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	R1fagY6WsF2bIolA for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 16:27:25 -0700 (PDT)
Date: Tue, 22 Apr 2014 09:27:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 9/9] repair: detect and handle attribute tree CRC errors
Message-ID: <20140421232723.GD18672@dastard>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-10-git-send-email-david@fromorbit.com>
	<20140416132503.GC4180@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140416132503.GC4180@laptop.bfoster>
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

On Wed, Apr 16, 2014 at 09:25:04AM -0400, Brian Foster wrote:
> On Tue, Apr 15, 2014 at 06:25:01PM +1000, Dave Chinner wrote:
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
> >  repair/attr_repair.c | 35 ++++++++++++++++++++++++++++-------
> >  1 file changed, 28 insertions(+), 7 deletions(-)
> > 
> > diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> > index ba85ac2..13ec90e 100644
> > --- a/repair/attr_repair.c
> > +++ b/repair/attr_repair.c
> > @@ -611,6 +611,8 @@ verify_da_path(xfs_mount_t	*mp,
> >  		ASSERT(cursor->level[this_level].dirty == 0 ||
> >  			(cursor->level[this_level].dirty && !no_modify));
> >  
> > +		if (bp->b_error == EFSBADCRC)
> > +			cursor->level[this_level].dirty++;
> 
> I was wondering why this wasn't checked closer to the readbuf call, then
> I noticed the assert. Any reason not to be consistent with the other
> changes, move this up closer to the call and nuke the assert?

Because I didn't want to modify the cursor state if the buffer
failed the basic checks (i.e. if (bad) {... return} branch was
taken) as if it is bad we aren't even going to try to repair it.
Hence marking it dirty for writeout when it might not even be an
attr block is probably a bad thing...

> >  		if (!bp) {
> >  			do_warn(
> >  	_("can't read file block %u (fsbno %" PRIu64 ") for attribute fork of inode %" PRIu64 "\n"),
> >  				da_bno, dev_bno, ino);
> >  			goto error_out;
> >  		}
> > +		if (bp->b_error == EFSBADCRC)
> > +			repair++;
> 
> Could you remind me why we only check EFSBADCRC in some places and
> EFSCORRUPTED as well in others?

Here we are checking and repairing the buffer, so EFSCORRUPTED
detection doesn't provide any value - if there is a corruption,
repair will already handle it and fix it. Hence this is here to
catch a buffer with a bad CRC but is otherwise good (e.g. bit error
in usused/unreferenced space in the metadata block).

> 
> >  
> >  		leaf = bp->b_addr;
> >  		xfs_attr3_leaf_hdr_from_disk(&leafhdr, leaf);
> > @@ -1382,9 +1401,9 @@ process_leaf_attr_level(xfs_mount_t	*mp,
> >  
> >  		current_hashval = greatest_hashval;
> >  
> > -		if (repair && !no_modify) 
> > +		if (repair && !no_modify)
> >  			libxfs_writebuf(bp, 0);
> > -		else 
> > +		else
> >  			libxfs_putbuf(bp);
> >  	} while (da_bno != 0);
> >  
> > @@ -1512,6 +1531,8 @@ process_longform_attr(
> >  			ino);
> >  		return(1);
> >  	}
> > +	if (bp->b_error == EFSBADCRC)
> > +		(*repair)++;
> 
> Note that repair is unconditionally reset to 0 at the beginning of
> process_leaf_attr_block() (in the XFS_ATTR_LEAF_MAGIC case further down
> this function).

Oh, so it is. I missed that. Good catch! Will fix.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
