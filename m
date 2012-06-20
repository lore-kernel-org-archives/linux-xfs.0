Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5K6U2pX248679 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 01:30:02 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	GZeac837QEKbem8Z for <xfs@oss.sgi.com>;
	Tue, 19 Jun 2012 23:30:00 -0700 (PDT)
Date: Wed, 20 Jun 2012 16:29:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/9] xfs: convert internal buffer functions to pass maps
Message-ID: <20120620062931.GC30705@dastard>
References: <1339133914-11148-1-git-send-email-david@fromorbit.com>
	<1339133914-11148-3-git-send-email-david@fromorbit.com>
	<20120618204325.GX4721@sgi.com> <20120618210713.GY4721@sgi.com>
	<20120619071552.GA23093@infradead.org>
	<20120619155946.GA2676@sgi.com>
	<20120619170304.GC7554@infradead.org>
	<20120619171153.GD2676@sgi.com> <20120620055619.GA30705@dastard>
	<20120620060400.GA5617@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120620060400.GA5617@infradead.org>
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
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Wed, Jun 20, 2012 at 02:04:00AM -0400, Christoph Hellwig wrote:
> On Wed, Jun 20, 2012 at 03:56:19PM +1000, Dave Chinner wrote:
> > > they are rebased not to require the inode allocator patchset.  I think that Jan
> > > is also going to repost his 'Fix overallocation in xfs_buf_allocate_memory()'
> > > based upon Dave's suggestions.  It's best not to depend upon that either.  What
> > > do you say, Dave?
> > 
> > I reorder my local patch set and repost it after running it through
> > some testing....
> 
> Sorry, I totally misunderstood the initial issue - I though Ben had my
> series applied, and thus yours didn't apply.

No, other way around ;)

But I'm going to leave Jan kara's buffer cache over-allocation bug
fix ahead my list, because that has to go into 3.5-rcX as it is a
regression fix....

FWIW, Ben, there's a few reviewed bug fixes on the list that are
outstanding that need to go to Linus ASAP:

http://oss.sgi.com/archives/xfs/2012-06/msg00154.html
http://oss.sgi.com/archives/xfs/2012-06/msg00134.html
http://oss.sgi.com/archives/xfs/2012-06/msg00056.html (regression)

Can you take care of them please?

> I still think reordering is better - I'm quite busy and I'd rather get
> your series reviewed first before redoing and retesting the inode
> allocator changes.
> 
> In fact I'll start reviewing them in about 10 minutes after I've
> finished catching up on email for this morning.

Cool. I'm just rebasing right now....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
