Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:33261 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725811AbeIDFMW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Sep 2018 01:12:22 -0400
Date: Tue, 4 Sep 2018 10:49:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mkfs.xfs options suitable for creating absurdly large XFS
 filesystems?
Message-ID: <20180904004940.GR5631@dastard>
References: <20180903224919.GA16358@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180903224919.GA16358@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 03, 2018 at 11:49:19PM +0100, Richard W.M. Jones wrote:
> [This is silly and has no real purpose except to explore the limits.
> If that offends you, don't read the rest of this email.]

We do this quite frequently ourselves, even if it is just to remind
ourselves how long it takes to wait for millions of IOs to be done.

> I am trying to create an XFS filesystem in a partition of approx
> 2^63 - 1 bytes to see what happens.

Should just work. You might find problems with the underlying
storage, but the XFS side of things should just work.

> This creates a 2^63 - 1 byte virtual disk and partitions it:
> 
>   # nbdkit memory size=9223372036854775807
> 
>   # modprobe nbd
>   # nbd-client localhost /dev/nbd0
>   # blockdev --getsize64 /dev/nbd0
>   9223372036854774784

$ echo $((2**63 - 1))
9223372036854775807

So the block device size is (2**63 - 1024) bytes.

>   # gdisk /dev/nbd0
>   [...]
>   Command (? for help): n
>   Partition number (1-128, default 1):
>   First sector (18-9007199254740973, default = 1024) or {+-}size{KMGTP}:
>   Last sector (1024-9007199254740973, default = 9007199254740973) or {+-}size{KMGTP}:

What's the sector size of you device? This seems to imply that it is
1024 bytes, not the normal 512 or 4096 bytes we see in most devices.

>   Current type is 'Linux filesystem'
>   Hex code or GUID (L to show codes, Enter = 8300):
>   Changed type of partition to 'Linux filesystem'
>   Command (? for help): w
> 
> The first problem was that the standard mkfs.xfs command will
> try to trim the disk in 4 GB chunks (I believe this is a limit
> imposed by the kernel APIs).  For a 8 EB image that takes forever.

Not a mkfs bug. XFS does a single BLKDISCARD call for the entire
block device range (the ioctl takes u64 start/end ranges). This gets
passed down as 64 bit ranges to __blkdev_issue_discard(), which then
slices and dices the large range to the granularity advertised by
the underlying block device.

Check /sys/block/<nbd-dev>/queue/discard_max_[hw_]bytes. THe local
nvme drives I have on this machine advertise:

$ cat /sys/block/nvme0n1/queue/discard_max_hw_bytes
2199023255040

which is (2^41 - 512) bytes, more commonly known as (2^32 - 1)
sectors. Which, IIRC, is the maximum IO size that a single bio and
therefore a single discard request to the driver can support.

Hence if you are seeing 4GB discards on the NBD side, then the NBD
device must be advertising 4GB to the block layer as the
discard_max_bytes. i.e. this, at first blush, looks purely like a
NBD issue.

> However I can use the -K option to get around that:
> 
>   # mkfs.xfs -K /dev/nbd0p1
>   meta-data=/dev/nbd0p1            isize=512    agcount=8388609, agsize=268435455 blks
>            =                       sectsz=1024  attr=2, projid32bit=1

Oh, yeah, 1kB sectors. How weird is that - I've never seen a block
device with a 1kB sector before.

>            =                       crc=1        finobt=1, sparse=0, rmapbt=0, reflink=0
>   data     =                       bsize=4096   blocks=2251799813684987, imaxpct=1
>            =                       sunit=0      swidth=0 blks
>   naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
>   log      =internal log           bsize=4096   blocks=521728, version=2
>            =                       sectsz=1024  sunit=1 blks, lazy-count=1
>   realtime =none                   extsz=4096   blocks=0, rtextents=0
>   mkfs.xfs: read failed: Invalid argument
> 
> I guess this indicates a real bug in mkfs.xfs.

Did it fail straight away? Or after a long time?  Can you trap this
in gdb and post a back trace so we know where it is coming from?

As it is:

$ man 2 read
....
	EINVAL
		fd  is  attached  to an object which is unsuitable
		for reading; or the file was opened with the
		O_DIRECT flag, and either the address specified in
		buf, the value specified in count, or the file
		offset is not suitably aligned.

mkfs.xfs uses direct IO on block devices, so this implies that the
underlying block device rejected the IO for alignment reasons.

I'm trying to reproduce it here:

$ grep vdd /proc/partitions 
 253       48 9007199254739968 vdd
$ sudo mkfs.xfs -f -s size=1024 -d size=2251799813684887b -N /dev/vdd
meta-data=/dev/vdd               isize=512    agcount=8388609, agsize=268435455 blks
         =                       sectsz=1024  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=2251799813684887, imaxpct=1
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=1024  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


And it is running now without the "-N" and I have to wait for tens
of millions of IOs to be issued. The write rate is currently about
13,000 IOPS, so I'm guessing it'll take at least an hour to do
this. Next time I'll run it on the machine with faster SSDs.

I haven't seen any error after 20 minutes, though.

> I've not tracked down
> exactly why this syscall fails yet but will see if I can find it
> later.
> 
> But first I wanted to ask a broader question about whether there are
> other mkfs options (apart from -K) which are suitable when creating
> especially large XFS filesystems?

Use the defaults - there's nothing you can "optimise" to make
testing like this go faster because all the time is in
reading/writing AG headers. There's millions of them, and there are
cases where they may have to all be read at mount time, too. Be
prepared to wait a long time for simple things to happen...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
