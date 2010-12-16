Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBGFitws078673 for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 09:44:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36A971EEAFE
	for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 07:46:50 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ML0MEFsqFlyLfEQy for
	<xfs@oss.sgi.com>; Thu, 16 Dec 2010 07:46:50 -0800 (PST)
Date: Thu, 16 Dec 2010 10:46:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: don't truncate prealloc from frequently
	accessed inodes
Message-ID: <20101216154649.GA1388@infradead.org>
References: <1292203511-15685-1-git-send-email-david@fromorbit.com>
	<1292203511-15685-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292203511-15685-3-git-send-email-david@fromorbit.com>
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

On Mon, Dec 13, 2010 at 12:25:11PM +1100, Dave Chinner wrote:
> The new counter in the struct xfs_inode fits into a hole in the
> structure on 64 bit machines, so does not grow the size of the inode
> at all.

The count actually is gone now.


But this patch totally changes xfstests 203 output for me.  Given that
the test doesn't care about the allocation pattern it's probably fine,
but we'll a fix for the testcase.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
