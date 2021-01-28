Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A492C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67B2064E21
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhA1S1Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 13:27:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23223 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231321AbhA1SZL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 13:25:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611858219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ILP6XjMxzCu2IvVH+kpZRycf379Q+TfELcuvrrd5yU0=;
        b=AY6sjIhA/DJA05hjhelSU44ekQ3S98W5AOjsuyTTfk9rv0Zagx/YUMfVIdJd6Df1Pry0E3
        SzOJTV/KrI8FwBHdZ7FhyhdvKwaIfySG/fe4zW+EBaMWcE5cQouiZ5lP2vcYCTfGCHmYxT
        q12RAZNAVfJXVr9TOAHM998/twf4rZ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-nnU518yTMDmDHrLLSf9qxQ-1; Thu, 28 Jan 2021 13:23:34 -0500
X-MC-Unique: nnU518yTMDmDHrLLSf9qxQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 671DB8042A6;
        Thu, 28 Jan 2021 18:23:33 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A9D83100239A;
        Thu, 28 Jan 2021 18:23:32 +0000 (UTC)
Date:   Thu, 28 Jan 2021 13:23:30 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 12/13] xfs: move xfs_qm_vop_chown_reserve to
 xfs_trans_dquot.c
Message-ID: <20210128182330.GK2619139@bfoster>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181373258.1523592.242724679476042204.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181373258.1523592.242724679476042204.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 10:02:12PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move xfs_qm_vop_chown_reserve to xfs_trans_dquot.c and rename it
> xfs_trans_reserve_quota_chown.  This will enable us to share code with
> the other quota reservation helpers, which will be very useful in the
> next patchset when we implement retry loops.  No functional changes
> here, we're just moving code.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_ioctl.c       |    2 -
>  fs/xfs/xfs_iops.c        |    6 +--
>  fs/xfs/xfs_qm.c          |   93 ----------------------------------------------
>  fs/xfs/xfs_quota.h       |   14 +++++--
>  fs/xfs/xfs_trans_dquot.c |   93 ++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 107 insertions(+), 101 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 3fbd98f61ea5..e299fbd9ef13 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1470,7 +1470,7 @@ xfs_ioctl_setattr(
>  
>  	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
>  	    ip->i_d.di_projid != fa->fsx_projid) {
> -		code = xfs_qm_vop_chown_reserve(tp, ip, NULL, NULL, pdqp,
> +		code = xfs_trans_reserve_quota_chown(tp, ip, NULL, NULL, pdqp,
>  				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
>  		if (code)	/* out of quota */
>  			goto error_trans_cancel;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index f1e21b6cfa48..cb68be87e0a4 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -730,9 +730,9 @@ xfs_setattr_nonsize(
>  		    ((XFS_IS_UQUOTA_ON(mp) && !uid_eq(iuid, uid)) ||
>  		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)))) {
>  			ASSERT(tp);
> -			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
> -						NULL, capable(CAP_FOWNER) ?
> -						XFS_QMOPT_FORCE_RES : 0);
> +			error = xfs_trans_reserve_quota_chown(tp, ip, udqp,
> +					gdqp, NULL, capable(CAP_FOWNER) ?
> +					XFS_QMOPT_FORCE_RES : 0);
>  			if (error)	/* out of quota */
>  				goto out_cancel;
>  		}
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index c134eb4aeaa8..6c2a9fa78e7c 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1794,99 +1794,6 @@ xfs_qm_vop_chown(
>  	return prevdq;
>  }
>  
> -/*
> - * Quota reservations for setattr(AT_UID|AT_GID|AT_PROJID).
> - */
> -int
> -xfs_qm_vop_chown_reserve(
> -	struct xfs_trans	*tp,
> -	struct xfs_inode	*ip,
> -	struct xfs_dquot	*udqp,
> -	struct xfs_dquot	*gdqp,
> -	struct xfs_dquot	*pdqp,
> -	uint			flags)
> -{
> -	struct xfs_mount	*mp = ip->i_mount;
> -	uint64_t		delblks;
> -	unsigned int		blkflags;
> -	struct xfs_dquot	*udq_unres = NULL;
> -	struct xfs_dquot	*gdq_unres = NULL;
> -	struct xfs_dquot	*pdq_unres = NULL;
> -	struct xfs_dquot	*udq_delblks = NULL;
> -	struct xfs_dquot	*gdq_delblks = NULL;
> -	struct xfs_dquot	*pdq_delblks = NULL;
> -	int			error;
> -
> -
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> -	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
> -
> -	delblks = ip->i_delayed_blks;
> -	blkflags = XFS_IS_REALTIME_INODE(ip) ?
> -			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
> -
> -	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
> -	    i_uid_read(VFS_I(ip)) != udqp->q_id) {
> -		udq_delblks = udqp;
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
> -	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
> -	    i_gid_read(VFS_I(ip)) != gdqp->q_id) {
> -		gdq_delblks = gdqp;
> -		if (delblks) {
> -			ASSERT(ip->i_gdquot);
> -			gdq_unres = ip->i_gdquot;
> -		}
> -	}
> -
> -	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
> -	    ip->i_d.di_projid != pdqp->q_id) {
> -		pdq_delblks = pdqp;
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
> -
> -	/*
> -	 * Do the delayed blks reservations/unreservations now. Since, these
> -	 * are done without the help of a transaction, if a reservation fails
> -	 * its previous reservations won't be automatically undone by trans
> -	 * code. So, we have to do it manually here.
> -	 */
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
> -}
> -
>  int
>  xfs_qm_vop_rename_dqattach(
>  	struct xfs_inode	**i_tab)
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index efd04f84d9b4..d3876c71be8f 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -98,9 +98,9 @@ extern void xfs_qm_vop_create_dqattach(struct xfs_trans *, struct xfs_inode *,
>  extern int xfs_qm_vop_rename_dqattach(struct xfs_inode **);
>  extern struct xfs_dquot *xfs_qm_vop_chown(struct xfs_trans *,
>  		struct xfs_inode *, struct xfs_dquot **, struct xfs_dquot *);
> -extern int xfs_qm_vop_chown_reserve(struct xfs_trans *, struct xfs_inode *,
> -		struct xfs_dquot *, struct xfs_dquot *,
> -		struct xfs_dquot *, uint);
> +int xfs_trans_reserve_quota_chown(struct xfs_trans *tp, struct xfs_inode *ip,
> +		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
> +		struct xfs_dquot *pdqp, unsigned int flags);
>  extern int xfs_qm_dqattach(struct xfs_inode *);
>  extern int xfs_qm_dqattach_locked(struct xfs_inode *ip, bool doalloc);
>  extern void xfs_qm_dqdetach(struct xfs_inode *);
> @@ -162,7 +162,13 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
>  #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
>  #define xfs_qm_vop_rename_dqattach(it)					(0)
>  #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
> -#define xfs_qm_vop_chown_reserve(tp, ip, u, g, p, fl)			(0)
> +static inline int
> +xfs_trans_reserve_quota_chown(struct xfs_trans *tp, struct xfs_inode *ip,
> +		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
> +		struct xfs_dquot *pdqp, unsigned int flags)
> +{
> +	return 0;
> +}
>  #define xfs_qm_dqattach(ip)						(0)
>  #define xfs_qm_dqattach_locked(ip, fl)					(0)
>  #define xfs_qm_dqdetach(ip)
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index a1a72b7900c5..88146280a177 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -836,6 +836,99 @@ xfs_trans_reserve_quota_icreate(
>  			dblocks, 1, XFS_QMOPT_RES_REGBLKS);
>  }
>  
> +/*
> + * Quota reservations for setattr(AT_UID|AT_GID|AT_PROJID).
> + */
> +int
> +xfs_trans_reserve_quota_chown(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	struct xfs_dquot	*udqp,
> +	struct xfs_dquot	*gdqp,
> +	struct xfs_dquot	*pdqp,
> +	unsigned int		flags)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	uint64_t		delblks;
> +	unsigned int		blkflags;
> +	struct xfs_dquot	*udq_unres = NULL;
> +	struct xfs_dquot	*gdq_unres = NULL;
> +	struct xfs_dquot	*pdq_unres = NULL;
> +	struct xfs_dquot	*udq_delblks = NULL;
> +	struct xfs_dquot	*gdq_delblks = NULL;
> +	struct xfs_dquot	*pdq_delblks = NULL;
> +	int			error;
> +
> +
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> +	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
> +
> +	delblks = ip->i_delayed_blks;
> +	blkflags = XFS_IS_REALTIME_INODE(ip) ?
> +			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
> +
> +	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
> +	    i_uid_read(VFS_I(ip)) != udqp->q_id) {
> +		udq_delblks = udqp;
> +		/*
> +		 * If there are delayed allocation blocks, then we have to
> +		 * unreserve those from the old dquot, and add them to the
> +		 * new dquot.
> +		 */
> +		if (delblks) {
> +			ASSERT(ip->i_udquot);
> +			udq_unres = ip->i_udquot;
> +		}
> +	}
> +	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
> +	    i_gid_read(VFS_I(ip)) != gdqp->q_id) {
> +		gdq_delblks = gdqp;
> +		if (delblks) {
> +			ASSERT(ip->i_gdquot);
> +			gdq_unres = ip->i_gdquot;
> +		}
> +	}
> +
> +	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
> +	    ip->i_d.di_projid != pdqp->q_id) {
> +		pdq_delblks = pdqp;
> +		if (delblks) {
> +			ASSERT(ip->i_pdquot);
> +			pdq_unres = ip->i_pdquot;
> +		}
> +	}
> +
> +	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
> +				udq_delblks, gdq_delblks, pdq_delblks,
> +				ip->i_d.di_nblocks, 1, flags | blkflags);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Do the delayed blks reservations/unreservations now. Since, these
> +	 * are done without the help of a transaction, if a reservation fails
> +	 * its previous reservations won't be automatically undone by trans
> +	 * code. So, we have to do it manually here.
> +	 */
> +	if (delblks) {
> +		/*
> +		 * Do the reservations first. Unreservation can't fail.
> +		 */
> +		ASSERT(udq_delblks || gdq_delblks || pdq_delblks);
> +		ASSERT(udq_unres || gdq_unres || pdq_unres);
> +		error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
> +			    udq_delblks, gdq_delblks, pdq_delblks,
> +			    (xfs_qcnt_t)delblks, 0, flags | blkflags);
> +		if (error)
> +			return error;
> +		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
> +				udq_unres, gdq_unres, pdq_unres,
> +				-((xfs_qcnt_t)delblks), 0, blkflags);
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * This routine is called to allocate a quotaoff log item.
>   */
> 

