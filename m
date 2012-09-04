Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q84Km55J158796 for <xfs@oss.sgi.com>; Tue, 4 Sep 2012 15:48:05 -0500
Message-ID: <5046693A.9010102@sgi.com>
Date: Tue, 04 Sep 2012 15:48:58 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 07/13] xfs: xfs_sync_data is redundant.
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1346328017-2795-8-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/30/12 07:00, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> We don't do any data writeback from XFS any more - the VFS is
> completely responsible for that, including for freeze. We can
> replace the remaining caller with the VFS level function that
> achieves the same thing, but without conflicting with current
> writeback work - writeback_inodes_sb_if_idle().
>
> This means we can remove the flush_work and xfs_flush_inodes() - the
> VFS functionality completely replaces the internal flush queue for
> doing this writeback work in a separate context to avoid stack
> overruns..
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

I get a XFS hang on xfstest 205 - couple different machines:

# cat /proc/413/stack
[<ffffffff810fa889>] sleep_on_page+0x9/0x10
[<ffffffff810fa874>] __lock_page+0x64/0x70
[<ffffffff81104f58>] write_cache_pages+0x368/0x510
[<ffffffff8110514c>] generic_writepages+0x4c/0x70
[<ffffffffa046d084>] xfs_vm_writepages+0x54/0x70 [xfs]
[<ffffffff8110518b>] do_writepages+0x1b/0x40
[<ffffffff8117ad85>] __writeback_single_inode+0x45/0x160
[<ffffffff8117c0c7>] writeback_sb_inodes+0x2a7/0x490
[<ffffffff8117c539>] wb_writeback+0x119/0x2b0
[<ffffffff8117c7a4>] wb_do_writeback+0xd4/0x230
[<ffffffff8117c9db>] bdi_writeback_thread+0xdb/0x230
[<ffffffff810650be>] kthread+0x9e/0xb0
[<ffffffff81432dc4>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff

# cat /proc/12489/stack (dd command)
[<ffffffff8117b415>] writeback_inodes_sb_nr+0x85/0xb0
[<ffffffff8117b77c>] writeback_inodes_sb+0x5c/0x80
[<ffffffff8117b7e2>] writeback_inodes_sb_if_idle+0x42/0x60
[<ffffffffa047b54e>] xfs_iomap_write_delay+0x28e/0x320 [xfs]
[<ffffffffa046c738>] __xfs_get_blocks+0x2b8/0x500 [xfs]
[<ffffffffa046c9ac>] xfs_get_blocks+0xc/0x10 [xfs]
[<ffffffff811863df>] __block_write_begin+0x2af/0x5c0
[<ffffffffa046cfa1>] xfs_vm_write_begin+0x61/0xd0 [xfs]
[<ffffffff810f9c02>] generic_perform_write+0xc2/0x1e0
[<ffffffff810f9d80>] generic_file_buffered_write+0x60/0xa0
[<ffffffffa047454d>] xfs_file_buffered_aio_write+0x11d/0x1b0 [xfs]
[<ffffffffa04746f0>] xfs_file_aio_write+0x110/0x170 [xfs]
[<ffffffff811530e1>] do_sync_write+0xa1/0xf0
[<ffffffff811536eb>] vfs_write+0xcb/0x130
[<ffffffff81153840>] sys_write+0x50/0x90
[<ffffffff81431d39>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
