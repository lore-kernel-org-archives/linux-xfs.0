Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAHGhxgY029542 for <xfs@oss.sgi.com>; Sat, 17 Nov 2012 10:43:59 -0600
Subject: [GIT PULL] XFS update for 3.7-rc7
Message-Id: <20121117164602.EFAF74266DC@whiskey.americas.sgi.com>
Date: Sat, 17 Nov 2012 10:46:02 -0600 (CST)
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

   Please pull these 3 bug fixes for XFS.  This includes a fix for attribute
   corruption, a fix for error handling in xfs_vm_writepage, and a fix for
   reference counts on xfs_bufs.

Thanks,
	Ben

The following changes since commit 6ce377afd1755eae5c93410ca9a1121dfead7b87:

  xfs: fix reading of wrapped log data (2012-11-08 11:10:51 -0600)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.7-rc7

for you to fetch changes up to d69043c42d8c6414fa28ad18d99973aa6c1c2e24:

  xfs: drop buffer io reference when a bad bio is built (2012-11-17 09:36:57 -0600)

----------------------------------------------------------------
xfs: bugfixes for 3.7-rc7

- fix attr tree double split corruption
- fix broken error handling in xfs_vm_writepage
- drop buffer io reference when a bad bio is built

----------------------------------------------------------------
Dave Chinner (3):
      xfs: fix attr tree double split corruption
      xfs: fix broken error handling in xfs_vm_writepage
      xfs: drop buffer io reference when a bad bio is built

 fs/xfs/xfs_aops.c      | 54 ++++++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_attr_leaf.c | 20 +++++++++++++++++--
 fs/xfs/xfs_buf.c       | 14 +++++++++++--
 3 files changed, 69 insertions(+), 19 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
