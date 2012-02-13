Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DNfWsX051654 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 17:41:33 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bnhT67t76G6lQMsz for <xfs@oss.sgi.com>;
	Mon, 13 Feb 2012 15:41:31 -0800 (PST)
Date: Tue, 14 Feb 2012 10:41:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Disk spin down
Message-ID: <20120213234129.GD14132@dastard>
References: <4F3803B1.1090205@ashurst.eu.org> <20120213083651.GA40007@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120213083651.GA40007@nsrc.org>
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
To: Brian Candler <B.Candler@pobox.com>
Cc: Andy Bennett <andyjpb@ashurst.eu.org>, xfs@oss.sgi.com

On Mon, Feb 13, 2012 at 08:36:51AM +0000, Brian Candler wrote:
> On Sun, Feb 12, 2012 at 06:23:45PM +0000, Andy Bennett wrote:
> > Can someone help me work out where writes are coming from on my system?
> 
> Is the filesystem in question mounted with 'relatime' or 'noatime'?
> Otherwise, merely reading a file will cause its inode to be dirtied.
> 
> (However in modern kernels, 'relatime' might be the default, I'm not sure)

relatime has been the default for quite some time, and even before
relatime was implemented in the VFS, xfs implementated atime updates
in a manner almost indistinguishable from relatime since about 2007....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
