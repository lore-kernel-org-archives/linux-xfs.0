Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6611XhD117588 for <xfs@oss.sgi.com>; Thu, 5 Jul 2012 20:01:33 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	estQeOvTDd2OEhx1 for <xfs@oss.sgi.com>;
	Thu, 05 Jul 2012 18:01:31 -0700 (PDT)
Date: Fri, 6 Jul 2012 11:01:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.5.0-rc5: inconsistent lock state
Message-ID: <20120706010126.GT19223@dastard>
References: <alpine.DEB.2.01.1207041206390.5568@trent.utfs.org>
	<20120705074307.GA28127@infradead.org>
	<alpine.DEB.2.01.1207050535420.5568@trent.utfs.org>
	<20120705215940.GP19223@dastard>
	<alpine.DEB.2.01.1207051615421.5568@trent.utfs.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1207051615421.5568@trent.utfs.org>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Jul 05, 2012 at 04:39:21PM -0700, Christian Kujau wrote:
> On Fri, 6 Jul 2012 at 07:59, Dave Chinner wrote:
> > It means that you have enough attributes that they don't fit in the
> > inode, so every time they are read or written you have to do an
> > extra IO on top of reading/writing the inode. Performance can easily
> > drop by an order of magnitude when the attributes are moved out of
> > the inode....
> 
> xfs_info shows isize=256 - but I'm not sure how I would have exceeded that 
> limit? I'm not using SELinux or anhy other security frameworks on that 
> machine, only plain unix permissions. Just check again, no ACLs, no EAs, 
> no file attributes are set on these filesystems.

Applications can use attributes without you being aware of them.
e.g. Samba, desktop search/indexing, etc might be using attributes
even though you aren't explicitly using them....

> The filesystems make heavy use of hardlinks, but files usually have no
> more than ~12 hardlinks, so that counter should not exceed the inode
> size either.

Hardlinks are not attributes, and the counter is in the inode core
so this won't have any impact on attributes being places out of
line.

> > Typically there is 50-70 bytes of attribute space available in 256
> > byte inodes, larger attributes or lots of them will push them out of
> > the inode....
> 
> 50 bytes sounds more than enought for holding only unix permissions.

Unix permissions are held in the inode core, not in the attribute
space.

And i did say "typically". if you have a file that has 6-7 extents,
then there won't be any space for attributes and it will put new
attributes out of line immediately....

> Does 
> it matter that the filesystem is somewhat larger? Not too large though, 
> all xfs filesystems are < 1TB in size.

No.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
