Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D8727F37
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 19:16:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5F1A48F8039
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 17:16:19 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	OnF8JPnTcEM0A1E5 for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 17:16:17 -0700 (PDT)
Date: Fri, 17 May 2013 10:16:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: wishlist: xfs_repair should detect files with too small sizes
Message-ID: <20130517001604.GJ24635@dastard>
References: <20130514215550.GK17260@hellgate> <20130515004736.GM29466@dastard>
	<20130515080355.GL17260@hellgate> <20130515214105.GZ24635@dastard>
	<20130516035651.GH17261@hellgate>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130516035651.GH17261@hellgate>
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
To: Andras Korn <korn-xfs@elan.rulez.org>
Cc: xfs@oss.sgi.com

On Thu, May 16, 2013 at 05:56:51AM +0200, Andras Korn wrote:
> On Thu, May 16, 2013 at 07:41:05AM +1000, Dave Chinner wrote:
> 
> > > OK, thinking about it I realise there doesn't appear to be a good way of
> > > preventing the problem, but I'm still not sure some heuristic couldn't be
> > > invented to detect and partially remedy it after the fact.
> > 
> > Trying to remedy it in xfs_repair does more harm than good. What
> > happens now allows recovery of data if the inode size was wrong. If
> > we remove the blocks beyond EOF, we lose that ability and hence make
> > unrecoverable data loss more likely in common failure scenarios.
> 
> That's clear (xfs_repair not freeing up the space is what allowed me to
> recover the data). I meant "remedy" as in _either_ increase the inode size
> OR free up the extra space. Perhaps xfs_db could be extended to do this?

You can already change the inode size with xfs_db by writing the
field directly.

> Of course, increasing the size as stored in the inode can add garbage (at
> the very least, binary zeroes) to the end of files, but if the data would
> otherwise have been lost, this is probably still preferable.

No, it's not preferable, because if data wasn't written after the
extents are allocated, extending the file size exposes stale data
that is already on disk that the owner of the file should not have
access to.

You are free to do this yourself, but we are not going to add
potential stale data exposure holes into repair/db if this situation
arises.

> I can even
> imagine an xfs_db command that increases file size up to the last non-zero
> data byte in the allocated space.

Stale data regions rarely contain zero.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
