Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 742127F50
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 20:57:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4392F304053
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 18:57:45 -0800 (PST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [119.145.14.64])
	by cuda.sgi.com with ESMTP id uR9EDo4zDpqkvtY4 (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Feb 2014 18:57:43 -0800 (PST)
Message-ID: <530C069A.8060800@huawei.com>
Date: Tue, 25 Feb 2014 10:57:30 +0800
From: ZhangZhen <zhenzhang.zhang@huawei.com>
MIME-Version: 1.0
Subject: [PATCH v2] xfstests: fix to make tests/btrfs/013 work using all
	version btrfs progs
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
To: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Cc: du.duyongfeng@huawei.com, Wang Shilong <wangsl.fnst@cn.fujitsu.com>

The test 013 couldn't work using some old version btrfs progs
e.g.(btrfs progs v0.19 openSUSE 12.3)because here lacked "start".
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
