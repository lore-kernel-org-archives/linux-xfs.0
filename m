Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F26FC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jan 2022 22:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbiAMWiN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jan 2022 17:38:13 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:42087 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233439AbiAMWiN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jan 2022 17:38:13 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5265D62C1B0;
        Fri, 14 Jan 2022 09:38:11 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1n88jS-00ExRA-56; Fri, 14 Jan 2022 09:38:10 +1100
Date:   Fri, 14 Jan 2022 09:38:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <20220113223810.GG3290465@dread.disaster.area>
References: <20220113133701.629593-1-bfoster@redhat.com>
 <20220113133701.629593-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113133701.629593-3-bfoster@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61e0a9d3
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=4NtgkeQ8t2ceewWSlU8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 13, 2022 at 08:37:01AM -0500, Brian Foster wrote:
> We've had reports on distro (pre-deferred inactivation) kernels that
> inode reclaim (i.e. via drop_caches) can deadlock on the s_umount
> lock when invoked on a frozen XFS fs. This occurs because
> drop_caches acquires the lock and then blocks in xfs_inactive() on
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
> 
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
> +		 */
> +		icw.icw_flags = XFS_ICWALK_FLAG_SYNC;
> +		xfs_blockgc_free_space(mp, &icw);

Is a SYNC walk safe to run here? I know we run
xfs_blockgc_free_space() from XFS_IOC_FREE_EOFBLOCKS under
SB_FREEZE_WRITE protection, but here we have both frozen writes and
page faults we're running in a much more constrained freeze context
here.

i.e. the SYNC walk will keep busy looping if it can't get the
IOLOCK_EXCL on an inode that is in cache, so if we end up with an
inode locked and blocked on SB_FREEZE_WRITE or SB_FREEZE_PAGEFAULT
for whatever reason this will never return....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
