Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8E6jY5d030198 for <xfs@oss.sgi.com>; Mon, 14 Sep 2009 01:45:34 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 636F9163B26C
	for <xfs@oss.sgi.com>; Sun, 13 Sep 2009 23:46:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ocDtelRfej1pCXiU for
	<xfs@oss.sgi.com>; Sun, 13 Sep 2009 23:46:46 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8E6kjSu014334
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2009 02:46:45 -0400
Received: from loki.usersys.redhat.com (dhcp-lab-108.englab.brq.redhat.com
	[10.34.33.108])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8E6kilL007011
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2009 02:46:45 -0400
From: Jaroslav Barton <jbarton@redhat.com>
Subject: [xfstests]: add-reiserfs-specific-_check_reiserfs_filesystem patch
Date: Mon, 14 Sep 2009 08:46:52 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_cberKRcYC4qt/nD"
Message-Id: <200909140846.52217.jbarton@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--Boundary-00=_cberKRcYC4qt/nD
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi,

I was on vacation last week.

I am using xfstests in my project and testing reiserfs filesystem. Reiserfsck 
waits for confirmation before fsck is runned. This patch runs reiserfsck with 
--yes parameter and confirmation is not needed.

Thanks

--Boundary-00=_cberKRcYC4qt/nD
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0001-add-reiserfs-specific-_check_reiserfs_filesystem-fun.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-add-reiserfs-specific-_check_reiserfs_filesystem-fun.patch"

=46rom f34d69cbbcdde9fa973e8c3ddb7fa3e9b17c7305 Mon Sep 17 00:00:00 2001
=46rom: Jaroslav Barton <jbarton@redhat.com>
Date: Fri, 4 Sep 2009 11:09:32 +0200
Subject: [PATCH] add reiserfs specific _check_reiserfs_filesystem function

The _check_generic_filesystem function doesn't start reiserfsck
correctly. Reiserfsck waits for user answer (user must write Yes,
but question is not visible). This specific function runs
reiserfsck with --yes parameter to awoid waiting for answer.
=2D--
 common.rc |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/common.rc b/common.rc
index da5f99e..8b990ba 100644
=2D-- a/common.rc
+++ b/common.rc
@@ -911,6 +911,50 @@ _check_extN_filesystem()
     return 0
 }
=20
+_check_reiserfs_filesystem()
+{
+    device=3D$1
+
+    # If type is set, we're mounted
+    type=3D`_fs_type $device`
+    ok=3D1
+
+    if [ "$type" =3D "$FSTYP" ]
+    then
+        # mounted ...
+        mountpoint=3D`_umount_or_remount_ro $device`
+    fi
+=09
+	reiserfsck --yes $device >$tmp.fsck 2>&1
+    if [ $? -ne 0 ]
+    then
+        echo "_check_reiserfs_filesystem: filesystem on $device is inconsi=
stent (see $seq.full)"
+
+        echo "_check_reiserfs_filesystem: filesystem on $device is inconsi=
stent" >>$here/$seq.full
+        echo "*** reiserfsck output ***"                          >>$here/=
$seq.full
+        cat $tmp.fsck                                         >>$here/$seq=
=2Efull
+        echo "*** end reiserfsck output"                          >>$here/=
$seq.full
+
+        ok=3D0
+    fi
+    rm -f $tmp.fsck
+
+    if [ $ok -eq 0 ]
+    then
+        echo "*** mount output ***"                           >>$here/$seq=
=2Efull
+        _mount                                                >>$here/$seq=
=2Efull
+        echo "*** end mount output"                           >>$here/$seq=
=2Efull
+    elif [ "$type" =3D "$FSTYP" ]
+    then
+	# was mounted ...
+	_mount_or_remount_rw "$MOUNT_OPTIONS" $device $mountpoint
+	ok=3D$?
+    fi
+
+    [ $ok -eq 0 ] && exit 1
+    return 0
+}
+
 # run xfs_check and friends on a FS.
=20
 _check_xfs_filesystem()
@@ -1082,6 +1126,9 @@ _check_test_fs()
     ext2|ext3|ext4)
 	_check_extN_filesystem $TEST_DEV
 	;;
+	reiserfs)
+	_check_reiserfs_filesystem $TEST_DEV
+	;;
     *)
 	_check_generic_filesystem $TEST_DEV
 	;;
=2D-=20
1.6.2.5


--Boundary-00=_cberKRcYC4qt/nD
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--Boundary-00=_cberKRcYC4qt/nD--
