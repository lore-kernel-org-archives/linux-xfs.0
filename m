Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52504 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934267AbcI2QtV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 12:49:21 -0400
Date: Thu, 29 Sep 2016 09:49:20 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/63] xfs: define tracepoints for refcount btree
 activities
Message-ID: <20160929164920.GC4546@infradead.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503122918.30303.16146439086000365868.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147503122918.30303.16146439086000365868.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

> +#ifndef XFS_REFCOUNT_IREC_PLACEHOLDER
> +#define XFS_REFCOUNT_IREC_PLACEHOLDER
> +/* Placeholder definition to avoid breaking bisectability. */
> +struct xfs_refcount_irec {
> +	xfs_agblock_t	rc_startblock;	/* starting block number */
> +	xfs_extlen_t	rc_blockcount;	/* count of free blocks */
> +	xfs_nlink_t	rc_refcount;	/* number of inodes linked here */
> +};
> +#endif

Oh well, I had hoped we could get rid of these place holder by folding
the tracepoint patches into their actual users.

But except for that this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
