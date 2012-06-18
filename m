Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5I3OWMc118730 for <xfs@oss.sgi.com>; Sun, 17 Jun 2012 22:24:32 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	VPUefDgntGOwa0ZL for <xfs@oss.sgi.com>;
	Sun, 17 Jun 2012 20:24:30 -0700 (PDT)
Resent-Message-ID: <20120618032428.GP19223@dastard>
Resent-To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com
Date: Mon, 18 Jun 2012 11:46:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/7] xfs: split xfs_dialloc
Message-ID: <20120618014654.GI19223@dastard>
References: <20120605144647.051012936@bombadil.infradead.org>
	<20120605144835.679206152@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120605144835.679206152@bombadil.infradead.org>
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

On Tue, Jun 05, 2012 at 10:46:49AM -0400, Christoph Hellwig wrote:
> Move the actual allocation once we have selected an allocation group into a
> separate helper, and make xfs_dialloc a wrapper around it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

looks ok. One minor thing - convert all the typedefs in the in
xfs_dialloc() function header to struct xxx format while you are
touching this code...

Other than that, 

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
