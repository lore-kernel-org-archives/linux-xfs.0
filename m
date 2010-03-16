Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2GNVmVX217501 for <xfs@oss.sgi.com>; Tue, 16 Mar 2010 18:31:48 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201003162333.o2GNXIvb022464@stout.americas.sgi.com>
Date: Tue, 16 Mar 2010 18:33:17 -0500
Subject: [GIT PULL] XFS update for 2.6.34-rc1
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

I hope you'll accept the following for 2.6.34-rc3, if not -rc2.

The first two are patches I neglected to include in my first batch
for 2.6.34.  The second is minor, but gets rid of some bogus warning
messages in the event of a forced shutdown.

					-Alex

The following changes since commit 57d54889cd00db2752994b389ba714138652e60c:
  Linus Torvalds (1):
        Linux 2.6.34-rc1

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (2):
      xfs: remove old vmap cache
      xfs: use scalable vmap API

Dave Chinner (1):
      xfs: don't warn about page discards on shutdown

 fs/xfs/linux-2.6/xfs_aops.c |   13 +++++--
 fs/xfs/linux-2.6/xfs_buf.c  |   81 ++----------------------------------------
 2 files changed, 14 insertions(+), 80 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
