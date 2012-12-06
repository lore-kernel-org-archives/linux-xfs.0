Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB6Mb15w161652 for <xfs@oss.sgi.com>; Thu, 6 Dec 2012 16:37:01 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id E13GLoYbyjE0ouS9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Dec 2012 14:39:25 -0800 (PST)
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id C10DBA51B7
	for <xfs@oss.sgi.com>; Thu,  6 Dec 2012 23:39:23 +0100 (CET)
Message-ID: <50C11E95.4050502@suse.com>
Date: Thu, 06 Dec 2012 17:39:17 -0500
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: Fix re-use of EWOULDBLOCK during read on dm-mirror
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
To: xfs@oss.sgi.com

When using lvconvert to convert a linear mapping to a dm-raid1 mirror,
we encountered issues where the log would be flooded with messages like:

metadata I/O error: block 0xee7060 ("xfs_trans_read_buf") error 11 numblks 8

The cause is that dm-mirror (and striping, and others) will return
-EWOULDBLOCK for readahead requests while the mirror is rebuilding. XFS's
end_io routine caches the errno and then xfs_buf_iowait bails out early
when it encounters it after issuing the i/o request. The I/O eventually
succeeds and the endio routine resets bp->b_error, but the original read
request has already returned -EWOULDBLOCK to the user and added the log
message above to the kernel log, freaking everyone out.

This patch ignores EWOULDBLOCK when deciding whether to wait for the I/O
to complete and tries again, allowing the read to succeed as expected.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Reviewed-by: Rich Johnston <rjohnston@sgi.com>
---
 fs/xfs/xfs_buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1252,7 +1252,7 @@ xfs_buf_iowait(
 {
 	trace_xfs_buf_iowait(bp, _RET_IP_);
 
-	if (!bp->b_error)
+	if (!bp->b_error || bp->b_error == EWOULDBLOCK)
 		wait_for_completion(&bp->b_iowait);
 
 	trace_xfs_buf_iowait_done(bp, _RET_IP_);


-- 
Jeff Mahoney
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
