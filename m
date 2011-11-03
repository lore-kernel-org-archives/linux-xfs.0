Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3EPPfi017874 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 09:25:25 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64CDD12FF47D
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 07:25:22 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id 11wVMVG7qZCYqpQd
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 07:25:22 -0700 (PDT)
Received: by bkbzs8 with SMTP id zs8so1398030bkb.26
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 07:25:22 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 00/12] Bunch of new stress tests -v4
Date: Thu,  3 Nov 2011 18:24:49 +0400
Message-Id: <1320330301-2682-1-git-send-email-dmonakhov@openvz.org>
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
To: linux-fsdevel@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, aelder@sgi.com, tytso@mit.edu, hch@lst.de, xfs@oss.sgi.com

Changes from v3 ( in request to  Christoph's comments)
 - hard code fsstress's options for explicit regression tests
 - add two new regression tests
Changes from v2 ( in request to  Christoph's comments)
 - rearange patch sequance
 - codestyle cleanups
 - give better description
 - add tunable mask for FS_IOC_SETFLAGS test.

LOG:
# Following patches improves fsstress logging,
# First three patches was already pulled by Chris to it's internal tree,
# but not push it to public tree yet
 xfstests: fsstress dump inode info when possible
 xfstests: add different logging option to fsstress
 xfstests: fsstress should kill children tasks before exit
# First patch add dump configuration in command line style, second use it's output
 xfstests: fsstress add command line style output for show_opts
 xfstests: freeze fsstress options for 117'th
# Following patches add new operations to fsstress.
 xfstests: add fallocate support to fsstress
 xfstests: fsstress add FS_IOC_{SET,GET}FLAGS operations v2
 xfstests: add fiemap operation to fsstress
# Following testcase may fail on recent kernel in case of ext4
# Some fixes are already available here:
#  http://www.spinics.net/lists/linux-ext4/msg27857.html
#  http://www.spinics.net/lists/linux-ext4/msg28552.html
 xfstests: add a new test that runs fsstress under ENOSPC conditions
 xfstress: add regression testcase for d583fb87a3ff0
# Fixes available here:
#  http://patchwork.ozlabs.org/patch/120581/
#  http://patchwork.ozlabs.org/patch/120582/
 xfstests: add a new quota test that runs fsstress under ENOSPC conditions
# Following testcase may fail on recent kernel in case of ext3/4
# In case of ext4 kernel will probably panic.  
 xfstress: Test data journaling flag switch for a single file

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
