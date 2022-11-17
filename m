Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2B1C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 19:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbiKQTO6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Nov 2022 14:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234246AbiKQTO5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2022 14:14:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A37710555
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 11:14:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38E36B82177
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 19:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4526C433D6;
        Thu, 17 Nov 2022 19:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668712493;
        bh=NmeKHwt10+AW7c+k/1GWwiP/7dJTY3GQD0St0Y5zuKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vHUZsS3O0jfJ4isJ1PD/jDG0ECvrYJpgl1xb7AtZB9slViN39YZazX56e0m9AMLo8
         Qp2OeXLrXidHA4FnV7LH2ILwdbIEQCilw1wHzp6fTJUgrWjOKGzieWuTgIF1B8Dju3
         rx3+tEkkmAqcFQBvoyprsgiSw7R/74Lr8lipcCJ7PsU6eCGGNzXdosuNcTtvrl6n3z
         Q3W5uUygMdIiChUxcmzkKGeL8f1Xj9MFmd/juY30cqGoqVFiVCh8HLHNoqjm7CTJ8c
         SrXuyOBHuQV5VvmUcLrBudJBcmMtN+6pU0ro+jIRumBvmD51TIgdITPbzuy9M3NZwx
         xEpHULCuN6hXA==
Date:   Thu, 17 Nov 2022 11:14:53 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Long Li <leo.lilong@huawei.com>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org, houtao1@huawei.com,
        yi.zhang@huawei.com, guoxuenan@huawei.com
Subject: Re: [PATCH v3] xfs: fix incorrect i_nlink caused by inode racing
Message-ID: <Y3aILXtqGCTHW02R@magnolia>
References: <20221117133854.GA525799@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117133854.GA525799@ceph-admin>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 17, 2022 at 09:38:54PM +0800, Long Li wrote:
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
> v3:
> - Put ilock and iunlock in the same function

Thanks for fixing that, I'll run this through testing overnight.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
>  fs/xfs/xfs_icache.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index eae7427062cf..f35e2cee5265 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -342,6 +342,9 @@ xfs_iget_recycle(
>  
>  	trace_xfs_iget_recycle(ip);
>  
> +	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
> +		return -EAGAIN;
> +
>  	/*
>  	 * We need to make it look like the inode is being reclaimed to prevent
>  	 * the actual reclaim workers from stomping over us while we recycle
> @@ -355,6 +358,7 @@ xfs_iget_recycle(
>  
>  	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
>  	error = xfs_reinit_inode(mp, inode);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	if (error) {
>  		/*
>  		 * Re-initializing the inode failed, and we are in deep
> @@ -518,6 +522,8 @@ xfs_iget_cache_hit(
>  	if (ip->i_flags & XFS_IRECLAIMABLE) {
>  		/* Drops i_flags_lock and RCU read lock. */
>  		error = xfs_iget_recycle(pag, ip);
> +		if (error == -EAGAIN)
> +			goto out_skip;
>  		if (error)
>  			return error;
>  	} else {
> -- 
> 2.31.1
> 
