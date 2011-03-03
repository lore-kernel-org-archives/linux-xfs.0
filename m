Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p23FWHW8098833 for <xfs@oss.sgi.com>; Thu, 3 Mar 2011 09:32:17 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201103031535.p23FZ1hI023122@stout.americas.sgi.com>
Date: Thu, 03 Mar 2011 09:35:00 -0600
Subject: [GIT PULL] XFS update for 2.6.38-rc8
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

> Regressions fixed, hopefully none introduced..

Sorry to report that one was introduced in XFS.  A caller was
providing the address of something smaller than what was expected
by a function that zeroed it, with a predictable result.

Please take the following change, which corrects the problem.
Thanks.

					-Alex

The following changes since commit cbdbb4c1d22e26f9d5314fefe6f2c7e5ed7f6a0f:

  Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2011-03-02 20:02:32 -0800)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      xfs: zero proper structure size for geometry calls

 fs/xfs/linux-2.6/xfs_ioctl.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
