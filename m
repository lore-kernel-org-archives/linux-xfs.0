Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6R7t9Xw173362 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 02:55:10 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A92D474C85
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 00:53:14 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HD77Niy0jb2fYCWx for
	<xfs@oss.sgi.com>; Tue, 27 Jul 2010 00:53:14 -0700 (PDT)
Date: Tue, 27 Jul 2010 03:53:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't hold the XFS_ILOCK while flushing pages in
	swapext
Message-ID: <20100727075313.GB30562@infradead.org>
References: <1280209651-10800-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1280209651-10800-1-git-send-email-david@fromorbit.com>
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

On Tue, Jul 27, 2010 at 03:47:31PM +1000, Dave Chinner wrote:
> +
> +	/*
> +	 * can't hold the ILOCK while flushing pages, so flush now we won't get
> +	 * new pages cached as we hold the XFS_IOLOCK_EXCL.
> +	 */
> +	if (VN_CACHED(VFS_I(tip)) != 0) {

There's really no point in the VN_CACHED check here.  Not only does
xfs_flushinval_pages repeat it at the beginning, but it's also
rather superflous as filemap_write_and_wait deals with the condition
of no attached pages efficiently.

Otherwise looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
