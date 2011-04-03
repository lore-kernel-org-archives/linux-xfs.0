Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p33AuiKt101926 for <xfs@oss.sgi.com>; Sun, 3 Apr 2011 05:56:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9644639A73D
	for <xfs@oss.sgi.com>; Sun,  3 Apr 2011 03:59:58 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id VC0f8AODuB49yth8 for
	<xfs@oss.sgi.com>; Sun, 03 Apr 2011 03:59:58 -0700 (PDT)
Date: Sun, 3 Apr 2011 06:59:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfs: convert the xfsaild threads to a workqueue
Message-ID: <20110403105957.GB3872@infradead.org>
References: <1299715529-11026-1-git-send-email-david@fromorbit.com>
	<1299715529-11026-6-git-send-email-david@fromorbit.com>
	<20110310174818.GE19609@infradead.org>
	<20110318040648.GG30195@dastard>
	<20110319134500.GB10056@infradead.org>
	<20110403003847.GI6957@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110403003847.GI6957@dastard>
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

On Sun, Apr 03, 2011 at 10:38:47AM +1000, Dave Chinner wrote:
> FWIW, we already have an implicit delay for frequent callers when
> the AIL is busy - the uninterruptible sleep for  sleeps of <= 20ms.
> That was implemented specifically to rate-limit wakeups while the
> xfsaild was busy pushing. This is essentially a different
> implementation of the same mechanism.

In that cases maybe the minum delay of the delayed work should stay
at 20ms?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
