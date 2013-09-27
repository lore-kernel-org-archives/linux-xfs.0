Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2AA417F53
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 09:02:09 -0500 (CDT)
Received: from eagdhcp-232-140.americas.sgi.com
	(eagdhcp-232-140.americas.sgi.com [128.162.232.140])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 090C38F8064
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 07:02:06 -0700 (PDT)
Received: from eagdhcp-232-140.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-140.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r8RE25RI003188
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 09:02:05 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-140.americas.sgi.com)
Message-Id: <20130927140104.515578025@sgi.com>
Date: Fri, 27 Sep 2013 09:00:55 -0500
From: tinguely@sgi.com
Subject: [PATCH] xfs: fix memory leak in xlog_recover_add_to_trans
Content-Disposition: inline;
	filename=xfs-fix-leak-in-xlog_recover_add_to_trans.patch
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

Free the memory in error path of xlog_recover_add_to_trans().
Normally this memory is freed in recovery pass2, but is leaked
in the error path.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
Found by Coverity (134683) in userspace, same patch applies there
also.
 fs/xfs/xfs_log_recover.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1585,6 +1585,7 @@ xlog_recover_add_to_trans(
 		"bad number of regions (%d) in inode log format",
 				  in_f->ilf_size);
 			ASSERT(0);
+			free(ptr);
 			return XFS_ERROR(EIO);
 		}
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
