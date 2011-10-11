Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9BMZUCX025422 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 17:35:30 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D52371BD6CC
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 15:35:28 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Wgmv2sRwdPywgnCA for <xfs@oss.sgi.com>;
	Tue, 11 Oct 2011 15:35:28 -0700 (PDT)
Date: Wed, 12 Oct 2011 09:35:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/11] xfs: do not flush data workqueues in
	xfs_flush_buftarg
Message-ID: <20111011223525.GE3159@dastard>
References: <20111010165242.656850411@bombadil.infradead.org>
	<20111010165328.386947740@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111010165328.386947740@bombadil.infradead.org>
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

On Mon, Oct 10, 2011 at 12:52:53PM -0400, Christoph Hellwig wrote:
> When we call xfs_flush_buftarg (generally from sync or umount) it already
> is too late to flush the data workqueues, as I/O completion is signalled
> for them and we are thus already done with the data we would flush here.
> 
> There are places where flushing them might be useful, but the current
> sync interface doesn't give us that opportunity.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
