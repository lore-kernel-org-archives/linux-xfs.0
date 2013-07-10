Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 73B027F59
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 09:00:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DA10FAC009
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 07:00:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oQEFCTwelb7rKiGL for
	<xfs@oss.sgi.com>; Wed, 10 Jul 2013 07:00:49 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6AE0nXA005864
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 10:00:49 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 04/10] xfstests: Allow to recheck options in common/rc
Date: Wed, 10 Jul 2013 16:00:33 +0200
Message-Id: <1373464839-31535-5-git-send-email-lczerner@redhat.com>
In-Reply-To: <1373464839-31535-1-git-send-email-lczerner@redhat.com>
References: <1373464839-31535-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

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
