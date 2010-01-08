Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o08ANJK7029595 for <xfs@oss.sgi.com>; Fri, 8 Jan 2010 04:23:19 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9DE7F151C9F
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2010 02:24:12 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rDhnMslyIEURfvpg for
	<xfs@oss.sgi.com>; Fri, 08 Jan 2010 02:24:12 -0800 (PST)
Date: Fri, 8 Jan 2010 05:24:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: reclaim all inodes by background tree walks
Message-ID: <20100108102408.GB16640@infradead.org>
References: <1262819125-27083-1-git-send-email-david@fromorbit.com>
	<1262819125-27083-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1262819125-27083-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


Looks safe to me.  I wonder whaimpact leaving the inodes around for
longer has to memory usage for inode heavy workloads, though.

>  unlock_and_requeue:
> +	/*
> +	 * We could return EAGAIN here to make reclaim rescan the inode tree in
> +	 * a short while. However, this just burns CPU time scanning the tree
> +	 * waiting for IO to complete and xfssyncd never goes back to the idle
> +	 * state. Instead, return 0 to let the next scheduled background reclaim
> +	 * attempt to reclaim the inode again.
> +	 */
>  	xfs_iflags_clear(ip, XFS_IRECLAIM);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	return EAGAIN;
> +	return 0;

This is an unrelated change and should be a patch of it's own.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
