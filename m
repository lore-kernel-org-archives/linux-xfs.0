Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8ECaLN3140311 for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 07:36:22 -0500
Subject: Re: xfs: fix a use after free in xfs_end_io_direct_write
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110913222600.GA26677@infradead.org>
References: <20110913222600.GA26677@infradead.org>
Date: Wed, 14 Sep 2011 07:36:16 -0500
Message-ID: <1316003776.4030.1.camel@doink>
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

On Tue, 2011-09-13 at 18:26 -0400, Christoph Hellwig wrote:
> There is a window in which the ioend that we call inode_dio_wake on
> in xfs_end_io_direct_write is already free.  Fix this by storing
> the inode pointer in a local variable.
> 
> This is a fix for the regression introduced in 3.1-rc by
> "fs: move inode_dio_done to the end_io handler".
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
