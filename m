Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q65Lxjps102232 for <xfs@oss.sgi.com>; Thu, 5 Jul 2012 16:59:45 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1xn5roWyhw2sX8Oi for <xfs@oss.sgi.com>;
	Thu, 05 Jul 2012 14:59:43 -0700 (PDT)
Date: Fri, 6 Jul 2012 07:59:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.5.0-rc5: inconsistent lock state
Message-ID: <20120705215940.GP19223@dastard>
References: <alpine.DEB.2.01.1207041206390.5568@trent.utfs.org>
	<20120705074307.GA28127@infradead.org>
	<alpine.DEB.2.01.1207050535420.5568@trent.utfs.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1207050535420.5568@trent.utfs.org>
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

On Thu, Jul 05, 2012 at 05:44:50AM -0700, Christian Kujau wrote:
> On Thu, 5 Jul 2012 at 03:43, Christoph Hellwig wrote:
> > See my "do not take the iolock in inode reclaim context" series from
> > yesterday, which should take care of this.
> 
> OK, good. I'll wait until this hits mainline then.
> 
> > Btw, if you hit this it's a sign you have out of the inode attributes,
> > so if this isn't just a single inode with them you might be better off
> > using larger inodes.
> 
> ..."(run) out of inode attributes" - not really sure what that means and 
> why that would be the case.

It means that you have enough attributes that they don't fit in the
inode, so every time they are read or written you have to do an
extra IO on top of reading/writing the inode. Performance can easily
drop by an order of magnitude when the attributes are moved out of
the inode....

Typically there is 50-70 bytes of attribute space available in 256
byte inodes, larger attributes or lots of them will push them out of
the inode....

> And "using larger inodes" sounds like a 
> reformat with a larger "-i size=" option.

Yes, inode size is defined at mkfs time.

> Is there a way to find out my 
> current inode size? "mkfs.xfs -N" does not print its default values on a 
> mounted filesystem and I'm pretty sure I've used the default values when I 
> created the filesystem a while ago (i.e. just plain "mkfs.xfs" w/o any 
> options)

xfs_info <mntpt>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
