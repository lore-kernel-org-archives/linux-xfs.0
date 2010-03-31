Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2VNagqi066863 for <xfs@oss.sgi.com>; Wed, 31 Mar 2010 18:36:42 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 06CEA1DC91A0
	for <xfs@oss.sgi.com>; Wed, 31 Mar 2010 16:38:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ijh1tve6G5u6TBAv for
	<xfs@oss.sgi.com>; Wed, 31 Mar 2010 16:38:28 -0700 (PDT)
Received: from int-mx05.intmail.prod.int.phx2.redhat.com
	(int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2VNcRmv008049
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 31 Mar 2010 19:38:27 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2VNcNCD032684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 31 Mar 2010 19:38:27 -0400
Message-ID: <4BB3DCEF.8040704@redhat.com>
Date: Wed, 31 Mar 2010 18:38:23 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: exit non-0 if fs check fails
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
To: xfs-oss <xfs@oss.sgi.com>

Right now if any of the _check_scratch_fs tests etc fail,
the check script exits but with 0 status.

This change will cause the status to be non-0 so we can detect
the error.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(aside - we could make it 2 instead of 1, so that a calling script
could fsck and continue ... thoughts?)

diff --git a/common.rc b/common.rc
index 2103a77..301ae6a 100644
--- a/common.rc
+++ b/common.rc
@@ -959,6 +959,7 @@ _check_generic_filesystem()
         echo "*** mount output ***"                             >>$here/$seq.full
         _mount                                                  >>$here/$seq.full
         echo "*** end mount output"                             >>$here/$seq.full
+        status=1
     elif [ "$type" = "$FSTYP" ]
     then
 	# was mounted ...
@@ -1054,6 +1055,7 @@ _check_xfs_filesystem()
         echo "*** mount output ***"                             >>$here/$seq.full
         _mount                                                  >>$here/$seq.full
         echo "*** end mount output"                             >>$here/$seq.full
+        status=1
     elif [ "$type" = "xfs" ]
     then
 	_mount_or_remount_rw "$extra_mount_options" $device $mountpoint

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
