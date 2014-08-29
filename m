Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8917C7FAD
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 18:55:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5B2C2304066
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 16:55:46 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Sps1PqFmVaENtIse for <xfs@oss.sgi.com>;
	Fri, 29 Aug 2014 16:55:40 -0700 (PDT)
Date: Sat, 30 Aug 2014 09:55:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: storage, libaio, or XFS problem?  3.4.26
Message-ID: <20140829235538.GF20518@dastard>
References: <3fe8c34c0ccbbd720015d273fa2b8b30@localhost>
	<20140826075345.GJ20518@dastard>
	<8c29baf987467a84f0b7c1d09c863662@localhost>
	<20140828003226.GO20518@dastard>
	<7f9e5aef187b44e899077467aeb0809d@localhost>
	<20140828230817.GU20518@dastard>
	<2d2ce7bb38c00a7d35f4a324f6a36cbb@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2d2ce7bb38c00a7d35f4a324f6a36cbb@localhost>
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

On Fri, Aug 29, 2014 at 11:38:16AM -0500, Stan Hoeppner wrote:
> On Fri, 29 Aug 2014 09:08:17 +1000, Dave Chinner <david@fromorbit.com>
> wrote:
> > On Thu, Aug 28, 2014 at 05:31:33PM -0500, Stan Hoeppner wrote:
> >> On Thu, 28 Aug 2014 10:32:27 +1000, Dave Chinner <david@fromorbit.com>
> >> wrote:
> >> > On Tue, Aug 26, 2014 at 12:19:43PM -0500, Stan Hoeppner wrote:
> >> >> Aug 25 23:05:39 Anguish-ssu-1 kernel: [22409.328839] XFS (sdd):
> >> >> xfs_do_force_shutdown(0x8) called from line 3732 of file
> >> >> fs/xfs/xfs_bmap.c.
> >> >> Return address = 0xffffffffa01cc9a6
> >> > 
> >> > Yup, that's kinda important. That's from xfs_bmap_finish(), and
> >> > freeing an extent has failed and triggered SHUTDOWN_CORRUPT_INCORE
> >> > which it's found some kind of inconsistency in the free space
> >> > btrees. So, likely the same problem that caused EFI recovery to fail
> >> > on the other volume.
> >> > 
> >> > Are the tests being run on newly made filesystems? If not, have
> >> > these filesystems had xfs_repair run on them after a failure?  If
> >> > so, what is the error that is fixed? If not, does repairing the
> >> > filesystem make the problem go away?
> >> 
> >> Newly made after every error of any kind, whether app, XFS shutdown,
> call
> >> trace, etc.  I've not attempted xfs_repair.
> > 
> > Please do.
> 
> Another storage crash yesterday.  xfs_repair output inline below for the 7
> filesystems.  I'm also pasting the dmesg output.  This time there is no
> oops, no call traces.  The filesystems mounted fine after mounting,
> replaying, and repairing. 

Ok, what version of xfs_repair did you use?

> > The bug? The bleeding edge storage arrays being used had had a
> > firmware bug in it.  When the number of outstanding IOs hit the
> > *array controller* command tag queue depth limit (some several
> > thousand simultaneous IOs in flight) it would occasionally misdirect
> > a single write IO to the *wrong lun*.  i.e. it would misdirect a
> > write.
> > 
> > It was only under *extreme* loads that this would happen, and it's
> > this sort of load that AIO+DIO can easily generate - you can have
> > several thousand IOs in flight without too much hassle, and that
> > will hit limits in the storage arrays that aren't often hit.  Array
> > controller CTQ depth limits are a good example of a limit that
> > normal IO won't go near to stressing.
> 
> I hadn't considered that up to this point.  That is *very* insightful, and
> applicable, since we are dealing with a beta storage array and firmware. 
> Worth mentioning is that the storage vendor has added a custom routine
> which expends Herculean effort to identify full stripes before writeback. 

Hmmmm. Food for thought, especially as it is evident that the
storage array appears to be crashing completely. At this point,
I'd say the burden of finding a corruption needs to start with
proving that the array is has not done something wrong. Once you
know that what is on disk is exactly what the filesystem asked to be
written, then you can start to isolate filesystem issues. But you
need the storage to be solid and trust-worthy before going looking
for filesystem problems....

> This because some of our writes for a given low rate stream are as low as
> 32KB and may be 2-3 seconds apart.  With a 64-128KB chunk, 768 to 1536KB
> stripe width, we'd get massive RMW without this feature.  Testing thus far
> shows it is fairly effective, though we still get pretty serious RMW due to
> the fact we're writing 350 of these small streams per array at ~72 KB/s
> max, along with 2 streams at ~48 MB/s, and and 50 streams at ~1.2 MB/s. 
> Multiply this by 7 LUNs per controller and it becomes clear we're putting a
> pretty serious load on the firmware and cache.

Yup, so having the array cache do the equivalent of sequential
readahead multi-stream detection for writeback would make a big
difference. But not simple to do....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
