Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5RE104P110194 for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 09:01:00 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201106271400.p5RE0u38026164@stout.americas.sgi.com>
Date: Mon, 27 Jun 2011 09:00:56 -0500
Subject: [GIT PULL] XFS update for 3.0-rc5
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

Linus, please pull the following three XFS changes for 3.0-rc5:
- The first fixes a problem where certain XFS inode fields were
  not getting re-initialized when they were recycled.
- The second ensures a flag related to speculatively preallocating
  space beyond EOF gets reset when a file is truncated.
- The third properly sets a flag indicating that a lookup failure
  is allowed for user-supplied attribute names.  This was causing
  a failed assertion when running a test that attempts to remove
  a non-existent selinux-related attribute.

Thank you.

  					-Alex

The following changes since commit 258e43fdb00c73d424b114ae3850accd55b27cbb:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6 (2011-06-26 19:40:31 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (3):
      xfs: reset inode per-lifetime state when recycling it
      xfs: clear XFS_IDIRTY_RELEASE on truncate down
      xfs: prevent bogus assert when trying to remove non-existent attribute

 fs/xfs/xfs_attr.c     |    7 +++++++
 fs/xfs/xfs_iget.c     |   13 +++++++++----
 fs/xfs/xfs_inode.h    |   10 ++++++++++
 fs/xfs/xfs_vnodeops.c |    7 +++++--
 4 files changed, 31 insertions(+), 6 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
