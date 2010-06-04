Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o541e597191479 for <xfs@oss.sgi.com>; Thu, 3 Jun 2010 20:40:05 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 35999396208
	for <xfs@oss.sgi.com>; Thu,  3 Jun 2010 18:42:32 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	LKc7aXvCelveaLFF for <xfs@oss.sgi.com>;
	Thu, 03 Jun 2010 18:42:32 -0700 (PDT)
Date: Fri, 4 Jun 2010 11:42:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: remove lazy per-AG initialization
Message-ID: <20100604014229.GD19651@dastard>
References: <20100528175108.GA9421@infradead.org>
	<20100530230915.GA13732@dastard> <1275602290.2468.110.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1275602290.2468.110.camel@doink>
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

On Thu, Jun 03, 2010 at 04:58:10PM -0500, Alex Elder wrote:
> On Mon, 2010-05-31 at 09:09 +1000, Dave Chinner wrote:
> > On Fri, May 28, 2010 at 01:51:08PM -0400, Christoph Hellwig wrote:
> > > Historically XFS initializes the allocator / inode allocator per-AG
> > > lazily, that is the first time this information is required.  For
> > > filesystems that use lazy superblock counters (which is the default now)
> > > we already have to walk all AGs to initialize the superblock counters
> > > on an unclean shutdown.
> > 
> > Which is not common, so isn't frequently triggered in the normal
> > mount process. The reason for the lazy initialisation is to speed
> > the mount process up when there are thousands of AGs. That is, we
> > avoid thousands of serialised IOs in the mount path. Have you
> > checked to see what the impact is on the clean mount execution time
> > is on such a filesystem?
> 
> It's interesting that the time penalty you're talking about
> doesn't go away, it just becomes less noticeable because it's
> aggregated over subsequent access to the AG's.

Right, the penalty is currently taken at access time, rather than at
mount time. One way to test the impact is to compare the runtime
difference for xfstests with MKFS_OPTIONS="-d agsize=16m" to bump up
the AG count and see how much additional IO and time it takes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
