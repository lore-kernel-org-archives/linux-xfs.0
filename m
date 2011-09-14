Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8EK2FRD158539 for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 15:02:15 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201109142002.p8EK29TA027782@stout.americas.sgi.com>
Date: Wed, 14 Sep 2011 15:02:09 -0500
Subject: [GIT PULL] XFS update for 3.1-rc7
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

Linus, please pull the following XFS fix in for 3.1-rc7.  It
addresses a use-after-free problem that is due to code that
went in to 3.1-rc1 (commit 72c5052d).

The repository is the same as has always been used for XFS at
oss.sgi.com.

Thanks.

					-Alex

The following changes since commit 003f6c9df54970d8b19578d195b3e2b398cdbde2:

  lib/sha1.c: quiet sparse noise about symbol not declared (2011-09-13 16:09:41 -0700)

are available in the git repository at:
  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (1):
      xfs: fix a use after free in xfs_end_io_direct_write

 fs/xfs/xfs_aops.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
