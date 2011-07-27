Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6RKZ011220135 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 15:35:00 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201107272034.p6RKYtnq013266@stout.americas.sgi.com>
Date: Wed, 27 Jul 2011 15:34:55 -0500
Subject: [GIT PULL] XFS update 2 for 3.1-rc1
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

Here are a few more commits for XFS for Linux 3.1-rc1.	-Alex

The following changes since commit 5fd00b031530cc476240f654c078c930f1dcd6ea:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6 (2011-07-27 09:26:39 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      xfs: encapsulate a block of debug code

Christoph Hellwig (3):
      xfs: flag all buffers as metadata
      xfs: prevent against ioend livelocks in xfs_file_fsync
      xfs: optimize the negative xattr caching

 fs/xfs/linux-2.6/xfs_buf.c  |    3 +++
 fs/xfs/linux-2.6/xfs_file.c |    2 ++
 fs/xfs/linux-2.6/xfs_iops.c |    9 +++++++--
 fs/xfs/xfs_da_btree.c       |   32 +++++++++++++++++++++-----------
 4 files changed, 33 insertions(+), 13 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
