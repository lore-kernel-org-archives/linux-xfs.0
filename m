Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB36i8iw068839 for <xfs@oss.sgi.com>; Fri, 3 Dec 2010 00:44:08 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE5041BBBA4
	for <xfs@oss.sgi.com>; Thu,  2 Dec 2010 22:45:51 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	R0JAypqSAnXnyy86 for <xfs@oss.sgi.com>;
	Thu, 02 Dec 2010 22:45:51 -0800 (PST)
Date: Fri, 3 Dec 2010 17:45:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/14] xfs: clean up log space grant functions
Message-ID: <20101203064548.GD23339@dastard>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-3-git-send-email-david@fromorbit.com>
	<20101201123032.GA20378@infradead.org>
	<20101202014833.GN16922@dastard>
	<20101202114049.GB21365@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101202114049.GB21365@infradead.org>
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

On Thu, Dec 02, 2010 at 06:40:50AM -0500, Christoph Hellwig wrote:
> On Thu, Dec 02, 2010 at 12:48:33PM +1100, Dave Chinner wrote:
> > Ok, so your main objection is the needless addition to the queue?
> > That can be avoided easily enough via a local variable. Would that
> > be sufficient to alleviate your concerns?
> 
> The main objection is that the new code might be a bit shorted,
> but is a lot less readable.  If you really want it go with it and
> an updated changelog mentioning the behaviour change, but I don't
> really feel too good about it.

OK, I'll drop it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
