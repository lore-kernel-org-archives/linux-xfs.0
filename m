Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6S8S6n5246845 for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 03:28:06 -0500
Received: from mort.rzone.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C2809E388
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 01:28:04 -0700 (PDT)
Received: from mort.rzone.de (mort.rzone.de [81.169.144.234]) by cuda.sgi.com
	with ESMTP id y1gqnslYkS7okGMx for <xfs@oss.sgi.com>;
	Thu, 28 Jul 2011 01:28:04 -0700 (PDT)
From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH 0/4] xfstests: Add support for btrfs in a couple of xfstests
Date: Thu, 28 Jul 2011 10:27:57 +0200
Message-Id: <cover.1311776403.git.sbehrens@giantdisaster.de>
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

Added btrfs to the list of supported filesystems for tests 015, 062,
079, 083, 117, 120 and 192.
For test 079 to run, src/t_immutable.c was also modified (for ext2 and
btrfs filesystems).

Stefan Behrens (4):
  xfstests: Add support for btrfs in 062
  xfstests: Add support for btrfs in 083, 117, 120 and 192
  xfstests: Add support for btrfs in 015
  xfstests: Add support for btrfs in 079

 015               |   11 ++++++++---
 062               |    4 ++--
 062.out           |    6 ------
 079               |    4 ++--
 083               |   12 +++++++++---
 117               |    4 ++--
 120               |    4 ++--
 192               |    2 +-
 src/t_immutable.c |   23 +++++++++++++++--------
 9 files changed, 41 insertions(+), 29 deletions(-)

-- 
1.7.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
