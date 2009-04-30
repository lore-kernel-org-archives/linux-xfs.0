Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3U5WJrf209916 for <xfs@oss.sgi.com>; Thu, 30 Apr 2009 00:32:19 -0500
Date: Thu, 30 Apr 2009 00:32:16 -0500
Subject: [GIT PULL] XFS update for 2.6.30-rc5
MIME-Version: 1.0
Message-Id: <20090430053216.2C65CA1FAB9F@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
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

The following changes since commit 091438dd5668396328a3419abcbc6591159eb8d1:
  Linus Torvalds (1):
        Linux 2.6.30-rc4

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (2):
      xfs: a couple getbmap cleanups
      xfs: fix getbmap vs mmap deadlock

Lachlan McIlroy (1):
      xfs_file_last_byte() needs to acquire ilock

Olaf Weber (1):
      xfs: add more checks to superblock validation

 fs/xfs/xfs_bmap.c  |  192 ++++++++++++++++++++++++++++------------------------
 fs/xfs/xfs_inode.c |    2 +
 fs/xfs/xfs_mount.c |    3 +
 3 files changed, 108 insertions(+), 89 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
