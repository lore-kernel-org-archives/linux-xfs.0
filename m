Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB2Bd6Hq014506 for <xfs@oss.sgi.com>; Thu, 2 Dec 2010 05:39:06 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C5581C888FB
	for <xfs@oss.sgi.com>; Thu,  2 Dec 2010 03:40:50 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5sagJsvC2a0Yp2Lj for
	<xfs@oss.sgi.com>; Thu, 02 Dec 2010 03:40:50 -0800 (PST)
Date: Thu, 2 Dec 2010 06:40:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/14] xfs: clean up log space grant functions
Message-ID: <20101202114049.GB21365@infradead.org>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-3-git-send-email-david@fromorbit.com>
	<20101201123032.GA20378@infradead.org>
	<20101202014833.GN16922@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101202014833.GN16922@dastard>
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

On Thu, Dec 02, 2010 at 12:48:33PM +1100, Dave Chinner wrote:
> Ok, so your main objection is the needless addition to the queue?
> That can be avoided easily enough via a local variable. Would that
> be sufficient to alleviate your concerns?

The main objection is that the new code might be a bit shorted,
but is a lot less readable.  If you really want it go with it and
an updated changelog mentioning the behaviour change, but I don't
really feel too good about it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
