Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 545237F54
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2015 08:18:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 35DC4304043
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2015 06:17:58 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NBLIpz0V12qXCC9l (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 18 Nov 2015 06:17:57 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 19FA946216
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2015 14:17:57 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [XFSTESTS 2/6] check: Enforce xfs filesystem recreation on $TEST_DEV
Date: Wed, 18 Nov 2015 15:17:45 +0100
Message-Id: <1447856269-7872-3-git-send-email-agruenba@redhat.com>
In-Reply-To: <1447856269-7872-1-git-send-email-agruenba@redhat.com>
References: <1447856269-7872-1-git-send-email-agruenba@redhat.com>
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
Cc: Andreas Gruenbacher <agruenba@redhat.com>

When recreating xfs filesystems on $TEST_DEV, pass option -f to enforce
the filesystem creation instead of refusing to overwrite existing xfs
filesystems.  We already do that for ext2/ext3/ext4 filesystems.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 common/rc | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/common/rc b/common/rc
index 4c2f42c..ce6ae3d 100644
--- a/common/rc
+++ b/common/rc
@@ -572,6 +572,9 @@ _test_mkfs()
     btrfs)
         $MKFS_BTRFS_PROG $MKFS_OPTIONS $* $TEST_DEV > /dev/null
 	;;
+    xfs)
+	$MKFS_PROG -t $FSTYP -- -f $MKFS_OPTIONS $* $TEST_DEV
+	;;
     ext2|ext3|ext4)
 	$MKFS_PROG -t $FSTYP -- -F $MKFS_OPTIONS $* $TEST_DEV
 	;;
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
