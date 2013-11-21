Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8E1257F37
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 10:44:03 -0600 (CST)
Subject: [GIT PULL] XFS update #2 for 3.13-rc1
Message-Id: <20131121164359.EA9BD4266DC@whiskey.americas.sgi.com>
Date: Thu, 21 Nov 2013 10:43:59 -0600 (CST)
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

   Please pull this xfs update for 3.13-rc1.  There are a couple of patches
   that I wasn't quite sure about in time for our initial 3.13 pull request, a
   bugfix, and an update to add Dave to MAINTAINERS.

Thanks,
	Ben

The following changes since commit 359d992bcd398273637cd9edde10afca953783c4:

  xfs: simplify kmem_{zone_}zalloc (2013-11-06 16:31:27 -0600)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-v3.13-rc1-2

for you to fetch changes up to 2fe8c1c08b3fbd87dd2641c8f032ff6e965d5803:

  xfs: open code inc_inode_iversion when logging an inode (2013-11-18 09:42:08 -0600)

----------------------------------------------------------------
xfs: update #2 for v3.13-rc1

Here we have a performance fix for inode iversion, increased inode cluster size
for v5 superblock filesystems, a fix for error handling in
xfs_bmap_add_attrfork, and a MAINTAINERS update to add Dave.

----------------------------------------------------------------
Ben Myers (1):
      xfs: update maintainers

Dave Chinner (2):
      xfs: increase inode cluster size for v5 filesystems
      xfs: open code inc_inode_iversion when logging an inode

Mark Tinguely (1):
      xfs: fix unlock in xfs_bmap_add_attrfork

 MAINTAINERS              |  2 +-
 fs/xfs/xfs_bmap.c        | 38 +++++++++++++++++++++-----------------
 fs/xfs/xfs_mount.c       | 15 +++++++++++++++
 fs/xfs/xfs_mount.h       |  2 +-
 fs/xfs/xfs_trans_inode.c |  8 +++++---
 fs/xfs/xfs_trans_resv.c  |  3 +--
 6 files changed, 44 insertions(+), 24 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
