Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P5K7O7163656 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 00:20:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3540111019
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 22:20:06 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	3VB7N1D6HbTDJHCF for <xfs@oss.sgi.com>;
	Wed, 24 Aug 2011 22:20:06 -0700 (PDT)
Date: Thu, 25 Aug 2011 01:20:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: use per-filesystem I/O completion workqueues
Message-ID: <20110825052004.GB5617@infradead.org>
References: <20110824055924.139283426@bombadil.infradead.org>
	<20110824060150.001321834@bombadil.infradead.org>
	<20110825004811.GK3162@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110825004811.GK3162@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Aug 25, 2011 at 10:48:11AM +1000, Dave Chinner wrote:
> The only issue I see with this is that it brings back per-filesystem
> workqueue threads. Because all the workqueues are defined with
> MEM_RECLAIM, there is a rescuer thread per workqueue that is used
> when the CWMQ cannot allocate memory to queue the work to the
> appropriate per-cpu queue.

Not much we can do about it.

> If we are going to block here, then we probably should increase the
> per-cpu concurrency of the work queue so that we can continue to
> process other ioends while this one is blocked.

True.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
