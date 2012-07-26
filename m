Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q8ZDAn000688 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:35:13 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Dte8e0piwsPpmoJq for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 01:35:11 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuJXI-00012a-OU
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:35:08 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuJXI-0003st-LN
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:35:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfstests: _check_quota_usage needs to unmount to get XFS
	quotacheck
Date: Thu, 26 Jul 2012 18:35:05 +1000
Message-Id: <1343291706-14882-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1343291706-14882-1-git-send-email-david@fromorbit.com>
References: <1343291706-14882-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Remount won't run a quota check - it's only done during mount. Hence
all quota tests using this check function are not actually
validating XFS filesystems right now.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common.quota |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/common.quota b/common.quota
index 9736306..2fa784b 100644
--- a/common.quota
+++ b/common.quota
@@ -236,6 +236,11 @@ _check_quota_usage()
 {
 	# Sync to get delalloc to disk
 	sync
+
+	# kill caches to guarantee removal speculative delalloc
+	# XXX: really need an ioctl instead of this big hammer
+	echo 3 > /proc/sys/vm/drop_caches
+
 	VFS_QUOTA=0
 	case $FSTYP in
 	ext2|ext3|ext4|ext4dev|reiserfs)
@@ -253,8 +258,9 @@ _check_quota_usage()
 		quotacheck -u -g $SCRATCH_MNT 2>/dev/null
 	else
 		# use XFS method to force quotacheck
-		mount -o remount,noquota $SCRATCH_DEV
-		mount -o remount,usrquota,grpquota $SCRATCH_DEV
+		xfs_quota -x -c "off -ug" $SCRATCH_MNT
+		_scratch_unmount
+		_scratch_mount "-o usrquota,grpquota"
 	fi
 	repquota -u -n $SCRATCH_MNT  | grep -v "^#0" | _filter_scratch |
 		sort >$tmp.user.checked
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
