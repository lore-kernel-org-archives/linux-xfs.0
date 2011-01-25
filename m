Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P4L5rX179571 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 22:21:05 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCDFA28D6C3
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 20:23:27 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	tB7PX2v5FwDSS0Yr for <xfs@oss.sgi.com>;
	Mon, 24 Jan 2011 20:23:27 -0800 (PST)
Date: Tue, 25 Jan 2011 15:23:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] xfs: clean up the xfs_alloc_compute_aligned
	calling convention
Message-ID: <20110125042325.GI11040@dastard>
References: <20110121092227.115815324@bombadil.infradead.org>
	<20110121092550.457037752@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110121092550.457037752@bombadil.infradead.org>
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

On Fri, Jan 21, 2011 at 04:22:28AM -0500, Christoph Hellwig wrote:
> Pass a xfs_alloc_arg structure to xfs_alloc_compute_aligned and derive
> the alignment and minlen paramters from it.  This cleans up the existing
> callers, and we'll need even more information from the xfs_alloc_arg
> in subsequent patches.  Based on a patch from Dave Chinner.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Good cleanup.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
