Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2BE137F4E
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 14:04:39 -0500 (CDT)
Subject: [GIT PULL] XFS fixes for 3.12-rc4
Message-Id: <20131004190435.6C3E14266DC@whiskey.americas.sgi.com>
Date: Fri,  4 Oct 2013 14:04:35 -0500 (CDT)
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

   Please pull in these bugfixes for xfs.  There are lockdep annotations for
   project quotas, a fix for dirent dtype support on v4 filesystems, a fix for
   a memory leak in recovery, and a fix for the build error that resulted from
   it.  D'oh.

Thanks,
	Ben

The following changes since commit 997def25e4b9cee3b01609e18a52f926bca8bd2b:

  xfs: fix node forward in xfs_node_toosmall (2013-09-26 10:38:17 -0500)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-v3.12-rc4

for you to fetch changes up to b2a42f78ab475f4730300b0e9568bc3b2587d112:

  xfs: Use kmem_free() instead of free() (2013-10-04 13:56:12 -0500)

----------------------------------------------------------------
xfs: bugfixes for 3.12-rc4

- lockdep fix for project quotas
- fix for dirent dtype support on v4 filesystems
- fix for a memory leak in recovery
- fix for build failure due to the recovery fix

----------------------------------------------------------------
Dave Chinner (2):
      xfs: lockdep needs to know about 3 dquot-deep nesting
      xfs: dirent dtype presence is dependent on directory magic numbers

Thierry Reding (1):
      xfs: Use kmem_free() instead of free()

tinguely@sgi.com (1):
      xfs: fix memory leak in xlog_recover_add_to_trans

 fs/xfs/xfs_dir2_block.c   |  6 +++---
 fs/xfs/xfs_dir2_format.h  | 51 +++++++++++++++++++----------------------------
 fs/xfs/xfs_dir2_readdir.c |  4 ++--
 fs/xfs/xfs_dir2_sf.c      |  6 +++---
 fs/xfs/xfs_dquot.c        | 19 +++++++++++++++---
 fs/xfs/xfs_log_recover.c  |  1 +
 6 files changed, 45 insertions(+), 42 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
