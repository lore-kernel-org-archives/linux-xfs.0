Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n61Etn7E017399 for <xfs@oss.sgi.com>; Wed, 1 Jul 2009 09:55:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 602A13375D9
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2009 07:56:21 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ihzfaLRHrJJm2BM9 for
	<xfs@oss.sgi.com>; Wed, 01 Jul 2009 07:56:21 -0700 (PDT)
Date: Wed, 1 Jul 2009 10:56:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for June 2009
Message-ID: <20090701145620.GA13061@infradead.org>
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


On June 9th we finally saw the release of Linux 2.6.30.  For XFS
this release mostly contains the improved ENOSPC handling, but also
various smaller bugfixes and lots of cleanups.  The code size of XFS
decreased again by 500 lines of code in this release.

The Linux 2.6.31 merge opened in the mid of the month and some big XFS
changes have been pushed: A removal of the quotaops 
infrastructure which simplifies the quota implementation, the switch
from XFS's own Posix ACL implementation to the generic one shared
by various other filesystems which also supports in-memory caching of
ACLs and another incremental refactoring of the sync code.

A patch to better track dirty inodes and work around issues in the
way the VFS updates the access time stamp on inodes has been reposted
and discussed. Another patch to converting the existing XFS tracing
infrastructure to use the ftrace even tracer has been posted.

On the userspace side there have been a few updates to xfsprogs, including
some repair fixes and a new fallocate command for xfs_io.  There were
major updates for xfstests:  The existing aio-dio-regress testsuite has
been merged into xfstests, and various changes went into the tree to make
xfstests better suitable for use with other filesystems.

The attr and acl projects which have been traditionally been hosted
as part of the XFS userspace utilities have now been split into a separate
project maintained by Andreas Gruenbacher, who has been doing most of
the work on it, and moved to the Savannah hosting platform.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
