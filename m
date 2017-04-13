Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49125 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751368AbdDMJxM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 05:53:12 -0400
Date: Thu, 13 Apr 2017 02:53:11 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: reserve enough blocks to handle btree splits when
 remapping
Message-ID: <20170413095311.GA21980@infradead.org>
References: <20170412214852.GR8502@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170412214852.GR8502@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

> +static inline unsigned int
> +XFS_RMAPADD_SPACE_RES(
> +	struct xfs_mount	*mp)
> +{
> +	return xfs_sb_version_hasrmapbt(&mp->m_sb) ? mp->m_rmap_maxlevels : 0;
> +}

All the other helpers are macros.  While I much prefer inlines it might
be a good idea to do it in one go and also convert them to lower case
instead of screaming..

> +#define XFS_NRMAPADD_SPACE_RES(mp,b,w)\
> +	(((b + XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp) - 1) / \
> +	  XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)) * \
> +	  XFS_RMAPADD_SPACE_RES(mp))

But then again the above is so much more readable than this, so maybe
it's a good idea after all and this one should be an inline as well.

Also I think future developers will really appreciate comments
explaining what we add up here.

Otherwise this looks fine and test fine for me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Christoph Hellwig <hch@lst.de>
