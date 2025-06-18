Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CC52E719D;
	Wed, 18 Jun 2025 13:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750251713; cv=none; b=UMQDwoJRFniWXdI21diEoU1BQGzm+UpkKMfJLbKpkdJAlx3Yr8GP2yqepIbWK9uD1cmgHAjE7LRtJUIiVLtfkFkOVuIdrEGuH0BrY4omQvw7yyk0O1pc+2vu8dfaA66PAc3C5vTLsvSOF8bV2s6Nt51eMrO1f2FBAgrQ9/jwDps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750251713; c=relaxed/simple;
	bh=7nzcdwTShcjaBqzYi1BqdbpDvuPoNl7aHDmFxqixCSw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=gcncszy40vMCx5Mgx1YzYXBORutUlSW57pkJFyxqcuwhAh6Q/ky2CEMRpsc0QFOXGKvp8PafXESyhj5VKjniWSo/zT5TQE/t0+lUUxj1XP3IYHw0jNHgE0bNuiJEsSIQ8HwhxAy8VJAJ1TTb9W+fz8Gf1Yjfrb8Xt4cWcz1cI/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=B84o6AkA; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="B84o6AkA"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1750251691;
	bh=wk2aAWgreJVBMMw2qig0RsGdOKufxyrDOjIm9IeUi1U=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=B84o6AkAjTsWOo/bmJ1UQKoPiTOauaqWnhr9K0E3k06Dk8GWOHx9JF8cmDLY9Z89C
	 uxrkY35X/kKK1pgRfxNJgKeK3wU14PLdYAROlf49AGupK6vmyWoLllPFbc/p8o0S/c
	 IkDVGqsom4g1mk2VGHFOKt9mHdQwRifoy0SDEoL8=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: temporary hung tasks on XFS since updating to 6.6.92
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <aFHsJmPhK6hBfEPC@dread.disaster.area>
Date: Wed, 18 Jun 2025 15:01:26 +0200
Cc: Carlos Maiolino <cem@kernel.org>,
 stable@vger.kernel.org,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 regressions@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <E4F29FAF-D17F-48BC-9F13-05F04C0C2AF5@flyingcircus.io>
References: <M1JxD6k5Sdxnq-pztTdv_FZwURA8AaT9qWNFUYGCmhiTRQFESfH7xqdOqQjz-oKQiin8pQckoNhfNyCHu-cxEQ==@protonmail.internalid>
 <14E1A49D-23BF-4929-A679-E6D5C8977D40@flyingcircus.io>
 <umhydsim2pkxhtux5hizyahwd6hy36yct5znt6u6ewo4fojvgy@zn4gkroozwes>
 <Z9Ih4yZoepxhmmH5Jrd1bCz35l6iPh5g2J61q2NR7loEdQb_aRquKdD1xLaE_5SPMlkBM8zLdVfdPvvKuNBrGQ==@protonmail.internalid>
 <3E218629-EA2C-4FD1-B2DB-AA6E40D422EE@flyingcircus.io>
 <g7wcgkxdlbshztwihayxma7xkxe23nic7zcreb3eyg3yeld5cu@yk7l2e4ibajk>
 <01751810-C689-4270-8797-FC0D632B6AB6@flyingcircus.io>
 <aFHsJmPhK6hBfEPC@dread.disaster.area>
To: Dave Chinner <david@fromorbit.com>



> On 18. Jun 2025, at 00:28, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Mon, Jun 16, 2025 at 12:09:21PM +0200, Christian Theune wrote:
>>> Can you share the xfs_info of one of these filesystems? I'm curious =
about the FS
>>> geometry.
>>=20
>> Sure:
>>=20
>> # xfs_info /
>> meta-data=3D/dev/disk/by-label/root isize=3D512    agcount=3D21, =
agsize=3D655040 blks
>>         =3D                       sectsz=3D512   attr=3D2, =
projid32bit=3D1
>>         =3D                       crc=3D1        finobt=3D1, =
sparse=3D1, rmapbt=3D0
>>         =3D                       reflink=3D1    bigtime=3D1 =
inobtcount=3D1 nrext64=3D0
>>         =3D                       exchange=3D0
>> data     =3D                       bsize=3D4096   blocks=3D13106171, =
imaxpct=3D25
>>         =3D                       sunit=3D0      swidth=3D0 blks
>> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, =
ftype=3D1, parent=3D0
>> log      =3Dinternal log           bsize=3D4096   blocks=3D16384, =
version=3D2
>>         =3D                       sectsz=3D512   sunit=3D0 blks, =
lazy-count=3D1
>> realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0
>=20
> =46rom the logs, it was /dev/vda1 that was getting hung up, so I'm
> going to assume the workload is hitting the root partition, not:
>=20
>> # xfs_info /tmp/
>> meta-data=3D/dev/vdb1              isize=3D512    agcount=3D8, =
agsize=3D229376 blks
>=20
> ... this one that has a small log.
>=20
> IOWs, I don't think the log size is a contributing factor here.
>=20
> The indication from the logs is that the system is hung up waiting
> on slow journal writes. e.g. there are processes hung waiting for
> transaction reservations (i.e. no journal space available). Journal
> space is backed up on metadata writeback trying to force the journal
> to stable storage (which is blocked waiting for journal IO
> completion so it can issue more journal IO) and getting blocked so
> it can't make progress, either.
>=20
> I think part of the issue is that journal writes issue device cache
> flushes and FUA writes, both of which require written data to be
> on stable storage before returning.
>=20
> All this points to whatever storage is backing these VMs is
> extremely slow at guaranteeing persistence of data and eventually it
> can't keep up with the application making changes to the filesystem.
> When the journal IO latency gets high enough you start to see things
> backing up and stall warnings appearing.
>=20
> IOWs, this does not look like a filesystem issue from the
> information presented, just storage that can't keep up with the rate
> at which the filesystem can make modifications in memory. When the
> fs finally starts to throttle on the slow storage, that's when you
> notice just how slow the storage actually is...
>=20
> [ Historical note: this is exactly the sort of thing we have seen
> for years with hardware RAID5/6 adapters with large amounts of NVRAM
> and random write workloads. They run as fast as NVRAM can sink the
> 4kB random writes, then when the NVRAM fills, they have to wait for
> hundreds of MB of cached 4kB random writes to be written to the
> RAID5/6 luns at 50-100 IOPS. This causes the exact same "filesystem
> is hung" symptoms as you are describing in this thread. ]

Yeah, I=E2=80=99m very wary of reporting these tracebacks as potential =
bugs because of them easily being just a hint on slow storage. My =
problem here is that I can=E2=80=99t point to anything that says the =
storage would have been slow.

I=E2=80=99ve gone through all metrics and logs on the KVM servers as =
well as the Ceph servers and they=E2=80=99ve been performing completely =
at baseline level regarding errors, queues, iops, latency.

I=E2=80=99ve done a measurement to try to emulate those accesses by =
running

$ fio --rw=3Drandrw --name=3Dsynctest --bs=3D4k --direct=3D1 --numjobs=3D1=
 --ioengine=3Dlibaio --iodepth=3D1 --runtime=3D600 --write_barrier=3D1 =
--size=3D60m

I hope this is sufficiently comparable behaviour (maybe with a different =
read/write ratio instead of 0.5?) to what XFS log flushing does. This =
resulted in [1].=20

My interpretation of this measurement (and the VM showed no illnes while =
this was running over 10 minutes): the VM is throttled at 250 IOPs and =
is reporting back after 10 minutes of 4k random writes with average IOPS =
of exactly 250. The latencies are a bit varied, this could be due to =
Qemu throttling. The max latency was 133ms, the average 2ms. This is on =
a 10g storage network with Ceph that requires another network roundtrip =
for replication before ACKing a write.

There is one more (somewhat far fetched thing) I could pull in here: out =
of 11 VMs that have seen that are exhibiting those symptoms I have seen =
two (including one already running on 6.12 at that time) that did log a =
stacktrace[2] that reminded me of the memory/folio issue we debugged =
late last year / earlier this year =
(https://lkml.org/lkml/2024/9/12/1472)) =E2=80=A6 maybe it=E2=80=99s =
worthwhile to consider whether this might be related. The outside =
symptoms are similar: it recovers on its own at some point and I can=E2=80=
=99t show any issue with the underlying storage at all.

I=E2=80=99m out of ideas for now, I=E2=80=99ll keep thinking about this. =
If anyone has any pointer for further tests in any direction, I=E2=80=99m =
open to anything. ;)

Thanks for all the help so far,
Christian

[1] The test results:

synctest: (g=3D0): rw=3Drandrw, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, =
(T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D1
fio-3.38
Starting 1 process
Jobs: 1 (f=3D1): [m(1)][100.0%][r=3D484KiB/s,w=3D517KiB/s][r=3D121,w=3D129=
 IOPS][eta 00m:00s]
synctest: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D655973: Wed Jun 18 =
09:28:31 2025
  read: IOPS=3D122, BW=3D489KiB/s (501kB/s)(29.9MiB/62557msec)
    slat (usec): min=3D8, max=3D1096, avg=3D22.94, stdev=3D24.68
    clat (usec): min=3D285, max=3D133773, avg=3D2745.14, stdev=3D2723.35
     lat (usec): min=3D296, max=3D133812, avg=3D2768.08, stdev=3D2723.35
    clat percentiles (usec):
     |  1.00th=3D[   416],  5.00th=3D[   506], 10.00th=3D[   611], =
20.00th=3D[   832],
     | 30.00th=3D[  1713], 40.00th=3D[  2540], 50.00th=3D[  2737], =
60.00th=3D[  3458],
     | 70.00th=3D[  3621], 80.00th=3D[  3785], 90.00th=3D[  4555], =
95.00th=3D[  4817],
     | 99.00th=3D[  6063], 99.50th=3D[  7898], 99.90th=3D[ 22676], =
99.95th=3D[ 78119],
     | 99.99th=3D[133694]
   bw (  KiB/s): min=3D  304, max=3D  608, per=3D99.90%, avg=3D489.79, =
stdev=3D59.34, samples=3D125
   iops        : min=3D   76, max=3D  152, avg=3D122.45, stdev=3D14.83, =
samples=3D125
  write: IOPS=3D123, BW=3D493KiB/s (504kB/s)(30.1MiB/62557msec); 0 zone =
resets
    slat (usec): min=3D11, max=3D1102, avg=3D25.54, stdev=3D23.33
    clat (usec): min=3D1434, max=3D140566, avg=3D5337.34, stdev=3D7163.78
     lat (usec): min=3D1453, max=3D140651, avg=3D5362.88, stdev=3D7164.02
    clat percentiles (usec):
     |  1.00th=3D[  1713],  5.00th=3D[  1926], 10.00th=3D[  2114], =
20.00th=3D[  2868],
     | 30.00th=3D[  3720], 40.00th=3D[  4080], 50.00th=3D[  4490], =
60.00th=3D[  5014],
     | 70.00th=3D[  5276], 80.00th=3D[  5866], 90.00th=3D[  6652], =
95.00th=3D[  8979],
     | 99.00th=3D[ 33162], 99.50th=3D[ 64750], 99.90th=3D[ 99091], =
99.95th=3D[111674],
     | 99.99th=3D[141558]
   bw (  KiB/s): min=3D  336, max=3D  672, per=3D99.86%, avg=3D492.93, =
stdev=3D60.30, samples=3D125
   iops        : min=3D   84, max=3D  168, avg=3D123.23, stdev=3D15.08, =
samples=3D125
  lat (usec)   : 500=3D2.28%, 750=3D6.19%, 1000=3D2.66%
  lat (msec)   : 2=3D9.39%, 4=3D40.59%, 10=3D36.82%, 20=3D1.26%, =
50=3D0.41%
  lat (msec)   : 100=3D0.34%, 250=3D0.05%
  cpu          : usr=3D0.17%, sys=3D0.73%, ctx=3D15398, majf=3D0, =
minf=3D11
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, =
32=3D0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D7655,7705,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
   READ: bw=3D489KiB/s (501kB/s), 489KiB/s-489KiB/s (501kB/s-501kB/s), =
io=3D29.9MiB (31.4MB), run=3D62557-62557msec
  WRITE: bw=3D493KiB/s (504kB/s), 493KiB/s-493KiB/s (504kB/s-504kB/s), =
io=3D30.1MiB (31.6MB), run=3D62557-62557msec

Disk stats (read/write):
  vda: ios=3D7662/7865, sectors=3D61856/71089, merge=3D0/5, =
ticks=3D21263/105909, in_queue=3D127177, util=3D98.62%
ctheune@hannover96stag00:~/ > fio --rw=3Drandrw --name=3Dsynctest =
--bs=3D4k --direct=3D1 --numjobs=3D1 --ioengine=3Dlibaio --iodepth=3D1 =
--runtime=3D600 --write_barrier=3D1 --size=3D60m --time_based
synctest: (g=3D0): rw=3Drandrw, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, =
(T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D1
fio-3.38
Starting 1 process
Jobs: 1 (f=3D1): [m(1)][100.0%][r=3D408KiB/s,w=3D344KiB/s][r=3D102,w=3D86 =
IOPS][eta 00m:00s]
synctest: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D656097: Wed Jun 18 =
09:38:54 2025
  read: IOPS=3D121, BW=3D485KiB/s (496kB/s)(284MiB/600006msec)
    slat (usec): min=3D7, max=3D1126, avg=3D23.70, stdev=3D22.33
    clat (usec): min=3D99, max=3D128424, avg=3D2834.26, stdev=3D1977.13
     lat (usec): min=3D299, max=3D128439, avg=3D2857.97, stdev=3D1975.91
    clat percentiles (usec):
     |  1.00th=3D[  416],  5.00th=3D[  519], 10.00th=3D[  660], =
20.00th=3D[ 1516],
     | 30.00th=3D[ 2442], 40.00th=3D[ 2638], 50.00th=3D[ 2802], =
60.00th=3D[ 3523],
     | 70.00th=3D[ 3654], 80.00th=3D[ 3818], 90.00th=3D[ 4555], =
95.00th=3D[ 4752],
     | 99.00th=3D[ 5211], 99.50th=3D[ 7308], 99.90th=3D[12125], =
99.95th=3D[23725],
     | 99.99th=3D[71828]
   bw (  KiB/s): min=3D   64, max=3D  672, per=3D100.00%, avg=3D485.12, =
stdev=3D75.21, samples=3D1199
   iops        : min=3D   16, max=3D  168, avg=3D121.27, stdev=3D18.80, =
samples=3D1199
  write: IOPS=3D120, BW=3D481KiB/s (493kB/s)(282MiB/600006msec); 0 zone =
resets
    slat (usec): min=3D10, max=3D1168, avg=3D26.84, stdev=3D22.15
    clat (usec): min=3D1193, max=3D307265, avg=3D5397.02, stdev=3D8361.82
     lat (usec): min=3D1343, max=3D307308, avg=3D5423.86, stdev=3D8362.12
    clat percentiles (usec):
     |  1.00th=3D[  1729],  5.00th=3D[  1975], 10.00th=3D[  2245], =
20.00th=3D[  3097],
     | 30.00th=3D[  3884], 40.00th=3D[  4178], 50.00th=3D[  4621], =
60.00th=3D[  5014],
     | 70.00th=3D[  5276], 80.00th=3D[  5800], 90.00th=3D[  6456], =
95.00th=3D[  7898],
     | 99.00th=3D[ 32900], 99.50th=3D[ 66847], 99.90th=3D[132645], =
99.95th=3D[154141],
     | 99.99th=3D[170918]
   bw (  KiB/s): min=3D   56, max=3D  672, per=3D99.91%, avg=3D481.74, =
stdev=3D74.40, samples=3D1199
   iops        : min=3D   14, max=3D  168, avg=3D120.43, stdev=3D18.60, =
samples=3D1199
  lat (usec)   : 100=3D0.01%, 250=3D0.01%, 500=3D2.08%, 750=3D4.49%, =
1000=3D2.13%
  lat (msec)   : 2=3D8.44%, 4=3D42.49%, 10=3D38.81%, 20=3D0.89%, =
50=3D0.31%
  lat (msec)   : 100=3D0.24%, 250=3D0.11%, 500=3D0.01%
  cpu          : usr=3D0.20%, sys=3D0.75%, ctx=3D145300, majf=3D0, =
minf=3D12
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, =
32=3D0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D72728,72217,0,0 short=3D0,0,0,0 =
dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
   READ: bw=3D485KiB/s (496kB/s), 485KiB/s-485KiB/s (496kB/s-496kB/s), =
io=3D284MiB (298MB), run=3D600006-600006msec
  WRITE: bw=3D481KiB/s (493kB/s), 481KiB/s-481KiB/s (493kB/s-493kB/s), =
io=3D282MiB (296MB), run=3D600006-600006msec

Disk stats (read/write):
  vda: ios=3D72722/74795, sectors=3D582248/768053, merge=3D0/67, =
ticks=3D206476/860665, in_queue=3D1067364, util=3D98.78%


[2] second type of hung tasks that I considered unrelated so far

May 17 03:30:23  kernel: INFO: task kworker/u18:2:19320 blocked for more =
than 122 seconds.
May 17 03:30:23  kernel:       Not tainted 6.12.28 #1-NixOS
May 17 03:30:23  kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 17 03:30:23  kernel: task:kworker/u18:2   state:D stack:0     =
pid:19320 tgid:19320 ppid:2      flags:0x00004000
May 17 03:30:23  kernel: Workqueue: writeback wb_workfn (flush-253:0)
May 17 03:30:23  kernel: Call Trace:
May 17 03:30:23  kernel:  <TASK>
May 17 03:30:23  kernel:  __schedule+0x442/0x12d0
May 17 03:30:23  kernel:  schedule+0x27/0xf0
May 17 03:30:23  kernel:  io_schedule+0x46/0x70
May 17 03:30:23  kernel:  folio_wait_bit_common+0x13f/0x340
May 17 03:30:23  kernel:  ? __pfx_wake_page_function+0x10/0x10
May 17 03:30:23  kernel:  writeback_iter+0x1ec/0x2d0
May 17 03:30:23  kernel:  iomap_writepages+0x74/0x9e0
May 17 03:30:23  kernel:  ? virtqueue_add_split+0xb1/0x7a0 [virtio_ring]
May 17 03:30:23  kernel:  ? virtqueue_add_split+0x2af/0x7a0 =
[virtio_ring]
May 17 03:30:23  kernel:  xfs_vm_writepages+0x67/0xa0 [xfs]
May 17 03:30:23  kernel:  do_writepages+0x8a/0x290
May 17 03:30:23  kernel:  ? enqueue_hrtimer+0x35/0x90
May 17 03:30:23  kernel:  ? hrtimer_start_range_ns+0x2b7/0x450
May 17 03:30:23  kernel:  __writeback_single_inode+0x3d/0x350
May 17 03:30:23  kernel:  ? wbc_detach_inode+0x116/0x250
May 17 03:30:23  kernel:  writeback_sb_inodes+0x228/0x4e0
May 17 03:30:23  kernel:  __writeback_inodes_wb+0x4c/0xf0
May 17 03:30:23  kernel:  wb_writeback+0x1ac/0x330
May 17 03:30:23  kernel:  ? get_nr_inodes+0x3b/0x60
May 17 03:30:23  kernel:  wb_workfn+0x357/0x460
May 17 03:30:23  kernel:  process_one_work+0x192/0x3b0
May 17 03:30:23  kernel:  worker_thread+0x230/0x340
May 17 03:30:23  kernel:  ? __pfx_worker_thread+0x10/0x10
May 17 03:30:23  kernel:  kthread+0xd0/0x100
May 17 03:30:23  kernel:  ? __pfx_kthread+0x10/0x10
May 17 03:30:23  kernel:  ret_from_fork+0x34/0x50
May 17 03:30:23  kernel:  ? __pfx_kthread+0x10/0x10
May 17 03:30:23  kernel:  ret_from_fork_asm+0x1a/0x30
May 17 03:30:23  kernel:  </TASK>
May 17 03:30:23  kernel: INFO: task nix:21146 blocked for more than 122 =
seconds.
May 17 03:30:23  kernel:       Not tainted 6.12.28 #1-NixOS
May 17 03:30:23  kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 17 03:30:23  kernel: task:nix             state:D stack:0     =
pid:21146 tgid:21146 ppid:21145  flags:0x00000002
May 17 03:30:23  kernel: Call Trace:
May 17 03:30:23  kernel:  <TASK>
May 17 03:30:23  kernel:  __schedule+0x442/0x12d0
May 17 03:30:23  kernel:  ? xas_load+0xd/0xe0
May 17 03:30:23  kernel:  ? xa_load+0x77/0xb0
May 17 03:30:23  kernel:  schedule+0x27/0xf0
May 17 03:30:23  kernel:  io_schedule+0x46/0x70
May 17 03:30:23  kernel:  folio_wait_bit_common+0x13f/0x340
May 17 03:30:23  kernel:  ? __pfx_wake_page_function+0x10/0x10
May 17 03:30:23  kernel:  folio_wait_writeback+0x2b/0x90
May 17 03:30:23  kernel:  truncate_inode_partial_folio+0x5e/0x1c0
May 17 03:30:23  kernel:  truncate_inode_pages_range+0x1de/0x410
May 17 03:30:23  kernel:  truncate_pagecache+0x47/0x60
May 17 03:30:23  kernel:  xfs_setattr_size+0xf6/0x3c0 [xfs]
May 17 03:30:23  kernel:  xfs_vn_setattr+0x85/0x150 [xfs]
May 17 03:30:23  kernel:  notify_change+0x301/0x500
May 17 03:30:23  kernel:  ? do_truncate+0x98/0xf0
May 17 03:30:23  kernel:  do_truncate+0x98/0xf0
May 17 03:30:23  kernel:  do_ftruncate+0x104/0x170
May 17 03:30:23  kernel:  do_sys_ftruncate+0x3d/0x80
May 17 03:30:23  kernel:  do_syscall_64+0xb7/0x210
May 17 03:30:23  kernel:  entry_SYSCALL_64_after_hwframe+0x77/0x7f
May 17 03:30:23  kernel: RIP: 0033:0x7f87aeb0d75b
May 17 03:30:23  kernel: RSP: 002b:00007ffddbfc04b8 EFLAGS: 00000213 =
ORIG_RAX: 000000000000004d
May 17 03:30:23  kernel: RAX: ffffffffffffffda RBX: 0000000000000000 =
RCX: 00007f87aeb0d75b
May 17 03:30:23  kernel: RDX: 0000000000000000 RSI: 0000000000000003 =
RDI: 0000000000000008
May 17 03:30:23  kernel: RBP: 0000557d5dd46498 R08: 0000000000000000 =
R09: 0000000000000000
May 17 03:30:23  kernel: R10: 0000000000000000 R11: 0000000000000213 =
R12: 0000000000000008
May 17 03:30:23  kernel: R13: 0000557d5dcd2aa0 R14: 0000557d5dd46468 =
R15: 0000000000000008
May 17 03:30:23  kernel:  </TASK>




May 17 03:32:26  kernel: INFO: task kworker/u18:2:19320 blocked for more =
than 245 seconds.
May 17 03:32:26  kernel:       Not tainted 6.12.28 #1-NixOS
May 17 03:32:26  kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 17 03:32:26  kernel: task:kworker/u18:2   state:D stack:0     =
pid:19320 tgid:19320 ppid:2      flags:0x00004000
May 17 03:32:26  kernel: Workqueue: writeback wb_workfn (flush-253:0)
May 17 03:32:26  kernel: Call Trace:
May 17 03:32:26  kernel:  <TASK>
May 17 03:32:26  kernel:  __schedule+0x442/0x12d0
May 17 03:32:26  kernel:  schedule+0x27/0xf0
May 17 03:32:26  kernel:  io_schedule+0x46/0x70
May 17 03:32:26  kernel:  folio_wait_bit_common+0x13f/0x340
May 17 03:32:26  kernel:  ? __pfx_wake_page_function+0x10/0x10
May 17 03:32:26  kernel:  writeback_iter+0x1ec/0x2d0
May 17 03:32:26  kernel:  iomap_writepages+0x74/0x9e0
May 17 03:32:26  kernel:  ? virtqueue_add_split+0xb1/0x7a0 [virtio_ring]
May 17 03:32:26  kernel:  ? virtqueue_add_split+0x2af/0x7a0 =
[virtio_ring]
May 17 03:32:26  kernel:  xfs_vm_writepages+0x67/0xa0 [xfs]
May 17 03:32:26  kernel:  do_writepages+0x8a/0x290
May 17 03:32:26  kernel:  ? enqueue_hrtimer+0x35/0x90
May 17 03:32:26  kernel:  ? hrtimer_start_range_ns+0x2b7/0x450
May 17 03:32:26  kernel:  __writeback_single_inode+0x3d/0x350
May 17 03:32:26  kernel:  ? wbc_detach_inode+0x116/0x250
May 17 03:32:26  kernel:  writeback_sb_inodes+0x228/0x4e0
May 17 03:32:26  kernel:  __writeback_inodes_wb+0x4c/0xf0
May 17 03:32:26  kernel:  wb_writeback+0x1ac/0x330
May 17 03:32:26  kernel:  ? get_nr_inodes+0x3b/0x60
May 17 03:32:26  kernel:  wb_workfn+0x357/0x460
May 17 03:32:26  kernel:  process_one_work+0x192/0x3b0
May 17 03:32:26  kernel:  worker_thread+0x230/0x340
May 17 03:32:26  kernel:  ? __pfx_worker_thread+0x10/0x10
May 17 03:32:26  kernel:  kthread+0xd0/0x100
May 17 03:32:26  kernel:  ? __pfx_kthread+0x10/0x10
May 17 03:32:26  kernel:  ret_from_fork+0x34/0x50
May 17 03:32:26  kernel:  ? __pfx_kthread+0x10/0x10
May 17 03:32:26  kernel:  ret_from_fork_asm+0x1a/0x30
May 17 03:32:26  kernel:  </TASK>
May 17 03:32:26  kernel: INFO: task nix:21146 blocked for more than 245 =
seconds.
May 17 03:32:26  kernel:       Not tainted 6.12.28 #1-NixOS
May 17 03:32:26  kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 17 03:32:26  kernel: task:nix             state:D stack:0     =
pid:21146 tgid:21146 ppid:21145  flags:0x00000002
May 17 03:32:26  kernel: Call Trace:
May 17 03:32:26  kernel:  <TASK>
May 17 03:32:26  kernel:  __schedule+0x442/0x12d0
May 17 03:32:26  kernel:  ? xas_load+0xd/0xe0
May 17 03:32:26  kernel:  ? xa_load+0x77/0xb0
May 17 03:32:26  kernel:  schedule+0x27/0xf0
May 17 03:32:26  kernel:  io_schedule+0x46/0x70
May 17 03:32:26  kernel:  folio_wait_bit_common+0x13f/0x340
May 17 03:32:26  kernel:  ? __pfx_wake_page_function+0x10/0x10
May 17 03:32:26  kernel:  folio_wait_writeback+0x2b/0x90
May 17 03:32:26  kernel:  truncate_inode_partial_folio+0x5e/0x1c0
May 17 03:32:26  kernel:  truncate_inode_pages_range+0x1de/0x410
May 17 03:32:26  kernel:  truncate_pagecache+0x47/0x60
May 17 03:32:26  kernel:  xfs_setattr_size+0xf6/0x3c0 [xfs]
May 17 03:32:26  kernel:  xfs_vn_setattr+0x85/0x150 [xfs]
May 17 03:32:26  kernel:  notify_change+0x301/0x500
May 17 03:32:26  kernel:  ? do_truncate+0x98/0xf0
May 17 03:32:26  kernel:  do_truncate+0x98/0xf0
May 17 03:32:26  kernel:  do_ftruncate+0x104/0x170
May 17 03:32:26  kernel:  do_sys_ftruncate+0x3d/0x80
May 17 03:32:26  kernel:  do_syscall_64+0xb7/0x210
May 17 03:32:26  kernel:  entry_SYSCALL_64_after_hwframe+0x77/0x7f
May 17 03:32:26  kernel: RIP: 0033:0x7f87aeb0d75b
May 17 03:32:26  kernel: RSP: 002b:00007ffddbfc04b8 EFLAGS: 00000213 =
ORIG_RAX: 000000000000004d
May 17 03:32:26  kernel: RAX: ffffffffffffffda RBX: 0000000000000000 =
RCX: 00007f87aeb0d75b
May 17 03:32:26  kernel: RDX: 0000000000000000 RSI: 0000000000000003 =
RDI: 0000000000000008
May 17 03:32:26  kernel: RBP: 0000557d5dd46498 R08: 0000000000000000 =
R09: 0000000000000000
May 17 03:32:26  kernel: R10: 0000000000000000 R11: 0000000000000213 =
R12: 0000000000000008
May 17 03:32:26  kernel: R13: 0000557d5dcd2aa0 R14: 0000557d5dd46468 =
R15: 0000000000000008
May 17 03:32:26  kernel:  </TASK>

May 17 03:34:29  kernel: INFO: task kworker/u18:2:19320 blocked for more =
than 368 seconds.
May 17 03:34:29  kernel:       Not tainted 6.12.28 #1-NixOS
May 17 03:34:29  kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 17 03:34:29  kernel: task:kworker/u18:2   state:D stack:0     =
pid:19320 tgid:19320 ppid:2      flags:0x00004000
May 17 03:34:29  kernel: Workqueue: writeback wb_workfn (flush-253:0)
May 17 03:34:29  kernel: Call Trace:
May 17 03:34:29  kernel:  <TASK>
May 17 03:34:29  kernel:  __schedule+0x442/0x12d0
May 17 03:34:29  kernel:  schedule+0x27/0xf0
May 17 03:34:29  kernel:  io_schedule+0x46/0x70
May 17 03:34:29  kernel:  folio_wait_bit_common+0x13f/0x340
May 17 03:34:29  kernel:  ? __pfx_wake_page_function+0x10/0x10
May 17 03:34:29  kernel:  writeback_iter+0x1ec/0x2d0
May 17 03:34:29  kernel:  iomap_writepages+0x74/0x9e0
May 17 03:34:29  kernel:  ? virtqueue_add_split+0xb1/0x7a0 [virtio_ring]
May 17 03:34:29  kernel:  ? virtqueue_add_split+0x2af/0x7a0 =
[virtio_ring]
May 17 03:34:29  kernel:  xfs_vm_writepages+0x67/0xa0 [xfs]
May 17 03:34:29  kernel:  do_writepages+0x8a/0x290
May 17 03:34:29  kernel:  ? enqueue_hrtimer+0x35/0x90
May 17 03:34:29  kernel:  ? hrtimer_start_range_ns+0x2b7/0x450
May 17 03:34:29  kernel:  __writeback_single_inode+0x3d/0x350
May 17 03:34:29  kernel:  ? wbc_detach_inode+0x116/0x250
May 17 03:34:29  kernel:  writeback_sb_inodes+0x228/0x4e0
May 17 03:34:29  kernel:  __writeback_inodes_wb+0x4c/0xf0
May 17 03:34:29  kernel:  wb_writeback+0x1ac/0x330
May 17 03:34:29  kernel:  ? get_nr_inodes+0x3b/0x60
May 17 03:34:29  kernel:  wb_workfn+0x357/0x460
May 17 03:34:29  kernel:  process_one_work+0x192/0x3b0
May 17 03:34:29  kernel:  worker_thread+0x230/0x340
May 17 03:34:29  kernel:  ? __pfx_worker_thread+0x10/0x10
May 17 03:34:29  kernel:  kthread+0xd0/0x100
May 17 03:34:29  kernel:  ? __pfx_kthread+0x10/0x10
May 17 03:34:29  kernel:  ret_from_fork+0x34/0x50
May 17 03:34:29  kernel:  ? __pfx_kthread+0x10/0x10
May 17 03:34:29  kernel:  ret_from_fork_asm+0x1a/0x30
May 17 03:34:29  kernel:  </TASK>
May 17 03:34:29  kernel: INFO: task nix:21146 blocked for more than 368 =
seconds.
May 17 03:34:29  kernel:       Not tainted 6.12.28 #1-NixOS
May 17 03:34:29  kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 17 03:34:29  kernel: task:nix             state:D stack:0     =
pid:21146 tgid:21146 ppid:21145  flags:0x00000002
May 17 03:34:29  kernel: Call Trace:
May 17 03:34:29  kernel:  <TASK>
May 17 03:34:29  kernel:  __schedule+0x442/0x12d0
May 17 03:34:29  kernel:  ? xas_load+0xd/0xe0
May 17 03:34:29  kernel:  ? xa_load+0x77/0xb0
May 17 03:34:29  kernel:  schedule+0x27/0xf0
May 17 03:34:29  kernel:  io_schedule+0x46/0x70
May 17 03:34:29  kernel:  folio_wait_bit_common+0x13f/0x340
May 17 03:34:29  kernel:  ? __pfx_wake_page_function+0x10/0x10
May 17 03:34:29  kernel:  folio_wait_writeback+0x2b/0x90
May 17 03:34:29  kernel:  truncate_inode_partial_folio+0x5e/0x1c0
May 17 03:34:29  kernel:  truncate_inode_pages_range+0x1de/0x410
May 17 03:34:29  kernel:  truncate_pagecache+0x47/0x60
May 17 03:34:29  kernel:  xfs_setattr_size+0xf6/0x3c0 [xfs]
May 17 03:34:29  kernel:  xfs_vn_setattr+0x85/0x150 [xfs]
May 17 03:34:29  kernel:  notify_change+0x301/0x500
May 17 03:34:29  kernel:  ? do_truncate+0x98/0xf0
May 17 03:34:29  kernel:  do_truncate+0x98/0xf0
May 17 03:34:29  kernel:  do_ftruncate+0x104/0x170
May 17 03:34:29  kernel:  do_sys_ftruncate+0x3d/0x80
May 17 03:34:29  kernel:  do_syscall_64+0xb7/0x210
May 17 03:34:29  kernel:  entry_SYSCALL_64_after_hwframe+0x77/0x7f
May 17 03:34:29  kernel: RIP: 0033:0x7f87aeb0d75b
May 17 03:34:29  kernel: RSP: 002b:00007ffddbfc04b8 EFLAGS: 00000213 =
ORIG_RAX: 000000000000004d
May 17 03:34:29  kernel: RAX: ffffffffffffffda RBX: 0000000000000000 =
RCX: 00007f87aeb0d75b
May 17 03:34:29  kernel: RDX: 0000000000000000 RSI: 0000000000000003 =
RDI: 0000000000000008
May 17 03:34:29  kernel: RBP: 0000557d5dd46498 R08: 0000000000000000 =
R09: 0000000000000000
May 17 03:34:29  kernel: R10: 0000000000000000 R11: 0000000000000213 =
R12: 0000000000000008
May 17 03:34:29  kernel: R13: 0000557d5dcd2aa0 R14: 0000557d5dd46468 =
R15: 0000000000000008
May 17 03:34:29  kernel:  </TASK>




--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

