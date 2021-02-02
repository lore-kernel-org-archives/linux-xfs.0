Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E04C4332B
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 13:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BF4264F61
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 13:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhBBNSw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 08:18:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25543 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232324AbhBBNSp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 08:18:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612271835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=or/hFDgGWIIYHIt7niJsJ71Fgj1/BKRyV6I3/bPGi3I=;
        b=iICpEiogBPn8jLwG57b5sw16zzcQ6V9wI1YIEQ2JT2WqBnEPpDPcd72/Ykye1fEYDXxfI6
        N0ooZNODYOIX/kUWQyxw50ZLDFcS7UmoaCMYILbJTc5+Yuqx4fMzx5n314zqk1JxIMqLCf
        7p5Nolfnop2op9gVONNire7QN2uNhYI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-S7AbuQzuOVek538obwTQCQ-1; Tue, 02 Feb 2021 08:13:19 -0500
X-MC-Unique: S7AbuQzuOVek538obwTQCQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDEA919611C1;
        Tue,  2 Feb 2021 13:13:17 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C73E5D9D5;
        Tue,  2 Feb 2021 13:13:16 +0000 (UTC)
Date:   Tue, 2 Feb 2021 08:13:15 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 01/16] xfs: fix chown leaking delalloc quota blocks when
 fssetxattr fails
Message-ID: <20210202131315.GB3336100@bfoster>
References: <161223139756.491593.10895138838199018804.stgit@magnolia>
 <161223140369.491593.14536007914189520446.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161223140369.491593.14536007914189520446.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 01, 2021 at 06:03:23PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While refactoring the quota code to create a function to allocate inode
> change transactions, I noticed that xfs_qm_vop_chown_reserve does more
> than just make reservations: it also *modifies* the incore counts
> directly to handle the owner id change for the delalloc blocks.
> 
> I then observed that the fssetxattr code continues validating input
> arguments after making the quota reservation but before dirtying the
> transaction.  If the routine decides to error out, it fails to undo the
> accounting switch!  This leads to incorrect quota reservation and
> failure down the line.
> 
> We can fix this by making the reservation function do only that -- for
> the new dquot, it reserves ondisk and delalloc blocks to the
> transaction, and the old dquot hangs on to its incore reservation for
> now.  Once we actually switch the dquots, we can then update the incore
> reservations because we've dirtied the transaction and it's too late to
> turn back now.
> 
> No fixes tag because this has been broken since the start of git.
> 

Do we have any test coverage for this problem?

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_qm.c |   91 +++++++++++++++++++++----------------------------------
>  1 file changed, 34 insertions(+), 57 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index c134eb4aeaa8..322d337b5dca 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1785,6 +1785,28 @@ xfs_qm_vop_chown(
>  	xfs_trans_mod_dquot(tp, newdq, bfield, ip->i_d.di_nblocks);
>  	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_ICOUNT, 1);
>  
> +	/*
> +	 * Back when we made quota reservations for the chown, we reserved the
> +	 * ondisk blocks + delalloc blocks with the new dquot.  Now that we've
> +	 * switched the dquots, decrease the new dquot's block reservation
> +	 * (having already bumped up the real counter) so that we don't have
> +	 * any reservation to give back when we commit.
> +	 */
> +	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_RES_BLKS,
> +			-ip->i_delayed_blks);
> +

Ok, so the reservation code code below continues to reserve di_blocks
and delalloc blocks as it did before, but associates it with the
transaction and no longer reduces delalloc reservation from the old
dquots. Instead, this function increases the consumption of reserved
blocks for di_blocks and then removes the additional quota reservation
from the transaction, but not the new dquots. Thus when the transaction
commits, this has the side effect of leaving additional reservation on
the new dquots that correspond to the delalloc blocks on the inode. Am I
following that correctly?

> +	/*
> +	 * Give the incore reservation for delalloc blocks back to the old
> +	 * dquot.  We don't normally handle delalloc quota reservations
> +	 * transactionally, so just lock the dquot and subtract from the
> +	 * reservation.  We've dirtied the transaction, so it's too late to
> +	 * turn back now.
> +	 */
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	xfs_dqlock(prevdq);
> +	prevdq->q_blk.reserved -= ip->i_delayed_blks;
> +	xfs_dqunlock(prevdq);
> +

What's the reason for not using xfs_trans_reserve_quota_bydquots(NULL,
...) here like the original code?

Brian

>  	/*
>  	 * Take an extra reference, because the inode is going to keep
>  	 * this dquot pointer even after the trans_commit.
> @@ -1807,84 +1829,39 @@ xfs_qm_vop_chown_reserve(
>  	uint			flags)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	uint64_t		delblks;
>  	unsigned int		blkflags;
> -	struct xfs_dquot	*udq_unres = NULL;
> -	struct xfs_dquot	*gdq_unres = NULL;
> -	struct xfs_dquot	*pdq_unres = NULL;
>  	struct xfs_dquot	*udq_delblks = NULL;
>  	struct xfs_dquot	*gdq_delblks = NULL;
>  	struct xfs_dquot	*pdq_delblks = NULL;
> -	int			error;
> -
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
>  	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
>  
> -	delblks = ip->i_delayed_blks;
>  	blkflags = XFS_IS_REALTIME_INODE(ip) ?
>  			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
>  
>  	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
> -	    i_uid_read(VFS_I(ip)) != udqp->q_id) {
> +	    i_uid_read(VFS_I(ip)) != udqp->q_id)
>  		udq_delblks = udqp;
> -		/*
> -		 * If there are delayed allocation blocks, then we have to
> -		 * unreserve those from the old dquot, and add them to the
> -		 * new dquot.
> -		 */
> -		if (delblks) {
> -			ASSERT(ip->i_udquot);
> -			udq_unres = ip->i_udquot;
> -		}
> -	}
> +
>  	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
> -	    i_gid_read(VFS_I(ip)) != gdqp->q_id) {
> +	    i_gid_read(VFS_I(ip)) != gdqp->q_id)
>  		gdq_delblks = gdqp;
> -		if (delblks) {
> -			ASSERT(ip->i_gdquot);
> -			gdq_unres = ip->i_gdquot;
> -		}
> -	}
>  
>  	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
> -	    ip->i_d.di_projid != pdqp->q_id) {
> +	    ip->i_d.di_projid != pdqp->q_id)
>  		pdq_delblks = pdqp;
> -		if (delblks) {
> -			ASSERT(ip->i_pdquot);
> -			pdq_unres = ip->i_pdquot;
> -		}
> -	}
> -
> -	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
> -				udq_delblks, gdq_delblks, pdq_delblks,
> -				ip->i_d.di_nblocks, 1, flags | blkflags);
> -	if (error)
> -		return error;
>  
>  	/*
> -	 * Do the delayed blks reservations/unreservations now. Since, these
> -	 * are done without the help of a transaction, if a reservation fails
> -	 * its previous reservations won't be automatically undone by trans
> -	 * code. So, we have to do it manually here.
> +	 * Reserve enough quota to handle blocks on disk and reserved for a
> +	 * delayed allocation.  We'll actually transfer the delalloc
> +	 * reservation between dquots at chown time, even though that part is
> +	 * only semi-transactional.
>  	 */
> -	if (delblks) {
> -		/*
> -		 * Do the reservations first. Unreservation can't fail.
> -		 */
> -		ASSERT(udq_delblks || gdq_delblks || pdq_delblks);
> -		ASSERT(udq_unres || gdq_unres || pdq_unres);
> -		error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
> -			    udq_delblks, gdq_delblks, pdq_delblks,
> -			    (xfs_qcnt_t)delblks, 0, flags | blkflags);
> -		if (error)
> -			return error;
> -		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
> -				udq_unres, gdq_unres, pdq_unres,
> -				-((xfs_qcnt_t)delblks), 0, blkflags);
> -	}
> -
> -	return 0;
> +	return xfs_trans_reserve_quota_bydquots(tp, ip->i_mount, udq_delblks,
> +			gdq_delblks, pdq_delblks,
> +			ip->i_d.di_nblocks + ip->i_delayed_blks,
> +			1, blkflags | flags);
>  }
>  
>  int
> 

