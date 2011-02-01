Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p11N1nEs249545 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 17:01:49 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87E4F4D91D5
	for <xfs@oss.sgi.com>; Tue,  1 Feb 2011 15:04:16 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	HeRMejZiufQlMBe3 for <xfs@oss.sgi.com>;
	Tue, 01 Feb 2011 15:04:16 -0800 (PST)
Date: Wed, 2 Feb 2011 10:04:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS internal error xfs_iformat(realtime) even after xfs_repair.
Message-ID: <20110201230413.GN11040@dastard>
References: <AANLkTin=nqXCVJRgqBuTDx6nxMx1GLiG2DortJG+pz2L@mail.gmail.com>
	<20110118045730.GU28803@dastard>
	<AANLkTikc-_dZvpu6Yb-FNJVVWqhmsC4OgVZ8gj0mRx-y@mail.gmail.com>
	<AANLkTimuB71cTrW3gsSPq=HhFgHC=5xCZAMMxNE97F06@mail.gmail.com>
	<20110201041202.GL11040@dastard>
	<20110201212832.GA1836@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110201212832.GA1836@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Ajeet Yadav <ajeet.yadav.77@gmail.com>, xfs@oss.sgi.com

On Tue, Feb 01, 2011 at 04:28:32PM -0500, Christoph Hellwig wrote:
> > It will be in the next release, whenever we make that.
> > 
> > I've got to finish of the sync of the userspace/kernel code, there's
> > a few fixes already in the -dev branch as well, we need to pick up
> > the FIEMAP changes to xfs_io, and so on. We probably should get t???is
> > all done and plan for a new release in the next few weeks...
> 
> I'm a bit concerned about the coverage of the libxfs resync.  My
> preference would be to get out a minor release focusses at the repair
> fixes, then merge the resync to master directly after release and make
> sure it gets into all the test setups for a while before it gets
> released.

Sure, I have no problem with that - this is the first mention of a
new release and I was just mentioning everything that is happening
at the moment. Doing a point release with all the known
fixes before the large sync makes sense...

Cheers,

dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
