Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52199 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750782AbdDAHEH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Apr 2017 03:04:07 -0400
Date: Sat, 1 Apr 2017 00:04:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix memory exposure problems
Message-ID: <20170401070406.GA6051@infradead.org>
References: <20170401012934.GI4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170401012934.GI4864@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 31, 2017 at 06:29:34PM -0700, Darrick J. Wong wrote:
> Fix a couple of memory exposure problems in the getbmap implementation
> where we copy too much header data from userspace, and a second problem
> in inumbers where we allocate an array of structures with holes, fail to
> zero the holes, then blindly copy the kernel memory contents into
> userspace.

This should be two different patches.

> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1547,10 +1547,10 @@ xfs_ioc_getbmap(
>  	unsigned int		cmd,
>  	void			__user *arg)
>  {
> -	struct getbmapx		bmx;
> +	struct getbmapx		bmx = {0};

missing spaces around the zero.

>  	int			error;
>  
> -	if (copy_from_user(&bmx, arg, sizeof(struct getbmapx)))
> +	if (copy_from_user(&bmx, arg, sizeof(struct getbmap)))
>  		return -EFAULT;

This really needs a comment on how struct getbmap is a strict subset
of struct getbmapx.  Or even better don't use getbmap at all
and use offsetoff on struct getbmapx.  

> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index e775f78..55642cd 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -584,7 +584,7 @@ xfs_inumbers(
>  		return error;
>  
>  	bcount = MIN(left, (int)(PAGE_SIZE / sizeof(*buffer)));
> -	buffer = kmem_alloc(bcount * sizeof(*buffer), KM_SLEEP);
> +	buffer = kmem_zalloc(bcount * sizeof(*buffer), KM_SLEEP);

This looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
