Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5F1mF5x065714 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 20:48:15 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1732EAE2BC2
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 18:54:20 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	Q88ksHRTcHwv8UTS for <xfs@oss.sgi.com>;
	Mon, 14 Jun 2010 18:54:20 -0700 (PDT)
Date: Tue, 15 Jun 2010 11:50:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: simplify xfs_vm_writepage
Message-ID: <20100615015047.GO6590@dastard>
References: <20100611161312.446670249@bombadil.infradead.org>
	<20100611161512.404472115@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100611161512.404472115@bombadil.infradead.org>
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

On Fri, Jun 11, 2010 at 12:13:15PM -0400, Christoph Hellwig wrote:
> The writepage implementation in XFS still tries to deal with dirty but
> unmapped buffers which used to caused by writes through shared mmaps.  Since
> the introduction of ->page_mkwrite these can't happen anymore, so remove the
> code dealing with them.
> 
> Note that the all_bh variable which causes us to start I/O on all buffers on
> the pages was controlled by the count of unmapped buffers, which also
> included those not actually dirty.  It's now unconditionally initialized to
> 0 but set to 1 for the case of small file size extensions.  It probably can
> be removed entirely, but that's left for another patch.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
