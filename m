Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2F7wn5H257263 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 02:59:09 -0500
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB4D5199C64
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 00:58:26 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	R6cujFeJpg3FPW1D for <xfs@oss.sgi.com>;
	Sun, 15 Mar 2009 00:58:26 -0700 (PDT)
Date: Sun, 15 Mar 2009 18:58:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/7] xfs: factor out code to find the longest free
	extent in the AG
Message-ID: <20090315075824.GV26138@disturbed>
References: <20090220085207.663702000@bombadil.infradead.org>
	<20090220085230.115970000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090220085230.115970000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Fri, Feb 20, 2009 at 03:52:14AM -0500, Christoph Hellwig wrote:
> From: Dave Chinner <dgc@sgi.com>
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>

....

>  /*
> + * Find the length of the longest extent in an AG.
> + */
> +xfs_extlen_t
> +xfs_alloc_min_freelist(
> +	struct xfs_mount	*mp,
> +	struct xfs_perag	*pag)

Looking at this again, I'd change the name of this function
to xfs_alloc_ag_longest_free_extent(), because that is what it
is actually returning....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
