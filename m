Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 905A67F69
	for <xfs@oss.sgi.com>; Tue,  2 Jul 2013 14:17:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7E35930408C
	for <xfs@oss.sgi.com>; Tue,  2 Jul 2013 12:17:25 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id NMLmqYEGOTq31l4O (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jul 2013 12:17:21 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 2005B9A06AA
	for <xfs@oss.sgi.com>; Tue,  2 Jul 2013 13:17:21 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: make the scratch device for generic/256 slightly
	larger
Date: Tue, 2 Jul 2013 15:17:18 -0400
Message-ID: <1372792638-23957-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

This is similar to a previous fix I sent.  1 gig makes us do mixed file block
groups for btrfs, so these enospc tests will usually fail because we don't have
space for metadata, which is the case for this test.  So jack the size up to
1.5gig so that btrfs can do its normal thing and pass the test.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/generic/256 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tests/generic/256 b/tests/generic/256
index 4a53da8..cfe7237 100755
--- a/tests/generic/256
+++ b/tests/generic/256
@@ -165,7 +165,7 @@ _test_full_fs_punch()
 
 # Make a small file system to fill
 umount $SCRATCH_DEV &> /dev/null
-_scratch_mkfs_sized $(( 1024 * 1024 * 1024 )) &> /dev/null
+_scratch_mkfs_sized $(( 1536 * 1024 * 1024 )) &> /dev/null
 _scratch_mount
 # Test must be able to write files with non-root permissions
 chmod 777 $SCRATCH_MNT
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
