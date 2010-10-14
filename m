Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9ELFLtm074255 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 16:15:21 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D58B3191AD43
	for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 14:16:28 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	ncLWkmvsdrFdwiHl for <xfs@oss.sgi.com>;
	Thu, 14 Oct 2010 14:16:28 -0700 (PDT)
Date: Fri, 15 Oct 2010 08:16:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH 0/2] xfs: dynamic speculative preallocation for
	delalloc
Message-ID: <20101014211626.GD4681@dastard>
References: <1286187236-16682-1-git-send-email-david@fromorbit.com>
	<1287076952.2362.519.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1287076952.2362.519.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 14, 2010 at 12:22:32PM -0500, Alex Elder wrote:
> On Mon, 2010-10-04 at 21:13 +1100, Dave Chinner wrote:
> > When multiple concurrent streaming writes land in the same AG,
> > allocation of extents interleaves between inodes and causes
> > excessive fragmentation of the files being written. That instead of
> > getting maximally sized extents, we'll get writeback range sized
> > extents interleaved on disk. that is for four files A, B, C and D,
> > we'll end up with extents like:
> > 
> >    +---+---+---+---+---+---+---+---+---+---+---+---+
> >      A1  B1  C1  D1  A2  B2  C2  A3  D2  C3  B3  D3 .....
> > 
> > instead of:
> > 
> >    +-----------+-----------+-----------+-----------+
> >          A           B           C           D
> > 
> > It is well known that using the allocsize mount option makes the
> > allocator behaviour much better and more likely to result in
> > the second layout above than the first, but that doesn't work in all
> > situations (e.g. writes from the NFS server). I think that we should
> > not be relying on manual configuration to solve this problem.
> > 
> 
> . . . (deleting some of your demonstration detail)
> 
> > The same results occur for tests running 16 and 64 sequential
> > writers into the same AG - extents of 8GB in all files, so
> > this is a major improvement in default behaviour and effectively
> > means we do not need the allocsize mount option anymore.
> > 
> > Worth noting is that the extents still interleave between files -
> > that problem still exists - but the size of the extents now means
> > that sequential read and write rates are not going to be affected
> > by excessive seeks between extents within each file.
> 
> Just curious--do we have any current and meaningful
> information about the trade-off between the size of an
> extent and seek time?  Obviously maximizing the extent
> size will maximize the bang (data read) for the buck (seek
> cost) but can we quantify that with current storage device
> specs?  (This is really a theoretical aside...)

The reported numbers were a drop in read throughput of ~15% on a
GB/s class filesystem when the files interleaved.

Fundamentally, it's a pretty simple equation. If the average seek
time is 5ms, and your disk runs at 100MB/s, then you lose 500kB/s
for every seek. while you are doing 20 seeks/s, then typically
you'll see 90MB/s, which is still pretty close to disk speed and
most people won't notice.

However, if your disk subsystem does 1GB/s, that 20 seeks/s is now
100MB/s and is very noticable. The latency of the seek does not
change as the bandwidth of the volume goes up, so the per-seek
bandwidth penalty is significantly higher. Even readahead cannot
hide the latency penalty if the number of seeks increases too
much...

> > Given this demonstratably improves allocation patterns, the only
> > question that remains in my mind is exactly what algorithm to use to
> > scale the preallocation.  The current patch records the last
> > prealloc size and increases the next one from that. While that
> > preovides good results, it will cause problems when interacting with
> > truncation. It also means that a file may have a substantial amount
> > of preallocatin beyond EOF - maybe several times the size of the
> > file.
> 
> I honestly haven't looked into this yet, but can you expand on
> the truncation problems you mention?  Is it that the preallocated
> blocks should be dropped and the scaling algorithm should be
> reset when a truncation occurs or something?

Create a large file. preallocation size goes:

	64k
	256k
	1024k
	4096k
	16M
	64M
	256M

now truncate the file. The write one block. Preallocation size is
now 1GB.

I've actually changed this now after doing more testing to be based
on the current file size. From my current commit message for the
patch:

For default settings, the size and the initial extents is determined
by the number of parallel writers and the amount of memory in the
machine. For 4GB RAM and 4 concurrent 32GB file writes:

EXT: FILE-OFFSET           BLOCK-RANGE          AG AG-OFFSET                 TOTAL
   0: [0..1048575]:         1048672..2097247      0 (1048672..2097247)      1048576
   1: [1048576..2097151]:   5242976..6291551      0 (5242976..6291551)      1048576
   2: [2097152..4194303]:   12583008..14680159    0 (12583008..14680159)    2097152
   3: [4194304..8388607]:   25165920..29360223    0 (25165920..29360223)    4194304
   4: [8388608..16777215]:  58720352..67108959    0 (58720352..67108959)    8388608
   5: [16777216..33554423]: 117440584..134217791  0 (117440584..134217791) 16777208
   6: [33554424..50331511]: 184549056..201326143  0 (184549056..201326143) 16777088
   7: [50331512..67108599]: 251657408..268434495  0 (251657408..268434495) 16777088

and for 16 concurrent 16GB file writes:

 EXT: FILE-OFFSET           BLOCK-RANGE          AG AG-OFFSET                 TOTAL
   0: [0..262143]:          2490472..2752615      0 (2490472..2752615)       262144
   1: [262144..524287]:     6291560..6553703      0 (6291560..6553703)       262144
   2: [524288..1048575]:    13631592..14155879    0 (13631592..14155879)     524288
   3: [1048576..2097151]:   30408808..31457383    0 (30408808..31457383)    1048576
   4: [2097152..4194303]:   52428904..54526055    0 (52428904..54526055)    2097152
   5: [4194304..8388607]:   104857704..109052007  0 (104857704..109052007)  4194304
   6: [8388608..16777215]:  209715304..218103911  0 (209715304..218103911)  8388608
   7: [16777216..33554423]: 452984848..469762055  0 (452984848..469762055) 16777208


> > However, the current algorithm does work well when writing lots of
> > relatively small files (e.g. up to a few tens of megabytes), as
> > increasing the preallocation size fast reduces the chances of
> > interleaving small allocations.
> 
> One thing that I keep wondering about as I think about this
> is what the effect is as the file system (or AG) gets full,

New speculative preallocation does not occur when ENOSPC is reported.

> and what level of "full" is enough to make any adverse
> effects of a change like this start to show up.  The other
> thing is, what sort of workloads are reasonable things to
> use to gauge the effect?

Anything that does concurrent buffered writes to the same directory.
Databases, DVRs, MPI applications, etc. Anything you'd use the
allocsize mount option for. ;)

> > We need to make the same write patterns result in equivalent
> > allocation patterns even when they come through the NFS server.
> > Right now the NFS server uses a file descriptor for each write that
> > comes across the wire. This means that the ->release function is
> > called after every write, and that means XFS will be truncating away
> > the speculative preallocation it did during the write. Hence we get
> > interleaving files and fragmentation.
> 
> It could be useful to base the behavior on actual knowledge
> that a file system is being exported by NFS.  But it may well
> be that other applications (like shell scripts that loop and
> append to the same file repeatedly) might benefit.

We have no knowledge of whether the filesystem is exported or not.
I could a "current_task_is_nfsd" hack in there, but I'd rather not
go to that extreme.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
