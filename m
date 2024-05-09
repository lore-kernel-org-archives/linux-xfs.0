Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A176986245
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 23:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715297647; cv=none; b=hgW9jMAgL8SxgnXY69Rqj7rir0ncSHm03/CK65w1mQ01ZQn+zJjVGFfELiEY4Ir+v+Tc41VVjPq1sdZR7dcaHLBkOyZ2KYpd3iaYFhxOENaVECK3i6/9r5IEfX/MYNACZkFGNm+tFgeMqicVvIFXOSDk/wHjewgIRTDVJfaRzqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715297647; c=relaxed/simple;
	bh=oT8ri8Cl2FgwX6OukEIGVPg7CicVAnFopbDm7BLaRXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=blvTEKaU8iVsMs2Nc86xu6bzzaZl2PBJ3I7VuphcivPu75LJtzL8ahjEWb1HZ1HaijZQ2QRIXKU7XrFGs070aoZKEcY8QyE1m8V5mE0k6yNnYQhhRAPOfyupoYAJ/nJwf84f3cgsOLSZp5n4q6kRJITebiq8coY5k73Ct9NSwEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wfib7Gg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wfib7Gg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14119C116B1;
	Thu,  9 May 2024 23:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715297647;
	bh=oT8ri8Cl2FgwX6OukEIGVPg7CicVAnFopbDm7BLaRXU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wfib7Gg8yqvUrarV1w1kpYQoUglu+1LX0jOHRxB7K/p4BXUrglpzXpxtegv2yyxwA
	 jv+ooAuGEO9t87u7gLU6/lNezDeLa4rApJwuv0EV4yUbVJr8OqjYs+WSLPXzbaBxHS
	 DSFsITnqS1ELCB44w5mEQDx4T9TDCput4929VPKRotTuJxxX5urwK2fDoymv7JfXnl
	 rUSPBQ0mngXB1TWLvme+8qh4pY2p9TX1QvdMXKCgOdTMqq4wOZ1fbfRvzEbB84WmaM
	 H0wtRVLvSGsy3KFa7y+UaaEj7ORvBHFA/jAoLe2pnl9he0vlYx9Af3QX4ppXwyxG9p
	 sCiBPOAng9ulg==
Date: Thu, 9 May 2024 16:34:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: allow setting xattrs on special files
Message-ID: <20240509233406.GT360919@frogsfrogsfrogs>
References: <20240509151459.3622910-2-aalbersh@redhat.com>
 <20240509151459.3622910-5-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509151459.3622910-5-aalbersh@redhat.com>

On Thu, May 09, 2024 at 05:14:59PM +0200, Andrey Albershteyn wrote:
> As XFS didn't have ioctls for special files setting an inode
> extended attributes was rejected for them in xfs_fileattr_set().
> Same applies for reading.
> 
> With XFS's project quota directories this is necessary. When project
> is setup, xfs_quota opens and calls FS_IOC_SETFSXATTR on every inode
> in the directory. However, special files are skipped due to open()
> returning a special inode for them. So, they don't even get to this
> check.
> 
> The further patch introduces XFS_IOC_SETFSXATTRAT which will call
> xfs_fileattr_set/get() on a special file. This patch add handling of
> setting xflags and project ID for special files.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/xfs/xfs_ioctl.c | 96 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 92 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index f0117188f302..515c9b4b862d 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -459,9 +459,6 @@ xfs_fileattr_get(
>  {
>  	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
>  
> -	if (d_is_special(dentry))
> -		return -ENOTTY;
> -
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
>  	xfs_fill_fsxattr(ip, XFS_DATA_FORK, fa);
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> @@ -721,6 +718,97 @@ xfs_ioctl_setattr_check_projid(
>  	return 0;
>  }
>  
> +static int
> +xfs_fileattr_spec_set(
> +	struct mnt_idmap	*idmap,
> +	struct dentry		*dentry,
> +	struct fileattr		*fa)
> +{
> +	struct xfs_inode *ip = XFS_I(d_inode(dentry));
> +	struct xfs_mount *mp = ip->i_mount;
> +	struct xfs_trans *tp;
> +	struct xfs_dquot *pdqp = NULL;
> +	struct xfs_dquot *olddquot = NULL;
> +	int error;
> +
> +	if (!fa->fsx_valid)
> +		return -EOPNOTSUPP;
> +
> +	if (fa->fsx_extsize ||
> +	    fa->fsx_nextents ||
> +	    fa->fsx_cowextsize)
> +		return -EOPNOTSUPP;
> +
> +	error = xfs_ioctl_setattr_check_projid(ip, fa);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * If disk quotas is on, we make sure that the dquots do exist on disk,
> +	 * before we start any other transactions. Trying to do this later
> +	 * is messy. We don't care to take a readlock to look at the ids
> +	 * in inode here, because we can't hold it across the trans_reserve.
> +	 * If the IDs do change before we take the ilock, we're covered
> +	 * because the i_*dquot fields will get updated anyway.
> +	 */
> +	if (fa->fsx_valid && XFS_IS_QUOTA_ON(mp)) {

Didn't we already check fsx_valid?

Also, what's different about the behavior of setxattr on special files
(vs. directories and regular files) such that we need a separate function?
Is it to disable the ability to set the extent size hints or the xflags?

--D

> +		error = xfs_qm_vop_dqalloc(ip, VFS_I(ip)->i_uid,
> +					   VFS_I(ip)->i_gid, fa->fsx_projid,
> +					   XFS_QMOPT_PQUOTA, NULL, NULL, &pdqp);
> +		if (error)
> +			return error;
> +	}
> +
> +	tp = xfs_ioctl_setattr_get_trans(ip, pdqp);
> +	if (IS_ERR(tp)) {
> +		error = PTR_ERR(tp);
> +		goto error_free_dquots;
> +	}
> +
> +	error = xfs_ioctl_setattr_xflags(tp, ip, fa);
> +	if (error)
> +		goto error_trans_cancel;
> +
> +	/*
> +	 * Change file ownership.  Must be the owner or privileged.  CAP_FSETID
> +	 * overrides the following restrictions:
> +	 *
> +	 * The set-user-ID and set-group-ID bits of a file will be cleared upon
> +	 * successful return from chown()
> +	 */
> +
> +	if ((VFS_I(ip)->i_mode & (S_ISUID | S_ISGID)) &&
> +	    !capable_wrt_inode_uidgid(idmap, VFS_I(ip), CAP_FSETID))
> +		VFS_I(ip)->i_mode &= ~(S_ISUID | S_ISGID);
> +
> +	/* Change the ownerships and register project quota modifications */
> +	if (ip->i_projid != fa->fsx_projid) {
> +		if (XFS_IS_PQUOTA_ON(mp)) {
> +			olddquot =
> +				xfs_qm_vop_chown(tp, ip, &ip->i_pdquot, pdqp);
> +		}
> +		ip->i_projid = fa->fsx_projid;
> +	}
> +
> +	error = xfs_trans_commit(tp);
> +
> +	/*
> +	 * Release any dquot(s) the inode had kept before chown.
> +	 */
> +	xfs_qm_dqrele(olddquot);
> +	xfs_qm_dqrele(pdqp);
> +
> +	return error;
> +
> +error_trans_cancel:
> +	xfs_trans_cancel(tp);
> +error_free_dquots:
> +	xfs_qm_dqrele(pdqp);
> +	return error;
> +
> +	return 0;
> +}
> +
>  int
>  xfs_fileattr_set(
>  	struct mnt_idmap	*idmap,
> @@ -737,7 +825,7 @@ xfs_fileattr_set(
>  	trace_xfs_ioctl_setattr(ip);
>  
>  	if (d_is_special(dentry))
> -		return -ENOTTY;
> +		return xfs_fileattr_spec_set(idmap, dentry, fa);
>  
>  	if (!fa->fsx_valid) {
>  		if (fa->flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL |
> -- 
> 2.42.0
> 
> 
