Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 89B897F56
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 05:11:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 24982AC00A
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 03:11:14 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id 80HxDk5gAu8lkGhV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 03:11:12 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: a simple and scalable pNFS block layout server V2
Date: Thu, 22 Jan 2015 12:09:46 +0100
Message-Id: <1421925006-24231-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

This series adds support for the pNFS operations in NFS v4.1, as well
as a block layout driver that can export block based filesystems that
implement a few additional export operations.  Support for XFS is
provided in this series, but other filesystems could be added easily.

The core pNFS code of course owns its heritage to the existing Linux
pNFS server prototype, but except for a few bits and pieces in the
XDR path nothing is left from it.

The design of this new pNFS server is fairly different from the old
one - while the old one implemented very little semantics in nfsd
and left almost everything to filesystems my implementation implements
as much as possible in common nfsd code, then dispatches to a layout
driver that still is part of nfsd and only then calls into the
filesystem, thus keeping it free from intimate pNFS knowledge.

This version of the code has been rebased to the locks-for-3.20
tree which adds a new lock context structure to the inode.  For now
we still (ab)use the lease list like in the last version.  Adding
a pNFS-specific list would duplicate a lot of code without much
benefit.  But during this research I came up with way to associate
a nfs4_file with a struct file at open time which should allow
to greatly simplify the pNFS and delegation code.  So stay tuned
for some patches in this area!

For now this also doesn't take errata 3901 for rfc 5661 into account
yet and sticks to the verified errata.  The changes in 3901 seem
useful in the longer run one verified and will be implemented
eventually. Note that the only existing pNFS block client (Linux)
would not benefit from the longer layout lifetimes anyway.

More details are document in the individual patch descriptions and
code comments.

This code is also available from:

	git://git.infradead.org/users/hch/pnfs.git pnfsd-for-3.20-2

Changes since V1:
	- rebased to the locks-for-3.20 tree
	- fixed a memory leak in the nfsd4_encode_getdeviceinfo error path
	- removed the always one lg_roc field
	- added a nopnfs export option
	- use a synchronous transaction in layoutget to simplify recovery
	- various XFS fixes pointed out by Dave
	- various documentation typo fixes

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
