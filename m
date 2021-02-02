Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D87FC433E9
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 13:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2768464F51
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 13:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhBBNSw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 08:18:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33987 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232040AbhBBNSo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 08:18:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612271836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3LsI5ltXA+XkY6iUN33p+Qcx0iXoEjuVAF2ijVCbdwE=;
        b=grOZS4QNDXeeBze4Y4LzYIf8Fi0ut+FxYGZKvQcMvNPhGkrauE/uis97e5I3eQYTkSYvqk
        W8JZbs5Myx9RZXu3wwXvKWdxYyn2utC4p4KvA9f02jLzwpIhsuwuBaSveApR+G3nwC+5DU
        282sfsFv1ug2/z0c1BbEAh8/7cys+Ow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-n9coHmRyMeKJBfpoYVz5JA-1; Tue, 02 Feb 2021 08:13:26 -0500
X-MC-Unique: n9coHmRyMeKJBfpoYVz5JA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 544F79CDC2;
        Tue,  2 Feb 2021 13:13:25 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F03A60C05;
        Tue,  2 Feb 2021 13:13:24 +0000 (UTC)
Date:   Tue, 2 Feb 2021 08:13:22 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 13/16] xfs: refactor inode ownership change
 transaction/inode/quota allocation idiom
Message-ID: <20210202131322.GC3336100@bfoster>
References: <161223139756.491593.10895138838199018804.stgit@magnolia>
 <161223147171.491593.1153393231638526420.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161223147171.491593.1153393231638526420.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 01, 2021 at 06:04:31PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> For file ownership (uid, gid, prid) changes, create a new helper
> xfs_trans_alloc_ichange that allocates a transaction and reserves the
> appropriate amount of quota against that transction in preparation for a
> change of user, group, or project id.  Replace all the open-coded idioms
> with a single call to this helper so that we can contain the retry loops
> in the next patchset.
> 
> This changes the locking behavior for ichange transactions slightly.
> Since tr_ichange does not have a permanent reservation and cannot roll,
> we pass XFS_ILOCK_EXCL to ijoin so that the inode will be unlocked
> automatically at commit time.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_ioctl.c |   29 ++++++++----------------
>  fs/xfs/xfs_iops.c  |   26 ++--------------------
>  fs/xfs/xfs_trans.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_trans.h |    3 +++
>  4 files changed, 77 insertions(+), 43 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 3fbd98f61ea5..78ee201eb7cb 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1275,24 +1275,23 @@ xfs_ioctl_setattr_prepare_dax(
>   */
>  static struct xfs_trans *
>  xfs_ioctl_setattr_get_trans(
> -	struct xfs_inode	*ip)
> +	struct xfs_inode	*ip,
> +	struct xfs_dquot	*pdqp)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
>  	int			error = -EROFS;
>  
>  	if (mp->m_flags & XFS_MOUNT_RDONLY)
> -		goto out_unlock;
> +		goto out_error;
>  	error = -EIO;
>  	if (XFS_FORCED_SHUTDOWN(mp))
> -		goto out_unlock;
> +		goto out_error;
>  
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
> +	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
> +			capable(CAP_FOWNER), &tp);
>  	if (error)
> -		goto out_unlock;
> -
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +		goto out_error;
>  
>  	/*
>  	 * CAP_FOWNER overrides the following restrictions:
> @@ -1312,7 +1311,7 @@ xfs_ioctl_setattr_get_trans(
>  
>  out_cancel:
>  	xfs_trans_cancel(tp);
> -out_unlock:
> +out_error:
>  	return ERR_PTR(error);
>  }
>  
> @@ -1462,20 +1461,12 @@ xfs_ioctl_setattr(
>  
>  	xfs_ioctl_setattr_prepare_dax(ip, fa);
>  
> -	tp = xfs_ioctl_setattr_get_trans(ip);
> +	tp = xfs_ioctl_setattr_get_trans(ip, pdqp);
>  	if (IS_ERR(tp)) {
>  		code = PTR_ERR(tp);
>  		goto error_free_dquots;
>  	}
>  
> -	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
> -	    ip->i_d.di_projid != fa->fsx_projid) {
> -		code = xfs_qm_vop_chown_reserve(tp, ip, NULL, NULL, pdqp,
> -				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
> -		if (code)	/* out of quota */
> -			goto error_trans_cancel;
> -	}
> -
>  	xfs_fill_fsxattr(ip, false, &old_fa);
>  	code = vfs_ioc_fssetxattr_check(VFS_I(ip), &old_fa, fa);
>  	if (code)
> @@ -1608,7 +1599,7 @@ xfs_ioc_setxflags(
>  
>  	xfs_ioctl_setattr_prepare_dax(ip, &fa);
>  
> -	tp = xfs_ioctl_setattr_get_trans(ip);
> +	tp = xfs_ioctl_setattr_get_trans(ip, NULL);
>  	if (IS_ERR(tp)) {
>  		error = PTR_ERR(tp);
>  		goto out_drop_write;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index f1e21b6cfa48..00369502fe25 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -700,13 +700,11 @@ xfs_setattr_nonsize(
>  			return error;
>  	}
>  
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
> +	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
> +			capable(CAP_FOWNER), &tp);
>  	if (error)
>  		goto out_dqrele;
>  
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, ip, 0);
> -
>  	/*
>  	 * Change file ownership.  Must be the owner or privileged.
>  	 */
> @@ -722,21 +720,6 @@ xfs_setattr_nonsize(
>  		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
>  		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
>  
> -		/*
> -		 * Do a quota reservation only if uid/gid is actually
> -		 * going to change.
> -		 */
> -		if (XFS_IS_QUOTA_RUNNING(mp) &&
> -		    ((XFS_IS_UQUOTA_ON(mp) && !uid_eq(iuid, uid)) ||
> -		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)))) {
> -			ASSERT(tp);
> -			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
> -						NULL, capable(CAP_FOWNER) ?
> -						XFS_QMOPT_FORCE_RES : 0);
> -			if (error)	/* out of quota */
> -				goto out_cancel;
> -		}
> -
>  		/*
>  		 * CAP_FSETID overrides the following restrictions:
>  		 *
> @@ -786,8 +769,6 @@ xfs_setattr_nonsize(
>  		xfs_trans_set_sync(tp);
>  	error = xfs_trans_commit(tp);
>  
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -
>  	/*
>  	 * Release any dquot(s) the inode had kept before chown.
>  	 */
> @@ -814,9 +795,6 @@ xfs_setattr_nonsize(
>  
>  	return 0;
>  
> -out_cancel:
> -	xfs_trans_cancel(tp);
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  out_dqrele:
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 6c68635cc6ac..60672b5545c9 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1107,3 +1107,65 @@ xfs_trans_alloc_icreate(
>  	*tpp = tp;
>  	return 0;
>  }
> +
> +/*
> + * Allocate an transaction, lock and join the inode to it, and reserve quota
> + * in preparation for inode attribute changes that include uid, gid, or prid
> + * changes.
> + *
> + * The caller must ensure that the on-disk dquots attached to this inode have
> + * already been allocated and initialized.  The ILOCK will be dropped when the
> + * transaction is committed or cancelled.
> + */
> +int
> +xfs_trans_alloc_ichange(
> +	struct xfs_inode	*ip,
> +	struct xfs_dquot	*udqp,
> +	struct xfs_dquot	*gdqp,
> +	struct xfs_dquot	*pdqp,
> +	bool			force,
> +	struct xfs_trans	**tpp)
> +{
> +	struct xfs_trans	*tp;
> +	struct xfs_mount	*mp = ip->i_mount;
> +	int			error;
> +
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
> +	if (error)
> +		return error;
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +
> +	error = xfs_qm_dqattach_locked(ip, false);
> +	if (error) {
> +		/* Caller should have allocated the dquots! */
> +		ASSERT(error != -ENOENT);
> +		goto out_cancel;
> +	}
> +
> +	/*
> +	 * For each quota type, skip quota reservations if the inode's dquots
> +	 * now match the ones that came from the caller, or the caller didn't
> +	 * pass one in.
> +	 */
> +	if (udqp == ip->i_udquot)
> +		udqp = NULL;
> +	if (gdqp == ip->i_gdquot)
> +		gdqp = NULL;
> +	if (pdqp == ip->i_pdquot)
> +		pdqp = NULL;
> +	if (udqp || gdqp || pdqp) {
> +		error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp, pdqp,
> +				force ? XFS_QMOPT_FORCE_RES : 0);
> +		if (error)
> +			goto out_cancel;
> +	}
> +
> +	*tpp = tp;
> +	return 0;
> +
> +out_cancel:
> +	xfs_trans_cancel(tp);
> +	return error;
> +}
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 04c132c55e9b..8b03fbfe9a1b 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -277,5 +277,8 @@ int xfs_trans_alloc_icreate(struct xfs_mount *mp, struct xfs_trans_res *resv,
>  		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
>  		struct xfs_dquot *pdqp, unsigned int dblocks,
>  		struct xfs_trans **tpp);
> +int xfs_trans_alloc_ichange(struct xfs_inode *ip, struct xfs_dquot *udqp,
> +		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp, bool force,
> +		struct xfs_trans **tpp);
>  
>  #endif	/* __XFS_TRANS_H__ */
> 

