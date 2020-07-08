Return-Path: <SRS0=1kUG=AT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F063C433E1
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 17:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6372D206F6
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 17:03:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DhCv+252"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbgGHRDR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 13:03:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44798 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgGHRDR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 13:03:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 068Gpx3f088508;
        Wed, 8 Jul 2020 17:03:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qkVtEN5x7/FVPdZdi7nqV+L48fvlAGOtspGkI3kQV0Y=;
 b=DhCv+252ihKBY0N/JTRKXI3yWW5o30N4hG7eCzS69dgJtuG+ZZ7Yj+VQ3BOD+7AsEii6
 0jDGsvHY3wFIlQSiUcvzKXn9zvELq/4wzJEUJY+366oXVY9lDT1Wj92h1a3BHSq6CmYY
 2nm2kgIMqTydPQy9ldDl0+nBAIgYVynB3Mg5kqsGPg69lXv+jh04dIoS1YBgZ6WM/x5M
 ejmpCTyWmaxS9/K+ems8ExIyLtzG2BZgILCyS60kR7I+hD8hdHlDSn1b/NWLZAka8Wge
 uYmECxyFq7/npN3B46iASCtcSZE/AA1GTNknNP0dajxjZd9jmeaVMYnXM4pf/6DyOq3R Og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 323wacqv6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 17:03:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 068GrUWI039325;
        Wed, 8 Jul 2020 17:03:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 325bgk3ybg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 17:03:09 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 068H39w4001691;
        Wed, 8 Jul 2020 17:03:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Jul 2020 10:03:08 -0700
Date:   Wed, 8 Jul 2020 10:03:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 2/2] xfs: don't access AGI on unlinked inodes if it
 can
Message-ID: <20200708170307.GD7625@magnolia>
References: <20200707135741.487-1-hsiangkao@redhat.com>
 <20200707135741.487-3-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707135741.487-3-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9676 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 spamscore=0 phishscore=0 malwarescore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007080109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9676 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 mlxlogscore=999 adultscore=0 cotscore=-2147483648
 suspectscore=1 impostorscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080109
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 07, 2020 at 09:57:41PM +0800, Gao Xiang wrote:
> Currently, we use AGI buffer lock to protect in-memory linked list for
> unlinked inodes but since it's not necessary to modify AGI unless the
> head of the unlinked list is modified. So let's removing the AGI buffer
> modification dependency if possible, including 1) adding another per-AG
> dedicated lock to protect the whole list and 2) inserting unlinked
> inodes from tail.
> 
> For 2), the tail of bucket 0 is now recorded in perag for xfs_iunlink()
> to use. xfs_iunlink_remove() still support old multiple short bucket
> lists for recovery code.
> 
> Note that some paths take AGI lock in its transaction in advance,
> so the proper locking order is only AGI lock -> unlinked list lock.

How much agi buffer lock contention does this eliminate?

> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/xfs_inode.c       | 251 ++++++++++++++++++++-------------------
>  fs/xfs/xfs_log_recover.c |   6 +
>  fs/xfs/xfs_mount.c       |   3 +
>  fs/xfs/xfs_mount.h       |   3 +
>  4 files changed, 144 insertions(+), 119 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 10565fa5ace4..d33e5b198534 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1994,182 +1994,195 @@ xfs_iunlink_update_bucket(
>  }
>  
>  /*
> - * Always insert at the head, so we only have to do a next inode lookup to
> - * update it's prev pointer. The AGI bucket will point at the one we are
> - * inserting.
> + * This is called when the inode's link count has gone to 0 or we are creating
> + * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
> + *
> + * We place the on-disk inode on a list in the AGI.  It will be pulled from this
> + * list when the inode is freed.
>   */
> -static int
> -xfs_iunlink_insert_inode(
> +STATIC int
> +xfs_iunlink(
>  	struct xfs_trans	*tp,
> -	struct xfs_buf		*agibp,
>  	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_agi		*agi = agibp->b_addr;
> -	xfs_agino_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> +	struct xfs_perag	*pag;
> +	struct xfs_inode	*pip;
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> -	xfs_agino_t		next_agino;
> +	int			error;
> +
> +	ASSERT(VFS_I(ip)->i_nlink == 0);
> +	ASSERT(VFS_I(ip)->i_mode != 0);
> +	trace_xfs_iunlink(ip);
> +
> +	pag = xfs_perag_get(mp, agno);
>  
>  	/*
> -	 * Get the index into the agi hash table for the list this inode will
> -	 * go on.  Make sure the pointer isn't garbage and that this inode
> -	 * isn't already on the list.
> +	 * some paths (e.g. xfs_create_tmpfile) could take AGI lock
> +	 * in this transaction in advance and the only locking order
> +	 * AGI buf lock -> pag_unlinked_mutex is safe.
>  	 */
> -	next_agino = be32_to_cpu(agi->agi_unlinked[0]);
> -	if (next_agino == agino ||
> -	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
> -		xfs_buf_mark_corrupt(agibp);
> -		return -EFSCORRUPTED;
> -	}
> -
> -	ip->i_prev_unlinked = NULLAGINO;
> -	ip->i_next_unlinked = next_agino;
> -	if (ip->i_next_unlinked != NULLAGINO) {
> -		struct xfs_inode	*nip;
> +	mutex_lock(&pag->pag_unlinked_mutex);
> +	pip = pag->pag_unlinked_tail;
> +	if (!pip) {
> +		struct xfs_buf	*agibp;
>  
> -		nip = xfs_iunlink_lookup_next(agibp->b_pag, ip);
> -		if (IS_ERR_OR_NULL(nip))
> -			return -EFSCORRUPTED;
> +		mutex_unlock(&pag->pag_unlinked_mutex);
>  
> -		if (nip->i_prev_unlinked != NULLAGINO) {
> -			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> -						NULL, 0, __this_address);
> -			return -EFSCORRUPTED;
> +		/*
> +		 * there could be some race, but it doesn't matter though
> +		 * since !pip doesn't happen frequently.
> +		 */
> +		error = xfs_read_agi(mp, tp, agno, &agibp);
> +		if (error) {
> +			xfs_perag_put(pag);
> +			return error;
>  		}
> -		nip->i_prev_unlinked = agino;
>  
> -		/* update the on disk inode now */
> -		xfs_iunlink_log(tp, ip);
> -	}
> +		mutex_lock(&pag->pag_unlinked_mutex);
> +		pip = pag->pag_unlinked_tail;
> +		if (!pip) {
> +			struct xfs_agi	*agi;
> +
> +			ip->i_prev_unlinked = NULLAGINO;
>  
> -	/* Point the head of the list to point to this inode. */
> -	return xfs_iunlink_update_bucket(tp, agno, agibp, next_agino, agino);
> +			agi = agibp->b_addr;
> +			ASSERT(be32_to_cpu(agi->agi_unlinked[0]) == NULLAGINO);
> +
> +			/* Point the head of the list to point to this inode. */
> +			error = xfs_iunlink_update_bucket(tp, agno,
> +					agibp, NULLAGINO, agino);
> +			goto out;
> +		}
> +	}
> +	ip->i_prev_unlinked = XFS_INO_TO_AGINO(mp, pip->i_ino);
> +	ASSERT(pip->i_next_unlinked == NULLAGINO);
> +	pip->i_next_unlinked = agino;
> +	xfs_iunlink_log(tp, pip);
> +out:
> +	ip->i_next_unlinked = NULLAGINO;
> +	pag->pag_unlinked_tail = ip;
> +	mutex_unlock(&pag->pag_unlinked_mutex);
> +	xfs_perag_put(pag);
> +	return 0;
>  }
>  
>  /*
> + * Pull the on-disk inode from the AGI unlinked list.
> + *
>   * Remove can be from anywhere in the list, so we have to do two adjacent inode
>   * lookups here so we can update list pointers. We may be at the head or the
>   * tail of the list, so we have to handle those cases as well.
>   */
> -static int
> -xfs_iunlink_remove_inode(
> +STATIC int
> +xfs_iunlink_remove(
>  	struct xfs_trans	*tp,
> -	struct xfs_buf		*agibp,
>  	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	xfs_agino_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> +	struct xfs_perag	*pag;
> +	struct xfs_inode	*pip = NULL;
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> -	xfs_agino_t		next_agino = ip->i_next_unlinked;
> +	xfs_agino_t		next_agino;
>  	int			error;
>  
> +	trace_xfs_iunlink_remove(ip);
> +
> +	pag = xfs_perag_get(mp, agno);
> +	mutex_lock(&pag->pag_unlinked_mutex);
> +
> +	/* see the comment in xfs_iunlink() on the only proper locking order */
>  	if (ip->i_prev_unlinked == NULLAGINO) {
> -		/* remove from head of list */
> -		if (next_agino == agino ||
> -		    !xfs_verify_agino_or_null(mp, agno, next_agino))
> -			return -EFSCORRUPTED;
> +		struct xfs_buf	*agibp;
>  
> -		error = xfs_iunlink_update_bucket(tp, agno, agibp, agino, next_agino);
> -		if (error)
> +		mutex_unlock(&pag->pag_unlinked_mutex);
> +
> +		error = xfs_read_agi(mp, tp, agno, &agibp);
> +		if (error) {
> +			xfs_perag_put(pag);
>  			return error;
> -	} else {
> -		/* lookup previous inode and update to point at next */
> -		struct xfs_inode	*pip;
> +		}
>  
> -		pip = xfs_iunlink_lookup_prev(agibp->b_pag, ip);
> -		if (IS_ERR_OR_NULL(pip))
> -			return -EFSCORRUPTED;
> +		mutex_lock(&pag->pag_unlinked_mutex);
> +		if (ip->i_prev_unlinked == NULLAGINO) {
> +			struct xfs_agi	*agi;
>  
> -		if (pip->i_next_unlinked != agino) {
> -			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> -						NULL, 0, __this_address);
> -			return -EFSCORRUPTED;
> +			next_agino = ip->i_next_unlinked;
> +			agi = agibp->b_addr;
> +
> +			/* remove from head of list */
> +			if (next_agino == agino ||
> +			    !xfs_verify_agino_or_null(mp, agno, next_agino))
> +				goto err_fscorrupted;
> +
> +			error = xfs_iunlink_update_bucket(tp, agno,
> +				agibp, agino, next_agino);
> +			if (error)
> +				goto err_out;
> +
> +			goto next_fixup;
>  		}
> +	}
>  
> -		/* update the on disk inode now */
> -		pip->i_next_unlinked = next_agino;
> -		xfs_iunlink_log(tp, pip);
> +	next_agino = ip->i_next_unlinked;
> +
> +	/* lookup previous inode and update to point at next */
> +	pip = xfs_iunlink_lookup_prev(pag, ip);
> +	if (IS_ERR_OR_NULL(pip))
> +		goto err_fscorrupted;
> +
> +	if (pip->i_next_unlinked != agino) {
> +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> +					NULL, 0, __this_address);
> +		goto err_fscorrupted;
>  	}
> +	pip->i_next_unlinked = next_agino;
> +	xfs_iunlink_log(tp, pip);
>  
> -	/* lookup the next inode and update to point at prev */
> -	if (ip->i_next_unlinked != NULLAGINO) {
> +next_fixup:
> +	if (next_agino == NULLAGINO) {
> +		/* so iunlink recovery can work here */
> +		if (pag->pag_unlinked_tail == ip)
> +			pag->pag_unlinked_tail = pip;
> +	} else {
> +		/* lookup the next inode and update to point at prev */
>  		struct xfs_inode	*nip;
>  
> -		nip = xfs_iunlink_lookup_next(agibp->b_pag, ip);
> +		nip = xfs_iunlink_lookup_next(pag, ip);
>  		if (IS_ERR_OR_NULL(nip))
> -			return -EFSCORRUPTED;
> +			goto err_fscorrupted;
>  
>  		if (nip->i_prev_unlinked != agino) {
>  			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
>  						NULL, 0, __this_address);
> -			return -EFSCORRUPTED;
> +			goto err_fscorrupted;
>  		}
>  		/* in memory update only */
>  		nip->i_prev_unlinked = ip->i_prev_unlinked;
>  	}
> +	mutex_unlock(&pag->pag_unlinked_mutex);
> +	xfs_perag_put(pag);
>  
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  	/*
>  	 * Now clear prev/next from this inode and update on disk if we
>  	 * need to clear the on-disk link.
>  	 */
>  	ip->i_prev_unlinked = NULLAGINO;
> -	ip->i_next_unlinked = NULLAGINO;
> -	if (next_agino != NULLAGINO)
> +	if (next_agino != NULLAGINO) {
> +		ip->i_next_unlinked = NULLAGINO;
>  		xfs_iunlink_log(tp, ip);
> +	}
>  	return 0;
> -}
>  
> -/*
> - * This is called when the inode's link count has gone to 0 or we are creating
> - * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
> - *
> - * We place the on-disk inode on a list in the AGI.  It will be pulled from this
> - * list when the inode is freed.
> - */
> -STATIC int
> -xfs_iunlink(
> -	struct xfs_trans	*tp,
> -	struct xfs_inode	*ip)
> -{
> -	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_buf		*agibp;
> -	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> -	int			error;
> -
> -	ASSERT(ip->i_next_unlinked == NULLAGINO);
> -	ASSERT(VFS_I(ip)->i_nlink == 0);
> -	ASSERT(VFS_I(ip)->i_mode != 0);
> -	trace_xfs_iunlink(ip);
> -
> -	/* Get the agi buffer first.  It ensures lock ordering on the list. */
> -	error = xfs_read_agi(mp, tp, agno, &agibp);
> -	if (error)
> -		return error;
> -
> -	return xfs_iunlink_insert_inode(tp, agibp, ip);
> -}
> -
> -/*
> - * Pull the on-disk inode from the AGI unlinked list.
> - */
> -STATIC int
> -xfs_iunlink_remove(
> -	struct xfs_trans	*tp,
> -	struct xfs_inode	*ip)
> -{
> -	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_buf		*agibp;
> -	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> -	int			error;
> -
> -	trace_xfs_iunlink_remove(ip);
> -
> -	/* Get the agi buffer first.  It ensures lock ordering on the list. */
> -	error = xfs_read_agi(mp, tp, agno, &agibp);
> -	if (error)
> -		return error;
> -
> -	return xfs_iunlink_remove_inode(tp, agibp, ip);
> +err_fscorrupted:
> +	error = -EFSCORRUPTED;
> +err_out:
> +	mutex_unlock(&pag->pag_unlinked_mutex);
> +	xfs_perag_put(pag);
> +	return error;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index d47eea31c165..3f2739316424 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2801,6 +2801,11 @@ xlog_recover_iunlink_ag(
>  					prev_ip->i_next_unlinked = NULLAGINO;
>  				break;
>  			}
> +
> +			/* XXX: take pag_unlinked_mutex across the loop? */
> +			if (!bucket)
> +				agibp->b_pag->pag_unlinked_tail = ip;
> +
>  			if (prev_ip) {
>  				ip->i_prev_unlinked = prev_agino;
>  				xfs_irele(prev_ip);
> @@ -2812,6 +2817,7 @@ xlog_recover_iunlink_ag(
>  		}
>  		if (prev_ip)
>  			xfs_irele(prev_ip);
> +
>  		if (error) {
>  			/*
>  			 * We can't read an inode this bucket points to, or an
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 031e96ff022d..a9701f863e84 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -223,6 +223,9 @@ xfs_initialize_perag(
>  		if (first_initialised == NULLAGNUMBER)
>  			first_initialised = index;
>  		spin_lock_init(&pag->pag_state_lock);
> +
> +		mutex_init(&pag->pag_unlinked_mutex);
> +		pag->pag_unlinked_tail = NULL;
>  	}
>  
>  	index = xfs_set_inode_alloc(mp, agcount);
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index a72cfcaa4ad1..107a634a34f7 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -372,6 +372,9 @@ typedef struct xfs_perag {
>  	/* reference count */
>  	uint8_t			pagf_refcount_level;
>  
> +	struct mutex		pag_unlinked_mutex;
> +	struct xfs_inode	*pag_unlinked_tail;

What do these fields do?  There aren't any comments....

--D

> +
>  	/*
>  	 * Unlinked inode information.  This incore information reflects
>  	 * data stored in the AGI, so callers must hold the AGI buffer lock
> -- 
> 2.18.1
> 
