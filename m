Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr003msb.fastweb.it ([85.18.95.87]:41756 "EHLO
        mr003msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752164AbdFOLvQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2017 07:51:16 -0400
Received: from ceres.assyoma.it (93.63.55.57) by mr003msb.fastweb.it (8.5.140.05)
        id 593E4F9F00238AE7 for linux-xfs@vger.kernel.org; Thu, 15 Jun 2017 13:51:14 +0200
Subject: Re: Shutdown filesystem when a thin pool become full
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Thu, 15 Jun 2017 13:51:13 +0200
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <7e8e16f1-5425-44b3-e908-c0e8a3300e3f@assyoma.it>
References: <c25a8ccc-f143-989d-3d49-3fe8753aa6f7@assyoma.it>
 <20170522230946.s3sdg4gd73oj7r5u@eorzea.usersys.redhat.com>
 <940c3b13-dea2-1887-d4ae-89555d1c2a4f@assyoma.it>
 <5f98a296-6023-f200-4c60-bcfdf0288d34@assyoma.it>
 <20170523122753.k7plzg3musc4up73@eorzea.usersys.redhat.com>
 <24daa89a452496d2cdffa5512a64ed2e@assyoma.it>
 <7e8e16f1-5425-44b3-e908-c0e8a3300e3f@assyoma.it>
Message-ID: <a89aa00c4f86fbdc674dd8f5b5eeb248@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Il 13-06-2017 11:09 Gionatan Danti ha scritto:
> Sorry for the bump, but further tests show unexpected behavior and I
> would really like to understand what I am missing.
> 
> Current setup:	CentOS 7.3 x86-64
> Kernel version:	3.10.0-514.21.1.el7.x86_64
> 
> LVM2 version (from lvm version):
>   LVM version:     2.02.166(2)-RHEL7 (2016-11-16)
>   Library version: 1.02.135-RHEL7 (2016-11-16)
>   Driver version:  4.34.0
> 
> On 23/05/2017 22:05, Gionatan Danti wrote:
>> 
>> Ok, I tried with a more typical non-sync write and it seems to report 
>> ENOSPC:
>> 
>> [root@blackhole ~]# dd if=/dev/zero of=/mnt/storage/disk.img bs=1M 
>> count=2048
>> dd: error writing ‘/mnt/storage/disk.img’: No space left on device
>> 2002+0 records in
>> 2001+0 records out
>> 2098917376 bytes (2.1 GB) copied, 7.88216 s, 266 MB/s
>> 
> 
> Contrary to what reported above, thin pool seems to *not* reporting
> ENOSPC when full. This means that any new data submitted to the
> filesystem will be reported as "written" but they never were.
> 
> I fully understand that application who cares for their data should
> regularly use fsync(). However, *many* application don't do that. One
> notable example is Windows Explorer: when accessing a full thinvol via
> a samba share, it will blatantly continue do "write" to the share
> without notice the user in any way that something is wrong. This is a
> recipe for disaster, as the user continues to uploads file which
> basically get lost...
> 
> Yes, the lacking fsync() use really is an application-level problem.
> However, sending files to (basically) /dev/null when the pool is full
> does not seems a smart thing.
> 
> I am surely doing wrong something, but I can not found what. Give a
> look below for how to reproduce...
> 
> # thinpool has errorwhenfull=y set
> # thinpool is 256M, thin volume is 1G
> [root@blackhole mnt]# lvs -o +whenfull
>   LV       VG        Attr       LSize   Pool     Origin Data%  Meta%
> Move Log Cpy%Sync Convert WhenFull
>   fatvol   vg_kvm    -wi-ao---- 256.00m
> 
>   storage  vg_kvm    -wi-a----- 300.00g
> 
>   thinpool vg_kvm    twi-aot--- 256.00m                 1.46   0.98
>                      error
>   thinvol  vg_kvm    Vwi-aot---   1.00g thinpool        0.37
> 
>   root     vg_system -wi-ao----  50.00g
> 
>   swap     vg_system -wi-ao----   7.62g
> 
> # current device mappings
> [root@blackhole mnt]# ls -al /dev/mapper/ | grep thin
> lrwxrwxrwx.  1 root root       7 13 giu 09.37 vg_kvm-thinpool -> 
> ../dm-7
> lrwxrwxrwx.  1 root root       7 13 giu 09.39 vg_kvm-thinpool_tdata -> 
> ../dm-5
> lrwxrwxrwx.  1 root root       7 13 giu 09.39 vg_kvm-thinpool_tmeta -> 
> ../dm-4
> lrwxrwxrwx.  1 root root       7 13 giu 09.39 vg_kvm-thinpool-tpool -> 
> ../dm-6
> lrwxrwxrwx.  1 root root       7 13 giu 10.46 vg_kvm-thinvol -> ../dm-8
> 
> # disabled ENOSPC max_retries (default value does not change anything)
> [root@blackhole mnt]# cat 
> /sys/fs/xfs/dm-8/error/metadata/ENOSPC/max_retries
> 0
> 
> # current filesystem use
> [root@blackhole mnt]# df -h | grep thin
> /dev/mapper/vg_kvm-thinvol 1021M   33M  989M   4% /mnt/thinvol
> 
> # write 400M - it should fill the thinpool
> [root@blackhole mnt]# dd if=/dev/zero of=/mnt/thinvol/disk.img bs=1M 
> count=400
> 400+0 records in
> 400+0 records out
> 419430400 bytes (419 MB) copied, 0.424677 s, 988 MB/s
> 
> ... wait 30 seconds ...
> 
> # thin pool switched to out-of-space mode
> [root@blackhole mnt]# dmesg
> [ 4408.257419] XFS (dm-8): Mounting V5 Filesystem
> [ 4408.368891] XFS (dm-8): Ending clean mount
> [ 4460.147962] device-mapper: thin: 253:6: switching pool to
> out-of-data-space (error IO) mode
> [ 4460.218484] buffer_io_error: 199623 callbacks suppressed
> [ 4460.218497] Buffer I/O error on dev dm-8, logical block 86032, lost
> async page write
> [ 4460.218510] Buffer I/O error on dev dm-8, logical block 86033, lost
> async page write
> [ 4460.218516] Buffer I/O error on dev dm-8, logical block 86034, lost
> async page write
> [ 4460.218521] Buffer I/O error on dev dm-8, logical block 86035, lost
> async page write
> [ 4460.218526] Buffer I/O error on dev dm-8, logical block 86036, lost
> async page write
> [ 4460.218531] Buffer I/O error on dev dm-8, logical block 86037, lost
> async page write
> [ 4460.218536] Buffer I/O error on dev dm-8, logical block 86038, lost
> async page write
> [ 4460.218541] Buffer I/O error on dev dm-8, logical block 86039, lost
> async page write
> [ 4460.218546] Buffer I/O error on dev dm-8, logical block 86040, lost
> async page write
> [ 4460.218551] Buffer I/O error on dev dm-8, logical block 86041, lost
> async page write
> 
> # current thinpool state
> [root@blackhole mnt]# lvs -o +whenfull
>   LV       VG        Attr       LSize   Pool     Origin Data%  Meta%
> Move Log Cpy%Sync Convert WhenFull
>   fatvol   vg_kvm    -wi-a----- 256.00m
> 
>   storage  vg_kvm    -wi-a----- 300.00g
> 
>   thinpool vg_kvm    twi-aot-D- 256.00m                 100.00 4.10
>                      error
>   thinvol  vg_kvm    Vwi-aot---   1.00g thinpool        25.00
> 
>   root     vg_system -wi-ao----  50.00g
> 
>   swap     vg_system -wi-ao----   7.62g
> 
> # write another 400M - they should *not* be allowed to complete without 
> errors
> [root@blackhole mnt]# dd if=/dev/zero of=/mnt/thinvol/disk2.img bs=1M 
> count=400
> 400+0 records in
> 400+0 records out
> 419430400 bytes (419 MB) copied, 0.36643 s, 1.1 GB/s
> 
> # no errors reported! give a look at dmesg
> 
> [root@blackhole mnt]# dmesg
> [ 4603.649156] buffer_io_error: 44890 callbacks suppressed
> [ 4603.649163] Buffer I/O error on dev dm-8, logical block 163776,
> lost async page write
> [ 4603.649172] Buffer I/O error on dev dm-8, logical block 163777,
> lost async page write
> [ 4603.649175] Buffer I/O error on dev dm-8, logical block 163778,
> lost async page write
> [ 4603.649178] Buffer I/O error on dev dm-8, logical block 163779,
> lost async page write
> [ 4603.649181] Buffer I/O error on dev dm-8, logical block 163780,
> lost async page write
> [ 4603.649184] Buffer I/O error on dev dm-8, logical block 163781,
> lost async page write
> [ 4603.649187] Buffer I/O error on dev dm-8, logical block 163782,
> lost async page write
> [ 4603.649189] Buffer I/O error on dev dm-8, logical block 163783,
> lost async page write
> [ 4603.649192] Buffer I/O error on dev dm-8, logical block 163784,
> lost async page write
> [ 4603.649194] Buffer I/O error on dev dm-8, logical block 163785,
> lost async page write
> 
> # current filesystem use
> [root@blackhole mnt]# df -h | grep thin
> /dev/mapper/vg_kvm-thinvol 1021M  833M  189M  82% /mnt/thinvol

Hi all,
any suggestion regarding the issue?

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
