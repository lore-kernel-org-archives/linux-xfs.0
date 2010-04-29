Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TEQslh078110 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 09:26:55 -0500
Subject: Re: [PATCH 02/11] xfs: remove iomap_target
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100428123014.699705209@bombadil.infradead.org>
References: <20100428122850.075189557@bombadil.infradead.org>
	<20100428123014.699705209@bombadil.infradead.org>
Date: Thu, 29 Apr 2010 09:25:14 -0500
Message-ID: <1272551114.3221.95.camel@doink>
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
> plain text document attachment (xfs-iomap-cleanup-2)
> Instead of using the iomap_target field in struct xfs_iomap and the
> IOMAP_REALTIME flag just use the already existing xfs_find_bdev_for_inode
> helper.  There's some fallout as we need to pass the inode in a few more
> places, which we also use to sanitize some calling conventions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

There are other places the xfs_find_bdev_for_inode() helper ought
to be used also.

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


> Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
