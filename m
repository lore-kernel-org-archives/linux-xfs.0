Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o83DmF5x254235 for <xfs@oss.sgi.com>; Fri, 3 Sep 2010 08:48:15 -0500
Subject: Re: [PATCH] xfs: prevent 32bit overflow in space reservation
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100903000146.GA705@dastard>
References: <1283404663-28105-1-git-send-email-david@fromorbit.com>
	<1283442679.5727.35.camel@doink>  <20100903000146.GA705@dastard>
Date: Fri, 03 Sep 2010 08:48:03 -0500
Message-ID: <1283521683.3094.10.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, 2010-09-03 at 10:01 +1000, Dave Chinner wrote:
> On Thu, Sep 02, 2010 at 10:51:19AM -0500, Alex Elder wrote:
> > On Thu, 2010-09-02 at 15:17 +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > If we attempt to preallocate more than 2^32 blocks of space in a
. . .

> > > +		resblks = min_t(xfs_fileoff_t, (e - s), (MAXEXTLEN * nimaps));
> > 
> > I guess it's clear that MAXEXTLEN fits in 32 bits because of
> > sizeof (xfs_extlen_t).
> 
> True, but if sizeof(xfs_extlen_t) was the limiting factor,
> then the mulitply could still cause 32bit overflows.
> 
> The real reason is that MAXEXTLEN defines the maximum extent length
> supported by the on disk bmap btree record format. The record format
> defines the extent length in FSBs to be:
> 
> #define MAXEXTLEN       ((xfs_extlen_t)0x001fffff)      /* 21 bits */
> 
> and as such fits easily into the 32 bit limit.

Yes, I recognized that but didn't mention it.  However...

> > And inspection shows that nimaps is
> > just 1, so this does the 32-bit limiting.  But that just
> > seems indirect.
> 
> nimaps can be up to:
> 
> #define XFS_BMAP_MAX_NMAP 4

...I had not noticed that nimap could have been changed from
its value 1 by the xfs_bmapi() call, so the point you make is
important.

> So if we change the loop to do more allocations per loop, then
> the code will already handle it correctly. :)

Yes.  And like I said, just adjusting the comment explains
why it is safe.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
