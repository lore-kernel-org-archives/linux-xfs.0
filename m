Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Jul 2008 00:31:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6U7VZqs023178
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 00:31:36 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B95E33F17E
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 00:32:48 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 3xwR0CbXktI7mFd9 for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 00:32:48 -0700 (PDT)
Date: Wed, 30 Jul 2008 17:32:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 21/21] clean up xfs_bmap_btree.c
Message-ID: <20080730073245.GV13395@disturbed>
References: <20080729193200.GV19104@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729193200.GV19104@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Jul 29, 2008 at 09:32:00PM +0200, Christoph Hellwig wrote:
> From: Dave Chinner <dgc@sgi.com>
> 
> Reimplement xfs_bmbt_newroot and xfs_bmbt_kill_root using the new generic
> btree helpers and clean out all cruft needed for the old implementations.
> 
> This requires exporting some functionality from xfs_btree.c that's only
> used locally otherwise.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....
> +	nrecs += i;
> +	xfs_btree_set_numrecs(block, nrecs);
> +
> +	ASSERT(nrecs == crecs);
> +	kp = xfs_bmbt_key_addr(cur, 1, block);
> +	ckp = xfs_bmbt_key_addr(cur, 1, cblock);
> +	memcpy(kp, ckp, nrecs * sizeof(xfs_bmbt_key_t));

Should really be xfs_bmbt_copy_keys(), right?

> +	pp = xfs_bmbt_ptr_addr(cur, 1, block);
> +	cpp = xfs_bmbt_ptr_addr(cur, 1, cblock);
> +
> +#ifdef DEBUG
> +	for (i = 0; i < crecs; i++) {
> +		int	error;
> +
> +		error = xfs_btree_check_ptr(cur, cpp, i, level - 1);
> +		if (error) {
> +			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> +			return error;
> +		}
> +	}
> +#endif
> +
> +	memcpy(pp, cpp, nrecs * sizeof(xfs_bmbt_key_t));

xfs_bmbt_copy_recs()?

Otherwise looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
