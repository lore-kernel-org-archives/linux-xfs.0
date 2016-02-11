Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 397C37CA3
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:40:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EA81C8F804C
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:40:13 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id cI4K1DaRUjMBXNoD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:40:12 -0800 (PST)
Subject: [PATCH 08/32] common: provide a method to repair the scratch fs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:40:08 -0800
Message-ID: <20160211234008.2202.30511.stgit@birch.djwong.org>
In-Reply-To: <20160211233916.2202.40961.stgit@birch.djwong.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Create a wrapper function that repairs any damage to the scratch
filesystem and returns a standard result.  We will use this to clean
up after IO error testing and other weird corruption tests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)


diff --git a/common/rc b/common/rc
index 63eb90b..e05df74 100644
--- a/common/rc
+++ b/common/rc
@@ -953,6 +953,49 @@ _scratch_xfs_repair()
     $XFS_REPAIR_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 
+# Repair scratch filesystem.  Returns 0 if the FS is good to go (either no
+# errors found or errors were fixed) and nonzero otherwise; also spits out
+# a complaint on stderr if fsck didn't tell us that the FS is good to go.
+_repair_scratch_fs()
+{
+    case $FSTYP in
+    xfs)
+        _scratch_xfs_repair "$@" 2>&1
+	res=$?
+	if [ "$res" -eq 2 ]; then
+		echo "xfs_repair returns $res; replay log?"
+		_scratch_mount
+		res=$?
+		if [ "$res" -gt 0 ]; then
+			echo "mount returns $res; zap log?"
+			_scratch_xfs_repair -L 2>&1
+			echo "log zap returns $?"
+		else
+			umount "$SCRATCH_MNT"
+		fi
+		_scratch_xfs_repair "$@" 2>&1
+		res=$?
+	fi
+	test $res -ne 0 && >&2 echo "xfs_repair failed, err=$res"
+	return $res
+        ;;
+    *)
+        # Let's hope fsck -y suffices...
+        fsck -t $FSTYP -y $SCRATCH_DEV 2>&1
+	res=$?
+	case $res in
+	0|1|2)
+		res=0
+		;;
+	*)
+		>&2 echo "fsck.$FSTYP failed, err=$res"
+		;;
+	esac
+	return $res
+        ;;
+    esac
+}
+
 _get_pids_by_name()
 {
     if [ $# -ne 1 ]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
