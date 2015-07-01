Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 313837FBF
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 18:50:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BE2C1AC004
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 16:49:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	eXn5tl90B38gcF2g for <xfs@oss.sgi.com>;
	Wed, 01 Jul 2015 16:49:57 -0700 (PDT)
Date: Thu, 2 Jul 2015 09:49:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/14] xfs: minimize impact to non-reflink files via
	reflink per-inode flag
Message-ID: <20150701234944.GW22807@dastard>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
	<20150625234016.4992.52406.stgit@birch.djwong.org>
	<20150701015843.GS22807@dastard>
	<20150701225944.GB10043@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150701225944.GB10043@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 01, 2015 at 03:59:44PM -0700, Darrick J. Wong wrote:
> On Wed, Jul 01, 2015 at 11:58:43AM +1000, Dave Chinner wrote:
> > I would have thought you only need to check the inode flag here
> > because the only time it will be set is on a reflink enabled
> > filesystem. i.e. that flag being set implies we've already done
> > all the "reflink is supported in this filesystem and it's not a
> > realtime file" checks when setting the flag.
> 
> Sure.  The reason for so many ASSERTs everywhere is to help me check my
> own sanity while cobbling together the first version.  I imagine I could
> eliminate a lot of them, but since they all compile out on !XFS_DEBUG &&
> !XFS_WARN, I didn't think it was a serious problem. :)

Generally it's not, but we try to keep performance of the debug
kernel within a few percent of a non-debug build, just so that it
behaves roughly the same w.r.t. CPU and memory overhead, scalability
and race conditions.

Hence I'd much prefer to see strong validation of the parameters at
the highest layer possible so that they don't need to be constantly
checked in lower layers that have a single context.  e.g.
AG-specific modification functions shouldn't need to check the agno
is valid, as they wouldn't have been called if someone tried to
perform the operation on an invalid agno.  Same goes for block
numbers, etc.

And for printk debugging to tell you whow functions a being called
and what oeprations they are doing, you should replace all that with
tracepoints.  Addition of trace points at the entry and exit of
functions gives sufficient information for verifying this during
debugging, but has almost no overhead in the code or at runtime.
They can also be switched on dynamically in production machines,
which you can't do with compile option debug code like xfs_debug and
ASSERT statements. i.e. tracepoints = good, debug printk = bad ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
