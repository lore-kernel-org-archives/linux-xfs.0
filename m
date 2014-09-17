Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2B79B7F47
	for <xfs@oss.sgi.com>; Wed, 17 Sep 2014 01:03:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CAB1CAC008
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 23:03:05 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	S0VdHWZbekzbgJ9Z for <xfs@oss.sgi.com>;
	Tue, 16 Sep 2014 23:03:03 -0700 (PDT)
Date: Wed, 17 Sep 2014 16:02:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mkfs.xfs fails with raid5 and smaller chunk sizes
Message-ID: <20140917060249.GR4322@dastard>
References: <5418B39C.2060707@rincon.com> <20140916221738.GO4322@dastard>
	<5418BE0F.9040702@rincon.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5418BE0F.9040702@rincon.com>
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
To: Brian Hemme <bmh@rincon.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 16, 2014 at 03:47:43PM -0700, Brian Hemme wrote:
> On 09/16/2014 03:17 PM, Dave Chinner wrote:
> >On Tue, Sep 16, 2014 at 03:03:08PM -0700, Brian Hemme wrote:
> >>Hello all,
> >>
> >>I am having some odd problems with mkfs.xfs when used on a raid 5
> >>array.  The array is built from 6 960GB SSDs all connected to SATA
> >>ports on the MB and created with mdadm.  If I use a chunk size any
> >>smaller then 512K mkfs.xfs just hangs forever.  It continues to use
> >>CPU and so does the raid array but never completes.  If the system
> >>is just left running for an extended length of time the whole OS
> >>eventually locks up.  I have tried this on three different systems
> >>with the same results.   I have searched all over for someone with
> >>similar issues without success.  I am hoping I am just doing
> >>something clearly wrong and you all can set me straight quickly.
> >>
> >>Some specifics:
> >>     Arch linux with 3.14.1 kernel
> >>     mkfs.xfs version 3.1.11
> >>     mdadm - v3.3 - 3rd September 2013
> >>
> >>Commands:
> >>>mdadm --create /dev/md0 --chunk=64K --level=5 --raid-devices=6
> >>/dev/sd[a-f]
> >>>mkfs.xfs /dev/md0
> >>   ** This command fails and locks up
> >>
> >>I have tried specifying the arguments to mkfs.xfs with the same
> >>results.  Building a 4 drive array seems to require a chunk size of
> >>1M or greater to work.  Same results if I make a partition on the
> >>array and make the fs there.
> >mkfs.xfs really should only take a couple of seconds to complete.
> >Seeing as you are using SSDs, my first suspicion is that md or the
> >SSDs are having problems with discard. Hence you should first
> >try 'mkfs.xfs -K /dev/md0' and see if that completes quickly.
> >
> >Otherwise, output of 'echo w>  sysrq-trigger' from dmesg would be a
> >good start, as would a 'perf top -G -U' snapshot (run for 30s at
> >least a minute after mkfs.xfs starts) to tell us what is burning
> >CPU.
> >
> >Cheers,
> >
> >Dave.
> 
> Thanks for the quick response!
> 
> Adding the -K seemed to do the trick.  However, for my education,
> why is this needed in this case?  It seems to work without it for
> larger chunk sizes or for raid 0 instead of 5. 

Discard on RAID 5 can require parity recalculation if the discard
sizes are small which means RMW operations. I'd say you probably
need to ask the linux-raid list to debug whatever issue you are
having with the RAID5 code.

> It also worked on
> our old install with a 3.1.6 kernel.

RAID5 discard support was added in 3.1.7....

> Any why would not using the -K
> cause enough of a problem that the whole machine hangs?  Just trying
> to understand this enough to make sure I don't run into problems
> down the road.

If you cause the IO subsystem to choke up, the system can hang
because it can't clean dirty pages of memory and hence you can get
ENOMEM situations that can hang the machine. Again, i'd first talk
to the linux-raid folk to find out what is causing the RAID5 to be
so slow in this case as it's really nothing to do with XFS at this
point...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
