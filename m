Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54935 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932073AbeDWR35 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Apr 2018 13:29:57 -0400
Date: Mon, 23 Apr 2018 19:31:20 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/13] xfs: refactor xfs_qm_dqtobp and xfs_qm_dqalloc
Message-ID: <20180423173120.GH834@lst.de>
References: <152440954198.29601.14390250048915099607.stgit@magnolia> <152440960423.29601.4842354354335883165.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152440960423.29601.4842354354335883165.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

>  /*
> + * Ensure that the given in-core dquot has a buffer on disk backing it, and
> + * return the buffer. This is called when the bmapi finds a hole.
>   */
>  STATIC int
> +xfs_qm_dqalloc_ondisk(
> +	struct xfs_trans	**tpp,
> +	struct xfs_dquot	*dqp,
> +	struct xfs_buf		**bpp)
>  {
> +	struct xfs_bmbt_irec	map;
> +	struct xfs_defer_ops	dfops;
> +	struct xfs_mount	*mp = (*tpp)->t_mountp;
> +	struct xfs_buf		*bp;
> +	struct xfs_inode	*quotip;
> +	xfs_fsblock_t		firstblock;
> +	int			nmaps = 1;
> +	int			error;
>  
>  	trace_xfs_dqalloc(dqp);
>  
> +	quotip = xfs_quota_inode(mp, dqp->dq_flags);

I'd initialize quotip on the line where it is declarated.

> +xfs_qm_dqread_ondisk(
> +	struct xfs_mount	*mp,
> +	struct xfs_dquot	*dqp,
> +	struct xfs_buf		**bpp)
>  {
>  	struct xfs_bmbt_irec	map;
>  	struct xfs_buf		*bp;
>  	struct xfs_inode	*quotip;
>  	uint			lock_mode;
> +	int			nmaps = 1;
> +	int			error;
>  
> +	quotip = xfs_quota_inode(mp, dqp->dq_flags);

Same here?

Also shouldn't the function names be something like

xfs_dquot_disk_alloc and xfs_dquot_disk_read?
