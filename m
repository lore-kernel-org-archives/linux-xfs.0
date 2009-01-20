Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0KNORFi024099 for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 17:24:28 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6DE13182CD39
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 15:24:26 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	C473Tf6VLzkkfVWF for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2009 15:24:26 -0800 (PST)
Date: Wed, 21 Jan 2009 10:24:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090120232422.GF10158@disturbed>
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
	<20090113214949.GN8071@disturbed>
	<Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com>
	<20090118173144.GA1999@infradead.org>
	<Pine.LNX.4.64.0901201430250.4603@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901201430250.4603@hs20-bc2-1.build.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

On Tue, Jan 20, 2009 at 02:38:27PM -0500, Mikulas Patocka wrote:
> 
> 
> On Sun, 18 Jan 2009, Christoph Hellwig wrote:
> 
> > On Tue, Jan 13, 2009 at 11:28:58PM -0500, Mikulas Patocka wrote:
> > > The result must not depend on magic timer values. If it does, you end up 
> > > with undebbugable nondeterministic failures.
> > > 
> > > Why don't you change that 500ms wait to "wait until the flush finishes"? 
> > > That would be correct.
> > 
> > Yes, this probably would better.  Could I motivate you to come up with
> > a patch for that?
> > 
> 
> Hi
> 
> I looked at the source and found out that it uses sync_blockdev for 
> syncing --- but sync_blockdev writes only metadata buffers, it doesn't 
> touch inodes and pages and doesn't resolve delayed allocations. So it 
> really doesn't sync anything.

Ah, bugger. Thanks for finding this.

> I replaced it with correct syncing of all inodes. With this patch it 
> passes my testcase (no more spurious -ENOSPCs), but it still isn't 
> correct, there is that 500ms delay --- if the machine was so overloaded 
> that it couldn't sync withing 500ms, you still get spurious -ENOSPC.

That's VFS level data syncing - there may be other XFS level stuff
that can be dones as well (e.g. cleanup/truncate of unlinked inodes)
that will release space.

> There are notions about possible deadlocks (the syncer may lock against 
> the process that is waiting for the sync to finish), that's why removing 
> that 500ms delay isn't that easy as it seems. I don't have XFS knowledge 
> to check for the deadlocks, it should be done by XFS developers. Also, 
> when you resolve the deadlocks and drop the timeout, replace WB_SYNC_NONE 
> with WB_SYNC_ALL in this patch.

Right, so you need to use internal xfs sync functions that don't
have these problems. That is:

	error = xfs_sync_inodes(ip->i_mount, SYNC_DELWRI|SYNC_WAIT);

will do a blocking flush of all the inodes without deadlocks occurring.
Then you can remove the 500ms wait.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
