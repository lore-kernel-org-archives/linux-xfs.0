Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E64CB7F55
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 16:55:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C946A8F8040
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 14:55:04 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	RqOizFvzkFjaSugk for <xfs@oss.sgi.com>;
	Fri, 06 Sep 2013 14:55:03 -0700 (PDT)
Date: Sat, 7 Sep 2013 07:55:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: move buf_ops externs to a xfs_format.h
Message-ID: <20130906215459.GG12541@dastard>
References: <1378382015-16026-1-git-send-email-david@fromorbit.com>
	<1378382015-16026-2-git-send-email-david@fromorbit.com>
	<20130905190407.GA603@infradead.org>
	<20130905235412.GN12779@dastard>
	<20130906162701.GA9994@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130906162701.GA9994@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Sep 06, 2013 at 09:27:01AM -0700, Christoph Hellwig wrote:
> On Fri, Sep 06, 2013 at 09:54:12AM +1000, Dave Chinner wrote:
> > Fair enough - I thought about that, but then realised we don't
> > really have any "global" shared header files that fit this purpose.
> > The only two really are xfs_fs.h - which is used for ioctl interface
> > definitions - and xfs_types.h which is used for type definitions,
> > not structure instances...
> > 
> > So I'm not really sure where we'd put something like this without
> > creating a new header file, and I don't really want to do that,
> > either.
> 
> We might need a new one, the headers still need major work anyway.
> 
> If we start with
> 
> 	xfs*_format.h - purely disk format
> 	xfs_fs.h - ioctl and userspace ABI constants
> 
> an
> 
> 	xfs_shared.h
> 
> and
> 	xfs_kernel.h

OK. I'm not a great fan of the "xfs_shared.h" name, I'll see if I
can come up with something better....

> seem like logical additions to move most of the misc headers to instead
> of all the silly ones for just a handful or two worth of prototypes.
> 
> Note that a few non-format bits already sneaked into xfs_format.h
> unfortunately, guess I need to watch more closely :)

They did, for the same reason as I put these ones there. I'll move
them to the "xfs_shared.h" once I create it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
