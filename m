Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n53H16r2184773 for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 12:01:06 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4C992CC393
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2009 10:01:23 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id VOL1N5QbhNTcIl1Y for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2009 10:01:23 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n53H1Nvt006250
	for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 13:01:23 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n53H1Mo1017792
	for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 13:01:22 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n53H1KKo012070
	for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 13:01:21 -0400
Message-ID: <4A26AC60.6060401@redhat.com>
Date: Wed, 03 Jun 2009 12:01:20 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: Make the SCRATCH_DEV optional
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
To: xfs mailing list <xfs@oss.sgi.com>

Tests will fail gracefully if there is no SCRATCH_DEV defined, so change

the check script to allow it, and update README to reflect this.

This just makes it simpler to set up the tests, at the expense of
coverage.

Long term it might be nice to allow either SCRATCH_DEV xor TEST_DEV
to be missing, but for now this is simple.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/README b/README
index 375e07c..210bded 100644
--- a/README
+++ b/README
@@ -26,25 +26,26 @@ Preparing system for tests (IRIX and Linux):
       set the environment variable DISABLE_UDF_TEST to 1.
 	
     
-    - create two partitions to use for testing
+    - create one or two partitions to use for testing
         - one TEST partition
             - format as XFS, mount & optionally populate with 
               NON-IMPORTANT stuff
-        - one SCRATCH partition
+        - one SCRATCH partition (optional)
             - leave empty and expect this partition to be clobbered
-              by some tests.
+              by some tests.  If this is not provided, many tests will
+              not be run.
               
         (these must be two DIFFERENT partitions)
               
     - setup your environment
         - setenv TEST_DEV "device containing TEST PARTITION"
         - setenv TEST_DIR "mount point of TEST PARTITION"   
-        - setenv SCRATCH_DEV "device containing SCRATCH PARTITION"
-        - setenv SCRATCH_MNT "mount point for SCRATCH PARTITION"
-        - setenv TAPE_DEV "tape device for testing xfsdump"
-        - setenv RMT_TAPE_DEV "remote tape device for testing xfsdump"
-        - setenv RMT_IRIXTAPE_DEV "remote IRIX tape device for testing xfsdump"
        	- optionally:
+             - setenv SCRATCH_DEV "device containing SCRATCH PARTITION"
+             - setenv SCRATCH_MNT "mount point for SCRATCH PARTITION"
+             - setenv TAPE_DEV "tape device for testing xfsdump"
+             - setenv RMT_TAPE_DEV "remote tape device for testing xfsdump"
+             - setenv RMT_IRIXTAPE_DEV "remote IRIX tape device for testing xfsdump"
 	     - setenv SCRATCH_LOGDEV "device for scratch-fs external log"
              - setenv SCRATCH_RTDEV "device for scratch-fs realtime data"
 	     - setenv TEST_LOGDEV "device for test-fs external log"
diff --git a/check b/check
index 348b68e..55e90a1 100755
--- a/check
+++ b/check
@@ -160,26 +160,28 @@ MOUNT_OPTIONS -- $FULL_MOUNT_OPTIONS
 
 EOF
 
-umount $SCRATCH_DEV 2>/dev/null
-# call the overridden mkfs - make sure the FS is built
-# the same as we'll create it later.
-
-if ! _scratch_mkfs $flag >$tmp.err 2>&1
-then
-    echo "our local _scratch_mkfs routine ..."
-    cat $tmp.err
-    echo "check: failed to mkfs \$SCRATCH_DEV using specified options"
-    exit 1
-fi
-
-# call the overridden mount - make sure the FS mounts with
-# the same options that we'll mount with later.
-if ! _scratch_mount >$tmp.err 2>&1
-then
-    echo "our local mount routine ..."
-    cat $tmp.err
-    echo "check: failed to mount \$SCRATCH_DEV using specified options"
-    exit 1
+if [ ! -z "$SCRATCH_DEV"]; then
+  umount $SCRATCH_DEV 2>/dev/null
+  # call the overridden mkfs - make sure the FS is built
+  # the same as we'll create it later.
+
+  if ! _scratch_mkfs $flag >$tmp.err 2>&1
+  then
+      echo "our local _scratch_mkfs routine ..."
+      cat $tmp.err
+      echo "check: failed to mkfs \$SCRATCH_DEV using specified options"
+      exit 1
+  fi
+
+  # call the overridden mount - make sure the FS mounts with
+  # the same options that we'll mount with later.
+  if ! _scratch_mount >$tmp.err 2>&1
+  then
+      echo "our local mount routine ..."
+      cat $tmp.err
+      echo "check: failed to mount \$SCRATCH_DEV using specified options"
+      exit 1
+  fi
 fi
 
 seq="check"


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
