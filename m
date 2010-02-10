Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1AI7djF068074 for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 12:07:47 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A81A71396794
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 10:08:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id prYW2uDRlmHVahXa for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2010 10:08:52 -0800 (PST)
Date: Wed, 10 Feb 2010 13:08:51 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for January 2010
Message-ID: <20100210180851.GA9854@infradead.org>
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
To: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

January saw additional release candidates of the Linux 2.6.33 kernel,
including a couple of bug fixes for XFS.  In the meantime the XFS tree
has been growing a large number of patches destined for the Linux 2.6.34
merge window: a large rework of the handling of per-AG data, support for
the quota netlink interface, and better power saving behavior of the
XFS kernel threads, and of course various cleanups.

A large patch series to replace the current asynchronous inode writeback
with a new scheme that uses the delayed write buffers was posted to
the list.  The new scheme, which allows archive better I/O locality by
dispatching meta-data I/O from a single place has been discussed
extensively and is expected to be merged in February.

On the userspace side January saw the 3.1.0 and 3.1.1 releases of xfsprogs,
as well as the 3.0.4 release of xfsdump.  The biggest changes in xfsprogs
3.1.0 were optimizations in xfs_repair that lead to a much lower memory
usage, and optional use of the blkid library for filesystem detection
and retrieving storage topology information.  The 3.1.1 release contained
various important bug fixes for these changes and a various improvements to
the build system.  The major feature of xfsdump 3.0.4 were fixes for
time stamp handling on 64-bit systems.

The xfstests package also lots of activity including various new testcases
and an improved build system.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
