Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4P0XGtZ106108 for <xfs@oss.sgi.com>; Tue, 24 May 2011 19:33:16 -0500
Subject: Re: [PATCH 8/9] xfs: fix up asserts in xfs_iflush_fork
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110511150712.830693893@bombadil.infradead.org>
References: <20110511150402.258164661@bombadil.infradead.org>
	<20110511150712.830693893@bombadil.infradead.org>
Date: Tue, 24 May 2011 19:32:01 -0500
Message-ID: <1306283521.2823.97.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: xfs@oss.sgi.com

On Wed, 2011-05-11 at 11:04 -0400, Christoph Hellwig wrote:
> Remove asserts in xfs_iflush_fork that would call xfs_iext_get_ext with
> a potentially invalid extent buffer index.
> 
> Based on an earlier patch from Lachlan McIlroy.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This states that it's invalid to attempt to
request the first (0th) extent, because it's
invalid if the fork has no extents, right?

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfs/fs/xfs/xfs_inode.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode.c	2011-05-11 10:18:39.555233397 +0200
> +++ xfs/fs/xfs/xfs_inode.c	2011-05-11 12:04:24.099733330 +0200
> @@ -2557,12 +2557,9 @@ xfs_iflush_fork(
>  	case XFS_DINODE_FMT_EXTENTS:
>  		ASSERT((ifp->if_flags & XFS_IFEXTENTS) ||
>  		       !(iip->ili_format.ilf_fields & extflag[whichfork]));
> -		ASSERT((xfs_iext_get_ext(ifp, 0) != NULL) ||
> -			(ifp->if_bytes == 0));
> -		ASSERT((xfs_iext_get_ext(ifp, 0) == NULL) ||
> -			(ifp->if_bytes > 0));
>  		if ((iip->ili_format.ilf_fields & extflag[whichfork]) &&
>  		    (ifp->if_bytes > 0)) {
> +			ASSERT(xfs_iext_get_ext(ifp, 0));
>  			ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) > 0);
>  			(void)xfs_iextents_copy(ip, (xfs_bmbt_rec_t *)cp,
>  				whichfork);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
