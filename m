Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C80F97F3F
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 05:38:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A551D8F8039
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 03:38:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bjvCmpm3dAMTVbGu for
	<xfs@oss.sgi.com>; Thu, 11 Jul 2013 03:38:16 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6BAcGAV031025
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 06:38:16 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 04/10 v2] xfstests: Allow to recheck options in common/rc
Date: Thu, 11 Jul 2013 12:37:59 +0200
Message-Id: <1373539085-8577-5-git-send-email-lczerner@redhat.com>
In-Reply-To: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
References: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
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
Cc: lczerner@redhat.com

Move configuration checks into separate function to allow us to recheck
the options without the need to reinclude the whole source file which is
ugly. We still run the check on include.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 common/rc | 74 ++++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 38 insertions(+), 36 deletions(-)

diff --git a/common/rc b/common/rc
index fe6bbfc..0dd30a3 100644
--- a/common/rc
+++ b/common/rc
@@ -2131,46 +2131,48 @@ run_check()
 	"$@" >> $seqres.full 2>&1 || _fail "failed: '$@'"
 }
 
-################################################################################
-
-if [ "$iam" != new ]
-then
-    # make some further configuration checks here
-
-    if [ "$TEST_DEV" = ""  ]
-    then
-        echo "common/rc: Error: \$TEST_DEV is not set"
-        exit 1
-    fi
-
-    # if $TEST_DEV is not mounted, mount it now as XFS
-    if [ -z "`_fs_type $TEST_DEV`" ]
-    then
-        # $TEST_DEV is not mounted
-        if ! _test_mount
-        then
-            echo "common/rc: retrying test device mount with external set"
-            [ "$USE_EXTERNAL" != "yes" ] && export USE_EXTERNAL=yes
-            if ! _test_mount
-            then
-                echo "common/rc: could not mount $TEST_DEV on $TEST_DIR"
-                exit 1
-            fi
-        fi
-    fi
+init_rc()
+{
+	if [ "$iam" == new ]
+	then
+		return
+	fi
+	# make some further configuration checks here
+	if [ "$TEST_DEV" = ""  ]
+	then
+		echo "common/rc: Error: \$TEST_DEV is not set"
+		exit 1
+	fi
 
-    if [ "`_fs_type $TEST_DEV`" != "$FSTYP" ]
-    then
-        echo "common/rc: Error: \$TEST_DEV ($TEST_DEV) is not a MOUNTED $FSTYP filesystem"
-        $DF_PROG $TEST_DEV
-        exit 1
-    fi
+	# if $TEST_DEV is not mounted, mount it now as XFS
+	if [ -z "`_fs_type $TEST_DEV`" ]
+	then
+		# $TEST_DEV is not mounted
+		if ! _test_mount
+		then
+			echo "common/rc: retrying test device mount with external set"
+			[ "$USE_EXTERNAL" != "yes" ] && export USE_EXTERNAL=yes
+			if ! _test_mount
+			then
+				echo "common/rc: could not mount $TEST_DEV on $TEST_DIR"
+				exit 1
+			fi
+		fi
+	fi
 
-    # Figure out if we need to add -F ("foreign", deprecated) option to xfs_io
-    xfs_io -c stat $TEST_DIR 2>&1 | grep -q "is not on an XFS filesystem" && \
+	if [ "`_fs_type $TEST_DEV`" != "$FSTYP" ]
+	then
+		echo "common/rc: Error: \$TEST_DEV ($TEST_DEV) is not a MOUNTED $FSTYP filesystem"
+		$DF_PROG $TEST_DEV
+		exit 1
+	fi
+	# Figure out if we need to add -F ("foreign", deprecated) option to xfs_io
+	xfs_io -c stat $TEST_DIR 2>&1 | grep -q "is not on an XFS filesystem" && \
 	export XFS_IO_PROG="$XFS_IO_PROG -F"
+}
 
-fi
+init_rc
 
+################################################################################
 # make sure this script returns success
 /bin/true
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
