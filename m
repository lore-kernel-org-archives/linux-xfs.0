Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0SEplWo161321 for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 08:51:47 -0600
Subject: Re: [PATCH 2/8] xfs: fix efi item leak on forced shutdown
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1296100401-17135-3-git-send-email-david@fromorbit.com>
References: <1296100401-17135-1-git-send-email-david@fromorbit.com>
	<1296100401-17135-3-git-send-email-david@fromorbit.com>
Date: Fri, 28 Jan 2011 08:54:10 -0600
Message-ID: <1296226450.2342.5.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, 2011-01-27 at 14:53 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> After test 139, kmemleak shows:
> 
> unreferenced object 0xffff880078b405d8 (size 400):
>   comm "xfs_io", pid 4904, jiffies 4294909383 (age 1186.728s)
>   hex dump (first 32 bytes):
>     60 c1 17 79 00 88 ff ff 60 c1 17 79 00 88 ff ff  `..y....`..y....
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff81afb04d>] kmemleak_alloc+0x2d/0x60
>     [<ffffffff8115c6cf>] kmem_cache_alloc+0x13f/0x2b0
>     [<ffffffff814aaa97>] kmem_zone_alloc+0x77/0xf0
>     [<ffffffff814aab2e>] kmem_zone_zalloc+0x1e/0x50
>     [<ffffffff8147cd6b>] xfs_efi_init+0x4b/0xb0
>     [<ffffffff814a4ee8>] xfs_trans_get_efi+0x58/0x90
>     [<ffffffff81455fab>] xfs_bmap_finish+0x8b/0x1d0
>     [<ffffffff814851b4>] xfs_itruncate_finish+0x2c4/0x5d0
>     [<ffffffff814a970f>] xfs_setattr+0x8df/0xa70
>     [<ffffffff814b5c7b>] xfs_vn_setattr+0x1b/0x20
>     [<ffffffff8117dc00>] notify_change+0x170/0x2e0
>     [<ffffffff81163bf6>] do_truncate+0x66/0xa0
>     [<ffffffff81163d0b>] sys_ftruncate+0xdb/0xe0
>     [<ffffffff8103a002>] system_call_fastpath+0x16/0x1b
>     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> The cause of the leak is that the "remove" parameter of IOP_UNPIN()
> is never set when a CIL push is aborted. This means that the EFI
> item is never freed if it was in the push being cancelled. The
> problem is specific to delayed logging, but has uncovered a couple
> of problems with the handling of IOP_UNPIN(remove).
> 
> Firstly, we cannot safely call xfs_trans_del_item() from IOP_UNPIN()
> in the CIL commit failure path or the iclog write failure path
> because for delayed loging we have no transaction context. Hence we
> must only call xfs_trans_del_item() if the log item being unpinned
> has an active log item descriptor.
> 
> Secondly, xfs_trans_uncommit() does not handle log item descriptor
> freeing during the traversal of log items on a transaction. It can
> reference a freed log item descriptor when unpinning an EFI item.
> Hence it needs to use a safe list traversal method to allow items to
> be removed from the transaction during IOP_UNPIN().
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

OK, this looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
