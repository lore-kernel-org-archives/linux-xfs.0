Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D97FE7F54
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 17:29:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A5E978F8039
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 15:29:01 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	K16Y7yW3PhCkF4XC for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 15:28:59 -0700 (PDT)
Date: Thu, 17 Apr 2014 08:28:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: Nuke XFS_ERROR macro
Message-ID: <20140416222827.GP15995@dastard>
References: <534EC073.8090006@sandeen.net> <534EC282.7010905@sandeen.net>
	<20140416175117.GA23643@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140416175117.GA23643@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Wed, Apr 16, 2014 at 10:51:17AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 16, 2014 at 12:48:50PM -0500, Eric Sandeen wrote:
> > XFS_ERROR was designed long ago to trap return values,
> > but it's not runtime configurable, it's not consistently used,
> > and we can do the same thing today with systemtap, using
> > something like:
> > 
> > probe module("xfs").function("xfs_*").return { if (@defined($return) && $return == VALUE) { ... } }
> 
> Gives me a version just using ftrace, or at least a kprobes based module
> that we can merged in the kernel tree and this would be fine for me.
> 
> Requiring a massive blob of questionable out of tree module code and a
> compiler is an absolute no-go.
> 
> NAK for now.

I think regardless of the systemtap/ftrace replacement, nobody uses
this at the moment, and it's not been used for a long time. It's a
compile time configurable, debug only error trap that is far
less useful than adding printk() or tracepoints at the appropriate
points.

If you've got to recompile the kernel to use it, then you may as
well add meaningful debug rather than hope an error trap that panics
the kernel tells you what you need.  i.e. the error trap code as it
stands is only useful for those running kernel debuggers, and very
few developers actually do that these days.

And, FWIW, it only allows detection of then initial error instance -
too bad if you want the second or third occurrence of the error.

IOWs, I can't see how this is at all useful anymore....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
