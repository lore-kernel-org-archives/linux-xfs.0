Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C7E7E29DF7
	for <xfs@oss.sgi.com>; Thu, 26 Feb 2015 19:56:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B67968F8039
	for <xfs@oss.sgi.com>; Thu, 26 Feb 2015 17:56:11 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	SOAbSH542UuBdCB4 for <xfs@oss.sgi.com>;
	Thu, 26 Feb 2015 17:56:06 -0800 (PST)
Date: Fri, 27 Feb 2015 12:56:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: updates for v4.0-rc2
Message-ID: <20150227015603.GH18360@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

Can you please pull the updates from the tree below? These are fixes
for regressions/bugs introduced in the 4.0 merge cycle and problems
discovered during the merge window that need to be pushed back to
stable kernels ASAP.

Thanks in advance!

-Dave.

The following changes since commit c517d838eb7d07bbe9507871fab3931deccff539:

  Linux 4.0-rc1 (2015-02-22 18:21:14 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-for-linus-4.0-rc2

for you to fetch changes up to 83d5f01858b56db69c8e4ca5389ef7c29bfdb5dd:

  xfs: cancel failed transaction in xfs_fs_commit_blocks() (2015-02-24 10:15:18 +1100)

----------------------------------------------------------------
xfs: fixes for v4.0-rc2

This update contains:
o ensure quota type is reset in on-disk dquots
o fix missing partial EOF block data flush on truncate extension
o fix transaction leak in error handling for new pnfs block layout
  support
o add missing target_ip check to RENAME_EXCHANGE

----------------------------------------------------------------
Dave Chinner (1):
      xfs: ensure truncate forces zeroed blocks to disk

Eric Sandeen (2):
      xfs: Ensure we have target_ip for RENAME_EXCHANGE
      xfs: cancel failed transaction in xfs_fs_commit_blocks()

Jan Kara (1):
      xfs: Fix quota type in quota structures when reusing quota file

 fs/xfs/xfs_file.c  |   14 ++++++++++----
 fs/xfs/xfs_inode.c |    4 ++++
 fs/xfs/xfs_inode.h |    9 +++++----
 fs/xfs/xfs_iops.c  |   36 ++++++++++++++----------------------
 fs/xfs/xfs_pnfs.c  |    4 +++-
 fs/xfs/xfs_qm.c    |    5 +++++
 6 files changed, 41 insertions(+), 31 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
