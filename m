Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p81Lkf0I041290 for <xfs@oss.sgi.com>; Thu, 1 Sep 2011 16:46:42 -0500
Date: Thu, 1 Sep 2011 17:46:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/11] xfs: call xfs_buf_delwri_queue directly
Message-ID: <20110901214640.GB4579@infradead.org>
References: <20110823082802.335389799@bombadil.infradead.org>
	<20110823082912.512830398@bombadil.infradead.org>
	<1314904935.2903.62.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1314904935.2903.62.camel@doink>
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

On Thu, Sep 01, 2011 at 02:22:15PM -0500, Alex Elder wrote:
> that the buffer should be queued at unlock time, we now
> just put it in the queue right away.  Seems reasonable.
> Do you know why enqueueing it was delayed before?

I don't know why - it's a carryover from IRIX days, so long before my
time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
