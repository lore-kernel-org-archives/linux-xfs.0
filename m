Return-Path: <SRS0=zhh1=BQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C804DC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Aug 2020 17:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36F42206B2
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Aug 2020 17:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgHFRcd convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:32:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729946AbgHFRcF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Aug 2020 13:32:05 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208827] New: [fio io_uring] io_uring write data crc32c verify
 failed
Date:   Thu, 06 Aug 2020 04:57:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-208827-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208827

            Bug ID: 208827
           Summary: [fio io_uring] io_uring write data crc32c verify
                    failed
           Product: File System
           Version: 2.5
    Kernel Version: xfs-linux xfs-5.9-merge-7 + v5.8-rc4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

Description of problem:
Our fio io_uring test failed as below:

# fio io_uring.fio
uring_w: (g=0): rw=randwrite, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB, (T)
64.0KiB-64.0KiB, ioengine=io_uring, iodepth=16
uring_sqt_w: (g=0): rw=randwrite, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB,
(T) 64.0KiB-64.0KiB, ioengine=io_uring, iodepth=16
uring_rw: (g=0): rw=randrw, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB, (T)
64.0KiB-64.0KiB, ioengine=io_uring, iodepth=16
uring_sqt_rw: (g=0): rw=randrw, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB,
(T) 64.0KiB-64.0KiB, ioengine=io_uring, iodepth=16
fio-3.21-39-g87622
Starting 4 threads
uring_w: Laying out IO file (1 file / 256MiB)
uring_sqt_w: Laying out IO file (1 file / 256MiB)
uring_rw: Laying out IO file (1 file / 256MiB)
uring_sqt_rw: Laying out IO file (1 file / 256MiB)
crc32c: verify failed at file /mnt/fio/uring_rw.0.0 offset 265289728, length
65536 (requested block: offset=265289728, length=65536)
       Expected CRC: e8f1ef35
       Received CRC: 9dd0deae
fio: pid=46530, err=84/file:io_u.c:2108, func=io_u_queued_complete,
error=Invalid or incomplete multibyte or wide character
crc32c: verify failed at file /mnt/fio/uring_sqt_rw.0.0 offset 268369920,
length 65536 (requested block: offset=268369920, length=65536)
       Expected CRC: 7e2a183e
       Received CRC: 652d5dbe
fio: pid=46531, err=84/file:io_u.c:2108, func=io_u_queued_complete,
error=Invalid or incomplete multibyte or wide character
crc32c: verify failed at file /mnt/fio/uring_sqt_w.0.0 offset 267911168, length
65536 (requested block: offset=267911168, length=65536)
       Expected CRC: 39d9d324
       Received CRC: a4a056be
fio: pid=46529, err=84/file:io_u.c:2108, func=io_u_queued_complete,
error=Invalid or incomplete multibyte or wide character
crc32c: verify failed at file /mnt/fio/uring_w.0.0 offset 264699904, length
65536 (requested block: offset=264699904, length=65536)
       Expected CRC: 3b5b87de
       Received CRC: 4e521e28
fio: pid=46528, err=84/file:io_u.c:2108, func=io_u_queued_complete,
error=Invalid or incomplete multibyte or wide character

uring_w: (groupid=0, jobs=1): err=84 (file:io_u.c:2108,
func=io_u_queued_complete, error=Invalid or incomplete multibyte or wide
character): pid=46528: Thu Aug  6 12:25:59 2020
  read: IOPS=455, BW=28.4MiB/s (29.8MB/s)(4448MiB/156391msec)
    slat (usec): min=6, max=112247, avg=52.95, stdev=893.43
    clat (nsec): min=148, max=13492M, avg=9750435.02, stdev=176173961.33
     lat (usec): min=35, max=13492k, avg=9803.70, stdev=176175.42
    clat percentiles (usec):
     |  1.00th=[    433],  5.00th=[    717], 10.00th=[    807],
     | 20.00th=[    824], 30.00th=[    832], 40.00th=[    840],
     | 50.00th=[    848], 60.00th=[    865], 70.00th=[    906],
     | 80.00th=[   1221], 90.00th=[   3851], 95.00th=[   7832],
     | 99.00th=[  96994], 99.50th=[ 256902], 99.90th=[2071987],
     | 99.95th=[3238003], 99.99th=[9730786]
  write: IOPS=5059, BW=316MiB/s (332MB/s)(4608MiB/14572msec); 0 zone resets
    slat (usec): min=26, max=767, avg=34.21, stdev= 9.47
    clat (usec): min=216, max=5434, avg=1708.28, stdev=450.47
     lat (usec): min=280, max=5552, avg=1742.70, stdev=451.53
    clat percentiles (usec):
     |  1.00th=[  758],  5.00th=[  996], 10.00th=[ 1045], 20.00th=[ 1139],
     | 30.00th=[ 1647], 40.00th=[ 1696], 50.00th=[ 1893], 60.00th=[ 1926],
     | 70.00th=[ 1926], 80.00th=[ 1942], 90.00th=[ 1991], 95.00th=[ 2180],
     | 99.00th=[ 3261], 99.50th=[ 3294], 99.90th=[ 3752], 99.95th=[ 3818],
     | 99.99th=[ 5014]   
   bw (  KiB/s): min= 8288, max=524288, per=93.06%, avg=258949.10,
stdev=157175.28, samples=30
   iops        : min=  129, max= 8192, avg=4045.83, stdev=2455.87, samples=30
  lat (nsec)   : 250=0.02%, 500=0.12%, 750=0.04%, 1000=0.11%
  lat (usec)   : 2=0.11%, 20=0.01%, 50=0.01%, 100=0.01%, 250=0.03%
  lat (usec)   : 500=0.24%, 750=2.61%, 1000=36.81%
  lat (msec)   : 2=49.61%, 4=5.45%, 10=2.93%, 20=0.88%, 50=0.39%
  lat (msec)   : 100=0.16%, 250=0.23%, 500=0.11%, 750=0.04%, 1000=0.02%
  lat (msec)   : 2000=0.04%, >=2000=0.05%
  cpu          : usr=2.05%, sys=6.92%, ctx=117371, majf=0, minf=11114
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.2%, 16=99.6%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=71166,73728,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16
...
...

Steps to Reproduce:
1. mkfs.xfs -f $general_partition_dev
2. mount $general_partition_dev /mnt/fio
3. run fio with below config file
$ cat uring.fio 
[global]
directory=/mnt/fio
size=256M
iodepth=16
bs=64k
verify=crc32c
thread=1
loops=200
unlink=1

[uring_w]
rw=randwrite
ioengine=io_uring
hipri=0
fixedbufs=0
registerfiles=0
sqthread_poll=0

[uring_sqt_w]
rw=randwrite
ioengine=io_uring
hipri=0
fixedbufs=0
registerfiles=1
sqthread_poll=1

[uring_rw]
rw=randrw
ioengine=io_uring
hipri=0
fixedbufs=0
registerfiles=0
sqthread_poll=0

[uring_sqt_rw]
rw=randrw
ioengine=io_uring
hipri=0
fixedbufs=0
registerfiles=1
sqthread_poll=1

Additional info:
I thought it's a io_uring issue at first, but I can't reproduce it on ext4. So
I report this bug XFS to get xfs-devel checking.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
