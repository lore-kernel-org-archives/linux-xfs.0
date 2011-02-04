Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1405vEC235638
	for <linux-xfs@oss.sgi.com>; Thu, 3 Feb 2011 18:05:58 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4FF71121EB95
	for <linux-xfs@oss.sgi.com>; Thu,  3 Feb 2011 16:08:26 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	RjeP4AwY1iWt5wFD for <linux-xfs@oss.sgi.com>;
	Thu, 03 Feb 2011 16:08:26 -0800 (PST)
Date: Fri, 4 Feb 2011 11:08:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdump SGI_FS_BULKSTAT errno = 22, how could this IRIX bug
	get into	Ubuntu 10.04 Lucid between kernels 2.6.32-27 and 2.6.32-26?
Message-ID: <20110204000823.GW11040@dastard>
References: <iibmah$dlp$1@dough.gmane.org> <4D49A35B.6030009@sgi.com>
	<20110203045836.GV11040@dastard>
	<4D4ABEF7.7000400@lueckdatasystems.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D4ABEF7.7000400@lueckdatasystems.com>
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
To: Michael Lueck <mlueck@lueckdatasystems.com>
Cc: linux-xfs@oss.sgi.com, Dann Frazier <dannf@debian.org>

On Thu, Feb 03, 2011 at 09:43:03AM -0500, Michael Lueck wrote:
> Dave Chinner wrote:
> >So bulkstat got EINVAL returned for and inode that it was looking
> >up. That implies that it was racing with an unlink, which is
> >what the above commits catch and prevent. Can you run xfsdump with
> >full debug output (-v 5) so we can see what inode is being operated
> >on when this failure occurs?
> 
> Thank you so much Dave!
> 
> Please find the trace output here in zipped format:
> 
> http://www.lueckdatasystems.com/pub/ldsbackup.trace.log.zip

Ok, so xfsdump i seeing a short bulkstat, then an EINVAL returned
from the next bulkstat. That's not a race condition, and makes me
think you have some kind of on-disk corruption. The inode it is
starting at when it returns EINVAL is 80508397. Can you firstly
post the output of:

# xfs_db -c "inode 80508397" -c p <dev>

And can you also run 'xfs_repair -n <dev>' on the filesystem and
post the output as well so we can see what state the filesytem is
in?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
