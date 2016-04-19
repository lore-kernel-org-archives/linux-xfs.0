Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F38E7CA0
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2016 17:32:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F363A304032
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2016 15:32:18 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	fwAGeezR9lYYIPUE for <xfs@oss.sgi.com>;
	Tue, 19 Apr 2016 15:32:16 -0700 (PDT)
Date: Wed, 20 Apr 2016 08:30:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: Don't wrap growfs AGFL indexes
Message-ID: <20160419223058.GC18517@dastard>
References: <1459836310-12619-1-git-send-email-david@fromorbit.com>
	<1459836310-12619-2-git-send-email-david@fromorbit.com>
	<20160407235043.GB1439@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160407235043.GB1439@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Apr 07, 2016 at 04:50:43PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 05, 2016 at 04:05:07PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Commit 96f859d ("libxfs: pack the agfl header structure so
> > XFS_AGFL_SIZE is correct") allowed the freelist to use the empty
> > slot at the end of the freelist on 64 bit systems that was not
> > being used due to sizeof() rounding up the structure size.
> > 
> > This has caused versions of xfs_repair prior to 4.5.0 (which also
> > has the fix) to report this as a corruption once the filesystem has
> > been grown. Older kernels can also have problems (seen from a whacky
> > container/vm management environment) mounting filesystems grown on a
> > system with a newer kernel than the vm/container it is deployed on.
> > 
> > To avoid this problem, change the initial free list indexes not to
> > wrap across the end of the AGFL, hence avoiding the initialisation
> > of agf_fllast to the last index in the AGFL.
> 
> I have to admit that it's been a while that I looked at the AGFL
> code, but I simply don't understand what's happening in this patch.
> Diff slightly reorder:
> 
> > -		agf->agf_flfirst = 0;
> > +		agf->agf_flfirst = cpu_to_be32(1);
> 
> So flfirst moves from 0 to 1.
> 
> > -		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
> > +		agf->agf_fllast = 0;
> 
> And last from size - 1 to 0.  In my naive reading this introduces
> wrapping and doesn't remove it.  What do I miss?

Nothing, my mistake. In doing a driveby fix, I mistook the list to
be ordered like:

       fllast
          |
 +--------oooooo--------+
               |
	    flfirst

When in fact the active entries are the other way around:

       flfirst
          |
 +--------oooooo--------+
               |
	    fllast

IOWs, I got confused by the fact the list grows from the "last"
pointer and shrinks at the "first" pointer. i.e the "last" index is
always ahead of the "first" index, which is directly contradictory
to their names. These are head and tail indexes, not first and
last.

        tail
          |
 +--------oooooo--------+
               |
	     head

Get from tail, put to head.

I think we need to rework this whole agfl size fix (as djwong
mentioned after we discussed it on IRC) so this needs reworking,
anyway.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
