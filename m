Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C13C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B74120772
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:13:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E2oZTfGL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgHSANb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 20:13:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52538 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbgHSANa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 20:13:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J0D4M4097307;
        Wed, 19 Aug 2020 00:13:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=mRWsBd8H99biX7w4x1n5Q8YFukFy0Az4zW9Rby2Fnlw=;
 b=E2oZTfGLGhEBfYZDDSCU6HMlqGkUGiHchfUV/gNnihXhaDzgx5N7+4ivdwgbepNPOVkS
 Mit5/8heCYOht0W3p4L6lzduKQIefUEmf+JDgts90R9qck0oV3mcKWYKPYvs0UDQEjGc
 g8p17/0zg2j7PMkHBs7a5udVH97+/JbaVKm17hCHHaNyikm/deb+HuCQeGgToIiLgpNo
 NPDuM6oesqNq/8g2QaKMZNsYqzKSy6MDMPV/Ssw/Qbn7gOBrKh/ShkDiddRdyaFBVJs+
 3mRt7LqkrPogkkaZbdSve2+pl1g04tBkEJ4er6QmaRiJeEan649b4B/YW5CVRfSeNdwI FA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32x8bn7sbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Aug 2020 00:13:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J07mCB109314;
        Wed, 19 Aug 2020 00:13:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 330pvhsc85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 00:13:26 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07J0DO3q003217;
        Wed, 19 Aug 2020 00:13:24 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 17:13:23 -0700
Date:   Tue, 18 Aug 2020 17:13:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/13] xfs: replace iunlink backref lookups with list
 lookups
Message-ID: <20200819001322.GT6096@magnolia>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092556.2567285-7-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=5 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=5 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 12, 2020 at 07:25:49PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now we have an in memory linked list of all the inodes on the
> unlinked list, use that to look up inodes in the list that we need
> to modify when adding or removing from the list.
> 
> This means we are no longer using the backref cache to maintain the
> previous inode lookups, so we can remove all that infrastructure
> now.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_error.c |   2 -
>  fs/xfs/xfs_inode.c | 327 ++++++++-------------------------------------
>  fs/xfs/xfs_inode.h |   3 -
>  fs/xfs/xfs_mount.c |   5 -
>  fs/xfs/xfs_trace.h |   1 -
>  5 files changed, 54 insertions(+), 284 deletions(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 7f6e20899473..829a89418830 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -162,7 +162,6 @@ XFS_ERRORTAG_ATTR_RW(log_item_pin,	XFS_ERRTAG_LOG_ITEM_PIN);
>  XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_REF);
>  XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
>  XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
> -XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
>  XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
> @@ -200,7 +199,6 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(buf_lru_ref),
>  	XFS_ERRORTAG_ATTR_LIST(force_repair),
>  	XFS_ERRORTAG_ATTR_LIST(bad_summary),
> -	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
>  	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
>  	NULL,
>  };
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index dcf80ac51267..2c930de99561 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1893,196 +1893,29 @@ xfs_inactive(
>   * because we must walk that list to find the inode that points to the inode
>   * being removed from the unlinked hash bucket list.
>   *
> - * What if we modelled the unlinked list as a collection of records capturing
> - * "X.next_unlinked = Y" relations?  If we indexed those records on Y, we'd
> - * have a fast way to look up unlinked list predecessors, which avoids the
> - * slow list walk.  That's exactly what we do here (in-core) with a per-AG
> - * rhashtable.
> + * However, inodes that are on the unlinked list are also guaranteed to be in
> + * memory as they are loaded and then pinned in memory by whatever holds
> + * references to the inode to perform the unlink. Same goes for the O_TMPFILE
> + * usage of the unlinked list - those files are pinned in memory by an open file
> + * descriptor. Hence the inodes on the list are pinned in memory until they are
> + * removed from the list.
>   *
> - * Because this is a backref cache, we ignore operational failures since the
> - * iunlink code can fall back to the slow bucket walk.  The only errors that
> - * should bubble out are for obviously incorrect situations.
> + * That means we can simply use an in-memory double linked list to track inodes
> + * on the unlinked list. As we've removed the scalability problem resulting from
> + * removal on a single linked list requiring traversal, we also no longer use
> + * the on-disk hash to keep traversals short. We just use a single list on disk
> + * now, and track the previous inode in the list in memory.
>   *
> - * All users of the backref cache MUST hold the AGI buffer lock to serialize
> - * access or have otherwise provided for concurrency control.
> - */
> -
> -/* Capture a "X.next_unlinked = Y" relationship. */
> -struct xfs_iunlink {
> -	struct rhash_head	iu_rhash_head;
> -	xfs_agino_t		iu_agino;		/* X */
> -	xfs_agino_t		iu_next_unlinked;	/* Y */
> -};
> -
> -/* Unlinked list predecessor lookup hashtable construction */
> -static int
> -xfs_iunlink_obj_cmpfn(
> -	struct rhashtable_compare_arg	*arg,
> -	const void			*obj)
> -{
> -	const xfs_agino_t		*key = arg->key;
> -	const struct xfs_iunlink	*iu = obj;
> -
> -	if (iu->iu_next_unlinked != *key)
> -		return 1;
> -	return 0;
> -}
> -
> -static const struct rhashtable_params xfs_iunlink_hash_params = {
> -	.min_size		= XFS_AGI_UNLINKED_BUCKETS,
> -	.key_len		= sizeof(xfs_agino_t),
> -	.key_offset		= offsetof(struct xfs_iunlink,
> -					   iu_next_unlinked),
> -	.head_offset		= offsetof(struct xfs_iunlink, iu_rhash_head),
> -	.automatic_shrinking	= true,
> -	.obj_cmpfn		= xfs_iunlink_obj_cmpfn,
> -};
> -
> -/*
> - * Return X, where X.next_unlinked == @agino.  Returns NULLAGINO if no such
> - * relation is found.
> + * To provide the guarantee that inodes are always on this in memory list, log
> + * recovery does what is necessary to populate the list sufficient to perform
> + * removal from the head of the list correctly. As such, we can now always rely
> + * on the in-memory list and if it differs from what we find on disk then we
> + * have a memory corruption problem or a software bug and so mismatches are now
> + * considered EFSCORRUPTION errors and are not recoverable.
> + *
> + * All users of the unlinked list MUST hold the AGI buffer lock to serialize
> + * access to the list.
>   */
> -static xfs_agino_t
> -xfs_iunlink_lookup_backref(
> -	struct xfs_perag	*pag,
> -	xfs_agino_t		agino)
> -{
> -	struct xfs_iunlink	*iu;
> -
> -	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &agino,
> -			xfs_iunlink_hash_params);
> -	return iu ? iu->iu_agino : NULLAGINO;
> -}
> -
> -/*
> - * Take ownership of an iunlink cache entry and insert it into the hash table.
> - * If successful, the entry will be owned by the cache; if not, it is freed.
> - * Either way, the caller does not own @iu after this call.
> - */
> -static int
> -xfs_iunlink_insert_backref(
> -	struct xfs_perag	*pag,
> -	struct xfs_iunlink	*iu)
> -{
> -	int			error;
> -
> -	error = rhashtable_insert_fast(&pag->pagi_unlinked_hash,
> -			&iu->iu_rhash_head, xfs_iunlink_hash_params);
> -	/*
> -	 * Fail loudly if there already was an entry because that's a sign of
> -	 * corruption of in-memory data.  Also fail loudly if we see an error
> -	 * code we didn't anticipate from the rhashtable code.  Currently we
> -	 * only anticipate ENOMEM.
> -	 */
> -	if (error) {
> -		WARN(error != -ENOMEM, "iunlink cache insert error %d", error);
> -		kmem_free(iu);
> -	}
> -	/*
> -	 * Absorb any runtime errors that aren't a result of corruption because
> -	 * this is a cache and we can always fall back to bucket list scanning.
> -	 */
> -	if (error != 0 && error != -EEXIST)
> -		error = 0;
> -	return error;
> -}
> -
> -/* Remember that @prev_agino.next_unlinked = @this_agino. */
> -static int
> -xfs_iunlink_add_backref(
> -	struct xfs_perag	*pag,
> -	xfs_agino_t		prev_agino,
> -	xfs_agino_t		this_agino)
> -{
> -	struct xfs_iunlink	*iu;
> -
> -	if (XFS_TEST_ERROR(false, pag->pag_mount, XFS_ERRTAG_IUNLINK_FALLBACK))
> -		return 0;
> -
> -	iu = kmem_zalloc(sizeof(*iu), KM_NOFS);
> -	iu->iu_agino = prev_agino;
> -	iu->iu_next_unlinked = this_agino;
> -
> -	return xfs_iunlink_insert_backref(pag, iu);
> -}
> -
> -/*
> - * Replace X.next_unlinked = @agino with X.next_unlinked = @next_unlinked.
> - * If @next_unlinked is NULLAGINO, we drop the backref and exit.  If there
> - * wasn't any such entry then we don't bother.
> - */
> -static int
> -xfs_iunlink_change_backref(
> -	struct xfs_perag	*pag,
> -	xfs_agino_t		agino,
> -	xfs_agino_t		next_unlinked)
> -{
> -	struct xfs_iunlink	*iu;
> -	int			error;
> -
> -	/* Look up the old entry; if there wasn't one then exit. */
> -	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &agino,
> -			xfs_iunlink_hash_params);
> -	if (!iu)
> -		return 0;
> -
> -	/*
> -	 * Remove the entry.  This shouldn't ever return an error, but if we
> -	 * couldn't remove the old entry we don't want to add it again to the
> -	 * hash table, and if the entry disappeared on us then someone's
> -	 * violated the locking rules and we need to fail loudly.  Either way
> -	 * we cannot remove the inode because internal state is or would have
> -	 * been corrupt.
> -	 */
> -	error = rhashtable_remove_fast(&pag->pagi_unlinked_hash,
> -			&iu->iu_rhash_head, xfs_iunlink_hash_params);
> -	if (error)
> -		return error;
> -
> -	/* If there is no new next entry just free our item and return. */
> -	if (next_unlinked == NULLAGINO) {
> -		kmem_free(iu);
> -		return 0;
> -	}
> -
> -	/* Update the entry and re-add it to the hash table. */
> -	iu->iu_next_unlinked = next_unlinked;
> -	return xfs_iunlink_insert_backref(pag, iu);
> -}
> -
> -/* Set up the in-core predecessor structures. */
> -int
> -xfs_iunlink_init(
> -	struct xfs_perag	*pag)
> -{
> -	return rhashtable_init(&pag->pagi_unlinked_hash,
> -			&xfs_iunlink_hash_params);
> -}
> -
> -/* Free the in-core predecessor structures. */
> -static void
> -xfs_iunlink_free_item(
> -	void			*ptr,
> -	void			*arg)
> -{
> -	struct xfs_iunlink	*iu = ptr;
> -	bool			*freed_anything = arg;
> -
> -	*freed_anything = true;
> -	kmem_free(iu);
> -}
> -
> -void
> -xfs_iunlink_destroy(
> -	struct xfs_perag	*pag)
> -{
> -	bool			freed_anything = false;
> -
> -	rhashtable_free_and_destroy(&pag->pagi_unlinked_hash,
> -			xfs_iunlink_free_item, &freed_anything);
> -
> -	ASSERT(freed_anything == false || XFS_FORCED_SHUTDOWN(pag->pag_mount));
> -}
>  
>  /*
>   * Point the AGI unlinked bucket at an inode and log the results.  The caller
> @@ -2221,6 +2054,7 @@ xfs_iunlink_insert_inode(
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_agi		*agi;
> +	struct xfs_inode	*nip;
>  	xfs_agino_t		next_agino;
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> @@ -2242,9 +2076,13 @@ xfs_iunlink_insert_inode(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	if (next_agino != NULLAGINO) {
> +	nip = list_first_entry_or_null(&agibp->b_pag->pag_ici_unlink_list,
> +					struct xfs_inode, i_unlink);
> +	if (nip) {
>  		xfs_agino_t		old_agino;
>  
> +		ASSERT(next_agino == XFS_INO_TO_AGINO(mp, nip->i_ino));
> +
>  		/*
>  		 * There is already another inode in the bucket, so point this
>  		 * inode to the current head of the list.
> @@ -2254,14 +2092,8 @@ xfs_iunlink_insert_inode(
>  		if (error)
>  			return error;
>  		ASSERT(old_agino == NULLAGINO);
> -
> -		/*
> -		 * agino has been unlinked, add a backref from the next inode
> -		 * back to agino.
> -		 */
> -		error = xfs_iunlink_add_backref(agibp->b_pag, agino, next_agino);
> -		if (error)
> -			return error;
> +	} else {
> +		ASSERT(next_agino == NULLAGINO);
>  	}
>  
>  	/* Point the head of the list to point to this inode. */
> @@ -2354,70 +2186,24 @@ xfs_iunlink_map_prev(
>  	xfs_agnumber_t		agno,
>  	xfs_agino_t		head_agino,
>  	xfs_agino_t		target_agino,
> -	xfs_agino_t		*agino,
> +	xfs_agino_t		agino,
>  	struct xfs_imap		*imap,
>  	struct xfs_dinode	**dipp,
>  	struct xfs_buf		**bpp,
>  	struct xfs_perag	*pag)
>  {
> -	struct xfs_mount	*mp = tp->t_mountp;
> -	xfs_agino_t		next_agino;
>  	int			error;
>  
>  	ASSERT(head_agino != target_agino);
>  	*bpp = NULL;
>  
> -	/* See if our backref cache can find it faster. */
> -	*agino = xfs_iunlink_lookup_backref(pag, target_agino);
> -	if (*agino != NULLAGINO) {
> -		error = xfs_iunlink_map_ino(tp, agno, *agino, imap, dipp, bpp);
> -		if (error)
> -			return error;
> -
> -		if (be32_to_cpu((*dipp)->di_next_unlinked) == target_agino)
> -			return 0;
> -
> -		/*
> -		 * If we get here the cache contents were corrupt, so drop the
> -		 * buffer and fall back to walking the bucket list.
> -		 */
> -		xfs_trans_brelse(tp, *bpp);
> -		*bpp = NULL;
> -		WARN_ON_ONCE(1);
> -	}
> -
> -	trace_xfs_iunlink_map_prev_fallback(mp, agno);
> -
> -	/* Otherwise, walk the entire bucket until we find it. */
> -	next_agino = head_agino;
> -	while (next_agino != target_agino) {
> -		xfs_agino_t	unlinked_agino;
> -
> -		if (*bpp)
> -			xfs_trans_brelse(tp, *bpp);
> -
> -		*agino = next_agino;
> -		error = xfs_iunlink_map_ino(tp, agno, next_agino, imap, dipp,
> -				bpp);
> -		if (error)
> -			return error;
> -
> -		unlinked_agino = be32_to_cpu((*dipp)->di_next_unlinked);
> -		/*
> -		 * Make sure this pointer is valid and isn't an obvious
> -		 * infinite loop.
> -		 */
> -		if (!xfs_verify_agino(mp, agno, unlinked_agino) ||
> -		    next_agino == unlinked_agino) {
> -			XFS_CORRUPTION_ERROR(__func__,
> -					XFS_ERRLEVEL_LOW, mp,
> -					*dipp, sizeof(**dipp));
> -			error = -EFSCORRUPTED;
> -			return error;
> -		}
> -		next_agino = unlinked_agino;
> -	}
> +	ASSERT(agino != NULLAGINO);
> +	error = xfs_iunlink_map_ino(tp, agno, agino, imap, dipp, bpp);
> +	if (error)
> +		return error;
>  
> +	if (be32_to_cpu((*dipp)->di_next_unlinked) != target_agino)
> +		return -EFSCORRUPTED;

Why drop the corruption report here?

--D

>  	return 0;
>  }
>  
> @@ -2461,27 +2247,31 @@ xfs_iunlink_remove_inode(
>  	if (error)
>  		return error;
>  
> -	/*
> -	 * If there was a backref pointing from the next inode back to this
> -	 * one, remove it because we've removed this inode from the list.
> -	 *
> -	 * Later, if this inode was in the middle of the list we'll update
> -	 * this inode's backref to point from the next inode.
> -	 */
> -	if (next_agino != NULLAGINO) {
> -		error = xfs_iunlink_change_backref(agibp->b_pag, next_agino,
> -				NULLAGINO);
> -		if (error)
> -			return error;
> +#ifdef DEBUG
> +	{
> +	struct xfs_inode *nip = list_next_entry(ip, i_unlink);
> +	if (nip)
> +		ASSERT(next_agino == XFS_INO_TO_AGINO(mp, nip->i_ino));
> +	else
> +		ASSERT(next_agino == NULLAGINO);
>  	}
> +#endif
> +
> +	if (ip != list_first_entry(&agibp->b_pag->pag_ici_unlink_list,
> +					struct xfs_inode, i_unlink)) {
>  
> -	if (head_agino != agino) {
> +		struct xfs_inode *pip;
>  		struct xfs_imap	imap;
>  		xfs_agino_t	prev_agino;
>  
> +		ASSERT(head_agino != agino);
> +
> +		pip = list_prev_entry(ip, i_unlink);
> +		prev_agino = XFS_INO_TO_AGINO(mp, pip->i_ino);
> +
>  		/* We need to search the list for the inode being freed. */
>  		error = xfs_iunlink_map_prev(tp, agno, head_agino, agino,
> -				&prev_agino, &imap, &last_dip, &last_ibp,
> +				prev_agino, &imap, &last_dip, &last_ibp,
>  				agibp->b_pag);
>  		if (error)
>  			return error;
> @@ -2490,16 +2280,7 @@ xfs_iunlink_remove_inode(
>  		xfs_iunlink_update_dinode(tp, agno, prev_agino, last_ibp,
>  				last_dip, &imap, next_agino);
>  
> -		/*
> -		 * Now we deal with the backref for this inode.  If this inode
> -		 * pointed at a real inode, change the backref that pointed to
> -		 * us to point to our old next.  If this inode was the end of
> -		 * the list, delete the backref that pointed to us.  Note that
> -		 * change_backref takes care of deleting the backref if
> -		 * next_agino is NULLAGINO.
> -		 */
> -		return xfs_iunlink_change_backref(agibp->b_pag, agino,
> -				next_agino);
> +		return 0;
>  	}
>  
>  	/* Point the head of the list to the next unlinked inode. */
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 73f36908a1ce..7f8fbb7c8594 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -464,9 +464,6 @@ extern struct kmem_zone	*xfs_inode_zone;
>  /* The default CoW extent size hint. */
>  #define XFS_DEFAULT_COWEXTSZ_HINT 32
>  
> -int xfs_iunlink_init(struct xfs_perag *pag);
> -void xfs_iunlink_destroy(struct xfs_perag *pag);
> -
>  void xfs_end_io(struct work_struct *work);
>  
>  int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 2def15297a5f..f28c969af272 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -146,7 +146,6 @@ xfs_free_perag(
>  		spin_unlock(&mp->m_perag_lock);
>  		ASSERT(pag);
>  		ASSERT(atomic_read(&pag->pag_ref) == 0);
> -		xfs_iunlink_destroy(pag);
>  		xfs_buf_hash_destroy(pag);
>  		call_rcu(&pag->rcu_head, __xfs_free_perag);
>  	}
> @@ -224,9 +223,6 @@ xfs_initialize_perag(
>  		/* first new pag is fully initialized */
>  		if (first_initialised == NULLAGNUMBER)
>  			first_initialised = index;
> -		error = xfs_iunlink_init(pag);
> -		if (error)
> -			goto out_hash_destroy;
>  		spin_lock_init(&pag->pag_state_lock);
>  	}
>  
> @@ -249,7 +245,6 @@ xfs_initialize_perag(
>  		if (!pag)
>  			break;
>  		xfs_buf_hash_destroy(pag);
> -		xfs_iunlink_destroy(pag);
>  		kmem_free(pag);
>  	}
>  	return error;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index abb1d859f226..acddc60f6d88 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3514,7 +3514,6 @@ DEFINE_EVENT(xfs_ag_inode_class, name, \
>  	TP_ARGS(ip))
>  DEFINE_AGINODE_EVENT(xfs_iunlink);
>  DEFINE_AGINODE_EVENT(xfs_iunlink_remove);
> -DEFINE_AG_EVENT(xfs_iunlink_map_prev_fallback);
>  
>  DECLARE_EVENT_CLASS(xfs_fs_corrupt_class,
>  	TP_PROTO(struct xfs_mount *mp, unsigned int flags),
> -- 
> 2.26.2.761.g0e0b3e54be
> 
