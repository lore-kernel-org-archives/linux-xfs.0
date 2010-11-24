Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAO0mXNK037109 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 18:48:34 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 508CF13E6170
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 16:50:09 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	oDQAKEwP2dqGnjnu for <xfs@oss.sgi.com>;
	Tue, 23 Nov 2010 16:50:09 -0800 (PST)
Date: Wed, 24 Nov 2010 11:50:03 +1100
From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: XFS performance oddity
Message-ID: <20101124005003.GB3168@amd>
References: <20101123122449.GA4812@amd>
 <20101123205804.GX22876@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101123205804.GX22876@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, xfs@oss.sgi.com

On Wed, Nov 24, 2010 at 07:58:04AM +1100, Dave Chinner wrote:
> On Tue, Nov 23, 2010 at 11:24:49PM +1100, Nick Piggin wrote:
> > Hi,
> > 
> > Running parallel fs_mark (0 size inodes, fsync on close) on a ramdisk
> > ends up with XFS in funny patterns.
> > 
> > procs -----------memory---------- ---swap-- -----io---- -system--
> > ----cpu----
> >  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
> > id wa
> > 24  1   6576 166396    252 393676  132  140 16900 80666 21308 104333  1 84 14  1
> > 21  0   6712 433856    256 387080  100  224  9152 53487 13677 53732  0 55 45  0
> >  2  0   7068 463496    248 389100    0  364  2940 17896 4485 26122  0 33 65  2
> >  1  0   7068 464340    248 388928    0    0     0     0   66  207  0  0 100  0
> >  0  0   7068 464340    248 388928    0    0     0     0   79  200  0  0 100  0
> >  0  0   7068 464544    248 388928    0    0     0     0   65  199  0  0 100  0
> >  1  0   7068 464748    248 388928    0    0     0     0   79  201  0  0 100  0
> >  0  0   7068 465064    248 388928    0    0     0     0   66  202  0  0 100  0
> >  0  0   7068 465312    248 388928    0    0     0     0   80  200  0  0 100  0
> >  0  0   7068 465500    248 388928    0    0     0     0   65  199  0  0 100  0
> >  0  0   7068 465500    248 388928    0    0     0     0   80  202  0  0 100  0
> >  1  0   7068 465500    248 388928    0    0     0     0   66  203  0  0 100  0
> >  0  0   7068 465500    248 388928    0    0     0     0   79  200  0  0 100  0
> > 23  0   7068 460332    248 388800    0    0  1416  8896 1981 7142  0  1 99  0
> >  6  0   6968 360248    248 403736   56    0 15568 95171 19438 110825  1 79 21  0
> > 23  0   6904 248736    248 419704  392    0 17412 118270 20208 111396  1 82 17  0
> >  9  0   6884 266116    248 435904  128    0 14956 79756 18554 118020  1 76 23  0
> >  0  0   6848 219640    248 445760  212    0  9932 51572 12622 76491  0 60 40  0
> > 
> > Got a dump of sleeping tasks. Any ideas?
> 
> It is stuck waiting for log space to be freed up. Generally this is
> caused by log IO completion not occurring or an unflushable object
> preventing the tail from being moved forward.  What:

Yeah it's strage, it seems like it hits some timeout or gets kicked
along by background writeback or something. Missed wakeup somewhere?

BTW. I reproduced similar traces with debug options turned off, and
with delaylog.
 

> 	- kernel are you running?

2.6.37-rc3 vanilla

> 	- is the time resolution of the above output?

1 second

> 	- is the output of mkfs.xfs?

meta-data=/dev/ram0              isize=256    agcount=16, agsize=65536 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1048576, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

> 	- are your mount options?

mount -o delaylog,logbsize=262144,nobarrier /dev/ram0 mnt

> 	- is the fs_mark command line?

../fs_mark -S1 -k -n 1000  -L 100 -s 0  -d scratch/0  -d scratch/1  -d
scratch/2  -d scratch/3  -d scratch/4  -d scratch/5  -d scratch/6  -d
scratch/7 -d scratch/8 -d scratch/9 -d scratch/10 -d scratch/11 -d
scratch/12 -d scratch/13 -d scratch/14 -d scratch/15 -d scratch/16 -d
scratch/17 -d scratch/18 -d scratch/19 -d scratch/20 -d scratch/21 -d
scratch/22 -d scratch/23
for f in scratch/* ; do rm -rf $f & done ; wait

Ran it again, and yes it has locked up for a long long time, it seems
to be in the rm phase, but I think I've seen similar stall (although not
so long) in the fs_mark phase too.



procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 6  0      0 547088    420 222872    0    0  1720 736397 23423 384539  7 32 61  0
 2  0      0 613604    420 225772    0    0  3960 492183 14276 228470  6 32 61  0
11  0      0 796704    420 241464    0    0   548 607070 19239 340874  5 20 75  0
14  0      0 695524    420 259748    0    0     8 758151 23038 382252  7 32 61  0
19  0      0 604932    420 276504    0    0    80 784919 23011 368598  7 31 63  0
24  0      0 474676    468 280416    0    0 17068 561785 21134 321450  6 28 62  3
25  0    484 189040    296 346560  164  560 130348 132672 68459 93936  5 85  9  0
 1  1    484 197768    300 375956   20    0 30292 153619 9570 116342  1 61 35  3
 2  0    484 205788    300 374448    0    0     0     0  241  381  0  1 90  9
22  0    484 363124    300 392992    0    0 18572 99025 9520 129093  0 17 82  0
 1  1    484 541336    300 396900    0    0  6236 59965 4118 82291  0 33 60  6
 1  0    484 542916    300 397108    0    0     0     0   61   90  0  0 99  1
 0  0    484 542916    300 397056    0    0     0     0   71   74  0  0 100  0
 0  0    484 542916    300 397056    0    0     0     0   43   58  0  0 100  0
 0  0    484 543196    300 397056    0    0     0     0   63   66  0  0 100  0
 0  0    484 543196    300 397056    0    0     0     0   44   60  0  0 100  0
 0  0    484 543652    300 397320    0    0     0     0   68   81  0  0 100  0
 0  0    484 544040    300 397320    0    0     0     0   44   65  0  0 100  0
 0  0    484 544040    300 397320    0    0     0     0   64   68  0  0 100  0
 0  0    484 544040    300 397320    0    0     0     0   44   59  0  0 100  0
 1  0    484 544288    300 397320    0    0     0     0   65   69  0  0 100  0
 1  0    484 544288    300 397320    0    0     0     0   45   62  0  0 100  0
 1  0    484 544296    300 397320    0    0     0     0   64   65  0  0 100  0
 0  0    484 544544    300 397320    0    0     0     0   45   62  0  0 100  0
 0  0    484 544544    300 397320    0    0     0     0   64   70  0  0 100  0

Every blocked task (sampled several sysrq+w) is stuck in
xlog_grant_log_space.

[  226.558091] rm            D 0000000000000008     0  3933   1510
[  226.558091] Call Trace:
[  226.558091]  [<ffffffffa004cbc8>] xlog_grant_log_space+0x158/0x3e0
[xfs]
[  226.558091]  [<ffffffffa00609e5>] ? kmem_zone_zalloc+0x35/0x50 [xfs]
[  226.558091]  [<ffffffff8103a1c0>] ? default_wake_function+0x0/0x10
[  226.558091]  [<ffffffffa004cf32>] xfs_log_reserve+0xe2/0xf0 [xfs]
[  226.558091]  [<ffffffffa005a5eb>] xfs_trans_reserve+0x9b/0x210 [xfs]
[  226.558091]  [<ffffffffa005a987>] ? xfs_trans_alloc+0x97/0xb0 [xfs]
[  226.558091]  [<ffffffffa005f1d7>] xfs_inactive+0x277/0x470 [xfs]
[  226.558091]  [<ffffffffa006b023>] xfs_fs_evict_inode+0xa3/0xb0 [xfs]
[  226.558091]  [<ffffffff810e3062>] evict+0x22/0xb0
[  226.558091]  [<ffffffff810e3c55>] iput+0x1c5/0x2c0
[  226.558091]  [<ffffffff810da420>] do_unlinkat+0x120/0x1d0
[  226.558091]  [<ffffffff810d15e1>] ? sys_newfstatat+0x31/0x50
[  226.558091]  [<ffffffff810da63d>] sys_unlinkat+0x1d/0x40
[  226.558091]  [<ffffffff81002deb>] system_call_fastpath+0x16/0x1b

Occasional 1-2s bursts of bi/bo activity which seem to happen every
30s, so it's probably some writeback thread kicking in (or an xfs
periodic thread?)

... and it eventually just recovered after 5 minutes.

Thanks,
Nick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
