Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42972 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932496AbcI3H0v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:26:51 -0400
Date: Fri, 30 Sep 2016 00:26:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 20/63] xfs: log bmap intent items
Message-ID: <20160930072650.GB13587@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520486550.29434.1414641708433838018.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520486550.29434.1414641708433838018.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

> +/* The XFS_BMAP_EXTENT_* in xfs_log_format.h must match these. */
> +enum xfs_bmap_intent_type {
> +	XFS_BMAP_MAP = 1,
> +	XFS_BMAP_UNMAP,
> +};

Meh.  Please just use it directly then.

Otherwise this looks ok, so a conditional:

Reviewed-by: Christoph Hellwig <hch@lst.de>

based on fixing the above.
