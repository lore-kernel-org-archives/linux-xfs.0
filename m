Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6814P3p204820 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 20:04:26 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 482CE17A23D9
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 18:04:24 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DvDA1bFdHhdf9Z0a for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 18:04:24 -0700 (PDT)
Date: Fri, 8 Jul 2011 11:04:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: use a cursor for bulk AIL insertion
Message-ID: <20110708010421.GD1026@dastard>
References: <1309757260-5484-1-git-send-email-david@fromorbit.com>
	<1309757260-5484-3-git-send-email-david@fromorbit.com>
	<20110704212055.GA24500@infradead.org>
	<1310073976.1980.84.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1310073976.1980.84.camel@doink>
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

On Thu, Jul 07, 2011 at 04:26:16PM -0500, Alex Elder wrote:
> On Mon, 2011-07-04 at 17:20 -0400, Christoph Hellwig wrote:
> > FYI: the following patch implementing my suggested cleanups survived a
> > few rounds of xfsqa:
> 
> It also eliminates the concern I had about using the value
> of "lip" after falling off the front of the list with a
> list_for_each_entry_reverse().  A null pointer signifies
> no entry has a lower lsn than the one provided, and
> that covers both the "empty list" and the "lower than
> all other lsn's in the list" cases.
> 
> I think you should base your solution on Christoph's
> approach, Dave.

Already been updated to use hch's code ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
