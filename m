Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p668FCJ0091864 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 03:15:12 -0500
Date: Wed, 6 Jul 2011 04:15:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/27] xfs: improve sync behaviour in the fact of
	aggressive dirtying
Message-ID: <20110706081511.GB5361@infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094603.789209280@bombadil.infradead.org>
	<1309905378.1950.50.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309905378.1950.50.camel@doink>
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

On Tue, Jul 05, 2011 at 05:36:18PM -0500, Alex Elder wrote:
> > A large part of the issue is that XFS writes data out itself two times
> > in the ->sync_fs method, overriding the lifelock protection in the core
> > writeback code, and another issue is the lock-less xfs_ioend_wait call,
> > which doesn't prevent new ioend from beeing queue up while waiting for
> > the count to reach zero.
> 
> The change affects only the first thing you mention here, not
> the second.

It does.  We're also removing the xfs_ioend_wait done from
xfs_sync_data/xfs_sync_inode_data.  We still have another one in
->write_inode, though.

> The i_iocount wait is not affected by your patch.

We're only removing one of the two we're doing per inode now.

> I'm OK with the change, but really prefer to have
> the description not include stuff that just isn't
> there.  If you want me to commit this as-is, just
> say so and I will.  Otherwise, post an update and
> I'll use that.  In any case, you can consider this
> reviewed by me.

If you have an idea how to reword the description send it my way.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
