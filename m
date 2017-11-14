Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39904 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750781AbdKNF7a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2017 00:59:30 -0500
Date: Mon, 13 Nov 2017 21:59:24 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fs, dax: unify IOMAP_F_DIRTY read vs write handling
 policy in the dax core
Message-ID: <20171114055924.GA15810@infradead.org>
References: <151062258598.8554.8157038002895095232.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151062258598.8554.8157038002895095232.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>

> -	if ((flags & IOMAP_WRITE) && xfs_ipincount(ip) &&
> -	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> -		iomap->flags |= IOMAP_F_DIRTY;
> +	if (xfs_ipincount(ip))
> +		if (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP)
> +			iomap->flags |= IOMAP_F_DIRTY;

Please don't split up the conditional and make it harder to read.

With that fixed up this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
