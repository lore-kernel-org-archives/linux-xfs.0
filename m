Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p81JMKtp035144 for <xfs@oss.sgi.com>; Thu, 1 Sep 2011 14:22:20 -0500
Subject: Re: [PATCH 04/11] xfs: call xfs_buf_delwri_queue directly
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110823082912.512830398@bombadil.infradead.org>
References: <20110823082802.335389799@bombadil.infradead.org>
	<20110823082912.512830398@bombadil.infradead.org>
Date: Thu, 1 Sep 2011 14:22:15 -0500
Message-ID: <1314904935.2903.62.camel@doink>
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
> Unify the ways we add buffers to the delwri queue by always calling
> xfs_buf_delwri_queue directly.  The xfs_bdwrite functions is removed and
> opencoded in its callers, and the two places setting XBF_DELWRI while a
> buffer is locked and expecting xfs_buf_unlock to pick it up are converted
> to call xfs_buf_delwri_queue directly, too.  Also replace the
> XFS_BUF_UNDELAYWRITE macro with direct calls to xfs_buf_delwri_dequeue
> to make the explicit queuing/dequeuing more obvious.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

So instead of just marking XBF_DELWRI to flag to signal
that the buffer should be queued at unlock time, we now
just put it in the queue right away.  Seems reasonable.
Do you know why enqueueing it was delayed before?

In any case:
Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
