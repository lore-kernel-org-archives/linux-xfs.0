Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 993337CA0
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 18:15:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B8317AC004
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:15:08 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	h0d4drDqbiUp6jZZ for <xfs@oss.sgi.com>;
	Thu, 21 Jul 2016 16:15:06 -0700 (PDT)
Date: Fri, 22 Jul 2016 09:15:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: bufferhead chains are invalid after
	end_page_writeback
Message-ID: <20160721231504.GP16044@dastard>
References: <1468974083-3660-1-git-send-email-david@fromorbit.com>
	<20160721143221.GA27521@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160721143221.GA27521@infradead.org>
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

On Thu, Jul 21, 2016 at 07:32:21AM -0700, Christoph Hellwig wrote:
> Looks fine,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> (should probably go into 4.7 still..)

I'll tag it for -stable so it gets back there appropriately. The
problem exists in kernels long before the changes we've made
recently, however, but I don't think this fix will apply cleanly to
older kernels...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
