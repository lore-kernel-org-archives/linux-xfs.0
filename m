Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5K645Ne244377 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 01:04:05 -0500
Date: Wed, 20 Jun 2012 02:04:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/9] xfs: convert internal buffer functions to pass maps
Message-ID: <20120620060400.GA5617@infradead.org>
References: <1339133914-11148-1-git-send-email-david@fromorbit.com>
	<1339133914-11148-3-git-send-email-david@fromorbit.com>
	<20120618204325.GX4721@sgi.com> <20120618210713.GY4721@sgi.com>
	<20120619071552.GA23093@infradead.org>
	<20120619155946.GA2676@sgi.com>
	<20120619170304.GC7554@infradead.org>
	<20120619171153.GD2676@sgi.com> <20120620055619.GA30705@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120620055619.GA30705@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Wed, Jun 20, 2012 at 03:56:19PM +1000, Dave Chinner wrote:
> > they are rebased not to require the inode allocator patchset.  I think that Jan
> > is also going to repost his 'Fix overallocation in xfs_buf_allocate_memory()'
> > based upon Dave's suggestions.  It's best not to depend upon that either.  What
> > do you say, Dave?
> 
> I reorder my local patch set and repost it after running it through
> some testing....

Sorry, I totally misunderstood the initial issue - I though Ben had my
series applied, and thus yours didn't apply.

I still think reordering is better - I'm quite busy and I'd rather get
your series reviewed first before redoing and retesting the inode
allocator changes.

In fact I'll start reviewing them in about 10 minutes after I've
finished catching up on email for this morning.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
