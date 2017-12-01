Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45817 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdLAW0X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Dec 2017 17:26:23 -0500
Date: Fri, 1 Dec 2017 14:26:17 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/4] xfs: explicitly initialize meta_scrub_ops array by
 type
Message-ID: <20171201222617.GY21412@magnolia>
References: <2f4bb05f-fd41-7fa3-22f0-9ec9d2224a47@redhat.com>
 <7c594a2e-5292-97b5-9f48-f8e2920fea1a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c594a2e-5292-97b5-9f48-f8e2920fea1a@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Dec 01, 2017 at 04:13:27PM -0600, Eric Sandeen wrote:
> An implicit mapping to type by order of initialization seems
> error-prone, and doesn't lend itself to cscope-ing.
> 
> Also add sanity checks about size of array vs. max types,
> and a defensive check that ->scrub exists before using it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 9c42c4e..dc1f33a 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -168,104 +168,104 @@
>  /* Scrubbing dispatch. */
>  
>  static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
> -	{ /* ioctl presence test */
> +	[XFS_SCRUB_TYPE_PROBE] = {	/* ioctl presence test */
>  		.setup	= xfs_scrub_setup_fs,
>  		.scrub	= xfs_scrub_probe,
>  	},
> -	{ /* superblock */
> +	[XFS_SCRUB_TYPE_SB] = {		/* superblock */
>  		.setup	= xfs_scrub_setup_ag_header,
>  		.scrub	= xfs_scrub_superblock,
>  	},
> -	{ /* agf */
> +	[XFS_SCRUB_TYPE_AGF] = {	/* agf */
>  		.setup	= xfs_scrub_setup_ag_header,
>  		.scrub	= xfs_scrub_agf,
>  	},
> -	{ /* agfl */
> +	[XFS_SCRUB_TYPE_AGFL]= {	/* agfl */
>  		.setup	= xfs_scrub_setup_ag_header,
>  		.scrub	= xfs_scrub_agfl,
>  	},
> -	{ /* agi */
> +	[XFS_SCRUB_TYPE_AGI] = {	/* agi */
>  		.setup	= xfs_scrub_setup_ag_header,
>  		.scrub	= xfs_scrub_agi,
>  	},
> -	{ /* bnobt */
> +	[XFS_SCRUB_TYPE_BNOBT] = {	/* bnobt */
>  		.setup	= xfs_scrub_setup_ag_allocbt,
>  		.scrub	= xfs_scrub_bnobt,
>  	},
> -	{ /* cntbt */
> +	[XFS_SCRUB_TYPE_CNTBT] = {	/* cntbt */
>  		.setup	= xfs_scrub_setup_ag_allocbt,
>  		.scrub	= xfs_scrub_cntbt,
>  	},
> -	{ /* inobt */
> +	[XFS_SCRUB_TYPE_INOBT] = {	/* inobt */
>  		.setup	= xfs_scrub_setup_ag_iallocbt,
>  		.scrub	= xfs_scrub_inobt,
>  	},
> -	{ /* finobt */
> +	[XFS_SCRUB_TYPE_FINOBT] = {	/* finobt */
>  		.setup	= xfs_scrub_setup_ag_iallocbt,
>  		.scrub	= xfs_scrub_finobt,
>  		.has	= xfs_sb_version_hasfinobt,
>  	},
> -	{ /* rmapbt */
> +	[XFS_SCRUB_TYPE_RMAPBT] = {	/* rmapbt */
>  		.setup	= xfs_scrub_setup_ag_rmapbt,
>  		.scrub	= xfs_scrub_rmapbt,
>  		.has	= xfs_sb_version_hasrmapbt,
>  	},
> -	{ /* refcountbt */
> +	[XFS_SCRUB_TYPE_REFCNTBT] = {	/* refcountbt */
>  		.setup	= xfs_scrub_setup_ag_refcountbt,
>  		.scrub	= xfs_scrub_refcountbt,
>  		.has	= xfs_sb_version_hasreflink,
>  	},
> -	{ /* inode record */
> +	[XFS_SCRUB_TYPE_INODE] = {	/* inode record */
>  		.setup	= xfs_scrub_setup_inode,
>  		.scrub	= xfs_scrub_inode,
>  	},
> -	{ /* inode data fork */
> +	[XFS_SCRUB_TYPE_BMBTD] = {	/* inode data fork */
>  		.setup	= xfs_scrub_setup_inode_bmap,
>  		.scrub	= xfs_scrub_bmap_data,
>  	},
> -	{ /* inode attr fork */
> +	[XFS_SCRUB_TYPE_BMBTA] = {	/* inode attr fork */
>  		.setup	= xfs_scrub_setup_inode_bmap,
>  		.scrub	= xfs_scrub_bmap_attr,
>  	},
> -	{ /* inode CoW fork */
> +	[XFS_SCRUB_TYPE_BMBTC] = {	/* inode CoW fork */
>  		.setup	= xfs_scrub_setup_inode_bmap,
>  		.scrub	= xfs_scrub_bmap_cow,
>  	},
> -	{ /* directory */
> +	[XFS_SCRUB_TYPE_DIR] = {	/* directory */
>  		.setup	= xfs_scrub_setup_directory,
>  		.scrub	= xfs_scrub_directory,
>  	},
> -	{ /* extended attributes */
> +	[XFS_SCRUB_TYPE_XATTR] = {	/* extended attributes */
>  		.setup	= xfs_scrub_setup_xattr,
>  		.scrub	= xfs_scrub_xattr,
>  	},
> -	{ /* symbolic link */
> +	[XFS_SCRUB_TYPE_SYMLINK] = {	/* symbolic link */
>  		.setup	= xfs_scrub_setup_symlink,
>  		.scrub	= xfs_scrub_symlink,
>  	},
> -	{ /* parent pointers */
> +	[XFS_SCRUB_TYPE_PARENT] = {	/* parent pointers */
>  		.setup	= xfs_scrub_setup_parent,
>  		.scrub	= xfs_scrub_parent,
>  	},
> -	{ /* realtime bitmap */
> +	[XFS_SCRUB_TYPE_RTBITMAP] = {	/* realtime bitmap */
>  		.setup	= xfs_scrub_setup_rt,
>  		.scrub	= xfs_scrub_rtbitmap,
>  		.has	= xfs_sb_version_hasrealtime,
>  	},
> -	{ /* realtime summary */
> +	[XFS_SCRUB_TYPE_RTSUM] = {	/* realtime summary */
>  		.setup	= xfs_scrub_setup_rt,
>  		.scrub	= xfs_scrub_rtsummary,
>  		.has	= xfs_sb_version_hasrealtime,
>  	},
> -	{ /* user quota */
> +	[XFS_SCRUB_TYPE_UQUOTA] = {	/* user quota */
>  		.setup = xfs_scrub_setup_quota,
>  		.scrub = xfs_scrub_quota,
>  	},
> -	{ /* group quota */
> +	[XFS_SCRUB_TYPE_GQUOTA] = {	/* group quota */
>  		.setup = xfs_scrub_setup_quota,
>  		.scrub = xfs_scrub_quota,
>  	},
> -	{ /* project quota */
> +	[XFS_SCRUB_TYPE_PQUOTA] = {	/* project quota */
>  		.setup = xfs_scrub_setup_quota,
>  		.scrub = xfs_scrub_quota,
>  	},
> @@ -297,6 +297,9 @@
>  	bool				try_harder = false;
>  	int				error = 0;
>  
> +	BUILD_BUG_ON(sizeof(meta_scrub_ops) !=
> +		(sizeof(struct xfs_scrub_meta_ops) * XFS_SCRUB_TYPE_NR));
> +
>  	trace_xfs_scrub_start(ip, sm, error);
>  
>  	/* Forbidden if we are shut down or mounted norecovery. */
> @@ -320,7 +323,7 @@
>  	if (sm->sm_type >= XFS_SCRUB_TYPE_NR)
>  		goto out;
>  	ops = &meta_scrub_ops[sm->sm_type];
> -	if (ops->scrub == NULL)
> +	if (ops->setup == NULL || ops->scrub == NULL)
>  		goto out;
>  
>  	/*
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
