Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o73IuWl4252454 for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 13:56:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B35FF490BD6
	for <xfs@oss.sgi.com>; Tue,  3 Aug 2010 11:56:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id qE8yL51HRFQi6GtK for
	<xfs@oss.sgi.com>; Tue, 03 Aug 2010 11:56:52 -0700 (PDT)
Date: Tue, 3 Aug 2010 14:56:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: Introduce XFS_IOC_ZERO_RANGE
Message-ID: <20100803185652.GD2824@infradead.org>
References: <1280816526-30100-1-git-send-email-david@fromorbit.com>
	<1280816526-30100-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1280816526-30100-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 03, 2010 at 04:22:06PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFS_IOC_ZERO_RANGE is the equivalent of an atomic XFS_IOC_UNRESVSP/
> XFS_IOC_RESVSP call pair. It enabled ranges of written data to be
> turned into zeroes without requiring IO or having to free and
> reallocate the extents in the range given as would occur if we had
> to punch and then preallocate them separately.  This enables
> applications to zero parts of files very quickly without changing
> the layout of the files in any way.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
