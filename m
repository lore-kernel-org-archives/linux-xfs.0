Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB1NRmjS033776 for <xfs@oss.sgi.com>; Thu, 1 Dec 2011 17:27:48 -0600
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 0/6] XFS update for 3.1-stable (again)
Date: Thu,  1 Dec 2011 17:27:38 -0600
Message-Id: <1322782064-1723-1-git-send-email-bpm@sgi.com>
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
To: stable@vger.kernel.org, greg@kroah.com
Cc: bpm@sgi.com, xfs@oss.sgi.com

This is a series of XFS fixes from current mainline which is important for
3.1-stable.  Note that it is the same patch set that Christoph submitted for
3.0-stable, minus the first three patches which are already included in 3.1.

My QA came out ok with these six patches atop 3.1.y.  I've been having trouble
getting mail out to stable@vger, but it seems to be working now.  Apologies to
those who are getting this mail yet again.

Carlos Maiolino (1):
  xfs: Fix possible memory corruption in xfs_readlink

Christoph Hellwig (2):
  xfs: avoid direct I/O write vs buffered I/O race
  xfs: fix buffer flushing during unmount

Dave Chinner (1):
  xfs: don't serialise direct IO reads on page cache checks

Mitsuo Hayasaka (2):
  xfs: Return -EIO when xfs_vn_getattr() failed
  xfs: use doalloc flag in xfs_qm_dqattach_one()

 fs/xfs/xfs_buf.h      |    1 -
 fs/xfs/xfs_file.c     |   34 ++++++++++++++++++++++++++++------
 fs/xfs/xfs_iops.c     |    2 +-
 fs/xfs/xfs_mount.c    |   29 ++++++++++-------------------
 fs/xfs/xfs_qm.c       |    3 ++-
 fs/xfs/xfs_vnodeops.c |   14 ++++++++++----
 6 files changed, 51 insertions(+), 32 deletions(-)

-- 
1.7.8.rc4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
