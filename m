Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1NMieGY161434 for <xfs@oss.sgi.com>; Thu, 23 Feb 2012 16:44:41 -0600
Subject: [GIT PULL] XFS update for 3.3
Message-Id: <20120223224444.5F139426DA7@whiskey.americas.sgi.com>
Date: Thu, 23 Feb 2012 16:44:44 -0600 (CST)
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

   Please pull the following three bugfixes for xfs in 3.3:

   A fix from Jesper Juhl removes an assignment in an ASSERT when a compare is
   intended.  Two fixes from Mitsuo Hayasaka address off-by-ones in XFS quota
   enforcement.

Thanks,
   Ben

The following changes since commit 45196cee28a5bcfb6ddbe2bffa4270cbed66ae4b:
  Linus Torvalds (1):
        Merge tag 'usb-3.3-rc4' of git://git.kernel.org/.../gregkh/usb

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Jesper Juhl (1):
      XFS: xfs_trans_add_item() - don't assign in ASSERT() when compare is intended

Mitsuo Hayasaka (2):
      xfs: change available ranges of softlimit and hardlimit in quota check
      xfs: make inode quota check more general

 fs/xfs/xfs_dquot.c       |   24 ++++++++++++------------
 fs/xfs/xfs_log_recover.c |    6 +++---
 fs/xfs/xfs_qm_syscalls.c |    4 ++--
 fs/xfs/xfs_trans.c       |    4 ++--
 fs/xfs/xfs_trans_dquot.c |   10 ++++++----
 5 files changed, 25 insertions(+), 23 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
