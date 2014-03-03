Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 24F827F58
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 16:53:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A6699AC002
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 14:53:51 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	d8VunlU4Ia4rVhOb for <xfs@oss.sgi.com>;
	Mon, 03 Mar 2014 14:53:49 -0800 (PST)
Date: Tue, 4 Mar 2014 09:53:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: rebuilt HW RAID60 array; XFS filesystem looks bad now
Message-ID: <20140303225344.GM13647@dastard>
References: <5314EE97.3020004@uga.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5314EE97.3020004@uga.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Paul Brunk <pbrunk@uga.edu>
Cc: xfs@oss.sgi.com

On Mon, Mar 03, 2014 at 04:05:27PM -0500, Paul Brunk wrote:
> Hi:
> 
> Short version: XFS filesystem on HW RAID60 array.  Array has been
> multiply rebuilt due to drive insertions.  XFS filesystem damaged and
> trying to salvage what I can, and I want to make sure I have no option
> other than "xfs_repair -L".  Details follow.
> 
> # uname -a
> Linux rccstor7.local 2.6.32-431.5.1.el6.x86_64 #1 SMP Wed Feb 12
> 00:41:43 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
> 
> xfs_repair version 3.1.1.  The box has one 4-core Opteron CPU and 8
> GB of RAM.
> 
> I have a 32TB HW RAID60 volume (Areca 1680 HW RAID) made of two RAID6
> raid sets.

Hmmm - yet another horror story from someone using an Areca HW RAID
controller. I'm starting to wonder if we should be putting an entry
in the FAQ saying "don't use Areca RAID controllers if you value
your data"...

[snip]

>  # mount /media/shares
>  mount: wrong fs type, bad option, bad superblock on /dev/mapper/vg0-lv0,
>         missing codepage or helper program, or other error
>         In some cases useful info is found in syslog - try
>         dmesg | tail  or so
> 
>  # dmesg|tail
>  XFS (dm-2): Mounting Filesystem
>  XFS (dm-2): Log inconsistent or not a log (last==0, first!=1)
>  XFS (dm-2): empty log check failed
>  XFS (dm-2): log mount/recovery failed: error 22
>  XFS (dm-2): log mount failed

That's bad. The log does not contain a valid header in it's first
block.

>  # xfs_repair -n /dev/dm-2
>  produced at least 7863 lines of output.   It begins
> 
>  Phase 1 - find and verify superblock...
>  Phase 2 - using internal log
>          - scan filesystem freespace and inode maps...
>  bad magic # 0xa04850d in btbno block 0/108
>  expected level 0 got 10510 in btbno block 0/108
>  bad btree nrecs (144, min=255, max=510) in btbno block 0/108

Corrupted freespace btree blocks.

>  block (0,80-80) multiply claimed by bno space tree, state - 2
>  block (0,108-108) multiply claimed by bno space tree, state - 7

with duplicate entries in them. That's not a good sign...

> 
>  # egrep -c "invalid start block" xfsrepair.out
>  2061
>  # egrep -c "multiply claimed by bno" xfsrepair.out
>  4753
> 
>  Included in the output are 381 occurrences of this pair of messages:
> 
>  bad starting inode # (0 (0x0 0x0)) in ino rec, skipping rec
>  badly aligned inode rec (starting inode = 0)

Ok, so the inode btree is also full of corrupt blocks.

> Is there anything I should try prior to xfs_repair -L?

Pray? Basically, then primary metadata in the filesystem that tracks
allocated space and inodes looks to be badly corrupted. If the
metadata is corrupted like this from the rebuild, then the rest of
the block device is likely to be busted up just as badly. So you
might be able to recover some of the filesysetm structure with XFS
repair, but all your data is going to be just as corrupted.

I'd be using metadump like Eric suggested to create a test image to
see what filesystem structure you'll end up with after running
repair. But with the corrupt AG btrees, there's a good chance even
metadump won't be able to run successfully on the filesystem. And
even that won't tell you how badly damaged the data is, just what
data you will have access to after running repair.

> I'm just trying to salvage whatever I can from this FS.  I'm aware it
> could be all gone.  Thanks.

Good luck :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
