Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3T0J5Jr020997 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 19:19:06 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B040E1AF28CF
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 17:21:09 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	gcq8tVkFEtAEwSEB for <xfs@oss.sgi.com>;
	Wed, 28 Apr 2010 17:21:09 -0700 (PDT)
Date: Thu, 29 Apr 2010 10:21:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/11] remove xfs_iomap
Message-ID: <20100429002107.GK9783@dastard>
References: <20100428122850.075189557@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100428122850.075189557@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Apr 28, 2010 at 08:28:50AM -0400, Christoph Hellwig wrote:
> This series gets rid of the xfs_iomap structure which we use to
> communicate between xfs_aops.c and xfs_iomap.c.  It's not a very
> useful structure - we basically need block offsets above and below
> it, but it's in terms of bytes.  Removing it and using the xfs_bmbt_irec
> structure instead thus simplifies the code and reduces the stack footprint
> of the writeback code.

I like the idea - anything we can remove from the writeback path is
useful in terms of stack footprint. I've had a quick look over the
patches and can't see any obvious issues, but I need to do a more
in-depth review of them over the next couple of days. In the mean
time, I'll add them to my QA stack...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
