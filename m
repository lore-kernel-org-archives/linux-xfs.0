Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37779 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751444AbeAZMHm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 07:07:42 -0500
Date: Fri, 26 Jan 2018 04:07:41 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/11] xfs: only grab shared inode locks for source file
 during reflink
Message-ID: <20180126120741.GA30851@infradead.org>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676028976.12349.5695190502888561177.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151676028976.12349.5695190502888561177.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

> +xfs_lock_two_inodes_separately(
> +	struct xfs_inode	*ip0,
> +	uint			ip0_mode,
> +	struct xfs_inode	*ip1,
> +	uint			ip1_mode)

We only have 6 calls to xfs_lock_two_inodes in total, so just update
the signature to take two modes and be done with it.

Also how about mode1 and mode2 for the argument names?

>  	lp = (xfs_log_item_t *)ip0->i_itemp;
>  	if (lp && (lp->li_flags & XFS_LI_IN_AIL)) {
> -		if (!xfs_ilock_nowait(ip1, xfs_lock_inumorder(lock_mode, 1))) {
> -			xfs_iunlock(ip0, lock_mode);
> +		if (!xfs_ilock_nowait(ip1, xfs_lock_inumorder(ip1_mode, 1))) {
> +			xfs_iunlock(ip0, ip0_mode);
>  			if ((++attempts % 5) == 0)
>  				delay(1); /* Don't just spin the CPU */
>  			goto again;
>  		}
>  	} else {
> -		xfs_ilock(ip1, xfs_lock_inumorder(lock_mode, 1));
> +		xfs_ilock(ip1, xfs_lock_inumorder(ip1_mode, 1));
>  	}
>  }

Not directly related to your patch, but the the nowait + retry
mess must go away.

I think we need to move to the VFS locking conventions, that is
based on ancestors for directories (see lock_rename) and otherwise
based on the struct inode address as in lock_two_nondirectories.

>       if (src_last)
> -             inode_lock_nested(src, I_MUTEX_NONDIR2);
> +             down_read_nested(&src->i_rwsem, I_MUTEX_NONDIR2);

Why is this not using inode_lock_nested any more?
