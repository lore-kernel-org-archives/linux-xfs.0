Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9CC747F3F
	for <xfs@oss.sgi.com>; Fri, 17 Apr 2015 02:40:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 36598AC003
	for <xfs@oss.sgi.com>; Fri, 17 Apr 2015 00:40:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LITQERBFNq7t0EHV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Apr 2015 00:40:35 -0700 (PDT)
From: xuw2015@gmail.com
Subject: [PATCH v2] xfs: use percpu_counter_read_positive for mp->m_icount
Date: Fri, 17 Apr 2015 15:40:23 +0800
Message-Id: <1429256423-9809-1-git-send-email-xuw2015@gmail.com>
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
Cc: George Wang <xuw2015@gmail.com>

From: George Wang <xuw2015@gmail.com>

Function percpu_counter_read just return the current counter, which can be
negative. This will cause the checking of "allocated inode
counts <= m_maxicount" false positive. Use percpu_counter_read_positive can
solve this problem, and be consistent with the purpose to introduce percpu
mechanism to xfs.

Signed-off-by: George Wang <xuw2015@gmail.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 07349a1..1c9e755 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -376,7 +376,7 @@ xfs_ialloc_ag_alloc(
 	 */
 	newlen = args.mp->m_ialloc_inos;
 	if (args.mp->m_maxicount &&
-	    percpu_counter_read(&args.mp->m_icount) + newlen >
+	    percpu_counter_read_positive(&args.mp->m_icount) + newlen >
 							args.mp->m_maxicount)
 		return -ENOSPC;
 	args.minlen = args.maxlen = args.mp->m_ialloc_blks;
@@ -1339,10 +1339,13 @@ xfs_dialloc(
 	 * If we have already hit the ceiling of inode blocks then clear
 	 * okalloc so we scan all available agi structures for a free
 	 * inode.
+	 *
+	 * Read rough value of mp->m_icount by percpu_counter_read_positive,
+	 * which will sacrifice the preciseness but improve the performance.
 	 */
 	if (mp->m_maxicount &&
-	    percpu_counter_read(&mp->m_icount) + mp->m_ialloc_inos >
-							mp->m_maxicount) {
+	    percpu_counter_read_positive(&mp->m_icount) + mp->m_ialloc_inos
+							> mp->m_maxicount) {
 		noroom = 1;
 		okalloc = 0;
 	}
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
