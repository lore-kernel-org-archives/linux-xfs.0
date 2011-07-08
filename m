Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p68AMMjf233499 for <xfs@oss.sgi.com>; Fri, 8 Jul 2011 05:22:22 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5855F14FFA8F
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2011 03:22:20 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	8CBFCtz8GLN4AaEO for <xfs@oss.sgi.com>;
	Fri, 08 Jul 2011 03:22:20 -0700 (PDT)
Date: Fri, 8 Jul 2011 20:22:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 22/28] xfs: use generic get_unaligned_beXX helpers
Message-ID: <20110708102218.GO1026@dastard>
References: <20110707110535.205001532@bombadil.infradead.org>
	<20110707110644.847340796@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110707110644.847340796@bombadil.infradead.org>
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

On Thu, Jul 07, 2011 at 07:05:57AM -0400, Christoph Hellwig wrote:
> Switch the shortform directory code over to use the generic
> get_unaligned_beXX helpers instead of reinventing them.  As a result
> kill off xfs_arch.h and move the setting of XFS_NATIVE_HOST into
> xfs_linux.h.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alex Elder <aelder@sgi.com>

The issues with the masking can be deal with separately.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
