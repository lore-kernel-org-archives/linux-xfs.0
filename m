Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:13376 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727012AbeJEQ1E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 12:27:04 -0400
Date: Fri, 5 Oct 2018 19:29:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: delalloc and reflink fixes & tweaks V3
Message-ID: <20181005092906.GG12041@dastard>
References: <20181002174207.25275-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181002174207.25275-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 02, 2018 at 10:41:59AM -0700, Christoph Hellwig wrote:
> Hi all,
> 
> this series contains the basic reflink and delalloc fixups intended
> for 4.20.  All the bits that need more work are left out for now.
> 
> Changes since v2:
>   - add a new comment
>   - drop the patch to use unwritten extents for delalloc by default,
>     it didn't actually do what it was intended to do, because there
>     was no test to check for that, and actually changing that caused
>     a few regressions that need more time looking into
>   - add two new unwritten extent related cleanup patches
> 
> Changes since v1:
>   - drop various patches
>   - print the inode number for dangling delalloc extents

Something in this patchset causes generic/127 to corrupt the rmap
btree. 100% failure rate across all my test machines:

[  878.026760] run fstests generic/127 at 2018-10-05 17:31:13
[  888.752797] XFS: Assertion failed: fs_is_ok, file: fs/xfs/libxfs/xfs_rmap.c, line: 418
......
[  888.788156] Call Trace:
[  888.788683]  xfs_rmap_unmap+0x633/0x980
[  888.789461]  ? kmem_zone_alloc+0x61/0xe0
[  888.790245]  xfs_rmap_finish_one+0x2d0/0x340
[  888.791099]  xfs_trans_log_finish_rmap_update+0x2f/0x40
[  888.792146]  xfs_rmap_update_finish_item+0x2c/0x40
[  888.793093]  xfs_defer_finish_noroll+0x184/0x520
[  888.793996]  ? xfs_rmap_update_cancel_item+0x10/0x10
[  888.794965]  ? xfs_free_file_space+0x355/0x390
[  888.795850]  __xfs_trans_commit+0x189/0x370
[  888.796675]  xfs_free_file_space+0x355/0x390
[  888.797523]  xfs_file_fallocate+0x1b3/0x330
[  888.798356]  ? __sb_start_write+0x8d/0xc0
[  888.799153]  vfs_fallocate+0x13d/0x270
[  888.799908]  ksys_fallocate+0x3c/0x70
[  888.800634]  __x64_sys_fallocate+0x1a/0x20
[  888.801454]  do_syscall_64+0x5a/0x180
[  888.802186]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[

And the corruption is then tripped over again after reboot during
log recovery:

[  133.805375] XFS (sdb): Mounting V5 Filesystem
[  134.067122] XFS (sdb): Starting recovery (logdev: internal)
[  134.228779] XFS: Assertion failed: fs_is_ok, file: fs/xfs/libxfs/xfs_rmap.c, line: 545
.....
[  134.253087] Call Trace:
[  134.253630]  xfs_rmap_unmap+0x467/0x980
[  134.254363]  ? kmem_zone_alloc+0x61/0xe0
[  134.255108]  xfs_rmap_finish_one+0x2d0/0x340
[  134.255914]  xfs_trans_log_finish_rmap_update+0x2f/0x40
[  134.256899]  xfs_rui_recover+0x211/0x2d0
[  134.257667]  xlog_recover_process_rui+0x3c/0x60
[  134.258521]  ? xfs_trans_ail_cursor_first+0x17/0x80
[  134.259427]  xlog_recover_process_intents+0x283/0x310
[  134.260374]  ? xfs_iget+0x514/0xad0
[  134.261033]  ? xlog_recover_finish+0x18/0xa0
[  134.261864]  xlog_recover_finish+0x18/0xa0
[  134.262640]  xfs_log_mount_finish+0x6f/0x110
[  134.263430]  xfs_mountfs+0x66f/0x8e0
[  134.264096]  ? xfs_mru_cache_create+0x15a/0x1b0
[  134.264937]  xfs_fs_fill_super+0x4a5/0x650
[  134.265737]  ? xfs_test_remount_options+0x60/0x60
[  134.266625]  mount_bdev+0x174/0x1b0
[  134.267288]  mount_fs+0x30/0x150
[  134.267856]  vfs_kern_mount.part.30+0x54/0x120
[  134.268686]  do_mount+0x5dd/0xc90
[  134.269344]  ? memdup_user+0x3e/0x70
[  134.270491]  ksys_mount+0x80/0xd0
[  134.271555]  __x64_sys_mount+0x21/0x30
[  134.272739]  do_syscall_64+0x5a/0x180
[  134.273459]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
