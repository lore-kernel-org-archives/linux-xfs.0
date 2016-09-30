Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45291 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbcI3Hqn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:46:43 -0400
Date: Fri, 30 Sep 2016 00:46:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 34/63] xfs: support removing extents from CoW fork
Message-ID: <20160930074642.GD951@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520496094.29434.16759424174258286275.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520496094.29434.16759424174258286275.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

>  /*
> + * xfs_bunmapi_cow() -- Remove the relevant parts of the CoW fork.
> + *			See xfs_bmap_del_extent.
> + * @ip: XFS inode.
> + * @idx: Extent number to delete.
> + * @del: Extent to remove.
> + */

Not quite a kerneldoc comment, not quite a normal one either..

That being sai the function seems mostly like a copy of the delay
part of xfs_bmap_del_extent and the duplication seems unfortunate.

As I plan to do a major rework of that area for the next merge
window I don't mind it for now, though.  

> +	xfs_bmbt_irec_t		*del)

Same for these uses of the old typedefs in new code.  I'd rather
avoid those, but instead of introducing churn now I'll sort this
out later.

So:

Reviewed-by: Christoph Hellwig <hch@lst.de>
