Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0E2F67F4E
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 14:18:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F0B5230407E
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 12:18:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uwiemdgF8LA9XEkt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 12:18:19 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix double free of trans in log recovery on I/O error
Date: Thu, 21 Aug 2014 15:18:12 -0400
Message-Id: <1408648692-15957-1-git-send-email-bfoster@redhat.com>
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
Cc: alex@zadarastorage.com

XFS log recovery builds up an xlog_recover object as it passes through
the log operations on the physical log. These structures are managed via
a hash table and are allocated when a new transaction is encountered and
freed once a commit operation for the transaction is encountered.

This state machine for active transactions is implemented by a
combination of xlog_do_recovery_pass(), which walks through the log
buffers and xlog_recover_process_data() which processes log operations
within each buffer. The latter function decides whether to allocate a
new xlog_recover, add to it or commit and ultimately free it.  If an
error occurs at any point during the lifecycle of a particular
xlog_recover, xlog_recover_process_data() frees the object and returns
an error.

xlog_recover_commit_trans() handles the final processing of the
transaction. It submits whatever I/O is required for the transaction and
frees xlog_recover object along with the transaction items it tracks. If
an error occurs at the final stages of the commit operation, such as I/O
failure, both xlog_recover_commit_trans() and
xlog_recover_process_data() attempt to free the trans object.

Modify xlog_recover_commit_trans() to only free the trans object on
successful completion of the trans, including any I/O errors that might
occur when recovering the log.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

I found that the recent buffer I/O rework fixes didn't address the crash
reproduced by the dm-flakey/log recovery test case I posted recently. I
tracked the crash down to this, which allows the test to pass. This
addresses the crash I saw when running the reproducer manually with the
metadump that Alex posted as well.

FWIW, I also went back and tested the xfs_buf_iowait() experiment in
both scenarios (Alex's metadump and xfstests test) and they all
reproduce the same crash for me. I think that either I'm still not
reproducing the original problem, something else might have contaminated
the original xfs_buf_iowait() test to give a false positive, or
something else entirely is going on.

Alex,

If you have a chance, I think it might be interesting to see whether you
reproduce any problems with this patch. It looks like this is a
regression introduced by:

	2a84108f xfs: free the list of recovery items on error

... but I have no idea if that's in whatever kernel you're running.

Brian

 fs/xfs/xfs_log_recover.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 176c4b3..daca9a6 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3528,10 +3528,15 @@ out:
 	if (!list_empty(&done_list))
 		list_splice_init(&done_list, &trans->r_itemq);
 
-	xlog_recover_free_trans(trans);
-
 	error2 = xfs_buf_delwri_submit(&buffer_list);
-	return error ? error : error2;
+
+	if (!error)
+		error = error2;
+	/* caller frees trans on error */
+	if (!error)
+		xlog_recover_free_trans(trans);
+
+	return error;
 }
 
 STATIC int
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
