Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59835 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932469AbcI2RBL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 13:01:11 -0400
Date: Thu, 29 Sep 2016 10:01:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 37/63] xfs: cancel CoW reservations and clear inode
 reflink flag when freeing blocks
Message-ID: <20160929170109.GF4546@infradead.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503145516.30303.8096168526472457811.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147503145516.30303.8096168526472457811.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Tue, Sep 27, 2016 at 07:57:35PM -0700, Darrick J. Wong wrote:
> +	/* Remove all pending CoW reservations. */
> +	error = xfs_reflink_cancel_cow_blocks(ip, &tp, first_unmap_block,
> +			last_block);
> +	if (error)
> +		goto out;
> +
> +	/*
> +	 * Clear the reflink flag if we truncated everything.
> +	 */
> +	if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip))
> +		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;

Shouldn't this (and the later added clearing of the cowblocks tag)
be moved into xfs_reflink_cancel_cow_blocks?
