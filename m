Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p68AK9AT233396 for <xfs@oss.sgi.com>; Fri, 8 Jul 2011 05:20:09 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F96917A52D0
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2011 03:20:08 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	XnpzOHSZJskQGOBG for <xfs@oss.sgi.com>;
	Fri, 08 Jul 2011 03:20:08 -0700 (PDT)
Date: Fri, 8 Jul 2011 20:20:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/28] xfs: kill the unused struct xfs_sync_work
Message-ID: <20110708102006.GL1026@dastard>
References: <20110707110535.205001532@bombadil.infradead.org>
	<20110707110642.697024790@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110707110642.697024790@bombadil.infradead.org>
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

On Thu, Jul 07, 2011 at 07:05:46AM -0400, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alex Elder <aelder@sgi.com>
> 
> Index: xfs/fs/xfs/linux-2.6/xfs_sync.h
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_sync.h	2011-06-30 15:47:30.203125879 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_sync.h	2011-06-30 15:47:39.093125768 +0200
> @@ -21,14 +21,6 @@
>  struct xfs_mount;
>  struct xfs_perag;
>  
> -typedef struct xfs_sync_work {
> -	struct list_head	w_list;
> -	struct xfs_mount	*w_mount;
> -	void			*w_data;	/* syncer routine argument */
> -	void			(*w_syncer)(struct xfs_mount *, void *);
> -	struct completion	*w_completion;
> -} xfs_sync_work_t;
> -
>  #define SYNC_WAIT		0x0001	/* wait for i/o to complete */
>  #define SYNC_TRYLOCK		0x0002  /* only try to lock inodes */

Oops, my fault!


Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
