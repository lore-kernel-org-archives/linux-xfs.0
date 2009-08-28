Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SNI1r9183345 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 18:18:11 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 4/4] [PATCH 5/5] xfs: fix xfs_quiesce_data 
Date: Fri, 28 Aug 2009 18:18:45 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ABF5@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090827231558.701516609@bombadil.infradead.org>
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
> From: Dave Chinner <david@fromorbit.com>
> 
> We need to do a synchronous xfs_sync_fsdata to make sure the superblock
> actually is on disk when we return.
> 
> Also remove SYNC_BDFLUSH flag to xfs_sync_inodes because that particular
> flag is never checked.
> 
> Move xfs_filestream_flush call later [hch: why?  seems unrelated].

I concur with your question.  Why not release the inode references early?

> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-08-27 20:06:39.889355294 -0300
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.c	2009-08-27 20:08:01.169357854 -0300
> @@ -426,14 +426,16 @@ xfs_quiesce_data(
>  	/* push non-blocking */
>  	xfs_sync_data(mp, 0);
>  	xfs_qm_sync(mp, SYNC_TRYLOCK);
> -	xfs_filestream_flush(mp);
> 
> -	/* push and block */
> +	/* push and block till complete */
>  	xfs_sync_data(mp, SYNC_WAIT);
>  	xfs_qm_sync(mp, SYNC_WAIT);
> 
> +	/* drop inode references pinned by filestreams */
> +	xfs_filestream_flush(mp);
> +
>  	/* write superblock and hoover up shutdown errors */
> -	error = xfs_sync_fsdata(mp, 0);
> +	error = xfs_sync_fsdata(mp, SYNC_WAIT);
> 
>  	/* flush data-only devices */
>  	if (mp->m_rtdev_targp)
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
