Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5D3777F56
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 16:23:30 -0500 (CDT)
Subject: [GIT PULL] XFS fix for 3.11-rc3
Message-Id: <20130725212326.D02C84266DC@whiskey.americas.sgi.com>
Date: Thu, 25 Jul 2013 16:23:26 -0500 (CDT)
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

Please pull this fix for XFS in 3.11-rc3.  This resolves a regression
introduced in the 3.11-rc1 merge window with commit cca9f93a52d2 which
results in recovery corrupting filesystems after crashes.

Thanks,
	Ben

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/for-linus-v3.11-rc3

for you to fetch changes up to e1b4271ac261b290fdab51446996fb13e68a57be:

  xfs: di_flushiter considered harmful (2013-07-25 10:41:42 -0500)

----------------------------------------------------------------
xfs: fix for 3.11-rc3

- fix for regression in commit cca9f93a52d2, recovery causing filesystem
  corruption after a crash

----------------------------------------------------------------
Dave Chinner (1):
      xfs: di_flushiter considered harmful

 fs/xfs/xfs_dinode.h      |  3 +++
 fs/xfs/xfs_inode.c       | 31 ++++++++++++++++++++++---------
 fs/xfs/xfs_log_recover.c | 13 +++++++++++--
 3 files changed, 36 insertions(+), 11 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
