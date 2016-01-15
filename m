Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9B9577F47
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2016 16:50:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 771FF304053
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2016 14:50:50 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6v7LBkyl2vMbsEH4 for <xfs@oss.sgi.com>;
	Fri, 15 Jan 2016 14:50:47 -0800 (PST)
Date: Sat, 16 Jan 2016 09:50:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4] quota: add new quotactl Q_XGETQUOTA2
Message-ID: <20160115225022.GO6033@dastard>
References: <568FEA2C.6080708@redhat.com>
	<20160109072600.GA21636@infradead.org>
	<20160111132617.GD6262@quack.suse.cz>
	<5693D33A.5090307@sandeen.net>
	<20160111162807.GK6262@quack.suse.cz>
	<5696D27A.9070700@sandeen.net>
	<20160115093507.GA15950@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160115093507.GA15950@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>

On Fri, Jan 15, 2016 at 10:35:07AM +0100, Jan Kara wrote:
> On Wed 13-01-16 16:40:58, Eric Sandeen wrote:
> > Actually, that's exactly what I thought would *need* to happen ... we already
> > have this weird 15-year-old split-brain quota interface, so if xfs and ext4
> > both need the same functionality, then we'd probably add both GETQUOTA2 and
> > XGETQUOTA2.  If we were doing this all from scratch, sure, but adding a new
> > handles-both-quota-types interface when every other operation is already split
> > between the two almost seems to make matters worse.
> 
> Well, currently GETQUOTA and XGETQUOTA (and all the other quotactls) are
> actually translated so they work regardless of the underlying filesystem.
> So the only difference between XFS and VFS quotactls is in the formatting
> of input/output structures. So from kernel POV it seems somewhat pointless
> to add two calls doing the same thing and differing just in the formatting
> of output - especially when we want the call to be extensible.
> 
> I agree that having a unified call means having a new structure for passing
> dquot info between kernel and userspace. So just for adding that one small
> feature you want it seems like an overkill. But when thinking about new
> extensible getquota quotactl it IMHO makes sense to unify the VFS/XFS split
> brain. Thoughts?

A new unified userspace quota API would be nice, but it's a
completely separate piece of work. We'd also need to do userspace
work to support it, so I think this is a valid medium term goal,
but not somethign that should gate the work Eric is doing.

i.e. it might be best to introduce a quotactl2 syscall for a
unified interface, such that the syscall itself has a flags
argument rather than having to jump through hoops to embed flags
in argument structures.....

FWIW, converting xfs_quota to use a new kernel API is trivial (half
an hour's work) as it already has a kernel API abstraction layer for
cross platform support. Hence we can quickly get userspace support
in place to test such a new kernel API...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
