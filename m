Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4AIbshl197955 for <xfs@oss.sgi.com>; Sun, 10 May 2009 13:37:54 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C9AF1D21897
	for <xfs@oss.sgi.com>; Sun, 10 May 2009 11:37:59 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id oskKFVtXxRYZwEvT for
	<xfs@oss.sgi.com>; Sun, 10 May 2009 11:37:59 -0700 (PDT)
Message-ID: <4A071F06.8040106@sandeen.net>
Date: Sun, 10 May 2009 13:37:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 5/5] xfs: fix xfs_quiesce_data
References: <20090426140305.113371000@bombadil.infradead.org>
	<20090426140708.279368000@bombadil.infradead.org>
In-Reply-To: <20090426140708.279368000@bombadil.infradead.org>
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

> We need to do a synchronous xfs_sync_fsdata to make sure the superblock
> actually is on disk when we return.  While we're at it also remove the
> superflous SYNC_BDFLUSH flag to xfs_sync_inodes, and move the xfs_filestream_flush
> call later [hch: why?  seems unrelated].

What makes SYNC_BDFLUSH "superfluous?" ... oh ... because nothing in
that callchain below ever looks for it.  Could we make that more obvious
in the changelog?

I guess I too would like a reason for the filestream_flush move
somewhere in the changelog...

Adding the SYNC_WAIT looks good to me though :)

-Eric

> 
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-04-26 10:46:17.112949525 +0200
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.c	2009-04-26 10:48:19.713979813 +0200
> @@ -323,16 +323,16 @@ xfs_quiesce_data(
>  	int error;
>  
>  	/* push non-blocking */
> -	xfs_sync_inodes(mp, SYNC_DELWRI|SYNC_BDFLUSH);
> +	xfs_sync_inodes(mp, SYNC_DELWRI);
>  	XFS_QM_DQSYNC(mp, SYNC_BDFLUSH);
> -	xfs_filestream_flush(mp);
>  
> -	/* push and block */
> +	/* push and block till complete */
>  	xfs_sync_inodes(mp, SYNC_DELWRI|SYNC_WAIT|SYNC_IOWAIT);
>  	XFS_QM_DQSYNC(mp, SYNC_WAIT);
> +	xfs_filestream_flush(mp);
>  
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
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
