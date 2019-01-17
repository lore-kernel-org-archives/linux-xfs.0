Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52508 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfAQOWV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 09:22:21 -0500
Date: Thu, 17 Jan 2019 06:22:21 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/22] xfs: refactor kernel-specific parts of xfs_ialloc
Message-ID: <20190117142221.GD16270@infradead.org>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
 <154630917828.18437.11659667761358440410.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154630917828.18437.11659667761358440410.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 31, 2018 at 06:19:38PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the kernel-specific parts of xfs_ialloc into a separate function in
> preparation for hoisting xfs_ialloc to libxfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.c |   45 ++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 36 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 403eb8fa2f1f..b635d43caeed 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -621,6 +621,32 @@ xfs_lookup(
>  	return error;
>  }
>  
> +/* Return an exclusive ILOCK'd in-core inode. */
> +static int
> +xfs_ialloc_iget(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_ino_t		ino,
> +	struct xfs_inode	**ipp)
> +{
> +	return xfs_iget(mp, tp, ino, XFS_IGET_CREATE, XFS_ILOCK_EXCL, ipp);
> +}

This is just too ugly and pointless.  Can you explain (or even better
show code) why we really need this for xfsprogs?

> +	xfs_ialloc_platform_init(tp, args, ip);

And that platform naming also is rather horrible.
