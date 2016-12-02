Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54909 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755026AbcLBNUw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 08:20:52 -0500
Date: Fri, 2 Dec 2016 05:20:44 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: make xfs btree stats less huge
Message-ID: <20161202132044.GC426@infradead.org>
References: <20161201103052.28453-1-david@fromorbit.com>
 <20161201103052.28453-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161201103052.28453-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org


> --- a/fs/xfs/xfs_stats.h
> +++ b/fs/xfs/xfs_stats.h
> @@ -21,10 +21,30 @@
>  
>  #include <linux/percpu.h>
>  
> +enum {
> +	__XBTS_lookup = 0,

Add a comment on top of the enum to explain these are the
offsets into each btree type?

> +#define XFS_STATS_CALC_INDEX(member)	\
> +	(offsetof(struct __xfsstats, member) / (int)sizeof(__uint32_t))

what's that int cast for?

Except for these nitpicks this looks great:

Reviewed-by: Christoph Hellwig <hch@lst.de>
