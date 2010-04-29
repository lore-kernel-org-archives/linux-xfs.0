Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TEUj4F078326 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 09:30:46 -0500
Subject: Re: [PATCH 04/11] xfs: report iomap_offset and iomap_bsize in
	block base
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100428123015.107986898@bombadil.infradead.org>
References: <20100428122850.075189557@bombadil.infradead.org>
	<20100428123015.107986898@bombadil.infradead.org>
Date: Thu, 29 Apr 2010 09:32:47 -0500
Message-ID: <1272551567.3221.97.camel@doink>
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
> plain text document attachment (xfs-iomap-cleanup-4)
> Report the iomap_offset and iomap_bsize fields of struct xfs_iomap
> in terms of fsblocks instead of in terms of bytes.  Shift the byte
> conversions into the callers temporarily, but they will disappear
> or get cleaned up later.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


> Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-04-27 17:07:53.000000000 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-04-27 17:13:15.434005637 +0200
. . .


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
