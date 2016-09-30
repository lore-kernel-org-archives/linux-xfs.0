Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43222 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751824AbcI3Hjf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:39:35 -0400
Date: Fri, 30 Sep 2016 00:39:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 29/63] xfs: introduce the CoW fork
Message-ID: <20160930073934.GA951@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520492856.29434.17061076591831860945.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520492856.29434.17061076591831860945.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

> +/* XFS_IEXT_STATE_TO_FORK() -- Convert BMAP state flags to an inode fork. */
> +xfs_ifork_t *
> +XFS_IEXT_STATE_TO_FORK(
> +	struct xfs_inode	*ip,
> +	int			state)
> +{
> +	if (state & BMAP_COWFORK)
> +		return ip->i_cowfp;
> +	else if (state & BMAP_ATTRFORK)
> +		return ip->i_afp;
> +	return &ip->i_df;
> +}

Would be nice to have a lower ase name for this.  And while we're at
it drop duplicating the function name in the top of the function
comment.

Othwerise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
