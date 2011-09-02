Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p82F2fw2075293 for <xfs@oss.sgi.com>; Fri, 2 Sep 2011 10:02:41 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201109021502.p82F2W3w003902@stout.americas.sgi.com>
Date: Fri, 02 Sep 2011 10:02:32 -0500
Subject: [GIT PULL] XFS update for 3.1-rc5
MIME-Version: 1.0
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
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Linus, please pull the following XFS changes for 3.1-rc5.  The first
documents a feature that we plan to remove in 3.3.  The second fixes
a problem related to inode dirtying during unmount, and the third
fixes some other problems found in that region of code.

The last two have not been through a -next build because of the
recent kernel.org issues, but I've done testing with a local pull
into your current master branch and all looks well.

Thank you.

					-Alex

The following changes since commit 9e79e3e9dd9672b37ac9412e9a926714306551fe:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2011-08-30 11:28:18 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (3):
      xfs: deprecate the nodelaylog mount option
      xfs: fix xfs_mark_inode_dirty during umount
      xfs: fix ->write_inode return values

 Documentation/feature-removal-schedule.txt |    8 ++++++
 fs/xfs/xfs_iops.c                          |   14 ++++++++--
 fs/xfs/xfs_super.c                         |   36 ++++++++-------------------
 3 files changed, 30 insertions(+), 28 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
