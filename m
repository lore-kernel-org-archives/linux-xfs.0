Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5I7Uw6x213398 for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 02:30:58 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED981B1DD80
	for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 00:37:23 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	K6PzAHFh5HAD7kou for <xfs@oss.sgi.com>;
	Fri, 18 Jun 2010 00:37:23 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: xfs: validate inode numbers in file handles correctly
Date: Fri, 18 Jun 2010 17:32:50 +1000
Message-Id: <1276846374-23916-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: security@kernel.org

This series closes a recently discovered problem in XFS filehandle conversion.
On systems where inodes are dynamically deleted, XFS does not adequately verify
the inode numbers in the filehandles, which results in reading stale inodes
from disk and potentially returning them as valid files. Because these unlinked
inodes were never zeroed out when the chunk was deallocated, some inodes in the
chunk can still appear to have to data extents attached to them. This can lead
to stale data exposure, exposure of active data and potentially overwriting of
active data if the stale extents referenced in the unlinked inodes have been
re-allocated.

Both NFS filehandles and local filehandles provided through libhandle have this
same problem. libhandle requires root permissions to use the interface, so it
is not exposing information that you can't get more easily with other means
(e.g. xfs_db or reading directly form the block device), so there isn't really
an issue here.

For NFS, we may incorrectly accept stale file handles for unlinked inodes after
a server reboot if the unlinked inodes have not been overwritten leading to the
above issues being triggered if multiple NFS clients are accessing the some
files.

Christoph's make-bulkstat-coherent patch is the basis for this series as
bulkstat can also expose unlinked inodes and information about them back to
userspace because it makes the same assumptions about inode lookups as the file
handle interfaces.

As a result, the first two patches of the series make up the real bug fix. The
last two patches make it clear we are looking up untrusted inode numbers and
remove a shortcut that these interfaces used that we do not want used any
more. Hence for backports to other kernels, only the first two patches are
necessary.

More information and the test program that demonstrates the issue via the
open_by_handle interface can be found here:

http://oss.sgi.com/archives/xfs/2010-06/msg00191.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
