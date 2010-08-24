Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7O2iRbc159614 for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 21:44:28 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2D3E1E50CF7
	for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 19:44:59 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	mIsvFAJrJ8n7L2Bd for <xfs@oss.sgi.com>;
	Mon, 23 Aug 2010 19:44:59 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	24753122-1927428
	for <xfs@oss.sgi.com>; Tue, 24 Aug 2010 12:14:57 +0930 (CST)
Received: from dave by dastard with local (Exim 4.71)
	(envelope-from <david@fromorbit.com>) id 1OnjVG-0005HF-1d
	for xfs@oss.sgi.com; Tue, 24 Aug 2010 12:44:46 +1000
Date: Tue, 24 Aug 2010 12:44:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT Review] xfs: 2.6.36 fixes
Message-ID: <20100824024445.GJ31488@dastard>
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

Folks,

Can you please cast an eye over the the tree below to check that all
the bug fixes that need to go into 2.6.36 are there? If so, I'll
send a pull request to Linus tomorrow.

Note that these are just the outstanding bug fixes that have been
reviewed (as Linus has again decreed for pull requests after -rc1),
so it not the complete set of reviewd patches that exist.

Cheers,

Dave.


The following changes since commit 9ee47476d6734c9deb9ae9ab05d963302f6b6150:

  Merge branch 'radix-tree' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev (2010-08-22 19:55:14 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git 2.6.36-fixes

Christoph Hellwig (1):
      xfs: do not discard page cache data on EAGAIN

Dave Chinner (8):
      xfs: unlock items before allowing the CIL to commit
      xfs: ensure we mark all inodes in a freed cluster XFS_ISTALE
      xfs: fix untrusted inode number lookup
      writeback: write_cache_pages doesn't terminate at nr_to_write <= 0
      xfs: handle negative wbc->nr_to_write during sync writeback
      xfs: dummy transactions should not dirty VFS state
      xfs: Reduce log force overhead for delayed logging
      xfs: don't do memory allocation under the CIL context lock

Stuart Brodsky (1):
      xfs: ensure f_ffree returned by statfs() is non-negative

 fs/xfs/linux-2.6/xfs_aops.c  |   13 ++-
 fs/xfs/linux-2.6/xfs_super.c |    9 +-
 fs/xfs/linux-2.6/xfs_sync.c  |   42 +------
 fs/xfs/xfs_fsops.c           |   31 +++--
 fs/xfs/xfs_fsops.h           |    2 +-
 fs/xfs/xfs_ialloc.c          |   16 ++-
 fs/xfs/xfs_inode.c           |   49 ++++----
 fs/xfs/xfs_log.c             |    7 +-
 fs/xfs/xfs_log_cil.c         |  263 +++++++++++++++++++++++++-----------------
 fs/xfs/xfs_log_priv.h        |   13 ++-
 fs/xfs/xfs_trans.c           |    5 +-
 fs/xfs/xfs_trans_priv.h      |    3 +-
 mm/page-writeback.c          |   26 ++---
 13 files changed, 261 insertions(+), 218 deletions(-)

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
