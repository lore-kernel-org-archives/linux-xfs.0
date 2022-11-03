Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 866E0C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 03:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbiKCD2a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Nov 2022 23:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiKCD0q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2022 23:26:46 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB1414D3C
        for <linux-xfs@vger.kernel.org>; Wed,  2 Nov 2022 20:26:44 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N2px73KCGzpW32;
        Thu,  3 Nov 2022 11:23:07 +0800 (CST)
Received: from localhost.localdomain (10.175.127.227) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 11:26:40 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <djwong@kernel.org>
CC:     <leo.lilong@huawei.com>, <billodo@redhat.com>,
        <chandan.babu@oracle.com>, <dchinner@redhat.com>,
        <guoxuenan@huawei.com>, <houtao1@huawei.com>,
        <linux-xfs@vger.kernel.org>, <sandeen@redhat.com>,
        <yi.zhang@huawei.com>
Subject: [PATCH v3] xfs: fix sb write verify for lazysbcount
Date:   Thu, 3 Nov 2022 11:47:36 +0800
Message-ID: <20221103034736.2604208-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When lazysbcount is enabled, fsstress and loop mount/unmount test report
the following problems:

XFS (loop0): SB summary counter sanity check failed
XFS (loop0): Metadata corruption detected at xfs_sb_write_verify+0x13b/0x460,
	xfs_sb block 0x0
XFS (loop0): Unmount and run xfs_repair
XFS (loop0): First 128 bytes of corrupted metadata buffer:
00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 28 00 00  XFSB.........(..
00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000020: 69 fb 7c cd 5f dc 44 af 85 74 e0 cc d4 e3 34 5a  i.|._.D..t....4Z
00000030: 00 00 00 00 00 20 00 06 00 00 00 00 00 00 00 80  ..... ..........
00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
00000050: 00 00 00 01 00 0a 00 00 00 00 00 04 00 00 00 00  ................
00000060: 00 00 0a 00 b4 b5 02 00 02 00 00 08 00 00 00 00  ................
00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 14 00 00 19  ................
XFS (loop0): Corruption of in-memory data (0x8) detected at _xfs_buf_ioapply
	+0xe1e/0x10e0 (fs/xfs/xfs_buf.c:1580).  Shutting down filesystem.
XFS (loop0): Please unmount the filesystem and rectify the problem(s)
XFS (loop0): log mount/recovery failed: error -117
XFS (loop0): log mount failed

This corruption will shutdown the file system and the file system will
no longer be mountable. The following script can reproduce the problem,
but it may take a long time.

 #!/bin/bash

 device=/dev/sda
 testdir=/mnt/test
 round=0

 function fail()
 {
	 echo "$*"
	 exit 1
 }

 mkdir -p $testdir
 while [ $round -lt 10000 ]
 do
	 echo "******* round $round ********"
	 mkfs.xfs -f $device
	 mount $device $testdir || fail "mount failed!"
	 fsstress -d $testdir -l 0 -n 10000 -p 4 >/dev/null &
	 sleep 4
	 killall -w fsstress
	 umount $testdir
	 xfs_repair -e $device > /dev/null
	 if [ $? -eq 2 ];then
		 echo "ERR CODE 2: Dirty log exception during repair."
		 exit 1
	 fi
	 round=$(($round+1))
 done

With lazysbcount is enabled, There is no additional lock protection for
reading m_ifree and m_icount in xfs_log_sb(), if other cpu modifies the
m_ifree, this will make the m_ifree greater than m_icount. For example,
consider the following sequence and ifreedelta is postive:

 CPU0				 CPU1
 xfs_log_sb			 xfs_trans_unreserve_and_mod_sb
 ----------			 ------------------------------
 percpu_counter_sum(&mp->m_icount)
				 percpu_counter_add_batch(&mp->m_icount,
						idelta, XFS_ICOUNT_BATCH)
				 percpu_counter_add(&mp->m_ifree, ifreedelta);
 percpu_counter_sum(&mp->m_ifree)

After this, incorrect inode count (sb_ifree > sb_icount) will be writen to
the log. In the subsequent writing of sb, incorrect inode count (sb_ifree >
sb_icount) will fail to pass the boundary check in xfs_validate_sb_write()
that cause the file system shutdown.

When lazysbcount is enabled, we don't need to guarantee that Lazy sb
counters are completely correct, but we do need to guarantee that sb_ifree
<= sb_icount. On the other hand, the constraint that m_ifree <= m_icount
must be satisfied any time that there /cannot/ be other threads allocating
or freeing inode chunks. If the constraint is violated under these
circumstances, sb_i{count,free} (the ondisk superblock inode counters)
maybe incorrect and need to be marked sick at unmount, the count will
be rebuilt on the next mount.

Fixes: 8756a5af1819 ("libxfs: add more bounds checking to sb sanity checks")
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
v3:
- Corrected the description of the cause of the problem 
- Add a check for m_icount and m_ifree at unmout
v2:
- Add scripts that could reproduce the problem
- Guaranteed that ifree will never be logged as being greater than icount

 fs/xfs/libxfs/xfs_sb.c |  4 +++-
 fs/xfs/xfs_mount.c     | 15 +++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a20cade590e9..1eeecf2eb2a7 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -972,7 +972,9 @@ xfs_log_sb(
 	 */
 	if (xfs_has_lazysbcount(mp)) {
 		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
-		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
+		mp->m_sb.sb_ifree = min_t(uint64_t,
+				percpu_counter_sum(&mp->m_ifree),
+				mp->m_sb.sb_icount);
 		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
 	}
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index e8bb3c2e847e..fb87ffb48f7f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -538,6 +538,20 @@ xfs_check_summary_counts(
 	return 0;
 }
 
+static void
+xfs_unmount_check(
+	struct xfs_mount	*mp)
+{
+	if (xfs_is_shutdown(mp))
+		return;
+
+	if (percpu_counter_sum(&mp->m_ifree) >
+			percpu_counter_sum(&mp->m_icount)) {
+		xfs_alert(mp, "ifree/icount mismatch at unmount");
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
+	}
+}
+
 /*
  * Flush and reclaim dirty inodes in preparation for unmount. Inodes and
  * internal inode structures can be sitting in the CIL and AIL at this point,
@@ -1077,6 +1091,7 @@ xfs_unmountfs(
 	if (error)
 		xfs_warn(mp, "Unable to free reserved block pool. "
 				"Freespace may not be correct on next mount.");
+	xfs_unmount_check(mp);
 
 	xfs_log_unmount(mp);
 	xfs_da_unmount(mp);
-- 
2.31.1

