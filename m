Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57470 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbfCAPtm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 10:49:42 -0500
Date: Fri, 1 Mar 2019 07:49:26 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/8] xfs: support project ID in xfs_setattr()
Message-ID: <20190301154926.GN21626@magnolia>
References: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
 <1551449141-7884-5-git-send-email-wshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551449141-7884-5-git-send-email-wshilong1991@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>

On Fri, Mar 01, 2019 at 11:05:37PM +0900, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> From: Wang Shilong <wshilong@ddn.com>

Needs a commit message here ^^^^

e.g. "Wire up XFS to the new ATTR_PROJID setattr functionality"

> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
>  fs/xfs/xfs_iops.c  | 51 +++++++++++++++++++++++++++++++++++++---------
>  fs/xfs/xfs_linux.h | 10 +++++++++
>  2 files changed, 51 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index f48ffd7a8d3e..c10466fe6ed4 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -589,7 +589,8 @@ xfs_vn_change_ok(
>  	struct dentry	*dentry,
>  	struct iattr	*iattr)
>  {
> -	struct xfs_mount	*mp = XFS_I(d_inode(dentry))->i_mount;
> +	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
> +	struct xfs_mount	*mp = ip->i_mount;
>  
>  	if (mp->m_flags & XFS_MOUNT_RDONLY)
>  		return -EROFS;
> @@ -597,6 +598,13 @@ xfs_vn_change_ok(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> +	 if ((iattr->ia_valid & ATTR_PROJID) &&
> +	     current_user_ns() != &init_user_ns) {
> +		if (!projid_eq(xfs_projid_to_kprojid(xfs_get_projid(ip)),
> +			       iattr->ia_projid))
> +			return -EPERM;
> +	}
> +
>  	return setattr_prepare(dentry, iattr);
>  }
>  
> @@ -619,8 +627,10 @@ xfs_setattr_nonsize(
>  	int			error;
>  	kuid_t			uid = GLOBAL_ROOT_UID, iuid = GLOBAL_ROOT_UID;
>  	kgid_t			gid = GLOBAL_ROOT_GID, igid = GLOBAL_ROOT_GID;
> -	struct xfs_dquot	*udqp = NULL, *gdqp = NULL;
> +	kprojid_t		projid, iprojid;
> +	struct xfs_dquot	*udqp = NULL, *gdqp = NULL, *pdqp = NULL;
>  	struct xfs_dquot	*olddquot1 = NULL, *olddquot2 = NULL;
> +	struct xfs_dquot	*olddquot3 = NULL;
>  
>  	ASSERT((mask & ATTR_SIZE) == 0);
>  
> @@ -632,7 +642,7 @@ xfs_setattr_nonsize(
>  	 * If the IDs do change before we take the ilock, we're covered
>  	 * because the i_*dquot fields will get updated anyway.
>  	 */
> -	if (XFS_IS_QUOTA_ON(mp) && (mask & (ATTR_UID|ATTR_GID))) {
> +	if (XFS_IS_QUOTA_ON(mp) && (mask & (ATTR_UID|ATTR_GID|ATTR_PROJID))) {
>  		uint	qflags = 0;
>  
>  		if ((mask & ATTR_UID) && XFS_IS_UQUOTA_ON(mp)) {
> @@ -647,18 +657,25 @@ xfs_setattr_nonsize(
>  		}  else {
>  			gid = inode->i_gid;
>  		}
> +		if ((mask & ATTR_PROJID) && XFS_IS_PQUOTA_ON(mp)) {
> +			projid = iattr->ia_projid;
> +			qflags |= XFS_QMOPT_PQUOTA;
> +		}  else {
> +			projid = xfs_projid_to_kprojid(xfs_get_projid(ip));

Hmm.  Prior to this change, xfs never actually touched the kernel's kprojid
infrastructure, which is to say that I don't think we actually map the
xfs project ids into a "kprojid user-namespace pair".  Does that cause a
user-visible change in how project ids work?  Don't we need to change
getxattr and setxattr to perform the translation too?  Or is everything
just fine the way it is in xfs without a new layer of mapping?

And if we /are/ deciding to wrap xfs project ids in kprojid now, I think
that ought to be a separate patch.

> +		}
>  
>  		/*
> -		 * We take a reference when we initialize udqp and gdqp,
> +		 * We take a reference when we initialize udqp,gdqp and pdqp,

                               space after the comma, please ^^^

--D

>  		 * so it is important that we never blindly double trip on
>  		 * the same variable. See xfs_create() for an example.
>  		 */
>  		ASSERT(udqp == NULL);
>  		ASSERT(gdqp == NULL);
> +		ASSERT(pdqp == NULL);
>  		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_uid(uid),
>  					   xfs_kgid_to_gid(gid),
> -					   xfs_get_projid(ip),
> -					   qflags, &udqp, &gdqp, NULL);
> +					   xfs_kprojid_to_projid(projid),
> +					   qflags, &udqp, &gdqp, &pdqp);
>  		if (error)
>  			return error;
>  	}
> @@ -673,7 +690,7 @@ xfs_setattr_nonsize(
>  	/*
>  	 * Change file ownership.  Must be the owner or privileged.
>  	 */
> -	if (mask & (ATTR_UID|ATTR_GID)) {
> +	if (mask & (ATTR_UID|ATTR_GID|ATTR_PROJID)) {
>  		/*
>  		 * These IDs could have changed since we last looked at them.
>  		 * But, we're assured that if the ownership did change
> @@ -682,8 +699,10 @@ xfs_setattr_nonsize(
>  		 */
>  		iuid = inode->i_uid;
>  		igid = inode->i_gid;
> +		iprojid = xfs_projid_to_kprojid(xfs_get_projid(ip));
>  		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
>  		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
> +		projid = (mask & ATTR_PROJID) ? iattr->ia_projid : iprojid;
>  
>  		/*
>  		 * Do a quota reservation only if uid/gid is actually
> @@ -691,10 +710,11 @@ xfs_setattr_nonsize(
>  		 */
>  		if (XFS_IS_QUOTA_RUNNING(mp) &&
>  		    ((XFS_IS_UQUOTA_ON(mp) && !uid_eq(iuid, uid)) ||
> -		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)))) {
> +		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)) ||
> +		     (XFS_IS_PQUOTA_ON(mp) && !projid_eq(iprojid, projid)))) {
>  			ASSERT(tp);
>  			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
> -						NULL, capable(CAP_FOWNER) ?
> +						pdqp, capable(CAP_FOWNER) ?
>  						XFS_QMOPT_FORCE_RES : 0);
>  			if (error)	/* out of quota */
>  				goto out_cancel;
> @@ -704,7 +724,7 @@ xfs_setattr_nonsize(
>  	/*
>  	 * Change file ownership.  Must be the owner or privileged.
>  	 */
> -	if (mask & (ATTR_UID|ATTR_GID)) {
> +	if (mask & (ATTR_UID|ATTR_GID|ATTR_PROJID)) {
>  		/*
>  		 * CAP_FSETID overrides the following restrictions:
>  		 *
> @@ -741,6 +761,15 @@ xfs_setattr_nonsize(
>  			ip->i_d.di_gid = xfs_kgid_to_gid(gid);
>  			inode->i_gid = gid;
>  		}
> +		if (!projid_eq(iprojid, projid)) {
> +			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
> +				ASSERT(mask & ATTR_PROJID);
> +				ASSERT(pdqp);
> +				olddquot3 = xfs_qm_vop_chown(tp, ip,
> +							&ip->i_pdquot, pdqp);
> +			}
> +			xfs_set_projid(ip, xfs_kprojid_to_projid(projid));
> +		}
>  	}
>  
>  	if (mask & ATTR_MODE)
> @@ -763,8 +792,10 @@ xfs_setattr_nonsize(
>  	 */
>  	xfs_qm_dqrele(olddquot1);
>  	xfs_qm_dqrele(olddquot2);
> +	xfs_qm_dqrele(olddquot3);
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);
> +	xfs_qm_dqrele(pdqp);
>  
>  	if (error)
>  		return error;
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index edbd5a210df2..80f5ea32823d 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -191,6 +191,16 @@ static inline kgid_t xfs_gid_to_kgid(uint32_t gid)
>  	return make_kgid(&init_user_ns, gid);
>  }
>  
> +static inline uint32_t xfs_kprojid_to_projid(kprojid_t projid)
> +{
> +	return from_kprojid(&init_user_ns, projid);
> +}
> +
> +static inline kprojid_t xfs_projid_to_kprojid(uint32_t projid)
> +{
> +	return make_kprojid(&init_user_ns, projid);
> +}
> +
>  static inline dev_t xfs_to_linux_dev_t(xfs_dev_t dev)
>  {
>  	return MKDEV(sysv_major(dev) & 0x1ff, sysv_minor(dev));
> -- 
> 2.19.1
> 
