Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D98A7EB64DC
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 02:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjGSCTS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jul 2023 22:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjGSCTS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2023 22:19:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B023A1BC1
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 19:19:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39FF8615D5
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 02:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAD2C433C8;
        Wed, 19 Jul 2023 02:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689733155;
        bh=Ux8w6l1/PeBGqE3q2NDqf/Xy03mKQRL/gK8q8FDX4oA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P9JvgOYH89WMWXMv0j4XpnV7NCTmFOLtiNjM5VVDncEF7z8Kei5nvLnZGu5wr9xZ1
         AxER5Am9k3VJBUfc3JaKYapj738nnXCOhKjfo6YPMa4jp0HMqr34aGxYM0qhcMS9Fi
         F4uWvgkFhO9nT2hg6/dGrBv4nTHpep3a+J9SuwvhBuSQ2ToH2jm7i7C7eV0dvwjbze
         Tx5GgsjsBlg2BN6EJ0RqibJJ59Mtw1xS26EkGzJZHrBVXHWhw67vbH2gLIXyVcmF9U
         QX7e3fahaL/nLB02s+odFHRJWiTKhI6qJALFo+FQlWB+kSKXAgMnEbCAzduXtmSMEe
         pGW1/uDjN8s5Q==
Date:   Tue, 18 Jul 2023 19:19:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Long Li <leo.lilong@huawei.com>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org,
        yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2 3/3] xfs: make sure done item committed before cancel
 intents
Message-ID: <20230719021914.GF11352@frogsfrogsfrogs>
References: <20230715063647.2094989-1-leo.lilong@huawei.com>
 <20230715063647.2094989-4-leo.lilong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230715063647.2094989-4-leo.lilong@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 15, 2023 at 02:36:47PM +0800, Long Li wrote:
> KASAN report a uaf when recover intents fails:
> 
>  ==================================================================
>  BUG: KASAN: slab-use-after-free in xfs_cui_release+0xb7/0xc0
>  Read of size 4 at addr ffff888012575e60 by task kworker/u8:3/103
>  CPU: 3 PID: 103 Comm: kworker/u8:3 Not tainted 6.4.0-rc7-next-20230619-00003-g94543a53f9a4-dirty #166
>  Workqueue: xfs-cil/sda xlog_cil_push_work
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x50/0x70
>   print_report+0xc2/0x600
>   kasan_report+0xb6/0xe0
>   xfs_cui_release+0xb7/0xc0
>   xfs_cud_item_release+0x3c/0x90
>   xfs_trans_committed_bulk+0x2d5/0x7f0
>   xlog_cil_committed+0xaba/0xf20
>   xlog_cil_push_work+0x1a60/0x2360
>   process_one_work+0x78e/0x1140
>   worker_thread+0x58b/0xf60
>   kthread+0x2cd/0x3c0
>   ret_from_fork+0x1f/0x30
>   </TASK>
> 
>  Allocated by task 531:
>   kasan_save_stack+0x22/0x40
>   kasan_set_track+0x25/0x30
>   __kasan_slab_alloc+0x55/0x60
>   kmem_cache_alloc+0x195/0x5f0
>   xfs_cui_init+0x198/0x1d0
>   xlog_recover_cui_commit_pass2+0x133/0x5f0
>   xlog_recover_items_pass2+0x107/0x230
>   xlog_recover_commit_trans+0x3e7/0x9c0
>   xlog_recovery_process_trans+0x140/0x1d0
>   xlog_recover_process_ophdr+0x1a0/0x3d0
>   xlog_recover_process_data+0x108/0x2d0
>   xlog_recover_process+0x1f6/0x280
>   xlog_do_recovery_pass+0x609/0xdb0
>   xlog_do_log_recovery+0x84/0xe0
>   xlog_do_recover+0x7d/0x470
>   xlog_recover+0x25f/0x490
>   xfs_log_mount+0x2dd/0x6f0
>   xfs_mountfs+0x11ce/0x1e70
>   xfs_fs_fill_super+0x10ec/0x1b20
>   get_tree_bdev+0x3c8/0x730
>   vfs_get_tree+0x89/0x2c0
>   path_mount+0xecf/0x1800
>   do_mount+0xf3/0x110
>   __x64_sys_mount+0x154/0x1f0
>   do_syscall_64+0x39/0x80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
>  Freed by task 531:
>   kasan_save_stack+0x22/0x40
>   kasan_set_track+0x25/0x30
>   kasan_save_free_info+0x2b/0x40
>   __kasan_slab_free+0x114/0x1b0
>   kmem_cache_free+0xf8/0x510
>   xfs_cui_item_free+0x95/0xb0
>   xfs_cui_release+0x86/0xc0
>   xlog_recover_cancel_intents.isra.0+0xf8/0x210
>   xlog_recover_finish+0x7e7/0x980
>   xfs_log_mount_finish+0x2bb/0x4a0
>   xfs_mountfs+0x14bf/0x1e70
>   xfs_fs_fill_super+0x10ec/0x1b20
>   get_tree_bdev+0x3c8/0x730
>   vfs_get_tree+0x89/0x2c0
>   path_mount+0xecf/0x1800
>   do_mount+0xf3/0x110
>   __x64_sys_mount+0x154/0x1f0
>   do_syscall_64+0x39/0x80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
>  The buggy address belongs to the object at ffff888012575dc8
>   which belongs to the cache xfs_cui_item of size 432
>  The buggy address is located 152 bytes inside of
>   freed 432-byte region [ffff888012575dc8, ffff888012575f78)
> 
>  The buggy address belongs to the physical page:
>  page:ffffea0000495d00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888012576208 pfn:0x12574
>  head:ffffea0000495d00 order:2 entire_mapcount:0 nr_pages_mapped:0 pincount:0
>  flags: 0x1fffff80010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
>  page_type: 0xffffffff()
>  raw: 001fffff80010200 ffff888012092f40 ffff888014570150 ffff888014570150
>  raw: ffff888012576208 00000000001e0010 00000001ffffffff 0000000000000000
>  page dumped because: kasan: bad access detected
> 
>  Memory state around the buggy address:
>   ffff888012575d00: fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc
>   ffff888012575d80: fc fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb
>  >ffff888012575e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                         ^
>   ffff888012575e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff888012575f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc
>  ==================================================================
> 
> If process intents fails, intent items left in AIL will be delete
> from AIL and freed in error handling, even intent items that have been
> recovered and created done items. After this, uaf will be triggered when
> done item commited, because at this point the released intent item will
> be accessed.
> 
> xlog_recover_finish                     xlog_cil_push_work
> ----------------------------            ---------------------------
> xlog_recover_process_intents
>   xfs_cui_item_recover//cui_refcount == 1
>     xfs_trans_get_cud
>     xfs_trans_commit
>       <add cud item to cil>
>   xfs_cui_item_recover
>     <error occurred and return>
> xlog_recover_cancel_intents
>   xfs_cui_release     //cui_refcount == 0
>     xfs_cui_item_free //free cui
>   <release other intent items>
> xlog_force_shutdown   //shutdown
>                                <...>
>                                         <push items in cil>
>                                         xlog_cil_committed
>                                           xfs_cud_item_release
>                                             xfs_cui_release // UAF
> 
> Fix it by move log force forward to make sure done items committed before
> cancel intents.
> 
> Fixes: 2e76f188fd90 ("xfs: cancel intents immediately if process_intents fails")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_log_recover.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index fdaa0ffe029b..c37031e64db5 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3444,6 +3444,13 @@ xlog_recover_finish(
>  	int	error;
>  
>  	error = xlog_recover_process_intents(log);
> +	/*
> +	 * Sync the log to get all the intents that have done item out of

"...that have intent done items out of the AIL."

> +	 * the AIL.  This isn't absolutely necessary, but it helps in case
> +	 * the unlink transactions would have problems pushing the intents
> +	 * out of the way.
> +	 */
> +	xfs_log_force(log->l_mp, XFS_LOG_SYNC);

Hmm.  Why doesn't the shutdown force the (now dead) dead log items out
of memory?

	/*
	 * Flush all the completed transactions to disk before marking the log
	 * being shut down. We need to do this first as shutting down the log
	 * before the force will prevent the log force from flushing the iclogs
	 * to disk.
	 *
	 * When we are in recovery, there are no transactions to flush, and
	 * we don't want to touch the log because we don't want to perturb the
	 * current head/tail for future recovery attempts. Hence we need to
	 * avoid a log force in this case.
	 *
	 * If we are shutting down due to a log IO error, then we must avoid
	 * trying to write the log as that may just result in more IO errors and
	 * an endless shutdown/force loop.
	 */
	if (!log_error && !xlog_in_recovery(log))
		xfs_log_force(log->l_mp, XFS_LOG_SYNC);

Oh.  We're in recovery, but we've passed the part where we've finished
with the log/inode/dquot items that we read from the disk.  IOWs, now
we've gotten to the part of recovery where we're actually standing up
new transactions to finish the work that was in the intents ... with new
incore intents.

I wonder, does the problem go away if you (hackishly)
clear_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate); before the
xlog_force_shutdown?

--D

>  	if (error) {
>  		/*
>  		 * Cancel all the unprocessed intent items now so that we don't
> @@ -3458,13 +3465,6 @@ xlog_recover_finish(
>  		return error;
>  	}
>  
> -	/*
> -	 * Sync the log to get all the intents out of the AIL.  This isn't
> -	 * absolutely necessary, but it helps in case the unlink transactions
> -	 * would have problems pushing the intents out of the way.
> -	 */
> -	xfs_log_force(log->l_mp, XFS_LOG_SYNC);
> -
>  	/*
>  	 * Now that we've recovered the log and all the intents, we can clear
>  	 * the log incompat feature bits in the superblock because there's no
> -- 
> 2.31.1
> 
