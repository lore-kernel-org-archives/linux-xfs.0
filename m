Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0RNJLFc047851 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 17:19:21 -0600
Subject: Re: [PATCH 1/6] xfs: clean up the xfs_alloc_compute_aligned
	calling convention
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110121092550.457037752@bombadil.infradead.org>
References: <20110121092227.115815324@bombadil.infradead.org>
	<20110121092550.457037752@bombadil.infradead.org>
Date: Thu, 27 Jan 2011 17:21:42 -0600
Message-ID: <1296170502.7651.528.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Fri, 2011-01-21 at 04:22 -0500, Christoph Hellwig wrote:
> plain text document attachment (xfs-cleanup-xfs_alloc_compute_aligned)
> Pass a xfs_alloc_arg structure to xfs_alloc_compute_aligned and derive
> the alignment and minlen paramters from it.  This cleans up the existing
> callers, and we'll need even more information from the xfs_alloc_arg
> in subsequent patches.  Based on a patch from Dave Chinner.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
