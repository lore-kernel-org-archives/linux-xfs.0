Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2OMn48D149405 for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 17:49:04 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	rYB4YuBEHAj1Rvh1 for <xfs@oss.sgi.com>;
	Sat, 24 Mar 2012 15:49:02 -0700 (PDT)
Date: Sun, 25 Mar 2012 09:49:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/8] xfs: Account log unmount transaction correctly
Message-ID: <20120324224901.GG5091@dastard>
References: <1332393313-1955-1-git-send-email-david@fromorbit.com>
	<1332393313-1955-7-git-send-email-david@fromorbit.com>
	<20120324082700.GA16953@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120324082700.GA16953@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, Mar 24, 2012 at 04:27:00AM -0400, Christoph Hellwig wrote:
> Looks good.
> 
> Can we add a testcase doing lots of freeze/unfreeze cycles with no other
> load to xftests to verify the fix?

It's just a trivial while loop that needs about a hundred
freeze/unfreeze ops to trigger on a 10GB filesystem, so I'll add a
test for that...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
