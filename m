Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5I3QSuG118947 for <xfs@oss.sgi.com>; Sun, 17 Jun 2012 22:26:28 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zO6mdj27gwD1Z7Mv for <xfs@oss.sgi.com>;
	Sun, 17 Jun 2012 20:26:26 -0700 (PDT)
Resent-Message-ID: <20120618032625.GT19223@dastard>
Resent-To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com
Date: Mon, 18 Jun 2012 12:30:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/7] xfs: do not read the AGI buffer in xfs_dialloc until
	nessecary
Message-ID: <20120618023004.GM19223@dastard>
References: <20120605144647.051012936@bombadil.infradead.org>
	<20120605144836.472805881@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120605144836.472805881@bombadil.infradead.org>
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

On Tue, Jun 05, 2012 at 10:46:53AM -0400, Christoph Hellwig wrote:
> Refactor the AG selection loop in xfs_dialloc to operate on the in-memory
> perag data as much as possible.  We only read the AGI buffer once we have
> selected an AG to allocate inodes now instead of for every AG considered.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
