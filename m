Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 090EA7CA0
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2016 06:19:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AE564304032
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2016 04:19:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FWEUFByKMyUWnX9u (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 31 Aug 2016 04:19:03 -0700 (PDT)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v2] xfs/187: fix new sb_features2 stop case running
Date: Wed, 31 Aug 2016 19:18:56 +0800
Message-Id: <1472642336-28112-1-git-send-email-zlang@redhat.com>
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
Cc: Zorro Lang <zlang@redhat.com>, xfs@oss.sgi.com

This case is too old, at that time there's no "ftype" feature for
XFS. Due to this case need to clear features2 bits when mkfs.xfs,
so ftype bit stop case running for long time.

New common function _require_old_xfs_format() will help to fix
this problem. Call it as:

  _require_old_xfs_format ATTR2 LAZYSBCOUNT

Then it'll help to clear all features2 bits, besides ATTR2 and
LAZYSBCOUNT which will be tested in case.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

V2 add a new common function _require_old_xfs_format(), which help to
to make sure no features2 xfs bits will be set.

But mostly we still want to test some features2 bits, so I make
this function won't deal with those features which are specified by
arguments.

For clear CRC feature, we can set MKFS_OPTIONS="$MKFS_OPTIONS -m crc=0"
simply. But if the user specify crc=1/0 in local.config file, the test
can't continue running. So I check if it has been set in the function.

Please tell me if you have better way to implement this function:)

By the way, did I miss some features2?

Thanks,
Zorro

 common/rc     | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/187 | 36 ++++++++++------------------
 2 files changed, 87 insertions(+), 24 deletions(-)

diff --git a/common/rc b/common/rc
index 3fb0600..29e2987 100644
--- a/common/rc
+++ b/common/rc
@@ -3923,6 +3923,81 @@ _require_xfs_mkfs_without_validation()
 	fi
 }
 
+# Make sure no features2 bits in XFS, besides those features are
+# specified by arguments. All current features2 names as below:
+#   "CRC FINOBT PROJID32BIT ATTR2 LAZYSBCOUNT FTYPE"
+_require_old_xfs_format()
+{
+	local skiplist="$*"
+	local ftr2=""
+	local b
+	local opts
+
+	_scratch_mkfs >/dev/null 2>&1
+	ftr2=`$XFS_DB_PROG -c version $SCRATCH_DEV | tr 'a-z' 'A-Z' |\
+		sed -n -e "s/,/ /g" -e "s/.*MOREBITS\(.*\)/\1/p"`
+
+	for b in `echo $skiplist | tr 'a-z' 'A-Z'`; do
+		i=`echo $ftr2 | sed -n -e "s/\(.*\)$b\(.*\)/\1\2/p"`
+		if [ -n "$b" ]; then
+			ftr2="$i"
+		fi
+	done
+
+	for b in $ftr2; do
+		case $b in
+		CRC)
+			if echo $MKFS_OPTIONS | grep -q "crc=1"; then
+				MKFS_OPTIONS=`echo $MKFS_OPTIONS | \
+					sed -e "s/crc=1/crc=0/g"`
+			else
+				MKFS_OPTIONS="$MKFS_OPTIONS -m crc=0"
+			fi
+			;;
+		FINOBT)
+			if echo $MKFS_OPTIONS | grep -q "finobt=1"; then
+				MKFS_OPTIONS=`echo $MKFS_OPTIONS | \
+					sed -e "s/finobt=1/finobt=0/g"`
+			else
+				MKFS_OPTIONS="$MKFS_OPTIONS -m finobt=0"
+			fi
+			;;
+		PROJID32BIT)
+			if echo $MKFS_OPTIONS | grep -q "projid32bit=1"; then
+				MKFS_OPTIONS=`echo $MKFS_OPTIONS | \
+					sed -e "s/projid32bit=1/projid32bit=0/g"`
+			else
+				MKFS_OPTIONS="$MKFS_OPTIONS -i projid32bit=0"
+			fi
+			;;
+		ATTR2)
+			if echo $MKFS_OPTIONS | grep -q "attr="; then
+				MKFS_OPTIONS=`echo $MKFS_OPTIONS | \
+					sed -e "s/attr=[0-9]/attr=1/g"`
+			else
+				MKFS_OPTIONS="$MKFS_OPTIONS -i attr=1"
+			fi
+			;;
+		LAZYSBCOUNT)
+			if echo $MKFS_OPTIONS | grep -q "lazy-count=1"; then
+				MKFS_OPTIONS=`echo $MKFS_OPTIONS | \
+					sed -e "s/lazy-count=1/lazy-count=0/g"`
+			else
+				MKFS_OPTIONS="$MKFS_OPTIONS -l lazy-count=0"
+			fi
+			;;
+		FTYPE)
+			if echo $MKFS_OPTIONS | grep -q "ftype=1"; then
+				MKFS_OPTIONS=`echo $MKFS_OPTIONS | \
+					sed -e "s/ftype=1/ftype=0/g"`
+			else
+				MKFS_OPTIONS="$MKFS_OPTIONS -n ftype=0"
+			fi
+			;;
+		esac
+	done
+}
+
 init_rc
 
 ################################################################################
diff --git a/tests/xfs/187 b/tests/xfs/187
index 836b924..ffc851c 100755
--- a/tests/xfs/187
+++ b/tests/xfs/187
@@ -31,7 +31,6 @@ seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
-here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
 trap "_cleanup; exit \$status" 0 1 2 3 15
@@ -57,25 +56,16 @@ _supported_fs xfs
 _supported_os Linux
 
 _require_scratch
+# clear features2 bits which we won't test
+_require_old_xfs_format ATTR2 LAZYSBCOUNT
 _require_attrs
-_require_attr_v1
-_require_projid16bit
 
 rm -f $seqres.full
-
-# Reset the options so that we can control what is going on here
-export MKFS_OPTIONS=""
-export MOUNT_OPTIONS=""
-
-# lazysb, attr2 and other feature bits are held in features2 and will require
-# morebitsbit on So test with lazysb and without it to see if the morebitsbit is
-# okay etc. If the mkfs defaults change, these need to change as well.
-export MKFS_NO_LAZY="-m crc=0 -l lazy-count=0 -i projid32bit=0"
-export MKFS_LAZY="-m crc=0 -l lazy-count=1 -i projid32bit=0"
+_scratch_mkfs >/dev/null 2>&1
 
 # Make sure that when we think we are testing with morebits off
 # that we really are.
-_scratch_mkfs -i attr=1 $MKFS_NO_LAZY  >/dev/null 2>&1
+_scratch_mkfs -i attr=1 -l lazy-count=0 >/dev/null 2>&1
 $XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 >$tmp.db
 if grep -i morebits $tmp.db
 then
@@ -90,13 +80,13 @@ echo "*** 1. test attr2 mkfs and then noattr2 mount ***"
 echo ""
 echo "attr2 fs"
 echo ""
-_scratch_mkfs -i attr=2 $MKFS_NO_LAZY >/dev/null 2>&1
+_scratch_mkfs -i attr=2 -l lazy-count=0 >/dev/null 2>&1
 $XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
 echo ""
 echo "noattr2 fs"
 echo ""
 _scratch_mount -o noattr2
-$UMOUNT_PROG $SCRATCH_MNT
+_scratch_unmount
 $XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
 
 # adding an EA will ensure the ATTR1 flag is turned on
@@ -105,7 +95,7 @@ echo "*** 2. test attr2 mkfs and then noattr2 mount with 1 EA ***"
 echo ""
 echo "attr2 fs"
 echo ""
-_scratch_mkfs -i attr=2 $MKFS_NO_LAZY >/dev/null 2>&1
+_scratch_mkfs -i attr=2 -l lazy-count=0 >/dev/null 2>&1
 $XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
 echo ""
 echo "noattr2 fs"
@@ -115,8 +105,8 @@ cd $SCRATCH_MNT
 touch testfile
 $SETFATTR_PROG -n user.test -v 0xbabe testfile
 $GETFATTR_PROG testfile
-cd $here
-$UMOUNT_PROG $SCRATCH_MNT
+cd - >/dev/null
+_scratch_unmount
 $XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
 
 echo ""
@@ -125,16 +115,14 @@ echo ""
 echo ""
 echo "attr2 fs"
 echo ""
-_scratch_mkfs -i attr=2 $MKFS_LAZY >/dev/null 2>&1
+_scratch_mkfs -i attr=2 -l lazy-count=1 >/dev/null 2>&1
 $XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
 echo ""
 echo "noattr2 fs"
 echo ""
 _scratch_mount -o noattr2
-cd $SCRATCH_MNT
-touch testfile
-cd $here
-$UMOUNT_PROG $SCRATCH_MNT
+touch $SCRATCH_MNT/testfile
+_scratch_unmount
 $XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
 
 # success, all done
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
