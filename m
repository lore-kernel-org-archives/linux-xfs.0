Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2280SCo014669 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 02:00:28 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	UKg6LaqVE3Q0T8nf for <xfs@oss.sgi.com>;
	Fri, 02 Mar 2012 00:00:26 -0800 (PST)
Date: Fri, 2 Mar 2012 18:59:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/8] xfs: clean up minor sparse warnings
Message-ID: <20120302075954.GF5091@dastard>
References: <1330661507-1121-1-git-send-email-david@fromorbit.com>
	<1330661507-1121-2-git-send-email-david@fromorbit.com>
	<20120302074642.GC4117@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120302074642.GC4117@infradead.org>
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

On Fri, Mar 02, 2012 at 02:46:42AM -0500, Christoph Hellwig wrote:
> On Fri, Mar 02, 2012 at 03:11:40PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> 
> Why do you use this double from line?  It confuses all the patch apply
> scripts.

I didn't. It looks like the current version of guilt is busted
or doesn't work correctly with the current version of git. Basically
guilt hasn't stripped the From line out of the patch description
when using it for the commit message, so it's getting set by
git-send-email as well as being included in the commit message. It
must have broken when I updated everything last week...

I'll have a look at it and repost when I find out why it's now
busted.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
