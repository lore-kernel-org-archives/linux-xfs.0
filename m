Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 89A88857B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:48:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4A2DC8F804C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:48:19 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id aRQdEU3uAD5JSzgW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:48:12 -0700 (PDT)
Subject: [PATCH 20/20] xfs: scrub fs (if still mounted) at the end of the test
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:48:07 -0700
Message-ID: <146612808781.25024.9354886387434772563.stgit@birch.djwong.org>
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
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

Teach _check_xfs_filesystem to scrub mounted filesystems before
unmounting and fscking them.  This is mostly to test the online
scrub tool...

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/config |    1 +
 common/rc     |    7 +++++++
 2 files changed, 8 insertions(+)


diff --git a/common/config b/common/config
index cacd815..41edb0c 100644
--- a/common/config
+++ b/common/config
@@ -163,6 +163,7 @@ export XFS_REPAIR_PROG="`set_prog_path xfs_repair`"
 export XFS_DB_PROG="`set_prog_path xfs_db`"
 export XFS_GROWFS_PROG=`set_prog_path xfs_growfs`
 export XFS_IO_PROG="`set_prog_path xfs_io`"
+export XFS_SCRUB_PROG="`set_prog_path xfs_scrub`"
 export XFS_PARALLEL_REPAIR_PROG="`set_prog_path xfs_prepair`"
 export XFS_PARALLEL_REPAIR64_PROG="`set_prog_path xfs_prepair64`"
 export __XFSDUMP_PROG="`set_prog_path xfsdump`"
diff --git a/common/rc b/common/rc
index 847191e..ea5baea 100644
--- a/common/rc
+++ b/common/rc
@@ -2188,6 +2188,13 @@ _check_xfs_filesystem()
 
     if [ "$type" = "xfs" ]
     then
+	if [ -x "$XFS_SCRUB_PROG" ]; then
+		"$XFS_SCRUB_PROG" $scrubflag -vd $device >>$seqres.full
+		if [ $? -ne 0 ]; then
+			echo "filesystem on $device failed scrub (see $seqres.full)"
+			ok=0
+		fi
+	fi
         # mounted ...
         mountpoint=`_umount_or_remount_ro $device`
     fi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
