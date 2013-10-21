Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1FAC47F59
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 10:53:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E1B588F8033
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 08:53:23 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id hwcDhCTyMphKnDn4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 Oct 2013 08:53:22 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 400A79A06AC
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 09:53:22 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: wipefs new device in btrfs/003
Date: Mon, 21 Oct 2013 11:53:16 -0400
Message-ID: <1382370796-12391-1-git-send-email-jbacik@fusionio.com>
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

We changed btrfs device add to check and see if there is an existing fs on the
device we are adding, so you now have to do -f if you want to do this.  In order
to get around checking to see if we have this version of btrfs-progs just wipefs
the device we're adding to make sure the device add will pass no matter which
version of btrfs-progs you have.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 common/config   | 1 +
 tests/btrfs/003 | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/common/config b/common/config
index 20c5b09..5dd7c7d 100644
--- a/common/config
+++ b/common/config
@@ -180,6 +180,7 @@ export E4DEFRAG_PROG="`set_prog_path e4defrag`"
 export LOGGER_PROG="`set_prog_path logger`"
 export DBENCH_PROG="`set_prog_path dbench`"
 export DMSETUP_PROG="`set_prog_path dmsetup`"
+export WIPEFS_PROG="`set_prog_path wipefs`"
 
 # Generate a comparable xfsprogs version number in the form of
 # major * 10000 + minor * 100 + release
diff --git a/tests/btrfs/003 b/tests/btrfs/003
index 15c2cc7..9105d06 100755
--- a/tests/btrfs/003
+++ b/tests/btrfs/003
@@ -51,6 +51,7 @@ _supported_os Linux
 _require_scratch
 _require_scratch_dev_pool
 _require_deletable_scratch_dev_pool
+_require_command $WIPEFS_PROG
 
 rm -f $seqres.full
 
@@ -109,6 +110,8 @@ _test_add()
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
 	for i in `seq 2 $n`; do
+		$WIPEFS_PROG -a ${devs[$i]} >> $seqres.full 2>&1 || \
+			_fail "wipefs failed"
 		$BTRFS_UTIL_PROG device add ${devs[$i]} $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "device add failed"
 	done
 	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "balance failed"
@@ -150,6 +153,7 @@ _test_replace()
 
 	# add a new disk to btrfs
 	ds=${devs[@]:$(($n)):1}
+	$WIPEFS_PROG -a ${ds} >> $seqres.full 2>&1 || _fail "wipefs failed"
 	$BTRFS_UTIL_PROG device add ${ds} $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "dev add failed"
 	# in some system balance fails if there is no delay (a bug)
 	# putting sleep 10 to work around as of now
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
