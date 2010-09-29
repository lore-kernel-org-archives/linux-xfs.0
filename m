Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8TEYwN5056285 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 09:34:58 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4322B1185DA0
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 07:49:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kHTXtPfIAEtz25eM for
	<xfs@oss.sgi.com>; Wed, 29 Sep 2010 07:49:03 -0700 (PDT)
Received: from int-mx08.intmail.prod.int.phx2.redhat.com
	(int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o8TEZuIR010519
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 10:35:56 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] xfstests: Use $MKFS_OPTIONS in _scratch_mkfs_*()
Date: Wed, 29 Sep 2010 16:35:51 +0200
Message-Id: <1285770951-27000-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1285770951-27000-1-git-send-email-lczerner@redhat.com>
References: <1285770951-27000-1-git-send-email-lczerner@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: lczerner@redhat.com, esandeen@redhat.com

Pass MKFS_OPTIONS to mkfs.$FSTYP in _scratch_mkfs_sized().
Preserve user defined MKFS_OPTIONS in _scratch_mkfs_geom().
---
 common.rc |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/common.rc b/common.rc
index 65989c1..52b7125 100644
--- a/common.rc
+++ b/common.rc
@@ -327,7 +327,7 @@ _scratch_mkfs_sized()
 	_scratch_mkfs_xfs -d size=$fssize -b size=$blocksize
 	;;
     ext2|ext3|ext4)
-	/sbin/mkfs.$FSTYP -b $blocksize $SCRATCH_DEV $blocks
+	/sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
 	;;
     *)
 	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
@@ -349,10 +349,10 @@ _scratch_mkfs_geom()
 
     case $FSTYP in
     xfs)
-	MKFS_OPTIONS="-b size=$blocksize, -d su=$sunit_bytes,sw=$swidth_mult"
+	MKFS_OPTIONS+="-b size=$blocksize, -d su=$sunit_bytes,sw=$swidth_mult"
 	;;
     ext4)
-	MKFS_OPTIONS="-b $blocksize -E stride=$sunit_blocks,stripe_width=$swidth_blocks"
+	MKFS_OPTIONS+="-b $blocksize -E stride=$sunit_blocks,stripe_width=$swidth_blocks"
 	;;
     *)
 	_notrun "can't mkfs $FSTYP with geometry"
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
