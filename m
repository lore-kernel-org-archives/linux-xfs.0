Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54098 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfAQOY2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 09:24:28 -0500
Date: Thu, 17 Jan 2019 06:24:27 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/22] xfs: refactor special inode roll out of
 xfs_dir_ialloc
Message-ID: <20190117142427.GF16270@infradead.org>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
 <154630921076.18437.14193766050551378677.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154630921076.18437.14193766050551378677.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

> diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
> index 5a1d98d1546d..ee274d74b8d4 100644
> --- a/fs/xfs/libxfs/xfs_inode_util.h
> +++ b/fs/xfs/libxfs/xfs_inode_util.h
> @@ -82,6 +82,12 @@ struct xfs_ialloc_ops {
>  
>  	/* Do any final setup needed before we return the inode. */
>  	void (*setup)(struct xfs_inode *ip);
> +
> +	/*
> +	 * Roll the transaction between allocating a new ichunk and
> +	 * initializing a new inode core.
> +	 */
> +	int (*ichunk_roll)(struct xfs_trans **tpp);

Sorry, but this whole idea to add gracious indirect calls is just
backwards.  They do have a non-trivial cost, and we should rather
get rid of pointless indirect calls instead of adding more.
