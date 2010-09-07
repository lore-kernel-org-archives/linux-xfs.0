Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o87EojZQ246873 for <xfs@oss.sgi.com>; Tue, 7 Sep 2010 09:50:45 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201009071451.o87EpPVc014171@stout.americas.sgi.com>
Date: Tue, 07 Sep 2010 09:51:24 -0500
Subject: [GIT PULL] XFS update for 2.6.36-rc4
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Linus, please pull the following four XFS changes for 2.6.36.  Three
are bug fixes, one makes two simple changes to reduce the effect of
some hot spots on large systems.  Thanks.

					-Alex

The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:

  Linux 2.6.36-rc3 (2010-08-29 08:36:04 -0700)

are available in the git repository at:
  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      Merge branch '2.6.36-xfs-misc' of git://git.kernel.org/.../dgc/xfsdev

Arkadiusz Mi?kiewicz (1):
      xfs: Disallow 32bit project quota id

Dave Chinner (2):
      xfs: improve buffer cache hash scalability
      xfs: prevent 32bit overflow in space reservation

Tao Ma (1):
      xfs: Make fiemap work with sparse files

 fs/xfs/linux-2.6/xfs_buf.c   |    8 +-------
 fs/xfs/linux-2.6/xfs_buf.h   |    1 -
 fs/xfs/linux-2.6/xfs_ioctl.c |    7 +++++++
 fs/xfs/linux-2.6/xfs_iops.c  |    2 +-
 fs/xfs/xfs_bmap.c            |   14 +++++++++++++-
 fs/xfs/xfs_fs.h              |    4 +++-
 fs/xfs/xfs_vnodeops.c        |   13 ++++++++++---
 7 files changed, 35 insertions(+), 14 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
