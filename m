Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2522CeQ213810 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 20:02:13 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8777F21B8D4
	for <xfs@oss.sgi.com>; Thu,  4 Mar 2010 18:03:36 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	SbMPBHjEPEvLcUWm for <xfs@oss.sgi.com>;
	Thu, 04 Mar 2010 18:03:36 -0800 (PST)
Date: Fri, 5 Mar 2010 13:03:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2] xfsqa: define resblks for tests near ENOSPC
Message-ID: <20100305020333.GN14317@discord.disaster>
References: <1267667254-7971-1-git-send-email-david@fromorbit.com>
	<20100304135623.GB31753@infradead.org>
	<20100304220421.GJ14317@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100304220421.GJ14317@discord.disaster>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


Several tests assume a certain amount of disk space free after the
reserve block pool is filled. Changing the default size of the
reserve block pool breaks these tests because there is less space
available that first thought.

Change these tests to specify a known reserve block pool size of
1024 blocks to ensure that they continue to work correctly even if
the default size changes.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 104       |    4 ++++
 204       |    4 ++++
 205       |    4 ++++
 common.rc |   11 +++++++++++
 4 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/104 b/104
index b35c43b..14f2669 100755
--- a/104
+++ b/104
@@ -48,6 +48,10 @@ _create_scratch()
 		echo "failed to mount $SCRATCH_DEV"
 		exit 1
 	fi
+
+	# fix the reserve block pool to a known size so that the enospc
+	# calculations work out correctly.
+	_scratch_resvblks 1024 >  /dev/null 2>&1
 }
 
 _fill_scratch()
diff --git a/204 b/204
index 8b94f60..9f4839c 100755
--- a/204
+++ b/204
@@ -44,6 +44,10 @@ SIZE=`expr 104 \* 1024 \* 1024`
 _scratch_mkfs_sized $SIZE  &> /dev/null
 _scratch_mount
 
+# fix the reserve block pool to a known size so that the enospc calculations
+# work out correctly.
+_scratch_resvblks 1024 > $seq.full 2>&1
+
 for i in `seq 1 22500`; do
     echo -n > $SCRATCH_MNT/$i
     echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
diff --git a/205 b/205
index 3f45185..35d6992 100755
--- a/205
+++ b/205
@@ -43,6 +43,10 @@ _require_scratch
 _scratch_mkfs_xfs -d size=16m -b size=512 >/dev/null
 _scratch_mount
 
+# fix the reserve block pool to a known size so that the enospc calculations
+# work out correctly.
+_scratch_resvblks 1024 > $seq.full 2>&1
+
 # on a 16MB filesystem, there's 32768x512byte blocks. used is:
 #	- 4944 in the log,
 #	- 32+1 for the root inode cluster
diff --git a/common.rc b/common.rc
index d71e0a2..2103a77 100644
--- a/common.rc
+++ b/common.rc
@@ -361,6 +361,17 @@ _scratch_mkfs_geom()
     _scratch_mkfs
 }
 
+_scratch_resvblks()
+{
+	case $FSTYP in
+	xfs)
+		xfs_io -x -c "resblks $1" $SCRATCH_MNT
+		;;
+	*)
+		;;
+	esac
+}
+
 _scratch_xfs_db_options()
 {
     SCRATCH_OPTIONS=""

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
