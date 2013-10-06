Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 212847F54
	for <xfs@oss.sgi.com>; Sat,  5 Oct 2013 21:57:05 -0500 (CDT)
Received: from eagdhcp-232-165.americas.sgi.com
	(eagdhcp-232-165.americas.sgi.com [128.162.232.165])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F0C7A304059
	for <xfs@oss.sgi.com>; Sat,  5 Oct 2013 19:57:01 -0700 (PDT)
Received: from eagdhcp-232-165.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-165.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r962v1ed002599
	for <xfs@oss.sgi.com>; Sat, 5 Oct 2013 21:57:01 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-165.americas.sgi.com)
Message-Id: <20131006025306.613219691@sgi.com>
Date: Sat, 05 Oct 2013 21:51:52 -0500
From: tinguely@sgi.com
Subject: [PATCH 1/2] xfsprogs: fix leak in xfs_log_recover_add_to_trans
References: <20131006025151.573856006@sgi.com>
Content-Disposition: inline;
	filename=xfsprogs-fix-memory-leak-in-xlog_recover_add_to_trans.patch
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
Found by Coverity (134683).

 libxlog/xfs_log_recover.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/libxlog/xfs_log_recover.c
===================================================================
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -1131,6 +1131,7 @@ xlog_recover_add_to_trans(
 		"bad number of regions (%d) in inode log format",
 				  in_f->ilf_size);
 			ASSERT(0);
+			kmem_free(ptr);
 			return XFS_ERROR(EIO);
 		}
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
