Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57168 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbfCYPrr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Mar 2019 11:47:47 -0400
Date: Mon, 25 Mar 2019 08:47:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [QUESTION] Long read latencies on mixed rw buffered IO
Message-ID: <20190325154731.GT1183@magnolia>
References: <CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com>
 <20190325001044.GA23020@dastard>
 <CAOQ4uxhu=Qtme9RJ7uZXYXt0UE+=xD+OC4gQ9EYkDC1ap8Hizg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhu=Qtme9RJ7uZXYXt0UE+=xD+OC4gQ9EYkDC1ap8Hizg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Mar 25, 2019 at 09:49:33AM +0200, Amir Goldstein wrote:
> On Mon, Mar 25, 2019 at 2:10 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Sun, Mar 24, 2019 at 08:18:10PM +0200, Amir Goldstein wrote:
> > > Hi All,
> > >
> > > Christoph's re-factoring to xfs_ilock() brought up this question,
> > > but AFAICS, current behavior seems to have always been that
> > > way for xfs (?).
> > >
> > > Since commit 6552321831dc ("xfs: remove i_iolock and use
> > > i_rwsem in the VFS inode instead"), xfs_file_buffered_aio_read()
> > > is the only call sites I know of to call generic_file_read_iter() with
> > > i_rwsem read side held.
> >
> > That did not change the locking behaviour of XFS at all.
> 
> I know. Said so above.
> 
> >
> > > This lock is killing performance of multi-threaded buffered
> > > read/write mixed workload on the same file [1].
> > > Attached output of bcc tools [2] script xfsdist and ext4dist
> > > for latency distribution on the same mixed read/write workload.
> >
> > In future, can you just paste the text in line, rather than attach
> > it as base64 encoded attechments? They are kinda hard to quote.
> >
> > ext4 read :
> >
> > ....
> >     4 -> 7          : 2610
> > ....
> >  2048 -> 4095       : 232
> >  4096 -> 8191       : 632
> >  8192 -> 16383      : 925
> > 16384 -> 32767      : 408
> > ....
> >
> > ext4 write:
> >
> >     4 -> 7          : 16732
> >     8 -> 15         : 81712
> >    16 -> 31         : 121450
> >    32 -> 63         : 29638
> >
> > So about 4500 read IOPS, of which >50% are cache hits.
> > And ~250,000 write iops, all in less than 64 microseconds so
> > straight into cache. So we are looking at a ~50:1 write to read
> > ratio here.
> >
> > XFS read:
> >
> >          0 -> 1          : 8
> >          2 -> 3          : 21
> >          4 -> 7          : 17
> >  ....
> >       8192 -> 16383      : 4
> >      16384 -> 32767      : 8
> >      32768 -> 65535      : 17
> >      65536 -> 131071     : 55
> >     131072 -> 262143     : 41
> >     262144 -> 524287     : 104
> >     524288 -> 1048575    : 101
> >    1048576 -> 2097151    : 34
> >  ....
> >
> > XFS Write:
> >          4 -> 7          : 10087
> >          8 -> 15         : 34815
> >         16 -> 31         : 32446
> >         32 -> 63         : 3888
> >         64 -> 127        : 155
> >  ....
> >         <snip long tail>
> >
> > Which shows ~400 read ops (almost no cache hits)
> 
> It's not because of almost no cache hits.
> The pattern is the same as in ext4 test.
> It's because most reads are blocked on writes in slow path,
> as following sample stack stace from offwaketime bcc tool shows:
> 
> Tracing blocked time (us) by user + kernel off-CPU and waker stack...
> 
>     waker:           filebench 32155
>     entry_SYSCALL_64_after_hwframe
>     do_syscall_64
>     sys_pwrite64
>     vfs_write
>     __vfs_write
>     new_sync_write
>     xfs_file_write_iter
>     xfs_file_buffered_aio_write
>     xfs_iunlock
>     up_write
>     call_rwsem_wake
>     rwsem_wake
>     --               --
>     finish_task_switch
>     schedule
>     rwsem_down_read_failed
>     call_rwsem_down_read_failed
>     down_read
>     xfs_ilock
>     xfs_file_buffered_aio_read
>     xfs_file_read_iter
>     new_sync_read
>     __vfs_read
>     vfs_read
>     sys_pread64
>     do_syscall_64
>     entry_SYSCALL_64_after_hwframe
>     pread
>     target:          filebench 32147
>         109242
> 
> > and ~80,000 write
> > ops with a long latency tail. It's a roughly a 200:1 write to read
> > ratio.
> >
> > I'm guessing what we are seeing here is a rwsem starvation problem.
> > The only reason a read would get delayed for mor ethan a few hundred
> > microseconds is ifthere are a continual stream of write holders
> > starving pending reads.
> >
> 
> Yes. That seems to be the case.
> 
> > I don't recall it being this bad historically but rwsems have been
> > severely performance optimised for various corner cases over the
> > past few years and it is extremely likely that behaviour has
> > changed.  Definitely needs looking at, but rwsems are so fragile
> > these days (highly dependent on memory ordering that nobody seems to
> > be able to get right) and impossible to validate as correct that we
> > might just end up having to live with it.
> >
> > FWIW, What kernel did you test this on?
> 
> The results above are from kernel 4.20.7-1.el7.elrepo.x86_64.
> Your assumption about change of behavior of rwsem over the
> years seems to be correct.
> The original report we got from customer was with kernel 4.9.134
> In the original report, long latencies were on writes rather than on reads.
> The following output of filebench randomrw workload summarizes the results:
> 
> rand-write1          1128ops       19ops/s   0.1mb/s    340.3ms/op
> [0.03ms - 7933.27ms]
> rand-read1           2954684ops    49238ops/s 384.7mb/s      0.2ms/op
> [0.02ms - 5873.27ms]
> 61.026: IO Summary: 2955812 ops 49257.253 ops/s 49238/19 rd/wr
> 384.8mb/s   0.3ms/op
> 
> With more recent kernel (4.20), the latencies have shifted to the read ops:
> 
> rand-write1          467706ops     7794ops/s  60.9mb/s    0.733ms/op
> [0.004ms - 3899.167ms]
> rand-read1           1970ops       33ops/s   0.3mb/s  164.277ms/op
> [0.017ms - 3905.929ms]
> 61.032: IO Summary: 469676 ops 7826.760 ops/s 33/7794 rd/wr  61.1mb/s 1.419ms/op
> 
> In a workload of 100% reads or 100% writes, there are no extreme
> latencies or neither
> old nor new kernel.

Hmmm.... so it looks like the rw_semaphore behavior has shifted over
time, then?

I thought rwsem was supposed to queue read and write waiters in order,
at least on x86?  Though I suppose that might not matter much since we
can only run one writer at a time vs. waking up all the readers at once.
Now I'm wondering if there ever was a time when the readers all got
batched to the front and starved the writers, but eh I haven't drank
enough coffee to remember things like that. :P

(I wonder what would happen if rw_semaphore decided to wake up some
number of the readers in the rwsem wait_list, not just the ones at the
front...)

> >
> > http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> >
> 
> Granted, I wasn't reported a problem is the traditional sense of "what is
> the cause?" - that I know. I was asking why this change between xfs
> and other fs.
> I gathered a lot of traces and analysis from different tools and on
> different kernels
> during the investigation, so pouring them at all once would have been counter
> productive. I'll happily provide any required analysis per demand.
> 
> > > Compared to ext4, avg. read latency on RAID of spindles
> > > can be two orders of magnitude higher (>100ms).
> > > I can provide more performance numbers if needed with fio,
> > > but they won't surprise anyone considering the extra lock.
> > >
> > > This workload simulates a performance issue we are seeing
> > > on deployed systems. There are other ways for us to work
> > > around the issue, not using xfs on those systems would be
> > > one way, but I wanted to figure out the reason for this
> > > behavior first.
> >
> > The workload is 8 threads doing random 8k random reads and
> > 8 threads doing random writes to a single 5GB file?
> 
> Yes. To a preallocated file.
> 
> >
> > I'd be interested in seeing if a fio workload using 16 randrw
> > threads demonstrate the same latency profile (i.e. threads aren't
> > exclusively read- or write- only), or is profile coming about
> > specifically because you have dedicated write-only threads that will
> > continually bash on the IO locks and hence starve readers?
> 
> I guess it depends on the rw mix. With 50% r/w mix run on kernel
> 4.20.7-1.el7, long latencies are mostly on the write ops.
> 
> Gist of fio output inline and full output attached (Sorry, for folks who
> don't like scrolling down):
> 
> ---XFS---
> fio -filename=/xfsfolder/largefile1/00000001/00000001 -direct=0
> -iodepth 1 -thread -rw=randrw -rwmixread=50 -ioengine=psync -bs=8k
> -size=5G -numjobs=16 -runtime=60 -group_reporting -name=randrw_16th_8k
> ...
>    read: IOPS=264, BW=2117KiB/s (2168kB/s)(124MiB/60045msec)
>     clat (usec): min=148, max=491768, avg=39432.35, stdev=23039.80
> ...
>   write: IOPS=268, BW=2149KiB/s (2201kB/s)(126MiB/60045msec)
>     clat (usec): min=4, max=477942, avg=20673.33, stdev=26613.06
> 
> ---EXT4---
> fio -filename=/ext4folder/largefile1/00000001/00000001 -direct=0
> -iodepth 1 -thread -rw=randrw -rwmixread=50 -ioengine=psync -bs=8k
> -size=5G -numjobs=16 -runtime=60 -group_reporting -name=randrw_16th_8k
> ...
>    read: IOPS=1409, BW=11.0MiB/s (11.5MB/s)(662MiB/60100msec)
>     clat (usec): min=3, max=1488.6k, avg=11313.66, stdev=22312.95
> ...
>   write: IOPS=1418, BW=11.1MiB/s (11.6MB/s)(666MiB/60100msec)
>     clat (usec): min=4, max=7202, avg=19.68, stdev=40.91
> 
> >
> > > My question is, is the purpose of this lock syncing
> > > dio/buffered io?
> >
> > That's one part of it. The other is POSIX atomic write semantics.
> >
> > https://pubs.opengroup.org/onlinepubs/009695399/functions/read.html
> >
> > "I/O is intended to be atomic to ordinary files and pipes and FIFOs.
> > Atomic means that all the bytes from a single operation that started
> > out together end up together, without interleaving from other I/O
> > operations."
> >
> > i.e. that independent read()s should see a write() as a single
> > atomic change. hence if you do a read() concurrently with a write(),
> > the read should either run to completion before the write, or the
> > write run to completion before the read().
> >
> > XFS is the only linux filesystem that provides this behaviour.
> >
> > ext4 and other filesytsems tha thave no buffered read side locking
> > provide serialisation at page level, which means an 8kB read racing
> > with a 8kB write can return 4k from the new write and 4k from the
> > yet-to-be-written part of the file. IOWs, the buffered read gets
> > torn.
> >
> 
> I see... Are you aware of any applications that depend on this POSIX
> atomic write behavior? It would seem very unlikely that such applications
> exist, if only xfs provides this guaranty on Linux...

If we remove the locks that establish the atomic io call behavior, it
seems likely to me that we'll find out which applications actually did
require the behavior and recommended XFS because of its unique
abilities.  Only now they'll be mad.

> IMO, it would be best if applications that desire atomic writes semantics
> would opt for it using a preadv2 flag. Or, for backward compat, we can allow
> applications to opt out of atomic write semantics. [CC fsdevel]
> 
> > > If so, was making this behavior optional via mount option
> > > ever considered for xfs?
> > > Am I the first one who is asking about this specific workload
> > > on xfs (Couldn't found anything on Google), or is this a known
> > > issue/trade off/design choice of xfs?
> >
> > It's an original design feature of XFS. See this 1996 usenix paper
> > on XFS, section 6.2 - Performing File I/O , "Using Multiple
> > Processes":
> >
> > "Currently, when using direct I/O and multiple writers, we
> > place the burden of serializing writes to the same
> > region of the file on the application. This differs from
> > traditional Unix file I/O where file writes are atomic
> > with respect to other file accesses, and it is one of the
> > main reasons why we do not yet support multiple
> > writers using traditional Unix file I/O."
> >
> > i.e. XFS was designed with the intent that buffered writes are
> > atomic w.r.t. to all other file accesses. That's not to say we can't
> > change it, just that it has always been different to what linux
> > native filesystems do. And depending on which set of application
> > developers you talk to, you'll get different answers as to whether
> > they want write()s to be atomic....
> >
> 
> All right. I am reading the above as no prior objection to adding
> an XFS mount option and/or preadv2() flag to opt out of this
> behavior

Reads and writes are not the only thing xfs uses i_rwsem to synchronise.
Reflink remap uses it to make sure everything's flushed to disk and that
page cache contents remain clean while the remap is ongoing.  I'm pretty
sure pnfs uses it for similar reasons when granting and committing write
leases.

> and align with the reckless behavior of the other local
> filesystems on Linux.
> Please correct me if I am wrong and I would like to hear what
> other people thing w.r.t mount option vs. preadv2() flag.
> It could also be an open flag, but I prefer not to go down that road...

I don't like the idea of adding a O_BROKENLOCKINGPONIES flag because it
adds more QA work to support a new (for xfs) violation of the posix spec
we (supposedly) fulfill.

If rw_semaphore favors writes too heavily, why not fix that?

<mutter mutter mutter>

--D

> Thanks,
> Amir.

> randrw_16th_8k: (g=0): rw=randrw, bs=(R) 8192B-8192B, (W) 8192B-8192B, (T) 8192B-8192B, ioengine=psync, iodepth=1
> ...
> fio-3.1
> Starting 16 threads
> 
> randrw_16th_8k: (groupid=0, jobs=16): err= 0: pid=5320: Mon Mar 25 03:21:00 2019
>    read: IOPS=264, BW=2117KiB/s (2168kB/s)(124MiB/60045msec)
>     clat (usec): min=148, max=491768, avg=39432.35, stdev=23039.80
>      lat (usec): min=148, max=491768, avg=39432.76, stdev=23039.81
>     clat percentiles (msec):
>      |  1.00th=[   12],  5.00th=[   18], 10.00th=[   21], 20.00th=[   26],
>      | 30.00th=[   29], 40.00th=[   32], 50.00th=[   35], 60.00th=[   39],
>      | 70.00th=[   43], 80.00th=[   50], 90.00th=[   64], 95.00th=[   80],
>      | 99.00th=[  116], 99.50th=[  133], 99.90th=[  247], 99.95th=[  439],
>      | 99.99th=[  485]
>    bw (  KiB/s): min=   16, max=  272, per=6.27%, avg=132.82, stdev=48.78, samples=1913
>    iops        : min=    2, max=   34, avg=16.60, stdev= 6.10, samples=1913
>   write: IOPS=268, BW=2149KiB/s (2201kB/s)(126MiB/60045msec)
>     clat (usec): min=4, max=477942, avg=20673.33, stdev=26613.06
>      lat (usec): min=4, max=477952, avg=20673.98, stdev=26613.15
>     clat percentiles (usec):
>      |  1.00th=[     7],  5.00th=[     8], 10.00th=[     8], 20.00th=[    12],
>      | 30.00th=[    22], 40.00th=[    31], 50.00th=[ 17957], 60.00th=[ 26346],
>      | 70.00th=[ 31851], 80.00th=[ 38011], 90.00th=[ 50594], 95.00th=[ 65799],
>      | 99.00th=[103285], 99.50th=[115868], 99.90th=[196084], 99.95th=[270533],
>      | 99.99th=[476054]
>    bw (  KiB/s): min=   16, max=  384, per=6.27%, avg=134.82, stdev=66.25, samples=1914
>    iops        : min=    2, max=   48, avg=16.85, stdev= 8.28, samples=1914
>   lat (usec)   : 10=8.31%, 20=6.12%, 50=9.41%, 100=0.68%, 250=0.02%
>   lat (usec)   : 500=0.01%, 750=0.01%
>   lat (msec)   : 2=0.01%, 4=0.07%, 10=0.27%, 20=5.26%, 50=55.06%
>   lat (msec)   : 100=13.19%, 250=1.52%, 500=0.07%
>   cpu          : usr=0.03%, sys=0.25%, ctx=41774, majf=0, minf=0
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued rwt: total=15893,16131,0, short=0,0,0, dropped=0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>    READ: bw=2117KiB/s (2168kB/s), 2117KiB/s-2117KiB/s (2168kB/s-2168kB/s), io=124MiB (130MB), run=60045-60045msec
>   WRITE: bw=2149KiB/s (2201kB/s), 2149KiB/s-2149KiB/s (2201kB/s-2201kB/s), io=126MiB (132MB), run=60045-60045msec
> 
> Disk stats (read/write):
>   sdc: ios=15435/10391, merge=0/1, ticks=122505/4115, in_queue=126193, util=98.26%

> randrw_16th_8k: (g=0): rw=randrw, bs=(R) 8192B-8192B, (W) 8192B-8192B, (T) 8192B-8192B, ioengine=psync, iodepth=1
> ...
> fio-3.1
> Starting 16 threads
> 
> randrw_16th_8k: (groupid=0, jobs=16): err= 0: pid=5294: Mon Mar 25 03:15:49 2019
>    read: IOPS=1409, BW=11.0MiB/s (11.5MB/s)(662MiB/60100msec)
>     clat (usec): min=3, max=1488.6k, avg=11313.66, stdev=22312.95
>      lat (usec): min=3, max=1488.6k, avg=11313.90, stdev=22312.95
>     clat percentiles (usec):
>      |  1.00th=[     5],  5.00th=[     6], 10.00th=[     8], 20.00th=[  3392],
>      | 30.00th=[  5145], 40.00th=[  6718], 50.00th=[  8094], 60.00th=[  9503],
>      | 70.00th=[ 11338], 80.00th=[ 14484], 90.00th=[ 21103], 95.00th=[ 29754],
>      | 99.00th=[ 68682], 99.50th=[109577], 99.90th=[278922], 99.95th=[379585],
>      | 99.99th=[893387]
>    bw (  KiB/s): min=   32, max= 1202, per=6.30%, avg=710.12, stdev=188.47, samples=1909
>    iops        : min=    4, max=  150, avg=88.72, stdev=23.54, samples=1909
>   write: IOPS=1418, BW=11.1MiB/s (11.6MB/s)(666MiB/60100msec)
>     clat (usec): min=4, max=7202, avg=19.68, stdev=40.91
>      lat (usec): min=5, max=7203, avg=20.09, stdev=40.97
>     clat percentiles (usec):
>      |  1.00th=[    7],  5.00th=[   10], 10.00th=[   12], 20.00th=[   12],
>      | 30.00th=[   13], 40.00th=[   15], 50.00th=[   18], 60.00th=[   20],
>      | 70.00th=[   22], 80.00th=[   26], 90.00th=[   32], 95.00th=[   37],
>      | 99.00th=[   56], 99.50th=[   64], 99.90th=[   91], 99.95th=[  117],
>      | 99.99th=[  379]
>    bw (  KiB/s): min=   16, max= 1523, per=6.30%, avg=715.24, stdev=247.64, samples=1908
>    iops        : min=    2, max=  190, avg=89.36, stdev=30.93, samples=1908
>   lat (usec)   : 4=0.02%, 10=8.31%, 20=29.16%, 50=17.64%, 100=0.69%
>   lat (usec)   : 250=0.04%, 500=0.66%, 750=0.08%, 1000=0.02%
>   lat (msec)   : 2=0.55%, 4=4.52%, 10=20.33%, 20=12.50%, 50=4.56%
>   lat (msec)   : 100=0.63%, 250=0.21%, 500=0.05%, 750=0.01%, 1000=0.01%
>   lat (msec)   : 2000=0.01%
>   cpu          : usr=0.09%, sys=0.48%, ctx=75050, majf=0, minf=0
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued rwt: total=84702,85250,0, short=0,0,0, dropped=0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>    READ: bw=11.0MiB/s (11.5MB/s), 11.0MiB/s-11.0MiB/s (11.5MB/s-11.5MB/s), io=662MiB (694MB), run=60100-60100msec
>   WRITE: bw=11.1MiB/s (11.6MB/s), 11.1MiB/s-11.1MiB/s (11.6MB/s-11.6MB/s), io=666MiB (698MB), run=60100-60100msec
> 
> Disk stats (read/write):
>   sdb: ios=74911/60641, merge=0/13, ticks=950347/34711, in_queue=987372, util=100.00%
