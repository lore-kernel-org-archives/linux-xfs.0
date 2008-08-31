Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 31 Aug 2008 10:09:34 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7VH9VbF028713
	for <xfs@oss.sgi.com>; Sun, 31 Aug 2008 10:09:32 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5D1E1223B25
	for <xfs@oss.sgi.com>; Sun, 31 Aug 2008 10:10:55 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id TQSSp4P0lUhA70cv for <xfs@oss.sgi.com>; Sun, 31 Aug 2008 10:10:55 -0700 (PDT)
Date: Sun, 31 Aug 2008 19:10:56 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: XFS status update for August 2008
Message-ID: <20080831171056.GA23373@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

With the 2.6.27-rc5 release the 2.6.27 cycle is nearing it's end.  The major
XFS feature in 2.6.27-rc5 is support for case-insensitive file names.  At
this point it is still limited to 7bit ASCII file names, with updates for
utf8 file names expected to follow later.  In addition to that 2.6.27-rc5
fixes a long-standing problem with non-EABI arm compiler which pack some XFS
data structures wrongly.  Besides this 2.6.27-rc5 also contains various
cleanups, most notably the removal of the last bhv_vnode_t instances, and
most uses of semaphores.  As usual the diffstat for XFS from 2.6.26 to
2.6.26-rc5 is negative:

	 100 files changed, 3819 insertions(+), 4409 deletions(-)

On the user space front a new minor xfsprogs version is about to be released
containing various fixes including the user space part of arm packing fix.

Work in progress on the XFS mailing list are a large patch set to unify the
alloc, inobt and bmap btree implementation into a single that supports
arbitrarily pluggable key and record formats.  These btree changes are the
first major preparation for adding CRC checks to all metadata structures in
XFS, and an even larger patch set to unify the XFS and Linux inode structures,
and perform all inode write back from the btree uses instead of an inode
cache in XFS.
