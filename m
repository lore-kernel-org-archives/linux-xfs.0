Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 41F5D7FBA
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 02:50:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C680DAC003
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 00:50:25 -0800 (PST)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id lk04WjQ5eivHuRuH (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Feb 2013 00:50:24 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/8] xfstests: get rid of hardcoded /sbin/mkfs
Date: Wed, 13 Feb 2013 12:49:57 +0400
Message-Id: <1360745403-6373-3-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1360745403-6373-1-git-send-email-dmonakhov@openvz.org>
References: <1360745403-6373-1-git-send-email-dmonakhov@openvz.org>
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
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org, dchinner@redhat.com


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 common.rc |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/common.rc b/common.rc
index f5027e7..196619d 100644
--- a/common.rc
+++ b/common.rc
@@ -334,7 +334,7 @@ _scratch_mkfs()
         $MKFS_BTRFS_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
 	;;
     *)
-	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV
+	$MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV
 	;;
     esac
 }
@@ -353,7 +353,7 @@ _scratch_mkfs_sized()
 	_scratch_mkfs_xfs -d size=$fssize -b size=$blocksize
 	;;
     ext2|ext3|ext4|ext4dev)
-	/sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+	$MKFS_PROG -t $FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
 	;;
     btrfs)
 	$MKFS_BTRFS_PROG $MKFS_OPTIONS -b $fssize $SCRATCH_DEV
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
