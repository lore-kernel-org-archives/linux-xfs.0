Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3U0T5Fe175671 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 19:29:05 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mG4fT6FcSYhAtMW4 for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 17:29:03 -0700 (PDT)
Date: Mon, 30 Apr 2012 10:29:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/18] xfs: page type check in writeback only checks last
	buffer
Message-ID: <20120430002900.GA3283@dastard>
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
	<1334319061-12968-5-git-send-email-david@fromorbit.com>
	<20120429213926.GB19889@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120429213926.GB19889@infradead.org>
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

On Sun, Apr 29, 2012 at 05:39:26PM -0400, Christoph Hellwig wrote:
> On Fri, Apr 13, 2012 at 10:10:47PM +1000, Dave Chinner wrote:
> > The problem was first noticed by Peter Watkins.
> 
> Was this a user visible bug?  Do we have a test case for it?

Not that I know of, and no. It was noticed by Peter when doing some
work to try to understand the writeback code and the
allocation-to-data-write crash hole.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
