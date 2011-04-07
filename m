Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p370CZHq063090 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 19:12:35 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DCB03AF5AF
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 17:15:51 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Nt8B9bkEPNnIZ9h1 for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2011 17:15:51 -0700 (PDT)
Date: Thu, 7 Apr 2011 10:15:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/9] xfs: push the AIL from memory reclaim and periodic
	sync
Message-ID: <20110407001548.GQ31057@dastard>
References: <1302070758-17312-1-git-send-email-david@fromorbit.com>
	<1302070758-17312-8-git-send-email-david@fromorbit.com>
	<20110406183356.GA23275@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110406183356.GA23275@infradead.org>
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

On Wed, Apr 06, 2011 at 02:33:56PM -0400, Christoph Hellwig wrote:
> The patch looks correct, but I wonder what the performance implications
> of flushing the AIL every 30 seconds are.  Did you benchmark the
> patchset to see what it does to performance numbers for metadata
> intensive workloads?

In my measurements it's made no difference.

If the workload is being sustained for more than a few seconds, then
memory reclaim typically becomes active and the push from there
becomes the dominating factor. This effectively makes the syncd work
trigger a no-op.

If the push from the syncd work does trigger work to be done, it's
generally because the filesystem has gone to idle or only has a low
level of modifications being done. In either case, it doesn't affect
performance, especially with delaylog pinning the working set of
metadata in memory...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
