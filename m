Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1H33v7R194705 for <xfs@oss.sgi.com>; Mon, 16 Feb 2009 21:03:58 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3C1A19493B2
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2009 19:03:22 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	EQDJGtlez6Dd9aBa for <xfs@oss.sgi.com>;
	Mon, 16 Feb 2009 19:03:22 -0800 (PST)
Date: Tue, 17 Feb 2009 14:03:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Don't reset di_format in xfs_ifree()
Message-ID: <20090217030306.GC8830@disturbed>
References: <49921B3E.8040406@sgi.com> <20090211092020.GR8830@disturbed>
	<49937458.2000500@sgi.com> <20090212223253.GV8830@disturbed>
	<20090215192507.GA15360@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090215192507.GA15360@infradead.org>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Feb 15, 2009 at 02:25:08PM -0500, Christoph Hellwig wrote:
> On Fri, Feb 13, 2009 at 09:32:53AM +1100, Dave Chinner wrote:
> > > Yes, I agree.  I just don't have the time to hunt it down.  I see
> > > there's a call to xfs_idestroy_fork() in xfs_ireclaim() for directories
> > > but xfs_ireclaim() gets called after xfs_iflush() in xfs_reclaim_inode().
> > 
> > I suspect it should be in xfs_inactive() if we are in local format.
> > This is what happens with the attribute fork.  I think that is where
> > we need something like:
> > 
> > 	if ((ip->i_d.di_mode & S_IFMT) == S_IFDIR &&
> > 	    ip->i_d.di_nextents == 0)
> > 		xfs_idestroy_fork(ip, XFS_DATA_FORK);
> 
> Why would we special case directories?

I guess we don't need to - I was thinking purely of local format
inodes....

> Btw, I can't reproduce this issue with the extent.c program and the
> invocation from the next patch.  Does it need other parameters to
> reproduce?

No idea, I haven't been able to reproduce it either.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
