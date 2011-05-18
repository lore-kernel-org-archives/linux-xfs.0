Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4ICffYr238223 for <xfs@oss.sgi.com>; Wed, 18 May 2011 07:41:42 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 811B8514B60
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 05:41:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dQtG1xFktNgiMNDZ for
	<xfs@oss.sgi.com>; Wed, 18 May 2011 05:41:40 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4ICfecw001128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 08:41:40 -0400
Received: from [10.34.26.208] (dhcp-26-208.brq.redhat.com [10.34.26.208])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p4ICfcX4007148
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 08:41:39 -0400
Subject: xfstests - SCRATCH_DIR mounted/unmounted twice when testing nfs
From: Boris Ranto <branto@redhat.com>
Date: Wed, 18 May 2011 12:41:38 +0000
Message-ID: <1305722498.25226.110.camel@dhcp-31-190.brq.redhat.com>
Mime-Version: 1.0
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
To: xfs <xfs@oss.sgi.com>

Tests 124, 127 and 128 unmount their SCRATCH_DEV manually while using _cleanup_testdir in trapped cleanup function.
This can lead to test fails due to double unmount on nfs where _cleanup_testdir unmounts SCRATCH_DEV.

Tests 129 and 130 use _setup_testdir and _scratch_mount that can lead to double mount on nfs where _setup_testdir mounts SCRATCH_DEV.

The least invasive patch (only nfs shall be affected by this patch) I could come up with that fixed this issue used conditional umounts in _cleanup_testdir and conditional mount/remount in _scratch_mount (remount was used so that mount flags do not get lost).

Alternatively, _setup_testdir could stop mounting SCRATCH_DEV but that would be probably too invasive.

Signed-off-by: Boris Ranto <branto@redhat.com>

diff --git a/common.rc b/common.rc
index e634fbb..6a701a6 100644
--- a/common.rc
+++ b/common.rc
@@ -227,6 +227,10 @@ _scratch_mount_options()
 
 _scratch_mount()
 {
+    if [ "$FSTYP" = "nfs" -a -n "$(_mount | grep $SCRATCH_DEV |grep
$SCRATCH_MNT)" ]
+    then
+       _scratch_unmount
+    fi
     _mount -t $FSTYP `_scratch_mount_options $*`
 }
 
@@ -1379,7 +1383,10 @@ _cleanup_testdir()
        ;;
     nfs*)
        # umount testdir as it is $SCRATCH_MNT which could be used by
xfs next
-       [ -n "$testdir" ] && $UMOUNT_PROG $testdir
+       if _mount | grep $SCRATCH_DEV |grep -q $testdir
+       then
+          [ -n "$testdir" ] && $UMOUNT_PROG $testdir
+       fi
        ;;
     *)
        # do nothing, testdir is $TEST_DIR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
