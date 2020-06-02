Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52399C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27927206C3
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:30:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B299GyGe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgFBEa5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:30:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49950 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFBEa5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:30:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524HuGf106403;
        Tue, 2 Jun 2020 04:30:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LkiyFBItBCgdI+BgXT3Skih7F2Aipuga1lejsfAogsU=;
 b=B299GyGekL8cfVWFDht3xHnh9/jr8VEeKtaDP41o7sVN1bYhWBe2gTx3KkznORqVHM59
 5SbuWpyKD4MJVpbP6nxTjDi9Z3j5lPFafmd7fe+VUQ5TF//sQlAqBfQW9tEf1WOJs5m5
 AFCkcVbPtxCrOR2d/g5KFmE7r5tq9d/No48aNguZEuvE1ORX6wABmuIQKhu8DiqmxXaB
 kn8bhIKgwLos856JDsLCY9MhSCZQ7fAxE/GEFLl14CJCuEhVHzqbrAa/73wgde8KX7d1
 0ldKicBvHkqaHSpKOxAzn3Tvossgobk8WEcrQTumPfya2/5nYXFC3NMv5DMXRBfuTFOY Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31bewqswte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:30:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524HvSw039996;
        Tue, 2 Jun 2020 04:30:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31c18sgnb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:30:54 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524UraJ022609;
        Tue, 2 Jun 2020 04:30:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:30:53 -0700
Date:   Mon, 1 Jun 2020 21:30:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/30] xfs: Don't allow logging of XFS_ISTALE inodes
Message-ID: <20200602043052.GZ8230@magnolia>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-2-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=5 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=5 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006020024
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

Hmm.  What defer ops causes a transaction roll?  Is it the EFI that
frees the inode cluster blocks?

> +	 *
> +	 * We check that xfs_ifree() hasn't grown an internal transaction roll
> +	 * by asserting that the inode is still locked when it returns.
> +	 */
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, ip, 0);
> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);

This looks right to me since we should be marking the inode free in the
first transaction and therefore should not keep it attached to the
transaction...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


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
