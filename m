Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65345C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 16:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BFAE20738
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 16:33:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BbmPSheG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgFBQdF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 12:33:05 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53680 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725940AbgFBQdF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 12:33:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591115583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XJaApkyPOpaS9GrFJqIgA4MrZcNjF3x0qQgEn90ie6g=;
        b=BbmPSheGiC6UtMQ4p4UgDWvI7vPKVN55T0jr/Tx9ZacLVgLqpHTN4TgcIUC1/YdJbU0FQ2
        LjrAWkhJ+/6isDUZs3ZNyK/UVjCfWHdRTjYKS9/hu177xoiwIe2C0RHpCv4Qcr/tq6kgs3
        EsMXA1CDg4WaGOpHKSInMmRJH1MBWog=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-LFvwrassNE-gegS6da7wzg-1; Tue, 02 Jun 2020 12:32:53 -0400
X-MC-Unique: LFvwrassNE-gegS6da7wzg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C49C61009442;
        Tue,  2 Jun 2020 16:32:51 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D51A78EF6;
        Tue,  2 Jun 2020 16:32:51 +0000 (UTC)
Date:   Tue, 2 Jun 2020 12:32:49 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/30] xfs: Don't allow logging of XFS_ISTALE inodes
Message-ID: <20200602163249.GA7967@bfoster>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-2-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:22AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In tracking down a problem in this patchset, I discovered we are
> reclaiming dirty stale inodes. This wasn't discovered until inodes
> were always attached to the cluster buffer and then the rcu callback
> that freed inodes was assert failing because the inode still had an
> active pointer to the cluster buffer after it had been reclaimed.
> 
> Debugging the issue indicated that this was a pre-existing issue
> resulting from the way the inodes are handled in xfs_inactive_ifree.
> When we free a cluster buffer from xfs_ifree_cluster, all the inodes
> in cache are marked XFS_ISTALE. Those that are clean have nothing
> else done to them and so eventually get cleaned up by background
> reclaim. i.e. it is assumed we'll never dirty/relog an inode marked
> XFS_ISTALE.
> 
> On journal commit dirty stale inodes as are handled by both
> buffer and inode log items to run though xfs_istale_done() and
> removed from the AIL (buffer log item commit) or the log item will
> simply unpin it because the buffer log item will clean it. What happens
> to any specific inode is entirely dependent on which log item wins
> the commit race, but the result is the same - stale inodes are
> clean, not attached to the cluster buffer, and not in the AIL. Hence
> inode reclaim can just free these inodes without further care.
> 
> However, if the stale inode is relogged, it gets dirtied again and
> relogged into the CIL. Most of the time this isn't an issue, because
> relogging simply changes the inode's location in the current
> checkpoint. Problems arise, however, when the CIL checkpoints
> between two transactions in the xfs_inactive_ifree() deferops
> processing. This results in the XFS_ISTALE inode being redirtied
> and inserted into the CIL without any of the other stale cluster
> buffer infrastructure being in place.
> 
> Hence on journal commit, it simply gets unpinned, so it remains
> dirty in memory. Everything in inode writeback avoids XFS_ISTALE
> inodes so it can't be written back, and it is not tracked in the AIL
> so there's not even a trigger to attempt to clean the inode. Hence
> the inode just sits dirty in memory until inode reclaim comes along,
> sees that it is XFS_ISTALE, and goes to reclaim it. This reclaiming
> of a dirty inode caused use after free, list corruptions and other
> nasty issues later in this patchset.
> 
> Hence this patch addresses a violation of the "never log XFS_ISTALE
> inodes" caused by the deferops processing rolling a transaction
> and relogging a stale inode in xfs_inactive_free. It also adds a
> bunch of asserts to catch this problem in debug kernels so that
> we don't reintroduce this problem in future.
> 
> Reproducer for this issue was generic/558 on a v4 filesystem.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_trans_inode.c |  2 ++
>  fs/xfs/xfs_icache.c             |  3 ++-
>  fs/xfs/xfs_inode.c              | 25 ++++++++++++++++++++++---
>  3 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index b5dfb66548422..4504d215cd590 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -36,6 +36,7 @@ xfs_trans_ijoin(
>  
>  	ASSERT(iip->ili_lock_flags == 0);
>  	iip->ili_lock_flags = lock_flags;
> +	ASSERT(!xfs_iflags_test(ip, XFS_ISTALE));
>  
>  	/*
>  	 * Get a log_item_desc to point at the new item.
> @@ -89,6 +90,7 @@ xfs_trans_log_inode(
>  
>  	ASSERT(ip->i_itemp != NULL);
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +	ASSERT(!xfs_iflags_test(ip, XFS_ISTALE));
>  
>  	/*
>  	 * Don't bother with i_lock for the I_DIRTY_TIME check here, as races
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 0a5ac6f9a5834..dbba4c1946386 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1141,7 +1141,7 @@ xfs_reclaim_inode(
>  			goto out_ifunlock;
>  		xfs_iunpin_wait(ip);
>  	}
> -	if (xfs_iflags_test(ip, XFS_ISTALE) || xfs_inode_clean(ip)) {
> +	if (xfs_inode_clean(ip)) {
>  		xfs_ifunlock(ip);
>  		goto reclaim;
>  	}
> @@ -1228,6 +1228,7 @@ xfs_reclaim_inode(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_qm_dqdetach(ip);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	ASSERT(xfs_inode_clean(ip));
>  
>  	__xfs_inode_free(ip);
>  	return error;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 64f5f9a440aed..53a1d64782c35 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1740,10 +1740,31 @@ xfs_inactive_ifree(
>  		return error;
>  	}
>  
> +	/*
> +	 * We do not hold the inode locked across the entire rolling transaction
> +	 * here. We only need to hold it for the first transaction that
> +	 * xfs_ifree() builds, which may mark the inode XFS_ISTALE if the
> +	 * underlying cluster buffer is freed. Relogging an XFS_ISTALE inode
> +	 * here breaks the relationship between cluster buffer invalidation and
> +	 * stale inode invalidation on cluster buffer item journal commit
> +	 * completion, and can result in leaving dirty stale inodes hanging
> +	 * around in memory.
> +	 *
> +	 * We have no need for serialising this inode operation against other
> +	 * operations - we freed the inode and hence reallocation is required
> +	 * and that will serialise on reallocating the space the deferops need
> +	 * to free. Hence we can unlock the inode on the first commit of
> +	 * the transaction rather than roll it right through the deferops. This
> +	 * avoids relogging the XFS_ISTALE inode.
> +	 *
> +	 * We check that xfs_ifree() hasn't grown an internal transaction roll
> +	 * by asserting that the inode is still locked when it returns.
> +	 */
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, ip, 0);
> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  
>  	error = xfs_ifree(tp, ip);
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  	if (error) {
>  		/*
>  		 * If we fail to free the inode, shut down.  The cancel
> @@ -1756,7 +1777,6 @@ xfs_inactive_ifree(
>  			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
>  		}
>  		xfs_trans_cancel(tp);
> -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		return error;
>  	}
>  
> @@ -1774,7 +1794,6 @@ xfs_inactive_ifree(
>  		xfs_notice(mp, "%s: xfs_trans_commit returned error %d",
>  			__func__, error);
>  
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return 0;
>  }
>  
> -- 
> 2.26.2.761.g0e0b3e54be
> 

