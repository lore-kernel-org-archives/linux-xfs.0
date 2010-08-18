Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7IGbToM123201 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 11:37:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 046EC14D50C5
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 09:47:18 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AHXBzrGClkRHJw10 for
	<xfs@oss.sgi.com>; Wed, 18 Aug 2010 09:47:18 -0700 (PDT)
Date: Wed, 18 Aug 2010 12:37:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for July 2010
Message-ID: <20100818163758.GA4321@infradead.org>
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

July saw three more release candidates for the Linux 2.6.35 kernel, which
included a relatively large number of XFS updates.  There were two security
fixes, a small one to prevent swapext to operate on write-only file
descriptors, and a much larger one to properly validate inode numbers
coming from NFS clients or userspace applications using the bulkstat or
the open-by-handle interfaces.  In addition to that another relatively
large patch fixes the way inodes get reclaimed in the background, and
avoids inode caches growing out of bounds.

In the meantime the code for the Linux 2.6.36 got the last touches before
the expected opening of the merge window, by merging a few more last
minute fixes and cleanups.  The most notable one is a patch series
that fixes in-memory corruption when concurrently accessing unwritten
extents using the in-kernel AIO code.

The userspace side was still quite slow, but some a bit more activity
than June.  In xfsprogs the xfs_db code grew two bug fixes, as did
the xfs_io script.  The xfstests package saw one new test cases and
various fixes to existing code.  Last but not least a few patches
affecting the build system for all userspace tools were committed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
