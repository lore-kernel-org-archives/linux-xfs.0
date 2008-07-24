Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 16:36:00 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6ONZxtN018033
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:35:59 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5DCBF1924BC7
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:37:09 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id dr69GXBBnJZxJN3S for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:37:09 -0700 (PDT)
Date: Fri, 25 Jul 2008 09:36:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/15] refactor xfs_btree_readahead
Message-ID: <20080724233655.GH15438@disturbed>
References: <20080723200859.GH7401@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723200859.GH7401@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 10:08:59PM +0200, Christoph Hellwig wrote:
> From: Dave Chinner <dgc@sgi.com>

Can i review my own code? ;)

> Refactor xfs_btree_readahead to make it more readable:
> 
>  (a) remove the inline xfs_btree_readahead wrapper and move all checks out
>      of line into the main routine.
>  (b) factor out helpers for short/long form btrees
>  (c) move check for root in inodes from the callers into xfs_btree_readahead
> 
> 
> [hch: split out from a big patch and minor cleanups]
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-11 11:13:15.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-11 11:13:20.000000000 +0200
> @@ -709,66 +709,84 @@ xfs_btree_reada_bufs(
>  	xfs_baread(mp->m_ddev_targp, d, mp->m_bsize * count);
>  }
>  
> +STATIC int
> +xfs_btree_reada_corel(

I've been wondering if this is the best naming convention -
appending a single s or l to indicate short or long btree ops.
Perhaps this would be better as xfs_btree_readahead_short() and
xfs_btree_readahead_long(), esp. as we dropped the 'core' from
the caller to make it xfs_btree_readahead().

Otherwise it looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
