Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C86358057
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 02:21:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A5D2E304043
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 00:21:37 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	LApmaDujFXQ0pEyQ for <xfs@oss.sgi.com>;
	Sat, 16 Mar 2013 00:21:35 -0700 (PDT)
Date: Sat, 16 Mar 2013 18:21:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_fsr, sunit, and swidth
Message-ID: <20130316072126.GG6369@dastard>
References: <5140C147.7070205@binghamton.edu>
	<514113C6.9090602@hardwarefreak.com>
	<514153ED.3000405@binghamton.edu>
	<5141C1FC.4060209@hardwarefreak.com>
	<5141C8C1.2080903@hardwarefreak.com>
	<5141E5CF.10101@binghamton.edu>
	<5142AE40.6040408@hardwarefreak.com>
	<20130315114538.GF6369@dastard>
	<5143F94C.1020708@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5143F94C.1020708@hardwarefreak.com>
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
Cc: Dave Hall <kdhall@binghamton.edu>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Mar 15, 2013 at 11:47:08PM -0500, Stan Hoeppner wrote:
> On 3/15/2013 6:45 AM, Dave Chinner wrote:
> > On Fri, Mar 15, 2013 at 12:14:40AM -0500, Stan Hoeppner wrote:
> >> On 3/14/2013 9:59 AM, Dave Hall wrote:
> >> Looks good.  75% is close to tickling the free space fragmentation
> >> dragon but you're not there yet.
> > 
> > Don't be so sure ;)
> 
> The only thing I'm sure of is that I'll always be learning something new
> about XFS and how to troubleshoot it. ;)
> 
> >>
> >>> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> >>> /dev/sdb1            5469091840 1367746380 4101345460   26% /infortrend
> >>
> >> Plenty of free inodes.
> >>
> >>> # xfs_db -r -c freesp /dev/sdb1
> >>>    from      to extents  blocks    pct
> >>>       1       1  832735  832735   0.05
> >>>       2       3  432183 1037663   0.06
> >>>       4       7  365573 1903965   0.11
> >>>       8      15  352402 3891608   0.23
> >>>      16      31  332762 7460486   0.43
> >>>      32      63  300571 13597941   0.79
> >>>      64     127  233778 20900655   1.21
> >>>     128     255  152003 27448751   1.59
> >>>     256     511  112673 40941665   2.37
> >>>     512    1023   82262 59331126   3.43
> >>>    1024    2047   53238 76543454   4.43
> >>>    2048    4095   34092 97842752   5.66
> >>>    4096    8191   22743 129915842   7.52
> >>>    8192   16383   14453 162422155   9.40
> >>>   16384   32767    8501 190601554  11.03
> >>>   32768   65535    4695 210822119  12.20
> >>>   65536  131071    2615 234787546  13.59
> >>>  131072  262143    1354 237684818  13.76
> >>>  262144  524287     470 160228724   9.27
> >>>  524288 1048575      74 47384798   2.74
> >>> 1048576 2097151       1 2097122   0.12
> >>
> >> Your free space map isn't completely horrible given you're at 75%
> >> capacity.  Looks like most of it is in chunks 32MB and larger.  Those
> >> 14.8m files have a mean size of ~1.22MB which suggests most of the files
> >> are small, so you shouldn't be having high seek load (thus latency)
> >> during allocation.
> > 
> > FWIW, you can't really tell how bad the freespace fragmentation is
> > from the global output like this. 
> 
> True.
> 
> > All of the large contiguous free
> > space might be in one or two AGs, and the others might be badly
> > fragmented. Hence you need to at least sample a few AGs to determine
> > if this is representative of the freespace in each AG....
> 
> What would be representative of 26AGs?  First, middle, last?  So Mr.
> Hall would execute:
> 
> ~$ xfs_db -r /dev/sdb1
> xfs_db> freesp -a0
> ...
> xfs_db> freesp -a13
> ...
> xfs_db> freesp -a26
> ...
> xfs_db> quit

Yup, though I normally just  run something like:

# for i in `seq 0 1 <agcount - 1>`; do
> xfs_db -c "freesp -a $i" <dev>
> done

To look at the them all quickly...

> > As it is, the above output raises alarms for me. What I see is that
> > the number of small extents massively outnumbers the large extents.
> > The fact that there are roughly 2.5 million extents smaller than 63
> > blocks and that there is only one freespace extent larger than 4GB
> > indicates to me that free space is substantially fragmented. At 25%
> > free space, that's 250GB per AG, and if the largest freespace in
> > most AGs is less than 4GB in length, then free space is not
> > contiguous. i.e.  Free space appears to be heavily weighted towards
> > small extents...`
> 
> It didn't raise alarms for me.  This is an rsnapshot workload with
> millions of small files.  For me it was a foregone conclusion he'd have
> serious fragmentation.  What I was looking at is whether it's severe
> enough to be a factor in his stated problem.  I don't think it is.  In
> fact I think it's completely unrelated, which is why I didn't go into
> deeper analysis of this.  Though I could be incorrect. ;)

Ok, so what size blocks are the metadata held in? 1-4 filesystem
block extents. So, when we do a by-size freespace btree lookup, we
don't find a large freespace to allocate from. So we fall back to a
by-blkno search down the freespace btree to find a neraby block of
sufficient size. That search runs until we run off one end of the
freespace btree. And when this might have to walk along several tens
of thousand of btree records, each allocation will consume a *lot*
of CPU time. How much? well, compared to finding a large freespace
extent, think orders of magnitude more CPU overhead per
allocation...

> > So, the above output would lead me to investigate the freespace
> > layout more deeply to determine if this is going to affect the
> > workload that is being run...
> 
> May be time to hold class again Dave as I'm probably missing something.
>  His slowdown is serial hardlink creation with "cp -al" of many millions
> of files.  Hardlinks are metadata structures, which means this workload
> modifies btrees and inodes, not extents, right?

It modifies directories and inodes, and adding directory entries
requires allocation of new directory blocks, and that requires
scanning of the freespace trees....

> XFS directory metadata is stored closely together in each AG, correct?
> 'cp -al' is going to walk directories in order, which means we're going
> have good read caching of the directory information thus little to no
> random read IO. 

not f the directory is fragmented. If freespace is fragmented, then
there's a good chance that directory blocks are not going to have
good locality, though the effect of that will be minimised by the
directory block readahead that is done.

> The cp is then going to create a hardlink per file.
> Now, even with the default 4KB write alignment, we should be getting a
> large bundle of hardlinks per write.  And I would think the 512MB BBWC
> on the array controller, if firmware is decent, should do a good job of
> merging these to mitigate RMW cycles.

it's possible, but I would expect the lack of IO to be caused by the
fact modification is CPU bound. i.e. it's taking so long for every
hard link to be created (on average) that the IO subsystem can
handle the read/write IO demands with ease because there is
realtively little IO being issued.

> The OP is seeing 100% CPU for the cp operation, almost no IO, and no
> iowait.  If XFS or RMW were introducing any latency I'd think we'd see
> some iowait.

Right, so that leads to the conclusion that the freespace
fragmentation is definitely a potential cause of the excessive CPU
usage....

> Thus I believe at this point, the problem is those millions of serial
> user space calls in a single Perl thread causing the high CPU burn,
> little IO, and long run time, not XFS nor the storage.  And I think the
> OP came to this conclusion as well, without waiting on our analysis of
> his filesystem.

Using perf to profile the kernel while the cp -al workload is
running will tell use exactly where the CPU is being burnt. That
will confirm the analysis, or point us at some other issue that is
causing excessive CPU burn...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
