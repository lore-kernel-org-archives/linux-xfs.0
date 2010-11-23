Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oANKPwCN002737 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 14:25:58 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D812819F669
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 12:27:34 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	xejZBV3QGf8sfn12 for <xfs@oss.sgi.com>;
	Tue, 23 Nov 2010 12:27:34 -0800 (PST)
Date: Wed, 24 Nov 2010 07:27:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Improving XFS file system inode performance
Message-ID: <20101123202721.GT22876@dastard>
References: <4CEAE7D7.6050401@ssec.wisc.edu>
	<20101122232528.21b78a9e@galadriel.home>
	<4CEAEF66.7030708@ssec.wisc.edu> <20101122234419.GK13830@dastard>
	<4CEBD47F.1040004@ssec.wisc.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CEBD47F.1040004@ssec.wisc.edu>
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
To: Jesse Stroik <jstroik@ssec.wisc.edu>
Cc: Linux XFS <xfs@oss.sgi.com>

On Tue, Nov 23, 2010 at 08:49:35AM -0600, Jesse Stroik wrote:
> Dave,
> 
> Thanks.  This is precisely what I was looking for.  I'll let you
> know how it turns out.
> 
> As this file system is likely to continue to increase in number of
> files at a fairly rapid rate, we're going to need a long term
> strategy.  I suspect it may be necessary in the near future to
> double or quadruple the memory to 32GB or 64GB, but the uncertainty
> in the formula makes me nervous.
> 
> For a situation like this, it would be ideal if we could specify an
> inode cache size.

That's the third request in a few weeks I've had for being able to
fix the inode cache size to either prevent it from growing too large
or to prevent it from being reclaimed prematurely. I doubt I'll ever
be able to get the VFS cache capped (people have tried in the past
with no success), so I'm going to look at providing a method for XFS
to provide limits on the size of it's inode cache.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
