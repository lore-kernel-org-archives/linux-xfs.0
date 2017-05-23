Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr001msb.fastweb.it ([85.18.95.85]:53245 "EHLO
        mr001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750885AbdEWLBJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2017 07:01:09 -0400
Received: from ceres.assyoma.it (93.63.55.57) by mr001msb.fastweb.it (8.5.140.05)
        id 58FDB0C301323EC9 for linux-xfs@vger.kernel.org; Tue, 23 May 2017 13:01:07 +0200
Subject: Re: Shutdown filesystem when a thin pool become full
References: <c25a8ccc-f143-989d-3d49-3fe8753aa6f7@assyoma.it>
 <20170522230946.s3sdg4gd73oj7r5u@eorzea.usersys.redhat.com>
 <940c3b13-dea2-1887-d4ae-89555d1c2a4f@assyoma.it>
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <5f98a296-6023-f200-4c60-bcfdf0288d34@assyoma.it>
Date: Tue, 23 May 2017 13:01:06 +0200
MIME-Version: 1.0
In-Reply-To: <940c3b13-dea2-1887-d4ae-89555d1c2a4f@assyoma.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: it-IT
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it

On 23/05/2017 12:56, Gionatan Danti wrote:> Does a full thin pool 
*really* report a ENOSPC? On all my tests, I
> simply see "buffer i/o error on dev" on dmesg output (see below).

Ok, I forget to attach the debug logs :p

This is my initial LVM state:
[root@blackhole tmp]# lvs
   LV       VG        Attr       LSize  Pool     Origin Data%  Meta% 
Move Log Cpy%Sync Convert
   root     vg_system -wi-ao---- 50.00g
   swap     vg_system -wi-ao----  7.62g
   thinpool vg_system twi-aot---  1.00g                 1.51   0.98
   thinvol  vg_system Vwi-aot---  2.00g thinpool        0.76
[root@blackhole tmp]# lvchange vg_system/thinpool --errorwhenfull=y
   Logical volume vg_system/thinpool changed.

I create an XFS filesystem on /dev/vg_system/thinvol and mounted it 
under /mnt/storage. Then I filled it:

[root@blackhole tmp]# dd if=/dev/zero of=/mnt/storage/disk.img bs=1M 
count=2048 oflag=sync
dd: error writing ‘/mnt/storage/disk.img’: Input/output error
1009+0 records in
1008+0 records out
1056964608 bytes (1.1 GB) copied, 59.7361 s, 17.7 MB/s

[root@blackhole tmp]# df -h
Filesystem                     Size  Used Avail Use% Mounted on
/dev/mapper/vg_system-root      50G   47G  3.8G  93% /
devtmpfs                       3.8G     0  3.8G   0% /dev
tmpfs                          3.8G   84K  3.8G   1% /dev/shm
tmpfs                          3.8G  9.1M  3.8G   1% /run
tmpfs                          3.8G     0  3.8G   0% /sys/fs/cgroup
tmpfs                          3.8G   16K  3.8G   1% /tmp
/dev/sda1                     1014M  314M  701M  31% /boot
tmpfs                          774M   16K  774M   1% /run/user/42
tmpfs                          774M     0  774M   0% /run/user/0
/dev/mapper/vg_system-thinvol  2.0G  1.1G  993M  52% /mnt/storage

On dmesg I can see the following:

[ 3005.331830] XFS (dm-6): Mounting V5 Filesystem
[ 3005.443769] XFS (dm-6): Ending clean mount
[ 5891.595901] device-mapper: thin: Data device (dm-3) discard 
unsupported: Disabling discard passdown.
[ 5970.314062] device-mapper: thin: 253:4: reached low water mark for 
data device: sending event.
[ 5970.358234] device-mapper: thin: 253:4: switching pool to 
out-of-data-space (error IO) mode
[ 5970.358528] Buffer I/O error on dev dm-6, logical block 389248, lost 
async page write
[ 5970.358546] Buffer I/O error on dev dm-6, logical block 389249, lost 
async page write
[ 5970.358552] Buffer I/O error on dev dm-6, logical block 389250, lost 
async page write
[ 5970.358557] Buffer I/O error on dev dm-6, logical block 389251, lost 
async page write
[ 5970.358562] Buffer I/O error on dev dm-6, logical block 389252, lost 
async page write
[ 5970.358567] Buffer I/O error on dev dm-6, logical block 389253, lost 
async page write
[ 5970.358573] Buffer I/O error on dev dm-6, logical block 389254, lost 
async page write
[ 5970.358577] Buffer I/O error on dev dm-6, logical block 389255, lost 
async page write
[ 5970.358583] Buffer I/O error on dev dm-6, logical block 389256, lost 
async page write
[ 5970.358594] Buffer I/O error on dev dm-6, logical block 389257, lost 
async page write

This appears as a "normal" I/O error, right? Or I am missing something?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
