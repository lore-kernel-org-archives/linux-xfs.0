Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5IC8sQG174917 for <xfs@oss.sgi.com>; Mon, 18 Jun 2012 07:09:00 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	8XUUvQjZsAZBT8lb (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Jun 2012 05:08:54 -0700 (PDT)
Date: Mon, 18 Jun 2012 08:08:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for May 2012
Message-ID: <20120618120853.GA15480@infradead.org>
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
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

May saw the release of Linux 3.4, including a decent sized XFS update.
Remarkable XFS features in Linux 3.4 include moving over all metadata
updates to use transactions, the addition of a work queue for the
low-level allocator code to avoid stack overflows due to extreme stack
use in the Linux VM/VFS call chain, better xattr operation tracing,
fixes for a long-standing but hard to hit deadlock when using the XFS
real time subvolume, and big improvements in disk quota scalability.

The final diffstat for XFS in Linux 3.4 is:

 61 files changed, 1692 insertions(+), 2356 deletions(-)

In the meantime the merge window for Linux 3.5 opened, and another large
update has been merged into Linus' tree.  Interesting changes in Linux
3.5-rc1 include improved error handling on buffer write failures,
a drastic reduction of locking overhead when doing high-IOPS direct I/O,
removal of the old xfsbufd daemon in favor of writing most run-time
metadata from the xfsaild daemon, deferral of CIL pushes to decouple
user space metadata I/O from log writeback, and last but not least the
addition of the SEEK_DATA/SEEK_HOLE lseek arguments that allow user space
programs to deal with sparse files efficiently. Traffic on the mailing list
has been a bit quiet in May, mostly focusing on a wide range of bug fixes,
but little new features.

On the user space side xfs_repair saw a few bug fixes posted to the list
that didn't make it to the repository yet, while xfstests saw it's usual
amount of minor bug fixes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
