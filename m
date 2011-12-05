Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB55fFWT113300 for <xfs@oss.sgi.com>; Sun, 4 Dec 2011 23:41:16 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5BFF729A211
	for <xfs@oss.sgi.com>; Sun,  4 Dec 2011 21:41:12 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ywGklIQvQPLrBPGP for <xfs@oss.sgi.com>;
	Sun, 04 Dec 2011 21:41:12 -0800 (PST)
Date: Mon, 5 Dec 2011 16:22:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/16] xfs: add a xfs_dqhold helper
Message-ID: <20111205052234.GT7046@dastard>
References: <20111128082722.604873274@bombadil.infradead.org>
	<20111128082838.499215551@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128082838.499215551@bombadil.infradead.org>
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

On Mon, Nov 28, 2011 at 03:27:35AM -0500, Christoph Hellwig wrote:
> Factor the common pattern of:
> 
> 	xfs_dqlock(dqp);
> 	XFS_DQHOLD(dqp);
> 	xfs_dqunlock(dqp);
> 
> into a new helper, and remove XFS_DQHOLD now that only two callers are left.

I only saw one caller left in the patch that was open coded....

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Anyway,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
