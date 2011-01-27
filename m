Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0R0aU20174705 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 18:36:31 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0477C1A354C6
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 16:38:54 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bdIgaYwPlM3MERtz for <xfs@oss.sgi.com>;
	Wed, 26 Jan 2011 16:38:54 -0800 (PST)
Date: Thu, 27 Jan 2011 11:38:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/8] xfs: limit extent length for allocation to AG size
Message-ID: <20110127003851.GC21311@dastard>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
	<1295945444-29488-5-git-send-email-david@fromorbit.com>
	<1296076968.1980.941.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1296076968.1980.941.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 26, 2011 at 03:22:48PM -0600, Alex Elder wrote:
> On Tue, 2011-01-25 at 19:50 +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Delayed allocation extents can be larger than AGs, so when trying to
> > convert a large range we may scan every AG inside
> > xfs_bmap_alloc_nullfb() trying to find an AG with a size larger than
> > an AG. We should stop when we find the first AG with a maximum
> > possible allocation size. This causes excessive CPU usage when there
> > are lots of AGs.
> > 
> > The same problem occurs when doing preallocation of a range larger
> > than an AG.
> > 
> > Fix the problem by limiting real allocation lengths to the maximum
> > that an AG can support. This means if we have empty AGs, we'll stop
> > the search at the first of them. If there are no empty AGs, we'll
> > still scan them all, but that is a different problem....
> 
> Maybe I'm wrong but I think you need to change a "+"
> to a "-" (shown below).

Good catch. That's what I get for cleaning up code ;)

> 
> And I have a few really minor suggestions:
> - You should update a comment (which I point
>   out below) to match your change.

Will fix.

> - Maybe make use of a local variable, at least
>   in xfs_bmap_btalloc_nullfb(), such as:
>     xfs_extlen_t requested = args->maxlen;

All the allocation code is coded that way to avoid putting local
variables on the stack. The allocation-in-writeback path is the
critical stack usage path in XFS, so I'd prefer to keep using
args->maxlen here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
