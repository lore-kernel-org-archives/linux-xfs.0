Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TEcPDA078696 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 09:38:25 -0500
Subject: Re: [PATCH 05/11] xfs: report iomap_bn in block base
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100428123015.330173874@bombadil.infradead.org>
References: <20100428122850.075189557@bombadil.infradead.org>
	<20100428123015.330173874@bombadil.infradead.org>
Date: Thu, 29 Apr 2010 09:39:43 -0500
Message-ID: <1272551983.3221.100.camel@doink>
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

On Wed, 2010-04-28 at 08:28 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-iomap-cleanup-5)
> Report the iomap_bn field of struct xfs_iomap in terms of filesystem blocks
> instead of in terms of bytes.  Shift the byte conversions into the caller,
> and replace the IOMAP_DELAY and IOMAP_HOLE flag checks with checks for
> HOLESTARTBLOCK and DELAYSTARTBLOCK.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good, although iomap_bn was previously a disk address,
not a byte offset (as you suggest in your summary).  I can
fix it if you like.

Reviewed-by: Alex Elder <aelder@sgi.com>


> Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
