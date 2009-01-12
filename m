Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0CNKfpo030171 for <xfs@oss.sgi.com>; Mon, 12 Jan 2009 17:20:45 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C26B17DE4CA
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2009 15:09:37 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	xWRA3ZCihQbYgpoD for <xfs@oss.sgi.com>;
	Mon, 12 Jan 2009 15:09:37 -0800 (PST)
Date: Tue, 13 Jan 2009 10:09:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/7] xfs: lockdep annotations for xfs_dqlock2
Message-ID: <20090112230933.GM8071@disturbed>
References: <20090109221104.237540000@bombadil.infradead.org>
	<20090109221300.520949000@bombadil.infradead.org>
	<20090111230637.GE8071@disturbed>
	<20090112151544.GA25507@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090112151544.GA25507@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

On Mon, Jan 12, 2009 at 10:15:44AM -0500, Christoph Hellwig wrote:
> On Mon, Jan 12, 2009 at 10:06:37AM +1100, Dave Chinner wrote:
> > This looks a bit wierd.
> > 
> > Yes, xfs_dqlock() is just a wrapper around mutex_lock, but we should
> > be consistent here. Can you add a xfs_dqlock_nested() wrapper to do
> > this?
> 
> I don't think we should add more of the silly wrappers.  What about
> the version below that always uses plain mutex_lock* in xfs_dqlock2?

Fair enough.

> ---
> 
> Subject: xfs: lockdep annotations for xfs_dqlock2
> From: Christoph Hellwig <hch@lst.de>
> 
> xfs_dqlock2 locks two xfs_dquots, which is fine as it always locks the
> dquot with the lower id first.  Use mutex_lock_nested to tell lockdep 
> about this fact.  Also clean up xfs_dqlock2 a bit by rationalizing
> the conditionals and always using the mutex_lock family of functions
> directly.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
