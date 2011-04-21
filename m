Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LG5npo164676 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 11:05:49 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201104211609.p3LG9D9n013300@stout.americas.sgi.com>
Date: Thu, 21 Apr 2011 11:09:13 -0500
Subject: [GIT PULL] XFS update for 2.6.39-rc5
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

Linus, please pull the following commit for XFS.  It fixes a
regression that went in to 2.6.39-rc1.  It's a simple problem,
but its consequence (reusing a va_format pointer without
re-initializing it) is not good.  Thank you.

					-Alex


The following changes since commit 584f79046780e10cb24367a691f8c28398a00e84:

  Merge branch 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging (2011-04-20 18:18:19 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (1):
      xfs: fix duplicate message output

 fs/xfs/linux-2.6/xfs_message.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
