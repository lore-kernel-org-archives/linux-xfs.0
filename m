Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B71B5C64EC7
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Mar 2023 01:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjCABF3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Feb 2023 20:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjCABF3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2023 20:05:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB251E2A4
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2023 17:05:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A317B611CA
        for <linux-xfs@vger.kernel.org>; Wed,  1 Mar 2023 01:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04689C433EF;
        Wed,  1 Mar 2023 01:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677632727;
        bh=usg3Pv3arl9CKnjCIfvJhKL3YxqEoRFq7/eZn57J19Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SSUYIxPWVYCOj1prGBbjdd8oIXh3WYagfuqaxjowfJQFio5N1EnmM9Yr0HTntKkSJ
         BeHEjKcS77vcqPDJ2rDxsHjTib06TLnHcV/4shHstyMRy0VM7Vv+kTIfVdjAXi8zi0
         HKRLXQgI1qvgeBlOemnc3+zeNPMIXmFQPwudplhAeR8QU/GbUaBmMWkEhE4srWFpmP
         4uERYdoeBj8cGZk/AbxMeDU9Oxb0EzgV4pbbJiAlGVU6v7ByGZGjDMqSheHC00+pUQ
         2Wk4G5kF77E2BwqHxOxct0bhLfnMRzEbLQ5f5wOcUD846ACUMnxD9se3C5p3HUVAji
         F3mCp6AIsJ9eA==
Date:   Tue, 28 Feb 2023 17:05:26 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Long Li <leo.lilong@huawei.com>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org, houtao1@huawei.com,
        yi.zhang@huawei.com, guoxuenan@huawei.com
Subject: Re: [PATCH v2] xfs: fix hung when transaction commit fail in
 xfs_inactive_ifree
Message-ID: <Y/6k1kmxtLqKwq8o@magnolia>
References: <20230227062952.GA53788@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227062952.GA53788@ceph-admin>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 27, 2023 at 02:29:52PM +0800, Long Li wrote:
> After running unplug disk test and unmount filesystem, the umount thread
> hung all the time.
> 
>  crash> dmesg
>  sd 0:0:0:0: rejecting I/O to offline device
>  XFS (sda): log I/O error -5
>  XFS (sda): Corruption of in-memory data (0x8) detected at xfs_defer_finish_noroll+0x12e0/0x1cf0
> 	(fs/xfs/libxfs/xfs_defer.c:504).  Shutting down filesystem.
>  XFS (sda): Please unmount the filesystem and rectify the problem(s)
>  XFS (sda): xfs_inactive_ifree: xfs_trans_commit returned error -5
>  XFS (sda): Unmounting Filesystem
> 
>  crash> bt 3368
>  PID: 3368   TASK: ffff88801bcd8040  CPU: 3   COMMAND: "umount"
>   #0 [ffffc900086a7ae0] __schedule at ffffffff83d3fd25
>   #1 [ffffc900086a7be8] schedule at ffffffff83d414dd
>   #2 [ffffc900086a7c10] xfs_ail_push_all_sync at ffffffff8256db24
>   #3 [ffffc900086a7d18] xfs_unmount_flush_inodes at ffffffff824ee7e2
>   #4 [ffffc900086a7d28] xfs_unmountfs at ffffffff824f2eff
>   #5 [ffffc900086a7da8] xfs_fs_put_super at ffffffff82503e69
>   #6 [ffffc900086a7de8] generic_shutdown_super at ffffffff81aeb8cd
>   #7 [ffffc900086a7e10] kill_block_super at ffffffff81aefcfa
>   #8 [ffffc900086a7e30] deactivate_locked_super at ffffffff81aeb2da
>   #9 [ffffc900086a7e48] deactivate_super at ffffffff81aeb639
>  #10 [ffffc900086a7e68] cleanup_mnt at ffffffff81b6ddd5
>  #11 [ffffc900086a7ea0] __cleanup_mnt at ffffffff81b6dfdf
>  #12 [ffffc900086a7eb0] task_work_run at ffffffff8126e5cf
>  #13 [ffffc900086a7ef8] exit_to_user_mode_prepare at ffffffff813fa136
>  #14 [ffffc900086a7f28] syscall_exit_to_user_mode at ffffffff83d25dbb
>  #15 [ffffc900086a7f40] do_syscall_64 at ffffffff83d1f8d9
>  #16 [ffffc900086a7f50] entry_SYSCALL_64_after_hwframe at ffffffff83e00085
> 
> When we free a cluster buffer from xfs_ifree_cluster, all the inodes in
> cache are marked XFS_ISTALE. On journal commit dirty stale inodes as are
> handled by both buffer and inode log items, inodes marked as XFS_ISTALE
> in AIL will be removed from the AIL because the buffer log item will clean
> it. If the transaction commit fails in the xfs_inactive_ifree(), inodes
> marked as XFS_ISTALE will be left in AIL due to buf log item is not
> committed,

Ah.  So the inode log items *are* in the AIL, but the buffer log item
for the inode cluster buffer is /not/ in the AIL?

Is it possible for neither inode nor cluster buffer are in the AIL?
I think the answer is no because freeing the inode will put it in the
AIL?

> this will cause the unmount thread above to be blocked all the
> time. Abort inodes flushing associated with the buffer that is stale when
> buf item release, prevent inode item left in AIL and can not being pushed.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_buf_item.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index df7322ed73fa..825e638d1088 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -659,14 +659,16 @@ xfs_buf_item_release(
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
>  	struct xfs_buf		*bp = bip->bli_buf;
> +	struct xfs_inode_log_item *iip;
> +	struct xfs_log_item     *lp, *n;

tabs here not spaces       ^^^^^

>  	bool			released;
>  	bool			hold = bip->bli_flags & XFS_BLI_HOLD;
>  	bool			stale = bip->bli_flags & XFS_BLI_STALE;
> +	bool			aborted = test_bit(XFS_LI_ABORTED,
> +						   &lip->li_flags);
>  #if defined(DEBUG) || defined(XFS_WARN)
>  	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
>  	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
> -	bool			aborted = test_bit(XFS_LI_ABORTED,
> -						   &lip->li_flags);
>  #endif
>  
>  	trace_xfs_buf_item_release(bip);
> @@ -679,6 +681,19 @@ xfs_buf_item_release(
>  	       (ordered && dirty && !xfs_buf_item_dirty_format(bip)));
>  	ASSERT(!stale || (bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
>  
> +	/*
> +	 * If it is an inode buffer and item marked as stale, abort flushing
> +	 * inodes associated with the buf, prevent inode item left in AIL.
> +	 */
> +	if (aborted && (bip->bli_flags & XFS_BLI_STALE_INODE)) {
> +		list_for_each_entry_safe(lp, n, &bp->b_li_list, li_bio_list) {
> +			iip = (struct xfs_inode_log_item *)lp;

Use container_of(), not raw casting.

> +
> +			if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE))
> +				xfs_iflush_abort(iip->ili_inode);
> +		}
> +	}
> +
>  	/*
>  	 * Clear the buffer's association with this transaction and
>  	 * per-transaction state from the bli, which has been copied above.
> -- 
> 2.31.1
> 
