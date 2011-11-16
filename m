Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAGNSc02236366 for <xfs@oss.sgi.com>; Wed, 16 Nov 2011 17:28:39 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DDB71D13076
	for <xfs@oss.sgi.com>; Wed, 16 Nov 2011 15:28:37 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	l20wU8oRCGgjIN11 for <xfs@oss.sgi.com>;
	Wed, 16 Nov 2011 15:28:37 -0800 (PST)
Date: Thu, 17 Nov 2011 10:28:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] xfs: do not require an ioend for new EOF calculation
Message-ID: <20111116232835.GC7046@dastard>
References: <20111115201407.038216766@bombadil.infradead.org>
	<20111115201426.862605739@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111115201426.862605739@bombadil.infradead.org>
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

On Tue, Nov 15, 2011 at 03:14:10PM -0500, Christoph Hellwig wrote:
> Replace xfs_ioend_new_eof with a new inline xfs_new_eof helper that
> doesn't require and ioend, and is available also outside of xfs_aops.c.
> 
> Also make the code a bit more clear by using a normal if statement
> instead of a slightly misleading MIN().
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
