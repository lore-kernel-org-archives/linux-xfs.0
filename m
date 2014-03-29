Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5689B7F3F
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 20:03:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3226A8F8066
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 18:03:46 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 1yHwo6EpfOsb02Rl
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 18:03:45 -0700 (PDT)
Message-ID: <53361BF0.6010909@hardwarefreak.com>
Date: Fri, 28 Mar 2014 20:03:44 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Exponential memory usage?
References: <DF4B0D0E-6D5A-4670-9301-A1DCD0EEAE6E@anti-paladin.com>
In-Reply-To: <DF4B0D0E-6D5A-4670-9301-A1DCD0EEAE6E@anti-paladin.com>
Reply-To: stan@hardwarefreak.com
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
To: Tap <tap@anti-paladin.com>, xfs@oss.sgi.com

On 3/28/2014 12:53 PM, Tap wrote:
> I have a Linux CentOs-based (6.5) system, running Linux 3.10.29 beneath xen 4.2.3-26 with a raid array as follows:

32 or 64 bit kernel?

>      Raid Level : raid6
>      Array Size : 14650667520 (13971.97 GiB 15002.28 GB)
>   Used Dev Size : 2930133504 (2794.39 GiB 3000.46 GB)
>    Raid Devices : 7

5 data spindles

>          Layout : left-symmetric
>      Chunk Size : 512K

2.5 MB stripe width

> xfs_info shows:
> 
> meta-data=/dev/md127             isize=256    agcount=32, agsize=114458368 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=3662666880, imaxpct=5
>          =                       sunit=128    swidth=640 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

XFS is aligned

> The system currently has 32 GB of RAM.
> 
> I was hoping to use this as the main data-stor for various (small) xen machines, one of which  was going to be a zoneminder system.  Zoneminder makes lots of "small" files (JPG's) from the various HD IP cameras that are connected.

What is the JPG file size?  This is critical.

> Anyway at some point the system had become unusable.  Something as simple as:
> 
>   find  /raid -type f
> -- or --
>   ls -lR /raid
> 
> Would walk the entire system out of RAM.  Looking at slabtop it looks like this is due mostly to xfs_inode memory usage.  Note that since these problems began I stopped running all sub-ordinate domains and am now only running dom0.  In fact I've allocated all 32 GB to that domain, and memory problems still persist.
> 
> (At 83% FS utilization) I decided I have to do something to get out of this unusable state and therefore started removing ( rm -rf targetDir ) all of the files that the zoneminder system had generated.  Even this, after a fresh reboot with thing else running, will run the system out of RAM (all 32 GB of it).  The delete of this area is still in progress as I have to periodically restart the machine to get RAM back (as I compose this email it is down to 66% space used).

83% and 66% of what, inodes or extents?  Please show

~# df -h -T -x tmpfs
~# df -i -h -T -x tmpfs

> I've googled and can't really find anything that describes these kinds of problems.  I've tried the few limited tunable values (XFS and VS) and nothing seems to have any positive impact on this run-away memory usage.
> 
> My questions are:
> 
> 1.  Is this expected?
> 
> 2.  Are there any XFS memory calculators that would have shown me this is a problem to begin with?

The answers depend on the cause, which has yet to be determined.
Analysis of the requested information should get you an answer pretty
quickly, unless the problem turns out to be a bug, which may take a
little longer.

> Given it walks out of 32 GB of memory I can't be sure that upgrading to 64 or 128 GB will *ever* help this situation.

Again, depends on the cause.  Don't throw more hardware at this until we
have a root cause identified, and it shows more RAM is needed.  If this
were a desktop and 2 sticks is $50 sure, but not when we're talking
registered ECC server sticks to reach 128MB capacity.  This 32 to 128
scenario often involves tossing the 32GB as it's not registered or of
the wrong rank/clock.

> Note:  FWIW Un-mounting the filesystem also recovers the memory.

Of course.  Unmounting frees up all the filesystem resources.


Cheers,

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
