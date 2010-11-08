Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA8NqKIh125065 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 17:52:20 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8D6916418E
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 15:53:47 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xn3SEwto2zdnjkm9 for
	<xfs@oss.sgi.com>; Mon, 08 Nov 2010 15:53:47 -0800 (PST)
Date: Mon, 8 Nov 2010 18:53:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for October 2010
Message-ID: <20101108235346.GA8498@infradead.org>
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

Near the end of the month we finally saw the release of Linux 2.6.36.
Just a single fix made it into mainline in this month, showing that the
stabilization period before has worked very well.

Linux 2.6.36 has been another impressive release for XFS, seeing
various performance improvements in the new delayed logging code,
for direct I/O and the sync system call, a few bug fixes, and lots
of cleanups, resulting in a net removal of over 2000 lines of code:

	89 files changed, 1998 insertions(+), 4279 deletions(-)

The merge window for Linux 2.6.37 opened just a few days after the
release of Linux 2.6.36 and already contains another large XFS update
at the end of October.  Highlights of the XFS tree merged into 2.6.37-rc1
are another large set of metadata scalability patches, support for 32-bit
wide project IDs, and support for the new XFS_IOC_ZERO_RANGE ioctl,
which allows to punch a whole and convert it to an unwritten extent
in a single atomic operation.  

The metadata scalability changes improve 8-way fs_mark of 50 million files
by over 15% and removal of those files by over 100%, with further
improvements expected by the next round of XFS metadata scalability
and VFS scalability improvements targeted at Linux 2.6.38.

On the user space side October was a rather quit month for xfsprogs, which
only saw the addition of 32-bit project ID handling, and a fix for
parsing the mount table in fsr when used together with disk encryption
tools.  A few patches for xfsdump were posted on the list, but none
was applied, leaving the majority of the user space activity to
xfstests, which saw very active development.  Various patches went
into xfstests to improve portability to filesystems with a limited
feature set, and to move more filters to generic code.  In addition
various cleanups to test cases in test programs were applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
