Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB14Uo3s170917 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 22:30:51 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC7991B819D
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 20:32:32 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	laycuSN2YrdQEzW5 for <xfs@oss.sgi.com>;
	Tue, 30 Nov 2010 20:32:32 -0800 (PST)
Date: Wed, 1 Dec 2010 15:32:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/10] xfs: kill xfs_iomap
Message-ID: <20101201043227.GF16922@dastard>
References: <20101122130506.868076797@bombadil.infradead.org>
	<20101122130903.938808862@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101122130903.938808862@bombadil.infradead.org>
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

On Mon, Nov 22, 2010 at 08:05:11AM -0500, Christoph Hellwig wrote:
> Opencode the xfs_iomap code in it's two callers.  The overlap of passed
> flags already was minimal and will be further reduced in the next patch.
> 
> As a side effect the BMAPI_* flags for xfs_bmapi and the IO_* flags
> for I/O end processing are merged into a single set of flags, which
> should be a bit more descriptive of the operation we perform.
> 
> Also improve the tracing by giving each caller it's own type set of
> tracepoints.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok. Minor comment:

> @@ -1472,7 +1563,7 @@ xfs_vm_direct_IO(
>  	ssize_t			ret;
>  
>  	if (rw & WRITE) {
> -		iocb->private = xfs_alloc_ioend(inode, IO_NEW);
> +		iocb->private = xfs_alloc_ioend(inode, 0);
>  
>  		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
>  					    offset, nr_segs,

Using an ioend type to "0" is not very obvious given all the other
uses have a defined type. I know that this converted to IO_UNWRITTEN
in IO completion if neceessary, but perhaps a IO_DIRECT type might
be better just to document it? Or perhaps a comment stating why 0 is
OK to use here?

Everything else looks fine, so:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
