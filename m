Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:5010 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750946AbeC1XhA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Mar 2018 19:37:00 -0400
Date: Thu, 29 Mar 2018 10:36:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/3] fstests: generic: Check the fs after each FUA
 writes
Message-ID: <20180328233657.GD1150@dastard>
References: <20180328044023.22078-1-wqu@suse.com>
 <20180328044023.22078-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180328044023.22078-3-wqu@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, amir73il@gmail.com, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, Mar 28, 2018 at 12:40:23PM +0800, Qu Wenruo wrote:
> Basic test case which triggers fsstress with dm-log-writes, and then
> check the fs after each FUA writes.
> With needed infrastructure and special handlers for journal based fs.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
.....
> For xfs:
> _check_xfs_filesystem: filesystem on /dev/mapper/test-scratch1 is inconsistent (r)
> *** xfs_repair -n output ***
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
> bad symlink header ino 8409190, file block 0, disk block 1051147
> problem with symbolic link in inode 8409190
> would have cleared inode 8409190
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 3
>         - agno = 2
> entry "lb" in shortform directory 8409188 references free inode 8409190
> would have junked entry "lb" in directory inode 8409188
> bad symlink header ino 8409190, file block 0, disk block 1051147
> problem with symbolic link in inode 8409190
> would have cleared inode 8409190
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
> entry "lb" in shortform directory inode 8409188 points to free inode 8409190
> would junk entry
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify link counts...
> Maximum metadata LSN (1:396) is ahead of log (1:63).

That warning implies a write ordering problem - there's a write with
an LSN on disk that does not yet exist in the log. i.e. the last FUA
write to the log had 1:63 in it, yet there's metadata on disk that
could only be *issued* after a REQ_FLUSH|REQ_FUA log write with
1:396 in it was *completed*. If we've only replayed up to the
FUA write with 1:63 in it, then no metadata writes should have been
*issued* with 1:396 in it as the LSN that is stamped into metadata
is only updated on log IO completion....

On first glance, this implies a bug in the underlying device write
replay code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
