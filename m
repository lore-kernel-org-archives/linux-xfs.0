Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1G0BOGi214129 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 18:11:24 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	EpgyGE4YA0FKma0p for <xfs@oss.sgi.com>;
	Wed, 15 Feb 2012 16:11:23 -0800 (PST)
Date: Thu, 16 Feb 2012 11:11:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/9] xfs: merge xfs_qm_export_dquot into
	xfs_qm_scall_getquota
Message-ID: <20120216001108.GS14132@dastard>
References: <20120215022926.577682146@bombadil.infradead.org>
	<20120215023148.024760659@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120215023148.024760659@bombadil.infradead.org>
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

On Tue, Feb 14, 2012 at 09:29:33PM -0500, Christoph Hellwig wrote:
> The is no good reason to have these two separate, and for the next change
> I'd need the full struct xfs_dquot in xfs_qm_export_dquot, so better just
> fold the code now instead of changing it around.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
