Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59240 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752426AbdFONOi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Jun 2017 09:14:38 -0400
Date: Thu, 15 Jun 2017 15:14:34 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Shutdown filesystem when a thin pool become full
Message-ID: <20170615131433.n33sqvyes4fhcbye@eorzea.usersys.redhat.com>
References: <c25a8ccc-f143-989d-3d49-3fe8753aa6f7@assyoma.it>
 <20170522230946.s3sdg4gd73oj7r5u@eorzea.usersys.redhat.com>
 <940c3b13-dea2-1887-d4ae-89555d1c2a4f@assyoma.it>
 <5f98a296-6023-f200-4c60-bcfdf0288d34@assyoma.it>
 <20170523122753.k7plzg3musc4up73@eorzea.usersys.redhat.com>
 <24daa89a452496d2cdffa5512a64ed2e@assyoma.it>
 <7e8e16f1-5425-44b3-e908-c0e8a3300e3f@assyoma.it>
 <a89aa00c4f86fbdc674dd8f5b5eeb248@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a89aa00c4f86fbdc674dd8f5b5eeb248@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

Hi,

> > > Ok, I tried with a more typical non-sync write and it seems to
> > > report ENOSPC:
> > > 
> > > [root@blackhole ~]# dd if=/dev/zero of=/mnt/storage/disk.img bs=1M
> > > count=2048
> > > dd: error writing ‘/mnt/storage/disk.img’: No space left on device
> > > 2002+0 records in
> > > 2001+0 records out
> > > 2098917376 bytes (2.1 GB) copied, 7.88216 s, 266 MB/s
> > > 
> > 
> > # thin pool switched to out-of-space mode
> > [root@blackhole mnt]# dmesg
> > [ 4408.257419] XFS (dm-8): Mounting V5 Filesystem
> > [ 4408.368891] XFS (dm-8): Ending clean mount
> > [ 4460.147962] device-mapper: thin: 253:6: switching pool to
> > out-of-data-space (error IO) mode
> > [ 4460.218484] buffer_io_error: 199623 callbacks suppressed
> > [ 4460.218497] Buffer I/O error on dev dm-8, logical block 86032, lost
> > async page write
> > 
.
.
.
> > # write another 400M - they should *not* be allowed to complete without
> > errors
> > [root@blackhole mnt]# dd if=/dev/zero of=/mnt/thinvol/disk2.img bs=1M
> > count=400
> > 400+0 records in
> > 400+0 records out
> > 419430400 bytes (419 MB) copied, 0.36643 s, 1.1 GB/s
> > 
> > # no errors reported! give a look at dmesg
> > 
> > [root@blackhole mnt]# dmesg
> > [ 4603.649156] buffer_io_error: 44890 callbacks suppressed
> > [ 4603.649163] Buffer I/O error on dev dm-8, logical block 163776,
> > lost async page write
> > [ 4603.649172] Buffer I/O error on dev dm-8, logical block 163777,
> > # current filesystem use
> > [root@blackhole mnt]# df -h | grep thin
> > /dev/mapper/vg_kvm-thinvol 1021M  833M  189M  82% /mnt/thinvol
> 

> Hi all,
> any suggestion regarding the issue?
> 
> Regards.
> 

Unfortunately, there isn't much a filesystem can do here. I'll need to talk with
device-mapper folks to get a better understanding how we can handle such cases,
if possible at all.

The problem you are seeing there is because of buffered writes, you don't get a
ENOSPC because the device itself virtually still has space to be allocated, so
the lack of space is only visible when the blocks are really being allocated
from the POOL itself, but still, there isn't much a filesystem can do here
regarding buffered writes.

As you noticed, XFS will report errors regarding the problems to write metadata
to the device, but again, user data, is up to the application to ensure the data
is consistent, although I think I actually found a problem with it while doing
some tests as you mentioned, I'll need to look deeper into them.
 

-- 
Carlos
