Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EIwebV026940 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 12:58:40 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 1/3] xfs: kill XFS_QMOPT_ASYNC
Date: Thu, 14 Jan 2010 12:59:34 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6970@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20100113220602.632551077@bombadil.infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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

Christoph Hellwig wrote:
> The option is unused and one of the few remaining users of xfs_bawrite,
> so let's get rid of it.

Looks good.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>


> Index: linux-2.6/fs/xfs/quota/xfs_dquot.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/quota/xfs_dquot.c	2010-01-08 15:10:07.694006652 +0100
> +++ linux-2.6/fs/xfs/quota/xfs_dquot.c	2010-01-08 15:10:26.227006460 +0100
> @@ -1253,8 +1253,6 @@ xfs_qm_dqflush(
> 
>  	if (flags & XFS_QMOPT_DELWRI) {
>  		xfs_bdwrite(mp, bp);
> -	} else if (flags & XFS_QMOPT_ASYNC) {
> -		error = xfs_bawrite(mp, bp);
>  	} else {
>  		error = xfs_bwrite(mp, bp);
>  	}
> Index: linux-2.6/fs/xfs/xfs_quota.h
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_quota.h	2010-01-08 15:10:07.729006360 +0100
> +++ linux-2.6/fs/xfs/xfs_quota.h	2010-01-08 15:10:12.062005658 +0100
> @@ -226,7 +226,6 @@ typedef struct xfs_qoff_logformat {
>   * flags for dqflush and dqflush_all.
>   */
>  #define XFS_QMOPT_SYNC		0x1000000
> -#define XFS_QMOPT_ASYNC		0x2000000
>  #define XFS_QMOPT_DELWRI	0x4000000
> 
>  /*
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
