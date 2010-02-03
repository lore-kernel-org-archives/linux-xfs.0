Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13Ktdsi243899 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 14:55:39 -0600
Date: Wed, 3 Feb 2010 15:56:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/10] xfs: xfs_fs_write_inode() can fail to write
	inodes synchronously V2
Message-ID: <20100203205648.GA23116@infradead.org>
References: <1265153104-29680-1-git-send-email-david@fromorbit.com>
	<1265153104-29680-10-git-send-email-david@fromorbit.com>
	<20100203112753.GA19996@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100203112753.GA19996@infradead.org>
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
Cc: bpm@sgi.com, xfs@oss.sgi.com

On Wed, Feb 03, 2010 at 06:27:53AM -0500, Christoph Hellwig wrote:
> Still not entirely happy with this one.  The first one is that I think
> the barriers in fsync are still too heavy for the normal sync use
> case.  I'd be more happy with exporting the body of xfs_fsync without
> the cache flushes (and a ebtter name than xfs_fsync) and use that
> for write_inode.
> 
> That leaves open the NFSD case thought.  I'd prefer to have that fixed
> if possibly.  Ben, any chance you could send your patch to use fsync
> to the nfs list ASAP?  I think we'd be even better off to just force
> -o wsync and disable ->write_inode entirely for NFS, any chance you
> could test such a patch on your setup?

Thinking about it, we usually do cause a log buffer write from ->fsync
which means we submit the barrier anyway.  That might be the reason
why you're not seeing the performance hit in your testing.  With that
I'm okay with the patch as-is for now, we can micro-optimize it later.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
