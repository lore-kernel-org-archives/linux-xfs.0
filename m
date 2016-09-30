Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43008 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751111AbcI3HeF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:34:05 -0400
Date: Fri, 30 Sep 2016 00:34:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 23/63] xfs: implement deferred bmbt map/unmap operations
Message-ID: <20160930073404.GD13587@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520489048.29434.18226996933853750466.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520489048.29434.18226996933853750466.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

> +/* Deferred mapping is only for real extents in the data fork. */
> +static bool
> +xfs_bmap_is_update_needed(
> +	int			whichfork,
> +	struct xfs_bmbt_irec	*bmap)
> +{
> +	ASSERT(whichfork == XFS_DATA_FORK);
> +
> +	return  bmap->br_startblock != HOLESTARTBLOCK &&
> +		bmap->br_startblock != DELAYSTARTBLOCK;
> +}

Passing in an argument just to assert on it seems weird.
And except for that a better name might be xfs_bmbt_is_real or similar,
and I bet we'd have other users for it as well.

Otherwise this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
