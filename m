Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2GAcJNl084737 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 05:38:40 -0500
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5B751C45FD1
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 03:37:57 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	u4qp2hv4XMufCuqo for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2009 03:37:57 -0700 (PDT)
Date: Mon, 16 Mar 2009 21:37:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] XFS: Prevent unwritten extent conversion from
	blocking I/O completion
Message-ID: <20090316103753.GG26138@disturbed>
References: <1237117243-25940-1-git-send-email-david@fromorbit.com>
	<1237117243-25940-2-git-send-email-david@fromorbit.com>
	<20090316092124.GA21496@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090316092124.GA21496@infradead.org>
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

On Mon, Mar 16, 2009 at 05:21:24AM -0400, Christoph Hellwig wrote:
> On Sun, Mar 15, 2009 at 10:40:42PM +1100, Dave Chinner wrote:
> > Unwritten extent conversion can recurse back into the filesystem due
> > to memory allocation. Memory reclaim requires I/O completions to be
> > processed to allow the callers to make progress. If the I/O
> > completion workqueue thread is doing the recursion, then we have a
> > deadlock situation.
> > 
> > Move unwritten extent completion into it's own workqueue so it
> > doesn't block I/O completions for normal delayed allocation or
> > overwrite data.
> 
> Hmm.   That was the original reason behind splitting the data from
> xfsbufd queue.  So maybe the split should be just unwritten vs the
> rest and three queues?
> 
> Btw, do you have a testcase that can reproduce this?

No, I hit it a couple of times running xfsqa on a low memory UML
image - 256MB of RAM, IIRC - during one of the fstress tests. I got
enough information to determine this was the problem and it hasn't
showed up since. I think someone also posted a lockdep trace
on LKML a couple of months back as well...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
