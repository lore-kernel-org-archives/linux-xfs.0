Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:40738 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726409AbeJFQhM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 12:37:12 -0400
Date: Sat, 6 Oct 2018 19:34:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/8] xfs: remove magic handling of unwritten extents in
 xfs_bmapi_allocate
Message-ID: <20181006093433.GA18095@dastard>
References: <20181002174207.25275-1-hch@lst.de>
 <20181002174207.25275-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181002174207.25275-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 02, 2018 at 10:42:02AM -0700, Christoph Hellwig wrote:
> There is no real need to treat unwritten delalloc extent special in
> any way here, so remove the special casing and related comment.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index da6b768664e3..3bb250ee6c7c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4069,20 +4069,10 @@ xfs_bmapi_allocate(
>  	bma->got.br_startoff = bma->offset;
>  	bma->got.br_startblock = bma->blkno;
>  	bma->got.br_blockcount = bma->length;
> -	bma->got.br_state = XFS_EXT_NORM;
> -
> -	/*
> -	 * In the data fork, a wasdelay extent has been initialized, so
> -	 * shouldn't be flagged as unwritten.
> -	 *
> -	 * For the cow fork, however, we convert delalloc reservations
> -	 * (extents allocated for speculative preallocation) to
> -	 * allocated unwritten extents, and only convert the unwritten
> -	 * extents to real extents when we're about to write the data.
> -	 */
> -	if ((!bma->wasdel || (bma->flags & XFS_BMAPI_COWFORK)) &&
> -	    (bma->flags & XFS_BMAPI_PREALLOC))
> +	if (bma->flags & XFS_BMAPI_PREALLOC)
>  		bma->got.br_state = XFS_EXT_UNWRITTEN;
> +	else
> +		bma->got.br_state = XFS_EXT_NORM;

I bisected the generic/127 rmap corruption down to this patch:

[   36.523002] run fstests generic/127 at 2018-10-06 19:25:42
[   48.642735] XFS: Assertion failed: fs_is_ok, file: fs/xfs/libxfs/xfs_rmap.c, line: 418
[   48.647380] ------------ [ cut here ]------------
[   48.648322] kernel BUG at fs/xfs/xfs_message.c:102!
[   48.649347] invalid opcode: 0000
[#1] PREEMPT SMP
[   48.650303] CPU: 9 PID: 4468 Comm: fsx Not tainted 4.19.0-rc6-dgc+ #681
[   48.651874] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.1-1 04/01/2014
[   48.653562] RIP: 0010:assfail+0x28/0x30
[   48.654332] Code: c3 90 66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6 70 56 2e 82 48 89 fa 31 ff e8 64 f9 ff ff 80 3d 75 9f 0a 01 00 75 03 0f 0b c3 <0f> 0b 66 0f 1f 44 00 00 66 66 66 66 90 48 63 f6 49 89a
[   48.657980] RSP: 0018:ffffc900049a7b18 EFLAGS: 00010202
[   48.659015] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   48.660423] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff8227ab34
[   48.661817] RBP: ffffc900049a7c38 R08: 0000000000000000 R09: 0000000000000000
[   48.663209] R10: 00000000000000c0 R11: f000000000000000 R12: 00000000000000c0
[   48.664634] R13: 0000000000000004 R14: ffff880239789d20 R15: 0000000000000000
[   48.666033] FS:  00007fb5eed1db80(0000) GS:ffff88023fd00000(0000) knlGS:0000000000000000
[   48.667608] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   48.668752] CR2: 00007f5ce9a0e8e0 CR3: 0000000238f5c001 CR4: 0000000000060ee0
[   48.670168] Call Trace:
[   48.671250]  xfs_rmap_unmap+0x633/0x980
[   48.672037]  ? kmem_zone_alloc+0x61/0xe0
[   48.672842]  xfs_rmap_finish_one+0x2d0/0x340
[   48.673692]  xfs_trans_log_finish_rmap_update+0x2f/0x40
[   48.674737]  xfs_rmap_update_finish_item+0x2c/0x40
[   48.675710]  xfs_defer_finish_noroll+0x184/0x520
[   48.676614]  ? xfs_rmap_update_cancel_item+0x10/0x10
[   48.677615]  ? xfs_free_file_space+0x355/0x390
[   48.678512]  __xfs_trans_commit+0x189/0x370
[   48.679360]  xfs_free_file_space+0x355/0x390
[   48.680227]  xfs_file_fallocate+0x1b3/0x330
[   48.681077]  ? __sb_start_write+0x8d/0xc0
[   48.681889]  vfs_fallocate+0x13d/0x270
[   48.682637]  ksys_fallocate+0x3c/0x70
[   48.683382]  __x64_sys_fallocate+0x1a/0x20
[   48.684208]  do_syscall_64+0x5a/0x180
[   48.684953]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The corruption check that is failing is this:

        /* Make sure the unwritten flag matches. */
	XFS_WANT_CORRUPTED_GOTO(mp, (flags & XFS_RMAP_UNWRITTEN) ==
			(rec->rm_flags & XFS_RMAP_UNWRITTEN), out);

So this patch does not appear to be doing the right thing with
unwritten extent flagging in some case.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
