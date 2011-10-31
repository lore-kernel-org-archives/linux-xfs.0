Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9VF32pm042502 for <xfs@oss.sgi.com>; Mon, 31 Oct 2011 10:03:02 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfstests: delay before dumps for incremental tests
Date: Mon, 31 Oct 2011 10:02:57 -0500
Message-Id: <1320073377-27783-1-git-send-email-wkendall@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

To get reproducible results when testing incremental backups, files
contained in a backup should not have the same timestamp (at second
resolution) as the backup itself. If they do, those files will also
be included in the incremental backup, and this will likely cause
issues in the expected output of the test. This patch adds a sleep
to test 024 prior to doing the level 0 backup. The other incremental
tests already include similar delays.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 024 |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/024 b/024
index de5ab5f..64b59bc 100755
--- a/024
+++ b/024
@@ -42,6 +42,8 @@ _supported_os Linux
 
 _require_tape $TAPE_DEV
 _create_dumpdir_fill
+# ensure file/dir timestamps precede dump timestamp
+sleep 2
 src/bstat $SCRATCH_MNT >>$here/$seq.full
 _erase_hard
 _do_dump
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
