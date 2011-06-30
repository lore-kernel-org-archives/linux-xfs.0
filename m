Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U30dG3166897 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 22:00:40 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16D8A4C2764
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 20:00:38 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	8yLt4HtpySA5PTBI for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 20:00:38 -0700 (PDT)
Date: Thu, 30 Jun 2011 13:00:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/27] xfs: remove i_transp
Message-ID: <20110630030035.GF561@dastard>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140338.898243621@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110629140338.898243621@bombadil.infradead.org>
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

On Wed, Jun 29, 2011 at 10:01:21AM -0400, Christoph Hellwig wrote:
> Remove the transaction pointer in the inode.  It's only used to avoid
> passing down an argument in the bmap code, and for a few asserts in
> the transaction code right now.
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
