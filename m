Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f196.google.com ([209.85.166.196]:40510 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfE1RQx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 May 2019 13:16:53 -0400
Received: by mail-it1-f196.google.com with SMTP id h11so5149084itf.5
        for <linux-xfs@vger.kernel.org>; Tue, 28 May 2019 10:16:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAMCX63xyxZwiPd0602im0M0m4jzSNfB3DcF1RekQ6A-03vXTmg@mail.gmail.com>
 <20190521224904.GI29573@dread.disaster.area> <CAMCX63zNvLCDE5ZmY-rUuF7JfL9Uauq4jvzPZuDecovUSnCLNQ@mail.gmail.com>
 <20190527033240.GA29573@dread.disaster.area>
In-Reply-To: <20190527033240.GA29573@dread.disaster.area>
From: Jeffrey Baker <jwbaker@gmail.com>
Date: Tue, 28 May 2019 10:16:39 -0700
Message-ID: <CAMCX63wUkBh==QFoeRSTxFKGdoo5iDLS6hM5xcVLK8_LfVdhwg@mail.gmail.com>
Subject: Re: Recurring hand in XFS inode reclaim on 4.10
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Sun, May 26, 2019 at 8:32 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, May 24, 2019 at 01:34:58PM -0700, Jeffrey Baker wrote:
> > On Tue, May 21, 2019 at 3:49 PM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Tue, May 21, 2019 at 09:21:10AM -0700, Jeffrey Baker wrote:
> > > > I have a problem of recurring hangs on machines where I get hung task
> > > > warnings for kswapd and many user threads stuck in lstat. At the time,
> > > > I/O grinds to a halt, although not quite to zero. These hangs happen
> > > > 1-2 times per day on a fleet of several thousand machines. We'd like
> > > > to understand the root cause, if it is already known, so we can figure
> > > > out the minimum kernel to which we might want to update.
> > > >
> > > > These are the hung task stacks:
> > > >
> > > > kswapd0         D    0   279      2 0x00000000
> > > > Call Trace:
> > > >  __schedule+0x232/0x700
> > > >  schedule+0x36/0x80
> > > >  schedule_preempt_disabled+0xe/0x10
> > > >  __mutex_lock_slowpath+0x193/0x290
> > > >  mutex_lock+0x2f/0x40
> > > >  xfs_reclaim_inodes_ag+0x288/0x330 [xfs]
> > >
> > > You're basically running the machine out of memory and there
> > > are so many direct reclaimers that all the inode reclaim parallelism in
> > > the filesystem has been exhausted and it's blocking waiting for
> > > other reclaim to complete.
> >
> > Sort of.  "Out of memory" here means > 2GB free, admittedly that's
> > less than 1% of the machine.
>
> By "out of memory" I meant that your machine appears to have been at
> or below the memory reclaim watermarks for an extended period of
> time, not that there is no free memory at all.

Indeed, we always have one NUMA zone at the low water mark, although
we have zone reclaim disabled.

>
> > > > kswapd1         D    0   280      2 0x00000000
> > > > Call Trace:
> > > >  __schedule+0x232/0x700
> > > >  schedule+0x36/0x80
> > > >  schedule_timeout+0x235/0x3f0
> > > >  ? blk_finish_plug+0x2c/0x40
> > > >  ? _xfs_buf_ioapply+0x334/0x460 [xfs]
> > > >  wait_for_completion+0xb4/0x140
> > > >  ? wake_up_q+0x70/0x70
> > > >  ? xfs_bwrite+0x24/0x60 [xfs]
> > > >  xfs_buf_submit_wait+0x7f/0x210 [xfs]
> > > >  xfs_bwrite+0x24/0x60 [xfs]
> > > >  xfs_reclaim_inode+0x313/0x340 [xfs]
> > > >  xfs_reclaim_inodes_ag+0x208/0x330 [xfs]
> > >
> > > Yup, memory reclaim is pushing so hard it is doing direct writeback
> > > of dirty inodes.
> >
> > OK.  Is that reflected in vmstat somewhere?  I see
> > "nr_vmscan_immediate_reclaim" but it's not obvious to me what that is,
> > and it wasn't increasing at the moment of this event.
>
> Nope, not for low level filesystem inode reclaim like this. Getting
> the filesystem to do writeback from the inode shrinker is relatively
> uncommon.
>
> > > > All other hung threads are stuck in the third stack.
> > > >
> > > > We are using the Ubuntu 16.04 kernel, 4.10.0-40-generic
> > > > #44~16.04.1-Ubuntu. The machines involved have 20-core / 40-thread
> > > > Intel CPUs, 384 GiB of main memory, and four nvme devices in an md
> > > > RAID 0.  The filesystem info is:
> > > >
> > > > # xfs_info /dev/md0
> > > > meta-data=/dev/md0               isize=256    agcount=6, agsize=268435455 blks
> > > >          =                       sectsz=512   attr=2, projid32bit=0
> > > >          =                       crc=0        finobt=0 spinodes=0
> > > > data     =                       bsize=4096   blocks=1562366976, imaxpct=5
> > > >          =                       sunit=0      swidth=0 blks
>
> FWIW, I just noticed you don't have a sunit/swidth set for you
> md RAID 0, which means you only have 6 AGs rather than 32. So
> there's a lot less allocation and reclaim concurrency in this
> filesystem that we'd normally see for a 4x RAID0 stripe....

To some extent this has been a forensic exercise for me to figure out
how and why these filesystems were deployed like this. I think it was
believed at the time that su/sw has a magic automatic value of 0.

>
> > > This looks to me like something below the filesystem choking up and
> > > grinding to a halt. What are all the nvme drives doing over this
> > > period?
> >
> > Write rates on the nvme drives are all exactly the md0 rates / 4, so
> > that seems normal.
>
> Write rates aren't that important - what do the io latencies, queue
> depths and device utilisation figures look like?

10s of microseconds, ~zero, and ~zero respectively.

> > > Hard to know what is going on at this point, though, but nothing
> > > at the filesystem or memory reclaim level should be stuck on IO for
> > > long periods of time on nvme SSDs...
> > >
> > > /me wonders if 4.10 had the block layer writeback throttle code in
> > > it, and if it does whether that is what has gone haywire here.
> >
> > That is an interesting point.  I do see this on a different, healthy box
> >
> > # cat /sys/kernel/debug/bdi/9\:0/stats
> > BdiWriteback:             4320 kB
> > BdiReclaimable:           2304 kB
> > BdiDirtyThresh:        4834552 kB
> > DirtyThresh:           4834552 kB
> > BackgroundThresh:      2414324 kB
> > BdiDirtied:         5316993504 kB
> > BdiWritten:         4732763040 kB
> > BdiWriteBandwidth:        6060 kBps
>
> That's the currently used write bandwidth of the backing device. The
> block layer writeback throttle is below this. i.e. This simply
> reflects the rate at which data is currently being written to the
> block device.
>
> > One hopes that no throttling is based on this estimate of 6MB/s since
> > this array is capable of more like 10000MB/s. At this time we're
> > focusing on system tunables that might prevent the machine from
> > getting into serious trouble with dirty pages or reclaim or whatever.
> > I know XFS has only a handful of tunables. Do you think it's
> > recommendable to lower the xfssynd timer from 30s to something else?
> > Our workload _is_ metadata-heavy; I see about 100 create/remove ops
> > per second
>
> FWIW, that's not what I'd call metadata heavy. XFS on a 4-SSD array with
> 20 CPU cores can sustain somewhere around 300,000 create/removes a
> second before it runs out of CPU. 100/s is barely a blip above
> idle....

Quite.  That's part of the mystery: why the machine derps to a halt
while also barely accessing its abilities. What I meant, though, was
that the metadata rate is fairly high in my experience in proportion
to the amount of other I/O, which is also pretty low here.

>
> > and the log stats are rapidly increasing. By contrast we're
> > not really pushing the extent allocator at all.
> >
> > extent_alloc 10755989 500829395 3030459 4148636182
> > abt 0 0 0 0
> > blk_map 3012410686 1743133993 196385287 18176676 100618849 659563291 0
> > bmbt 0 0 0 0
> > dir 112134 99359626 99358346 49393915
>
> Ok, so 100M files created and removed since boot.
>
> > trans 98 4036033830 0
>
> All async transactions.
>
> > ig 99320520 98796299 5890 524221 0 523020 140279
> > log 1339041912 2184819896 0 1341870387 1341704946
>       writes     blocks     |   forces   force_waits
>                          noiclogs
>
> Ok, so why are the so many log forces (1.34 /billion/)? There's
> roughly a log force in every 3rd transaction, but they aren't from
> the transaction commit (because they are async transactions).
>
> > push_ail 4109383649 0 37995385 2614017 0 136962 25152 3301200 0 47933
>          try_logspace | pushes   success | pinned   |  flushing | flush
>                sleep_logspace           pushbuf   locked     restarts
>
> They aren't coming from the metadata writeback code (pinned count),
> and the log is not blocking on free space. i.e. there's no metadata
> writeback bottleneck occurring.
>
> > xstrat 589377 0
> > rw 3561425929 1342108567
>
> Oh, 1.34 billion writes. You're doing O_DSYNC writes, yes? And lots
> of them to every file that is created?
>
> > attr 3297942617 0 0 0
> > icluster 1452111 945722 3364798
> > vnodes 1201 0 0 0 99307909 99307909 99307909 0
> > buf 779252853 2349573 776924344 978078 41302 2328509 0 2491287 1090
> > abtb2 13886237 90593055 270338 266221 17 15 4555 1481 1188 2529 30 22
> > 47 37 93926009
> > abtc2 28760802 203677378 13739372 13735284 45 43 3270 1292 1935 1691
> > 57 50 102 93 1413028741
> > bmbt2 14355745 140867292 7158285 7115081 8 2 4074 4122 25396 4074 230
> > 48 238 50 6974741
> > ibt2 397071627 776203283 67846 67820 0 0 0 0 0 0 0 0 0 0 413
>
> For 100M files created/removed, to only see ~68000 inode btree
> record inserts and removes implies that the filesystem is
> efficiently reusing the freed inodes. i.e. there's pretty much a
> steady state of inodes in use in the workload....
>
> > fibt2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
> > rmapbt 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
> > refcntbt 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
> > qm 0 0 0 0 0 0 0 0
> > xpc 17666569097216 111928912437311 80399355018480
>                        write_bytes    read_bytes
>
> Assuming this is the only substantially active XFS filesystem on the
> system, that's 101TiB written to those drives, in 1.34 billion writes,
> which is an average of 82KiB per write. Assuming that the 32 bit
> write counter has not wrapped. Given that the transaction counter is
> nearly at the wrap point, and the read counter is at 3.5B for ~75TiB
> (average 22KiB), let's assume that the write counter has wrapped
> and we have ~5.5 billion writes. That gives an average write of just
> on 20KiB which kinda matches the read....
>
> So the drives look like they are being constantly hammered with
> small, synchronous IOs. This means write amplification is likely to
> be a substantial problem for them. They've had a /lot/ of data
> written to them and are under constant load so there's no time for
> idle cleanup, so is it possible that the drives themselves are
> having internal garbage collection related slowdowns?

That's certainly not impossible, although these are Very Fancy(tm)
devices.  I'll have a look at the logs.

Thanks again,
jwb

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
