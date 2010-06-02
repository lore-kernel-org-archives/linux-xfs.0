Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o525h4XY054216 for <xfs@oss.sgi.com>; Wed, 2 Jun 2010 00:43:05 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D668638D2D7
	for <xfs@oss.sgi.com>; Tue,  1 Jun 2010 22:45:30 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	F4BfzPUIntfx6X3W for <xfs@oss.sgi.com>;
	Tue, 01 Jun 2010 22:45:30 -0700 (PDT)
Date: Wed, 2 Jun 2010 15:45:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/17] xfs: give li_cb callbacks the correct prototype
Message-ID: <20100602054527.GI7011@dastard>
References: <20100531160727.842750532@bombadil.infradead.org>
	<20100531160901.036824012@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100531160901.036824012@bombadil.infradead.org>
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

On Mon, May 31, 2010 at 12:07:36PM -0400, Christoph Hellwig wrote:
> Stop the function pointer casting madness and give all the li_cb instances
> correct prototype.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks like it applies on top of my xfs_ifree_cluster() bug fix.
Looks good, anyway.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
