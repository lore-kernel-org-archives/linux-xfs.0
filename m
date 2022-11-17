Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9E8C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 03:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbiKQDNE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Nov 2022 22:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234170AbiKQDNC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2022 22:13:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33334E432
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 19:13:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C6C46207B
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 03:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB49AC433C1;
        Thu, 17 Nov 2022 03:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668654780;
        bh=VZmHHHwfUta8fEo+Q61awl5mcOfLlfyKE9qy4kPw+rU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YXewhMVXzqBWh6etulplEu19nQNLE6hUYe4A1QWSVJjb3S0/+t4k4+7aokkasIFqQ
         AD3/DR7mM8mq9Y/5RZgyNCP8cojuybZbsEtTOaj7XBBeNb656r2HjJJUzjdWg4PY+R
         CJlC6bXNv7zTxIluNEOElpYTTaml1b+A9SQR6Y/R7sprcZFqo4QHJundilMaVllFKu
         mRwJM2IYEDxQwroLc/9UgZ00nvQO5DV/qKF14LWPyqqLpYTcNbYR/bbYyUk6PMZbsP
         XMRjKRSeXLfB4P20NwnjxOo7hnt3+OmZGfdfXfznFP2BuiYxWcjZEtRv+tjbqs4aat
         w04pVLBQvEftw==
Date:   Wed, 16 Nov 2022 19:13:00 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Long Li <leo.lilong@huawei.com>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org, houtao1@huawei.com,
        yi.zhang@huawei.com, guoxuenan@huawei.com
Subject: Re: [PATCH v2] xfs: fix incorrect i_nlink caused by inode racing
Message-ID: <Y3WmvHFnK1eUodin@magnolia>
References: <20221117025829.GA1095675@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117025829.GA1095675@ceph-admin>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 17, 2022 at 10:58:29AM +0800, Long Li wrote:
> The following error occurred during the fsstress test:
> 
> XFS: Assertion failed: VFS_I(ip)->i_nlink >= 2, file: fs/xfs/xfs_inode.c, line: 2452
> 
> The problem was that inode race condition causes incorrect i_nlink to be
> written to disk, and then it is read into memory. Consider the following
> call graph, inodes that are marked as both XFS_IFLUSHING and
> XFS_IRECLAIMABLE, i_nlink will be reset to 1 and then restored to original
> value in xfs_reinit_inode(). Therefore, the i_nlink of directory on disk
> may be set to 1.
> 
>   xfsaild
>       xfs_inode_item_push
>           xfs_iflush_cluster
>               xfs_iflush
>                   xfs_inode_to_disk
> 
>   xfs_iget
>       xfs_iget_cache_hit
>           xfs_iget_recycle
>               xfs_reinit_inode
>   	          inode_init_always
> 
> xfs_reinit_inode() needs to hold the ILOCK_EXCL as it is changing internal
> inode state and can race with other RCU protected inode lookups. On the
> read side, xfs_iflush_cluster() grabs the ILOCK_SHARED while under rcu +
> ip->i_flags_lock, and so xfs_iflush/xfs_inode_to_disk() are protected from
> racing inode updates (during transactions) by that lock.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
> v2:
> - Modify the assertion error code line number
> - Use ILOCK_EXCL to prevent inode racing 
> 
>  fs/xfs/xfs_icache.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index eae7427062cf..5a1650e769e7 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -329,7 +329,7 @@ xfs_reinit_inode(
>  
>  /*
>   * Carefully nudge an inode whose VFS state has been torn down back into a
> - * usable state.  Drops the i_flags_lock and the rcu read lock.
> + * usable state.  Drops the i_flags_lock, rcu read lock and XFS_ILOCK_EXCL.
>   */
>  static int
>  xfs_iget_recycle(
> @@ -355,6 +355,7 @@ xfs_iget_recycle(
>  
>  	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
>  	error = xfs_reinit_inode(mp, inode);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);

Ugh, please don't take a lock in one function and drop it in a different
function.  If the trylock is really necessary for this operation, have
xfs_iget_recycle return EAGAIN and then make xfs_iget_cache_hit goto
out_skip if recycling returns EAGAIN.

--D

>  	if (error) {
>  		/*
>  		 * Re-initializing the inode failed, and we are in deep
> @@ -516,7 +517,10 @@ xfs_iget_cache_hit(
>  
>  	/* The inode fits the selection criteria; process it. */
>  	if (ip->i_flags & XFS_IRECLAIMABLE) {
> -		/* Drops i_flags_lock and RCU read lock. */
> +		if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
> +			goto out_skip;
> +
> +		/* Drops i_flags_lock, RCU read lock and XFS_ILOCK_EXCL. */
>  		error = xfs_iget_recycle(pag, ip);
>  		if (error)
>  			return error;
> -- 
> 2.31.1
> 
