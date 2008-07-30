Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 19:08:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6U28FCt012816
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 19:08:15 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 782F633FBC7
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 19:09:27 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id r7ZQMu2GYb15QRCC for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 19:09:27 -0700 (PDT)
Date: Wed, 30 Jul 2008 12:09:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/21] implement generic xfs_btree_decrement
Message-ID: <20080730020919.GK13395@disturbed>
References: <20080729193058.GK19104@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729193058.GK19104@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Jul 29, 2008 at 09:30:58PM +0200, Christoph Hellwig wrote:
> From: Dave Chinner <dgc@sgi.com>
> 
> [hch: split out from bigger patch and minor adaptions]
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
....
> +	/*
> +	 * If we went off the root then we are seriously confused.
> +	 * or the root of the tree is in an inode.
> +	 */
> +	if (lev == cur->bc_nlevels) {
> +		ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
> +		goto out0;
> +	}

Same question as for the increment case.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
