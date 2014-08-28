Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 166247F3F
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 18:10:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 055028F8054
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 16:10:36 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	vFPHRZX4u6cAcH2U for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 16:10:34 -0700 (PDT)
Date: Fri, 29 Aug 2014 09:08:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: storage, libaio, or XFS problem?  3.4.26
Message-ID: <20140828230817.GU20518@dastard>
References: <3fe8c34c0ccbbd720015d273fa2b8b30@localhost>
	<20140826075345.GJ20518@dastard>
	<8c29baf987467a84f0b7c1d09c863662@localhost>
	<20140828003226.GO20518@dastard>
	<7f9e5aef187b44e899077467aeb0809d@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7f9e5aef187b44e899077467aeb0809d@localhost>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 28, 2014 at 05:31:33PM -0500, Stan Hoeppner wrote:
> On Thu, 28 Aug 2014 10:32:27 +1000, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Aug 26, 2014 at 12:19:43PM -0500, Stan Hoeppner wrote:
> >> Aug 25 23:05:39 Anguish-ssu-1 kernel: [22409.328839] XFS (sdd):
> >> xfs_do_force_shutdown(0x8) called from line 3732 of file
> >> fs/xfs/xfs_bmap.c.
> >> Return address = 0xffffffffa01cc9a6
> > 
> > Yup, that's kinda important. That's from xfs_bmap_finish(), and
> > freeing an extent has failed and triggered SHUTDOWN_CORRUPT_INCORE
> > which it's found some kind of inconsistency in the free space
> > btrees. So, likely the same problem that caused EFI recovery to fail
> > on the other volume.
> > 
> > Are the tests being run on newly made filesystems? If not, have
> > these filesystems had xfs_repair run on them after a failure?  If
> > so, what is the error that is fixed? If not, does repairing the
> > filesystem make the problem go away?
> 
> Newly made after every error of any kind, whether app, XFS shutdown, call
> trace, etc.  I've not attempted xfs_repair.

Please do.

> Part of the problem is the storage hardware is a moving target.
> They're swapping modules and upgrading firmware every few days.
> And I don't have a view into that.  So it's difficult to know when
> IO problems are due to hardware or buggy code.  However, I can
> state with certainty that we only run into the XFS problems when
> using AIO.  And it has occurred on both test rigs, each of which
> have their own RAID controllers and disks.

Which, in and of itself doesn't point at AIO or XFS being the
problem.  What is says is that something goes wrong under the
extremely high IO load that can be generated with AIO+DIO. That
"something" might be a race in XFS, a bug in AIO, or could be a
load related storage problem.

For example, I've been on the wrong end of hard to track down
problems on beta/early access storage before. For example there was
an incident years ago that took 3 more than 3 months to isolate a
filesystem corruption that occurred under high load. It took that
long to isolate a test case, reproduce it in house on identical
hardware, firmware, software, etc and then *capture it with a FC
analyser*.

The bug? The bleeding edge storage arrays being used had had a
firmware bug in it.  When the number of outstanding IOs hit the
*array controller* command tag queue depth limit (some several
thousand simultaneous IOs in flight) it would occasionally misdirect
a single write IO to the *wrong lun*.  i.e. it would misdirect a
write.

It was only under *extreme* loads that this would happen, and it's
this sort of load that AIO+DIO can easily generate - you can have
several thousand IOs in flight without too much hassle, and that
will hit limits in the storage arrays that aren't often hit.  Array
controller CTQ depth limits are a good example of a limit that
normal IO won't go near to stressing.

> >> update timestamps for inode 0xf000000a4
> >> Aug 25 23:05:49 Anguish-ssu-1 kernel: [22419.605835] XFS (sdd): failed
> to
> >> update timestamps for inode 0x2810f413c
> >> Aug 25 23:05:49 Anguish-ssu-1 kernel: [22419.606169] XFS (sdd): failed
> to
> >> update timestamps for inode 0x60000009f
> > 
> > And that is interesting. Makes me wonder if the inode is getting
> > unlocked on transaction commit failure, or whether there's some
> > other path in the shutdown code that is not unlocking the inode
> > correctly.
> 
> Is this a separate time stamp from that which noatime disables?  We're
> mounting with noatime, nodiratime.

Yes. mtime/ctime updates go through this on the write path.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
