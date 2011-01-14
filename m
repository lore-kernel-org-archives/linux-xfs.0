Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ELuLiu096059 for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 15:56:21 -0600
Date: Fri, 14 Jan 2011 15:58:26 -0600
From: Alex Elder <aelder@americas.sgi.com>
Message-Id: <201101142158.p0ELwQG3010869@alcatraz.americas.sgi.com>
Subject: [GIT PULL] XFS update 2 for 2.6.38-rc1
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

Linus, please pull the following additional changes to XFS for
2.6.38-rc1.  Thanks.

					-Alex

The following changes since commit 52cfd503ad7176d23a5dd7af3981744feb60622f:

  Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6 (2011-01-13 20:15:35 -0800)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Anton Blanchard (1):
      xfs: Add log level to assertion printk

Christoph Hellwig (2):
      xfs: add FITRIM support
      xfs: fix error handling for synchronous writes

Dave Chinner (10):
      xfs: ensure sync write errors are returned
      xfs: factor common post-write isize handling code
      xfs: factor post-write newsize updates
      xfs: introduce xfs_rw_lock() helpers for locking the inode
      xfs: split direct IO write path from xfs_file_aio_write
      xfs: split buffered IO write path from xfs_file_aio_write
      xfs: factor common write setup code
      xfs: serialise unaligned direct IOs
      xfs: ensure log covering transactions are synchronous
      xfs: prevent NMI timeouts in cmn_err

Jesper Juhl (1):
      xfs: fix an assignment within an ASSERT()

 fs/xfs/Makefile                |    1 +
 fs/xfs/linux-2.6/xfs_buf.c     |    7 +-
 fs/xfs/linux-2.6/xfs_buf.h     |    7 +-
 fs/xfs/linux-2.6/xfs_discard.c |  191 ++++++++++++++
 fs/xfs/linux-2.6/xfs_discard.h |    8 +
 fs/xfs/linux-2.6/xfs_file.c    |  535 +++++++++++++++++++++++-----------------
 fs/xfs/linux-2.6/xfs_ioctl.c   |    3 +
 fs/xfs/linux-2.6/xfs_super.c   |    2 +-
 fs/xfs/linux-2.6/xfs_sync.c    |   11 +-
 fs/xfs/linux-2.6/xfs_sysctl.c  |   23 ++-
 fs/xfs/linux-2.6/xfs_trace.h   |   33 +++
 fs/xfs/support/debug.c         |  112 ++++-----
 fs/xfs/support/debug.h         |   25 ++-
 fs/xfs/xfs_alloc.c             |   10 +-
 fs/xfs/xfs_alloc.h             |   25 ++-
 fs/xfs/xfs_buf_item.c          |  151 ++++--------
 fs/xfs/xfs_error.c             |   31 ---
 fs/xfs/xfs_error.h             |   18 +-
 fs/xfs/xfs_fsops.c             |   10 +-
 fs/xfs/xfs_fsops.h             |    2 +-
 fs/xfs/xfs_log.c               |    2 +-
 fs/xfs/xfs_log_recover.c       |    2 +-
 fs/xfs/xfs_trans.c             |    2 +-
 23 files changed, 729 insertions(+), 482 deletions(-)
 create mode 100644 fs/xfs/linux-2.6/xfs_discard.c
 create mode 100644 fs/xfs/linux-2.6/xfs_discard.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
