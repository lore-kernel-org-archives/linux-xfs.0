Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 712527F3F
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 21:22:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 444D9304039
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 19:22:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Jl5nZLNyKNgX4KkV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Apr 2015 19:22:32 -0700 (PDT)
From: xuw2015@gmail.com
Subject: [PATCH] xfs: use percpu_counter_compare instead of naive comparing
Date: Fri, 17 Apr 2015 10:22:24 +0800
Message-Id: <1429237344-5668-1-git-send-email-xuw2015@gmail.com>
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

Function percpu_counter_read just return the current counter, regardless of
every cpu's count. This counter can be negative value, which will cause the
checking of "allocated inode counts <= m_maxicount" false positive.
Commit 501ab3238753 "xfs: use generic percpu counters for inode counter
" introduced this problem.
Use the percpu_counter_compare, which will first do stuff in current cpu for
performance; if can not get the result, it will get the exactly counter
based on the count of every cpu.

Signed-off-by: George Wang <xuw2015@gmail.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 07349a1..af9e7d2 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -376,8 +376,8 @@ xfs_ialloc_ag_alloc(
 	 */
 	newlen = args.mp->m_ialloc_inos;
 	if (args.mp->m_maxicount &&
-	    percpu_counter_read(&args.mp->m_icount) + newlen >
-							args.mp->m_maxicount)
+	    percpu_counter_compare(&args.mp->m_icount,
+					args.mp->m_maxicount - newlen) > 0)
 		return -ENOSPC;
 	args.minlen = args.maxlen = args.mp->m_ialloc_blks;
 	/*
@@ -1341,8 +1341,8 @@ xfs_dialloc(
 	 * inode.
 	 */
 	if (mp->m_maxicount &&
-	    percpu_counter_read(&mp->m_icount) + mp->m_ialloc_inos >
-							mp->m_maxicount) {
+	    percpu_counter_compare(&mp->m_icount,
+				mp->m_maxicount - mp->m_ialloc_inos) > 0) {
 		noroom = 1;
 		okalloc = 0;
 	}
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
