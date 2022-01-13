Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C7DC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jan 2022 17:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbiAMRNv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jan 2022 12:13:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39888 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiAMRNv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jan 2022 12:13:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9978B80934
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jan 2022 17:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD3EC36AE9;
        Thu, 13 Jan 2022 17:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642094028;
        bh=GJXFCVge/BQJq8voZq7pzZrtnXxkvs+MBiqiZrFMoYs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JLDrJjFFWXuUMWffsHcffTAVEJnnVbSNUkhVrI9kXB6Qqt5eCoslszhKN+neFmgUZ
         7UU3UI9qxu0AVHaFjU2umROdpiGMtE8cbdz6nt3IvWNOO0FlLIK6/+TgaiVUP4f6A1
         6evcL1diMuhvUPE0o/214XiKg1Tg1dJB6+XQ7alOKz4fv8AW4NXct6egbBLhKQyppC
         bxGtz/utybbQFUMnQGAHyxs11C3eg2lXGvZXEiaOTZaKw6e7clQ6d11g5JPj38uYpg
         0ZlK76pnSbsh6hbp40nxieGsMp+5x4S3U9YHPebIz7aGRKVmUX7ZZgk+Z3qbIu0HJr
         Mwp16x5Y4hG+w==
Date:   Thu, 13 Jan 2022 09:13:47 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <20220113171347.GD19198@magnolia>
References: <20220113133701.629593-1-bfoster@redhat.com>
 <20220113133701.629593-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113133701.629593-3-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 13, 2022 at 08:37:01AM -0500, Brian Foster wrote:
> We've had reports on distro (pre-deferred inactivation) kernels that
> inode reclaim (i.e. via drop_caches) can deadlock on the s_umount
> lock when invoked on a frozen XFS fs. This occurs because
> drop_caches acquires the lock

Eww, I hadn't even noticed drop_caches as a way in to a s_umount
deadlock.  Good catch!

> and then blocks in xfs_inactive() on
> transaction alloc for an inode that requires an eofb trim. unfreeze
> then blocks on the same lock and the fs is deadlocked.
> 
> With deferred inactivation, the deadlock problem is no longer
> present because ->destroy_inode() no longer blocks whether the fs is
> frozen or not. There is still unfortunate behavior in that lookups
> of a pending inactive inode spin loop waiting for the pending
> inactive state to clear, which won't happen until the fs is
> unfrozen. This was always possible to some degree, but is
> potentially amplified by the fact that reclaim no longer blocks on
> the first inode that requires inactivation work. Instead, we
> populate the inactivation queues indefinitely. The side effect can
> be observed easily by invoking drop_caches on a frozen fs previously
> populated with eofb and/or cowblocks inodes and then running
> anything that relies on inode lookup (i.e., ls).
> 
> To mitigate this behavior, invoke internal blockgc reclaim during
> the freeze sequence to guarantee that inode eviction doesn't lead to
> this state due to eofb or cowblocks inodes. This is similar to
> current behavior on read-only remount. Since the deadlock issue was
> present for such a long time, also document the subtle
> ->destroy_inode() constraint to avoid unintentional reintroduction
> of the deadlock problem in the future.

Yay for improved documentation. :)

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_super.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index c7ac486ca5d3..1d0f87e47fa4 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -623,8 +623,13 @@ xfs_fs_alloc_inode(
>  }
>  
>  /*
> - * Now that the generic code is guaranteed not to be accessing
> - * the linux inode, we can inactivate and reclaim the inode.
> + * Now that the generic code is guaranteed not to be accessing the inode, we can
> + * inactivate and reclaim it.
> + *
> + * NOTE: ->destroy_inode() can be called (with ->s_umount held) while the
> + * filesystem is frozen. Therefore it is generally unsafe to attempt transaction
> + * allocation in this context. A transaction alloc that blocks on frozen state
> + * from a context with ->s_umount held will deadlock with unfreeze.
>   */
>  STATIC void
>  xfs_fs_destroy_inode(
> @@ -764,6 +769,16 @@ xfs_fs_sync_fs(
>  	 * when the state is either SB_FREEZE_FS or SB_FREEZE_COMPLETE.
>  	 */
>  	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT) {
> +		struct xfs_icwalk	icw = {0};
> +
> +		/*
> +		 * Clear out eofb and cowblocks inodes so eviction while frozen
> +		 * doesn't leave them sitting in the inactivation queue where
> +		 * they cannot be processed.

Would you mind adding an explicit link in the comment between needing to
get /all/ the inodes and _FLAG_SYNC?

"We must process every cached inode, so this requires a synchronous
cache scan."

> +		 */
> +		icw.icw_flags = XFS_ICWALK_FLAG_SYNC;
> +		xfs_blockgc_free_space(mp, &icw);

This needs to check the return value, right?

--D

> +
>  		xfs_inodegc_stop(mp);
>  		xfs_blockgc_stop(mp);
>  	}
> -- 
> 2.31.1
> 
