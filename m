Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:10170 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751947AbcK0WOg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Nov 2016 17:14:36 -0500
Date: Mon, 28 Nov 2016 09:14:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Slow file stat/deletion
Message-ID: <20161127221433.GV28177@dastard>
References: <bef58272-f791-52bf-cc4c-1cb1b7c9efec@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bef58272-f791-52bf-cc4c-1cb1b7c9efec@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Fri, Nov 25, 2016 at 11:40:40AM +0100, Gionatan Danti wrote:
> Hi all,
> I am using a XFS filesystem as a target for rsnapshot hardlink-based
> backups.
> 
> Being hardlink-based, our backups generally are quite fast. However,
> I noticed that for some directories having many small files the
> longer part of the backup process is to remove the old
> (out-of-retention) subdirs that must be purged to make room for the
> new backup iteration.

Ah, hard link farms. aka "How to fragment the AGI btrees for fun and
profit."

> Further analysis show that the slower part of the 'rm' process is
> the reading of the affected inodes/dentries. An example: to remove a
> subdir with ~700000 files and directories, the system needs about 30
> minutes. At the same time, issuing a simple "find <dir> / | wc -l"
> (after having dropped the caches) need ~24 minutes. In other words,
> actual reads need 4x the real delete time.
> 
> So, my question is: there is anything I can do to speedup the
> read/stat/deletion?

Not now. Speed is a factor of the inode layout and seek times. Find
relies on sequential directory access which is sped up on XFS by
internal btree readahead and it doesn't require reading the extent
list. rm processes inodes one at a time and requires reading of the
extent list so per-inode there is more IO, a lot more CPU time spent
and more per-op latency, so it's no surprise it's much slower than
find.

> 
> Here is my system config:
> CPU: AMD Opteron(tm) Processor 4334
> RAM: 16 GB
> HDD: 12x 2TB WD RE in a RAID6 array (64k stripe unit), attached to a
> PERC H700 controller with 512MB BBU writeback cache
> OS:  CentOS 7.2 x86_64 with 3.10.0-327.18.2.el7.x86_64 kernel
> 
> Relevant LVM setup:
> LV           VG         Attr       LSize  Pool         Origin Data%
> Meta%  Move Log Cpy%Sync Convert Chunk
> 000-ThinPool vg_storage twi-aotz-- 10,85t                     86,71
> 38,53                            8,00m
> Storage      vg_storage Vwi-aotz-- 10,80t 000-ThinPool        87,12
> 0
> 
> XFS filesystem info:
> meta-data=/dev/mapper/vg_storage-Storage isize=512    agcount=32,
> agsize=90596992 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=0        finobt=0

finobt=0.

finobt was added primarily to solve inode allocation age-related
degradation for hard link farm style workloads. It will have
significant impact on unlink as well, because initial inode
allocation patterns will be better...

> Some consideration:
> 1) I am using a single big thin volume because back in the time ( >2
> years ago) I was not sure about XFS and, having no shrinking
> capability, I relayed on thin volume unmap should the filesystem
> choice change. However, thin pool's chunk size is quite big (8 MB)
> so it should not pose acute fragmentation problem;

Nope, but it means that what should be sequential IO is probably
going to be random. i.e. instead of directory/inode/extent reading
IO having minimum track-track seek latency because they are all
nearby (1-2ms), they'll be average seeks (6-7ms) because locality is no
longer as the filesystem has optimised for.

> 
> 2) due to being layered over a thinly provided volume, the
> filesystem was created with "noalign" option.

noalign affects data placement only, and only for filesystems that
have a stripe unit/width set, which yours doesn't:

>			sunit=0      swidth=0 blks

> I run some in-the-lab
> test on a spare machine and I (still) find that this option seems to
> *lower* the time needed to stat/delete files when XFS is on top of a
> thin volume, so I do not think this is a problem. I'm right?

It's not a problem because it doesn't do anything with your fs
config.

> 3) the filesystem is over 2 years old and has a very big number of
> files on it (inode count is 12588595, but each inode has multiple
> hardlinked files). Is this slow delete performance a side effect of
> "aging" ?

Yes. Made worse by being on a thinp volume.


> 4) I have not changed the default read-ahead value (256 KB). I know
> this is quite small compared to available disk resources but, before
> messing with low-level block device tuning, I would really like to
> know your opinion on my case.

Only used for data readahead. Will make no difference to
directory/stat/unlink performance.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
