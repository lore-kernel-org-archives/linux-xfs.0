Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5KN2af9184118 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 18:02:36 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5z9QeggzeT53Xmup for <xfs@oss.sgi.com>;
	Wed, 20 Jun 2012 16:02:34 -0700 (PDT)
Date: Thu, 21 Jun 2012 09:02:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] types.h: implement intptr_t and uintptr_t
Message-ID: <20120620230232.GN30705@dastard>
References: <1338487534-14575-1-git-send-email-jengelh@inai.de>
	<20120620075216.GA24798@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120620075216.GA24798@infradead.org>
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
Cc: joe@perches.com, linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>, bpm@sgi.com, xfs@oss.sgi.com

On Wed, Jun 20, 2012 at 03:52:16AM -0400, Christoph Hellwig wrote:
> I'd really like to get Jans type cleanups in XFS in for the next
> merge window.  Given the lack of feedback on lkml in favor or
> against (u)intptr_t I'm tempted to add them to xfs_linux.h for now,
> and then do another push to propagate them to kernel-wide types later.
> 
> Is that fine with everybody?

I'd just push it into the XFS tree and into linux-next. It's a
relatively harmless set of changes, and if nobody cares enough about
it except us, just push it and see what happens when people start
noticing the conflicts it might cause....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
