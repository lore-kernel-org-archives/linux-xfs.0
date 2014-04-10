Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 222E77F91
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 17:37:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0AD15304053
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 15:37:46 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	iwSJydCfrJaeJEw1 for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 15:37:45 -0700 (PDT)
Date: Fri, 11 Apr 2014 08:35:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] xfs: zeroing space needs to punch delalloc blocks
Message-ID: <20140410223546.GE27519@dastard>
References: <1397106053-7489-1-git-send-email-david@fromorbit.com>
	<1397106053-7489-5-git-send-email-david@fromorbit.com>
	<20140410104001.GG17641@infradead.org>
	<20140410122259.GC27519@dastard>
	<20140410123332.GA15577@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140410123332.GA15577@infradead.org>
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
Cc: xfs@oss.sgi.com

On Thu, Apr 10, 2014 at 05:33:32AM -0700, Christoph Hellwig wrote:
> On Thu, Apr 10, 2014 at 10:22:59PM +1000, Dave Chinner wrote:
> > XFS_B_TO_FSB gives the same result given that we've already rounded
> > start_boundary to block granularity....
> 
> It does, but XFS_B_TO_FSBT is one less operation, and it's the better
> example for a start offset when people start copy & pasting it.

*nod*.

Fixed it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
