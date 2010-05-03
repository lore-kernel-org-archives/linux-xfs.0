Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o43CFDOE153173 for <xfs@oss.sgi.com>; Mon, 3 May 2010 07:15:13 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 986F8307F7F
	for <xfs@oss.sgi.com>; Mon,  3 May 2010 05:17:19 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	KsokmC62TlIps8fY for <xfs@oss.sgi.com>;
	Mon, 03 May 2010 05:17:19 -0700 (PDT)
Date: Mon, 3 May 2010 22:17:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_fsr question for improvement
Message-ID: <20100503121716.GF2591@dastard>
References: <201004161043.11243@zmi.at> <20100417012415.GE2493@dastard>
	<201005030849.47591@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201005030849.47591@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Mon, May 03, 2010 at 08:49:43AM +0200, Michael Monnerie wrote:
> On Samstag, 17. April 2010 Dave Chinner wrote:
> > They have thousands of extents in them and they are all between
> > 8-10GB in size, and IO from my VMs are stiall capable of saturating
> > the disks backing these files. While I'd normally consider these
> > files fragmented and candidates for running fsr on tme, the number
> > of extents is not actually a performance limiting factor and so
> > there's no point in defragmenting them. Especially as that requires
> > shutting down the VMs...
> 
> I personally care less about file fragmentation than about 
> metadata/inode/directory fragmentation. This server gets accesses from 
> numerous people,
> 
> # time find /mountpoint/ -inum 107901420
> /mountpoint/some/dir/ectory/path/x.iso
> 
> real    7m50.732s
> user    0m0.152s
> sys     0m2.376s
> 
> It took nearly 8 minutes to search through that mount point, which is 
> 6TB big on a RAID-5 striped over 7 2TB disks, so search speed should be 
> high.

Not necessarily, as your raid array has shown.

>
> Especially as there are only 765.000 files on that disk:
> Filesystem            Inodes   IUsed   IFree IUse%
> /mountpoint           1258291200  765659 1257525541    1%
> 
> Wouldn't you say an 8 minutes search over just 765.000 files is slow, 
> even when only using 7x 2TB 7200rpm disks in RAID-5?

Depends on the directory structure and the number of IOs needed to
traverse it. If it's only a handful of files per directory, then you
get no internal directory readahead to hide read latency. That
results in a small random synchronous read workload that might
require a couple of hundred thousand IOs to complete.

>From your early stats showing a read rate of 50 IO/s from the raid
array, then the directory read traverse has requires about 25kiops
to complete. That takes about 10s on my laptop's cheap SSD, which
does random reads about 50x faster than your RAID array....

> > > Would it be possible xfs_fsr defrags the meta data in a way that
> > > they are all together so seeks are faster?
> > 
> > It's not related to fsr because fsr does not defragment metadata.
> > Some metadata cannot be defragmented (e.g. inodes cannot be moved),
> > some metadata cannot be manipulated directly (e.g. free space
> > btrees), and some is just difficult to do (e.g. directory
> > defragmentation) so hasn't ever been done.
> 
> I see. On this particular server I know it would be good for performance 
> to have the metadata defrag'ed, but that's not the aim of xfs_fsr.
> But maybe some developer is bored once and finds a way to optimize the 
> search&find of files on an aged filesystem, i.e. metadata defrag :-)

Many have. Find and tar have resisted attempts to optimise them over
the years, so stuff like this:

http://oss.oracle.com/~mason/acp/

grows on the interwebs all over the place... ;)


> I tried this two times:
> # time find /mountpoint/ -inum 107901420
> real    8m17.316s
> user    0m0.148s 
> sys     0m1.964s 
> 
> # time find /mountpoint/ -inum 107901420
> real    0m30.113s
> user    0m0.540s 
> sys     0m9.813s 
> 
> Caching helps the 2nd time :-)

That still seems rather slow traversing 750,000 cached directory
entries. My laptop (1.3GHz CULV core2 CPU) does 465,000 directory
entries in:

$ time sudo find / -mount -inum 123809285

real    0m2.196s
user    0m0.384s
sys     0m1.464s

> > Raid 5/6 generally provides the same IOPS performance as a single
> > spindle, regardless of the width of the RAID stripe. A 2TB sata
> > drive might be able to do 150-200 IOPS, so a RAID5 array made up of
> > these drives will tend to max out at roughly the same....
> 
> Running xfs_fsr, I can see up to 1200r+1200w=2400I/Os per second:
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-
> sz avgqu-sz   await  svctm  %util
> xvdc              0,00     0,00    0,00 1191,42     0,00 52320,16    
> 87,83   121,23   96,77   0,71  84,63
> xvde              0,00     0,00 1226,35    0,00 52324,15     0,00    
> 85,33     0,77    0,62   0,13  15,33
> 
> But on average it's about 600-700 read plus writes per second, so 
> 1200-1400 IOPS. 
> Both "disks" are 2TB LVM volumes on the same raidset, I just had to 
> split it as XEN doesn't allow to create >2TB volumes.
> 
> So, the badly slow I/O I see during "find" are not happening during fsr. 
> How can that be?

Because most of the IO xfs_fsr does is large sequential IO which the
RAID caches are optimised for. Directory traversals, OTOH, are small,
semi-random IO which are latency sensitive....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
