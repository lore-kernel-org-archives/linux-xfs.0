Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53270 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759899AbdEWM16 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 May 2017 08:27:58 -0400
Date: Tue, 23 May 2017 14:27:53 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Shutdown filesystem when a thin pool become full
Message-ID: <20170523122753.k7plzg3musc4up73@eorzea.usersys.redhat.com>
References: <c25a8ccc-f143-989d-3d49-3fe8753aa6f7@assyoma.it>
 <20170522230946.s3sdg4gd73oj7r5u@eorzea.usersys.redhat.com>
 <940c3b13-dea2-1887-d4ae-89555d1c2a4f@assyoma.it>
 <5f98a296-6023-f200-4c60-bcfdf0288d34@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5f98a296-6023-f200-4c60-bcfdf0288d34@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Tue, May 23, 2017 at 01:01:06PM +0200, Gionatan Danti wrote:
> On 23/05/2017 12:56, Gionatan Danti wrote:> Does a full thin pool *really*
> report a ENOSPC? On all my tests, I
> > simply see "buffer i/o error on dev" on dmesg output (see below).
> 
> Ok, I forget to attach the debug logs :p
> 
> This is my initial LVM state:
> [root@blackhole tmp]# lvs
>   LV       VG        Attr       LSize  Pool     Origin Data%  Meta% Move Log
> Cpy%Sync Convert
>   root     vg_system -wi-ao---- 50.00g
>   swap     vg_system -wi-ao----  7.62g
>   thinpool vg_system twi-aot---  1.00g                 1.51   0.98
>   thinvol  vg_system Vwi-aot---  2.00g thinpool        0.76
> [root@blackhole tmp]# lvchange vg_system/thinpool --errorwhenfull=y
>   Logical volume vg_system/thinpool changed.
> 
> I create an XFS filesystem on /dev/vg_system/thinvol and mounted it under
> /mnt/storage. Then I filled it:
> 
> [root@blackhole tmp]# dd if=/dev/zero of=/mnt/storage/disk.img bs=1M
> count=2048 oflag=sync
> dd: error writing ‘/mnt/storage/disk.img’: Input/output error

Aha, you are using sync flag, that's why you are getting IO errors instead of
ENOSPC, I don't remember from the top of my mind why exactly, it's been a while
since I started to work on this XFS and dm-thin integration, but IIRC, the
problem is that XFS reserves the data required, and don't expect to get an
ENOSPC once the device "have space", and when the sync occurs, kaboom. I should
take a look again on it.


> [ 3005.331830] XFS (dm-6): Mounting V5 Filesystem
> [ 3005.443769] XFS (dm-6): Ending clean mount
> [ 5891.595901] device-mapper: thin: Data device (dm-3) discard unsupported:
> Disabling discard passdown.
> [ 5970.314062] device-mapper: thin: 253:4: reached low water mark for data
> device: sending event.
> [ 5970.358234] device-mapper: thin: 253:4: switching pool to
> out-of-data-space (error IO) mode
> [ 5970.358528] Buffer I/O error on dev dm-6, logical block 389248, lost
> async page write
> [ 5970.358546] Buffer I/O error on dev dm-6, logical block 389249, lost
> async page write
> async page write
> [ 5970.358577] Buffer I/O error on dev dm-6, logical block 389255, lost
> async page write
> [ 5970.358583] Buffer I/O error on dev dm-6, logical block 389256, lost
> async page write
> [ 5970.358594] Buffer I/O error on dev dm-6, logical block 389257, lost
> async page write
> 
> This appears as a "normal" I/O error, right? Or I am missing something?

Yeah, I don't remember exactly the details from this part of the problem, but
yes, looks like you are also hitting the problem I've been working on, which
basically makes XFS spinning indefinitely on xfsaild, trying to retry the
buffers which failed, but, can't because they are flush locked. It basically
have all data committed to AIL but can't flush them to their respective place
due lack of space, then, it you will keep seeing this message until it either
permanent fail the buffers, you expand the dm-pool or you unmount the
filesystem.

Currently, in all 3 cases, XFS can hang, unless you have set 'max_retries'
configuration to '0', before reproducing the problem.

Which kernel version are you using?

If you have the possibility, you can test my patches to fix this problem:

https://www.spinics.net/lists/linux-xfs/msg06986.html

It will certainly have a V3, but they shouldn't explode your system :) And more
testing are always welcomed.

With the patchset you will still get the errors, since the device will not have
the space XFS expects it to have, but the errors will simply go away as soon as
you extend the pool device allowing more space, or it will shut down the FS if
you try to unmount it, instead of hang the filesystem.

Cheers.

-- 
Carlos
