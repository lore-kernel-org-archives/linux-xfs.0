Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 607577F67
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 19:40:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3B0EA8F8052
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 17:40:49 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id nDfj01uZlvXAuWa6 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 17:40:48 -0700 (PDT)
Date: Thu, 28 Aug 2014 17:40:47 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] xfs: use ranged writeback and invalidation for
	direct IO
Message-ID: <20140829004047.GD30463@infradead.org>
References: <1409226551-16570-1-git-send-email-david@fromorbit.com>
	<1409226551-16570-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1409226551-16570-5-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 28, 2014 at 09:49:08PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now we are not doing silly things with dirtying buffers beyond EOF
> and using invalidation correctly, we can finally reduce the ranges of
> writeback and invalidation used by direct IO to match that of the IO
> being issued.
> 
> Bring the writeback and invalidation ranges back to match the
> generic direct IO code - this will greatly reduce the perturbation
> of cached data when direct IO and buffered IO are mixed, but still
> provide the same buffered vs direct IO coherency behaviour we
> currently have.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks correct, although I wonder if it's really worth the risk exposing
us to the crazy details of the page cache invalidation range notations..

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
