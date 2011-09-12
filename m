Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8CIhdGE011458 for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 13:43:39 -0500
Subject: Re: [PATCH] xfs: avoid direct I/O write vs buffered I/O race
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110827144253.GA16381@infradead.org>
References: <20110827144253.GA16381@infradead.org>
Date: Mon, 12 Sep 2011 13:43:36 -0500
Message-ID: <1315853016.2898.64.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Sat, 2011-08-27 at 10:42 -0400, Christoph Hellwig wrote:
> Currently a buffered reader or writer can add pages to the pagecache
> while we are waiting for the iolock in xfs_file_dio_aio_write.  Prevent
> this by re-checking mapping->nrpages after we got the iolock, and if
> nessecary upgrade the lock to exclusive mode.  To simplify this a bit
> only take the ilock inside of xfs_file_aio_write_checks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I agree with Dave, moving the ILOCK acquisition into
xfs_file_aio_write_checks() is very nice.

In any case the core change looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
