Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3D3DB7F4E
	for <xfs@oss.sgi.com>; Thu, 12 Sep 2013 09:05:52 -0500 (CDT)
Message-Id: <20130912140127.489098296@sgi.com>
Date: Thu, 12 Sep 2013 09:01:23 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfs: remove dead code from xlog_recover_inode_pass2
References: <20130912140122.873071199@sgi.com>
Content-Disposition: inline;
	filename=xfs-remove-dead-code-xlog_recover_inode_pass2.patch
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
Cc: Dan Carpenter <dan.carpenter@oracle.com>

Additional code in the error handler of xlog_recover_inode_pass2()
results in the following error:

static checker warning: "fs/xfs/xfs_log_recover.c:2999
xlog_recover_inode_pass2()
	 info: ignoring unreachable code."

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_log_recover.c |    3 ---
 1 file changed, 3 deletions(-)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2995,9 +2995,6 @@ error:
 	if (need_free)
 		kmem_free(in_f);
 	return XFS_ERROR(error);
-
-	xfs_buf_relse(bp);
-	goto error;
 }
 
 /*


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
