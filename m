Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p664A0aK065775 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 23:10:00 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A93934D8C6
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 20:56:09 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	S5XnYs23sPUfu2zJ for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2011 20:56:09 -0700 (PDT)
Date: Wed, 6 Jul 2011 13:55:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 27/27] xfs: avoid a few disk cache flushes
Message-ID: <20110706035557.GV1026@dastard>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094607.799498339@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110701094607.799498339@bombadil.infradead.org>
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

On Fri, Jul 01, 2011 at 05:43:48AM -0400, Christoph Hellwig wrote:
> There is no need for a pre-flush when doing writing the second part of a
> split log buffer, and if we are using an external log there is no need
> to do a full cache flush of the log device at all given that all writes
> to it use the FUA flag.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
