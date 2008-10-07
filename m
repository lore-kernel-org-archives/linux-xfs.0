Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:19:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97LJke9027646
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:19:47 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0FB29FEB4C
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 14:21:26 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id hmPK1yQBkNRiGHZl for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 14:21:26 -0700 (PDT)
Date: Wed, 8 Oct 2008 08:21:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] kill xfs_ialloc_log_di
Message-ID: <20081007212123.GU30001@disturbed>
References: <20081007202157.GB16485@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007202157.GB16485@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Oct 07, 2008 at 10:21:57PM +0200, Christoph Hellwig wrote:
> xfs_ialloc_log_di alwasy logs the full inode core + di_next_unlinked, so
> there's really no need for all the offset magic and we can just call
> xfs_trans_log_buf directly from it's only user.  Also add a comment
> describing what we should do here instead.

Looks like a good idea. I'll have to redo some patches on top of
this, but otherwise I think it's fine.

> @@ -406,18 +344,25 @@ xfs_ialloc_ag_alloc(
>  					 XFS_BUF_LOCK);
>  		ASSERT(fbuf);
>  		ASSERT(!XFS_BUF_GETERROR(fbuf));
> +
>  		/*
> -		 * Set initial values for the inodes in this buffer.
> +		 * Initialize all inodes in this buffer and then log them.
> +		 *
> +		 * XXX: It would be much better if we had just one transaction to
> +		 *      log a whole cluster of inodes instead of all the indivdual
> +		 *      transactions causing a lot of log traffic.
>  		 */

That's the patch series I'll need to redo on top of this. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
