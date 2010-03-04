Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o24MsvTf203134 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 16:54:57 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23C2521AF0A
	for <xfs@oss.sgi.com>; Thu,  4 Mar 2010 14:56:24 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	YkdwUsq8gCI11l0Y for <xfs@oss.sgi.com>;
	Thu, 04 Mar 2010 14:56:24 -0800 (PST)
Date: Fri, 5 Mar 2010 09:56:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: check for more work before sleeping in xfssyncd
Message-ID: <20100304225621.GL14317@discord.disaster>
References: <1267667185-7736-1-git-send-email-david@fromorbit.com>
	<1267667185-7736-2-git-send-email-david@fromorbit.com>
	<20100304135050.GA31753@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100304135050.GA31753@infradead.org>
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

On Thu, Mar 04, 2010 at 08:50:50AM -0500, Christoph Hellwig wrote:
> On Thu, Mar 04, 2010 at 12:46:23PM +1100, Dave Chinner wrote:
> > xfssyncd processes a queue of work by detaching the queue and
> > then iterating over all the work items. It then sleeps for a
> > time period or until new work comes in. If new work is queued
> > while xfssyncd is actively processing the detached work queue,
> > it will not process that new work until after a sleep timeout
> > or the next work event queued wakes it.
> > 
> > Fix this by checking the work queue again before going to sleep.
> 
> Looks good, as does the list_splice cleanup not mentioned in the
> changelog.  But I really wonder if we shouldn't just call the
> flushing routine directly instead of going through xfssyncd.
> 
> The xfssyncd queueing infrastructure is quite a lot of hairy code
> just to save a bit of stack space in two places rather high
> up in the callchain.

Yeah, there is a lot cruft in that code. A good amount of cleanup
could be done here, but I'm not going to tackle that today.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
