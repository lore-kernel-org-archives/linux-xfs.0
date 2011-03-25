Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2PMYEmf260088 for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 17:34:14 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1E8837D686
	for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 15:37:20 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	TsYP3YJfeOcsdXeR for <xfs@oss.sgi.com>;
	Fri, 25 Mar 2011 15:37:20 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.72)
	(envelope-from <david@fromorbit.com>) id 1Q3Fd8-0004eN-Ls
	for xfs@oss.sgi.com; Sat, 26 Mar 2011 09:37:18 +1100
Date: Sat, 26 Mar 2011 09:37:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: more fixes for 2.6.39
Message-ID: <20110325223718.GP26611@dastard>
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


Hi Alex,

Here is the latest round of commits for 2.6.39 rady for you to pull.
It's based on the current xfs-oss master branch.

Cheers,

Dave.


The following changes since commit 0c9ba97318fc9a905bcc1419b6966de061203a70:

  xfs: don't name variables "panic" (2011-03-11 16:34:51 -0600)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git xfs-for-2.6.39

Dave Chinner (6):
      xfs: preallocation transactions do not need to be synchronous
      vmap: flush vmap aliases when mapping fails
      xfs: introduce inode cluster buffer trylocks for xfs_iflush
      xfs: xfs_trans_read_buf() should return an error on failure
      xfs: register the inode cache shrinker before quotachecks
      xfs: stop using the page cache to back the buffer cache

 fs/xfs/linux-2.6/xfs_buf.c   |  355 +++++++++++-------------------------------
 fs/xfs/linux-2.6/xfs_buf.h   |   40 +-----
 fs/xfs/linux-2.6/xfs_file.c  |    6 +-
 fs/xfs/linux-2.6/xfs_ioctl.c |    4 +
 fs/xfs/linux-2.6/xfs_super.c |   36 +++--
 fs/xfs/linux-2.6/xfs_sync.c  |   30 ++++-
 fs/xfs/xfs_inode.c           |    2 +-
 fs/xfs/xfs_inode_item.c      |    6 +-
 fs/xfs/xfs_trans_buf.c       |    3 +-
 fs/xfs/xfs_vnodeops.c        |    3 +-
 fs/xfs/xfs_vnodeops.h        |    1 +
 11 files changed, 165 insertions(+), 321 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
