Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C57B2C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 23:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C72A20738
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 23:23:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pGziVTvM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgFBXXn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 19:23:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58254 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgFBXXm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 19:23:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052NMhZE101099;
        Tue, 2 Jun 2020 23:23:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=t2GVYREcY3i9CQEhtc8MLs47b+vHcC0z+e8Zu08x3H4=;
 b=pGziVTvMsbgURizjbm/YYV+gs9zx7r4VPzoNguriXKvuVca5e0FVVKWFV3JU/zyjyIho
 N2fbYwe/5rmjzKhQN82ZDNsWjK4ESmLyi9631f3tEe+RYcht8O+dq6OUphZjpOhpurGc
 f96g+/wLRyagChOMzlFvNUWNgq5XpfnZMT2B+gLGugFtWgMCb3sZhlCJr0a9GCycFSK5
 Qg9/gqT142Iy+zK5ydfxNmWnqRh2Px6Z7DxD5CEWKedSgUqaaXBiUgxyp4VX+qBAbN5C
 qYhzmsuOA/HZrO+kELUNDCWQj0B3m/4Nq41Q0sYgWnl01YFOpzi/Zpk2EA48Cr20OAog 5g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31bewqxhsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 23:23:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052NICqL006807;
        Tue, 2 Jun 2020 23:23:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31c25qa4pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 23:23:37 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 052NNapt024894;
        Tue, 2 Jun 2020 23:23:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 16:23:36 -0700
Date:   Tue, 2 Jun 2020 16:23:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/30] xfs: rework xfs_iflush_cluster() dirty inode
 iteration
Message-ID: <20200602232335.GS8230@magnolia>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-29-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-29-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=5 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=5 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006020161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:49AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we have all the dirty inodes attached to the cluster
> buffer, we don't actually have to do radix tree lookups to find
> them. Sure, the radix tree is efficient, but walking a linked list
> of just the dirty inodes attached to the buffer is much better.
> 
> We are also no longer dependent on having a locked inode passed into
> the function to determine where to start the lookup. This means we
> can drop it from the function call and treat all inodes the same.
> 
> We also make xfs_iflush_cluster skip inodes marked with
> XFS_IRECLAIM. This we avoid races with inodes that reclaim is
> actively referencing or are being re-initialised by inode lookup. If
> they are actually dirty, they'll get written by a future cluster
> flush....
> 
> We also add a shutdown check after obtaining the flush lock so that
> we catch inodes that are dirty in memory and may have inconsistent
> state due to the shutdown in progress. We abort these inodes
> directly and so they remove themselves directly from the buffer list
> and the AIL rather than having to wait for the buffer to be failed
> and callbacks run to be processed correctly.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode.c      | 148 ++++++++++++++++------------------------
>  fs/xfs/xfs_inode.h      |   2 +-
>  fs/xfs/xfs_inode_item.c |   2 +-
>  3 files changed, 62 insertions(+), 90 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 8566bd0f4334d..931a483d5b316 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3611,117 +3611,94 @@ xfs_iflush(
>   */
>  int
>  xfs_iflush_cluster(
> -	struct xfs_inode	*ip,
>  	struct xfs_buf		*bp)
>  {
> -	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_perag	*pag;
> -	unsigned long		first_index, mask;
> -	int			cilist_size;
> -	struct xfs_inode	**cilist;
> -	struct xfs_inode	*cip;
> -	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> -	int			error = 0;
> -	int			nr_found;
> +	struct xfs_mount	*mp = bp->b_mount;
> +	struct xfs_log_item	*lip, *n;
> +	struct xfs_inode	*ip;
> +	struct xfs_inode_log_item *iip;
>  	int			clcount = 0;
> -	int			i;
> -
> -	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> -
> -	cilist_size = igeo->inodes_per_cluster * sizeof(struct xfs_inode *);
> -	cilist = kmem_alloc(cilist_size, KM_MAYFAIL|KM_NOFS);
> -	if (!cilist)
> -		goto out_put;
> -
> -	mask = ~(igeo->inodes_per_cluster - 1);
> -	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
> -	rcu_read_lock();
> -	/* really need a gang lookup range call here */
> -	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)cilist,
> -					first_index, igeo->inodes_per_cluster);
> -	if (nr_found == 0)
> -		goto out_free;
> +	int			error = 0;
>  
> -	for (i = 0; i < nr_found; i++) {
> -		cip = cilist[i];
> +	/*
> +	 * We must use the safe variant here as on shutdown xfs_iflush_abort()
> +	 * can remove itself from the list.
> +	 */
> +	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
> +		iip = (struct xfs_inode_log_item *)lip;
> +		ip = iip->ili_inode;
>  
>  		/*
> -		 * because this is an RCU protected lookup, we could find a
> -		 * recently freed or even reallocated inode during the lookup.
> -		 * We need to check under the i_flags_lock for a valid inode
> -		 * here. Skip it if it is not valid or the wrong inode.
> +		 * Quick and dirty check to avoid locks if possible.
>  		 */
> -		spin_lock(&cip->i_flags_lock);
> -		if (!cip->i_ino ||
> -		    __xfs_iflags_test(cip, XFS_ISTALE)) {
> -			spin_unlock(&cip->i_flags_lock);
> +		if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLOCK))
> +			continue;
> +		if (xfs_ipincount(ip))
>  			continue;
> -		}
>  
>  		/*
> -		 * Once we fall off the end of the cluster, no point checking
> -		 * any more inodes in the list because they will also all be
> -		 * outside the cluster.
> +		 * The inode is still attached to the buffer, which means it is
> +		 * dirty but reclaim might try to grab it. Check carefully for
> +		 * that, and grab the ilock while still holding the i_flags_lock
> +		 * to guarantee reclaim will not be able to reclaim this inode
> +		 * once we drop the i_flags_lock.
>  		 */
> -		if ((XFS_INO_TO_AGINO(mp, cip->i_ino) & mask) != first_index) {
> -			spin_unlock(&cip->i_flags_lock);
> -			break;
> +		spin_lock(&ip->i_flags_lock);
> +		ASSERT(!__xfs_iflags_test(ip, XFS_ISTALE));
> +		if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLOCK)) {
> +			spin_unlock(&ip->i_flags_lock);
> +			continue;
>  		}
> -		spin_unlock(&cip->i_flags_lock);
>  
>  		/*
> -		 * Do an un-protected check to see if the inode is dirty and
> -		 * is a candidate for flushing.  These checks will be repeated
> -		 * later after the appropriate locks are acquired.
> +		 * ILOCK will pin the inode against reclaim and prevent
> +		 * concurrent transactions modifying the inode while we are
> +		 * flushing the inode.
>  		 */
> -		if (xfs_inode_clean(cip) && xfs_ipincount(cip) == 0)
> +		if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
> +			spin_unlock(&ip->i_flags_lock);
>  			continue;
> +		}
> +		spin_unlock(&ip->i_flags_lock);
>  
>  		/*
> -		 * Try to get locks.  If any are unavailable or it is pinned,
> -		 * then this inode cannot be flushed and is skipped.
> +		 * Skip inodes that are already flush locked as they have
> +		 * already been written to the buffer.
>  		 */
> -
> -		if (!xfs_ilock_nowait(cip, XFS_ILOCK_SHARED))
> -			continue;
> -		if (!xfs_iflock_nowait(cip)) {
> -			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> -			continue;
> -		}
> -		if (xfs_ipincount(cip)) {
> -			xfs_ifunlock(cip);
> -			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> +		if (!xfs_iflock_nowait(ip)) {
> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  			continue;
>  		}
>  
> -
>  		/*
> -		 * Check the inode number again, just to be certain we are not
> -		 * racing with freeing in xfs_reclaim_inode(). See the comments
> -		 * in that function for more information as to why the initial
> -		 * check is not sufficient.
> +		 * If we are shut down, unpin and abort the inode now as there
> +		 * is no point in flushing it to the buffer just to get an IO
> +		 * completion to abort the buffer and remove it from the AIL.
>  		 */
> -		if (!cip->i_ino) {
> -			xfs_ifunlock(cip);
> -			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> +		if (XFS_FORCED_SHUTDOWN(mp)) {
> +			xfs_iunpin_wait(ip);
> +			/* xfs_iflush_abort() drops the flush lock */
> +			xfs_iflush_abort(ip);
> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +			error = -EIO;
>  			continue;
>  		}
>  
> -		/*
> -		 * arriving here means that this inode can be flushed.  First
> -		 * re-check that it's dirty before flushing.
> -		 */
> -		if (!xfs_inode_clean(cip)) {
> -			error = xfs_iflush(cip, bp);
> -			if (error) {
> -				xfs_iunlock(cip, XFS_ILOCK_SHARED);
> -				goto out_free;
> -			}
> -			clcount++;
> -		} else {
> -			xfs_ifunlock(cip);
> +		/* don't block waiting on a log force to unpin dirty inodes */
> +		if (xfs_ipincount(ip)) {
> +			xfs_ifunlock(ip);
> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +			continue;
>  		}
> -		xfs_iunlock(cip, XFS_ILOCK_SHARED);
> +
> +		if (!xfs_inode_clean(ip))
> +			error = xfs_iflush(ip, bp);
> +		else
> +			xfs_ifunlock(ip);
> +		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +		if (error)
> +			break;
> +		clcount++;
>  	}
>  
>  	if (clcount) {
> @@ -3729,11 +3706,6 @@ xfs_iflush_cluster(
>  		XFS_STATS_ADD(mp, xs_icluster_flushinode, clcount);
>  	}
>  
> -out_free:
> -	rcu_read_unlock();
> -	kmem_free(cilist);
> -out_put:
> -	xfs_perag_put(pag);
>  	if (error) {
>  		bp->b_flags |= XBF_ASYNC;
>  		xfs_buf_ioend_fail(bp);
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index d1109eb13ba2e..b93cf9076df8a 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -427,7 +427,7 @@ int		xfs_log_force_inode(struct xfs_inode *ip);
>  void		xfs_iunpin_wait(xfs_inode_t *);
>  #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
>  
> -int		xfs_iflush_cluster(struct xfs_inode *, struct xfs_buf *);
> +int		xfs_iflush_cluster(struct xfs_buf *);
>  void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
>  				struct xfs_inode *ip1, uint ip1_mode);
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index e679fac944725..a3a8ae5e39e12 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -513,7 +513,7 @@ xfs_inode_item_push(
>  	 * reference for IO until we queue the buffer for delwri submission.
>  	 */
>  	xfs_buf_hold(bp);
> -	error = xfs_iflush_cluster(ip, bp);
> +	error = xfs_iflush_cluster(bp);
>  	if (!error) {
>  		if (!xfs_buf_delwri_queue(bp, buffer_list))
>  			rval = XFS_ITEM_FLUSHING;
> -- 
> 2.26.2.761.g0e0b3e54be
> 
