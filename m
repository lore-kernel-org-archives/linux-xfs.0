Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6R7uRAQ173419 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 02:56:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72D0E132FC6E
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 01:06:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id es1YQ5bBhZXvEZ9x for
	<xfs@oss.sgi.com>; Tue, 27 Jul 2010 01:06:51 -0700 (PDT)
Date: Tue, 27 Jul 2010 03:59:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: Introduce XFS_IOC_ZERO_RANGE
Message-ID: <20100727075930.GC30562@infradead.org>
References: <1280210129-10925-1-git-send-email-david@fromorbit.com>
	<1280210129-10925-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1280210129-10925-3-git-send-email-david@fromorbit.com>
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

On Tue, Jul 27, 2010 at 03:55:29PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFS_IOC_ZERO_RANGE is the equivalent of an atomic XFS_IOC_UNRESVSP/
> XFS_IOC_RESVSP call pair. It enabled ranges of written data to be
> turned into zeroes without requiring IO or having to free and
> reallocate the extents in the range given as would occur if we had
> to punch and then preallocate them separately.  This enables
> applications to zero parts of files very quickly without changing
> the layout of the files in any way.

This looks good minus the left over printks.  It'll also needs xfstests
coverage and a description in the xfsctl manpage.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
