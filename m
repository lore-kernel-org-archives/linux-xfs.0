Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4098417BA9
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 00:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738889582; cv=none; b=Kvi5sfEGHzyEx8dvdvDtdLcWTbpKl//P2wNZICGzWw53GSw+sj3zWIJh5FPFdbLD8uauuEzCDczUFVty7Yq6tldVIG3ziCmH4drwwXrjWu6pO45bUrBWDHsMreZCE3zVlj6ec/Ybm8lnKgjHy8r/dzIwq1tGQOvV4Fi+iXOYvyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738889582; c=relaxed/simple;
	bh=7M83dxJr3BANPK7nYhfhXn5FUwyvMpq6taHo7TNeLbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g50WXt5qAZVUysRWo3y09hPdaX+W6Rz+RMMZjqoMfGNw2KoXCIdfeC3gjezXqlHoksGRTamH3nrkUvhvrNqLB+5gHTtxEoVhsNHj26H+JZlJvCyz2h6UGSgnBztq6zsVKS7koR81bRYa2gshBTJIG24aPsdBVy1QmHXq1S03sQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pHldxdF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pHldxdF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE7DC4CEDD;
	Fri,  7 Feb 2025 00:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738889581;
	bh=7M83dxJr3BANPK7nYhfhXn5FUwyvMpq6taHo7TNeLbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pHldxdF7vXvjL/sBNcYPYcZJLwfdS0rs3tOi+pBIA5qGVcdSMJMJJBooXu3akuY85
	 OMonuZRZNfapAZFdNU9B90ZqsmRre5n44/NJX2klWH6aZHCzjgHHOuNQvm9jIDOta4
	 U6ySuBT4KgUgmtt/qMdhWq8lch/Mka6BiQUcXlzT6YQ4F2t2gXRPxc2afxBR5WstOo
	 uoNFP1fsjrJgFd0xnoNRItku6Rf0C6gSD6iCtXZOM7TNasDtf6gHdBdfoKF4mvguCI
	 2+Q/hfmyjB/7lM2Eu7OU4WBTaIKkIRVgeSJGNbc7Nv+/egLVnKtHe2bkIsGzmZq7KA
	 6LuUnHdUbM3nA==
Date: Thu, 6 Feb 2025 16:52:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 43/43] xfs: export max_open_zones in sysfs
Message-ID: <20250207005259.GD21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-44-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-44-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:59AM +0100, Christoph Hellwig wrote:
> Add a zoned group with an attribute for the maximum number of open zones.
> This allows querying the open zones for data placement tests, or also
> for placement aware applications that are in control of the entire
> file system.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

It occurs to me -- what happens to all this zoned code if you build
without RT support?

Creating a whole sysfs kobj just to export a single attribute seems a
little overkill but I guess that beats revving the fs geometry ioctl.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_mount.h |  1 +
>  fs/xfs/xfs_sysfs.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 41 insertions(+)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 7c7fd94375c1..390d9d5882f4 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -277,6 +277,7 @@ typedef struct xfs_mount {
>  #ifdef CONFIG_XFS_ONLINE_SCRUB_STATS
>  	struct xchk_stats	*m_scrub_stats;
>  #endif
> +	struct xfs_kobj		m_zoned_kobj;
>  	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
>  	atomic_t		m_agirotor;	/* last ag dir inode alloced */
>  	atomic_t		m_rtgrotor;	/* last rtgroup rtpicked */
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index c3bd7dff229d..797a92908647 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -13,6 +13,7 @@
>  #include "xfs_log.h"
>  #include "xfs_log_priv.h"
>  #include "xfs_mount.h"
> +#include "xfs_zones.h"
>  
>  struct xfs_sysfs_attr {
>  	struct attribute attr;
> @@ -701,6 +702,34 @@ xfs_error_sysfs_init_class(
>  	return error;
>  }
>  
> +static inline struct xfs_mount *zoned_to_mp(struct kobject *kobj)
> +{
> +	return container_of(to_kobj(kobj), struct xfs_mount, m_zoned_kobj);
> +}
> +
> +static ssize_t
> +max_open_zones_show(
> +	struct kobject		*kobj,
> +	char			*buf)
> +{
> +	/* only report the open zones available for user data */
> +	return sysfs_emit(buf, "%u\n",
> +		zoned_to_mp(kobj)->m_max_open_zones - XFS_OPEN_GC_ZONES);
> +}
> +XFS_SYSFS_ATTR_RO(max_open_zones);
> +
> +static struct attribute *xfs_zoned_attrs[] = {
> +	ATTR_LIST(max_open_zones),
> +	NULL,
> +};
> +ATTRIBUTE_GROUPS(xfs_zoned);
> +
> +static const struct kobj_type xfs_zoned_ktype = {
> +	.release = xfs_sysfs_release,
> +	.sysfs_ops = &xfs_sysfs_ops,
> +	.default_groups = xfs_zoned_groups,
> +};
> +
>  int
>  xfs_mount_sysfs_init(
>  	struct xfs_mount	*mp)
> @@ -741,6 +770,14 @@ xfs_mount_sysfs_init(
>  	if (error)
>  		goto out_remove_error_dir;
>  
> +	if (xfs_has_zoned(mp)) {
> +		/* .../xfs/<dev>/zoned/ */
> +		error = xfs_sysfs_init(&mp->m_zoned_kobj, &xfs_zoned_ktype,
> +					&mp->m_kobj, "zoned");
> +		if (error)
> +			goto out_remove_error_dir;
> +	}
> +
>  	return 0;
>  
>  out_remove_error_dir:
> @@ -759,6 +796,9 @@ xfs_mount_sysfs_del(
>  	struct xfs_error_cfg	*cfg;
>  	int			i, j;
>  
> +	if (xfs_has_zoned(mp))
> +		xfs_sysfs_del(&mp->m_zoned_kobj);
> +
>  	for (i = 0; i < XFS_ERR_CLASS_MAX; i++) {
>  		for (j = 0; j < XFS_ERR_ERRNO_MAX; j++) {
>  			cfg = &mp->m_error_cfg[i][j];
> -- 
> 2.45.2
> 
> 
