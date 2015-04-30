Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 303227F37
	for <xfs@oss.sgi.com>; Thu, 30 Apr 2015 03:44:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C135AAC001
	for <xfs@oss.sgi.com>; Thu, 30 Apr 2015 01:44:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8HhSIedE6bKDGBl0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Apr 2015 01:44:51 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] generic/204: use more space for inode allocation
Date: Thu, 30 Apr 2015 16:44:20 +0800
Message-Id: <1430383460-32206-1-git-send-email-eguan@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: fstests@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

On v4/512b and v5/1k xfs, there're not enough free inodes for new files
and generic/204 fails because of running out of inode not space.

Adding "-i maxpct=50" to MKFS_OPTIONS to bump up the inode limit at mkfs
time, and test could pass on all configurations.

Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/generic/204 | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tests/generic/204 b/tests/generic/204
index 13069d8..42985ab 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -52,8 +52,10 @@ _scratch_mkfs 2> /dev/null | _filter_mkfs 2> $tmp.mkfs > /dev/null
 . $tmp.mkfs
 
 # For xfs, we need to handle the different default log sizes that different
-# versions of mkfs create. All should be valid with a 5MB log, so use that.
-[ $FSTYP = "xfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -l size=7m"
+# versions of mkfs create. All should be valid with a 7MB log, so use that.
+# And v4/512 v5/1k xfs don't have enough free inodes, set imaxpct=50 at mkfs
+# time solves this problem.
+[ $FSTYP = "xfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -l size=7m -i maxpct=50"
 
 SIZE=`expr 106 \* 1024 \* 1024`
 _scratch_mkfs_sized $SIZE $dbsize 2> /dev/null \
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
