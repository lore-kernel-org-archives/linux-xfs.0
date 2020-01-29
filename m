Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11900C35246
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 22:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E406C20716
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 22:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgA2WSX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 17:18:23 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:46679 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726222AbgA2WSX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 17:18:23 -0500
Received: from dread.disaster.area (pa49-195-111-217.pa.nsw.optusnet.com.au [49.195.111.217])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 432723A2BD2;
        Thu, 30 Jan 2020 09:18:20 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iwvf9-00050n-3V; Thu, 30 Jan 2020 09:18:19 +1100
Date:   Thu, 30 Jan 2020 09:18:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: change xfs_isilocked() to always use lockdep()
Message-ID: <20200129221819.GO18610@dread.disaster.area>
References: <20200128145528.2093039-1-preichl@redhat.com>
 <20200128145528.2093039-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128145528.2093039-2-preichl@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=0OveGI8p3fsTA6FL6ss4ZQ==:117 a=0OveGI8p3fsTA6FL6ss4ZQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=YptG3Zgc0czc365FdWwA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 28, 2020 at 03:55:25PM +0100, Pavel Reichl wrote:
> mr_writer is obsolete and the information it contains is accesible
> from mr_lock.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c5077e6326c7..32fac6152dc3 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -352,13 +352,17 @@ xfs_isilocked(
>  {
>  	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
>  		if (!(lock_flags & XFS_ILOCK_SHARED))
> -			return !!ip->i_lock.mr_writer;
> +			return !debug_locks ||
> +				lockdep_is_held_type(&ip->i_lock.mr_lock, 0);
>  		return rwsem_is_locked(&ip->i_lock.mr_lock);
>  	}
>  
>  	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
>  		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
> -			return !!ip->i_mmaplock.mr_writer;
> +			return !debug_locks ||
> +				lockdep_is_held_type(
> +					&ip->i_mmaplock.mr_lock,
> +					0);
>  		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
>  	}

Ok, so this code is only called from ASSERT() statements, which
means this turns off write lock checking for XFS debug kernels if
lockdep is not enabled. Hence I think these checks need to be
restructured to be based around rwsem_is_locked() first and lockdep
second.

That is:

/* In all implementations count != 0 means locked */
static inline int rwsem_is_locked(struct rw_semaphore *sem)
{
        return atomic_long_read(&sem->count) != 0;
}

This captures both read and write locks on the rwsem, and doesn't
discriminate at all. Now we don't have explicit writer lock checking
in CONFIG_XFS_DEBUG=y kernels, I think we need to at least check
that the rwsem is locked in all cases to catch cases where we are
calling a function without the lock held. That will ctach most
programming mistakes, and then lockdep will provide the
read-vs-write discrimination to catch the "hold the wrong lock type"
mistakes.

Hence I think this code should end up looking like this:

	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
		bool locked = false;

		if (!rwsem_is_locked(&ip->i_lock))
			return false;
		if (!debug_locks)
			return true;
		if (lock_flags & XFS_ILOCK_EXCL)
			locked = lockdep_is_held_type(&ip->i_lock, 0);
		if (lock_flags & XFS_ILOCK_SHARED)
			locked |= lockdep_is_held_type(&ip->i_lock, 1);
		return locked;
	}

Thoughts?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
