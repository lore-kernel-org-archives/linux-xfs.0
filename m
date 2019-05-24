Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f195.google.com ([209.85.166.195]:50935 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfEXUfL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 May 2019 16:35:11 -0400
Received: by mail-it1-f195.google.com with SMTP id a186so8035104itg.0
        for <linux-xfs@vger.kernel.org>; Fri, 24 May 2019 13:35:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAMCX63xyxZwiPd0602im0M0m4jzSNfB3DcF1RekQ6A-03vXTmg@mail.gmail.com>
 <20190521224904.GI29573@dread.disaster.area>
In-Reply-To: <20190521224904.GI29573@dread.disaster.area>
From: Jeffrey Baker <jwbaker@gmail.com>
Date: Fri, 24 May 2019 13:34:58 -0700
Message-ID: <CAMCX63zNvLCDE5ZmY-rUuF7JfL9Uauq4jvzPZuDecovUSnCLNQ@mail.gmail.com>
Subject: Re: Recurring hand in XFS inode reclaim on 4.10
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 3:49 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, May 21, 2019 at 09:21:10AM -0700, Jeffrey Baker wrote:
> > I have a problem of recurring hangs on machines where I get hung task
> > warnings for kswapd and many user threads stuck in lstat. At the time,
> > I/O grinds to a halt, although not quite to zero. These hangs happen
> > 1-2 times per day on a fleet of several thousand machines. We'd like
> > to understand the root cause, if it is already known, so we can figure
> > out the minimum kernel to which we might want to update.
> >
> > These are the hung task stacks:
> >
> > kswapd0         D    0   279      2 0x00000000
> > Call Trace:
> >  __schedule+0x232/0x700
> >  schedule+0x36/0x80
> >  schedule_preempt_disabled+0xe/0x10
> >  __mutex_lock_slowpath+0x193/0x290
> >  mutex_lock+0x2f/0x40
> >  xfs_reclaim_inodes_ag+0x288/0x330 [xfs]
>
> You're basically running the machine out of memory and there
> are so many direct reclaimers that all the inode reclaim parallelism in
> the filesystem has been exhausted and it's blocking waiting for
> other reclaim to complete.

Sort of.  "Out of memory" here means > 2GB free, admittedly that's
less than 1% of the machine.

>
> > kswapd1         D    0   280      2 0x00000000
> > Call Trace:
> >  __schedule+0x232/0x700
> >  schedule+0x36/0x80
> >  schedule_timeout+0x235/0x3f0
> >  ? blk_finish_plug+0x2c/0x40
> >  ? _xfs_buf_ioapply+0x334/0x460 [xfs]
> >  wait_for_completion+0xb4/0x140
> >  ? wake_up_q+0x70/0x70
> >  ? xfs_bwrite+0x24/0x60 [xfs]
> >  xfs_buf_submit_wait+0x7f/0x210 [xfs]
> >  xfs_bwrite+0x24/0x60 [xfs]
> >  xfs_reclaim_inode+0x313/0x340 [xfs]
> >  xfs_reclaim_inodes_ag+0x208/0x330 [xfs]
>
> Yup, memory reclaim is pushing so hard it is doing direct writeback
> of dirty inodes.

OK.  Is that reflected in vmstat somewhere?  I see
"nr_vmscan_immediate_reclaim" but it's not obvious to me what that is,
and it wasn't increasing at the moment of this event.

> > mysqld          D    0 89015 116527 0x00000080
> > Call Trace:
> >  __schedule+0x232/0x700
> >  ? __remove_hrtimer+0x3c/0x70
> >  schedule+0x36/0x80
> >  rwsem_down_read_failed+0xf9/0x150
> >  ? xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
> >  call_rwsem_down_read_failed+0x18/0x30
> >  ? xfs_trans_roll+0x40/0x40 [xfs]
> >  down_read+0x20/0x40
> >  xfs_ilock+0xe5/0x110 [xfs]
> >  xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
> >  xfs_attr_get+0xd3/0x180 [xfs]
> >  xfs_xattr_get+0x4b/0x70 [xfs]
> >  __vfs_getxattr+0x57/0x70
> >  get_vfs_caps_from_disk+0x59/0x100
> >  audit_copy_inode+0x6d/0xb0
> >  __audit_inode+0x1bb/0x320
> >  filename_lookup+0x128/0x180
>
> Somebody else has the inode locked doing something with it, so the
> audit code has to wait for it to finish before it can continue. This
> likely has nothing to do with memory reclaim, and more likely is
> backed up behind a transaction or something doing IO....
>
> >  ? __check_object_size+0x108/0x1e3
> >  ? path_get+0x27/0x30
> >  ? __audit_getname+0x96/0xb0
> >  user_path_at_empty+0x36/0x40
> >  vfs_fstatat+0x66/0xc0
> >  SYSC_newlstat+0x31/0x60
> >  ? syscall_trace_enter+0x1d9/0x2f0
> >  ? __audit_syscall_exit+0x230/0x2c0
> >  SyS_newlstat+0xe/0x10
> >  do_syscall_64+0x5b/0xc0
> >  entry_SYSCALL64_slow_path+0x25/0x25
> >
> > All other hung threads are stuck in the third stack.
> >
> > We are using the Ubuntu 16.04 kernel, 4.10.0-40-generic
> > #44~16.04.1-Ubuntu. The machines involved have 20-core / 40-thread
> > Intel CPUs, 384 GiB of main memory, and four nvme devices in an md
> > RAID 0.  The filesystem info is:
> >
> > # xfs_info /dev/md0
> > meta-data=/dev/md0               isize=256    agcount=6, agsize=268435455 blks
> >          =                       sectsz=512   attr=2, projid32bit=0
> >          =                       crc=0        finobt=0 spinodes=0
> > data     =                       bsize=4096   blocks=1562366976, imaxpct=5
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > log      =internal               bsize=4096   blocks=521728, version=2
> >          =                       sectsz=512   sunit=1 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> >
> > The tasks above were reported as hung at 22:51:55, so they'd been dead
> > since 22:49:55 at the latest.  The stats from around that time seem
> > pretty normal.
>
> So you've got processes stuck waiting a couple of minutes for IO
> on nvme drives? That doesn't sound like a filesystem problem - that
> sounds more like lost IOs, a hung MD array, or hardware that's gone
> AWOL....

Sure, it could be any of these things. We're trying to get to the
bottom of why the software appears to do nothing while the hardware
appears to be working perfectly. In particular why the kswapd thread
is waiting on I/O but there's none/very little happening.

>
> > 22:48:02  memtotal memfree buffers cached dirty slabmem  swptotal swpfree _mem_
> > 22:48:07   385598M   2199M    115M 23773M   14M   2435M        0M      0M
>
> Nothing unusual there - still lots of reclaimable page cache, and
> some slabmem, too.
>
> > Something is obviously wrong with atop's analysis of md0 I/O rate
> > here, but you get the idea: I/O slides over a minute from a reasonable
> > rate to near zero, except for one big spike of output.
> >
> > # atopsar -r /var/log/atop/atop_20190517 -b 22:48:00 -e 22:53:00 -f
> >
> > 22:48:02  disk           busy read/s KB/read  writ/s KB/writ avque avserv _mdd_
> > 22:48:07  md0              0% 1208.4     6.9  2569.0     6.6   0.0   0.00 ms
> > 22:48:12  md0              0% 1294.1     7.0  2642.5     6.6   0.0   0.00 ms
> > 22:48:17  md0              0% 1289.0     6.9  2823.5     6.8   0.0   0.00 ms
> > 22:48:22  md0              0% 1376.3     6.9  2662.6     6.7   0.0   0.00 ms
> > 22:48:27  md0              0% 1332.3     6.8  2578.7     6.3   0.0   0.00 ms
> > 22:48:32  md0              0% 1338.2     6.9  2601.7     6.5   0.0   0.00 ms
> > 22:48:37  md0              0% 1133.7     6.8  3172.3     6.9   0.0   0.00 ms
> > 22:48:42  md0              0% 1377.4     6.8  2609.3     6.8   0.0   0.00 ms
> > 22:48:47  md0              0% 1353.4     6.9  2293.6     6.5   0.0   0.00 ms
> > 22:48:52  md0              0% 1291.8     6.9  2200.5     6.3   0.0   0.00 ms
> > 22:48:57  md0              0% 1332.2     7.0  3066.1     6.9   0.0   0.00 ms
> > 22:49:02  md0              0% 1275.6     6.9  3021.2     6.8   0.0   0.00 ms
> > 22:49:07  md0              0% 1306.6     6.4  4407.2    10.4   0.0   0.00 ms
> > 22:49:12  md0              0% 1172.4     6.6  2740.4     7.1   0.0   0.00 ms
> > 22:49:17  md0              0%  468.4     4.9  2769.7     6.6   0.0   0.00 ms
>
> IO rates take a hit here, about 40s before the processes got stuck.
>
> > 22:49:22  md0              0%  422.3     4.9  2950.9     7.0   0.0   0.00 ms
> > 22:49:27  md0              0%  364.7     4.9  2744.3     7.0   0.0   0.00 ms
> > 22:49:32  md0              0%  254.6     4.7  6271.1     8.8   0.0   0.00 ms
> > 22:49:37  md0              0%  289.6     4.6  2108.7     6.8   0.0   0.00 ms
> > 22:49:42  md0              0%  276.1     4.7  2278.3     6.7   0.0   0.00 ms
> > 22:49:47  md0              0%  266.2     4.7  1990.3     7.0   0.0   0.00 ms
> > 22:49:52  md0              0%  274.9     4.7  2051.3     7.0   0.0   0.00 ms
> > 22:49:57  md0              0%  222.7     4.6  1770.4     7.1   0.0   0.00 ms
>
> Processes stick here just as the read rate takes another hit, and...
>
> > 22:50:02  md0              0%  104.1     4.5 22339.5     9.5   0.0   0.00 ms
>
> That's likely a burst of 8KB inode writes from the XFS inode
> reclaim code.
>
> > 22:50:07  md0              0%  132.9     4.4  6208.9     9.1   0.0   0.00 ms
> > 22:50:12  md0              0%  147.2     4.5   755.7     5.1   0.0   0.00 ms
> > 22:50:17  md0              0%  127.0     4.4   722.6     5.3   0.0   0.00 ms
> > 22:50:22  md0              0%  120.5     4.4   703.7     4.9   0.0   0.00 ms
> > 22:50:27  md0              0%  106.5     4.5   681.7     5.0   0.0   0.00 ms
> > 22:50:32  md0              0%  121.1     4.5   756.5     4.7   0.0   0.00 ms
> > 22:50:37  md0              0%  131.9     4.4   696.7     4.8   0.0   0.00 ms
> > 22:50:42  md0              0%  100.9     4.4   669.6     4.7   0.0   0.00 ms
> > 22:50:47  md0              0%   72.2     4.4   691.1     6.7   0.0   0.00 ms
> > 22:50:52  md0              0%    0.0     0.0   320.4     7.6   0.0   0.00 ms
>
> And a minute later everything has ground to a halt.
>
> > 22:50:57  md0              0%    0.2     4.0   115.1     6.5   0.0   0.00 ms
> > 22:51:02  md0              0%    0.0     0.0    62.5     5.7   0.0   0.00 ms
> > 22:51:07  md0              0%    0.2     4.0    23.0     4.2   0.0   0.00 ms
> > 22:51:12  md0              0%    0.2     4.0    22.6     4.1   0.0   0.00 ms
> > 22:51:17  md0              0%    0.0     0.0    22.4     4.1   0.0   0.00 ms
> > 22:51:22  md0              0%    0.2     4.0    26.0     4.4   0.0   0.00 ms
> > 22:51:27  md0              0%    0.0     0.0    25.4     5.6   0.0   0.00 ms
> > 22:51:32  md0              0%    0.0     0.0    22.6     4.1   0.0   0.00 ms
> > 22:51:37  md0              0%    0.0     0.0    21.5     4.1   0.0   0.00 ms
> > 22:51:42  md0              0%    0.0     0.0    26.0     5.4   0.0   0.00 ms
> > 22:51:47  md0              0%    0.0     0.0    22.2     4.1   0.0   0.00 ms
> > 22:51:52  md0              0%    0.0     0.0    23.4     4.1   0.0   0.00 ms
> > 22:51:57  md0              0%    0.2     4.0    26.0     5.6   0.0   0.00 ms
>
> This looks to me like something below the filesystem choking up and
> grinding to a halt. What are all the nvme drives doing over this
> period?

Write rates on the nvme drives are all exactly the md0 rates / 4, so
that seems normal.

>
> Hard to know what is going on at this point, though, but nothing
> at the filesystem or memory reclaim level should be stuck on IO for
> long periods of time on nvme SSDs...
>
> /me wonders if 4.10 had the block layer writeback throttle code in
> it, and if it does whether that is what has gone haywire here.

That is an interesting point.  I do see this on a different, healthy box

# cat /sys/kernel/debug/bdi/9\:0/stats
BdiWriteback:             4320 kB
BdiReclaimable:           2304 kB
BdiDirtyThresh:        4834552 kB
DirtyThresh:           4834552 kB
BackgroundThresh:      2414324 kB
BdiDirtied:         5316993504 kB
BdiWritten:         4732763040 kB
BdiWriteBandwidth:        6060 kBps

One hopes that no throttling is based on this estimate of 6MB/s since
this array is capable of more like 10000MB/s. At this time we're
focusing on system tunables that might prevent the machine from
getting into serious trouble with dirty pages or reclaim or whatever.
I know XFS has only a handful of tunables. Do you think it's
recommendable to lower the xfssynd timer from 30s to something else?
Our workload _is_ metadata-heavy; I see about 100 create/remove ops
per second and the log stats are rapidly increasing. By contrast we're
not really pushing the extent allocator at all.

extent_alloc 10755989 500829395 3030459 4148636182
abt 0 0 0 0
blk_map 3012410686 1743133993 196385287 18176676 100618849 659563291 0
bmbt 0 0 0 0
dir 112134 99359626 99358346 49393915
trans 98 4036033830 0
ig 99320520 98796299 5890 524221 0 523020 140279
log 1339041912 2184819896 0 1341870387 1341704946
push_ail 4109383649 0 37995385 2614017 0 136962 25152 3301200 0 47933
xstrat 589377 0
rw 3561425929 1342108567
attr 3297942617 0 0 0
icluster 1452111 945722 3364798
vnodes 1201 0 0 0 99307909 99307909 99307909 0
buf 779252853 2349573 776924344 978078 41302 2328509 0 2491287 1090
abtb2 13886237 90593055 270338 266221 17 15 4555 1481 1188 2529 30 22
47 37 93926009
abtc2 28760802 203677378 13739372 13735284 45 43 3270 1292 1935 1691
57 50 102 93 1413028741
bmbt2 14355745 140867292 7158285 7115081 8 2 4074 4122 25396 4074 230
48 238 50 6974741
ibt2 397071627 776203283 67846 67820 0 0 0 0 0 0 0 0 0 0 413
fibt2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
rmapbt 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
refcntbt 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
qm 0 0 0 0 0 0 0 0
xpc 17666569097216 111928912437311 80399355018480
debug 0

Thanks for your thoughts so far.

-jwb


>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
