Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p71AVNUr262009 for <xfs@oss.sgi.com>; Mon, 1 Aug 2011 05:31:23 -0500
Received: from mort.rzone.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85C162B91AB
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2011 03:31:21 -0700 (PDT)
Received: from mort.rzone.de (mort.rzone.de [81.169.144.234]) by cuda.sgi.com
	with ESMTP id mPIAg5EMiW8mf15H for <xfs@oss.sgi.com>;
	Mon, 01 Aug 2011 03:31:21 -0700 (PDT)
From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH v3 0/2] xfstests: Changed a couple of tests to be generic
Date: Mon,  1 Aug 2011 12:31:18 +0200
Message-Id: <cover.1312193821.git.sbehrens@giantdisaster.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Changes v2->v3:
- Merged 3 patches into one.
- Less verbose subject lines.

Changes v1->v2:
- Instead of just adding btrfs to the list of supported filesystems,
  the 7 tests that are touched by this patch series are now executed
  for all filesystems (since the tests are generic ones).
- The changes in src/t_immutable.c are revised to make the setting
  of append-only and immutable flags generic instead of just adding
  code for btrfs.

This patch series changes the tests 015, 062, 079, 083, 117, 120 and
192 to be generic for all filesystems and to be executed for all
filesystems.
For test 079 to run, src/t_immutable.c was also modified to use the
new generic FS_IOC_SETFLAGS/FS_IOC_GETFLAGS ioctl() if they are
available.

Stefan Behrens (2):
  xfstests: make more tests generic
  xfstests: make t_immutable and 079 filesystem-agnostic

 015               |    5 ++-
 062               |    4 +-
 062.out           |    6 -----
 079               |   12 +++++++--
 083               |   12 +++++++--
 117               |    4 +-
 120               |    4 +-
 192               |    2 +-
 src/t_immutable.c |   66 +++++++++++++++++-----------------------------------
 9 files changed, 50 insertions(+), 65 deletions(-)

-- 
1.7.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
