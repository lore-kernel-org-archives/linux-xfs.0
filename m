Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1NFvCkI069361 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 09:57:12 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201102231559.p1NFxrcj011362@stout.americas.sgi.com>
Date: Wed, 23 Feb 2011 09:59:53 -0600
Subject: [GIT PULL] XFS update for 2.6.38-rc7
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

Linus, please pull the following two minor changes for XFS.  One
fixes a security problem (kernel stack leak to user space) and the
other ensures an unsupported operation can be distinguished from a 
supported but not operative one.  Thanks.

					-Alex

The following changes since commit 4a508dd259f5995b8d31c576b894263f5947d654:

  Merge branch 'for-2639-rc4/i2c-fixes' of git://git.fluff.org/bjdooks/linux (2011-02-22 17:13:16 -0800)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dan Rosenberg (1):
      xfs: prevent leaking uninitialized stack memory in FSGEOMETRY_V1

Lukas Czerner (1):
      xfs: check if device support discard in xfs_ioc_trim()

 fs/xfs/linux-2.6/xfs_discard.c |    2 ++
 fs/xfs/xfs_fsops.c             |    3 +++
 2 files changed, 5 insertions(+), 0 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
