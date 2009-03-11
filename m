Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2BLEI4t029915 for <xfs@oss.sgi.com>; Wed, 11 Mar 2009 16:14:38 -0500
Received: from attica.americas.sgi.com (attica.americas.sgi.com
	[128.162.236.44])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AE275304062
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2009 14:13:55 -0700 (PDT)
Date: Wed, 11 Mar 2009 16:04:55 -0500
Subject: [GIT PULL] XFS update for 2.6.29-rc8
MIME-Version: 1.0
Message-Id: <20090311210455.236A514167101@attica.americas.sgi.com>
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

The following changes since commit 559595a985e106d2fa9f0c79b7f5805453fed593:
  Linus Torvalds (1):
        Merge branch 'merge' of git://git.kernel.org/.../benh/powerpc

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (3):
      xfs: prevent kernel crash due to corrupted inode log format
      xfs: prevent lockdep false positive in xfs_iget_cache_miss
      xfs: only issues a cache flush on unmount if barriers are enabled

 fs/xfs/linux-2.6/xfs_buf.c   |   12 ++++++++++--
 fs/xfs/linux-2.6/xfs_buf.h   |    2 +-
 fs/xfs/linux-2.6/xfs_super.c |   10 +++++-----
 fs/xfs/xfs_iget.c            |   15 ++++++++++-----
 fs/xfs/xfs_log_recover.c     |   17 +++++++++++++----
 5 files changed, 39 insertions(+), 17 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
