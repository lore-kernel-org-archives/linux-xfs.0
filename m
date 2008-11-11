Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Nov 2008 19:58:24 -0800 (PST)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAB3wCJR012054
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2008 19:58:14 -0800
Date: Tue, 11 Nov 2008 14:58:05 +1100
Subject: [GIT PULL] XFS update for 2.6.28
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081111035805.EEC4B58FA24A@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

This pull request is a little more conservative than the last one!  Just
critical bug fixes this time.

The following changes since commit 3ad4f597058301c97f362e500a32f63f5c950a45:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../tiwai/sound-2.6

are available in the git repository at:

  git://oss.sgi.com:8090/xfs/xfs for-linus

Dave Chinner (1):
      [XFS] handle memory allocation failures during log initialisation

David Chinner (2):
      [XFS] Account for allocated blocks when expanding directories
      [XFS] XFS: Check for valid transaction headers in recovery

Lachlan McIlroy (2):
      [XFS] Fix use-after-free with log and quotas
      [XFS] Wait for all I/O on truncate to zero file size

 fs/xfs/xfs_da_btree.c    |    5 +++++
 fs/xfs/xfs_dir2.c        |    6 ++++++
 fs/xfs/xfs_inode.c       |    2 +-
 fs/xfs/xfs_log.c         |   39 ++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_log_recover.c |    8 +++++++-
 fs/xfs/xfs_mount.c       |    5 +++--
 6 files changed, 58 insertions(+), 7 deletions(-)
