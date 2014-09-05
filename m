Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 47BAA7F3F
	for <xfs@oss.sgi.com>; Fri,  5 Sep 2014 14:18:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0AF09304053
	for <xfs@oss.sgi.com>; Fri,  5 Sep 2014 12:18:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WzXPihWq4e090QW7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 05 Sep 2014 12:18:20 -0700 (PDT)
Date: Fri, 5 Sep 2014 15:18:16 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Is XFS suitable for 350 million files on 20TB storage?
Message-ID: <20140905191815.GB8400@laptop.bfoster>
References: <540986B1.4080306@profihost.ag>
	<20140905123058.GA29710@bfoster.bfoster>
	<5409AF40.10801@profihost.ag>
	<20140905134810.GA3965@laptop.bfoster>
	<5409FBEA.9050708@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5409FBEA.9050708@profihost.ag>
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
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Sep 05, 2014 at 08:07:38PM +0200, Stefan Priebe wrote:
> Hi,
> 
> Am 05.09.2014 15:48, schrieb Brian Foster:
> >On Fri, Sep 05, 2014 at 02:40:32PM +0200, Stefan Priebe - Profihost AG wrote:
> >>
> >>Am 05.09.2014 um 14:30 schrieb Brian Foster:
> >>>On Fri, Sep 05, 2014 at 11:47:29AM +0200, Stefan Priebe - Profihost AG wrote:
> >>>>Hi,
> >>>>
> >>>>i have a backup system running 20TB of storage having 350 million files.
> >>>>This was working fine for month.
> >>>>
> >>>>But now the free space is so heavily fragmented that i only see the
> >>>>kworker with 4x 100% CPU and write speed beeing very slow. 15TB of the
> >>>>20TB are in use.
> >>>>
> >>>>Overall files are 350 Million - all in different directories. Max 5000
> >>>>per dir.
> >>>>
> >>>>Kernel is 3.10.53 and mount options are:
> >>>>noatime,nodiratime,attr2,inode64,logbufs=8,logbsize=256k,noquota
> >>>>
> >>>># xfs_db -r -c freesp /dev/sda1
> >>>>    from      to extents  blocks    pct
> >>>>       1       1 29484138 29484138   2,16
> >>>>       2       3 16930134 39834672   2,92
> >>>>       4       7 16169985 87877159   6,45
> >>>>       8      15 78202543 999838327  73,41
> >>>>      16      31 3562456 83746085   6,15
> >>>>      32      63 2370812 102124143   7,50
> >>>>      64     127  280885 18929867   1,39
> >>>>     256     511       2     827   0,00
> >>>>     512    1023      65   35092   0,00
> >>>>    2048    4095       2    6561   0,00
> >>>>   16384   32767       1   23951   0,00
> >>>>
> >>>>Is there anything i can optimize? Or is it just a bad idea to do this
> >>>>with XFS? Any other options? Maybe rsync options like --inplace /
> >>>>--no-whole-file?
> >>>>
> >>>
> >>>It's probably a good idea to include more information about your fs:
> >>>
> >>>http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> >>
> >>Generally sure but the problem itself is clear. If you look at the free
> >>space allocation you see that free space is heavily fragmented.
> >>
> >>But here you go:
> >>- 3.10.53 vanilla
> >>- xfs_repair version 3.1.11
> >>- 16 cores
> >>- /dev/sda1 /backup xfs
> >>rw,noatime,nodiratime,attr2,inode64,logbufs=8,logbsize=256k,noquota 0 0
> >>- Raid 10 with 1GB controller cache running in write back mode using 24
> >>spinners
> >>- no lvm
> >>- no io waits
> >>- xfs_info /serverbackup/
> >>meta-data=/dev/sda1              isize=256    agcount=21,
> >>agsize=268435455 blks
> >>          =                       sectsz=512   attr=2
> >>data     =                       bsize=4096   blocks=5369232896, imaxpct=5
> >>          =                       sunit=0      swidth=0 blks
> >>naming   =version 2              bsize=4096   ascii-ci=0
> >>log      =internal               bsize=4096   blocks=521728, version=2
> >>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> >>realtime =none                   extsz=4096   blocks=0, rtextents=0
> >>
> >>anything missing?
> >>
> >
> >What's the workload to the fs? Is it repeated rsync's from a constantly
> >changing dataset? Do the files change frequently or are they only ever
> >added/removed?
> 
> Yes it repeated rsync with constant changing files. About 10-20% of all
> files every week. A mixture of changing, removing / adding.
> 

Ok.

> >Also, what is the characterization of writes being "slow?" An rsync is
> >slower than normal? Sustained writes to a single file? How significant a
> >degradation?
> 
> kworker is using all cpu while writing data to this xfs partition. rsync can
> just write at a rate of 32-128kb/s.
> 

Do you have a baseline? This seems highly subjective. By that I mean
this could be slower for copying a lot of little files, faster if you
happen to copy a single large file, etc.

> >Something like the following might be interesting as well:
> >for i in $(seq 0 20); do xfs_db -c "agi $i" -c "p freecount" <dev>; done
> freecount = 3189417
> freecount = 1975726
> freecount = 1309903
> freecount = 1726846
> freecount = 1271047
> freecount = 1281956
> freecount = 1571285
> freecount = 1365473
> freecount = 1238118
> freecount = 1697011
> freecount = 1000832
> freecount = 1369791
> freecount = 1706360
> freecount = 1439165
> freecount = 1656404
> freecount = 1881762
> freecount = 1593432
> freecount = 1555909
> freecount = 1197091
> freecount = 1667467
> freecount = 63
> 

Interesting, that seems like a lot of free inodes. That's 1-2 million in
each AG that we have to look around for each time we want to allocate an
inode. I can't say for sure that's the source of the slowdown, but this
certainly looks like the kind of workload that inspired the addition of
the free inode btree (finobt) to more recent kernels.

It appears that you still have quite a bit of space available in
general. Could you run some local tests on this filesystem to try and
quantify how much of this degradation manifests on sustained writes vs.
file creation? For example, how is throughput when writing a few GB to a
local test file? How about with that same amount of data broken up
across a few thousand files?

Brian

P.S., Alternatively if you wanted to grab a metadump of this filesystem
and compress/upload it somewhere, I'd be interested to take a look at
it.

> Thanks!
> 
> Stefan
> 
> 
> 
> >Brian
> >
> >>>... as well as what your typical workflow/dataset is for this fs. It
> >>>seems like you have relatively small files (15TB used across 350m files
> >>>is around 46k per file), yes?
> >>
> >>Yes - most fo them are even smaller. And some files are > 5GB.
> >>
> >>>If so, I wonder if something like the
> >>>following commit introduced in 3.12 would help:
> >>>
> >>>133eeb17 xfs: don't use speculative prealloc for small files
> >>
> >>Looks interesting.
> >>
> >>Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
