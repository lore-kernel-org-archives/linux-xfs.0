Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p086R8Zv192172 for <xfs@oss.sgi.com>; Sat, 8 Jan 2011 00:27:09 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD9D42495FF
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 22:29:15 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id pAAspNhmSXZJiDT9
	for <xfs@oss.sgi.com>; Fri, 07 Jan 2011 22:29:15 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 581656C01B
	for <xfs@oss.sgi.com>; Sat,  8 Jan 2011 00:29:14 -0600 (CST)
Message-ID: <4D28043A.20300@hardwarefreak.com>
Date: Sat, 08 Jan 2011 00:29:14 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: realtime partition support?
References: <4D2724E0.9020801@philkarn.net> <20110108021728.GA28803@dastard>
	<4D27E11F.4030607@philkarn.net>
In-Reply-To: <4D27E11F.4030607@philkarn.net>
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
To: xfs@oss.sgi.com

Phil Karn put forth on 1/7/2011 9:59 PM:

> No? I'm having a very hard time getting XFS on rotating SATA drives to
> come close to Reiser or ext4 when extracting a large tarball (e.g., the
> Linux source tree) or when doing rm -rf.

This is because you're not using Dave's delayed logging patch, and
you've not been reading this list for many months, as it's been
discussed in detail many times.  See:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/filesystems/xfs-delayed-logging-design.txt;h=96d0df28bed323d5596fc051b0ffb96ed8e3c8df;hb=HEAD


Dave Chinner put forth on 3/14/2010 11:30 PM:

> The following results are from a synthetic test designed to show
> just the impact of delayed logging on the amount of metadata
> written to the log.
>
> load:	Sequential create 100k zero-length files in a directory per
> 	thread, no fsync between create and unlink.
> 	(./fs_mark -S0 -n 100000 -s 0 -d ....)
>
> measurement: via PCP. XFS specific metrics:
>
> 	xfs.log.blocks
> 	xfs.log.writes
> 	xfs.log.noiclogs
> 	xfs.log.force
> 	xfs.transactions.*
> 	xfs.dir_ops.create
> 	xfs.dir_ops.remove
>
>
> machine:
>
> 2GHz Dual core opteron, 3GB RAM
> single 36GB 15krpm scsi drive w/ CTQ depth=32
> mkfs.xfs -f -l size=128m /dev/sdb2
>
> Current code:
>
> mount -o "logbsize=262144" /dev/sdb2 /mnt/scratch
>
> threads:	 fs_mark	CPU	create log	unlink log
> 		throughput		bandwidth	bandwidth
> 1		  2900/s         75%       34MB/s	 34MB/s
> 2		  2850/s	 75%	   33MB/s	 33MB/s
> 4		  2800/s	 80%	   30MB/s        30MB/s
>
> Delayed logging:
>
> mount -o "delaylog,logbsize=262144" /dev/sdb2 /mnt/scratch
>
> threads:	 fs_mark	CPU	create log	unlink log
> 		throughput		bandwidth	bandwidth
> 1		  4300/s        110%       1.5MB/s	 <1MB/s
> 2		  7900/s	195%	   <4MB/s	 <1MB/s
> 4		  7500/s	200%	   <5MB/s        <1.5MB/s
>
> I think it pretty clear that the design goal of "an order of
> magnitude less log IO bandwidth" is being met here. Scalability is
> looking promising, but a 2p machine is not large enough to make any
> definitive statements about that. Hence from these results the
> implementation is at or exceeding design levels.


The above results were with very young code.  I'm guessing the current
code in the tree probably has a little better performance.  Nonetheless,
the above results are impressive, and put XFS on par with any other FS
WRT metadata write heavy workloads.  Your "rm -rf" operation will be
_significantly_ faster, likely a factor of 2x or better, with this
delayed logging option enabled, and will be limited mainly/only by the
speed of your CPU/memory subsystem.

Untarring a kernel should yield a similar, but somewhat lesser,
performance increase as you'll be creating ~2300 directories and ~50,000
files (not nulls).

With a modern AMD/Intel platform with a CPU of ~3GHz clock speed, XFS
metadata OPs with delayed logging enabled should absolutely scream,
especially so with multicore CPUs and parallel/concurrent metadata write
heavy processes/threads.

I can't remember any more recent test results from Dave, although I may
simply have missed reading those emails, if they were sent.  Even if the
current code isn't any faster than that used for the tests above, the
metadata write performance increase is still phenomenal.

Again, nice work Dave. :)  AFAIK, you've eliminated the one 'legit'
performance gripe Linux folks have traditionally leveled at XFS WRT to
use as a general purpose server/workstation filesystem.  Now they have
no excuses not to use it.  :)  I'd love to see a full up Linux FS
performance comparison article after 2.6.39 rolls out and delaylog is
the default mount option.  I don't have the necessary hardware etc to do
such a piece or I gladly would.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
