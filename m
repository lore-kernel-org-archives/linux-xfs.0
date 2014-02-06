Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0FC797F51
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 11:32:02 -0600 (CST)
Subject: [GIT PULL] XFS fix for 3.14-rc2
Message-Id: <20140206173158.6A2A14266DC@whiskey.americas.sgi.com>
Date: Thu,  6 Feb 2014 11:31:58 -0600 (CST)
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

   Please pull this xfs update for 3.14.  This is to allow logical sector sized
   direct io on advanced format disks.  Eric expressed a desire to get this fix
   in 3.14 because this bug affects some virtualization packages.

Thanks,
	Ben

The following changes since commit bf3964c188d686424ff7b69a45941851b9f437f0:

  Merge branch 'xfs-extent-list-locking-fixes' into for-next (2014-01-09 16:03:18 -0600)

are available in the git repository at:


  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-v3.14-rc1-2

for you to fetch changes up to 7c71ee78031c248dca13fc94dea9a4cc217db6cf:

  xfs: allow logical-sector sized O_DIRECT (2014-01-24 11:55:42 -0600)

----------------------------------------------------------------
xfs: update #2 for v3.14-rc1

- allow logical sector sized direct io on 'advanced format' 4k/512 disk.

----------------------------------------------------------------
Eric Sandeen (3):
      xfs: clean up xfs_buftarg
      xfs: rename xfs_buftarg structure members
      xfs: allow logical-sector sized O_DIRECT

 fs/xfs/xfs_buf.c   | 14 +++++++++-----
 fs/xfs/xfs_buf.h   | 20 +++++++++++++++++---
 fs/xfs/xfs_file.c  |  7 +++++--
 fs/xfs/xfs_ioctl.c |  2 +-
 4 files changed, 32 insertions(+), 11 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
