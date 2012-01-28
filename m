Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0SAt3oF107107 for <xfs@oss.sgi.com>; Sat, 28 Jan 2012 04:55:03 -0600
Date: Sat, 28 Jan 2012 13:55:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] xfs: remove an unneeded NULL check
Message-ID: <20120128105501.GB25092@elgon.mountain>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs-masters@oss.sgi.com, Alex Elder <elder@kernel.org>, kernel-janitors@vger.kernel.org, xfs@oss.sgi.com

Smatch complains because we check "commit_lsn" for NULL inconsistently.
fs/xfs/xfs_log_cil.c +705 xfs_log_commit_cil(43) error: we previously
	assumed 'commit_lsn' could be null (see line 688)
xfs_log_commit_cil() is only called from one place, and "commit_lsn" is
a valid pointer, so I've removed the NULL check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index d4fadbe..d9c4652 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -685,8 +685,7 @@ xfs_log_commit_cil(
 
 	/* lock out background commit */
 	down_read(&log->l_cilp->xc_ctx_lock);
-	if (commit_lsn)
-		*commit_lsn = log->l_cilp->xc_ctx->sequence;
+	*commit_lsn = log->l_cilp->xc_ctx->sequence;
 
 	xlog_cil_insert_items(log, log_vector, tp->t_ticket);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
