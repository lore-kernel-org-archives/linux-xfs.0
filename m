Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6936C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8223964E21
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbhA1S0c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 13:26:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49002 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232008AbhA1SY0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 13:24:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611858179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P0W96pfj75TC7OV72WqnFNEVO+/m67+7TzGf9HnCzs4=;
        b=aGKwB2R21IToCiiRcRrDe2N6s1JR1B+oUQH4YIlwQHnepiHutq3I6IkkaOgEsELi3aSXj5
        LgJU/Rh93Ef2zQ8iVVwMscsesHhO06DgqQ16kZ3yKb97g02mkVGQUzNmJM8ickF3Egp/Wj
        pd0wghmlHvaxYzFn8FnX7bTHBzfBGOE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-xyA9R1GoNJmzekpaFvsZQQ-1; Thu, 28 Jan 2021 13:22:54 -0500
X-MC-Unique: xyA9R1GoNJmzekpaFvsZQQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69A1D809DD3;
        Thu, 28 Jan 2021 18:22:53 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B96915D9F1;
        Thu, 28 Jan 2021 18:22:52 +0000 (UTC)
Date:   Thu, 28 Jan 2021 13:22:50 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 07/13] xfs: refactor common transaction/inode/quota
 allocation idiom
Message-ID: <20210128182250.GF2619139@bfoster>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181370409.1523592.1925953061702139800.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181370409.1523592.1925953061702139800.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 10:01:44PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a new helper xfs_trans_alloc_inode that allocates a transaction,
> locks and joins an inode to it, and then reserves the appropriate amount
> of quota against that transction.  Then replace all the open-coded
> idioms with a single call to this helper.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c |   11 +----------
>  fs/xfs/libxfs/xfs_bmap.c |   10 ++--------
>  fs/xfs/xfs_bmap_util.c   |   14 +++----------
>  fs/xfs/xfs_iomap.c       |   11 ++---------
>  fs/xfs/xfs_trans.c       |   48 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_trans.h       |    3 +++
>  6 files changed, 59 insertions(+), 38 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index e05dc0bc4a8f..cb95bc77fe59 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -458,14 +458,10 @@ xfs_attr_set(
>  	 * Root fork attributes can use reserved data blocks for this
>  	 * operation if necessary
>  	 */
> -	error = xfs_trans_alloc(mp, &tres, total, 0,
> -			rsvd ? XFS_TRANS_RESERVE : 0, &args->trans);
> +	error = xfs_trans_alloc_inode(dp, &tres, total, rsvd, &args->trans);
>  	if (error)
>  		return error;
>  
> -	xfs_ilock(dp, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(args->trans, dp, 0);
> -
>  	if (args->value || xfs_inode_hasattr(dp)) {
>  		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
>  				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> @@ -474,11 +470,6 @@ xfs_attr_set(
>  	}
>  
>  	if (args->value) {
> -		error = xfs_trans_reserve_quota_nblks(args->trans, dp,
> -				args->total, 0, rsvd);
> -		if (error)
> -			goto out_trans_cancel;
> -
>  		error = xfs_has_attr(args);
>  		if (error == -EEXIST && (args->attr_flags & XATTR_CREATE))
>  			goto out_trans_cancel;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 043bb8c634b0..f78fa694f3c2 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1079,19 +1079,13 @@ xfs_bmap_add_attrfork(
>  
>  	blks = XFS_ADDAFORK_SPACE_RES(mp);
>  
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_addafork, blks, 0,
> -			rsvd ? XFS_TRANS_RESERVE : 0, &tp);
> +	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_addafork, blks,
> +			rsvd, &tp);
>  	if (error)
>  		return error;
> -
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd);
> -	if (error)
> -		goto trans_cancel;
>  	if (XFS_IFORK_Q(ip))
>  		goto trans_cancel;
>  
> -	xfs_trans_ijoin(tp, ip, 0);
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	error = xfs_bmap_set_attrforkoff(ip, size, &version);
>  	if (error)
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index d54d9f02d3dd..94ffdeb2dd73 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -873,18 +873,10 @@ xfs_unmap_extent(
>  	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
>  	int			error;
>  
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
> -	if (error) {
> -		ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
> -		return error;
> -	}
> -
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0, false);
> +	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks,
> +			false, &tp);
>  	if (error)
> -		goto out_trans_cancel;
> -
> -	xfs_trans_ijoin(tp, ip, 0);
> +		return error;
>  
>  	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
>  			XFS_IEXT_PUNCH_HOLE_CNT);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index ef29d44c656a..05de1be20426 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -552,18 +552,11 @@ xfs_iomap_write_unwritten(
>  		 * here as we might be asked to write out the same inode that we
>  		 * complete here and might deadlock on the iolock.
>  		 */
> -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
> -				XFS_TRANS_RESERVE, &tp);
> +		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks,
> +				true, &tp);
>  		if (error)
>  			return error;
>  
> -		xfs_ilock(ip, XFS_ILOCK_EXCL);
> -		xfs_trans_ijoin(tp, ip, 0);
> -
> -		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0, true);
> -		if (error)
> -			goto error_on_bmapi_transaction;
> -
>  		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
>  				XFS_IEXT_WRITE_UNWRITTEN_CNT);
>  		if (error)
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index e72730f85af1..156b9ed8534f 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -20,6 +20,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_error.h"
>  #include "xfs_defer.h"
> +#include "xfs_inode.h"
>  
>  kmem_zone_t	*xfs_trans_zone;
>  
> @@ -1024,3 +1025,50 @@ xfs_trans_roll(
>  	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>  	return xfs_trans_reserve(*tpp, &tres, 0, 0);
>  }
> +
> +/*
> + * Allocate an transaction, lock and join the inode to it, and reserve quota.
> + *
> + * The caller must ensure that the on-disk dquots attached to this inode have
> + * already been allocated and initialized.  The caller is responsible for
> + * releasing ILOCK_EXCL if a new transaction is returned.
> + */
> +int
> +xfs_trans_alloc_inode(
> +	struct xfs_inode	*ip,
> +	struct xfs_trans_res	*resv,
> +	unsigned int		dblocks,
> +	bool			force,
> +	struct xfs_trans	**tpp)
> +{
> +	struct xfs_trans	*tp;
> +	struct xfs_mount	*mp = ip->i_mount;
> +	int			error;
> +
> +	error = xfs_trans_alloc(mp, resv, dblocks, 0,
> +			force ? XFS_TRANS_RESERVE : 0, &tp);
> +	if (error)
> +		return error;
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
> +
> +	error = xfs_qm_dqattach_locked(ip, false);
> +	if (error) {
> +		/* Caller should have allocated the dquots! */
> +		ASSERT(error != -ENOENT);
> +		goto out_cancel;
> +	}
> +
> +	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, 0, force);
> +	if (error)
> +		goto out_cancel;
> +
> +	*tpp = tp;
> +	return 0;
> +
> +out_cancel:
> +	xfs_trans_cancel(tp);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	return error;
> +}
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 084658946cc8..aa50be244432 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -268,4 +268,7 @@ xfs_trans_item_relog(
>  	return lip->li_ops->iop_relog(lip, tp);
>  }
>  
> +int xfs_trans_alloc_inode(struct xfs_inode *ip, struct xfs_trans_res *resv,
> +		unsigned int dblocks, bool force, struct xfs_trans **tpp);
> +
>  #endif	/* __XFS_TRANS_H__ */
> 

