Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAH4Pqci004015 for <xfs@oss.sgi.com>; Wed, 16 Nov 2011 22:25:53 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 900492587C3
	for <xfs@oss.sgi.com>; Wed, 16 Nov 2011 20:25:50 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	AqUxStdMGBSXNKiO for <xfs@oss.sgi.com>;
	Wed, 16 Nov 2011 20:25:50 -0800 (PST)
Date: Thu, 17 Nov 2011 15:25:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] repair: avoid ABBA deadlocks on prefetched buffers
Message-ID: <20111117042543.GF7046@dastard>
References: <20111115210953.GA6670@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111115210953.GA6670@infradead.org>
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

On Tue, Nov 15, 2011 at 04:09:53PM -0500, Christoph Hellwig wrote:
> Both the prefetch threads and actual repair processing threads can have
> multiple buffers at a time locked, but they do no use a common locker
> order, which can lead to ABBA deadlocks while trying to lock the buffers.
> 
> Switch the prefetch code to do a trylock and skip buffers that have
> already been locked to avoid this deadlock.
> 
> Reported-by: Arkadiusz Mi??kiewicz <arekm@maven.pl>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks sane to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
