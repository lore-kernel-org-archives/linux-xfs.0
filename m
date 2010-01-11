Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BMPt5m184850 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 16:25:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 971C61C4377C
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 14:26:50 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id d9KW1Cihj3gM5KI3 for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2010 14:26:50 -0800 (PST)
Date: Mon, 11 Jan 2010 17:26:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for December 2009
Message-ID: <20100111222649.GA21308@infradead.org>
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

December finally saw the long awaited release of Linux 2.6.32, which for
XFS is mostly a bug fix release, with the major changes being various
improvement to the sync path, including working around the expectation
from the grub boot loader where metadata is supposed to be after a sync()
system call.  Together with a refactoring of the inode allocator this
gives a nice diffstat for this kernel release:

 46 files changed, 767 insertions(+), 1048 deletions(-)

In the meantime development for the 2.6.33 has been going strong.  The
new event tracing code that allows to observe the inner workings of XFS
in production systems has finally been merged, with another patch to
reduce the size of the tracing code by using new upstream kernel features
posted for review.  Also a large patch series has been posted which
changes per-AG data to be looked up by a radix tree instead of the
existing array.  This works around possible deadlocks and user after
free issues during growfs, and prepares for removing a global (shared)
lock from the free space allocators.  In addition to that a wide range
of fixes has been posted and applied.

Work on the userspace packages has been just as busy.  In mkfs.xfs the
lazy superblock counter feature has now been enabled by default for the
upcoming xfsprogs 3.1.0 release, which will require kernel 2.6.22 for
the default mkfs invocation.  Also for mkfs.xfs as patch was posted
to correct the automatic detection of 4 kilobyte sector drivers which
are expected to show up in large quantities the real work soon.  The
norepair mode in xfs_repair has been enhanced with additional freespace
btree correction checks from xfs_db and is now identical to xfs_check in
filesystem consistency checking coverage.  A temporary file permission
problems has been fixed in xfs_fsr, and the libhandle library has been
fixed to better deal with symbolic links.  In xfs_io a few commands
that were added years ago have finally been wired up to actually be
usable.  And last but not least xfsdump saw a fix to the time stamp
handling in the backup format and some usability and documentation
improvements to xfsinvutil.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
