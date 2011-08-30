Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7U6TTLU117521 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 01:29:30 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B55F213AD4F3
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 23:32:47 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	hrSbmSDclIA9WHE8 for <xfs@oss.sgi.com>;
	Mon, 29 Aug 2011 23:32:47 -0700 (PDT)
Date: Tue, 30 Aug 2011 16:29:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: avoid direct I/O write vs buffered I/O race
Message-ID: <20110830062924.GP3162@dastard>
References: <20110827144253.GA16381@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110827144253.GA16381@infradead.org>
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

On Sat, Aug 27, 2011 at 10:42:53AM -0400, Christoph Hellwig wrote:
> Currently a buffered reader or writer can add pages to the pagecache
> while we are waiting for the iolock in xfs_file_dio_aio_write.  Prevent
> this by re-checking mapping->nrpages after we got the iolock, and if
> nessecary upgrade the lock to exclusive mode.  To simplify this a bit
> only take the ilock inside of xfs_file_aio_write_checks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks sane. Pushing the ILOCK completely into
xfs_file_aio_write_checks() is a nice segregation of locking
responsibilities.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
