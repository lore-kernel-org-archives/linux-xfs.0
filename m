Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1N0lEPn008016 for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 18:47:14 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ABCB712CFD41
	for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 16:49:48 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	u5Fpt4IlrM32MEcH for <xfs@oss.sgi.com>;
	Tue, 22 Feb 2011 16:49:48 -0800 (PST)
Date: Wed, 23 Feb 2011 11:49:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: stop using xfs_trans_iget in the RT allocator
Message-ID: <20110223004946.GI3166@dastard>
References: <20110213132531.GA18279@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110213132531.GA18279@infradead.org>
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

On Sun, Feb 13, 2011 at 08:25:31AM -0500, Christoph Hellwig wrote:
> During mount we establish references to the RT inodes, which we keep for
> the lifetime of the filesystem.  Instead of using xfs_trans_iget to grab
> additional references when adding RT inodes to transactions use the
> combination of xfs_ilock and xfs_trans_ijoin_ref, which archives the same
                                                          achieves
> end result with less overhead.
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
