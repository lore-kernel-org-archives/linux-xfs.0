Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97JeCd3258962 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 14:40:12 -0500
Subject: Re: [PATCH 7/9] xfs: clean up xfs_ioerror_alert
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111006210639.731475087@bombadil.infradead.org>
References: <20111006210607.175284390@bombadil.infradead.org>
	<20111006210639.731475087@bombadil.infradead.org>
Date: Fri, 7 Oct 2011 14:37:16 -0500
Message-ID: <1318016236.2810.45.camel@doink>
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

On Thu, 2011-10-06 at 17:06 -0400, Christoph Hellwig wrote:
> Instead of passing the block number and mount structure explicitly
> get them off the bp and fix make the argument order more natural.
> 
> Also move it to xfs_buf.c and stop printing the device name given
> that we already get the fs name as part of xfs_alert, and we know
> what device is operates on because of the caller that gets printed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I agree on the name change suggestion, possibly to
xfs_buf_error_alert().  Also, with just one exception
it seems that the "func" argument is simply the name
of the calling function.  I would favor adding that
via passing __func__ in a macro.  If distinguishing
between the cases in xlog_sync(), xfs_trans_read_buf(),
and xfs_zero_remaining_bytes() were important then
the line number could be included.

Anyway, looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
