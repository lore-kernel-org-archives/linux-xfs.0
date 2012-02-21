Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1L5N4ch146793 for <xfs@oss.sgi.com>; Mon, 20 Feb 2012 23:23:04 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	JrhqyBUCikPoUWBP for <xfs@oss.sgi.com>;
	Mon, 20 Feb 2012 21:23:03 -0800 (PST)
Date: Tue, 21 Feb 2012 16:23:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/8] xfs: add back fdatasync support
Message-ID: <20120221052301.GO3592@dastard>
References: <20120221003824.415885674@bombadil.infradead.org>
	<20120221003907.518904261@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120221003907.518904261@bombadil.infradead.org>
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

On Mon, Feb 20, 2012 at 07:38:32PM -0500, Christoph Hellwig wrote:
> Add an in-memory only flag to say we logged timestamps only, and use it to
> check if fdatasync can optimize away the log force.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Couple of minor things below.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> +/*
> + * The timestamps in the core are dirty, but not nessecarily anything
                                                    necessarily
> + * else.
> + *
> + * This is an incore only value store in ilf_fields & co, which must
> + * never make it to disk, unlike the other fields above.

That comment is a bit incoherent. Perhaps:

 * this is an incore-only flag stored in ili_fields which, unlike
 * the above flags, must never make it to disk in the ilf_fields.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
