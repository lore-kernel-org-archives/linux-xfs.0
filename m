Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7D5627F55
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 04:51:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B28B8F8035
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 02:51:46 -0800 (PST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
	by cuda.sgi.com with ESMTP id 0AsimnxDaMljUCnk (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Feb 2014 02:51:42 -0800 (PST)
Message-ID: <530B2418.20905@huawei.com>
Date: Mon, 24 Feb 2014 18:51:04 +0800
From: ZhangZhen <zhenzhang.zhang@huawei.com>
MIME-Version: 1.0
Subject: [PATCH for xfstests] xfstests: fix to make tests/btrfs/013 really work
References: <530AF3E3.9060202@huawei.com>
In-Reply-To: <530AF3E3.9060202@huawei.com>
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
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org

The test 013 couldn't work because here lacked "start".
This patch fix it.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 tests/btrfs/013 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/btrfs/013 b/tests/btrfs/013
index 7620fcc..fb81663 100644
--- a/tests/btrfs/013
+++ b/tests/btrfs/013
@@ -72,7 +72,7 @@ _check_csum_error()
 }
 $XFS_IO_PROG -f -c "falloc 0 1M" -c "pwrite 16k 8k" -c "fsync" \
 	$SCRATCH_MNT/foo > $seqres.full 2>&1
-$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT >> $seqres.full 2>&1 || \
+$BTRFS_UTIL_PROG filesystem balance start $SCRATCH_MNT >> $seqres.full 2>&1 || \
 	_fail "balance failed"
 _scratch_unmount
 _scratch_mount
-- 
1.8.1.4


.




_______________________________________________
kernel.openeuler mailing list
kernel.openeuler@huawei.com
http://rnd-openeuler.huawei.com/mailman/listinfo/kernel.openeuler





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
