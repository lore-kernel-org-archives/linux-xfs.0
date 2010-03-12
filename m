Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2CABU5D242518 for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 04:11:31 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9926A1D2F58C
	for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 02:13:04 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id VmRTQs5JGT1KOByW for
	<xfs@oss.sgi.com>; Fri, 12 Mar 2010 02:13:04 -0800 (PST)
Date: Fri, 12 Mar 2010 05:13:04 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: duplicate extent btrees in xfs_repair need
	locking
Message-ID: <20100312101304.GB15922@infradead.org>
References: <1268298930-20809-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1268298930-20809-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 11, 2010 at 08:15:30PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The per-ag duplicate extent btrees can be search concurrently from multiple
> threads. This occurs when inode extent lists are being processed and inodes
> with extents in the same AG are checked concurrently. The btrees have an
> internal traversal cursor, so doing concurrent searches can result in the
> cursor being corrupted for both searches.
> 
> Add an external lock for each duplicate extent tree and use it for searches,
> inserts and deletes to ensure that we don't trash the state of any operation.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Note that all actual content modifications to the tree are done from
single threaded code, so strictly speaking we'd only need to lock in
search_dup_extent.  Anyway, the locking shouldn't add enough overhead
to worry about this, so:


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
