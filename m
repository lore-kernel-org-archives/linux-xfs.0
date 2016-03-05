Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 57D0C7CA3
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 18:37:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2BB62304032
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 16:37:38 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 6OLU4ecotbZUW93W (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 16:37:37 -0800 (PST)
Subject: [PATCH 01/12] xfs/207: fix golden output to match FS_IOC_FSSETXATTR
	hoist
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Mar 2016 16:37:24 -0800
Message-ID: <20160305003724.28738.94718.stgit@birch.djwong.org>
In-Reply-To: <20160305003717.28738.98818.stgit@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/207.out |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/207.out b/tests/xfs/207.out
index 14eede4..434b8d9 100644
--- a/tests/xfs/207.out
+++ b/tests/xfs/207.out
@@ -3,7 +3,7 @@ Format and mount
 Create the original files
 Set extsz and cowextsz on zero byte file
 Set extsz and cowextsz on 1Mbyte file
-xfs_io: XFS_IOC_FSSETXATTR SCRATCH_MNT/test-207/file2: Invalid argument
+xfs_io: FS_IOC_FSSETXATTR SCRATCH_MNT/test-207/file2: Invalid argument
 Check extsz and cowextsz settings on zero byte file
 [1048576] SCRATCH_MNT/test-207/file1
 [1048576] SCRATCH_MNT/test-207/file1
@@ -11,8 +11,8 @@ Check extsz and cowextsz settings on 1Mbyte file
 [0] SCRATCH_MNT/test-207/file2
 [1048576] SCRATCH_MNT/test-207/file2
 Set cowextsize and check flag
-fsxattr.xflags = 0x20000 [---------------C]
+fsxattr.xflags = 0x20000 [----------------C]
 [1048576] SCRATCH_MNT/test-207/file3
 Unset cowextsize and check flag
-fsxattr.xflags = 0x0 [----------------]
+fsxattr.xflags = 0x0 [-----------------]
 [0] SCRATCH_MNT/test-207/file3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
