Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49622 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727004AbeILL1e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Sep 2018 07:27:34 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8C6JcXJ017341
        for <linux-xfs@vger.kernel.org>; Wed, 12 Sep 2018 02:24:34 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2metq5wf92-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Sep 2018 02:24:34 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 12 Sep 2018 02:24:32 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V3 10/19] xfs/325: Inject free_extent error after CoW operation
Date: Wed, 12 Sep 2018 11:56:17 +0530
In-Reply-To: <20180912062626.14349-1-chandan@linux.vnet.ibm.com>
References: <20180912062626.14349-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180912062626.14349-11-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, guaneryu@gmail.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

On a 64k blocksized filesystem, when the test CoWs the file2's offset
range [10 * 64k, 19 * 64k], the call to xfs_bmapi_reserve_delalloc()
allocates 32 64k blocks. This is because XFS_DEFAULT_COWEXTSZ_HINT has
the value of 32 and xfs_get_cowextsz_hint() uses this to compute the
extent alignment. This leads to xfs_bmapi_reserve_delalloc() to reserve
space corresponding to the file range [0, 32 * 64k] in the inode's
cow fork area. On completion of write I/O corresponding to file2's range
[10 * 64k, 19 * 64k], xfs_end_io() moves 10 out of the originally
allocated 32 64k blocks to the data fork area. The remaining 22 64k
blocks linger on in cow fork area of the inode.

Later, when servicing the exit() syscall for the xfs_io process,
xfs_free_eofblocks() ends up invoking xfs_reflink_cancel_cow_blocks()
since i_delayed_blks has the value 22. xfs_reflink_cancel_cow_blocks()
indirectly invokes __xfs_free_extent() which returns EIO since
XFS_ERRTAG_FREE_EXTENT has been set. This leads to the filesystem to be
shutdown. The "rm" command invoked later ends up returning an
error and hence the test fails. The test actually requires that the
filesystem gets shutdown when executing the "rm" command.

To fix the problem, this commit injects the free_extent error after we
CoW file2's [10 * 64k, 19 * 64k] range.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/xfs/325     | 5 +++--
 tests/xfs/325.out | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/325 b/tests/xfs/325
index b156de9..6795901 100755
--- a/tests/xfs/325
+++ b/tests/xfs/325
@@ -54,11 +54,12 @@ echo "Check files"
 md5sum $SCRATCH_MNT/file1 | _filter_scratch
 md5sum $SCRATCH_MNT/file2 | _filter_scratch
 
+echo "CoW a few blocks"
+$XFS_IO_PROG -c "pwrite -W -S 0x67 $((10 * blksz)) $((10 * blksz))" $SCRATCH_MNT/file2 >> $seqres.full
+
 echo "Inject error"
 _scratch_inject_error "free_extent"
 
-echo "CoW a few blocks"
-$XFS_IO_PROG -c "pwrite -W -S 0x67 $((10 * blksz)) $((10 * blksz))" $SCRATCH_MNT/file2 >> $seqres.full
 rm $SCRATCH_MNT/file1
 sync
 
diff --git a/tests/xfs/325.out b/tests/xfs/325.out
index 4e25d2b..92027cd 100644
--- a/tests/xfs/325.out
+++ b/tests/xfs/325.out
@@ -4,8 +4,8 @@ Create files
 Check files
 d5a0ed0305c8df4180cb2bf975ecffe8  SCRATCH_MNT/file1
 d5a0ed0305c8df4180cb2bf975ecffe8  SCRATCH_MNT/file2
-Inject error
 CoW a few blocks
+Inject error
 FS should be shut down, touch will fail
 touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
 Remount to replay log
-- 
2.9.5
