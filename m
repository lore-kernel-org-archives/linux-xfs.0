Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 14:58:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9MLw7Y9024434
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 14:58:08 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BEA655306B4
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 14:59:52 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id YZ3O8Sc3iWOU0JaW for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 14:59:52 -0700 (PDT)
Date: Thu, 23 Oct 2008 08:59:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: small logs that fit in RAID controller cache are (sometimes)
	faster
Message-ID: <20081022215949.GT18495@disturbed>
References: <20081022074031.GA19754@cordes.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022074031.GA19754@cordes.ca>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Cordes <peter@cordes.ca>
Cc: xfs@oss.sgi.com

On Wed, Oct 22, 2008 at 04:40:31AM -0300, Peter Cordes wrote:
>  I've been playing with external vs. internal logs, and log sizes, on
> a HW RAID controller w/256MB of battery-backed cache.  I'm getting the
> impression that for a single-threaded untar workload at least, a small
> log (5 or 20MB) is actually faster 128MB.  I think when the log is
> small enough relative to the RAID controller's write-back cache, the
> writes don't have to wait for actual disk.  It's (maybe) like having
> the log on a ramdisk.  Battery-backed write caches on RAID controllers
> make nobarrier safe (right?), so that's what I was using.

[snip lots of stuff]

Basically it comes down to the fact that the default (internal 128MB
log) is pretty much the fastest option when you have a battery
backed cache, right?

>  untar times:
> 110s w/  a 128MB internal log (note that the max sequential write is
>            at least ~3x higher for the RAID6 the internal log is on)
> 116s w/  a 128MB external log
> 113s with a 96MB external log
> 110s with a 64MB external log
> 115s with a 20MB external log
> 110s with a  5MB external log

In general, a small log is going to limit your transaction
parallelism. You are running a single threaded workload, so that's
not a big deal. Note that with a 16k directory block size, the
transaction reservation sizes are in the order of 3MB, which means
that with a 5MB log you'll completely serialise directory
modifications.  IOWs, don't do it.

Larger logs are better because they allow many transactions to be
executed in parallel - something that happens alot on a fileserver.
Also, large logs allow writeback of metadata to be avoided when it
is frequently modified and relogged.  Metadata writeback is
typically a small random write pattern....

>  I'm thinking of creating the FS with a 96MB external log, but I
> haven't tested with parallel workloads with logs < 128MB.  This RAID
> array also holds /home (on the first 650GB of array), while this FS
> (/data) is the last 2.2TB.  /home uses an internal log, so if
> someone's keeping /home busy and someone else is keeping /data busy,
> their logs won't both be going to the RAID6.

That's pretty much irrelevant if you have a couple hundred MB of
write cache - the write cache will buffer each sequential log I/O
stream until they span full RAID stripes and then it will sync them
to disk as efficiently as possible. That's why the 128MB internal
log performs so well......

> (I also use agcount=8 on
> /data, agcount=7 on /home.  Although I/O will probably be bursty, and
> not loading /home and /data at the same time, my main concern is to
> avoid scattering files in too many places.  fewer AGs = more locality
> for a bunch of sequentially created files, right?  I have 8 spindles
> in the RAID, so that seemed like a good amount of AGs.  RAID6 doesn't
> like small scattered writes _at_ _all_.)

AGs are for allocation parallelism. That is, only one allocation or
free can be taking place in an AG at once. If you have lots of
threads banging on the filesystem, you need enough AGs to prevent
modifcation of the free space trees being the bottleneck. The data
in each AG will be packed as tightly as possible....

BTW, there is no real correlation between spindle count and # of
AGs for stripe based volumes as all AGs span all spindles. If you
have a linear concatenation, then you have the case where the
number of AGs should match or be a multiple of the number of
spindles. The allows AGs to operate completely independently
of each other....

>  Basically, I really want to ask if my mkfs parameters look good
> before I let users start filling up the filesystems and running jobs
> on the cluster, making it hard to redo the mkfs.  Am I doing anything
> that looks silly?

Oh, it's a cluster that will be banging on the filesystem? That's
a parallel workload. See above comments about log size and agcount
for parallelism. ;)

>  BTW, is there a way to mount the root filesystem with inode64?  If I
> put that in my fstab, it only tries to do it with a remount (which
> doesn't work), because I guess Ubuntu's initrd doesn't have mount
> options from /etc/fstab.  I made my root fs 10GB, and with imaxpct=8,
> so the 32bit inode allocator should do ok.

The inode64 allocator is used on all filesystems smaller than 1TB.
inode32 only takes over when filesystems grow larger than that.

>  I found -n size=16k helps with random deletion speed, IIRC.  I only

Helps with lots of directory operations - the btrees are wider and
shallower which means less I/O for lookups, less allocations and
deletions of btree blocks, etc.

> use that on the big RAID6 filesystems, not / or /var/tmp, since users
> won't be making their huge data file directories anywhere else.
> Bonnie++ ends up with highly fragmented directories (xfs_bmap) after
> random-order file creation.

And the larger directory block sizes reduces fragmentation....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
