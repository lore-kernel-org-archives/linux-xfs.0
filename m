Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3GLTnFA013025 for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 16:29:49 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201004162131.o3GLVgZQ026576@stout.americas.sgi.com>
Date: Fri, 16 Apr 2010 16:31:42 -0500
Subject: [GIT PULL] XFS update for 2.6.34-rc5
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

Please pull these two changes for 2.6.34-rc5.	-Alex

The following changes since commit dc57da3875f527b1cc195ea4ce5bd32e1e68433d:
  Linus Torvalds (1):
        Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (2):
      xfs: ensure that sync updates the log tail correctly
      xfs: don't warn on EAGAIN in inode reclaim

 fs/xfs/linux-2.6/xfs_sync.c |    4 ++--
 fs/xfs/xfs_log.c            |   38 ++++++++++++++++++++++++++------------
 2 files changed, 28 insertions(+), 14 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
