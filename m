Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D73287F3F
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2014 18:54:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B35C88F8033
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2014 16:54:52 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	RblbTyadBcoLLwNk for <xfs@oss.sgi.com>;
	Sun, 06 Jul 2014 16:54:50 -0700 (PDT)
Date: Mon, 7 Jul 2014 09:54:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] libxfs: reused invalidated buffers leak state and data
Message-ID: <20140706235444.GP9508@dastard>
References: <1404453435-1915-1-git-send-email-david@fromorbit.com>
	<1404453435-1915-5-git-send-email-david@fromorbit.com>
	<20140704141509.GB29520@infradead.org>
	<20140704222210.GM9508@dastard>
	<20140705094807.GB18130@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140705094807.GB18130@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, Jul 05, 2014 at 02:48:07AM -0700, Christoph Hellwig wrote:
> On Sat, Jul 05, 2014 at 08:22:10AM +1000, Dave Chinner wrote:
> > I'm open to other ways of fixing this, but right now we've got to
> > fix xfs_repair because it's currently breaking filesystems worse
> > than before xfs_repair was run...
> 
> Ok, so clearly mark this as difference from kernel code in a long
> comment explaining the situation similar to wrote you above. 

Will do.

> It's
> pretty obvious that the buffer cache in userspace will eventually need
> a major overhaul sooner or later.  I wonder how feasible porting the
> kernel one would be..

It's not so much the porting that's the issue - it's cleaning up all
the applications that use it that is the headache. And,
realistically, I don't think there's much of the kernel code that
can be used - we have to rewrite all the allocation, freeing,
locking and IO parts of it, so we'd pretty much be re-implementing
most of it, anyway....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
