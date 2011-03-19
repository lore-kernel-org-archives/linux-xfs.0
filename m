Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2JDg7Vc097067 for <xfs@oss.sgi.com>; Sat, 19 Mar 2011 08:42:17 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD597159A030
	for <xfs@oss.sgi.com>; Sat, 19 Mar 2011 06:45:04 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id L04SqhDXnurEacwa for
	<xfs@oss.sgi.com>; Sat, 19 Mar 2011 06:45:04 -0700 (PDT)
Date: Sat, 19 Mar 2011 09:45:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfs: convert the xfsaild threads to a workqueue
Message-ID: <20110319134500.GB10056@infradead.org>
References: <1299715529-11026-1-git-send-email-david@fromorbit.com>
	<1299715529-11026-6-git-send-email-david@fromorbit.com>
	<20110310174818.GE19609@infradead.org>
	<20110318040648.GG30195@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110318040648.GG30195@dastard>
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

On Fri, Mar 18, 2011 at 03:06:48PM +1100, Dave Chinner wrote:
> It gets used by a second caller in the next patch that uses a
> timeout of zero. The idea of adding a delay to a normal push is to
> rate limit the number of times we do work so we always work on
> batches rather a few items at a time in multiple executions of the
> work.
>
> I'll see if it's simpler to just do this work directly in teh
> callers, though.

I don't think hiding this delay (uncommented) in the workqueue use is
a good idea.  xlog_grant_push_ail has all the logics about when to push
the AIL, so any batching should be grouped with that logic, and
documented there.  It in fact already has some comments static that
a min/max watermark scheme would be useful.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
