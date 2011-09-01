Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p81JMum6035472 for <xfs@oss.sgi.com>; Thu, 1 Sep 2011 14:22:56 -0500
Subject: Re: [PATCH 10/11] xfs: wait for I/O completion when writing out
	pages in xfs_setattr_size
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110823082913.640125155@bombadil.infradead.org>
References: <20110823082802.335389799@bombadil.infradead.org>
	<20110823082913.640125155@bombadil.infradead.org>
Date: Thu, 1 Sep 2011 14:22:52 -0500
Message-ID: <1314904972.2903.69.camel@doink>
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

On Tue, 2011-08-23 at 04:28 -0400, Christoph Hellwig wrote:
> The current code relies on the xfs_ioend_wait call later on to make sure
> all I/O actually has completed.  The xfs_ioend_wait call will go away soon,
> so prepare for that by using the waiting filemap function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
