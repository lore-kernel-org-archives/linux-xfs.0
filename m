Return-Path: <SRS0=8d1d=7V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14580C433DF
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 17:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0C61208A9
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 17:38:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FMUfknzq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729849AbgFHRiB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 13:38:01 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34293 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726122AbgFHRiA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jun 2020 13:38:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591637878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sN/Ziissjoj+uhNH3ne+BMdnWWtAOAEFTJQqEmgQH+Q=;
        b=FMUfknzqz3vfO0bqn+KvaOdQSI3YnS3AadwqyCoPLHl8HdcAQ91igzWtJhBVFDXtVuRFzM
        2T/5OJW/GKHXjkVIbl3YWKeaFGznTecOUjNnbNuX1rOTdq9zjRotOuDakuQulL0tzBZRs0
        s7IPUuj5a8xkYp0NXD+wHA/72iJkB+s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-bFyBSduTP7urkm4gvkT8dQ-1; Mon, 08 Jun 2020 13:37:56 -0400
X-MC-Unique: bFyBSduTP7urkm4gvkT8dQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6011F100A901;
        Mon,  8 Jun 2020 17:37:55 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AF4E79598;
        Mon,  8 Jun 2020 17:37:54 +0000 (UTC)
Date:   Mon, 8 Jun 2020 13:37:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/30] xfs: rename xfs_iflush_int()
Message-ID: <20200608173753.GA37518@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-28-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604074606.266213-28-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 04, 2020 at 05:46:03PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> with xfs_iflush() gone, we can rename xfs_iflush_int() back to
> xfs_iflush(). Also move it up above xfs_iflush_cluster() so we don't
> need the forward definition any more.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_inode.c | 293 ++++++++++++++++++++++-----------------------
>  1 file changed, 146 insertions(+), 147 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 61c872e4ee157..8566bd0f4334d 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -44,7 +44,6 @@ kmem_zone_t *xfs_inode_zone;
>   */
>  #define	XFS_ITRUNC_MAX_EXTENTS	2
>  
> -STATIC int xfs_iflush_int(struct xfs_inode *, struct xfs_buf *);
>  STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
>  STATIC int xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *);
>  
> @@ -3450,152 +3449,8 @@ xfs_rename(
>  	return error;
>  }
>  
> -/*
> - * Non-blocking flush of dirty inode metadata into the backing buffer.
> - *
> - * The caller must have a reference to the inode and hold the cluster buffer
> - * locked. The function will walk across all the inodes on the cluster buffer it
> - * can find and lock without blocking, and flush them to the cluster buffer.
> - *
> - * On success, the caller must write out the buffer returned in *bp and
> - * release it. On failure, the filesystem will be shut down, the buffer will
> - * have been unlocked and released, and EFSCORRUPTED will be returned.
> - */
> -int
> -xfs_iflush_cluster(
> -	struct xfs_inode	*ip,
> -	struct xfs_buf		*bp)
> -{
> -	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_perag	*pag;
> -	unsigned long		first_index, mask;
> -	int			cilist_size;
> -	struct xfs_inode	**cilist;
> -	struct xfs_inode	*cip;
> -	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> -	int			error = 0;
> -	int			nr_found;
> -	int			clcount = 0;
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
> -
> -	for (i = 0; i < nr_found; i++) {
> -		cip = cilist[i];
> -
> -		/*
> -		 * because this is an RCU protected lookup, we could find a
> -		 * recently freed or even reallocated inode during the lookup.
> -		 * We need to check under the i_flags_lock for a valid inode
> -		 * here. Skip it if it is not valid or the wrong inode.
> -		 */
> -		spin_lock(&cip->i_flags_lock);
> -		if (!cip->i_ino ||
> -		    __xfs_iflags_test(cip, XFS_ISTALE)) {
> -			spin_unlock(&cip->i_flags_lock);
> -			continue;
> -		}
> -
> -		/*
> -		 * Once we fall off the end of the cluster, no point checking
> -		 * any more inodes in the list because they will also all be
> -		 * outside the cluster.
> -		 */
> -		if ((XFS_INO_TO_AGINO(mp, cip->i_ino) & mask) != first_index) {
> -			spin_unlock(&cip->i_flags_lock);
> -			break;
> -		}
> -		spin_unlock(&cip->i_flags_lock);
> -
> -		/*
> -		 * Do an un-protected check to see if the inode is dirty and
> -		 * is a candidate for flushing.  These checks will be repeated
> -		 * later after the appropriate locks are acquired.
> -		 */
> -		if (xfs_inode_clean(cip) && xfs_ipincount(cip) == 0)
> -			continue;
> -
> -		/*
> -		 * Try to get locks.  If any are unavailable or it is pinned,
> -		 * then this inode cannot be flushed and is skipped.
> -		 */
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
> -			continue;
> -		}
> -
> -
> -		/*
> -		 * Check the inode number again, just to be certain we are not
> -		 * racing with freeing in xfs_reclaim_inode(). See the comments
> -		 * in that function for more information as to why the initial
> -		 * check is not sufficient.
> -		 */
> -		if (!cip->i_ino) {
> -			xfs_ifunlock(cip);
> -			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> -			continue;
> -		}
> -
> -		/*
> -		 * arriving here means that this inode can be flushed.  First
> -		 * re-check that it's dirty before flushing.
> -		 */
> -		if (!xfs_inode_clean(cip)) {
> -			error = xfs_iflush_int(cip, bp);
> -			if (error) {
> -				xfs_iunlock(cip, XFS_ILOCK_SHARED);
> -				goto out_free;
> -			}
> -			clcount++;
> -		} else {
> -			xfs_ifunlock(cip);
> -		}
> -		xfs_iunlock(cip, XFS_ILOCK_SHARED);
> -	}
> -
> -	if (clcount) {
> -		XFS_STATS_INC(mp, xs_icluster_flushcnt);
> -		XFS_STATS_ADD(mp, xs_icluster_flushinode, clcount);
> -	}
> -
> -out_free:
> -	rcu_read_unlock();
> -	kmem_free(cilist);
> -out_put:
> -	xfs_perag_put(pag);
> -	if (error) {
> -		bp->b_flags |= XBF_ASYNC;
> -		xfs_buf_ioend_fail(bp);
> -		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -	}
> -	return error;
> -}
> -
> -STATIC int
> -xfs_iflush_int(
> +static int
> +xfs_iflush(
>  	struct xfs_inode	*ip,
>  	struct xfs_buf		*bp)
>  {
> @@ -3743,6 +3598,150 @@ xfs_iflush_int(
>  	return error;
>  }
>  
> +/*
> + * Non-blocking flush of dirty inode metadata into the backing buffer.
> + *
> + * The caller must have a reference to the inode and hold the cluster buffer
> + * locked. The function will walk across all the inodes on the cluster buffer it
> + * can find and lock without blocking, and flush them to the cluster buffer.
> + *
> + * On success, the caller must write out the buffer returned in *bp and
> + * release it. On failure, the filesystem will be shut down, the buffer will
> + * have been unlocked and released, and EFSCORRUPTED will be returned.
> + */
> +int
> +xfs_iflush_cluster(
> +	struct xfs_inode	*ip,
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_perag	*pag;
> +	unsigned long		first_index, mask;
> +	int			cilist_size;
> +	struct xfs_inode	**cilist;
> +	struct xfs_inode	*cip;
> +	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> +	int			error = 0;
> +	int			nr_found;
> +	int			clcount = 0;
> +	int			i;
> +
> +	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> +
> +	cilist_size = igeo->inodes_per_cluster * sizeof(struct xfs_inode *);
> +	cilist = kmem_alloc(cilist_size, KM_MAYFAIL|KM_NOFS);
> +	if (!cilist)
> +		goto out_put;
> +
> +	mask = ~(igeo->inodes_per_cluster - 1);
> +	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
> +	rcu_read_lock();
> +	/* really need a gang lookup range call here */
> +	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)cilist,
> +					first_index, igeo->inodes_per_cluster);
> +	if (nr_found == 0)
> +		goto out_free;
> +
> +	for (i = 0; i < nr_found; i++) {
> +		cip = cilist[i];
> +
> +		/*
> +		 * because this is an RCU protected lookup, we could find a
> +		 * recently freed or even reallocated inode during the lookup.
> +		 * We need to check under the i_flags_lock for a valid inode
> +		 * here. Skip it if it is not valid or the wrong inode.
> +		 */
> +		spin_lock(&cip->i_flags_lock);
> +		if (!cip->i_ino ||
> +		    __xfs_iflags_test(cip, XFS_ISTALE)) {
> +			spin_unlock(&cip->i_flags_lock);
> +			continue;
> +		}
> +
> +		/*
> +		 * Once we fall off the end of the cluster, no point checking
> +		 * any more inodes in the list because they will also all be
> +		 * outside the cluster.
> +		 */
> +		if ((XFS_INO_TO_AGINO(mp, cip->i_ino) & mask) != first_index) {
> +			spin_unlock(&cip->i_flags_lock);
> +			break;
> +		}
> +		spin_unlock(&cip->i_flags_lock);
> +
> +		/*
> +		 * Do an un-protected check to see if the inode is dirty and
> +		 * is a candidate for flushing.  These checks will be repeated
> +		 * later after the appropriate locks are acquired.
> +		 */
> +		if (xfs_inode_clean(cip) && xfs_ipincount(cip) == 0)
> +			continue;
> +
> +		/*
> +		 * Try to get locks.  If any are unavailable or it is pinned,
> +		 * then this inode cannot be flushed and is skipped.
> +		 */
> +
> +		if (!xfs_ilock_nowait(cip, XFS_ILOCK_SHARED))
> +			continue;
> +		if (!xfs_iflock_nowait(cip)) {
> +			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> +			continue;
> +		}
> +		if (xfs_ipincount(cip)) {
> +			xfs_ifunlock(cip);
> +			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> +			continue;
> +		}
> +
> +
> +		/*
> +		 * Check the inode number again, just to be certain we are not
> +		 * racing with freeing in xfs_reclaim_inode(). See the comments
> +		 * in that function for more information as to why the initial
> +		 * check is not sufficient.
> +		 */
> +		if (!cip->i_ino) {
> +			xfs_ifunlock(cip);
> +			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> +			continue;
> +		}
> +
> +		/*
> +		 * arriving here means that this inode can be flushed.  First
> +		 * re-check that it's dirty before flushing.
> +		 */
> +		if (!xfs_inode_clean(cip)) {
> +			error = xfs_iflush(cip, bp);
> +			if (error) {
> +				xfs_iunlock(cip, XFS_ILOCK_SHARED);
> +				goto out_free;
> +			}
> +			clcount++;
> +		} else {
> +			xfs_ifunlock(cip);
> +		}
> +		xfs_iunlock(cip, XFS_ILOCK_SHARED);
> +	}
> +
> +	if (clcount) {
> +		XFS_STATS_INC(mp, xs_icluster_flushcnt);
> +		XFS_STATS_ADD(mp, xs_icluster_flushinode, clcount);
> +	}
> +
> +out_free:
> +	rcu_read_unlock();
> +	kmem_free(cilist);
> +out_put:
> +	xfs_perag_put(pag);
> +	if (error) {
> +		bp->b_flags |= XBF_ASYNC;
> +		xfs_buf_ioend_fail(bp);
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +	}
> +	return error;
> +}
> +
>  /* Release an inode. */
>  void
>  xfs_irele(
> -- 
> 2.26.2.761.g0e0b3e54be
> 

