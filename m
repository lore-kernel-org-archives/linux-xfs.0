Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0I0MRsn083033 for <xfs@oss.sgi.com>; Mon, 17 Jan 2011 18:22:27 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5D06101A0B2
	for <xfs@oss.sgi.com>; Mon, 17 Jan 2011 16:24:41 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	9MGZRqInXxkTLL4k for <xfs@oss.sgi.com>;
	Mon, 17 Jan 2011 16:24:41 -0800 (PST)
Date: Tue, 18 Jan 2011 11:24:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110118002437.GS28803@dastard>
References: <20110114002900.GF16267@dastard> <20110114164016.GB30134@sgi.com>
	<20110114225907.GH16267@dastard> <20110115041629.GC11968@sgi.com>
	<20110117051827.GL16267@dastard> <20110117143708.GE11968@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110117143708.GE11968@sgi.com>
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

On Mon, Jan 17, 2011 at 08:37:08AM -0600, Geoffrey Wehrman wrote:
> On Mon, Jan 17, 2011 at 04:18:28PM +1100, Dave Chinner wrote:
> | On Fri, Jan 14, 2011 at 10:16:29PM -0600, Geoffrey Wehrman wrote:
> | > On Sat, Jan 15, 2011 at 09:59:07AM +1100, Dave Chinner wrote:
> | > | On Fri, Jan 14, 2011 at 10:40:16AM -0600, Geoffrey Wehrman wrote:
> | > | > Also, I'm not saying using XFS_BMAPI_EXACT is feasible.  I have a very
> | > | > minimal understanding of the writepage code path.
> | > | 
> | > | I think there are situations where this does make sense, but given
> | > | the potential issues I'm not sure it is a solution that can be
> | > | extended to the general case. A good discussion point on a different
> | > | angle, though. ;)
> | > 
> | > You've convinced me that XFS_BMAPI_EXACT is not the optimal solution.
> | > 
> | > Upon further consideration, I do like your proposal to make delalloc
> | > allocation more like an intent/done type operation.  The compatibility
> | > issues aren't all that bad.  As long as the filesystem is unmounted
> | > clean, there is no need for the next mount do log recovery and therefore
> | > no need to have any knowledge of the new transactions.
> | 
> | That is a good observation. If there is agreement that this a strong
> | enough backwards compatibility guarantee (it's good enough for me),
> | then I think that I will start to prototype this approach.
> 
> I'm not sure how a version of XFS without the new log recovery code will
> behave if it encounters a log with the new transactions.  I assume it
> will gracefully abort log recovery and fail the mount with the report of
> a corrupt log.  I have no objection with this compatibility guarantee.

It will do the same as you describe for the old log recovery code,
so there should be no new problems there.

> | However, this does not solve the extsize allocation issues where we
> | don't have dirty pages in the page cache covering parts of the
> | delayed allocation extent so we still need a solution for that. I'm
> | tending towards zeroing in .aio_write as the simplest solution
> | because it doesn't cause buffer head/extent tree mapping mismatches,
> | and it would use the above intent/done operations for crash
> | resilience so there's no additional, rarely used code path to test
> | through .writepage. Does that sound reasonable?
> 
> Zeroing in .aio_write will create zeroed pages covering the entire
> allocation, correct?

Yes, though it only needs to zero the regions that the write does
not cover itself - no need to zero what we're about to put data
into. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
