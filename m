Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BLkebg181481 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 15:46:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A45C3158207
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 13:47:35 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HcQ4nSX2ihbFYaCj for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2010 13:47:35 -0800 (PST)
Date: Mon, 11 Jan 2010 16:47:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix stale inode flush avoidance
Message-ID: <20100111214733.GA10278@infradead.org>
References: <1263210321-21068-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263210321-21068-1-git-send-email-david@fromorbit.com>
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

On Mon, Jan 11, 2010 at 10:45:21PM +1100, Dave Chinner wrote:
> When reclaiming stale inodes, we need to guarantee that inodes are
> unpinned before returning with a "clean" status. If we don't we can
> reclaim inodes that are pinned, leading to use after free in the
> transaction subsystem as transactions complete.

Looks good.  Per discussion this morning the clean check might not be
good enough for delwri buffers either, but as let's leave that for the
more throughout redo of the inode buffer flushing.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
