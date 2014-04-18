Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 660E47F52
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 19:16:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 498018F8035
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 17:15:58 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	KOsdRiMLt1sGxdEM for <xfs@oss.sgi.com>;
	Thu, 17 Apr 2014 17:15:56 -0700 (PDT)
Date: Fri, 18 Apr 2014 10:15:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: fixes for 3.15-rc2
Message-ID: <20140418001552.GZ15995@dastard>
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

Can you please pull the updates listed below? The fixes are for data
corruption issues, memory corruption and regressions for changes
merged in -rc1. More detail is in the tag below.

FYI, there have been some recent problems with oss.sgi.com resetting
connections on git pulls. Hopefully that has been resolved, but if
you have problems pulling the changes please let me know.

-Dave.

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-3.15-rc2

for you to fetch changes up to 330033d697ed8d296fa52b5303db9d802ad901cc:

  xfs: fix tmpfile/selinux deadlock and initialize security (2014-04-17 08:15:30 +1000)

----------------------------------------------------------------
xfs: bug fixes for 3.15-rc2

Data corruption fixes:
- fix a bunch of delayed allocation state mismatches
- fix collapse/zero range bugs
- fix a direct IO block mapping bug @ EOF

Other fixes:
- fix a use after free on metadata IO error
- fix a use after free on IO error during unmount
- fix an incorrect error sign on direct IO write errors
- add missing O_TMPFILE inode security context initialisation

----------------------------------------------------------------
Brian Foster (1):
      xfs: fix tmpfile/selinux deadlock and initialize security

Dave Chinner (8):
      xfs: kill buffers over failed write ranges properly
      xfs: write failure beyond EOF truncates too much data
      xfs: xfs_vm_write_end truncates too much on failure
      xfs: zeroing space needs to punch delalloc blocks
      xfs: don't map ranges that span EOF for direct IO
      xfs: collapse range is delalloc challenged
      xfs: unmount does not wait for shutdown during unmount
      xfs: wrong error sign conversion during failed DIO writes

Eric Sandeen (1):
      xfs: fix buffer use after free on IO error

 fs/xfs/xfs_aops.c      |   51 ++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_bmap.c      |   17 ++++++++++------
 fs/xfs/xfs_bmap_util.c |   13 +++++++++++-
 fs/xfs/xfs_buf.c       |   16 +++++++++++----
 fs/xfs/xfs_file.c      |    2 +-
 fs/xfs/xfs_inode.c     |    5 +++--
 fs/xfs/xfs_inode.h     |    2 +-
 fs/xfs/xfs_iops.c      |   20 +++++++++++++++---
 fs/xfs/xfs_log.c       |   53 ++++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_trace.h     |    1 +
 10 files changed, 147 insertions(+), 33 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
