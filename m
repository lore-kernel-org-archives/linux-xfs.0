Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p66Exr7H128508 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 09:59:53 -0500
Subject: Re: [PATCH 08/27] xfs: improve sync behaviour in the fact of
	aggressive dirtying
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110706081511.GB5361@infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094603.789209280@bombadil.infradead.org>
	<1309905378.1950.50.camel@doink> <20110706081511.GB5361@infradead.org>
Date: Wed, 6 Jul 2011 09:59:49 -0500
Message-ID: <1309964389.1931.36.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-07-06 at 04:15 -0400, Christoph Hellwig wrote:
> On Tue, Jul 05, 2011 at 05:36:18PM -0500, Alex Elder wrote:
> > > A large part of the issue is that XFS writes data out itself two times
> > > in the ->sync_fs method, overriding the lifelock protection in the core
> > > writeback code, and another issue is the lock-less xfs_ioend_wait call,
> > > which doesn't prevent new ioend from beeing queue up while waiting for
> > > the count to reach zero.
> > 
> > The change affects only the first thing you mention here, not
> > the second.
> 
> It does.  We're also removing the xfs_ioend_wait done from
> xfs_sync_data/xfs_sync_inode_data.  We still have another one in
> ->write_inode, though.

OK, now I see what you're talking about.  I guess the way it was
stated I expected that the code would now *prevent* new ioends
from being queued while waiting.

> 
> > The i_iocount wait is not affected by your patch.
> 
> We're only removing one of the two we're doing per inode now.
> 
> > I'm OK with the change, but really prefer to have
> > the description not include stuff that just isn't
> > there.  If you want me to commit this as-is, just
> > say so and I will.  Otherwise, post an update and
> > I'll use that.  In any case, you can consider this
> > reviewed by me.
> 
> If you have an idea how to reword the description send it my way.

Here's an attempt.  (It also gives you a chance to correct
my understanding...)

A large part of the issue is that XFS writes data out itself
two times in the ->sync_fs method, overriding the livelock
protection in the core writeback code.  This patch removes
these XFS-internal sync calls and relies on the VFS to do it's
work just like all other filesystems do.

Another issue is the lock-less xfs_ioend_wait() call,
which doesn't prevent new ioends from being queued up
while waiting for the count to reach zero.  Removing
the second SYNC_WAIT call to xfs_sync_data() eliminates
one place this is used unnecessarily by avoiding the
wait request at the end of xfs_sync_inode_data().  In
most cases there is no need to wait for ongoing writes
to make it to disk, as long as those queued at the time
of a sync request get flushed out.

We still wait like this in ->write_inode, and we should
remove that as well, but that's material for a separate
commit.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
