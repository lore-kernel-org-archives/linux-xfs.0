Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D67567CA0
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 16:59:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9704E304051
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 14:59:02 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	83wyptkHoLaI6gXM for <xfs@oss.sgi.com>;
	Thu, 24 Mar 2016 14:59:00 -0700 (PDT)
Date: Fri, 25 Mar 2016 08:58:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Failing XFS memory allocation
Message-ID: <20160324215858.GE11812@dastard>
References: <56F26CCE.6010502@kyup.com>
	<20160323124312.GB43073@bfoster.bfoster> <56F29279.70600@kyup.com>
	<20160323131059.GC43073@bfoster.bfoster>
	<20160323230002.GY30721@dastard> <56F3B157.2060505@kyup.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56F3B157.2060505@kyup.com>
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
To: Nikolay Borisov <kernel@kyup.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Thu, Mar 24, 2016 at 11:20:23AM +0200, Nikolay Borisov wrote:
> On 03/24/2016 01:00 AM, Dave Chinner wrote:
> > As it is, yes, the memory allocation problem is with the in-core
> > extent tree, and we've known about it for some time. The issue is
> > that as memory gets fragmented, the top level indirection array
> > grows too large to be allocated as a contiguous chunk. When this
> > happens really depends on memory load, uptime and the way the extent
> > tree is being modified.
> 
> And what about the following completely crazy idea of switching order >
> 3 allocations to using vmalloc? I know this would incur heavy
> performance hit, but other than that would it cause correctness issues?
> Of course I'm not saying this should be implemented in upstream rather
> whether it's worth it having a go for experimenting with this idea.

It's not an option as many supported platforms which have extremely
limited vmalloc space.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
