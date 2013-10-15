Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 14D437F3F
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 16:47:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BF8DE304039
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 14:47:38 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	t7E1io9ntLpf0grp for <xfs@oss.sgi.com>;
	Tue, 15 Oct 2013 14:47:37 -0700 (PDT)
Date: Wed, 16 Oct 2013 08:47:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: fold xfs_change_file_space into xfs_ioc_space
Message-ID: <20131015214733.GW4446@dastard>
References: <20131012075503.370510641@bombadil.infradead.org>
	<20131012075640.637625757@bombadil.infradead.org>
	<20131014050807.GJ4446@dastard>
	<20131015153143.GA1612@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131015153143.GA1612@infradead.org>
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

On Tue, Oct 15, 2013 at 08:31:43AM -0700, Christoph Hellwig wrote:
> On Mon, Oct 14, 2013 at 04:08:07PM +1100, Dave Chinner wrote:
> > One question, though:
> > 
> > > +	case XFS_IOC_ALLOCSP:
> > > +	case XFS_IOC_ALLOCSP64:
> > > +	case XFS_IOC_FREESP:
> > > +	case XFS_IOC_FREESP64:
> > 
> > Should we, at this point, mark these ioctls as deprecated and
> > schedule then for removal given that we've recommended against using
> > them for the past 10 years and we have fallocate() now?
> 
> I don't see any reason to remove them given that it's only about 15
> extra lines of code.  But if you care enough to get rid of them we
> probably need multiple years of actuall warnings emmited when used
> before actually removing them.  I would be very surprised if there
> aren't same users that wouldn't argue very vocally against their
> removal.

I'll put a significant quantity of beer on the table if anyone other
than xfstests is actually using these ioctls. In all my years of
working with XFS, I've never seen a single user of them, even on
Irix.

The one person I know who was considering using XFS_IOC_ALLOCSP
convinced me (quite easily) to implement XFS_IOC_ZERO_RANGE for them
because writing all those zeros to re-initialise pre-allocated VM
images was going to be prohibitively expensive...

Anyway, it was just a thought.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
