Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p960Wg0Y152090 for <xfs@oss.sgi.com>; Wed, 5 Oct 2011 19:32:43 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F110C144A641
	for <xfs@oss.sgi.com>; Wed,  5 Oct 2011 17:39:24 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	3GOrWayBLnDjuiyp for <xfs@oss.sgi.com>;
	Wed, 05 Oct 2011 17:39:24 -0700 (PDT)
Date: Thu, 6 Oct 2011 11:32:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: SEEK_DATA/SEEK_HOLE support
Message-ID: <20111006003234.GR3159@dastard>
References: <4E887D7F.2010306@oracle.com> <201110050934.28021@zmi.at>
	<20111005093615.GQ3159@dastard> <201110052022.19953@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201110052022.19953@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Liu <jeff.liu@oracle.com>, xfs@oss.sgi.com

On Wed, Oct 05, 2011 at 08:22:18PM +0200, Michael Monnerie wrote:
> On Mittwoch, 5. Oktober 2011 Dave Chinner wrote:
> > It's a data corruption problem, pure and simple....
> 
> Thanks for the thorough explanation. So it's a problem when a file has 
> recently been modified and not yet been written back to disk. Would it 
> be worth to force a flush to disk before SEEK_* operations can start? I 
> don't know if it's easier to do all the lookups you suggested, or do an 
> fsync. That could have it's own impacts, though.

The problem is that application does not know whether fsync is
needed or not, so it would have to do that unconditionally for every
file it was copying. That has potential for quite severe, unexpected
performance regressions, so it's something we want to avoid.

There isn't really any additional complexity on the side of the
XFS SEEK_XXX code to handle this properly - my comments were
aimed at making sure that everyone understood the constraints of
taking parts of the XFS code and making it a generic helper because
other filesystems do not have the same locking heirachyi or
unwritten extent implementation as XFS does....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
