Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q289StCB004922 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 03:28:56 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	eVaKIrj7bObbgnVR for <xfs@oss.sgi.com>;
	Thu, 08 Mar 2012 01:28:53 -0800 (PST)
Date: Thu, 8 Mar 2012 20:28:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: df bigger than ls?
Message-ID: <20120308092850.GQ3592@dastard>
References: <20120307155439.GA23360@nsrc.org> <20120307171619.GA23557@nsrc.org>
	<4F57A32A.5010704@sandeen.net> <20120308021054.GM3592@dastard>
	<4F5816D6.80801@sandeen.net> <20120308091033.GC23992@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120308091033.GC23992@nsrc.org>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Mar 08, 2012 at 09:10:33AM +0000, Brian Candler wrote:
> On Wed, Mar 07, 2012 at 08:17:58PM -0600, Eric Sandeen wrote:
> > It seems worth thinking about.  I guess I'm still a little concerned
> > about the ENOSPC case; it could lead to some confusion - I could imagine
> > several hundreds of gigs under preallocation, with a reasonable-sized
> > filesystem returning ENOSPC quite early.
> 
> And presumably df on the filesystem would also show it approaching 100%
> utilisation?

*nod*

> I'm used to this where a large file has been unlinked but is still open. 
> The preallocation case is a new one to me though.
> 
> How about if the total of all preallocations were limited to some small
> percentage of the total filesystem size?  If you reach this limit and want
> to preallocate some space for another file you'd have to either drop or
> shrink an older preallocation.

There is no separate accounting for preallocation - it is considered
used space so this currently can't be done even if there was some
method for tracking and trimming speculatively preallocated space.

Realistically, if you aren't running out of space there is no reason
to limit speculative preallocation. Indeed, if we didn't add
delalloc blocks to the block count in stat(2) output so they showed
up in df, almost no-one would even know about the fact that this is
done....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
