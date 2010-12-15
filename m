Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBFMtLSE246673 for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 16:55:22 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 11AE31F5F76
	for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 14:57:13 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	wz319DeiaLh27TTF for <xfs@oss.sgi.com>;
	Wed, 15 Dec 2010 14:57:13 -0800 (PST)
Date: Thu, 16 Dec 2010 09:57:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: provide a inode iolock lockdep class
Message-ID: <20101215225710.GG9925@dastard>
References: <1292202431-15320-1-git-send-email-david@fromorbit.com>
	<20101215121811.GA3122@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101215121811.GA3122@infradead.org>
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

On Wed, Dec 15, 2010 at 07:18:11AM -0500, Christoph Hellwig wrote:
> On Mon, Dec 13, 2010 at 12:07:11PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The XFS iolock needs to be re-initialised to a new lock class before
> > it enters reclaim to prevent lockdep false positives. Unfortunately,
> > this is not sufficient protection as inodes in the XFS_IRECLAIMABLE
> > state can be recycled and not re-initialised before being reused.
> > 
> > We need to re-initialise the lock state when transfering out of
> > XFS_IRECLAIMABLE state to XFS_INEW, but we need to keep the same
> > class as if the inode was just allocated. Hence we need a specific
> > lockdep class variable for the iolock so that both initialisations
> > use the same class.
> > 
> > While there, add a specific class for inodes in the reclaim state so
> > that it is easy to tell from lockdep reports what state the inode
> > was in that generated the report.
> 
> Looks good to me.  As long as we have the mrlock abstraction we might as
> well hide this behind it, but as I plan on killing the abstraction
> that's probably not worth the effort.

I thought about doing that, too, after looking at what the abstraction
still provides us with. I think it only provides an extra "is write
locked" debug check which I think could be added to the generic
rwsem code pretty easily. But I've got a big enough patch stack out
for review right now. ;)

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks, I'll add it to the for-2.6.38 stack.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
