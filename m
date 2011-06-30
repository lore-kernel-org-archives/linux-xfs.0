Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U74r7P188075 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 02:04:54 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6DE9A4C2AB6
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 00:04:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	izqpSbrYI7FzkmS1 for <xfs@oss.sgi.com>;
	Thu, 30 Jun 2011 00:04:52 -0700 (PDT)
Date: Thu, 30 Jun 2011 17:04:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 15/27] xfs: kill struct xfs_dir2_sf
Message-ID: <20110630070449.GJ561@dastard>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140339.466443510@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110629140339.466443510@bombadil.infradead.org>
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

On Wed, Jun 29, 2011 at 10:01:24AM -0400, Christoph Hellwig wrote:
> The list field of it is never cactually used, so all uses can simply be
> replaced with the xfs_dir2_sf_hdr_t type that it has as first member.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I can't help but think this would have been a much smaller patch if
you rolled the contents of the xfs_dir2_sf_hdr_t into xfs_dir2_sf_t
and killed the xfs_dir2_sf_hdr_t instead. There's many more
occurrences of xfs_dir2_sf_t than there are xfs_dir2_sf_hdr_t.

Anyway, gotta run now so I'll look at this more later....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
