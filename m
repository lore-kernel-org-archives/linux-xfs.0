Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 15:09:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m41M9lAY002716
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 15:09:51 -0700
Date: Thu, 1 May 2008 18:10:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Don't allow memory reclaim to wait on the filesystem
	in inode writeback
Message-ID: <20080501221030.GA4857@infradead.org>
References: <20080501122611.GK108924158@sgi.com> <20080501131521.GA7435@infradead.org> <20080501220825.GN108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501220825.GN108924158@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, May 02, 2008 at 08:08:25AM +1000, David Chinner wrote:
> Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2008-04-28 16:35:23.000000000 +1000
> +++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2008-05-02 08:03:30.071824780 +1000
> @@ -2986,7 +2986,7 @@ xfs_iflush_cluster(
>  	ASSERT(pag->pag_ici_init);
>  
>  	ilist_size = XFS_INODE_CLUSTER_SIZE(mp) * sizeof(xfs_inode_t *);
> -	ilist = kmem_alloc(ilist_size, KM_MAYFAIL);
> +	ilist = kmem_alloc(ilist_size, KM_MAYFAIL|KM_NOFS);
>  	if (!ilist)
>  		return 0;

Looks good.
