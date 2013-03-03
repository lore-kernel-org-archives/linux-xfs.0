Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8282E800C
	for <xfs@oss.sgi.com>; Sat,  2 Mar 2013 18:06:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 639C08F8049
	for <xfs@oss.sgi.com>; Sat,  2 Mar 2013 16:06:08 -0800 (PST)
Received: from radon.swed.at (a.ns.miles-group.at [95.130.255.143]) by
	cuda.sgi.com with ESMTP id bvcdqoZm4w1X6n9v (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 02 Mar 2013 16:06:03 -0800 (PST)
From: Richard Weinberger <richard@nod.at>
Subject: [PATCH] Do not check ocfs2
Date: Sun,  3 Mar 2013 01:05:50 +0100
Message-Id: <1362269150-21478-1-git-send-email-richard@nod.at>
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
Cc: linux-fsdevel@vger.kernel.org, Richard Weinberger <richard@nod.at>

We cannot run fsck.ocfs2 because the file system
is most likely mounted on another node.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 common.rc | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/common.rc b/common.rc
index f5180fe..00c075d 100644
--- a/common.rc
+++ b/common.rc
@@ -1419,6 +1419,9 @@ _check_test_fs()
     udf)
 	# do nothing for now
 	;;
+    ocfs2)
+	# other nodes may have mounted the fs
+	;;
     btrfs)
 	_check_btrfs_filesystem $TEST_DEV
 	;;
@@ -1448,6 +1451,9 @@ _check_scratch_fs()
     nfs*)
 	# Don't know how to check an NFS filesystem, yet.
 	;;
+    ocfs2)
+	# other nodes may have mounted the fs
+	;;
     btrfs)
 	_check_btrfs_filesystem $SCRATCH_DEV
 	;;
-- 
1.8.1.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
