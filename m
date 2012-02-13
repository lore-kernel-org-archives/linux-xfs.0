Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DI6S9X029637 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 12:06:28 -0600
Subject: [GIT PULL] XFS update for 3.3
Message-Id: <20120213180629.527D4426DA7@whiskey.americas.sgi.com>
Date: Mon, 13 Feb 2012 12:06:29 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
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
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

   Please pull the following two bugfixes in XFS for 3.3.  One fix passes
   KMEM_SLEEP to kmem_realloc instead of 0, and the other resolves a possible
   deadlock in xfs quotas.

Thanks,
	Ben

The following changes since commit 612b8507c5d545feed2437b3d2239929cac7688d:
  Linus Torvalds (1):
        Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (1):
      xfs: use a normal shrinker for the dquot freelist

Mitsuo Hayasaka (1):
      xfs: pass KM_SLEEP flag to kmem_realloc() in xlog_recover_add_to_cnt_trans()

 fs/xfs/kmem.h            |    6 -
 fs/xfs/xfs_dquot.c       |  103 ++++------------
 fs/xfs/xfs_log_recover.c |    2 +-
 fs/xfs/xfs_qm.c          |  291 ++++++++++++++++++----------------------------
 fs/xfs/xfs_qm.h          |   14 ---
 fs/xfs/xfs_qm_stats.c    |    4 +-
 fs/xfs/xfs_trace.h       |    5 +-
 7 files changed, 142 insertions(+), 283 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
