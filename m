Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 05:45:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m37CjcMH001711
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 05:45:39 -0700
Date: Mon, 7 Apr 2008 08:46:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch] Remove xlog_ticket allocator
Message-ID: <20080407124613.GA27350@infradead.org>
References: <20080401231439.GU103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401231439.GU103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Apr 02, 2008 at 09:14:39AM +1000, David Chinner wrote:
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2008-03-13 13:58:08.866070224 +1100
> +++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2008-03-13 13:59:59.208010688 +1100
> @@ -68,15 +68,17 @@ xfs_init(void)
>  	/*
>  	 * Initialize all of the zone allocators we use.
>  	 */
> +	xfs_log_ticket_zone = kmem_zone_init(sizeof(xlog_ticket_t),
> +						"xfs_log_ticket");
>  	xfs_bmap_free_item_zone = kmem_zone_init(sizeof(xfs_bmap_free_item_t),
> -						 "xfs_bmap_free_item");
> +						"xfs_bmap_free_item");
>  	xfs_btree_cur_zone = kmem_zone_init(sizeof(xfs_btree_cur_t),
> -					    "xfs_btree_cur");
> -	xfs_trans_zone = kmem_zone_init(sizeof(xfs_trans_t), "xfs_trans");
> -	xfs_da_state_zone =
> -		kmem_zone_init(sizeof(xfs_da_state_t), "xfs_da_state");
> +						"xfs_btree_cur");
> +	xfs_da_state_zone = kmem_zone_init(sizeof(xfs_da_state_t),
> +						"xfs_da_state");
>  	xfs_dabuf_zone = kmem_zone_init(sizeof(xfs_dabuf_t), "xfs_dabuf");
>  	xfs_ifork_zone = kmem_zone_init(sizeof(xfs_ifork_t), "xfs_ifork");
> +	xfs_trans_zone = kmem_zone_init(sizeof(xfs_trans_t), "xfs_trans");

kmem_zone_init can fail so both for the new and old calls we need
some error handling here.  Could probably be a separate patch.

Otherwise this looks fine.
