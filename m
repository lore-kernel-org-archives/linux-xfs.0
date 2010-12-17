Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBH0LFan156422 for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 18:21:17 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ECAB21CD2D19
	for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 16:23:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id NBXFhIGr6bN3d1Yf for
	<xfs@oss.sgi.com>; Thu, 16 Dec 2010 16:23:09 -0800 (PST)
Date: Thu, 16 Dec 2010 19:23:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] xfs: reduce the number of AIL push wakeups
Message-ID: <20101217002307.GA24135@infradead.org>
References: <1292214743-18073-1-git-send-email-david@fromorbit.com>
	<1292214743-18073-6-git-send-email-david@fromorbit.com>
	<20101216153846.GC24185@infradead.org>
	<20101216215050.GA5193@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101216215050.GA5193@dastard>
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

On Fri, Dec 17, 2010 at 08:50:50AM +1100, Dave Chinner wrote:
> What tests?

I couldn't really see a pattern yet - it's different ones and different
amount of warnings during each run.

> So this is saying is that a 20ms uninterruptible sleep lasting for more
> than 120s? Doesn't that imply some kind of scheduler starvation, not
> an actual XFS problem?

It does for sure look odd to me.  I'll do a sub-commit bisect between
the two hunk in the patch tomorrow to drill a bit deeper into what's
going on.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
