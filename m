Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37214 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbeKZWrg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Nov 2018 17:47:36 -0500
Date: Mon, 26 Nov 2018 19:55:30 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [GIT PULL] xfs: fixes for v4.20-rc4
Message-ID: <20181126115530.GC2299@dhcp-12-149.nay.redhat.com>
References: <20181124170540.GY6792@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181124170540.GY6792@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Nov 24, 2018 at 09:05:40AM -0800, Darrick J. Wong wrote:
> Hi Linus,
> 
> Dave and I have continued our work fixing corruption problems that can
> be found when running long-term burn-in exercisers on xfs.  Here are
> some patches fixing most of the problems, but there will likely be more.
> :/
> 
> Anyhow, this series merges cleanly with master as of last night, so
> please let me know if you encounter problems.
> 
> --D
> 
> The following changes since commit 837514f7a4ca4aca06aec5caa5ff56d33ef06976:
> 
>   xfs: fix overflow in xfs_attr3_leaf_verify (2018-11-06 07:50:50 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.20-fixes-2

Hi Darrick,

I hit a xfs corruption several times on xfs-4.20-fixes-2. By loop running g/299
with 2k block size XFS on ppc64le. As below:

Thanks,
Zorro

# while true; do ./check generic/299 || break;done
...
...
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/ppc64le ibm-p8-kvm-09-guest-14 4.20.0-rc1.kasan
MKFS_OPTIONS  -- -f -b size=2048 -m crc=1,finobt=1,reflink=1,rmapbt=1 -i sparse=1 /dev/vda5
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/vda5 /mnt/xfstests/mnt2

generic/299 153s ... _check_xfs_filesystem: filesystem on /dev/vda5 is inconsistent (r)
(see /var/lib/xfstests/results//generic/299.full for details)

Ran: generic/299
Failures: generic/299
Failed 1 of 1 tests

# cat generic/299.full
fio --ioengine=libaio --bs=128k --directory=/mnt/xfstests/mnt2 --filesize=16106127360 --size=999G --iodepth=128*1 --continue_on_error=write --ignore_error=,ENOSPC --error_dump=0 --create_on_open=1 --fallocate=none --exitall=1 --name=direct_aio --direct=1 --buffered=0 --numjobs=4 --rw=randwrite --runtime=100*1 --time_based --name=aio-dio-verifier Option verifysort is deprecated
--numjobs=1 --verify=crc32c-intel --verify_fatal=1 --verify_dump=1 --verify_backlog=1024 --verify_async=4 --verifysort=1 --direct=1 --bs=4k --rw=randrw --filename=aio-dio-verifier --name=buffered-aio-verifier Option verifysort is deprecated
--numjobs=1 --verify=crc32c-intel --verify_fatal=1 --verify_dump=1 --verify_backlog=1024 --verify_async=4 --verifysort=1 --direct=0 --buffered=1 --bs=4k --rw=randrw --filename=buffered-aio-verifier 
meta-data=/dev/vda5              isize=512    agcount=4, agsize=1966080 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1
data     =                       bsize=2048   blocks=7864320, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=2048   blocks=5120, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
###########
# 299 test fio activity
# Filenames derived from jobsname and jobid like follows:
# ..
[global]
ioengine=libaio
bs=128k
directory=/mnt/xfstests/mnt2
filesize=16106127360
size=999G
iodepth=128*1
continue_on_error=write
ignore_error=,ENOSPC
error_dump=0
create_on_open=1
fallocate=none
exitall=1

## Perform direct aio, to files which may be truncated
## by external task
[direct_aio]
direct=1
buffered=0
numjobs=4
rw=randwrite
runtime=100*1
time_based

# Perform direct aio and verify data
# This test case should check use-after-free issues
[aio-dio-verifier]
numjobs=1
verify=crc32c-intel
verify_fatal=1
verify_dump=1
verify_backlog=1024
verify_async=4
verifysort=1
direct=1
bs=4k
rw=randrw
filename=aio-dio-verifier

# Perform buffered aio and verify data
# This test case should check use-after-free issues
[buffered-aio-verifier]
numjobs=1
verify=crc32c-intel
verify_fatal=1
verify_dump=1
verify_backlog=1024
verify_async=4
verifysort=1
direct=0
buffered=1
bs=4k
rw=randrw
filename=buffered-aio-verifier
# /usr/bin/fio /tmp/29540.fio
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
direct_aio: (g=0): rw=randwrite, bs=(R) 128KiB-128KiB, (W) 128KiB-128KiB, (T) 128KiB-128KiB, ioengine=libaio, iodepth=128
...
Option verifysort is deprecated
aio-dio-verifier: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=128
Option verifysort is deprecated
buffered-aio-verifier: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=128
fio-3.7
Starting 6 processes
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device
fallocate: No space left on device

direct_aio: (groupid=0, jobs=1): err= 0: pid=29784: Mon Nov 26 05:03:39 2018
  write: IOPS=97, BW=12.2MiB/s (12.8MB/s)(1222MiB/100298msec)
    slat (usec): min=24, max=1135.8k, avg=7297.52, stdev=51858.55
    clat (msec): min=13, max=22145, avg=1300.26, stdev=2872.82
     lat (msec): min=13, max=22201, avg=1307.56, stdev=2893.11
    clat percentiles (msec):
     |  1.00th=[   38],  5.00th=[   95], 10.00th=[  157], 20.00th=[  284],
     | 30.00th=[  405], 40.00th=[  518], 50.00th=[  642], 60.00th=[  776],
     | 70.00th=[  919], 80.00th=[ 1150], 90.00th=[ 1703], 95.00th=[ 3339],
     | 99.00th=[17113], 99.50th=[17113], 99.90th=[17113], 99.95th=[17113],
     | 99.99th=[17113]
   bw (  KiB/s): min=  255, max=72448, per=32.25%, avg=13205.90, stdev=16411.99, samples=187
   iops        : min=    1, max=  566, avg=103.07, stdev=128.25, samples=187
  lat (msec)   : 20=0.07%, 50=1.82%, 100=3.54%, 250=11.75%, 500=21.27%
  lat (msec)   : 750=20.17%, 1000=17.25%
  cpu          : usr=0.40%, sys=1.09%, ctx=6780, majf=0, minf=7
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.2%, 32=0.3%, >=64=99.4%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued rwts: total=0,9777,0,0 short=0,0,0,0 dropped=0,0,0,0
     errors    : total=0, first_error=0/<Success>
     latency   : target=0, window=0, percentile=100.00%, depth=128
direct_aio: (groupid=0, jobs=1): err=28 (): pid=29785: Mon Nov 26 05:03:39 2018
  write: IOPS=76, BW=9817KiB/s (10.1MB/s)(962MiB/100297msec)
    slat (usec): min=25, max=15232k, avg=11268.43, stdev=191673.36
    clat (msec): min=12, max=18573, avg=1652.72, stdev=2615.40
     lat (msec): min=12, max=18573, avg=1663.99, stdev=2626.01
    clat percentiles (msec):
     |  1.00th=[   83],  5.00th=[  213], 10.00th=[  326], 20.00th=[  485],
     | 30.00th=[  609], 40.00th=[  751], 50.00th=[  927], 60.00th=[ 1099],
     | 70.00th=[ 1368], 80.00th=[ 1838], 90.00th=[ 3339], 95.00th=[ 5403],
     | 99.00th=[17113], 99.50th=[17113], 99.90th=[17113], 99.95th=[17113],
     | 99.99th=[17113]
   bw (  KiB/s): min=  255, max=74347, per=34.51%, avg=14132.23, stdev=15051.32, samples=137
   iops        : min=    1, max=  580, avg=110.38, stdev=117.57, samples=137
  lat (msec)   : 20=0.18%, 50=0.42%, 100=0.83%, 250=5.10%, 500=16.22%
  lat (msec)   : 750=17.18%, 1000=15.30%
  cpu          : usr=0.37%, sys=0.77%, ctx=3356, majf=0, minf=8
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.2%, 32=0.4%, >=64=99.2%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued rwts: total=0,7693,0,0 short=0,0,0,0 dropped=0,0,0,0
     errors    : total=1, first_error=28/<No space left on device>
     latency   : target=0, window=0, percentile=100.00%, depth=128
direct_aio: (groupid=0, jobs=1): err= 0: pid=29787: Mon Nov 26 05:03:39 2018
  write: IOPS=74, BW=9513KiB/s (9741kB/s)(932MiB/100297msec)
    slat (usec): min=24, max=4966.9k, avg=12229.77, stdev=108059.10
    clat (msec): min=16, max=10530, avg=1702.61, stdev=1924.05
     lat (msec): min=16, max=10530, avg=1714.85, stdev=1931.56
    clat percentiles (msec):
     |  1.00th=[   70],  5.00th=[  259], 10.00th=[  401], 20.00th=[  531],
     | 30.00th=[  676], 40.00th=[  844], 50.00th=[ 1036], 60.00th=[ 1318],
     | 70.00th=[ 1737], 80.00th=[ 2198], 90.00th=[ 3876], 95.00th=[ 5873],
     | 99.00th=[ 9463], 99.50th=[ 9731], 99.90th=[10537], 99.95th=[10537],
     | 99.99th=[10537]
   bw (  KiB/s): min=  255, max=51456, per=31.58%, avg=12932.45, stdev=13416.48, samples=145
   iops        : min=    1, max=  402, avg=100.98, stdev=104.83, samples=145
  lat (msec)   : 20=0.03%, 50=0.63%, 100=0.63%, 250=3.58%, 500=12.30%
  lat (msec)   : 750=16.49%, 1000=14.97%
  cpu          : usr=0.27%, sys=0.87%, ctx=3352, majf=0, minf=7
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.2%, 32=0.4%, >=64=99.2%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued rwts: total=0,7454,0,0 short=0,0,0,0 dropped=0,0,0,0
     errors    : total=0, first_error=0/<Success>
     latency   : target=0, window=0, percentile=100.00%, depth=128
direct_aio: (groupid=0, jobs=1): err= 0: pid=29789: Mon Nov 26 05:03:39 2018
  write: IOPS=46, BW=5936KiB/s (6078kB/s)(595MiB/102577msec)
    slat (usec): min=13, max=32710k, avg=20836.57, stdev=488166.72
    clat (msec): min=19, max=34082, avg=2723.54, stdev=6121.38
     lat (msec): min=19, max=36460, avg=2744.38, stdev=6148.86
    clat percentiles (msec):
     |  1.00th=[   48],  5.00th=[  144], 10.00th=[  234], 20.00th=[  393],
     | 30.00th=[  510], 40.00th=[  751], 50.00th=[  894], 60.00th=[ 1003],
     | 70.00th=[ 1301], 80.00th=[ 2366], 90.00th=[ 5604], 95.00th=[14832],
     | 99.00th=[17113], 99.50th=[17113], 99.90th=[17113], 99.95th=[17113],
     | 99.99th=[17113]
   bw (  KiB/s): min=  255, max=67840, per=30.46%, avg=12472.08, stdev=15144.14, samples=95
   iops        : min=    1, max=  530, avg=97.37, stdev=118.33, samples=95
  lat (msec)   : 20=0.04%, 50=1.03%, 100=1.39%, 250=9.90%, 500=15.96%
  lat (msec)   : 750=11.75%, 1000=20.22%
  cpu          : usr=0.22%, sys=0.47%, ctx=1140, majf=0, minf=8
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.2%, 16=0.3%, 32=0.7%, >=64=98.7%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued rwts: total=0,4757,0,0 short=0,0,0,0 dropped=0,0,0,0
     errors    : total=0, first_error=0/<Success>
     latency   : target=0, window=0, percentile=100.00%, depth=128
aio-dio-verifier: (groupid=0, jobs=1): err= 0: pid=29790: Mon Nov 26 05:03:39 2018
   read: IOPS=132, BW=531KiB/s (544kB/s)(52.1MiB/100378msec)
    slat (usec): min=2, max=1110.4k, avg=949.67, stdev=17580.98
    clat (nsec): min=1390, max=11234M, avg=299769759.11, stdev=1177119594.87
     lat (usec): min=4, max=11234k, avg=300721.89, stdev=1180554.79
    clat percentiles (usec):
     |  1.00th=[       3],  5.00th=[      29], 10.00th=[     221],
     | 20.00th=[     955], 30.00th=[    2474], 40.00th=[    5932],
     | 50.00th=[   22938], 60.00th=[   65799], 70.00th=[  107480],
     | 80.00th=[  152044], 90.00th=[  434111], 95.00th=[  977273],
     | 99.00th=[ 8086619], 99.50th=[ 9596568], 99.90th=[10536092],
     | 99.95th=[11072963], 99.99th=[11207181]
   bw (  KiB/s): min=    8, max= 2067, per=6.59%, avg=455.65, stdev=539.72, samples=144
   iops        : min=    2, max=  518, avg=113.99, stdev=135.02, samples=144
  write: IOPS=81, BW=324KiB/s (332kB/s)(31.8MiB/100378msec)
    slat (usec): min=34, max=1803.9k, avg=7002.55, stdev=53896.35
    clat (msec): min=8, max=12171, avg=1075.13, stdev=1561.65
     lat (msec): min=8, max=12203, avg=1082.13, stdev=1577.90
    clat percentiles (msec):
     |  1.00th=[   36],  5.00th=[  128], 10.00th=[  215], 20.00th=[  317],
     | 30.00th=[  447], 40.00th=[  575], 50.00th=[  693], 60.00th=[  818],
     | 70.00th=[  995], 80.00th=[ 1234], 90.00th=[ 1770], 95.00th=[ 3272],
     | 99.00th=[ 9731], 99.50th=[10537], 99.90th=[11342], 99.95th=[11610],
     | 99.99th=[12147]
   bw (  KiB/s): min=    8, max= 2136, per=0.91%, avg=371.73, stdev=446.85, samples=172
   iops        : min=    2, max=  534, avg=92.89, stdev=111.71, samples=172
  lat (usec)   : 2=0.33%, 4=1.16%, 10=0.90%, 20=0.33%, 50=0.82%
  lat (usec)   : 100=0.77%, 250=2.26%, 500=2.61%, 750=1.78%, 1000=1.74%
  lat (msec)   : 2=4.34%, 4=5.24%, 10=5.72%, 20=2.51%, 50=4.99%
  lat (msec)   : 100=8.18%, 250=15.35%, 500=10.62%, 750=9.33%, 1000=6.91%
  cpu          : usr=0.96%, sys=0.99%, ctx=10235, majf=0, minf=12
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.7%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued rwts: total=13337,8132,0,0 short=0,0,0,0 dropped=0,0,0,0
     errors    : total=0, first_error=0/<Success>
     latency   : target=0, window=0, percentile=100.00%, depth=128
buffered-aio-verifier: (groupid=0, jobs=1): err= 0: pid=29791: Mon Nov 26 05:03:39 2018
   read: IOPS=1596, BW=6387KiB/s (6541kB/s)(626MiB/100334msec)
    slat (usec): min=3, max=1432.9k, avg=321.22, stdev=10396.86
    clat (usec): min=1301, max=3679.6k, avg=44781.14, stdev=175511.11
     lat (usec): min=1309, max=3679.7k, avg=45104.08, stdev=176411.48
    clat percentiles (msec):
     |  1.00th=[    4],  5.00th=[    5], 10.00th=[    6], 20.00th=[    7],
     | 30.00th=[    7], 40.00th=[    7], 50.00th=[    8], 60.00th=[    9],
     | 70.00th=[    9], 80.00th=[   11], 90.00th=[   42], 95.00th=[  213],
     | 99.00th=[  919], 99.50th=[ 1301], 99.90th=[ 1989], 99.95th=[ 2635],
     | 99.99th=[ 3104]
   bw (  KiB/s): min=    8, max=33600, per=63.78%, avg=4410.54, stdev=7041.52, samples=168
   iops        : min=    2, max= 8400, avg=1102.65, stdev=1760.49, samples=168
  write: IOPS=918, BW=3674KiB/s (3762kB/s)(360MiB/100334msec)
    slat (usec): min=18, max=1798.9k, avg=473.00, stdev=11760.01
    clat (usec): min=53, max=3679.6k, avg=60394.40, stdev=222340.06
     lat (usec): min=1340, max=3679.8k, avg=60869.31, stdev=223524.75
    clat percentiles (msec):
     |  1.00th=[    5],  5.00th=[    6], 10.00th=[    6], 20.00th=[    7],
     | 30.00th=[    7], 40.00th=[    7], 50.00th=[    7], 60.00th=[    8],
     | 70.00th=[    9], 80.00th=[   11], 90.00th=[   90], 95.00th=[  338],
     | 99.00th=[ 1133], 99.50th=[ 1536], 99.90th=[ 2937], 99.95th=[ 3004],
     | 99.99th=[ 3675]
   bw (  KiB/s): min=    8, max=32768, per=10.85%, avg=4440.91, stdev=6990.85, samples=166
   iops        : min=    2, max= 8192, avg=1110.20, stdev=1747.71, samples=166
  lat (usec)   : 100=0.01%
  lat (msec)   : 2=0.08%, 4=0.84%, 10=76.80%, 20=10.67%, 50=1.41%
  lat (msec)   : 100=1.48%, 250=4.00%, 500=1.84%, 750=1.18%, 1000=0.70%
  cpu          : usr=5.22%, sys=9.05%, ctx=77399, majf=0, minf=46
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued rwts: total=160219,92161,0,0 short=0,0,0,0 dropped=0,0,0,0
     errors    : total=0, first_error=0/<Success>
     latency   : target=0, window=0, percentile=100.00%, depth=128

Run status group 0 (all jobs):
   READ: bw=6916KiB/s (7082kB/s), 531KiB/s-6387KiB/s (544kB/s-6541kB/s), io=678MiB (711MB), run=100334-100378msec
  WRITE: bw=39.0MiB/s (41.9MB/s), 324KiB/s-12.2MiB/s (332kB/s-12.8MB/s), io=4102MiB (4301MB), run=100297-102577msec

Disk stats (read/write):
  vda: ios=5167/39498, merge=2735/75860, ticks=413705/10814432, in_queue=8535340, util=95.59%
_check_xfs_filesystem: filesystem on /dev/vda5 is inconsistent (r)
*** xfs_repair -n output ***
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
sb_fdblocks 7031562, counted 7031570
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.
*** end xfs_repair output
*** mount output ***
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime,seclabel)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
devtmpfs on /dev type devtmpfs (rw,nosuid,seclabel,size=4672832k,nr_inodes=73013,mode=755)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev,seclabel,size=4702208k,nr_inodes=73472)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,seclabel,gid=5,mode=620,ptmxmode=000)
tmpfs on /run type tmpfs (rw,nosuid,nodev,seclabel,size=4702208k,nr_inodes=73472,mode=755)
tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,seclabel,size=4702208k,nr_inodes=73472,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime,seclabel)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,memory)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,cpuset)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,blkio)
cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,perf_event)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,cpu,cpuacct)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,devices)
cgroup on /sys/fs/cgroup/hugetlb type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,hugetlb)
cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,net_cls,net_prio)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,freezer)
cgroup on /sys/fs/cgroup/pids type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,pids)
cgroup on /sys/fs/cgroup/rdma type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,rdma)
configfs on /sys/kernel/config type configfs (rw,relatime)
/dev/vda8 on / type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
selinuxfs on /sys/fs/selinux type selinuxfs (rw,relatime)
systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=42,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=12956)
mqueue on /dev/mqueue type mqueue (rw,relatime,seclabel)
debugfs on /sys/kernel/debug type debugfs (rw,relatime,seclabel)
/dev/vda2 on /boot type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw,relatime)
tmpfs on /run/user/0 type tmpfs (rw,nosuid,nodev,relatime,seclabel,size=918272k,mode=700)
*** end mount output

> 
> for you to fetch changes up to 8c110d43c6bca4b24dd13272a9d4e0ba6f2ec957:
> 
>   iomap: readpages doesn't zero page tail beyond EOF (2018-11-21 10:10:54 -0800)
> 
> ----------------------------------------------------------------
> Changes since last update:
> - Numerous corruption fixes for copy on write
> - Numerous corruption fixes for blocksize < pagesize writes
> - Don't miscalculate AG reservations for small final AGs
> - Fix page cache truncation to work properly for reflink and extent
>   shifting
> - Fix use-after-free when retrying failed inode/dquot buffer logging
> - Fix corruptions seen when using copy_file_range in directio mode
> 
> ----------------------------------------------------------------
> Brian Foster (1):
>       xfs: fix shared extent data corruption due to missing cow reservation
> 
> Dave Chinner (11):
>       xfs: uncached buffer tracing needs to print bno
>       xfs: fix transient reference count error in xfs_buf_resubmit_failed_buffers
>       xfs: finobt AG reserves don't consider last AG can be a runt
>       xfs: extent shifting doesn't fully invalidate page cache
>       xfs: flush removing page cache in xfs_reflink_remap_prep
>       xfs: delalloc -> unwritten COW fork allocation can go wrong
>       iomap: FUA is wrong for DIO O_DSYNC writes into unwritten extents
>       iomap: sub-block dio needs to zeroout beyond EOF
>       iomap: dio data corruption and spurious errors when pipes fill
>       vfs: vfs_dedupe_file_range() doesn't return EOPNOTSUPP
>       iomap: readpages doesn't zero page tail beyond EOF
> 
> Eric Biggers (1):
>       xfs: make xfs_file_remap_range() static
> 
>  fs/iomap.c                       | 53 +++++++++++++++++++++++++++++++---------
>  fs/read_write.c                  | 15 ++++++------
>  fs/xfs/libxfs/xfs_bmap.c         |  5 +++-
>  fs/xfs/libxfs/xfs_ialloc_btree.c | 11 ++++++---
>  fs/xfs/xfs_bmap_util.c           | 10 ++------
>  fs/xfs/xfs_bmap_util.h           |  3 +++
>  fs/xfs/xfs_buf_item.c            | 28 +++++++++++++++------
>  fs/xfs/xfs_file.c                |  2 +-
>  fs/xfs/xfs_reflink.c             | 18 +++++++++++---
>  fs/xfs/xfs_trace.h               |  5 +++-
>  10 files changed, 104 insertions(+), 46 deletions(-)
