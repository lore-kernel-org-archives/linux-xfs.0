Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TDrbjH076076 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 08:53:38 -0500
Subject: Re: [PATCH 01/11] xfs: limit xfs_imap_to_bmap to a single mapping
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100428123014.517888577@bombadil.infradead.org>
References: <20100428122850.075189557@bombadil.infradead.org>
	<20100428123014.517888577@bombadil.infradead.org>
Date: Thu, 29 Apr 2010 08:55:13 -0500
Message-ID: <1272549313.3221.79.camel@doink>
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
> plain text document attachment (xfs-iomap-cleanup-1)
> We only call xfs_iomap for single mappings anyway, so remove all code
> dealing with multiple mappings from xfs_imap_to_bmap and add asserts
> that we never get results that we do not expect.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfs/fs/xfs/xfs_iomap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_iomap.c	2010-04-28 14:06:53.000000000 +0200
> +++ xfs/fs/xfs/xfs_iomap.c	2010-04-28 14:14:38.708003332 +0200

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
