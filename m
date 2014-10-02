Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1444C7F4E
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 16:05:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E7F8B8F8064
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 14:05:32 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gQNy4l1pjOwiIgmU for <xfs@oss.sgi.com>;
	Thu, 02 Oct 2014 14:05:27 -0700 (PDT)
Date: Fri, 3 Oct 2014 07:05:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: preadv2/pwritev2 updates
Message-ID: <20141002210525.GB12693@dastard>
References: <1412197494-7655-1-git-send-email-hch@lst.de>
	<20141001222637.GU4758@dastard> <20141002113123.GB32112@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141002113123.GB32112@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, Milosz Tanski <milosz@adfin.com>, xfs@oss.sgi.com

On Thu, Oct 02, 2014 at 01:31:23PM +0200, Christoph Hellwig wrote:
> On Thu, Oct 02, 2014 at 08:26:37AM +1000, Dave Chinner wrote:
> > On Wed, Oct 01, 2014 at 11:04:51PM +0200, Christoph Hellwig wrote:
> > > Hi Miklos,
> > > 
> > > attached are the patches that go on top of your
> > > "[RFC v3 0/4] vfs: Non-blockling buffered fs read (page cache only)"
> > > series.  The first one adds RWF_NONBLOCK to XFS, the other two
> > > add a new RWF_DSYNC flag that adds a per-operation O_DSYNC flag.
> > 
> > Christoph, any plans to add these new syscalls to xfs_io and
> > data integrity tests for the new RWF_DSYNC flag?
> 
> I've got some hacked up xfs_io support, but Milosz was planning a
> slight revision of the syscall interface that I'm still waiting for.
> 
> How would you want to automatically test for data integrity?  That requires
> a powerfail or crash unfortunately and we don't have good infrastructure
> for that yet.  I've tested it by adding a printk that RWF_DSYNC triggers
> the same code path as O_DSYNC.

We have the infrastructure in xfstests to do this in a generic way:
use dm-flakey.  The fsync tests (generic/311, generic/32[23]) that
Josef wrote that use dm-flakey to prevent writes after the IOs have
completed and check that the data is there after remount.

Similarly, for xfs specific tests we have older tests that use the
shutdown ioctl (e.g. xfs/137-139) by using the godown function to
shut the filesystem down and prevent unmount from writing metadata.
On remount the data should be present.

So there's a couple of different ways you can do this...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
