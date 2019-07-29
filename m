Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47606 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387450AbfG2LXj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Jul 2019 07:23:39 -0400
Date: Mon, 29 Jul 2019 07:23:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs: garbage file data inclusion bug under memory pressure
Message-ID: <20190729112335.GA23942@bfoster>
References: <804d24cb-5b7c-4620-5a5f-4ec039472086@i-love.sakura.ne.jp>
 <20190725220726.GW7689@dread.disaster.area>
 <201907290350.x6T3oBpj009459@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201907290350.x6T3oBpj009459@www262.sakura.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Mon, Jul 29, 2019 at 12:50:11PM +0900, Tetsuo Handa wrote:
> Dave Chinner wrote:
> > > > But I have to ask: what is causing the IO to fail? OOM conditions
> > > > should not cause writeback errors - XFS will retry memory
> > > > allocations until they succeed, and the block layer is supposed to
> > > > be resilient against memory shortages, too. Hence I'd be interested
> > > > to know what is actually failing here...
> > > 
> > > Yeah. It is strange that this problem occurs when close-to-OOM.
> > > But no failure messages at all (except OOM killer messages and writeback
> > > error messages).
> > 
> > Perhaps using things like trace_kmalloc and friends to isolate the
> > location of memory allocation failures would help....
> > 
> 
> I checked using below diff, and confirmed that XFS writeback failure is triggered by ENOMEM.
> 
> When fsync() is called, xfs_submit_ioend() is called. xfs_submit_ioend() invokes
> xfs_setfilesize_trans_alloc(), but xfs_trans_alloc() fails with -ENOMEM because
> xfs_log_reserve() from xfs_trans_reserve() fails with -ENOMEM because
> xlog_ticket_alloc() is using KM_SLEEP | KM_MAYFAIL which is mapped to
> GFP_NOFS|__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_COMP which will fail under close-to-OOM.
> 
> As a result, bio_endio() is immediately called due to -ENOMEM, and
> xfs_destroy_ioend() from xfs_end_bio() from bio_endio() is printing
> writeback error message due to -ENOMEM error.
> (By the way, why not to print error code when printing writeback error message?)
> 
> ----------------------------------------

Ah, that makes sense. Thanks for tracking that down Tetsuo. For context,
it looks like that flag goes back to commit eb01c9cd87 ("[XFS] Remove
the xlog_ticket allocator") that replaces some old internal ticket
allocation mechanism (that I'm not familiar with) with a standard kmem
cache.

ISTM we can just remove that KM_MAYFAIL from ticket allocation. We're
already in NOFS context in this particular caller (writeback), though
that's probably not the case for most other transaction allocations. If
we had a reason to get more elaborate, I suppose we could conditionalize
use of the KM_MAYFAIL flag and/or lift bits of ticket allocation to
earlier in xfs_trans_alloc(), but it's not clear to me that's necessary.
Dave?

Brian

> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index f16d5f196c6b..7df0f5333d91 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -112,7 +112,8 @@ xfs_destroy_ioend(
> 
>  	if (unlikely(error && !quiet)) {
>  		xfs_err_ratelimited(XFS_I(inode)->i_mount,
> -			"writeback error on sector %llu", start);
> +				    "writeback error %d on sector %llu", error, start);
> +		panic("STOP!");
>  	}
>  }
>  
> @@ -648,6 +649,9 @@ xfs_submit_ioend(
>  {
>  	unsigned int		nofs_flag;
>  
> +	if (status)
> +		pr_err("xfs_submit_ioend(1) status=%d\n", status);
> +
>  	/*
>  	 * We can allocate memory here while doing writeback on behalf of
>  	 * memory reclaim.  To avoid memory allocation deadlocks set the
> @@ -659,6 +663,8 @@ xfs_submit_ioend(
>  	if (!status && ioend->io_fork == XFS_COW_FORK) {
>  		status = xfs_reflink_convert_cow(XFS_I(ioend->io_inode),
>  				ioend->io_offset, ioend->io_size);
> +		if (status)
> +			pr_err("xfs_submit_ioend(2) status=%d\n", status);
>  	}
>  
>  	/* Reserve log space if we might write beyond the on-disk inode size. */
> @@ -666,8 +672,11 @@ xfs_submit_ioend(
>  	    (ioend->io_fork == XFS_COW_FORK ||
>  	     ioend->io_state != XFS_EXT_UNWRITTEN) &&
>  	    xfs_ioend_is_append(ioend) &&
> -	    !ioend->io_append_trans)
> +	    !ioend->io_append_trans) {
>  		status = xfs_setfilesize_trans_alloc(ioend);
> +		if (status)
> +			pr_err("xfs_submit_ioend(3) status=%d\n", status);
> +	}
>  
>  	memalloc_nofs_restore(nofs_flag);
>  
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 272c6de1bf4e..d8d1ed1c51d4 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3748,11 +3748,11 @@ void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
>  {
>  	struct va_format vaf;
>  	va_list args;
> -	static DEFINE_RATELIMIT_STATE(nopage_rs, DEFAULT_RATELIMIT_INTERVAL,
> -				      DEFAULT_RATELIMIT_BURST);
> +	//static DEFINE_RATELIMIT_STATE(nopage_rs, DEFAULT_RATELIMIT_INTERVAL,
> +	//			      DEFAULT_RATELIMIT_BURST);
>  
> -	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs))
> -		return;
> +	//if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs))
> +	//	return;
>  
>  	va_start(args, fmt);
>  	vaf.fmt = fmt;
> ----------------------------------------
> 
> ----------------------------------------
> [  160.300800][T1662] oom-torture: page allocation failure: order:0, mode:0x46c40(GFP_NOFS|__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_COMP), nodemask=(null)
> [  160.301216][T1662] CPU: 7 PID: 1662 Comm: oom-torture Kdump: loaded Not tainted 5.3.0-rc2+ #925
> [  160.301220][T1662] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
> [  160.301222][T1662] Call Trace:
> [  160.301229][T1662]  dump_stack+0x67/0x95
> [  160.301235][T1662]  warn_alloc+0xa9/0x140
> [  160.301251][T1662]  __alloc_pages_slowpath+0x9a8/0xbce
> [  160.301275][T1662]  __alloc_pages_nodemask+0x372/0x3b0
> [  160.301288][T1662]  alloc_slab_page+0x3a/0x8d0
> [  160.301294][T1662]  ? lockdep_hardirqs_on+0xe8/0x1d0
> [  160.301297][T1662]  ? new_slab+0x251/0x420
> [  160.301306][T1662]  new_slab+0x330/0x420
> [  160.301314][T1662]  ___slab_alloc.constprop.94+0x879/0xb00
> [  160.301363][T1662]  ? kmem_zone_alloc+0x9f/0x110 [xfs]
> [  160.301398][T1662]  ? kmem_zone_alloc+0x9f/0x110 [xfs]
> [  160.301430][T1662]  ? kmem_zone_alloc+0x9f/0x110 [xfs]
> [  160.301434][T1662]  ? init_object+0x37/0x80
> [  160.301445][T1662]  ? lockdep_hardirqs_off+0x77/0xe0
> [  160.301473][T1662]  ? kmem_zone_alloc+0x9f/0x110 [xfs]
> [  160.301478][T1662]  __slab_alloc.isra.89.constprop.93+0x43/0x6f
> [  160.301486][T1662]  kmem_cache_alloc+0x331/0x390
> [  160.301512][T1662]  ? kmem_zone_alloc+0x9f/0x110 [xfs]
> [  160.301543][T1662]  kmem_zone_alloc+0x9f/0x110 [xfs]
> [  160.301574][T1662]  xlog_ticket_alloc+0x33/0xd0 [xfs]
> [  160.301602][T1662]  xfs_log_reserve+0xb4/0x410 [xfs]
> [  160.301632][T1662]  xfs_trans_reserve+0x1d1/0x2b0 [xfs]
> [  160.301684][T1662]  xfs_trans_alloc+0xc9/0x250 [xfs]
> [  160.301714][T1662]  xfs_setfilesize_trans_alloc.isra.27+0x44/0xc0 [xfs]
> [  160.301769][T1662]  xfs_submit_ioend.isra.28+0xa5/0x180 [xfs]
> [  160.301799][T1662]  xfs_vm_writepages+0x76/0xa0 [xfs]
> [  160.301813][T1662]  do_writepages+0x17/0x80
> [  160.301819][T1662]  __filemap_fdatawrite_range+0xc1/0xf0
> [  160.301836][T1662]  file_write_and_wait_range+0x53/0xa0
> [  160.301865][T1662]  xfs_file_fsync+0x87/0x290 [xfs]
> [  160.301878][T1662]  vfs_fsync_range+0x37/0x80
> [  160.301883][T1662]  ? do_syscall_64+0x12/0x1c0
> [  160.301887][T1662]  ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [  160.301891][T1662]  do_fsync+0x38/0x60
> [  160.301899][T1662]  __x64_sys_fsync+0xf/0x20
> [  160.301903][T1662]  do_syscall_64+0x4a/0x1c0
> [  160.301909][T1662]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [  160.301912][T1662] RIP: 0033:0x7f73ecaac280
> [  160.301916][T1662] Code: 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 83 3d 1d 6d 2d 00 00 75 10 b8 4a 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 be 6a 01 00 48 89 04 24
> [  160.301919][T1662] RSP: 002b:00007fff2aaeb018 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
> [  160.301923][T1662] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f73ecaac280
> [  160.301925][T1662] RDX: 000000000000000a RSI: 0000000000000000 RDI: 0000000000000003
> [  160.301928][T1662] RBP: 0000000000000003 R08: 0000000000000000 R09: 00007f73eca0420d
> [  160.301931][T1662] R10: 00007fff2aaeaa60 R11: 0000000000000246 R12: 0000000000400938
> [  160.301934][T1662] R13: 00007fff2aaeb120 R14: 0000000000000000 R15: 0000000000000000
> [  160.302003][T1662] xfs_submit_ioend(3) status=-12
> [  160.302081][T1662] XFS (sda1): writeback error -12 on sector 91827024
> [  160.302085][T1662] Kernel panic - not syncing: STOP!
> [  160.304453][T1662] CPU: 7 PID: 1662 Comm: oom-torture Kdump: loaded Not tainted 5.3.0-rc2+ #925
> [  160.304455][T1662] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
> [  160.304457][T1662] Call Trace:
> [  160.304461][T1662]  dump_stack+0x67/0x95
> [  160.304467][T1662]  panic+0xfc/0x2e0
> [  160.304501][T1662]  xfs_destroy_ioend+0x228/0x260 [xfs]
> [  160.304534][T1662]  xfs_end_bio+0xd0/0xe0 [xfs]
> [  160.320673][T1662]  bio_endio+0x174/0x340
> [  160.320677][T1662]  ? bio_endio+0xc3/0x340
> [  160.320712][T1662]  xfs_submit_ioend.isra.28+0x101/0x180 [xfs]
> [  160.320741][T1662]  xfs_vm_writepages+0x76/0xa0 [xfs]
> [  160.329386][T1662]  do_writepages+0x17/0x80
> [  160.329392][T1662]  __filemap_fdatawrite_range+0xc1/0xf0
> [  160.329403][T1662]  file_write_and_wait_range+0x53/0xa0
> [  160.329440][T1662]  xfs_file_fsync+0x87/0x290 [xfs]
> [  160.329451][T1662]  vfs_fsync_range+0x37/0x80
> [  160.329454][T1662]  ? do_syscall_64+0x12/0x1c0
> [  160.329457][T1662]  ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [  160.329462][T1662]  do_fsync+0x38/0x60
> [  160.329467][T1662]  __x64_sys_fsync+0xf/0x20
> [  160.329470][T1662]  do_syscall_64+0x4a/0x1c0
> [  160.329475][T1662]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [  160.329478][T1662] RIP: 0033:0x7f73ecaac280
> [  160.329481][T1662] Code: 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 83 3d 1d 6d 2d 00 00 75 10 b8 4a 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 be 6a 01 00 48 89 04 24
> [  160.329482][T1662] RSP: 002b:00007fff2aaeb018 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
> [  160.329485][T1662] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f73ecaac280
> [  160.329486][T1662] RDX: 000000000000000a RSI: 0000000000000000 RDI: 0000000000000003
> [  160.329488][T1662] RBP: 0000000000000003 R08: 0000000000000000 R09: 00007f73eca0420d
> [  160.329489][T1662] R10: 00007fff2aaeaa60 R11: 0000000000000246 R12: 0000000000400938
> [  160.329490][T1662] R13: 00007fff2aaeb120 R14: 0000000000000000 R15: 0000000000000000
> ----------------------------------------
