Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BC517E4
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 00:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738889650; cv=none; b=jL4lO3+TyZ97ZxznpLSMSLYUX1Gir/8DD/yJ9/es/jkmy+T9+ThtMTrvn/d73x+Ci2L35B1JMFa1CWoBMR3jKVXpPDQnSWeaEGMtir8HPq0QZTG9tZjfS9RPAczVjqinijQ8CC1x/IZrk3fi2teI7tvMT9CTvaTWJh5mRYWQXtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738889650; c=relaxed/simple;
	bh=tOp4P+jO9SqrewElH6BY95rPFxFkJyhT/Jl1ksCMzuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DlKIjqF/1j8YWB71PWd5sJoj4UYZiUBaUuQx1UWRPzRznGga5oBKU5kDHpjNRDem7GkSmtsUOu3QWkqi93rV0vQBPzitmIQZklfjRMaN0DycPFmEvWnaL8DYjxOyB99shDvExgU2GFiHGAOr6ep7325OQySQ/+DrPsx+vWgy7vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BVaDafRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BVaDafRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7E3C4CEDD;
	Fri,  7 Feb 2025 00:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738889649;
	bh=tOp4P+jO9SqrewElH6BY95rPFxFkJyhT/Jl1ksCMzuM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BVaDafREYlOzs/BLgzaMqllTnLGBCaY9g2xdXgEvYuilyV2e3cizdVdX/P9CQ+537
	 8ZMKK/Hz+v91bM0JmAbyy/U339PMTpqr83zubr97B7y0zeUTOeSgfgFki9RhV7wLMp
	 m5UX+RpR2xo/nBhtpuz4/bFuxFVBjty8V/pHA//KPeMc+Mka+CbCGgIvXgFZNHGEcK
	 g4tMcUBsK3lfaRzj5fg+1/fM9YOhy0Q1Q7vQ9xj+/a2Ckr9k6TX1Hp6Iu1wjjLDwyb
	 X2C9yl0PiDkL5OVHLtaheGocQC5Yo/t9BhI+wjafUFhQ29qW/JmDQ3EpOs1svtFo6v
	 iRL93owsWU4iA==
Date: Thu, 6 Feb 2025 16:54:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 42/43] xfs: contain more sysfs code in xfs_sysfs.c
Message-ID: <20250207005409.GE21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-43-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-43-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:58AM +0100, Christoph Hellwig wrote:
> Extend the error sysfs initialization helper to include the neighbouring
> attributes as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks like a pretty simple rearrangement...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_mount.c | 29 ++++++-----------------------
>  fs/xfs/xfs_sysfs.c | 35 ++++++++++++++++++++++++++++-------
>  fs/xfs/xfs_sysfs.h |  5 ++---
>  3 files changed, 36 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 7dbdf9e5529c..a62791c2b2fe 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -768,27 +768,15 @@ xfs_mountfs(
>  	/* enable fail_at_unmount as default */
>  	mp->m_fail_unmount = true;
>  
> -	super_set_sysfs_name_id(mp->m_super);
> -
> -	error = xfs_sysfs_init(&mp->m_kobj, &xfs_mp_ktype,
> -			       NULL, mp->m_super->s_id);
> -	if (error)
> -		goto out;
> -
> -	error = xfs_sysfs_init(&mp->m_stats.xs_kobj, &xfs_stats_ktype,
> -			       &mp->m_kobj, "stats");
> +	error = xfs_mount_sysfs_init(mp);
>  	if (error)
> -		goto out_remove_sysfs;
> +		goto out_remove_scrub_stats;
>  
>  	xchk_stats_register(mp->m_scrub_stats, mp->m_debugfs);
>  
> -	error = xfs_error_sysfs_init(mp);
> -	if (error)
> -		goto out_remove_scrub_stats;
> -
>  	error = xfs_errortag_init(mp);
>  	if (error)
> -		goto out_remove_error_sysfs;
> +		goto out_remove_sysfs;
>  
>  	error = xfs_uuid_mount(mp);
>  	if (error)
> @@ -1151,13 +1139,10 @@ xfs_mountfs(
>  	xfs_uuid_unmount(mp);
>   out_remove_errortag:
>  	xfs_errortag_del(mp);
> - out_remove_error_sysfs:
> -	xfs_error_sysfs_del(mp);
> + out_remove_sysfs:
> +	xfs_mount_sysfs_del(mp);
>   out_remove_scrub_stats:
>  	xchk_stats_unregister(mp->m_scrub_stats);
> -	xfs_sysfs_del(&mp->m_stats.xs_kobj);
> - out_remove_sysfs:
> -	xfs_sysfs_del(&mp->m_kobj);
>   out:
>  	return error;
>  }
> @@ -1234,10 +1219,8 @@ xfs_unmountfs(
>  	xfs_free_rtgroups(mp, 0, mp->m_sb.sb_rgcount);
>  	xfs_free_perag_range(mp, 0, mp->m_sb.sb_agcount);
>  	xfs_errortag_del(mp);
> -	xfs_error_sysfs_del(mp);
>  	xchk_stats_unregister(mp->m_scrub_stats);
> -	xfs_sysfs_del(&mp->m_stats.xs_kobj);
> -	xfs_sysfs_del(&mp->m_kobj);
> +	xfs_mount_sysfs_del(mp);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 60cb5318fdae..c3bd7dff229d 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -69,7 +69,7 @@ static struct attribute *xfs_mp_attrs[] = {
>  };
>  ATTRIBUTE_GROUPS(xfs_mp);
>  
> -const struct kobj_type xfs_mp_ktype = {
> +static const struct kobj_type xfs_mp_ktype = {
>  	.release = xfs_sysfs_release,
>  	.sysfs_ops = &xfs_sysfs_ops,
>  	.default_groups = xfs_mp_groups,
> @@ -702,39 +702,58 @@ xfs_error_sysfs_init_class(
>  }
>  
>  int
> -xfs_error_sysfs_init(
> +xfs_mount_sysfs_init(
>  	struct xfs_mount	*mp)
>  {
>  	int			error;
>  
> +	super_set_sysfs_name_id(mp->m_super);
> +
> +	/* .../xfs/<dev>/ */
> +	error = xfs_sysfs_init(&mp->m_kobj, &xfs_mp_ktype,
> +			       NULL, mp->m_super->s_id);
> +	if (error)
> +		return error;
> +
> +	/* .../xfs/<dev>/stats/ */
> +	error = xfs_sysfs_init(&mp->m_stats.xs_kobj, &xfs_stats_ktype,
> +			       &mp->m_kobj, "stats");
> +	if (error)
> +		goto out_remove_fsdir;
> +
>  	/* .../xfs/<dev>/error/ */
>  	error = xfs_sysfs_init(&mp->m_error_kobj, &xfs_error_ktype,
>  				&mp->m_kobj, "error");
>  	if (error)
> -		return error;
> +		goto out_remove_stats_dir;
>  
> +	/* .../xfs/<dev>/error/fail_at_unmount */
>  	error = sysfs_create_file(&mp->m_error_kobj.kobject,
>  				  ATTR_LIST(fail_at_unmount));
>  
>  	if (error)
> -		goto out_error;
> +		goto out_remove_error_dir;
>  
>  	/* .../xfs/<dev>/error/metadata/ */
>  	error = xfs_error_sysfs_init_class(mp, XFS_ERR_METADATA,
>  				"metadata", &mp->m_error_meta_kobj,
>  				xfs_error_meta_init);
>  	if (error)
> -		goto out_error;
> +		goto out_remove_error_dir;
>  
>  	return 0;
>  
> -out_error:
> +out_remove_error_dir:
>  	xfs_sysfs_del(&mp->m_error_kobj);
> +out_remove_stats_dir:
> +	xfs_sysfs_del(&mp->m_stats.xs_kobj);
> +out_remove_fsdir:
> +	xfs_sysfs_del(&mp->m_kobj);
>  	return error;
>  }
>  
>  void
> -xfs_error_sysfs_del(
> +xfs_mount_sysfs_del(
>  	struct xfs_mount	*mp)
>  {
>  	struct xfs_error_cfg	*cfg;
> @@ -749,6 +768,8 @@ xfs_error_sysfs_del(
>  	}
>  	xfs_sysfs_del(&mp->m_error_meta_kobj);
>  	xfs_sysfs_del(&mp->m_error_kobj);
> +	xfs_sysfs_del(&mp->m_stats.xs_kobj);
> +	xfs_sysfs_del(&mp->m_kobj);
>  }
>  
>  struct xfs_error_cfg *
> diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
> index 148893ebfdef..1622fe80ad3e 100644
> --- a/fs/xfs/xfs_sysfs.h
> +++ b/fs/xfs/xfs_sysfs.h
> @@ -7,7 +7,6 @@
>  #ifndef __XFS_SYSFS_H__
>  #define __XFS_SYSFS_H__
>  
> -extern const struct kobj_type xfs_mp_ktype;	/* xfs_mount */
>  extern const struct kobj_type xfs_dbg_ktype;	/* debug */
>  extern const struct kobj_type xfs_log_ktype;	/* xlog */
>  extern const struct kobj_type xfs_stats_ktype;	/* stats */
> @@ -53,7 +52,7 @@ xfs_sysfs_del(
>  	wait_for_completion(&kobj->complete);
>  }
>  
> -int	xfs_error_sysfs_init(struct xfs_mount *mp);
> -void	xfs_error_sysfs_del(struct xfs_mount *mp);
> +int	xfs_mount_sysfs_init(struct xfs_mount *mp);
> +void	xfs_mount_sysfs_del(struct xfs_mount *mp);
>  
>  #endif	/* __XFS_SYSFS_H__ */
> -- 
> 2.45.2
> 
> 
