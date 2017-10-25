Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:45003 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751668AbdJYV36 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2017 17:29:58 -0400
Date: Thu, 26 Oct 2017 08:29:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Possible to mount this XFS at least temporarily to retrieve
 files?
Message-ID: <20171025212955.GZ3666@dastard>
References: <dd004707-cd48-adb8-1429-37867360594e@aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd004707-cd48-adb8-1429-37867360594e@aei.mpg.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 25, 2017 at 09:20:03AM +0200, Carsten Aulbert wrote:
> Hi
> 
> after some hiatus, back on this list with an incident which happened
> yesterday:
> 
> On a Debian Jessie machine installed back in October 2016 there a re a
> bunch of 3TB disks behind an Adaptec ASR-6405[1] in RAID6 configuration.
> Yesterday, one of the disks failed and was subsequently replace. About
> an hour into the rebuild the 28TB xfs on this block device gave up:
> 
> Oct 24 12:39:15 atlas8 kernel: [526440.956408] XFS (sdc1):
> xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.
> Oct 24 12:39:15 atlas8 kernel: [526440.956452] XFS (sdc1):
> xfs_do_force_shutdown(0x8) called from line 3242 of file
> /build/linux-byISom/linux-3.16.43/fs/xfs/xfs_inode.c.  Return address =
> 0xffffffffa02c0b76
> Oct 24 12:39:45 atlas8 kernel: [526471.029957] XFS (sdc1):
> xfs_log_force: error 5 returned.
> Oct 24 12:40:15 atlas8 kernel: [526501.154991] XFS (sdc1):
> xfs_log_force: error 5 returned.

That's a pretty good indication that th rebuild has gone
catastrophically wrong....

[....]

> Another shot in the dark was rebooting the system with a more recent
> kernel, this time 4.9.30-2+deb9u5~bpo8+1 instead of 3.16.43-2+deb8u5
> which indeed changed the behaviour of xfs_repair:
> 
> # xfs_repair /dev/sdc1
> Phase 1 - find and verify superblock...
> sb root inode value 18446744073709551615 (NULLFSINO) inconsistent with
> calculated value 128

Which tends to indicate it found a secondary superblock in the place
of the primary superblock.....

> Phase 2 - using internal log
>         - zero log...
> Log inconsistent (didn't find previous header)
> failed to find log head
> zero_log: cannot find log head/tail (xlog_find_tail=5)

And the log isn't where it's supposed to be. 

> Some more "random" output:
> 
> # xfs_db -r -c "sb 0" -c "p" -c "freesp" /dev/sdc1

[...]

> rootino = null
> rbmino = null
> rsumino = null

These null inode pointers, and

[...]

> icount = 0
> ifree = 0
> fdblocks = 7313292427

this (inode counts zero and free blocks at 28TB) indicate we're
looking at a secondary superblock as written by mkfs.

This is a pretty good indication that the RAID rebuild has
completely jumbled up the disks and the data on the disks during
the rebuild.

> Now my "final" question: Is there a chance to get some/most files from
> this hosed file system or am I just wasting my time[2]?

It's a hardware raid controller that is having hardware problems
during a rebuild.  I'd say your filesystem is completely screwed
because the rebuild went wrong and you have no way of knowing what
blocks are good and what aren't, nor even whether the RAID has been
assembled correctly after the failure. Hence even if you could mount
it, the data in the files is likely to be corrupt/incorrect
anyway...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
