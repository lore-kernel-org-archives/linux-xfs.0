Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBTHVCNU019991 for <xfs@oss.sgi.com>; Thu, 29 Dec 2011 11:31:12 -0600
Date: Thu, 29 Dec 2011 11:31:39 -0600
From: Ben Myers <bpm@sgi.com>
Subject: [GIT PULL] XFS update for 3.2
Message-ID: <20111229173139.GL21646@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

Please pull the following fixes for 3.2.  Quoting Christoph Hellwig:
"These two small fixes fix issues with periodic metadata writeback and
sync not being able [to] write file size updates to disk in some cases."
These have not gone through -next because we have 3.3 work in the
oss/master branch right now, but they merged and built cleanly on
3.2-rc7.  They have been tested thoroughly by Mark Tinguely and myself.
It is late in the cycle and I will submit them later for 3.2-stable if
you prefer.

Have a happy New Year!

Thanks,
       Ben

The following changes since commit 371de6e4e0042adf4f9b54c414154f57414ddd37:
  Keith Packard (1):
        drm/i915: Disable RC6 on Sandybridge by default

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (2):
      xfs: log the inode in ->write_inode calls for kupdate
      xfs: log all dirty inodes in xfs_fs_sync_fs

 fs/xfs/xfs_super.c |   30 +++++-------------------------
 fs/xfs/xfs_sync.c  |   36 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_sync.h  |    2 ++
 3 files changed, 43 insertions(+), 25 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
