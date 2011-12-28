Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBSLaB1H225619 for <xfs@oss.sgi.com>; Wed, 28 Dec 2011 15:36:12 -0600
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.186]) by cuda.sgi.com with ESMTP id
	MNNOE8AeE77fXV3r for <xfs@oss.sgi.com>;
	Wed, 28 Dec 2011 13:36:08 -0800 (PST)
From: "Hans-Peter Jansen" <hpj@urpla.net>
Subject: Re: [PATCH 1/1] xfs: log the inode in ->write_inode calls for kupdate
Date: Wed, 28 Dec 2011 22:35:56 +0100
References: <20111218154936.GA17626@infradead.org>
	<20111218154955.GB17626@infradead.org>
In-Reply-To: <20111218154955.GB17626@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201112282235.57645.hpj@urpla.net>
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
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Paul Anderson <pha@umich.edu>, Sean Thomas Caron <scaron@umich.edu>

On Sunday 18 December 2011, 16:49:55 Christoph Hellwig wrote:
> If the writeback code writes back an inode because it has expired we
> currently use the non-blockin ->write_inode path.  This means any
> inode that is pinned is skipped.  With delayed logging and a workload
> that has very little log traffic otherwise it is very likely that an
> inode that gets constantly written to is always pinned, and thus we
> keep refusing to write it.  The VM writeback code at that point
> redirties it and doesn't try to write it again for another 30
> seconds.  This means under certain scenarious time based metadata
> writeback never happens.

Wouldn't this qualify as STABLE material then?

> Fix this by calling into xfs_log_inode for kupdate in addition to
> data integrity syncs, and thus transfer the inode to the log ASAP.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: xfs/fs/xfs/xfs_super.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_super.c	2011-12-14 05:33:07.193262189 -0800
> +++ xfs/fs/xfs/xfs_super.c	2011-12-14 05:38:56.108038623 -0800
> @@ -905,7 +884,7 @@ xfs_fs_write_inode(
>  	if (!ip->i_update_core)
>  		return 0;
>
> -	if (wbc->sync_mode == WB_SYNC_ALL) {
> +	if (wbc->sync_mode == WB_SYNC_ALL || wbc->for_kupdate) {
>  		/*
>  		 * Make sure the inode has made it it into the log.  Instead
>  		 * of forcing it all the way to stable storage using a
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
