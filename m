Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5HG8wal126441 for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 11:08:58 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201106171608.p5HG8qno030243@stout.americas.sgi.com>
Date: Fri, 17 Jun 2011 11:08:52 -0500
Subject: [GIT PULL] XFS update for 3.0-rc4
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

Linus, please pull the following two XFS changes for 3.0.

The first is a simple fix that flips the sign of an error return
value.

The second fixes a bug having to do with the order in which log and
data (or realtime) device cache flushes are issued.  This could lead
to data corruption when an external log was used.  Previously, we
avoided the problem by disabling barriers and issuing a warning
about that at mount time, but the recent barrier/FUA rework makes
that not work properly any more.  Fixing the flush ordering problem
also nicely eliminates the need a block of code.

Thanks.

					-Alex

The following changes since commit eb96c925152fc289311e5d7e956b919e9b60ab53:

  Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2011-06-16 17:54:41 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Al Viro (1):
      xfs: fix ->mknod() return value on xfs_get_acl() failure

Christoph Hellwig (1):
      xfs: make log devices with write back caches work

 fs/xfs/linux-2.6/xfs_file.c  |   50 +++++++++++++++++----------
 fs/xfs/linux-2.6/xfs_iops.c  |    2 +-
 fs/xfs/linux-2.6/xfs_super.c |   75 ------------------------------------------
 fs/xfs/xfs_log.c             |   11 +++++-
 4 files changed, 42 insertions(+), 96 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
