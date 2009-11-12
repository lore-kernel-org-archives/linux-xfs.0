Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nACHsaSP010113 for <xfs@oss.sgi.com>; Thu, 12 Nov 2009 11:54:37 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 32D91D1958E
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2009 09:54:56 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zVqxRyZIJb6gK0KY for
	<xfs@oss.sgi.com>; Thu, 12 Nov 2009 09:54:56 -0800 (PST)
Date: Thu, 12 Nov 2009 12:54:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for October 2009
Message-ID: <20091112175455.GA32539@infradead.org>
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

In October we saw the Linux 2.6.32 merge window with a major XFS update.
This update includes a refactoring of the inode allocator which also
allows for speedups for very large filesystems, major sync fixes, updates
to the fsync and O_SYNC handling which merge the two code paths into a single
and more efficient one, a workaround for the VFS time stamp behavior,
and of course various smaller fixes.  A couple of additional fixes have been
queued up for the next merge window.

On the userspace side there has been a healthy activity on xfsprogs:  mkfs can
now discard unused sectors on SSDs and thinly provisioned storage devices and
use the more generic libblkid for topology information and filesystems detection
instead of the older libdisk, and the build system gained some updates to
make the source package generation simpler and shared for different package
types.  A patch has been out to the list but yet committed to add symbol
versioning to the libhandle library to make future ABI additions easier.
The xfstests package only saw some minor activity with a new test case
and small build system fixes.

New minor releases of xfsprogs and xfsdump were tagged but not formally
released after additional discussion.  Instead a new major xfsprogs release
is planned for next month.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
