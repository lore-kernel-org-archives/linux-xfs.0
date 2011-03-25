Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2PL1m10247238 for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 16:01:48 -0500
Subject: Re: [PATCH 6/6] xfs: make discard operations asynchronous
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110322200138.216042448@bombadil.infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200138.216042448@bombadil.infradead.org>
Date: Fri, 25 Mar 2011 16:04:55 -0500
Message-ID: <1301087095.2537.692.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Tue, 2011-03-22 at 15:55 -0400, Christoph Hellwig wrote:
> Instead of waiting for each discard request keep the CIL context alive
> until all of them are done, at which point we can tear it down completly
> and remove the busy extents from the rbtree.
> 
> At this point I'm doing the I/O completion from IRQ context for simplicity,
> but I'll benchmark it against a version that uses a workqueue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
