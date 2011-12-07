Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB7N7uNv118337 for <xfs@oss.sgi.com>; Wed, 7 Dec 2011 17:07:56 -0600
Subject: [GIT PULL] XFS update for 3.2
Message-Id: <20111207230819.37403426DA7@whiskey.americas.sgi.com>
Date: Wed,  7 Dec 2011 17:08:19 -0600 (CST)
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

Please pull the following fixes for XFS for 3.2.

a99ebf4 fixes an overflow when converting allocation length to extent length,

c29f7d4 fixes export of 64 bit inode numbers on 32 bit kernels, and

9f9c19e fixes a log hang due to a race when granting log space.  It was
debugged and tested thoroughly by Chandra Seetharaman <sekharan@us.ibm.com>.

Thanks,
	Ben

The following changes since commit 77a7300abad7fe01891b400e88d746f97307ee5a:
  Anton Vorontsov (1):
        of/irq: Get rid of NO_IRQ usage

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (2):
      xfs: fix nfs export of 64-bit inodes numbers on 32-bit kernels
      xfs: fix the logspace waiting algorithm

Dave Chinner (1):
      xfs: fix allocation length overflow in xfs_bmapi_write()

 fs/xfs/xfs_bmap.c   |   20 +++-
 fs/xfs/xfs_export.c |    8 +-
 fs/xfs/xfs_log.c    |  348 +++++++++++++++++++++++++--------------------------
 fs/xfs/xfs_trace.h  |   12 +--
 4 files changed, 200 insertions(+), 188 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
