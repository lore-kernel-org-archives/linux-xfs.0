Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3BITMED105532 for <xfs@oss.sgi.com>; Mon, 11 Apr 2011 13:29:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15DE01E0B5DD
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2011 11:32:42 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vzO85zALrxOGp35u for
	<xfs@oss.sgi.com>; Mon, 11 Apr 2011 11:32:42 -0700 (PDT)
Date: Mon, 11 Apr 2011 14:32:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't look forever in xfs_inode_ag_walk during
	async inode flushes
Message-ID: <20110411183242.GB32346@infradead.org>
References: <1302157685-3966-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1302157685-3966-1-git-send-email-david@fromorbit.com>
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

On Thu, Apr 07, 2011 at 04:28:05PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When the underlying inode buffer is locked and xfs_sync_inode_attr()
> is doing a non-blocking flush, xfs_iflush() can return EAGAIN. When
> this happen??, clear the error rather than returning it to
> xfs_inode_ag_walk(), as returning EAGAIN will result in the AG walk
> delaying for a short while and trying again. This can result in
> background walks getting stuck on the one AG until inode buffer is
> unlocked by some other means.
> 
> This behaviour was noticed when analysing event traces followed by
> code inspection and verification of the fix via further traces.

It's a bit sad that we have two callers now that need to explicitly
ignore the EAGAIN and only one that actually cares, but until we
get rid of VFS-dirty inodes and ->write_inode it looks like we
can't do anything about it.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
