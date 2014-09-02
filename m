Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 494377F59
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 09:22:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 355C28F8040
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 07:22:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jMYotLnvPnUkBdUM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Sep 2014 07:22:44 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/2] xfstests/common: don't assume sysfs attrs all reside
	under test dev
Date: Tue,  2 Sep 2014 10:22:40 -0400
Message-Id: <1409667761-50248-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1409667761-50248-1-git-send-email-bfoster@redhat.com>
References: <1409667761-50248-1-git-send-email-bfoster@redhat.com>
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
Cc: xfs@oss.sgi.com

_require_xfs_sysfs() currently assumes that all sysfs attributes reside
under a device-specific subdirectory in the XFS sysfs hierarchy. It is
hardcoded to use the TEST_DEV mount and expect the relative attribute
path as a parameter.

Not all sysfs attributes are associated with specific devices or mount
points, however. Remove the hardcoded device name part of the attribute
path from _require_xfs_sysfs() and let the caller construct the relative
path based on the sysfs XFS root directory.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 common/rc     | 3 +--
 tests/xfs/011 | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/common/rc b/common/rc
index 16da898..01f573e 100644
--- a/common/rc
+++ b/common/rc
@@ -1224,13 +1224,12 @@ _require_xfs_sysfs()
 {
 	attr=$1
 	sysfsdir=/sys/fs/xfs
-	testdev=`_short_dev $TEST_DEV`
 
 	if [ ! -e $sysfsdir ]; then
 		_notrun "no kernel support for XFS sysfs attributes"
 	fi
 
-	if [ ! -z $1 ] && [ ! -e $sysfsdir/$testdev/$attr ]; then
+	if [ ! -z $1 ] && [ ! -e $sysfsdir/$attr ]; then
 		_notrun "sysfs attribute '$attr' is not supported"
 	fi
 }
diff --git a/tests/xfs/011 b/tests/xfs/011
index 658a822..197752c 100755
--- a/tests/xfs/011
+++ b/tests/xfs/011
@@ -85,7 +85,7 @@ _supported_os Linux
 
 _require_scratch
 _require_freeze
-_require_xfs_sysfs log
+_require_xfs_sysfs $(_short_dev $TEST_DEV)/log
 
 rm -f $seqres.full
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
