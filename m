Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0EGc49i052201 for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 10:38:04 -0600
Date: Fri, 14 Jan 2011 10:40:16 -0600
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110114164016.GB30134@sgi.com>
References: <20110114002900.GF16267@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110114002900.GF16267@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 14, 2011 at 11:29:00AM +1100, Dave Chinner wrote:
| This seems to be incorrect to me - a "wasdelay" extent has not yet
| been initialised - there's data in memory, but there is nothing on
| disk and we may not write it for some time. If we crash after this
| transaction is written but before any data is written, we expose
| stale data.
| 
| Not only that, it allocates the _entire_ delalloc extent that spans
| the preallocation range, even when the preallocation range is only 1
| block and the delalloc extent covers gigabytes. hence we actually
| expose a much greater range of the file to stale data exposure
| during a crash than just eh preallocated range. Not good.
| 
| Secondly, I think we have the same expose-the-entire-delalloc-extent
| -to-stale-data-exposure problem in ->writepage. This onnne, however,
| is due to using BMAPI_ENTIRE to allocate the entire delalloc extent
| the first time any part of it is written to. Even if we are only
| writing a single page (i.e. wbc->nr_to_write = 1) and the delalloc
| extent covers gigabytes. So, same problem when we crash.
| 
| Finally, I think the extsize based problem exposed by test 229 is a
| also a result of allocating space we have no pages covering in the
| page cache (triggered by BMAPI_ENTIRE allocation) so the allocated
| space is never zeroed and hence exposes stale data.

There used to be an XFS_BMAPI_EXACT flag that wasn't ever used.  What
would be the effects of re-creating this flag and using it in writepage
to prevent the expose-the-entire-delalloc-extent-to-stale-data-exposure
problem?  This wouldn't solve the exposure of stale data for a crash
that occurs after the extent conversion but before the data is written
out.  The quantity of data exposed is potentially much smaller however.

Also, I'm not saying using XFS_BMAPI_EXACT is feasable.  I have a very
minimal understanding of the writepage code path.


-- 
Geoffrey Wehrman  651-683-5496  gwehrman@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
