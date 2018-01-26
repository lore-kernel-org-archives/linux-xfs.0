Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:32881 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751475AbeAZMVK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 07:21:10 -0500
Date: Fri, 26 Jan 2018 04:21:09 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfs: skip CoW writes past EOF when writeback races
 with truncate
Message-ID: <20180126122109.GF15859@infradead.org>
References: <151693228803.7395.12526880865470882359.stgit@magnolia>
 <151693231885.7395.533058591055949677.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151693231885.7395.533058591055949677.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

> +	/*
> +	 * Apparently truncate can race with writeback since writeback doesn't

The apparently here looks rather snarky, I'd remove it.

> +	 * take the iolock and truncate decreases the file size before it
> +	 * starts truncating the pages between new_size and old_size.
> +	 * Therefore, we can end up in the situation where writeback gets a
> +	 * CoW fork mapping but the truncate makes the mapping invalid and we
> +	 * end up in here trying to get a new mapping.  Bail out here so that
> +	 * we simply never get a valid mapping and so we drop the write
> +	 * altogether.  The page truncation will kill the contents anyway.
> +	 */
> +	if (type == XFS_IO_COW && offset > i_size_read(inode))
> +		return 0;

Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
