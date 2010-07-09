Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o69GAVPO122084 for <xfs@oss.sgi.com>; Fri, 9 Jul 2010 11:10:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 77563BA1B63
	for <xfs@oss.sgi.com>; Fri,  9 Jul 2010 09:19:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id aoDof8XBPTBiqi1A for
	<xfs@oss.sgi.com>; Fri, 09 Jul 2010 09:19:08 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OXGCa-000766-9Y
	for xfs@oss.sgi.com; Fri, 09 Jul 2010 16:13:24 +0000
Date: Fri, 9 Jul 2010 12:13:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: remove incorrect log write optimization
Message-ID: <20100709161324.GB26302@infradead.org>
References: <20100628143434.GA5473@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100628143434.GA5473@infradead.org>
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

ping?

On Mon, Jun 28, 2010 at 10:34:34AM -0400, Christoph Hellwig wrote:
> We do need a barrier for the first buffer of a split log write.  Otherwise
> we might incorrectly stamp the tail LSN into transactions in the first
> block, or not flush data I/O before updating the inode size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs-dev/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs-dev.orig/fs/xfs/xfs_log.c	2010-06-28 11:51:30.423004228 +0200
> +++ xfs-dev/fs/xfs/xfs_log.c	2010-06-28 11:52:52.559255519 +0200
> @@ -1423,11 +1423,8 @@ xlog_sync(xlog_t		*log,
>  	XFS_BUF_BUSY(bp);
>  	XFS_BUF_ASYNC(bp);
>  	bp->b_flags |= XBF_LOG_BUFFER;
> -	/*
> -	 * Do an ordered write for the log block.
> -	 * Its unnecessary to flush the first split block in the log wrap case.
> -	 */
> -	if (!split && (log->l_mp->m_flags & XFS_MOUNT_BARRIER))
> +
> +	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
>  		XFS_BUF_ORDERED(bp);
>  
>  	ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
