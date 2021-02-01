Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E27ECC433E6
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 18:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB57C64EC1
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 18:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhBASpG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 13:45:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230094AbhBASpA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Feb 2021 13:45:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71BA964E2E;
        Mon,  1 Feb 2021 18:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612205058;
        bh=bERrmRoO0KVNgV/Z4IY3ugv3/JUyUCwuwmE2Z1OWNuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EulaTt31Uu30iNLPzoeAUvri/sq438ppnzOAqdrlS9V+luaNOKumWEzylOybaOI/Y
         D225KcYNRwtIxRUMtfa9Yi/pSOtimfighUOOS5LtP9HBU9rj8rSc6GNf1slaHhuodw
         QO0BzV0OzFVFqYGl0b7pS2/mXjo4l9IREdO9GPaiY7BDh1tXBX2RyqVf6QrF6BwkRK
         KEVex+F7cVB9/Tj/RWrth+H9xtt023mNg1hCbTkUNepn6vFZ7b0LwK5wHBhJDEhFXQ
         PCHsXUL8sXUSmALCtNe9VTxyu03ADiHWQPKcT/n7YxITsopnoOGb0B9jh7szBfOHwZ
         ApHsVKdkJzPzA==
Date:   Mon, 1 Feb 2021 10:44:17 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 16/17] xfs: refactor inode creation
 transaction/inode/quota allocation idiom
Message-ID: <20210201184417.GD7193@magnolia>
References: <161214502818.139387.7678025647736002500.stgit@magnolia>
 <161214511852.139387.8043363892513677931.stgit@magnolia>
 <20210201122029.GE3271714@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201122029.GE3271714@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 01, 2021 at 12:20:29PM +0000, Christoph Hellwig wrote:
> On Sun, Jan 31, 2021 at 06:05:18PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > For file ownership changes, create a new helper xfs_trans_alloc_ichange
> > that allocates a transaction and reserves the appropriate amount of
> > quota against that transction in preparation for a change of user,
> > group, or project id.  Replace all the open-coded idioms with a single
> > call to this helper so that we can contain the retry loops in the next
> > patchset.
> > 
> > This changes the locking behavior for ichange transactions slightly.
> > Since tr_ichange does not have a permanent reservation and cannot roll,
> > we pass XFS_ILOCK_EXCL to ijoin so that the inode will be unlocked
> > automatically at commit time.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_ioctl.c |   29 +++++++++----------------
> >  fs/xfs/xfs_iops.c  |   25 ++-------------------
> >  fs/xfs/xfs_trans.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_trans.h |    3 +++
> >  4 files changed, 76 insertions(+), 42 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index cf2167b84f5b..38ee66d999d8 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1275,24 +1275,23 @@ xfs_ioctl_setattr_prepare_dax(
> >   */
> >  static struct xfs_trans *
> >  xfs_ioctl_setattr_get_trans(
> > -	struct xfs_inode	*ip)
> > +	struct xfs_inode	*ip,
> > +	struct xfs_dquot	*pdqp)
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	struct xfs_trans	*tp;
> >  	int			error = -EROFS;
> >  
> >  	if (mp->m_flags & XFS_MOUNT_RDONLY)
> > -		goto out_unlock;
> > +		goto out_error;
> >  	error = -EIO;
> >  	if (XFS_FORCED_SHUTDOWN(mp))
> > -		goto out_unlock;
> > +		goto out_error;
> >  
> > -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
> > +	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
> > +			capable(CAP_FOWNER), &tp);
> >  	if (error)
> > -		goto out_unlock;
> > -
> > -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> > +		goto out_error;
> >  
> >  	/*
> >  	 * CAP_FOWNER overrides the following restrictions:
> > @@ -1312,7 +1311,7 @@ xfs_ioctl_setattr_get_trans(
> >  
> >  out_cancel:
> >  	xfs_trans_cancel(tp);
> > -out_unlock:
> > +out_error:
> >  	return ERR_PTR(error);
> >  }
> >  
> > @@ -1462,20 +1461,12 @@ xfs_ioctl_setattr(
> >  
> >  	xfs_ioctl_setattr_prepare_dax(ip, fa);
> >  
> > -	tp = xfs_ioctl_setattr_get_trans(ip);
> > +	tp = xfs_ioctl_setattr_get_trans(ip, pdqp);
> >  	if (IS_ERR(tp)) {
> >  		error = PTR_ERR(tp);
> >  		goto error_free_dquots;
> >  	}
> >  
> > -	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
> > -	    ip->i_d.di_projid != fa->fsx_projid) {
> > -		error = xfs_trans_reserve_quota_chown(tp, ip, NULL, NULL, pdqp,
> > -				capable(CAP_FOWNER));
> > -		if (error)	/* out of quota */
> > -			goto error_trans_cancel;
> > -	}
> > -
> >  	xfs_fill_fsxattr(ip, false, &old_fa);
> >  	error = vfs_ioc_fssetxattr_check(VFS_I(ip), &old_fa, fa);
> >  	if (error)
> > @@ -1608,7 +1599,7 @@ xfs_ioc_setxflags(
> >  
> >  	xfs_ioctl_setattr_prepare_dax(ip, &fa);
> >  
> > -	tp = xfs_ioctl_setattr_get_trans(ip);
> > +	tp = xfs_ioctl_setattr_get_trans(ip, NULL);
> >  	if (IS_ERR(tp)) {
> >  		error = PTR_ERR(tp);
> >  		goto out_drop_write;
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index 51c877ce90bc..00369502fe25 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -700,13 +700,11 @@ xfs_setattr_nonsize(
> >  			return error;
> >  	}
> >  
> > -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
> > +	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
> > +			capable(CAP_FOWNER), &tp);
> >  	if (error)
> >  		goto out_dqrele;
> >  
> > -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > -	xfs_trans_ijoin(tp, ip, 0);
> > -
> >  	/*
> >  	 * Change file ownership.  Must be the owner or privileged.
> >  	 */
> > @@ -722,20 +720,6 @@ xfs_setattr_nonsize(
> >  		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
> >  		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
> >  
> > -		/*
> > -		 * Do a quota reservation only if uid/gid is actually
> > -		 * going to change.
> > -		 */
> > -		if (XFS_IS_QUOTA_RUNNING(mp) &&
> > -		    ((XFS_IS_UQUOTA_ON(mp) && !uid_eq(iuid, uid)) ||
> > -		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)))) {
> > -			ASSERT(tp);
> > -			error = xfs_trans_reserve_quota_chown(tp, ip, udqp,
> > -					gdqp, NULL, capable(CAP_FOWNER));
> > -			if (error)	/* out of quota */
> > -				goto out_cancel;
> > -		}
> > -
> >  		/*
> >  		 * CAP_FSETID overrides the following restrictions:
> >  		 *
> > @@ -785,8 +769,6 @@ xfs_setattr_nonsize(
> >  		xfs_trans_set_sync(tp);
> >  	error = xfs_trans_commit(tp);
> >  
> > -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > -
> >  	/*
> >  	 * Release any dquot(s) the inode had kept before chown.
> >  	 */
> > @@ -813,9 +795,6 @@ xfs_setattr_nonsize(
> >  
> >  	return 0;
> >  
> > -out_cancel:
> > -	xfs_trans_cancel(tp);
> > -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >  out_dqrele:
> >  	xfs_qm_dqrele(udqp);
> >  	xfs_qm_dqrele(gdqp);
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 6c68635cc6ac..466e1c86767f 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -1107,3 +1107,64 @@ xfs_trans_alloc_icreate(
> >  	*tpp = tp;
> >  	return 0;
> >  }
> > +
> > +/*
> > + * Allocate an transaction, lock and join the inode to it, and reserve quota
> > + * in preparation for inode attribute changes that include uid, gid, or prid
> > + * changes.
> > + *
> > + * The caller must ensure that the on-disk dquots attached to this inode have
> > + * already been allocated and initialized.  The ILOCK will be dropped when the
> > + * transaction is committed or cancelled.
> > + */
> > +int
> > +xfs_trans_alloc_ichange(
> > +	struct xfs_inode	*ip,
> > +	struct xfs_dquot	*udqp,
> > +	struct xfs_dquot	*gdqp,
> > +	struct xfs_dquot	*pdqp,
> > +	bool			force,
> > +	struct xfs_trans	**tpp)
> > +{
> > +	struct xfs_trans	*tp;
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	struct xfs_dquot	*new_udqp;
> > +	struct xfs_dquot	*new_gdqp;
> > +	struct xfs_dquot	*new_pdqp;
> > +	int			error;
> > +
> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
> > +	if (error)
> > +		return error;
> > +
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> > +
> > +	error = xfs_qm_dqattach_locked(ip, false);
> > +	if (error) {
> > +		/* Caller should have allocated the dquots! */
> > +		ASSERT(error != -ENOENT);
> > +		goto out_cancel;
> > +	}
> > +
> > +	/*
> > +	 * Skip quota reservations if the [ugp]id is now the same, or if the
> > +	 * caller wasn't requesting a change in the first place.
> > +	 */
> > +	new_udqp = (udqp != ip->i_udquot) ? udqp : NULL;
> > +	new_gdqp = (gdqp != ip->i_gdquot) ? gdqp : NULL;
> > +	new_pdqp = (pdqp != ip->i_pdquot) ? pdqp : NULL;
> > +	if (new_udqp || new_gdqp || new_pdqp) {
> 
> Here again just clearing the original pointers would seem a lot
> cleaner..

It would, though I'll have to put back something like that in the "retry
chown on EDQUOT" patch in the next series, since the dquots can change
when we drop the ILOCK prior to the retry.

That change ought to be in that patch though, I suppose.  Will fix.

> 
> > +		error = xfs_trans_reserve_quota_chown(tp, ip, new_udqp,
> > +				new_gdqp, new_pdqp, force);
> 
> And if this funtion was open coded we would not have to do that twice.

Fixed.

--D
