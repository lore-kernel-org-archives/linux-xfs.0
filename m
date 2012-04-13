Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DAVXdf025409 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 05:31:33 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qH98Ceycjrfw2ANn for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 03:31:32 -0700 (PDT)
Date: Fri, 13 Apr 2012 20:31:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/10] xfs: do not write the buffer from xfs_iflush
Message-ID: <20120413103130.GJ6734@dastard>
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164645.870931834@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327164645.870931834@bombadil.infradead.org>
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

On Tue, Mar 27, 2012 at 12:44:06PM -0400, Christoph Hellwig wrote:
> Instead of writing the buffer directly from inside xfs_iflush return it to
> the caller and let the caller decide what to do with the buffer.  Also
> remove the pincount check in xfs_iflush that all non-blocking callers already
> implement and the now unused flags parameter.
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
