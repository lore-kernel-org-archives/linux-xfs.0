Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4S0YoFf179530 for <xfs@oss.sgi.com>; Thu, 27 May 2010 19:34:51 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CF7D149D8A8
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 17:39:07 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	Qpx07p3WTHstmtO1 for <xfs@oss.sgi.com>;
	Thu, 27 May 2010 17:39:07 -0700 (PDT)
Date: Fri, 28 May 2010 10:37:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Re-initialise lockdep context for all inodes in
	reclaim
Message-ID: <20100528003711.GU12087@dastard>
References: <1274925546-31468-1-git-send-email-david@fromorbit.com>
	<20100527122138.GA14632@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100527122138.GA14632@infradead.org>
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

On Thu, May 27, 2010 at 08:21:38AM -0400, Christoph Hellwig wrote:
> On Thu, May 27, 2010 at 11:59:06AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We re-initialise the lockdep context for inode iolocks when dropping an inode,
> > but not when we delete an inode. Now that we can reclaim inodes from a shrinker,
> > we can get get false lockdep warnings about inode iolock inversions during
> > reclaim of deleted inodes. Hence we need to re-initialise the iolock in the
> > delete path as well.
> 
> clear_inode also gets called when we delete an inode, so at least
> the rationale for this isn't quite right.  It seems like we re-acquire
> new lockdep dependecies between clear_inode and destroy_inode that your
> shrinker doesn't like.  What lockdep report do you see?

I'll have to regenerate it - I saw it a couple of times with the
current shrinker, and it went away with this patch. I'll put this
on hold for the moment.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
