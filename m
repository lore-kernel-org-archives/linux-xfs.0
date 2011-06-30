Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U1YESg163987 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 20:34:14 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 90C5C4C2548
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 18:34:12 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	VDPurO6rC4G51C07 for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 18:34:12 -0700 (PDT)
Date: Thu, 30 Jun 2011 11:34:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/27] xfs: PF_FSTRANS should never be set in ->writepage
Message-ID: <20110630013410.GW561@dastard>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140336.532726362@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110629140336.532726362@bombadil.infradead.org>
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

On Wed, Jun 29, 2011 at 10:01:10AM -0400, Christoph Hellwig wrote:
> Now that we reject direct reclaim in addition to always using GFP_NOFS
> allocation there's no chance we'll ever end up in ->writepage with
> PF_FSTRANS set.  Add a WARN_ON if we hit this case, and stop checking
> if we'd actually need to start a transaction.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alex Elder <aelder@sgi.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
