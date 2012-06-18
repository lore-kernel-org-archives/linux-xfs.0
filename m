Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5I3QBJR118894 for <xfs@oss.sgi.com>; Sun, 17 Jun 2012 22:26:11 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ICgSb4XdNw6nrevc for <xfs@oss.sgi.com>;
	Sun, 17 Jun 2012 20:26:10 -0700 (PDT)
Resent-Message-ID: <20120618032609.GR19223@dastard>
Resent-To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com
Date: Mon, 18 Jun 2012 12:11:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/7] xfs: add a short cut to xfs_dialloc for the non-NULL
	agbp case
Message-ID: <20120618021107.GK19223@dastard>
References: <20120605144647.051012936@bombadil.infradead.org>
	<20120605144836.097576146@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120605144836.097576146@bombadil.infradead.org>
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

On Tue, Jun 05, 2012 at 10:46:51AM -0400, Christoph Hellwig wrote:
> In this case we already have selected an AG and know it has free space
> beause the buffer lock never got released.  Jump directly into xfs_dialloc_ag
> and short cut the AG selection loop.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
