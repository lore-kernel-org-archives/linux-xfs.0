Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O01VS6243222 for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 19:01:32 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80E8918D9446
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 17:01:29 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	SB4lLqyLHLuwcMxI for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 17:01:29 -0700 (PDT)
Date: Wed, 24 Aug 2011 10:01:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/11] xfs: defer AIO/DIO completions
Message-ID: <20110824000125.GF3162@dastard>
References: <20110823082802.335389799@bombadil.infradead.org>
	<20110823082913.270459702@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110823082913.270459702@bombadil.infradead.org>
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

On Tue, Aug 23, 2011 at 04:28:10AM -0400, Christoph Hellwig wrote:
> We really shouldn't complete AIO or DIO requests until we have finished
> the unwritten extent conversion and size update.  This means fsync never
> has to pick up any ioends as all work has been completed when signalling
> I/O completion.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Much nicer ;)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
