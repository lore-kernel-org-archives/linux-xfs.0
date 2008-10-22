Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 14:29:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9MLT6of022405
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 14:29:06 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72BE610D1717
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 14:30:51 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id EpoaxF4SEJh5uES8 for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 14:30:51 -0700 (PDT)
Date: Thu, 23 Oct 2008 08:30:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] free partially initialized inodes using
	destroy_inode
Message-ID: <20081022213049.GS18495@disturbed>
References: <20081022163129.GC25556@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022163129.GC25556@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Oct 22, 2008 at 12:31:29PM -0400, Christoph Hellwig wrote:
> To make sure we free the security data inodes need to be freed using
> the proper VFS helper (which we also need to export for this). We mark
> these inodes bad so we can skip the flush path for them.

Looks good, except for one minor mistake in a comment:

> Index: xfs-2.6/fs/xfs/xfs_inode.h
> ===================================================================
> --- xfs-2.6.orig/fs/xfs/xfs_inode.h	2008-10-22 17:57:30.000000000 +0200
> +++ xfs-2.6/fs/xfs/xfs_inode.h	2008-10-22 18:00:15.000000000 +0200
> @@ -310,6 +310,23 @@ static inline struct inode *VFS_I(struct
>  }
>  
>  /*
> + * Get rid of a partially initialized inode.
> + *
> + * We have to go through destroy_inode to make sure allocations
> + * from init_inode_always like the security data are undone.
> + *
> + * We mark the inode dirty so that it takes the short cut in
                        ^^^^^
			"bad"

> + * the reclaim path instead of going through the flush path
> + * which doesn't make sense for an inode that has never seen the
> + * light of day.
> + */
> +static inline void xfs_destroy_inode(struct xfs_inode *ip)
> +{
> +	make_bad_inode(VFS_I(ip));
> +	return destroy_inode(VFS_I(ip));
> +}
> +
> +/*
>   * i_flags helper functions
>   */
>  static inline void

I don't think this needs another round of review just to fix the
comment, so it can probably go straight in if the committer can
touch up that comment.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
