Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 33E177F93
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 14:12:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 07A848F8033
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:12:18 -0800 (PST)
Received: from mail-vb0-f74.google.com (mail-vb0-f74.google.com
	[209.85.212.74]) by cuda.sgi.com with ESMTP id ykzvYI0K63KmviEg
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:12:17 -0800 (PST)
Received: by mail-vb0-f74.google.com with SMTP id w5so135929vbf.3
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:12:16 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH 01/10] xfstests: Add tmpfs support
Date: Tue, 10 Dec 2013 12:11:52 -0800
Message-Id: <1386706321-15795-2-git-send-email-jayr@google.com>
In-Reply-To: <1386706321-15795-1-git-send-email-jayr@google.com>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
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
Cc: tytso@mit.edu, hughd@google.com, branto@redhat.com, Junho Ryu <jayr@google.com>

From: Boris Ranto <branto@redhat.com>

This is just a simple patch to get the tmpfs working as a target file
system. The patch copies the way nfs is handled in xfstests.

I didn't change the xfstests logic to recognize a proper SCRATCH_DEV.
Hence, the SCRATCH_DEV for tmpfs should be in nfs form (with ':' sign
in it) in order for this to work properly.

Signed-off-by: Boris Ranto <branto@redhat.com>
Signed-off-by: Junho Ryu <jayr@google.com>
---
 check     |  2 ++
 common/rc | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/check b/check
index c88bcf2..320ad26 100755
--- a/check
+++ b/check
@@ -73,6 +73,7 @@ usage()
 
 check options
     -nfs                test NFS
+    -tmpfs              test TMPFS
     -l			line mode diff
     -udiff		show unified diff (default)
     -n			show me, do not run tests
@@ -207,6 +208,7 @@ while [ $# -gt 0 ]; do
 	-\? | -h | --help) usage ;;
 
 	-nfs)	FSTYP=nfs ;;
+	-tmpfs)	FSTYP=tmpfs ;;
 
 	-g)	group=$2 ; shift ;
 		GROUP_LIST="$GROUP_LIST $group"
diff --git a/common/rc b/common/rc
index 5f61d57..a2005c9 100644
--- a/common/rc
+++ b/common/rc
@@ -112,6 +112,10 @@ _mount_opts()
 	# acls aren't turned on by default on gfs2
 	export MOUNT_OPTIONS="-o acl $GFS2_MOUNT_OPTIONS"
 	;;
+    tmpfs)
+	# We need to specify the size at mount, use 512 MB by default
+	export MOUNT_OPTIONS="-o size=512M $TMPFS_MOUNT_OPTIONS"
+	;;
     *)
 	;;
     esac
@@ -140,6 +144,9 @@ _mkfs_opts()
     jfs)
 	export MKFS_OPTIONS="$JFS_MKFS_OPTIONS -q"
 	;;
+    tmpfs)
+	export MKFS_OPTIONS="$TMPFS_MKFS_OPTIONS"
+	;;
     *)
 	;;
     esac
@@ -544,6 +551,9 @@ _scratch_mkfs()
     ext4)
 	_scratch_mkfs_ext4 $*
 	;;
+    tmpfs)
+	# do nothing for tmpfs
+	;;
     *)
 	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV
 	;;
@@ -977,6 +987,12 @@ _require_scratch()
 	nfs*)
                  _notrun "requires a scratch device"
 		 ;;
+	tmpfs)
+		if [ -z "$SCRATCH_DEV" -o ! -d "$SCRATCH_MNT" ];
+		then
+		    _notrun "this test requires a valid \$SCRATCH_MNT and unique $SCRATCH_DEV"
+		fi
+		;;
 	*)
 		 if [ -z "$SCRATCH_DEV" -o "`_is_block_dev $SCRATCH_DEV`" = "" ]
 		 then
@@ -1701,6 +1717,9 @@ _check_test_fs()
     btrfs)
 	_check_btrfs_filesystem $TEST_DEV
 	;;
+    tmpfs)
+	# no way to check consistency for tmpfs
+	;;
     *)
 	_check_generic_filesystem $TEST_DEV
 	;;
@@ -1733,6 +1752,9 @@ _check_scratch_fs()
     btrfs)
 	_check_btrfs_filesystem $device
 	;;
+    tmpfs)
+	# no way to check consistency for tmpfs
+	;;
     *)
 	_check_generic_filesystem $device
 	;;
-- 
1.8.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
