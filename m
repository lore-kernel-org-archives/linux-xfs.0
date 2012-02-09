Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q19M3wn7199147
	for <linux-xfs@oss.sgi.com>; Thu, 9 Feb 2012 16:03:59 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5hQk5nG20A0ZwGgw for <linux-xfs@oss.sgi.com>;
	Thu, 09 Feb 2012 14:03:55 -0800 (PST)
Date: Fri, 10 Feb 2012 09:03:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question: Does XFS journal data or only metadata?
Message-ID: <20120209220353.GG7479@dastard>
References: <200502031005.57621.as@cohaesio.com>
	<200502031716.59894.as@cohaesio.com>
	<200502031724.56665.as@cohaesio.com>
	<200502031740.01081.as@cohaesio.com> <4202594B.3030204@xfs.org>
	<loom.20120209T122422-618@post.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <loom.20120209T122422-618@post.gmane.org>
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
To: Michal Szymanski <msz@astrouw.edu.pl>
Cc: linux-xfs@oss.sgi.com

On Thu, Feb 09, 2012 at 11:45:38AM +0000, Michal Szymanski wrote:
> I went through internal->external log procedure as described here and
> linked-to articles a few years  ago and it worked fine. These days I got
> into similar problem after reconfiguring a disk which holds the 
> external log for a XFS partition. The question to the gurus is
> following:
> 
> Is it possible to migrate an external log to internal if the XFS
> filesystem was originally created without  an internal log, i.e. it was
> put on external device straight at mkfs.xfs invocation? 

Not easily. The log region needs to be contiguous, and removed from
the free space btrees, which means it is a tricky operation to do.
It's possible that all you need to do is find enough contiguous free
space somewhere and point the superblock at that (with xfs_db), then
run repair to fix up the free space trees. I would not try this on a
filesystem that holds data you care about, though, until you know
whether it works...

> xfs_growfs still says, after 7 years, at least in the man page, that
> -l/-i/-x options are not implemented.  Is it really so?

Very few people ever ask about doing this or need it and it's quite
complex to implement and test, so it's never been done. It will
probably stay unimplemented until someone who really needs it helps
implement it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
