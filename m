Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p81Le06W041086 for <xfs@oss.sgi.com>; Thu, 1 Sep 2011 16:40:05 -0500
Date: Thu, 1 Sep 2011 17:39:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/11] xfs: remove the unlock argument to
	xfs_buf_delwri_queue
Message-ID: <20110901213957.GA4579@infradead.org>
References: <20110823082802.335389799@bombadil.infradead.org>
	<20110823082912.127871770@bombadil.infradead.org>
	<1314904924.2903.60.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1314904924.2903.60.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Sep 01, 2011 at 02:22:04PM -0500, Alex Elder wrote:
> On Tue, 2011-08-23 at 04:28 -0400, Christoph Hellwig wrote:
> > We can just unlock the buffer in the caller, and the decrement of b_hold
> > would also be needed in the !unlock, we just never hit that case currently
> > given that the caller handles that case.
> 
> More specifically, the only way we'd hit that case would
> involve an unqueued buffer (in xfs_buf_unlock()) getting
> queued before bt_delwrite_lock could be acquired (in
> xfs_buf_delwri_queue()).  But that can't happen because
> the buffer is locked the entire time between the check
> in xfs_buf_unlock() and the one in xfs_buf_delwri_queue().
> (Right?)

Exactly.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
