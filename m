Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E68F4C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 05:35:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBEE863225
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 05:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhKQFiw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Nov 2021 00:38:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233099AbhKQFiv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 Nov 2021 00:38:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E211F63223;
        Wed, 17 Nov 2021 05:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637127354;
        bh=3wYNhNsM1wLzDfEVwKwADh2v6kVySzhY9mxnMJyHaXc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p3xzlkYSqxeXtuSLDR1yQmKF+I969MFbR/ucZv0G1NaJR4WaAPEJaNqp8e4beNLdV
         gU7jRgMxaUdkLej48awdTglEVPgORQFeLKiCqTSoCOCk5aEwJCZFKBGRXMT08q18u1
         8cBLdGbr7CSRG7IW1lFTMzOoUvvcxHAalKouR+ZbTpZHyqwEVlFy30tK5iRF0K5Qng
         QIS9iAQ2b/4N5vX62QWa2VQilHUl3i/VqAH2N41RGPa6nQaRSyd/PsnTjQpv0Iesxq
         igS3cmjhhhkx63GvAZl2kJxxWc1QRraVUrT13Z1550F8K2ucQJnBxra2w73vGTY3I3
         CLBlACmVilnZg==
Date:   Tue, 16 Nov 2021 21:35:53 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] xfs: remove xfs_inew_wait
Message-ID: <20211117053553.GV24307@magnolia>
References: <20211115095643.91254-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115095643.91254-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 15, 2021 at 10:56:43AM +0100, Christoph Hellwig wrote:
> With the remove of xfs_dqrele_all_inodes, xfs_inew_wait and all the
> infrastructure used to wake the XFS_INEW bit waitqueue is unused.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 777eb1fa857e ("xfs: remove xfs_dqrele_all_inodes")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Assuming we don't just immediately add something like this back for that
symlink rcu lookup whateverthatisnotfollowingatall reported elsewhere,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_icache.c | 21 ---------------------
>  fs/xfs/xfs_inode.h  |  4 +---
>  2 files changed, 1 insertion(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index e1472004170e8..da4af2142a2b4 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -289,22 +289,6 @@ xfs_perag_clear_inode_tag(
>  	trace_xfs_perag_clear_inode_tag(mp, pag->pag_agno, tag, _RET_IP_);
>  }
>  
> -static inline void
> -xfs_inew_wait(
> -	struct xfs_inode	*ip)
> -{
> -	wait_queue_head_t *wq = bit_waitqueue(&ip->i_flags, __XFS_INEW_BIT);
> -	DEFINE_WAIT_BIT(wait, &ip->i_flags, __XFS_INEW_BIT);
> -
> -	do {
> -		prepare_to_wait(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
> -		if (!xfs_iflags_test(ip, XFS_INEW))
> -			break;
> -		schedule();
> -	} while (true);
> -	finish_wait(wq, &wait.wq_entry);
> -}
> -
>  /*
>   * When we recycle a reclaimable inode, we need to re-initialise the VFS inode
>   * part of the structure. This is made more complex by the fact we store
> @@ -368,18 +352,13 @@ xfs_iget_recycle(
>  	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
>  	error = xfs_reinit_inode(mp, inode);
>  	if (error) {
> -		bool	wake;
> -
>  		/*
>  		 * Re-initializing the inode failed, and we are in deep
>  		 * trouble.  Try to re-add it to the reclaim list.
>  		 */
>  		rcu_read_lock();
>  		spin_lock(&ip->i_flags_lock);
> -		wake = !!__xfs_iflags_test(ip, XFS_INEW);
>  		ip->i_flags &= ~(XFS_INEW | XFS_IRECLAIM);
> -		if (wake)
> -			wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
>  		ASSERT(ip->i_flags & XFS_IRECLAIMABLE);
>  		spin_unlock(&ip->i_flags_lock);
>  		rcu_read_unlock();
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index e635a3d64cba2..c447bf04205a8 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -231,8 +231,7 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
>  #define XFS_IRECLAIM		(1 << 0) /* started reclaiming this inode */
>  #define XFS_ISTALE		(1 << 1) /* inode has been staled */
>  #define XFS_IRECLAIMABLE	(1 << 2) /* inode can be reclaimed */
> -#define __XFS_INEW_BIT		3	 /* inode has just been allocated */
> -#define XFS_INEW		(1 << __XFS_INEW_BIT)
> +#define XFS_INEW		(1 << 3) /* inode has just been allocated */
>  #define XFS_IPRESERVE_DM_FIELDS	(1 << 4) /* has legacy DMAPI fields set */
>  #define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
>  #define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
> @@ -492,7 +491,6 @@ static inline void xfs_finish_inode_setup(struct xfs_inode *ip)
>  	xfs_iflags_clear(ip, XFS_INEW);
>  	barrier();
>  	unlock_new_inode(VFS_I(ip));
> -	wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
>  }
>  
>  static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
> -- 
> 2.30.2
> 
