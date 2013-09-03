Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A3C367F60
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 19:15:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 92E83304081
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 17:15:03 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	TBmyozIDWitFeOJb for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 17:15:02 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VGeGn-0002J9-Gd
	for xfs@oss.sgi.com; Tue, 03 Sep 2013 10:14:57 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VGeGn-0001zG-Fi
	for xfs@oss.sgi.com; Tue, 03 Sep 2013 10:14:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfstests: Obey mkfs options for sized filesystems on XFS
Date: Tue,  3 Sep 2013 10:14:54 +1000
Message-Id: <1378167295-7566-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1378167295-7566-1-git-send-email-david@fromorbit.com>
References: <1378167295-7566-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The XFS implementation of _scratch_mkfs_sized ignores MKFS_OPTIONS
when a custom block size is set and so isn't testing things like
CRCs on such sized filesytsems. Fix this by ensuring we don't try to
override the block size is it is set in MKFS_OPTIONS. xfs/204 shows
this problem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/rc         | 8 +++++++-
 tests/generic/204 | 4 +++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index 358f24b..8a239c5 100644
--- a/common/rc
+++ b/common/rc
@@ -578,7 +578,13 @@ _scratch_mkfs_sized()
 
     case $FSTYP in
     xfs)
-	_scratch_mkfs_xfs -d size=$fssize -b size=$blocksize
+	# don't override MKFS_OPTIONS that set a block size.
+	echo $MKFS_OPTIONS |egrep -q "b?size="
+	if [ $? -eq 0 ]; then
+		_scratch_mkfs_xfs -d size=$fssize
+	else
+		_scratch_mkfs_xfs -d size=$fssize -b size=$blocksize
+	fi
 	;;
     ext2|ext3|ext4|ext4dev)
 	yes | ${MKFS_PROG}.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
diff --git a/tests/generic/204 b/tests/generic/204
index 98cb176..a054c8f 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -39,13 +39,15 @@ _supported_os Linux
 
 _require_scratch
 
+rm -f $seqres.full
+
 SIZE=`expr 104 \* 1024 \* 1024`
 _scratch_mkfs_sized $SIZE  &> /dev/null
 _scratch_mount
 
 # fix the reserve block pool to a known size so that the enospc calculations
 # work out correctly.
-_scratch_resvblks 1024 > $seqres.full 2>&1
+_scratch_resvblks 1024 >> $seqres.full 2>&1
 
 for i in `seq 1 22500`; do
     echo -n > $SCRATCH_MNT/$i
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
