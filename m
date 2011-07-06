Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6649JuR065737 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 23:09:20 -0500
Subject: Re: [PATCH 26/27] xfs: cleanup I/O-related buffer flags
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110701094607.536262104@bombadil.infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094607.536262104@bombadil.infradead.org>
Date: Tue, 5 Jul 2011 23:09:15 -0500
Message-ID: <1309925355.3381.55.camel@doink>
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

On Fri, 2011-07-01 at 05:43 -0400, Christoph Hellwig wrote:
> Remove the unused and misnamed _XBF_RUN_QUEUES flag, rename XBF_LOG_BUFFER
> to the more fitting XBF_SYNCIO, and split XBF_ORDERED into XBF_FUA and
> XBF_FLUSH to allow more fine grained control over the bio flags.  Also
> cleanup processing of the flags in _xfs_buf_ioapply to make more sense,
> and renumber the sparse flag number space to group flags by purpose.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Interesting that _XBF_RUN_QUEUES was never actually used.
The new names are much more understandable.  Looks like
READ_META and WRITE_META are now effectively gone...

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
