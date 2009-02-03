Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n13H8NFU078644 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 11:08:23 -0600
Date: Tue, 03 Feb 2009 11:07:40 -0600
Subject: [GIT PULL] XFS update for 2.6.29-rc4
MIME-Version: 1.0
Message-Id: <20090203170740.538E91418C93B@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
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
Cc: akpm@linux-foundation.org, xfs@sgi.com, linux-kernel@vger.kernel.org

The following changes since commit b1792e367053968f2ddb48bc911d314143ce6242:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/pci-2.6

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (1):
      xfs: Check buffer lengths in log recovery

Eric Sandeen (1):
      don't reallocate sxp variable passed into xfs_swapext

Felix Blyakher (2):
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6 into for-linus
      [XFS] Warn on transaction in flight on read-only remount

 fs/xfs/linux-2.6/xfs_sync.c |    6 +++++-
 fs/xfs/xfs_dfrag.c          |   10 +---------
 fs/xfs/xfs_log_recover.c    |   31 +++++++++++++++++++++++++------
 3 files changed, 31 insertions(+), 16 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
