Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9DFYGEY188591 for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 10:34:16 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201110131534.p9DFYAgh032034@stout.americas.sgi.com>
Date: Thu, 13 Oct 2011 10:34:10 -0500
Subject: [GIT PULL] XFS update for 3.1
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

Linus, please pull the following XFS changes for Linux 3.1.

In trying to track down the source of an XFS hang related to active
item pushing Christoph Hellwig identified three contributing
problems, addressed in the commits below.
- The first was that a "last pushed log sequence number" value was
  being updated when it should not have been.
- The second is that it is possible for a buffer containing inodes
  to be found pinned at the time it gets pushed, and that could
  cause pushing to stall.
- The third is related to the switch to using a workqueue for AIL
  pushing, which made it possible for pushing to get starved behind
  syncing activity.  At this late point in the cycle, the best
  course of action was to revert to using a kernel thread as was
  done previously.
The last change is simply adding tracepoints; feel free to exclude
it if you see fit.

These changes have not been through a linux-next build; portions of
them are incompatible with the XFS code that's being included there.
I have done builds and repeated tests with them however and expect
no problems.

Thank you.

					-Alex

The following changes since commit 65112dccf8a113737684366349d7f9ec373ddc47:

  Merge git://git.samba.org/sfrench/cifs-2.6 (2011-10-10 14:53:11 +1200)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (4):
      xfs: do not update xa_last_pushed_lsn for locked items
      xfs: force the log if we encounter pinned buffers in .iop_pushbuf
      xfs: revert to using a kthread for AIL pushing
      xfs: add AIL pushing tracepoints

 fs/xfs/xfs_buf_item.c   |    3 +-
 fs/xfs/xfs_dquot_item.c |   10 ++++--
 fs/xfs/xfs_inode_item.c |   10 ++++--
 fs/xfs/xfs_linux.h      |    2 +
 fs/xfs/xfs_super.c      |   13 +------
 fs/xfs/xfs_trace.h      |   37 +++++++++++++++++++
 fs/xfs/xfs_trans.h      |    2 +-
 fs/xfs/xfs_trans_ail.c  |   91 +++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_trans_priv.h |    8 +----
 9 files changed, 114 insertions(+), 62 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
