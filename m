Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1L4uEsM144583 for <xfs@oss.sgi.com>; Mon, 20 Feb 2012 22:56:14 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	dFunEDbRo4m7CK7F for <xfs@oss.sgi.com>;
	Mon, 20 Feb 2012 20:56:12 -0800 (PST)
Date: Tue, 21 Feb 2012 15:56:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/12] log grant code cleanups V2
Message-ID: <20120221045610.GI3592@dastard>
References: <20120220023119.435889631@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120220023119.435889631@bombadil.infradead.org>
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

On Sun, Feb 19, 2012 at 09:31:19PM -0500, Christoph Hellwig wrote:
> This series removes the opportunistic log space wakeups which had no
> use but hiding real races for far too long, and applies various bits
> of refactoring to the log grant code to make it smaller and more readable.
> 
> Changes since V1:
> 	- address various minor review comments

You can add:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

To the series. Solving the higher level issue of grant heads moving
between the sample and the addition can wait until this goes in. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
