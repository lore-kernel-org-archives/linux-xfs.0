Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 11CF429E09
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 15:23:36 -0600 (CST)
Message-Id: <20131206212037.475868363@sgi.com>
Date: Fri, 06 Dec 2013 15:20:28 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 1/2] xfs: fix double free on error when cleaning log items
References: <20131206212027.846346746@sgi.com>
Content-Disposition: inline;
	filename=xfs-fix-double-free-on-error-when-cleanning-log_items.patch
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

Commit 2a84108 cleans the remaining pending log item entries
when log recovery fails. Unfortunately, the cleaning call was
not removed from the error path in xlog_recover_commit_trans,
This can result in a use after free and a second free of the
transaction structure when the cleaning is done in
xlog_recover_process_data.

Now the log item entry cleaning in xlog_recover_commit_trans
is only performed for the non-error case.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_log_recover.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3509,9 +3509,10 @@ out:
 	if (!list_empty(&done_list))
 		list_splice_init(&done_list, &trans->r_itemq);
 
-	xlog_recover_free_trans(trans);
-
 	error2 = xfs_buf_delwri_submit(&buffer_list);
+	/* caller will free transactions in the error path */
+	if (!error && !error2)
+		xlog_recover_free_trans(trans);
 	return error ? error : error2;
 }
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
