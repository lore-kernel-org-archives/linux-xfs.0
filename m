Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 858387F9D
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 00:01:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F148AAC006
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 22:01:18 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AxDYd6G6rcUT5Rss for <xfs@oss.sgi.com>;
	Wed, 09 Apr 2014 22:01:17 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WY76e-0004cB-O0
	for xfs@oss.sgi.com; Thu, 10 Apr 2014 15:00:56 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WY76e-0002CR-NI
	for xfs@oss.sgi.com; Thu, 10 Apr 2014 15:00:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] xfs: zeroing space needs to punch delalloc blocks
Date: Thu, 10 Apr 2014 15:00:51 +1000
Message-Id: <1397106053-7489-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1397106053-7489-1-git-send-email-david@fromorbit.com>
References: <1397106053-7489-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When we are zeroing space andit is covered by a delalloc range, we
need to punch the delalloc range out before we truncate the page
cache. Failing to do so leaves and inconsistency between the page
cache and the extent tree, which we later trip over when doing
direct IO over the same range.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 13 ++++++++++++-
 fs/xfs/xfs_trace.h     |  1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 01f6a64..3235b74 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1418,6 +1418,8 @@ xfs_zero_file_space(
 	xfs_off_t		end_boundary;
 	int			error;
 
+	trace_xfs_zero_file_space(ip);
+
 	granularity = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
 
 	/*
@@ -1432,9 +1434,18 @@ xfs_zero_file_space(
 	ASSERT(end_boundary <= offset + len);
 
 	if (start_boundary < end_boundary - 1) {
-		/* punch out the page cache over the conversion range */
+		/*
+		 * punch out delayed allocation blocks and the page cache over
+		 * the conversion range
+		 */
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		error = xfs_bmap_punch_delalloc_range(ip,
+				XFS_B_TO_FSB(mp, start_boundary),
+				XFS_B_TO_FSB(mp, end_boundary - start_boundary));
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		truncate_pagecache_range(VFS_I(ip), start_boundary,
 					 end_boundary - 1);
+
 		/* convert the blocks */
 		error = xfs_alloc_file_space(ip, start_boundary,
 					end_boundary - start_boundary - 1,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a4ae41c..65d8c79 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -603,6 +603,7 @@ DEFINE_INODE_EVENT(xfs_readlink);
 DEFINE_INODE_EVENT(xfs_inactive_symlink);
 DEFINE_INODE_EVENT(xfs_alloc_file_space);
 DEFINE_INODE_EVENT(xfs_free_file_space);
+DEFINE_INODE_EVENT(xfs_zero_file_space);
 DEFINE_INODE_EVENT(xfs_collapse_file_space);
 DEFINE_INODE_EVENT(xfs_readdir);
 #ifdef CONFIG_XFS_POSIX_ACL
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
