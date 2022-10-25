Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA745C38A2D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 08:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiJYIxm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 04:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiJYIxm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 04:53:42 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A52127414
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 01:53:39 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MxQb219MKzmVJ9;
        Tue, 25 Oct 2022 16:48:46 +0800 (CST)
Received: from localhost.localdomain (10.175.127.227) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 16:53:37 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <leo.lilong@huawei.com>
CC:     <billodo@redhat.com>, <chandan.babu@oracle.com>,
        <dchinner@redhat.com>, <djwong@kernel.org>, <guoxuenan@huawei.com>,
        <houtao1@huawei.com>, <linux-xfs@vger.kernel.org>,
        <sandeen@redhat.com>, <yi.zhang@huawei.com>
Subject: [PATCH v2] xfs: fix sb write verify for lazysbcount
Date:   Tue, 25 Oct 2022 17:15:27 +0800
Message-ID: <20221025091527.377976-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221022020345.GA2699923@ceph-admin>
References: <20221022020345.GA2699923@ceph-admin>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

This will make the file system unmountable, the cause of the problem is
that during the log recovery process, incorrect count (ifree > icount)
are recovered from the log and fail to pass the boundary check in
xfs_validate_sb_write(). The following script can reproduce the problem,
but it may take a long time.

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
m_ifree, this will make the m_ifree greater than m_icount and written to
the log. For example consider the following sequence:

 CPU0				 CPU1
 xfs_log_sb			 xfs_trans_unreserve_and_mod_sb
 ----------			 ------------------------------
 percpu_counter_sum(&mp->m_icount)
				 percpu_counter_add(&mp->m_icount, idelta)
				 percpu_counter_add_batch(&mp->m_icount,
						idelta, XFS_ICOUNT_BATCH)
 percpu_counter_sum(&mp->m_ifree)

If we have an unclean shutdown, this will be corrected by
xfs_initialize_perag_data() rebuilding the counters from the AGF block
counts, and the correction is later than log recovery. During log recovery,
incorrect ifree/icount may be restored from the log and written sb, since
ifree and icount have not been corrected at this time, sb write check
will fail due to ifree > icount.

Guaranteed that ifree will never be logged as being greater than icount.
Neither icount or ifree will be accurate if we are racing with other
updates, but it will guarantee that what we write to the journal
won't trigger corruption warnings.

Fixes: 8756a5af1819 ("libxfs: add more bounds checking to sb sanity checks")
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
v2:
- Add scripts that could reproduce the problem
- Guaranteed that ifree will never be logged as being greater than icount

 fs/xfs/libxfs/xfs_sb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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
 
-- 
2.31.1

