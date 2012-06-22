Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5MGbPo4070143 for <xfs@oss.sgi.com>; Fri, 22 Jun 2012 11:37:25 -0500
Subject: [GIT PULL] XFS update for 3.5-rc4
Message-Id: <20120622163804.3781F402055@whiskey.americas.sgi.com>
Date: Fri, 22 Jun 2012 11:38:04 -0500 (CDT)
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

   Please pull in these fixes for XFS for 3.5-rc4.  This includes:

   * Fix stale data exposure with unwritten extents
   * Fix a warning in xfs_alloc_vextent with ODEBUG
   * Fix overallocation and alignment of pages for xfs_bufs
   * Fix a cursor leak
   * Fix a log hang
   * Fix a crash related to xfs_sync_worker
   * Rename xfs log structure from struct log to struct xlog so we can
     use crash dumps effectively

   I thought I'd try a signed tag this time around.  My key ID is D5ABA64E:

   gpg --keyserver pgp.mit.edu --recv-keys D5ABA64E

   Hopefully I got it right.

Thanks,
Ben

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/for-linus-Jun-21-2012

for you to fetch changes up to f7bdf03a99efc083608cd9c0c3e03abff311c79e:

  xfs: rename log structure to xlog (2012-06-21 14:21:11 -0500)

----------------------------------------------------------------
Fixes for 3.5-rc

----------------------------------------------------------------
Alain Renaud (1):
      xfs: xfs_vm_writepage clear iomap_valid when !buffer_uptodate (REV2)

Ben Myers (1):
      xfs: shutdown xfs_sync_worker before the log

Brian Foster (1):
      xfs: check for stale inode before acquiring iflock on push

Dave Chinner (1):
      xfs: fix allocbt cursor leak in xfs_alloc_ag_vextent_near

Jan Kara (1):
      xfs: Fix overallocation in xfs_buf_allocate_memory()

Jeff Liu (1):
      xfs: fix debug_object WARN at xfs_alloc_vextent()

Mark Tinguely (1):
      xfs: rename log structure to xlog

 fs/xfs/xfs_alloc.c       |  3 +-
 fs/xfs/xfs_aops.c        | 11 +++++--
 fs/xfs/xfs_buf.c         | 16 ++--------
 fs/xfs/xfs_inode_item.c  | 17 +++++------
 fs/xfs/xfs_log.c         | 77 ++++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_log_cil.c     | 22 +++++++-------
 fs/xfs/xfs_log_priv.h    | 46 +++++++++++++++++++----------
 fs/xfs/xfs_log_recover.c | 38 ++++++++++++------------
 fs/xfs/xfs_mount.h       |  4 +--
 fs/xfs/xfs_sync.c        | 32 ++++++++++----------
 fs/xfs/xfs_trace.h       | 18 +++++------
 11 files changed, 153 insertions(+), 131 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
