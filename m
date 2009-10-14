Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9E08CxX162030 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 19:08:13 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD00611A0E4D
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 17:09:42 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5m7G3HZgumzBBoGV for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2009 17:09:42 -0700 (PDT)
Date: Tue, 13 Oct 2009 20:09:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for September 2009
Message-ID: <20091014000942.GA8811@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

In September the Linux 2.6.31 kernel was finally released, including another
last minute XFS fix for the swapext (defragmentation) compat ioctl handler.
The final patch from 2.6.30 to 2.6.31 shows the following impressive diffstat
for XFS:

   55 files changed, 1476 insertions(+), 2269 deletions(-)

The 2.6.32 merge window started with a large XFS merge that included changes
to the inode allocator, and a few smaller fixes.  New versions of the sync 
and time stamp fixes as well as the event tracing support have been posted
in September but not yet merged into the XFS development tree and/or mainline.

On the userspace side a large patch series to reduce the memory usage in
xfs_repair to acceptable levels was posted, but not yet merged.  A new xfs_df
shell script to measure use of the on disk space was posted but not yet
merged pending some minor review comments and a missing man page.  In addition
we saw the usual amount of smaller fixes and cleanups.

Also this month Felix Blyakher resigned from his post as XFS maintainer
and handed off to Alex Elder.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
