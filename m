Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F8977FC7
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 00:14:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7CC0C304066
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 22:14:37 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id S1PglZrHtuzyGmvh
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 22:14:36 -0700 (PDT)
Message-ID: <5142AE40.6040408@hardwarefreak.com>
Date: Fri, 15 Mar 2013 00:14:40 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_fsr, sunit, and swidth
References: <5140C147.7070205@binghamton.edu>
	<514113C6.9090602@hardwarefreak.com>
	<514153ED.3000405@binghamton.edu>
	<5141C1FC.4060209@hardwarefreak.com>
	<5141C8C1.2080903@hardwarefreak.com>
	<5141E5CF.10101@binghamton.edu>
In-Reply-To: <5141E5CF.10101@binghamton.edu>
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
To: Dave Hall <kdhall@binghamton.edu>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 3/14/2013 9:59 AM, Dave Hall wrote:

> Linux decoy 3.2.0-0.bpo.4-amd64 #1 SMP Debian 3.2.35-2~bpo60+1 x86_64
> GNU/Linux

Ok, so you're already on a recent kernel with delaylog.

>>> >  ~$ grep xfs /etc/fstab
>>>      
> LABEL=backup        /infortrend    xfs   
> inode64,noatime,nodiratime,nobarrier    0    0

XFS uses relatime by default, so noatime/nodiratime are useless, though
not part of the problem.  inode64 is good as your files and metadata
have locality.  Nobarrier is good with functioning BBWC.

> meta-data=/dev/sdb1              isize=256    agcount=26,
> agsize=268435455 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=6836364800, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

Standard internal log, no alignment.  With delaylog, 512MB BBWC, and a
nearly pure metadata workload, this should be fine.

> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sdb1            27343372288 20432618356 6910753932  75% /infortrend

Looks good.  75% is close to tickling the free space fragmentation
dragon but you're not there yet.

> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> /dev/sdb1            5469091840 1367746380 4101345460   26% /infortrend

Plenty of free inodes.

> # xfs_db -r -c freesp /dev/sdb1
>    from      to extents  blocks    pct
>       1       1  832735  832735   0.05
>       2       3  432183 1037663   0.06
>       4       7  365573 1903965   0.11
>       8      15  352402 3891608   0.23
>      16      31  332762 7460486   0.43
>      32      63  300571 13597941   0.79
>      64     127  233778 20900655   1.21
>     128     255  152003 27448751   1.59
>     256     511  112673 40941665   2.37
>     512    1023   82262 59331126   3.43
>    1024    2047   53238 76543454   4.43
>    2048    4095   34092 97842752   5.66
>    4096    8191   22743 129915842   7.52
>    8192   16383   14453 162422155   9.40
>   16384   32767    8501 190601554  11.03
>   32768   65535    4695 210822119  12.20
>   65536  131071    2615 234787546  13.59
>  131072  262143    1354 237684818  13.76
>  262144  524287     470 160228724   9.27
>  524288 1048575      74 47384798   2.74
> 1048576 2097151       1 2097122   0.12

Your free space map isn't completely horrible given you're at 75%
capacity.  Looks like most of it is in chunks 32MB and larger.  Those
14.8m files have a mean size of ~1.22MB which suggests most of the files
are small, so you shouldn't be having high seek load (thus latency)
during allocation.

> The RAID box is an Infortrend S16S-G1030 with 512MB cache and a fully
> functional battery.  I couldn't find  any details about the internal
> RAID implementation used by Infortrend.   The array is SAS attached to
> an LSI HBA (SAS2008 PCI-Express Fusion-MPT SAS-2).

It's an older unit, definitely not the fastest in its class, but unless
the firmware is horrible the 512MB BBWC should handle this metadata
workload with aplomb.  With 128GB RAM and Linux read-ahead caching you
don't need the RAID controller to be doing read caching.  Go into the
SANWatch interface and make sure you're dedicating all the cache to
writes not reads.  This may or may not be configurable.  Some firmware
will simply drop read cache lines dynamically when writes come in.  Some
let you manually tweak the ratio.  I'm not that familiar with the
Infortrend units.  But again, this is a minor optimization, and I don't
think this is part of the problem.

> The system hardware is a SuperMicro quad 8-core XEON E7-4820 2.0GHz with
> 128 GB of ram, hyper-theading enabled.  (This is something that I
> inherited.  There is no doubt that it is overkill.)

Just a bit.  64 hardware threads, 72MB of L3 cache, and 128GB RAM for a
storage server with two storage HBAs and low throughput disk arrays.
Apparently running a Debian mirror is more compute intensive than I
previously thought...

> Another bit of information that you didn't ask about is the I/O
> scheduler algorithm.  

Didn't get that far yet. ;)

> I just checked and found it set to 'cfq', although
> I though I had set it to 'noop' via a kernel parameter in GRUB.

As you're using a distro kernel, I recommend simply doing it in root's
crontab.  That way it can't get 'lost' during kernel upgrades due to
grub update problems, etc.  The scheduler can be changed on the fly so
it doesn't matter where you set it in the boot sequence.

@reboot		/bin/echo noop > /sys/block/sdb/queue/scheduler

> Also, some observations about the cp -al:  In parallel to investigating
> hardware/OS/filesystem issue I have done some experiments with cp -al. 
> It hurts to have 64 cores available and see cp -al running the wheels
> off just one, with a couple others slightly active with system level
> duties.  

This tends to happen when one runs single threaded user space code on a
large multiprocessor.

> So I tried some experiments where I copied smaller segments of
> the file tree in parallel (using make -j).  I haven't had the chance to
> fully play this out, but these parallel cp invocations completed very
> quickly.  So it would appear that the cp command itself may bog down
> with such a large file tree.  I haven't had a chance to tear apart the
> source code or do any profiling to see if there are any obvious problems
> there.
> 
> Lastly, I will mention that I see almost 0% wa when watching top.

So it's probably safe to say at this point that XFS and IO in general
are not the problem.

One thing you did not mention is how you are using rsnapshot.  If you
are using it as most folks do to backup remote filesystems of other
machines over ethernet, what happens when you simply schedule multiple
rsnapshot processes concurrently, targeting each at a different remote
machine?

If you're using rsnapshot strictly locally, you should take a hard look
at xfsdump.  It exists specifically for backing up XFS filesystems/files
and has been around a very long time, is very mature.  It's not quite as
flexible as rsnapshot and may require more disk space, but it is
lighting fast, even though limited to a single thread on Linux.  Why is
it lightning fast?  Because the bulk of the work is performed in kernel
space by the XFS driver, directly manipulating the filesystem--no user
space execution or system calls.  See 'man xfsdump'.

Familiarize yourself with it and perform a test dump, to a file, of a
large (~1TB) directory/tree.  You'll see what we mean by lightning fast,
compared to rsnapshot and other user space methods.  And you'll actually
see some IO throughput with this. ;)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
