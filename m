Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43884 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750902AbdK2Ocl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Nov 2017 09:32:41 -0500
Date: Wed, 29 Nov 2017 09:32:40 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC 4/4] xfs: include an allocfree res for inobt
 modifications
Message-ID: <20171129143239.GE50847@bfoster.bfoster>
References: <20171127202434.43125-1-bfoster@redhat.com>
 <20171127202434.43125-5-bfoster@redhat.com>
 <20171127232719.GC5858@dastard>
 <20171128154922.GE45759@bfoster.bfoster>
 <20171128223445.GH5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171128223445.GH5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 29, 2017 at 09:34:45AM +1100, Dave Chinner wrote:
> On Tue, Nov 28, 2017 at 10:49:22AM -0500, Brian Foster wrote:
> > On Tue, Nov 28, 2017 at 10:27:19AM +1100, Dave Chinner wrote:
> > > On Mon, Nov 27, 2017 at 03:24:34PM -0500, Brian Foster wrote:
...
> > > Code looks fine. Comments below are for another follow-on patch.
> > > 
> > 
> > Actually, what do you think of the following variant (compile tested
> > only)? This facilites another cleanup patch I just wrote to kill off
> > about half of the (now effectively duplicate) xfs_calc_create_*()
> > helpers because the finobt and inode chunk res. helpers only include the
> > associated reservation based on the associated feature bits.
> 
> Yup, makes a lot of sense to do that.
> 
> FWIW, because we've got so many alloc vs free type reservations,
> would it make more sense to do something like:
> 
> #define _ALLOC	true
> #define _FREE	false
> 
> And use those in the callers rather than true/false?
> 
...
> > @@ -511,7 +542,7 @@ xfs_calc_ifree_reservation(
> >  		xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
> >  		xfs_calc_iunlink_remove_reservation(mp) +
> >  		xfs_calc_buf_res(1, 0) +
> > -		xfs_calc_buf_res(mp->m_ialloc_blks, 0) +
> > +		xfs_calc_inode_chunk_res(mp, false) +
> 
> 		xfs_calc_inode_chunk_res(mp, _FREE) +
> 		.....
> 
> That would make it very clear what type of reservation we are
> acutally expecting to take out in the calculation. i.e. the code
> is now clearly self documenting :)
> 

Sure, that looks like a nice enhancement. I'll factor that in..

Brian

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
