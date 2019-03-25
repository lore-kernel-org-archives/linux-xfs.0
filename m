Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:36728 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729849AbfCYHtq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Mar 2019 03:49:46 -0400
MIME-Version: 1.0
References: <CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com>
 <20190325001044.GA23020@dastard>
In-Reply-To: <20190325001044.GA23020@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 25 Mar 2019 09:49:33 +0200
Message-ID: <CAOQ4uxhu=Qtme9RJ7uZXYXt0UE+=xD+OC4gQ9EYkDC1ap8Hizg@mail.gmail.com>
Subject: Re: [QUESTION] Long read latencies on mixed rw buffered IO
Content-Type: multipart/mixed; boundary="000000000000b0184c0584e67258"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

--000000000000b0184c0584e67258
Content-Type: text/plain; charset="UTF-8"

On Mon, Mar 25, 2019 at 2:10 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Sun, Mar 24, 2019 at 08:18:10PM +0200, Amir Goldstein wrote:
> > Hi All,
> >
> > Christoph's re-factoring to xfs_ilock() brought up this question,
> > but AFAICS, current behavior seems to have always been that
> > way for xfs (?).
> >
> > Since commit 6552321831dc ("xfs: remove i_iolock and use
> > i_rwsem in the VFS inode instead"), xfs_file_buffered_aio_read()
> > is the only call sites I know of to call generic_file_read_iter() with
> > i_rwsem read side held.
>
> That did not change the locking behaviour of XFS at all.

I know. Said so above.

>
> > This lock is killing performance of multi-threaded buffered
> > read/write mixed workload on the same file [1].
> > Attached output of bcc tools [2] script xfsdist and ext4dist
> > for latency distribution on the same mixed read/write workload.
>
> In future, can you just paste the text in line, rather than attach
> it as base64 encoded attechments? They are kinda hard to quote.
>
> ext4 read :
>
> ....
>     4 -> 7          : 2610
> ....
>  2048 -> 4095       : 232
>  4096 -> 8191       : 632
>  8192 -> 16383      : 925
> 16384 -> 32767      : 408
> ....
>
> ext4 write:
>
>     4 -> 7          : 16732
>     8 -> 15         : 81712
>    16 -> 31         : 121450
>    32 -> 63         : 29638
>
> So about 4500 read IOPS, of which >50% are cache hits.
> And ~250,000 write iops, all in less than 64 microseconds so
> straight into cache. So we are looking at a ~50:1 write to read
> ratio here.
>
> XFS read:
>
>          0 -> 1          : 8
>          2 -> 3          : 21
>          4 -> 7          : 17
>  ....
>       8192 -> 16383      : 4
>      16384 -> 32767      : 8
>      32768 -> 65535      : 17
>      65536 -> 131071     : 55
>     131072 -> 262143     : 41
>     262144 -> 524287     : 104
>     524288 -> 1048575    : 101
>    1048576 -> 2097151    : 34
>  ....
>
> XFS Write:
>          4 -> 7          : 10087
>          8 -> 15         : 34815
>         16 -> 31         : 32446
>         32 -> 63         : 3888
>         64 -> 127        : 155
>  ....
>         <snip long tail>
>
> Which shows ~400 read ops (almost no cache hits)

It's not because of almost no cache hits.
The pattern is the same as in ext4 test.
It's because most reads are blocked on writes in slow path,
as following sample stack stace from offwaketime bcc tool shows:

Tracing blocked time (us) by user + kernel off-CPU and waker stack...

    waker:           filebench 32155
    entry_SYSCALL_64_after_hwframe
    do_syscall_64
    sys_pwrite64
    vfs_write
    __vfs_write
    new_sync_write
    xfs_file_write_iter
    xfs_file_buffered_aio_write
    xfs_iunlock
    up_write
    call_rwsem_wake
    rwsem_wake
    --               --
    finish_task_switch
    schedule
    rwsem_down_read_failed
    call_rwsem_down_read_failed
    down_read
    xfs_ilock
    xfs_file_buffered_aio_read
    xfs_file_read_iter
    new_sync_read
    __vfs_read
    vfs_read
    sys_pread64
    do_syscall_64
    entry_SYSCALL_64_after_hwframe
    pread
    target:          filebench 32147
        109242

> and ~80,000 write
> ops with a long latency tail. It's a roughly a 200:1 write to read
> ratio.
>
> I'm guessing what we are seeing here is a rwsem starvation problem.
> The only reason a read would get delayed for mor ethan a few hundred
> microseconds is ifthere are a continual stream of write holders
> starving pending reads.
>

Yes. That seems to be the case.

> I don't recall it being this bad historically but rwsems have been
> severely performance optimised for various corner cases over the
> past few years and it is extremely likely that behaviour has
> changed.  Definitely needs looking at, but rwsems are so fragile
> these days (highly dependent on memory ordering that nobody seems to
> be able to get right) and impossible to validate as correct that we
> might just end up having to live with it.
>
> FWIW, What kernel did you test this on?

The results above are from kernel 4.20.7-1.el7.elrepo.x86_64.
Your assumption about change of behavior of rwsem over the
years seems to be correct.
The original report we got from customer was with kernel 4.9.134
In the original report, long latencies were on writes rather than on reads.
The following output of filebench randomrw workload summarizes the results:

rand-write1          1128ops       19ops/s   0.1mb/s    340.3ms/op
[0.03ms - 7933.27ms]
rand-read1           2954684ops    49238ops/s 384.7mb/s      0.2ms/op
[0.02ms - 5873.27ms]
61.026: IO Summary: 2955812 ops 49257.253 ops/s 49238/19 rd/wr
384.8mb/s   0.3ms/op

With more recent kernel (4.20), the latencies have shifted to the read ops:

rand-write1          467706ops     7794ops/s  60.9mb/s    0.733ms/op
[0.004ms - 3899.167ms]
rand-read1           1970ops       33ops/s   0.3mb/s  164.277ms/op
[0.017ms - 3905.929ms]
61.032: IO Summary: 469676 ops 7826.760 ops/s 33/7794 rd/wr  61.1mb/s 1.419ms/op

In a workload of 100% reads or 100% writes, there are no extreme
latencies or neither
old nor new kernel.

>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>

Granted, I wasn't reported a problem is the traditional sense of "what is
the cause?" - that I know. I was asking why this change between xfs
and other fs.
I gathered a lot of traces and analysis from different tools and on
different kernels
during the investigation, so pouring them at all once would have been counter
productive. I'll happily provide any required analysis per demand.

> > Compared to ext4, avg. read latency on RAID of spindles
> > can be two orders of magnitude higher (>100ms).
> > I can provide more performance numbers if needed with fio,
> > but they won't surprise anyone considering the extra lock.
> >
> > This workload simulates a performance issue we are seeing
> > on deployed systems. There are other ways for us to work
> > around the issue, not using xfs on those systems would be
> > one way, but I wanted to figure out the reason for this
> > behavior first.
>
> The workload is 8 threads doing random 8k random reads and
> 8 threads doing random writes to a single 5GB file?

Yes. To a preallocated file.

>
> I'd be interested in seeing if a fio workload using 16 randrw
> threads demonstrate the same latency profile (i.e. threads aren't
> exclusively read- or write- only), or is profile coming about
> specifically because you have dedicated write-only threads that will
> continually bash on the IO locks and hence starve readers?

I guess it depends on the rw mix. With 50% r/w mix run on kernel
4.20.7-1.el7, long latencies are mostly on the write ops.

Gist of fio output inline and full output attached (Sorry, for folks who
don't like scrolling down):

---XFS---
fio -filename=/xfsfolder/largefile1/00000001/00000001 -direct=0
-iodepth 1 -thread -rw=randrw -rwmixread=50 -ioengine=psync -bs=8k
-size=5G -numjobs=16 -runtime=60 -group_reporting -name=randrw_16th_8k
...
   read: IOPS=264, BW=2117KiB/s (2168kB/s)(124MiB/60045msec)
    clat (usec): min=148, max=491768, avg=39432.35, stdev=23039.80
...
  write: IOPS=268, BW=2149KiB/s (2201kB/s)(126MiB/60045msec)
    clat (usec): min=4, max=477942, avg=20673.33, stdev=26613.06

---EXT4---
fio -filename=/ext4folder/largefile1/00000001/00000001 -direct=0
-iodepth 1 -thread -rw=randrw -rwmixread=50 -ioengine=psync -bs=8k
-size=5G -numjobs=16 -runtime=60 -group_reporting -name=randrw_16th_8k
...
   read: IOPS=1409, BW=11.0MiB/s (11.5MB/s)(662MiB/60100msec)
    clat (usec): min=3, max=1488.6k, avg=11313.66, stdev=22312.95
...
  write: IOPS=1418, BW=11.1MiB/s (11.6MB/s)(666MiB/60100msec)
    clat (usec): min=4, max=7202, avg=19.68, stdev=40.91

>
> > My question is, is the purpose of this lock syncing
> > dio/buffered io?
>
> That's one part of it. The other is POSIX atomic write semantics.
>
> https://pubs.opengroup.org/onlinepubs/009695399/functions/read.html
>
> "I/O is intended to be atomic to ordinary files and pipes and FIFOs.
> Atomic means that all the bytes from a single operation that started
> out together end up together, without interleaving from other I/O
> operations."
>
> i.e. that independent read()s should see a write() as a single
> atomic change. hence if you do a read() concurrently with a write(),
> the read should either run to completion before the write, or the
> write run to completion before the read().
>
> XFS is the only linux filesystem that provides this behaviour.
>
> ext4 and other filesytsems tha thave no buffered read side locking
> provide serialisation at page level, which means an 8kB read racing
> with a 8kB write can return 4k from the new write and 4k from the
> yet-to-be-written part of the file. IOWs, the buffered read gets
> torn.
>

I see... Are you aware of any applications that depend on this POSIX
atomic write behavior? It would seem very unlikely that such applications
exist, if only xfs provides this guaranty on Linux...
IMO, it would be best if applications that desire atomic writes semantics
would opt for it using a preadv2 flag. Or, for backward compat, we can allow
applications to opt out of atomic write semantics. [CC fsdevel]

> > If so, was making this behavior optional via mount option
> > ever considered for xfs?
> > Am I the first one who is asking about this specific workload
> > on xfs (Couldn't found anything on Google), or is this a known
> > issue/trade off/design choice of xfs?
>
> It's an original design feature of XFS. See this 1996 usenix paper
> on XFS, section 6.2 - Performing File I/O , "Using Multiple
> Processes":
>
> "Currently, when using direct I/O and multiple writers, we
> place the burden of serializing writes to the same
> region of the file on the application. This differs from
> traditional Unix file I/O where file writes are atomic
> with respect to other file accesses, and it is one of the
> main reasons why we do not yet support multiple
> writers using traditional Unix file I/O."
>
> i.e. XFS was designed with the intent that buffered writes are
> atomic w.r.t. to all other file accesses. That's not to say we can't
> change it, just that it has always been different to what linux
> native filesystems do. And depending on which set of application
> developers you talk to, you'll get different answers as to whether
> they want write()s to be atomic....
>

All right. I am reading the above as no prior objection to adding
an XFS mount option and/or preadv2() flag to opt out of this
behavior and align with the reckless behavior of the other local
filesystems on Linux.
Please correct me if I am wrong and I would like to hear what
other people thing w.r.t mount option vs. preadv2() flag.
It could also be an open flag, but I prefer not to go down that road...

Thanks,
Amir.

--000000000000b0184c0584e67258
Content-Type: text/plain; charset="US-ASCII"; name="fio.xfs.randrw_16th_8k.txt"
Content-Disposition: attachment; filename="fio.xfs.randrw_16th_8k.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_jto14p6y0>
X-Attachment-Id: f_jto14p6y0

cmFuZHJ3XzE2dGhfOGs6IChnPTApOiBydz1yYW5kcncsIGJzPShSKSA4MTkyQi04MTkyQiwgKFcp
IDgxOTJCLTgxOTJCLCAoVCkgODE5MkItODE5MkIsIGlvZW5naW5lPXBzeW5jLCBpb2RlcHRoPTEK
Li4uCmZpby0zLjEKU3RhcnRpbmcgMTYgdGhyZWFkcwoKcmFuZHJ3XzE2dGhfOGs6IChncm91cGlk
PTAsIGpvYnM9MTYpOiBlcnI9IDA6IHBpZD01MzIwOiBNb24gTWFyIDI1IDAzOjIxOjAwIDIwMTkK
ICAgcmVhZDogSU9QUz0yNjQsIEJXPTIxMTdLaUIvcyAoMjE2OGtCL3MpKDEyNE1pQi82MDA0NW1z
ZWMpCiAgICBjbGF0ICh1c2VjKTogbWluPTE0OCwgbWF4PTQ5MTc2OCwgYXZnPTM5NDMyLjM1LCBz
dGRldj0yMzAzOS44MAogICAgIGxhdCAodXNlYyk6IG1pbj0xNDgsIG1heD00OTE3NjgsIGF2Zz0z
OTQzMi43Niwgc3RkZXY9MjMwMzkuODEKICAgIGNsYXQgcGVyY2VudGlsZXMgKG1zZWMpOgogICAg
IHwgIDEuMDB0aD1bICAgMTJdLCAgNS4wMHRoPVsgICAxOF0sIDEwLjAwdGg9WyAgIDIxXSwgMjAu
MDB0aD1bICAgMjZdLAogICAgIHwgMzAuMDB0aD1bICAgMjldLCA0MC4wMHRoPVsgICAzMl0sIDUw
LjAwdGg9WyAgIDM1XSwgNjAuMDB0aD1bICAgMzldLAogICAgIHwgNzAuMDB0aD1bICAgNDNdLCA4
MC4wMHRoPVsgICA1MF0sIDkwLjAwdGg9WyAgIDY0XSwgOTUuMDB0aD1bICAgODBdLAogICAgIHwg
OTkuMDB0aD1bICAxMTZdLCA5OS41MHRoPVsgIDEzM10sIDk5LjkwdGg9WyAgMjQ3XSwgOTkuOTV0
aD1bICA0MzldLAogICAgIHwgOTkuOTl0aD1bICA0ODVdCiAgIGJ3ICggIEtpQi9zKTogbWluPSAg
IDE2LCBtYXg9ICAyNzIsIHBlcj02LjI3JSwgYXZnPTEzMi44Miwgc3RkZXY9NDguNzgsIHNhbXBs
ZXM9MTkxMwogICBpb3BzICAgICAgICA6IG1pbj0gICAgMiwgbWF4PSAgIDM0LCBhdmc9MTYuNjAs
IHN0ZGV2PSA2LjEwLCBzYW1wbGVzPTE5MTMKICB3cml0ZTogSU9QUz0yNjgsIEJXPTIxNDlLaUIv
cyAoMjIwMWtCL3MpKDEyNk1pQi82MDA0NW1zZWMpCiAgICBjbGF0ICh1c2VjKTogbWluPTQsIG1h
eD00Nzc5NDIsIGF2Zz0yMDY3My4zMywgc3RkZXY9MjY2MTMuMDYKICAgICBsYXQgKHVzZWMpOiBt
aW49NCwgbWF4PTQ3Nzk1MiwgYXZnPTIwNjczLjk4LCBzdGRldj0yNjYxMy4xNQogICAgY2xhdCBw
ZXJjZW50aWxlcyAodXNlYyk6CiAgICAgfCAgMS4wMHRoPVsgICAgIDddLCAgNS4wMHRoPVsgICAg
IDhdLCAxMC4wMHRoPVsgICAgIDhdLCAyMC4wMHRoPVsgICAgMTJdLAogICAgIHwgMzAuMDB0aD1b
ICAgIDIyXSwgNDAuMDB0aD1bICAgIDMxXSwgNTAuMDB0aD1bIDE3OTU3XSwgNjAuMDB0aD1bIDI2
MzQ2XSwKICAgICB8IDcwLjAwdGg9WyAzMTg1MV0sIDgwLjAwdGg9WyAzODAxMV0sIDkwLjAwdGg9
WyA1MDU5NF0sIDk1LjAwdGg9WyA2NTc5OV0sCiAgICAgfCA5OS4wMHRoPVsxMDMyODVdLCA5OS41
MHRoPVsxMTU4NjhdLCA5OS45MHRoPVsxOTYwODRdLCA5OS45NXRoPVsyNzA1MzNdLAogICAgIHwg
OTkuOTl0aD1bNDc2MDU0XQogICBidyAoICBLaUIvcyk6IG1pbj0gICAxNiwgbWF4PSAgMzg0LCBw
ZXI9Ni4yNyUsIGF2Zz0xMzQuODIsIHN0ZGV2PTY2LjI1LCBzYW1wbGVzPTE5MTQKICAgaW9wcyAg
ICAgICAgOiBtaW49ICAgIDIsIG1heD0gICA0OCwgYXZnPTE2Ljg1LCBzdGRldj0gOC4yOCwgc2Ft
cGxlcz0xOTE0CiAgbGF0ICh1c2VjKSAgIDogMTA9OC4zMSUsIDIwPTYuMTIlLCA1MD05LjQxJSwg
MTAwPTAuNjglLCAyNTA9MC4wMiUKICBsYXQgKHVzZWMpICAgOiA1MDA9MC4wMSUsIDc1MD0wLjAx
JQogIGxhdCAobXNlYykgICA6IDI9MC4wMSUsIDQ9MC4wNyUsIDEwPTAuMjclLCAyMD01LjI2JSwg
NTA9NTUuMDYlCiAgbGF0IChtc2VjKSAgIDogMTAwPTEzLjE5JSwgMjUwPTEuNTIlLCA1MDA9MC4w
NyUKICBjcHUgICAgICAgICAgOiB1c3I9MC4wMyUsIHN5cz0wLjI1JSwgY3R4PTQxNzc0LCBtYWpm
PTAsIG1pbmY9MAogIElPIGRlcHRocyAgICA6IDE9MTAwLjAlLCAyPTAuMCUsIDQ9MC4wJSwgOD0w
LjAlLCAxNj0wLjAlLCAzMj0wLjAlLCA+PTY0PTAuMCUKICAgICBzdWJtaXQgICAgOiAwPTAuMCUs
IDQ9MTAwLjAlLCA4PTAuMCUsIDE2PTAuMCUsIDMyPTAuMCUsIDY0PTAuMCUsID49NjQ9MC4wJQog
ICAgIGNvbXBsZXRlICA6IDA9MC4wJSwgND0xMDAuMCUsIDg9MC4wJSwgMTY9MC4wJSwgMzI9MC4w
JSwgNjQ9MC4wJSwgPj02ND0wLjAlCiAgICAgaXNzdWVkIHJ3dDogdG90YWw9MTU4OTMsMTYxMzEs
MCwgc2hvcnQ9MCwwLDAsIGRyb3BwZWQ9MCwwLDAKICAgICBsYXRlbmN5ICAgOiB0YXJnZXQ9MCwg
d2luZG93PTAsIHBlcmNlbnRpbGU9MTAwLjAwJSwgZGVwdGg9MQoKUnVuIHN0YXR1cyBncm91cCAw
IChhbGwgam9icyk6CiAgIFJFQUQ6IGJ3PTIxMTdLaUIvcyAoMjE2OGtCL3MpLCAyMTE3S2lCL3Mt
MjExN0tpQi9zICgyMTY4a0Ivcy0yMTY4a0IvcyksIGlvPTEyNE1pQiAoMTMwTUIpLCBydW49NjAw
NDUtNjAwNDVtc2VjCiAgV1JJVEU6IGJ3PTIxNDlLaUIvcyAoMjIwMWtCL3MpLCAyMTQ5S2lCL3Mt
MjE0OUtpQi9zICgyMjAxa0Ivcy0yMjAxa0IvcyksIGlvPTEyNk1pQiAoMTMyTUIpLCBydW49NjAw
NDUtNjAwNDVtc2VjCgpEaXNrIHN0YXRzIChyZWFkL3dyaXRlKToKICBzZGM6IGlvcz0xNTQzNS8x
MDM5MSwgbWVyZ2U9MC8xLCB0aWNrcz0xMjI1MDUvNDExNSwgaW5fcXVldWU9MTI2MTkzLCB1dGls
PTk4LjI2JQo=
--000000000000b0184c0584e67258
Content-Type: text/plain; charset="US-ASCII"; name="fio.ext4.randrw_16th_8k.txt"
Content-Disposition: attachment; filename="fio.ext4.randrw_16th_8k.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_jto14u361>
X-Attachment-Id: f_jto14u361

cmFuZHJ3XzE2dGhfOGs6IChnPTApOiBydz1yYW5kcncsIGJzPShSKSA4MTkyQi04MTkyQiwgKFcp
IDgxOTJCLTgxOTJCLCAoVCkgODE5MkItODE5MkIsIGlvZW5naW5lPXBzeW5jLCBpb2RlcHRoPTEK
Li4uCmZpby0zLjEKU3RhcnRpbmcgMTYgdGhyZWFkcwoKcmFuZHJ3XzE2dGhfOGs6IChncm91cGlk
PTAsIGpvYnM9MTYpOiBlcnI9IDA6IHBpZD01Mjk0OiBNb24gTWFyIDI1IDAzOjE1OjQ5IDIwMTkK
ICAgcmVhZDogSU9QUz0xNDA5LCBCVz0xMS4wTWlCL3MgKDExLjVNQi9zKSg2NjJNaUIvNjAxMDBt
c2VjKQogICAgY2xhdCAodXNlYyk6IG1pbj0zLCBtYXg9MTQ4OC42aywgYXZnPTExMzEzLjY2LCBz
dGRldj0yMjMxMi45NQogICAgIGxhdCAodXNlYyk6IG1pbj0zLCBtYXg9MTQ4OC42aywgYXZnPTEx
MzEzLjkwLCBzdGRldj0yMjMxMi45NQogICAgY2xhdCBwZXJjZW50aWxlcyAodXNlYyk6CiAgICAg
fCAgMS4wMHRoPVsgICAgIDVdLCAgNS4wMHRoPVsgICAgIDZdLCAxMC4wMHRoPVsgICAgIDhdLCAy
MC4wMHRoPVsgIDMzOTJdLAogICAgIHwgMzAuMDB0aD1bICA1MTQ1XSwgNDAuMDB0aD1bICA2NzE4
XSwgNTAuMDB0aD1bICA4MDk0XSwgNjAuMDB0aD1bICA5NTAzXSwKICAgICB8IDcwLjAwdGg9WyAx
MTMzOF0sIDgwLjAwdGg9WyAxNDQ4NF0sIDkwLjAwdGg9WyAyMTEwM10sIDk1LjAwdGg9WyAyOTc1
NF0sCiAgICAgfCA5OS4wMHRoPVsgNjg2ODJdLCA5OS41MHRoPVsxMDk1NzddLCA5OS45MHRoPVsy
Nzg5MjJdLCA5OS45NXRoPVszNzk1ODVdLAogICAgIHwgOTkuOTl0aD1bODkzMzg3XQogICBidyAo
ICBLaUIvcyk6IG1pbj0gICAzMiwgbWF4PSAxMjAyLCBwZXI9Ni4zMCUsIGF2Zz03MTAuMTIsIHN0
ZGV2PTE4OC40Nywgc2FtcGxlcz0xOTA5CiAgIGlvcHMgICAgICAgIDogbWluPSAgICA0LCBtYXg9
ICAxNTAsIGF2Zz04OC43Miwgc3RkZXY9MjMuNTQsIHNhbXBsZXM9MTkwOQogIHdyaXRlOiBJT1BT
PTE0MTgsIEJXPTExLjFNaUIvcyAoMTEuNk1CL3MpKDY2Nk1pQi82MDEwMG1zZWMpCiAgICBjbGF0
ICh1c2VjKTogbWluPTQsIG1heD03MjAyLCBhdmc9MTkuNjgsIHN0ZGV2PTQwLjkxCiAgICAgbGF0
ICh1c2VjKTogbWluPTUsIG1heD03MjAzLCBhdmc9MjAuMDksIHN0ZGV2PTQwLjk3CiAgICBjbGF0
IHBlcmNlbnRpbGVzICh1c2VjKToKICAgICB8ICAxLjAwdGg9WyAgICA3XSwgIDUuMDB0aD1bICAg
MTBdLCAxMC4wMHRoPVsgICAxMl0sIDIwLjAwdGg9WyAgIDEyXSwKICAgICB8IDMwLjAwdGg9WyAg
IDEzXSwgNDAuMDB0aD1bICAgMTVdLCA1MC4wMHRoPVsgICAxOF0sIDYwLjAwdGg9WyAgIDIwXSwK
ICAgICB8IDcwLjAwdGg9WyAgIDIyXSwgODAuMDB0aD1bICAgMjZdLCA5MC4wMHRoPVsgICAzMl0s
IDk1LjAwdGg9WyAgIDM3XSwKICAgICB8IDk5LjAwdGg9WyAgIDU2XSwgOTkuNTB0aD1bICAgNjRd
LCA5OS45MHRoPVsgICA5MV0sIDk5Ljk1dGg9WyAgMTE3XSwKICAgICB8IDk5Ljk5dGg9WyAgMzc5
XQogICBidyAoICBLaUIvcyk6IG1pbj0gICAxNiwgbWF4PSAxNTIzLCBwZXI9Ni4zMCUsIGF2Zz03
MTUuMjQsIHN0ZGV2PTI0Ny42NCwgc2FtcGxlcz0xOTA4CiAgIGlvcHMgICAgICAgIDogbWluPSAg
ICAyLCBtYXg9ICAxOTAsIGF2Zz04OS4zNiwgc3RkZXY9MzAuOTMsIHNhbXBsZXM9MTkwOAogIGxh
dCAodXNlYykgICA6IDQ9MC4wMiUsIDEwPTguMzElLCAyMD0yOS4xNiUsIDUwPTE3LjY0JSwgMTAw
PTAuNjklCiAgbGF0ICh1c2VjKSAgIDogMjUwPTAuMDQlLCA1MDA9MC42NiUsIDc1MD0wLjA4JSwg
MTAwMD0wLjAyJQogIGxhdCAobXNlYykgICA6IDI9MC41NSUsIDQ9NC41MiUsIDEwPTIwLjMzJSwg
MjA9MTIuNTAlLCA1MD00LjU2JQogIGxhdCAobXNlYykgICA6IDEwMD0wLjYzJSwgMjUwPTAuMjEl
LCA1MDA9MC4wNSUsIDc1MD0wLjAxJSwgMTAwMD0wLjAxJQogIGxhdCAobXNlYykgICA6IDIwMDA9
MC4wMSUKICBjcHUgICAgICAgICAgOiB1c3I9MC4wOSUsIHN5cz0wLjQ4JSwgY3R4PTc1MDUwLCBt
YWpmPTAsIG1pbmY9MAogIElPIGRlcHRocyAgICA6IDE9MTAwLjAlLCAyPTAuMCUsIDQ9MC4wJSwg
OD0wLjAlLCAxNj0wLjAlLCAzMj0wLjAlLCA+PTY0PTAuMCUKICAgICBzdWJtaXQgICAgOiAwPTAu
MCUsIDQ9MTAwLjAlLCA4PTAuMCUsIDE2PTAuMCUsIDMyPTAuMCUsIDY0PTAuMCUsID49NjQ9MC4w
JQogICAgIGNvbXBsZXRlICA6IDA9MC4wJSwgND0xMDAuMCUsIDg9MC4wJSwgMTY9MC4wJSwgMzI9
MC4wJSwgNjQ9MC4wJSwgPj02ND0wLjAlCiAgICAgaXNzdWVkIHJ3dDogdG90YWw9ODQ3MDIsODUy
NTAsMCwgc2hvcnQ9MCwwLDAsIGRyb3BwZWQ9MCwwLDAKICAgICBsYXRlbmN5ICAgOiB0YXJnZXQ9
MCwgd2luZG93PTAsIHBlcmNlbnRpbGU9MTAwLjAwJSwgZGVwdGg9MQoKUnVuIHN0YXR1cyBncm91
cCAwIChhbGwgam9icyk6CiAgIFJFQUQ6IGJ3PTExLjBNaUIvcyAoMTEuNU1CL3MpLCAxMS4wTWlC
L3MtMTEuME1pQi9zICgxMS41TUIvcy0xMS41TUIvcyksIGlvPTY2Mk1pQiAoNjk0TUIpLCBydW49
NjAxMDAtNjAxMDBtc2VjCiAgV1JJVEU6IGJ3PTExLjFNaUIvcyAoMTEuNk1CL3MpLCAxMS4xTWlC
L3MtMTEuMU1pQi9zICgxMS42TUIvcy0xMS42TUIvcyksIGlvPTY2Nk1pQiAoNjk4TUIpLCBydW49
NjAxMDAtNjAxMDBtc2VjCgpEaXNrIHN0YXRzIChyZWFkL3dyaXRlKToKICBzZGI6IGlvcz03NDkx
MS82MDY0MSwgbWVyZ2U9MC8xMywgdGlja3M9OTUwMzQ3LzM0NzExLCBpbl9xdWV1ZT05ODczNzIs
IHV0aWw9MTAwLjAwJQo=
--000000000000b0184c0584e67258--
