Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56712 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031788AbdEWVd7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 May 2017 17:33:59 -0400
Subject: Re: Shutdown filesystem when a thin pool become full
References: <c25a8ccc-f143-989d-3d49-3fe8753aa6f7@assyoma.it>
 <20170522230946.s3sdg4gd73oj7r5u@eorzea.usersys.redhat.com>
 <940c3b13-dea2-1887-d4ae-89555d1c2a4f@assyoma.it>
 <5f98a296-6023-f200-4c60-bcfdf0288d34@assyoma.it>
 <20170523122753.k7plzg3musc4up73@eorzea.usersys.redhat.com>
 <24daa89a452496d2cdffa5512a64ed2e@assyoma.it>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6b665d39-7bc4-9160-4c3a-d5b9c9994b01@sandeen.net>
Date: Tue, 23 May 2017 16:33:57 -0500
MIME-Version: 1.0
In-Reply-To: <24daa89a452496d2cdffa5512a64ed2e@assyoma.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>, linux-xfs@vger.kernel.org

On 5/23/17 3:05 PM, Gionatan Danti wrote:
> Il 23-05-2017 14:27 Carlos Maiolino ha scritto:
>>
>> Aha, you are using sync flag, that's why you are getting IO errors instead of
>> ENOSPC, I don't remember from the top of my mind why exactly, it's been a while
>> since I started to work on this XFS and dm-thin integration, but IIRC, the
>> problem is that XFS reserves the data required, and don't expect to get an
>> ENOSPC once the device "have space", and when the sync occurs, kaboom. I should
>> take a look again on it.
> 
> Ok, I tried with a more typical non-sync write and it seems to report ENOSPC:
> 
> [root@blackhole ~]# dd if=/dev/zero of=/mnt/storage/disk.img bs=1M count=2048
> dd: error writing ‘/mnt/storage/disk.img’: No space left on device
> 2002+0 records in
> 2001+0 records out
> 2098917376 bytes (2.1 GB) copied, 7.88216 s, 266 MB/s
> 
> With /sys/fs/xfs/dm-6/error/metadata/ENOSPC/max_retries = -1 (default), I have the following dmesg output:
> 
> [root@blackhole ~]# dmesg
> [23152.667198] XFS (dm-6): Mounting V5 Filesystem
> [23152.762711] XFS (dm-6): Ending clean mount
> [23192.704672] device-mapper: thin: 253:4: reached low water mark for data device: sending event.
> [23192.988356] device-mapper: thin: 253:4: switching pool to out-of-data-space (error IO) mode
> [23193.046288] Buffer I/O error on dev dm-6, logical block 385299, lost async page write
> [23193.046299] Buffer I/O error on dev dm-6, logical block 385300, lost async page write
> [23193.046302] Buffer I/O error on dev dm-6, logical block 385301, lost async page write
> [23193.046304] Buffer I/O error on dev dm-6, logical block 385302, lost async page write
> [23193.046307] Buffer I/O error on dev dm-6, logical block 385303, lost async page write
> [23193.046309] Buffer I/O error on dev dm-6, logical block 385304, lost async page write
> [23193.046312] Buffer I/O error on dev dm-6, logical block 385305, lost async page write
> [23193.046314] Buffer I/O error on dev dm-6, logical block 385306, lost async page write
> [23193.046316] Buffer I/O error on dev dm-6, logical block 385307, lost async page write
> [23193.046319] Buffer I/O error on dev dm-6, logical block 385308, lost async page write
> 
> With /sys/fs/xfs/dm-6/error/metadata/ENOSPC/max_retries = 0, dmesg output is slightly different:


Try setting EIO rather than ENOSPC.

> 
> [root@blackhole default]# dmesg
> [23557.594502] device-mapper: thin: 253:4: switching pool to out-of-data-space (error IO) mode
> [23557.649772] buffer_io_error: 257430 callbacks suppressed
> [23557.649784] Buffer I/O error on dev dm-6, logical block 381193, lost async page write
> [23557.649805] Buffer I/O error on dev dm-6, logical block 381194, lost async page write
> [23557.649811] Buffer I/O error on dev dm-6, logical block 381195, lost async page write
> [23557.649818] Buffer I/O error on dev dm-6, logical block 381196, lost async page write
> [23557.649862] Buffer I/O error on dev dm-6, logical block 381197, lost async page write
> [23557.649871] Buffer I/O error on dev dm-6, logical block 381198, lost async page write
> [23557.649880] Buffer I/O error on dev dm-6, logical block 381199, lost async page write
> [23557.649888] Buffer I/O error on dev dm-6, logical block 381200, lost async page write
> [23557.649897] Buffer I/O error on dev dm-6, logical block 381201, lost async page write
> [23557.649903] Buffer I/O error on dev dm-6, logical block 381202, lost async page write
> 
> Notice the suppressed buffer_io_error entries: are they related to the bug you linked before?
> Anyway, in *no* cases I had a filesystem shutdown on these errors.

Yep, that's "just" data IO.

> Trying to be pragmatic, my main concern is to avoid extended filesystem and/or data corruption in the case a thin pool become inadvertently full. For example, with ext4 I can mount the filesystem with "errors=remount-ro,data=journaled" and *any* filesystem error (due to thinpool or other problems) will put the filesystem in a read-only state, avoiding significan damages.
> 
> If, and how, I can replicate this behavior with XFS? From my understanding, XFS does not have a "remount read-only" mode. Moreover, until its metadata can be safely stored on disk (ie: they hit already allocated space), it seems to happily continue to run, disregarding data writeout problem/error. As a note, ext4 without "data=jornaled" bahave quite similarly, whit a read-only remount happening on metadata errors only.
> 
> Surely I am missing something... right?

Even if you run out of space, xfs should not become corrupted.
You may need to add space to successfully replay the log afterward,
but if you do, it should replay and everyhthing should be consistent
(which is not the same as "no data was lost") - is that not the case?

As for xfs happily running with metadata errors, the tunable error behavior
should make it stop more quickly, at least if you set it for EIO.
It usually will eventually stop when it hits what it considers a critical
metadata IO error...

-Eric

> Thanks.
> 
