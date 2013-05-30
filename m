Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8D40D7F37
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 17:02:23 -0500 (CDT)
Received: from xmail.sgi.com (pv-excas1-dc21.corp.sgi.com [137.38.106.7])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6E8B9304062
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 15:02:20 -0700 (PDT)
Message-ID: <51A7CC6B.3030607@sgi.com>
Date: Thu, 30 May 2013 17:02:19 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: Fix test wildcard expansion.
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfstests <xfs@oss.sgi.com>


Before commit 38d58591 "xfstests: fix typo in check",
check xfs/[0-9]?? would execute all tests/xfs/[0-9]?? because:

'if grep "^$testname" $group_file >/dev/null'
returns the contents of $group_file because $testname="".

Therefore xfs/[0-9]?? was echoed to $tmp.list

Fix the parsing in check to expand the regular expressions for test names.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>
---

diff --git a/check b/check
index 8d32486..eb5d9be 100755
--- a/check
+++ b/check
@@ -242,13 +242,15 @@ if $have_test_arg; then
  			test_name=`basename $1`
  			group_file=$SRC_DIR/$test_dir/group

-			if grep "^$test_name" $group_file >/dev/null ; then
-				# in group file ... OK
-				echo $SRC_DIR/$1 >>$tmp.list
-			else
-				# oops
-				echo "$1 - unknown test, ignored"
-			fi
+			for f in `cd $SRC_DIR/$test_dir; ls $test_name`; do
+				if grep "^$f" $group_file >/dev/null ; then
+					# in group file ... OK
+					echo $SRC_DIR/$test_dir/$f >>$tmp.list
+				else
+					# oops
+					echo "$test_dir/$f - unknown test, ignored"
+				fi
+			done
  			;;
  		esac

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
