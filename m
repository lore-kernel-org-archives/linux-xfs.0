Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAO3Dobm052200 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 21:13:51 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5B781A0C38
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 19:15:27 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	JwqGL5BYUyq7c2vQ for <xfs@oss.sgi.com>;
	Tue, 23 Nov 2010 19:15:27 -0800 (PST)
Date: Wed, 24 Nov 2010 14:15:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS performance oddity
Message-ID: <20101124031524.GC22876@dastard>
References: <20101123122449.GA4812@amd> <20101123205804.GX22876@dastard>
	<20101124005003.GB3168@amd>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101124005003.GB3168@amd>
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
To: Nick Piggin <npiggin@kernel.dk>
Cc: xfs@oss.sgi.com

On Wed, Nov 24, 2010 at 11:50:03AM +1100, Nick Piggin wrote:
> On Wed, Nov 24, 2010 at 07:58:04AM +1100, Dave Chinner wrote:
> > On Tue, Nov 23, 2010 at 11:24:49PM +1100, Nick Piggin wrote:
> > > Hi,
> > > 
> > > Running parallel fs_mark (0 size inodes, fsync on close) on a ramdisk
> > > ends up with XFS in funny patterns.
> > > 
> > > procs -----------memory---------- ---swap-- -----io---- -system--
> > > ----cpu----
> > >  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
> > > id wa
> > > 24  1   6576 166396    252 393676  132  140 16900 80666 21308 104333  1 84 14  1
> > > 21  0   6712 433856    256 387080  100  224  9152 53487 13677 53732  0 55 45  0
> > >  2  0   7068 463496    248 389100    0  364  2940 17896 4485 26122  0 33 65  2
> > >  1  0   7068 464340    248 388928    0    0     0     0   66  207  0  0 100  0
> > >  0  0   7068 464340    248 388928    0    0     0     0   79  200  0  0 100  0
> > >  0  0   7068 464544    248 388928    0    0     0     0   65  199  0  0 100  0
> > >  1  0   7068 464748    248 388928    0    0     0     0   79  201  0  0 100  0
> > >  0  0   7068 465064    248 388928    0    0     0     0   66  202  0  0 100  0
> > >  0  0   7068 465312    248 388928    0    0     0     0   80  200  0  0 100  0
> > >  0  0   7068 465500    248 388928    0    0     0     0   65  199  0  0 100  0
> > >  0  0   7068 465500    248 388928    0    0     0     0   80  202  0  0 100  0
> > >  1  0   7068 465500    248 388928    0    0     0     0   66  203  0  0 100  0
> > >  0  0   7068 465500    248 388928    0    0     0     0   79  200  0  0 100  0
> > > 23  0   7068 460332    248 388800    0    0  1416  8896 1981 7142  0  1 99  0
> > >  6  0   6968 360248    248 403736   56    0 15568 95171 19438 110825  1 79 21  0
> > > 23  0   6904 248736    248 419704  392    0 17412 118270 20208 111396  1 82 17  0
> > >  9  0   6884 266116    248 435904  128    0 14956 79756 18554 118020  1 76 23  0
> > >  0  0   6848 219640    248 445760  212    0  9932 51572 12622 76491  0 60 40  0
> > > 
> > > Got a dump of sleeping tasks. Any ideas?
> > 
> > It is stuck waiting for log space to be freed up. Generally this is
> > caused by log IO completion not occurring or an unflushable object
> > preventing the tail from being moved forward.  What:
> 
> Yeah it's strage, it seems like it hits some timeout or gets kicked
> along by background writeback or something. Missed wakeup somewhere?

No idea yet.

> > 	- is the output of mkfs.xfs?
> 
> meta-data=/dev/ram0              isize=256    agcount=16, agsize=65536 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=1048576, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=16384, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

Ok, small log, small AGs.

> > 	- are your mount options?
> 
> mount -o delaylog,logbsize=262144,nobarrier /dev/ram0 mnt
> 
> > 	- is the fs_mark command line?
> 
> ../fs_mark -S1 -k -n 1000  -L 100 -s 0  -d scratch/0  -d scratch/1  -d
> scratch/2  -d scratch/3  -d scratch/4  -d scratch/5  -d scratch/6  -d
> scratch/7 -d scratch/8 -d scratch/9 -d scratch/10 -d scratch/11 -d
> scratch/12 -d scratch/13 -d scratch/14 -d scratch/15 -d scratch/16 -d
> scratch/17 -d scratch/18 -d scratch/19 -d scratch/20 -d scratch/21 -d
> scratch/22 -d scratch/23
> for f in scratch/* ; do rm -rf $f & done ; wait

Ok, so you are effectively doing a concurrent synchronous create of 2.4M
zero byte files.

BTW, how many CPU cores does your machine have? if it's more than 8, then
you're probably getting a fair bit of serialisation on the per-ag
structures. I normally use agcount=num_cpus * 2 for scalability
testing when running one load thread per CPU.

> Ran it again, and yes it has locked up for a long long time, it seems
> to be in the rm phase, but I think I've seen similar stall (although not
> so long) in the fs_mark phase too.

Ok, I've just reproduced a couple of short hangs (a few seconds)
during the rm phase so I should be able to track it down.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
