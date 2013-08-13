Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2359F7F51
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 00:31:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F1D708F8064
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 22:31:36 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id tnkmFvrdLkjcsLvu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 22:31:35 -0700 (PDT)
Message-ID: <5209C4D0.5050203@oracle.com>
Date: Tue, 13 Aug 2013 13:32:00 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: call roundup_64() to calculate the min_logblks
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: kbuild test robot <fengguang.wu@intel.com>

From: Jie Liu <jeff.liu@oracle.com>

Replace roundup() with roundup_64() as we calculate min_logblks
with 64-bit divisions.  Hence, call roundup() will cause the
following error while compiling a 32-bit kernel:

fs/built-in.o: In function `xfs_log_calc_minimum_size':
fs/xfs/xfs_log_rlimit.c:140: undefined reference to `__udivdi3'

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_log_rlimit.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_rlimit.c b/fs/xfs/xfs_log_rlimit.c
index 6b17ef4..bbcec0b 100644
--- a/fs/xfs/xfs_log_rlimit.c
+++ b/fs/xfs/xfs_log_rlimit.c
@@ -136,10 +136,12 @@ xfs_log_calc_minimum_size(
 	 * Also, the log size should be a multiple of the log stripe unit, round
 	 * it up to lsunit boundary if lsunit is specified.
 	 */
-	if (lsunit)
-		min_logblks = roundup(BTOBB(max_logres), lsunit) + 2 * lsunit;
-	else
+	if (lsunit) {
+		min_logblks = roundup_64(BTOBB(max_logres), lsunit) +
+			      2 * lsunit;
+	} else
 		min_logblks = BTOBB(max_logres) + 2 * BBSIZE;
 	min_logblks *= XFS_MIN_LOG_FACTOR;
+
 	return XFS_BB_TO_FSB(mp, min_logblks);
 }
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
