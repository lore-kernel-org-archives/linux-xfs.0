Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41772 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752641AbdLUNhA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Dec 2017 08:37:00 -0500
Date: Thu, 21 Dec 2017 05:36:59 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfs: track cowblocks separately in i_flags
Message-ID: <20171221133659.GA10079@infradead.org>
References: <151335786780.26575.15542999972223359181.stgit@magnolia>
 <151335787965.26575.17711793213679430025.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151335787965.26575.17711793213679430025.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

> +static inline unsigned long
> +xfs_iflag_for_tag(
> +	int		tag)
> +{
> +	switch (tag) {
> +	case XFS_ICI_EOFBLOCKS_TAG:
> +		return XFS_IEOFBLOCKS;
> +	case XFS_ICI_COWBLOCKS_TAG:
> +		return XFS_ICOWBLOCKS;
> +	default:
> +		ASSERT(0);
> +		return 0;
> +	}
> +}

I'd rather pass the flag explicitly to the functions that already
take the tag value.

Except for that the patch looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
