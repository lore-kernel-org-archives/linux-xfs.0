Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Sep 2008 00:57:34 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8I7vUE6025840
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2008 00:57:31 -0700
Date: Thu, 18 Sep 2008 17:58:59 +1000
Subject: [GIT PULL] XFS update for 2.6.27
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080918075859.BDE0D58C52AE@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

The following changes since commit 45e9c0de2e86485f8b6633fd64ab19cfbff167f6:
  Arjan van de Ven (1):
        warn: Turn the netdev timeout WARN_ON() into a WARN()

are available in the git repository at:

  git://oss.sgi.com:8090/xfs/linux-2.6 master

Christoph Hellwig (1):
      [XFS] Fix regression introduced by remount fixup

David Chinner (2):
      [XFS] Fix barrier status change detection.
      [XFS] Prevent lockdep false positives when locking two inodes.

Lachlan McIlroy (4):
      [XFS] Move memory allocations for log tracing out of the critical path
      [XFS] Prevent direct I/O from mapping extents beyond eof
      [XFS] Fix use-after-free with buffers
      [XFS] Don't do I/O beyond eof when unreserving space

 fs/xfs/linux-2.6/xfs_aops.c  |    4 +++
 fs/xfs/linux-2.6/xfs_super.c |   20 +++++++++++++
 fs/xfs/xfs_buf_item.c        |   44 +++++++++++++----------------
 fs/xfs/xfs_dfrag.c           |    9 +++++-
 fs/xfs/xfs_log.c             |   62 +++++++++++++++++++++++++++--------------
 fs/xfs/xfs_log_priv.h        |    1 -
 fs/xfs/xfs_vnodeops.c        |   26 +++++++++++++++++
 7 files changed, 119 insertions(+), 47 deletions(-)
