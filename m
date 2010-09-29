Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8TH8Cjq068408 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 12:08:12 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201009291709.o8TH98Cf002604@stout.americas.sgi.com>
Date: Wed, 29 Sep 2010 12:09:07 -0500
Subject: [GIT PULL] XFS update for 2.6.36-rc7
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

Linus, please consider pulling the following change in XFS for
2.6.36.  It fixes a bug that could cause file system corruption in
the event of a crash when the new delayed logging functionality is
enabled.  I re-based and re-tested it this morning, but it was
subjected to additional testing previously.  Thanks.

					-Alex

The following changes since commit 899611ee7d373e5eeda08e9a8632684e1ebbbf00:

  Linux 2.6.36-rc6 (2010-09-28 18:01:22 -0700)

are available in the git repository at:
  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (1):
      xfs: force background CIL push under sustained load

 fs/xfs/xfs_log_cil.c  |   12 +++++++++---
 fs/xfs/xfs_log_priv.h |   37 +++++++++++++++++++++----------------
 2 files changed, 30 insertions(+), 19 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
