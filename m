Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o02C051p103628 for <xfs@oss.sgi.com>; Sat, 2 Jan 2010 06:00:05 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CDCC71503378
	for <xfs@oss.sgi.com>; Sat,  2 Jan 2010 04:00:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id OIGeFDfYhgQnvgyJ for
	<xfs@oss.sgi.com>; Sat, 02 Jan 2010 04:00:54 -0800 (PST)
Date: Sat, 2 Jan 2010 07:00:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: Don't flush stale inodes
Message-ID: <20100102120053.GB18502@infradead.org>
References: <1262399980-19277-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1262399980-19277-1-git-send-email-david@fromorbit.com>
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

On Sat, Jan 02, 2010 at 01:39:40PM +1100, Dave Chinner wrote:
> Because inodes remain in cache much longer than inode buffers do
> under memory pressure, we can get the situation where we have stale,
> dirty inodes being reclaimed but the backing storage has been freed.
> Hence we should never, ever flush XFS_ISTALE inodes to disk as
> there is no guarantee that the backing buffer is in cache and
> still marked stale when the flush occurs.

We should not flush stale inodes.  But how do we even end up calling
xfs_iflush with a stale inode?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
