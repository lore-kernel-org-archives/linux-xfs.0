Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:64244 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751190AbcIUFII (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Sep 2016 01:08:08 -0400
Date: Wed, 21 Sep 2016 15:08:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs/032 find xfs corruption
Message-ID: <20160921050804.GM340@dastard>
References: <20160921042318.GR12847@dhcp12-143.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160921042318.GR12847@dhcp12-143.nay.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Sep 21, 2016 at 12:23:18PM +0800, Zorro Lang wrote:
> Hi,
> 
> xfs/032 trigger xfs(v4/v5) corruption after run it several times:
> [root@dhcp-13-149 xfstests-dev]# xfs_repair -n ~/xfs-032.img 
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> sb_icount 64, counted 256
> sb_ifree 61, counted 242
> sb_fdblocks 1038280, counted 1035431
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
> entry "d8" in shortform directory 1572896 references free inode 38
> would have junked entry "d8" in directory inode 1572896
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
> entry "d8" in shortform directory inode 1572896 points to free inode 38
> would junk entry
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> disconnected dir inode 524320, would move to lost+found
> Phase 7 - verify link counts...
> would have reset inode 1069090 nlinks from 2 to 1
> would have reset inode 1572896 nlinks from 4 to 3
> No modify flag set, skipping filesystem flush and exiting.

So, is the log dirty? if so, does mount/unmounting the filesystem
get rid of all the problems? When the image file check fails, does
an xfs_repair on the scratch device also fail, or is xfs_copy
failing to copy the filesystem cleanly for some reason?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
