Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:45268 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730273AbeGSNHe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 09:07:34 -0400
Date: Thu, 19 Jul 2018 08:24:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/8] xfs: return from _defer_finish with a clean
 transaction
Message-ID: <20180719122436.GD25672@bfoster>
References: <153192902811.31685.11590100183112248407.stgit@magnolia>
 <153192904042.31685.60438652773989931.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153192904042.31685.60438652773989931.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wed, Jul 18, 2018 at 08:50:40AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Christoph Hellwig reported seeing the following assertion in
> generic/051:
> 
> XFS: Assertion failed: tp->t_firstblock == NULLFSBLOCK, file: fs/xfs/libxfs5
> ------------[ cut here ]------------
> kernel BUG at fs/xfs/xfs_message.c:102!
> invalid opcode: 0000 [#1] SMP PTI
> CPU: 2 PID: 20757 Comm: fsstress Not tainted 4.18.0-rc4+ #3969
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.1-1 04/01/4
> RIP: 0010:assfail+0x23/0x30
> Code: c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7 c6 88 e0 8c 82 48 89 fa
> RSP: 0018:ffff88012dc43c08 EFLAGS: 00010202
> RAX: 0000000000000000 RBX: ffff88012dc43ca0 RCX: 0000000000000000
> RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff828480eb
> RBP: ffff88012aa92758 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: f000000000000000 R12: 0000000000000000
> R13: ffff88012dc43d48 R14: ffff88013092e7e8 R15: 0000000000000014
> FS:  00007f8d689b8e80(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f8d689c7000 CR3: 000000012ba6a000 CR4: 00000000000006e0
> Call Trace:
>  xfs_defer_init+0xff/0x160
>  xfs_reflink_remap_extent+0x31b/0xa00
>  xfs_reflink_remap_blocks+0xec/0x4a0
>  xfs_reflink_remap_range+0x3a1/0x650
>  xfs_file_dedupe_range+0x39/0x50
>  vfs_dedupe_file_range+0x218/0x260
>  do_vfs_ioctl+0x262/0x6a0
>  ? __se_sys_newfstat+0x3c/0x60
>  ksys_ioctl+0x35/0x60
>  __x64_sys_ioctl+0x11/0x20
>  do_syscall_64+0x4b/0x190
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> The root cause of the assertion failure is that xfs_defer_finish doesn't
> roll the transaction after processing all the deferred items.  Therefore
> it returns a dirty transaction to the caller, which leaves the caller at
> risk of exceeding the transaction reservation if it logs more items.
> 
> Brian Foster's patchset to move the defer_ops firstblock into the
> transaction requires t_firstblock == NULLFSBLOCK upon defer_ops
> initialization, which is how this was noticed at all.
> 
> Reported-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

I was about ready to post the embedded dfops series but this reminds me
that this last roll should be optimized out in the xfs_defer_finish() ->
xfs_trans_commit() case. Technically a commit of a clean transaction
doesn't have to do anything, but that would at least avoid the
unnecessary regrant that occurs during the roll. Hmm, I may just post
the series as is for initial review and then tack on a patch for the
last bit later..

Brian

>  fs/xfs/libxfs/xfs_defer.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index c3e5bffda4f5..3ba8bb308c3c 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -424,6 +424,12 @@ xfs_defer_finish(
>  			cleanup_fn(*tp, state, error);
>  	}
>  
> +	/*
> +	 * Roll the transaction once more to avoid returning to the caller
> +	 * with a dirty transaction.
> +	 */
> +	if ((*tp)->t_flags & XFS_TRANS_DIRTY)
> +		error = xfs_defer_trans_roll(tp, dop);
>  out:
>  	(*tp)->t_agfl_dfops = orig_dop;
>  	if (error)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
