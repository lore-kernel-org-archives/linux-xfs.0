Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:32795 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752402AbeAZJLS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 04:11:18 -0500
Date: Fri, 26 Jan 2018 01:11:18 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/11] xfs: fix up cowextsz allocation shortfalls
Message-ID: <20180126091118.GH29115@infradead.org>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676031559.12349.8327260913918740589.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151676031559.12349.8327260913918740589.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

> diff --git a/fs/iomap.c b/fs/iomap.c
> index e5de772..aec35a0 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -63,7 +63,7 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
>  	ret = ops->iomap_begin(inode, pos, length, flags, &iomap);
>  	if (ret)
>  		return ret;
> -	if (WARN_ON(iomap.offset > pos))
> +	if (WARN_ON(iomap.offset > pos) || WARN_ON(iomap.length == 0))
>  		return -EIO;
>  
>  	/*

Please split this into a separate patch.

Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
