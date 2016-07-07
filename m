Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6D0BF7CDC
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 17:28:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D99A8AC055
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 15:28:34 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jJZXZoKvSCWmEjyh for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2016 15:28:31 -0700 (PDT)
Date: Fri, 8 Jul 2016 08:28:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [QUESTION] about the freelist allocator in XFS
Message-ID: <20160707222829.GG12670@dastard>
References: <CAGeO4WMZtYjaW=L7Hj8CgTd-sO38-xAUMhkZ-x-Z394YjOO7Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGeO4WMZtYjaW=L7Hj8CgTd-sO38-xAUMhkZ-x-Z394YjOO7Xg@mail.gmail.com>
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
To: Kaho Ng <ngkaho1234@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 07, 2016 at 07:01:35PM +0800, Kaho Ng wrote:
> I am trying to investigate how freelist allocator in xfs interacts
> with freespace B+Tree allocator.
> First I prepared a patch
> <https://gist.github.com/22ffca35929e67c08759b057779b7566> on
> linux-source/fs/xfs/libxfs/xfs_alloc.c to print debugging messages
> (The kernel version used is linux-3.10.0-327.22.2.el7).
......
> When reading the log output
> <https://gist.github.com/890076405e1c13c0a952a579e25e6afe> , I
> realised that there is no B+Tree split
> triggered by xfs_alloc_fix_freelist() when calling xfs_free_extent().
> Isn't B+Tree split possible in by-size B+Tree even when truncating a
> longer freespace record to shorter one? But what I found in the log is
> only a few tree shrinks... And when reading the source code of
> freespace allocator I found that a B+Tree growth in this case is
> impossible at least...

args->isfl doesn't mean what you think it means.

args->isfl is only set when moving blocks from the freespace btree
to the AGFL, which only occurs when a previous operation allocated a
new freespace btree block and depleted the current freelist. i.e.
"AG Free List" != "AG freespace btree" - they are different
structures on disk...

And when you consider that a freelist refill can only remove records
from the the freespace btree, it's should be clear that a btree
split won't occur during a freelist refill...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
