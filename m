Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0IERj1p135600 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 08:27:45 -0600
Date: Tue, 18 Jan 2011 08:30:00 -0600
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110118143000.GB8803@sgi.com>
References: <20110114002900.GF16267@dastard> <20110114164016.GB30134@sgi.com>
	<20110114225907.GH16267@dastard> <20110115041629.GC11968@sgi.com>
	<20110117051827.GL16267@dastard> <20110117143708.GE11968@sgi.com>
	<20110118002437.GS28803@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110118002437.GS28803@dastard>
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

On Tue, Jan 18, 2011 at 11:24:37AM +1100, Dave Chinner wrote:
| On Mon, Jan 17, 2011 at 08:37:08AM -0600, Geoffrey Wehrman wrote:
| > On Mon, Jan 17, 2011 at 04:18:28PM +1100, Dave Chinner wrote:
| > | However, this does not solve the extsize allocation issues where we
| > | don't have dirty pages in the page cache covering parts of the
| > | delayed allocation extent so we still need a solution for that. I'm
| > | tending towards zeroing in .aio_write as the simplest solution
| > | because it doesn't cause buffer head/extent tree mapping mismatches,
| > | and it would use the above intent/done operations for crash
| > | resilience so there's no additional, rarely used code path to test
| > | through .writepage. Does that sound reasonable?
| > 
| > Zeroing in .aio_write will create zeroed pages covering the entire
| > allocation, correct?
| 
| Yes, though it only needs to zero the regions that the write does
| not cover itself - no need to zero what we're about to put data
| into. ;)

Glad you were able to understand what I meant.  Something I didn't think
of earlier though:  What happens when I try to use an 8 GB on a system
with only 4 GB of memory?  I'm not really worried about this pathological
case, but I do wonder what the effects will be of allocating what could
be significant quantities of memory in .aio_write.


-- 
Geoffrey Wehrman  651-683-5496  gwehrman@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
