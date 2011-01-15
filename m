Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0F4EHBI155098 for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 22:14:17 -0600
Date: Fri, 14 Jan 2011 22:16:29 -0600
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110115041629.GC11968@sgi.com>
References: <20110114002900.GF16267@dastard> <20110114164016.GB30134@sgi.com>
	<20110114225907.GH16267@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110114225907.GH16267@dastard>
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

On Sat, Jan 15, 2011 at 09:59:07AM +1100, Dave Chinner wrote:
| On Fri, Jan 14, 2011 at 10:40:16AM -0600, Geoffrey Wehrman wrote:
| > Also, I'm not saying using XFS_BMAPI_EXACT is feasible.  I have a very
| > minimal understanding of the writepage code path.
| 
| I think there are situations where this does make sense, but given
| the potential issues I'm not sure it is a solution that can be
| extended to the general case. A good discussion point on a different
| angle, though. ;)

You've convinced me that XFS_BMAPI_EXACT is not the optimal solution.

Upon further consideration, I do like your proposal to make delalloc
allocation more like an intent/done type operation.  The compatibility
issues aren't all that bad.  As long as the filesystem is unmounted
clean, there is no need for the next mount do log recovery and therefore
no need to have any knowledge of the new transactions.


-- 
Geoffrey Wehrman  651-683-5496  gwehrman@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
