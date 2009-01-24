Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0O7Dc9F257539 for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 01:13:39 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16563B4049
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 23:12:54 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	8BAIjIl11pFpvYvx for <xfs@oss.sgi.com>;
	Fri, 23 Jan 2009 23:12:54 -0800 (PST)
Date: Sat, 24 Jan 2009 18:12:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090124071249.GF32390@disturbed>
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
	<20090113214949.GN8071@disturbed>
	<Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com>
	<20090118173144.GA1999@infradead.org>
	<Pine.LNX.4.64.0901201430250.4603@hs20-bc2-1.build.redhat.com>
	<20090120232422.GF10158@disturbed>
	<20090122205913.GA30859@infradead.org>
	<20090122224347.GA18751@infradead.org>
	<Pine.LNX.4.64.0901231509010.5179@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901231509010.5179@hs20-bc2-1.build.redhat.com>
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jan 23, 2009 at 03:14:30PM -0500, Mikulas Patocka wrote:
> 
> 
> On Thu, 22 Jan 2009, Christoph Hellwig wrote:
> 
> > On Thu, Jan 22, 2009 at 03:59:13PM -0500, Christoph Hellwig wrote:
> > > On Wed, Jan 21, 2009 at 10:24:22AM +1100, Dave Chinner wrote:
> > > > Right, so you need to use internal xfs sync functions that don't
> > > > have these problems. That is:
> > > > 
> > > > 	error = xfs_sync_inodes(ip->i_mount, SYNC_DELWRI|SYNC_WAIT);
> > > > 
> > > > will do a blocking flush of all the inodes without deadlocks occurring.
> > > > Then you can remove the 500ms wait.
> > > 
> > > I've given this a try with Eric's testcase from #724 in the oss bugzilla,
> > > but it's not enough yet.  I thinks that's because SYNC_WAIT is rather
> > > meaningless for data writeout, and we need SYNC_IOWAIT instead.  The
> > > patch below gets the testcase working for me:
> > 
> > Actually I still see failures happing sometimes.  I guess tha'ts because
> > our flush is still asynchronous due to the schedule_work..
> 
> If I placed
> xfs_sync_inodes(ip->i_mount, SYNC_DELWRI);
> xfs_sync_inodes(ip->i_mount, SYNC_DELWRI | SYNC_IOWAIT);
> directly to xfs_flush_device, I got lock dependency warning (though not a 
> real deadlock).

Same reason memory reclaim gives lockdep warnings on XFS - we're
recursing into operations that take inode locks while we currently
hold an inode lock.  However, it shouldn't deadlock because
we should ever try to take the iolock on the inode that we current
hold it on.

> So synchronous flushing definitely needs some thinking and lock 
> rearchitecting.

No, not at all. At most the grabbing of the iolock in
xfs_sync_inodes_ag() needs to become a trylock....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
