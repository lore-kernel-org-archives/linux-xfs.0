Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TKDdlh098553 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 15:13:39 -0500
Subject: Re: [PATCH 08/11] xfs: clean up xfs_iomap_valid
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100428123015.969557658@bombadil.infradead.org>
References: <20100428122850.075189557@bombadil.infradead.org>
	<20100428123015.969557658@bombadil.infradead.org>
Date: Thu, 29 Apr 2010 15:15:38 -0500
Message-ID: <1272572138.3221.127.camel@doink>
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
> plain text document attachment (xfs-iomap-cleanup-9)
> Rename all iomap_valid identifiers to imap_valid to fit the new world order,
> and clean up xfs_iomap_valid to convert the passed in offset to blocks
> instead of the imap values to bytes.  Use the simpler inode->i_blkbits
> instead of the XFS macros for this.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
