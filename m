Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 22:35:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8G5ZFBp005433
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:35:15 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 396E3445BA2
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:36:44 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 0vQGCmCk25DBNY1a for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:36:44 -0700 (PDT)
Date: Tue, 16 Sep 2008 15:36:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] cleanup maxrecs calculation
Message-ID: <20080916053641.GV5811@disturbed>
References: <20080915004648.GD12213@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915004648.GD12213@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Sep 15, 2008 at 02:46:48AM +0200, Christoph Hellwig wrote:
> +	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
> +	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);

That's kind of strange - index 0 gets configured with a leaf (?)
value of 1, and index 1 with a value of 0. Can we change the order
of one of these so that the function and the variables match?

Would a define for what the function parameter means make sense?
That way the code would document itself....

> @@ -650,7 +650,8 @@ xfs_iformat_btree(
>  	 * Copy and convert from the on-disk structure
>  	 * to the in-memory structure.
>  	 */
> -	xfs_bmdr_to_bmbt(dfp, XFS_DFORK_SIZE(dip, ip->i_mount, whichfork),
> +	xfs_bmdr_to_bmbt(ip->i_mount, dfp,
> +			 XFS_DFORK_SIZE(dip, ip->i_mount, whichfork),
>  		ifp->if_broot, size);

Indenting could do with some fixing there.

Otherwise looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
