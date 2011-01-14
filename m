Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0EMuvAD105401 for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 16:56:58 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ABAB2267ED7
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 14:59:11 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	skzvp1tEa8d1dOwS for <xfs@oss.sgi.com>;
	Fri, 14 Jan 2011 14:59:11 -0800 (PST)
Date: Sat, 15 Jan 2011 09:59:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110114225907.GH16267@dastard>
References: <20110114002900.GF16267@dastard> <20110114164016.GB30134@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110114164016.GB30134@sgi.com>
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
To: Geoffrey Wehrman <gwehrman@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 14, 2011 at 10:40:16AM -0600, Geoffrey Wehrman wrote:
> On Fri, Jan 14, 2011 at 11:29:00AM +1100, Dave Chinner wrote:
> | This seems to be incorrect to me - a "wasdelay" extent has not yet
> | been initialised - there's data in memory, but there is nothing on
> | disk and we may not write it for some time. If we crash after this
> | transaction is written but before any data is written, we expose
> | stale data.
> | 
> | Not only that, it allocates the _entire_ delalloc extent that spans
> | the preallocation range, even when the preallocation range is only 1
> | block and the delalloc extent covers gigabytes. hence we actually
> | expose a much greater range of the file to stale data exposure
> | during a crash than just eh preallocated range. Not good.
> | 
> | Secondly, I think we have the same expose-the-entire-delalloc-extent
> | -to-stale-data-exposure problem in ->writepage. This onnne, however,
> | is due to using BMAPI_ENTIRE to allocate the entire delalloc extent
> | the first time any part of it is written to. Even if we are only
> | writing a single page (i.e. wbc->nr_to_write = 1) and the delalloc
> | extent covers gigabytes. So, same problem when we crash.
> | 
> | Finally, I think the extsize based problem exposed by test 229 is a
> | also a result of allocating space we have no pages covering in the
> | page cache (triggered by BMAPI_ENTIRE allocation) so the allocated
> | space is never zeroed and hence exposes stale data.
> 
> There used to be an XFS_BMAPI_EXACT flag that wasn't ever used.  What
> would be the effects of re-creating this flag and using it in writepage
> to prevent the expose-the-entire-delalloc-extent-to-stale-data-exposure
> problem?  This wouldn't solve the exposure of stale data for a crash
> that occurs after the extent conversion but before the data is written
> out.  The quantity of data exposed is potentially much smaller however.

Definitely a possibility, Geoffrey, and not one that I thought of.
I agree that it would significantly minimise the amount of stale data
exposed on a crash, but there does seem to be some down sides. Ben
has already pointed out the increased cost of allocations, and I can
also think of a couple of others:

	- I'm not sure it's the right solution to the extsize issue
	  because it will prevent extent size and aligned
	  allocations from ocurring, which is exactly what extsize
	  is supposed to provide.

	  I'm also not sure it would work with the realtime device
	  as all allocation has to be at least rtextent_size sized
	  and aligned rather than page boundary. I need to check how
	  the rt allocation code handles sub-rtextent size writes -
	  that may point to the solution for the general case here.

	- I think that using XFS_BMAPI_EXACT semantic will possibly
	  make the speculative EOF preallocation worthless. Delayed
	  allocation conversion will never convert the speculative
	  delalloc preallocation into real extents (beyond EOF) and
	  we'll see increased fragementation in many common
	  workloads due to that....

> Also, I'm not saying using XFS_BMAPI_EXACT is feasable.  I have a very
> minimal understanding of the writepage code path.

I think there are situations where this does make sense, but given
the potential issues I'm not sure it is a solution that can be
extended to the general case. A good discussion point on a different
angle, though. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
