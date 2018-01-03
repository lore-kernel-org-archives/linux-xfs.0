Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr011msb.fastweb.it ([85.18.95.108]:52780 "EHLO
        mr011msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752764AbeACOyv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 09:54:51 -0500
Subject: Re: Block size and read-modify-write
References: <021d36d95a9de952ddd38cc56d18df4f@assyoma.it>
 <20180102102539.5kh2tjo5gmlewiek@odin.usersys.redhat.com>
 <20180103011926.GJ5858@dastard>
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <b58a3a90-0e7b-abca-91ce-8b2d8819a75b@assyoma.it>
Date: Wed, 3 Jan 2018 15:54:42 +0100
MIME-Version: 1.0
In-Reply-To: <20180103011926.GJ5858@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: it-IT
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: Gionatan Danti <g.danti@assyoma.it>



On 03/01/2018 02:19, Dave Chinner wrote:
> Cached writes smaller than a *page* will cause RMW cycles in the
> page cache, regardless of the block size of the filesystem.

Sure, in this case a page-sized r/m/w cycle happen in the pagecache. 
However it seems to me that, when flushed to disk, writes happens at the 
block level granularity, as you can see from tests[1,2] below. Am I 
wrong? I am missing something?

> Ok, there is a difference between *sector size* and *filesystem
> block size*. You seem to be using them interchangably in your
> question, and that's not correct.

True, maybe I have issues grasping the concept of sector size from XFS 
point of view. I understand sector size as an hardware property of the 
underlying block device, but how does it relate to the filesystem?

I naively supposed that an XFS filesystem created with 4k *sector* size 
(ie: mkfs.xfs -s size=4096) would prevent 512 bytes O_DIRECT writes, but 
my test[3] shows that even of such a filesystem a 512B direct write is 
possible, indeed.

Is sector size information only used by XFS own metadata and journaling 
in order to avoid costly device-level r/m/w cycles on 512e devices? I 
understand that on 4Kn device you *have* to avoid sub-sector writes, or 
the transfer will fail.

> 
> .... this is not correct for direct IO. The direct IO path does not
> do RMW cycles at all.
> 
> Put simply: a 512B DIO write on a (real or emulated) 512B sector
> device with a 4k FSB will be serialised by the filesystem and do a
> single 512B sector write to the device.  However, if the device
> reports as a 4k sector device then a 512B DIO write will be rejected
> by the filesystem because sub-sector IO is not possible.

Ok, this was as expected.

I want to put some context on the original question, and why I am so 
interested on r/m/w cycles. SSD's flash-page size has, in recent years 
(2014+), ballooned to 8/16/32K. I wonder if a matching blocksize and/or 
sector size are needed to avoid (some of) device-level r/m/w cycles, 
which can dramatically increase flash write amplification (with reduced 
endurance).

Thanks.


------ test output below ------

# Block device properties
[root@blackhole queue]# blockdev --getss --getpbsz --getiomin --getbsz 
/dev/sda3
512
512
512
4096

[1] # XFS with blocksize=4K and sectorsize=512B (default)
[root@blackhole queue]# mkfs.xfs /dev/sda3
meta-data=/dev/sda3              isize=512    agcount=4, agsize=65536 blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=262144, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@blackhole queue]# mount /dev/sda3 /mnt/test/
# Preallocate file to minimize metadata traffic
[root@blackhole test]# fallocate /mnt/test/test.img -l 256M
# Write 512B via pagecache
[root@blackhole test]# while true; do echo 3 > /proc/sys/vm/drop_caches; 
dd if=/dev/urandom of=/mnt/test/test.img bs=512 count=1 oflag=dsync 
conv=nocreat,notrunc; sleep 1; done
# Dstat results: 4K reads/writes (read-modify-write)
[root@blackhole ~]# dstat -d -D /dev/sda3
--dsk/sda3-
  read  writ
4096B 4096B
4096B 4096B
4096B 4096B
# Write 512B via O_DIRECT
[root@blackhole test]# while true; do echo 3 > /proc/sys/vm/drop_caches; 
dd if=/dev/urandom of=/mnt/test/test.img bs=512 count=1 oflag=dsync 
conv=nocreat,notrunc oflag=direct; sleep 1; done
# Dstat results: 512B writes
[root@blackhole ~]# dstat -d -D /dev/sda3
--dsk/sda3-
  read  writ
    0   512B
    0   512B
    0   512B

[2] # XFS with blocksize=1K and sectorsize=512B
[root@blackhole mnt]# umount /mnt/test/
[root@blackhole mnt]# mkfs.xfs /dev/sda3 -f -b size=1024
meta-data=/dev/sda3              isize=512    agcount=4, agsize=262144 blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=1        finobt=0, sparse=0
data     =                       bsize=1024   blocks=1048576, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=1024   blocks=10240, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@blackhole mnt]# mount /dev/sda3 /mnt/test/
# Preallocate file to minimize metadata traffic
[root@blackhole mnt]# fallocate /mnt/test/test.img -l 256M
# Write 512B via pagecache
[root@blackhole mnt]# while true; do echo 3 > /proc/sys/vm/drop_caches; 
dd if=/dev/urandom of=/mnt/test/test.img bs=512 count=1 oflag=dsync 
conv=nocreat,notrunc; sleep 1; done
# Dstat results: 1K reads/writes (read-modify-write)
[root@blackhole ~]# dstat -d -D /dev/sda3
--dsk/sda3-
  read  writ
1024B 1024B
1024B 1024B
1024B 1024B
# Write 512B via O_DIRECT
while true; do echo 3 > /proc/sys/vm/drop_caches; dd if=/dev/urandom 
of=/mnt/test/test.img bs=512 count=1 oflag=dsync conv=nocreat,notrunc 
oflag=direct; sleep 1; done
# Dstat results: 512B writes
[root@blackhole ~]# dstat -d -D /dev/sda3
--dsk/sda3-
  read  writ
    0   512B
    0   512B
    0   512B

[3] # XFS with blocksize=4K and sectorsize=4K
[root@blackhole mnt]# umount /mnt/test/
[root@blackhole mnt]# mkfs.xfs /dev/sda3 -f -s size=4096
meta-data=/dev/sda3              isize=512    agcount=4, agsize=65536 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=262144, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@blackhole mnt]# mount /dev/sda3 /mnt/test/
# Preallocate file to minimize metadata traffic
[root@blackhole mnt]# fallocate /mnt/test/test.img -l 256M
# Write 512B via pagecache
[root@blackhole mnt]# while true; do echo 3 > /proc/sys/vm/drop_caches; 
dd if=/dev/urandom of=/mnt/test/test.img bs=512 count=1 oflag=dsync 
conv=nocreat,notrunc; sleep 1; done
# Dstat results: 4K reads/writes (read-modify-write)
[root@blackhole ~]# dstat -d -D /dev/sda3
--dsk/sda3-
  read  writ
4096B 4096B
4096B 4096B
4096B 4096B
# Write 512B via O_DIRECT
[root@blackhole mnt]# while true; do echo 3 > /proc/sys/vm/drop_caches; 
dd if=/dev/urandom of=/mnt/test/test.img bs=512 count=1 oflag=dsync 
conv=nocreat,notrunc oflag=direct; sleep 1; done
# Dstat results: 512B writes
[root@blackhole ~]# dstat -d -D /dev/sda3
--dsk/sda3-
  read  writ
    0   512B
    0   512B
    0   512B

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
