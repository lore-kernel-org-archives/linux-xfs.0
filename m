Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q65NdOZn110106 for <xfs@oss.sgi.com>; Thu, 5 Jul 2012 18:39:24 -0500
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id ICztQ5ZZhLXMmy7Q for <xfs@oss.sgi.com>;
	Thu, 05 Jul 2012 16:39:23 -0700 (PDT)
Date: Thu, 5 Jul 2012 16:39:21 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 3.5.0-rc5: inconsistent lock state
In-Reply-To: <20120705215940.GP19223@dastard>
Message-ID: <alpine.DEB.2.01.1207051615421.5568@trent.utfs.org>
References: <alpine.DEB.2.01.1207041206390.5568@trent.utfs.org>
	<20120705074307.GA28127@infradead.org>
	<alpine.DEB.2.01.1207050535420.5568@trent.utfs.org>
	<20120705215940.GP19223@dastard>
MIME-Version: 1.0
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, 6 Jul 2012 at 07:59, Dave Chinner wrote:
> It means that you have enough attributes that they don't fit in the
> inode, so every time they are read or written you have to do an
> extra IO on top of reading/writing the inode. Performance can easily
> drop by an order of magnitude when the attributes are moved out of
> the inode....

xfs_info shows isize=256 - but I'm not sure how I would have exceeded that 
limit? I'm not using SELinux or anhy other security frameworks on that 
machine, only plain unix permissions. Just check again, no ACLs, no EAs, 
no file attributes are set on these filesystems.

The filesystems make heavy use of hardlinks, but files usually have no
more than ~12 hardlinks, so that counter should not exceed the inode
size either.

> Typically there is 50-70 bytes of attribute space available in 256
> byte inodes, larger attributes or lots of them will push them out of
> the inode....

50 bytes sounds more than enought for holding only unix permissions. Does 
it matter that the filesystem is somewhat larger? Not too large though, 
all xfs filesystems are < 1TB in size.

Thanks,
Christian.
-- 
BOFH excuse #211:

Lightning strikes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
