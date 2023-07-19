Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F4FEB64DC
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 02:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjGSCIA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jul 2023 22:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjGSCH7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2023 22:07:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1347139
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 19:07:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59D5761626
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 02:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D187C433C8;
        Wed, 19 Jul 2023 02:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689732476;
        bh=XRaAYaznRdJfVD0RNOxpO0wVpNncDSJgBP7F7g4EXok=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PLwxy1KZ3+du4JmRip7VTqsdKP2ZP88QfZ38I8IZ3bgRwFGbA/Fe59b9C+vinod7J
         g9dJ8Zom8Fe/RJczwMvylKMBhRzdTtH1ZGmoCTY/yzkCdMSBU7bCKKsAGXUWeIiqvU
         TFXQWaoHaJi1IhFQri3NhWNsOfAJ25W4BXeEnbR1K5FxqARFDOGz/7k2x1Fc/sN9np
         GaPyPdgpHb7/Sx3MPScei80VcfcqEME7Y9incoeejDidqe58I3ftwLJguIFuBJH4+/
         UhHGUxHnSlKSJpOQdubCbAt/5uaNX5yMVS7wNHSS0JJ+IfAQmudJRp5N/+Cdf2k4ZW
         OuUVlv+oyQQTQ==
Date:   Tue, 18 Jul 2023 19:07:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Long Li <leo.lilong@huawei.com>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org,
        yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2 2/3] xfs: abort intent items when recovery intents fail
Message-ID: <20230719020756.GD11352@frogsfrogsfrogs>
References: <20230715063647.2094989-1-leo.lilong@huawei.com>
 <20230715063647.2094989-3-leo.lilong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230715063647.2094989-3-leo.lilong@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 15, 2023 at 02:36:46PM +0800, Long Li wrote:
> When recovering intents, we capture newly created intent items as part of
> committing recovered intent items.  If intent recovery fails at a later
> point, we forget to remove those newly created intent items from the AIL
> and hang:
> 
>     [root@localhost ~]# cat /proc/539/stack
>     [<0>] xfs_ail_push_all_sync+0x174/0x230
>     [<0>] xfs_unmount_flush_inodes+0x8d/0xd0
>     [<0>] xfs_mountfs+0x15f7/0x1e70
>     [<0>] xfs_fs_fill_super+0x10ec/0x1b20
>     [<0>] get_tree_bdev+0x3c8/0x730
>     [<0>] vfs_get_tree+0x89/0x2c0
>     [<0>] path_mount+0xecf/0x1800
>     [<0>] do_mount+0xf3/0x110
>     [<0>] __x64_sys_mount+0x154/0x1f0
>     [<0>] do_syscall_64+0x39/0x80
>     [<0>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> When newly created intent items fail to commit via transaction, intent
> recovery hasn't created done items for these newly created intent items,
> so the capture structure is the sole owner of the captured intent items.
> We must release them explicitly or else they leak:
> 
> unreferenced object 0xffff888016719108 (size 432):
>   comm "mount", pid 529, jiffies 4294706839 (age 144.463s)
>   hex dump (first 32 bytes):
>     08 91 71 16 80 88 ff ff 08 91 71 16 80 88 ff ff  ..q.......q.....
>     18 91 71 16 80 88 ff ff 18 91 71 16 80 88 ff ff  ..q.......q.....
>   backtrace:
>     [<ffffffff8230c68f>] xfs_efi_init+0x18f/0x1d0
>     [<ffffffff8230c720>] xfs_extent_free_create_intent+0x50/0x150
>     [<ffffffff821b671a>] xfs_defer_create_intents+0x16a/0x340
>     [<ffffffff821bac3e>] xfs_defer_ops_capture_and_commit+0x8e/0xad0
>     [<ffffffff82322bb9>] xfs_cui_item_recover+0x819/0x980
>     [<ffffffff823289b6>] xlog_recover_process_intents+0x246/0xb70
>     [<ffffffff8233249a>] xlog_recover_finish+0x8a/0x9a0
>     [<ffffffff822eeafb>] xfs_log_mount_finish+0x2bb/0x4a0
>     [<ffffffff822c0f4f>] xfs_mountfs+0x14bf/0x1e70
>     [<ffffffff822d1f80>] xfs_fs_fill_super+0x10d0/0x1b20
>     [<ffffffff81a21fa2>] get_tree_bdev+0x3d2/0x6d0
>     [<ffffffff81a1ee09>] vfs_get_tree+0x89/0x2c0
>     [<ffffffff81a9f35f>] path_mount+0xecf/0x1800
>     [<ffffffff81a9fd83>] do_mount+0xf3/0x110
>     [<ffffffff81aa00e4>] __x64_sys_mount+0x154/0x1f0
>     [<ffffffff83968739>] do_syscall_64+0x39/0x80
> 
> Fix the problem above by abort intent items that don't have a done item
> when recovery intents fail.
> 
> Fixes: e6fff81e4870 ("xfs: proper replay of deferred ops queued during log recovery")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c | 5 +++--
>  fs/xfs/libxfs/xfs_defer.h | 2 +-
>  fs/xfs/xfs_log_recover.c  | 2 +-
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 88388e12f8e7..f71679ce23b9 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -763,12 +763,13 @@ xfs_defer_ops_capture(
>  
>  /* Release all resources that we used to capture deferred ops. */
>  void
> -xfs_defer_ops_capture_free(
> +xfs_defer_ops_capture_abort(
>  	struct xfs_mount		*mp,
>  	struct xfs_defer_capture	*dfc)
>  {
>  	unsigned short			i;
>  
> +	xfs_defer_pending_abort(mp, &dfc->dfc_dfops);

Aha, so ... intent recovery can itself create new intent items.  These
new items are tracked via t_dfops in the transaction, but they've been
moved into the xfs_defer_capture structure by xfs_defer_ops_capture...

>  	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
>  
>  	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
> @@ -809,7 +810,7 @@ xfs_defer_ops_capture_and_commit(
>  	/* Commit the transaction and add the capture structure to the list. */
>  	error = xfs_trans_commit(tp);
>  	if (error) {
> -		xfs_defer_ops_capture_free(mp, dfc);
> +		xfs_defer_ops_capture_abort(mp, dfc);

...but then the transaction commit fails.  The capture structure still
has the new intents attached, but nobody actually aborts them.  They
leak.

That's why _capture_free needs to call xfs_defer_pending_abort so that
we call ->abort_intent to free the new intents instead of leaking them.

Ok.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


>  		return error;
>  	}
>  
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 114a3a4930a3..8788ad5f6a73 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -121,7 +121,7 @@ int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
>  		struct list_head *capture_list);
>  void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp,
>  		struct xfs_defer_resources *dres);
> -void xfs_defer_ops_capture_free(struct xfs_mount *mp,
> +void xfs_defer_ops_capture_abort(struct xfs_mount *mp,
>  		struct xfs_defer_capture *d);
>  void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 82c81d20459d..fdaa0ffe029b 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2511,7 +2511,7 @@ xlog_abort_defer_ops(
>  
>  	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
>  		list_del_init(&dfc->dfc_list);
> -		xfs_defer_ops_capture_free(mp, dfc);
> +		xfs_defer_ops_capture_abort(mp, dfc);
>  	}
>  }
>  
> -- 
> 2.31.1
> 
