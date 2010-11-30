Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAULwWlk143107 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 15:58:33 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B72C01401053
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 14:00:15 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PhyAMzKTwYGclSSV for
	<xfs@oss.sgi.com>; Tue, 30 Nov 2010 14:00:15 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAUM0EDP028020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 17:00:14 -0500
Received: from localhost.localdomain (test1244.test.redhat.com [10.10.10.244])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id oAUM0DRr029216
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 17:00:14 -0500
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Xfstests: make _scratch_mkfs_sized work for btrfs
Date: Tue, 30 Nov 2010 16:50:39 -0500
Message-Id: <1291153839-12317-1-git-send-email-josef@redhat.com>
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

This patch simply makes _scratch_mkfs_sized work right for btrfs.  I've run a
few of the tests that use _scratch_mkfs_sized (204 and 226) and everything seems
to work right now.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 common.rc |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/common.rc b/common.rc
index 459bdf5..58e7318 100644
--- a/common.rc
+++ b/common.rc
@@ -329,6 +329,9 @@ _scratch_mkfs_sized()
     ext2|ext3|ext4)
 	/sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
 	;;
+     btrfs)
+	/sbin/mkfs.$FSTYP $MKFS_OPTIONS $SCRATCH_DEV -b $fssize
+	;;
     *)
 	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
 	;;
-- 
1.6.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
