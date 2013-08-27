Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9D4477F3F
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 22:25:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 24FF3AC006
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 20:25:49 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZPepPkEHSUaZ20SJ for <xfs@oss.sgi.com>;
	Mon, 26 Aug 2013 20:25:47 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VE9uZ-0001Kc-Id
	for xfs@oss.sgi.com; Tue, 27 Aug 2013 13:25:43 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VE9uZ-0006iE-HY
	for xfs@oss.sgi.com; Tue, 27 Aug 2013 13:25:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix bad dquot buffer size in log recovery readahead
Date: Tue, 27 Aug 2013 13:25:43 +1000
Message-Id: <1377573943-25770-1-git-send-email-david@fromorbit.com>
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

xfstests xfs/087 fails 100% reliably with this assert:

XFS (vdb): Mounting Filesystem
XFS (vdb): Starting recovery (logdev: internal)
XFS: Assertion failed: bp->b_flags & XBF_STALE, file: fs/xfs/xfs_buf.c, line: 548

while trying to read a dquot buffer in xlog_recover_dquot_ra_pass2().

The issue is that the buffer length to read that is passed to
xfs_buf_readahead is in units of filesystem blocks, not disk blocks.
(i.e. FSB, not daddr). Fix it but putting the correct conversion in
place.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ac9c18b..769c4a1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3202,7 +3202,7 @@ xlog_recover_dquot_ra_pass2(
 	ASSERT(dq_f->qlf_len == 1);
 
 	xfs_buf_readahead(mp->m_ddev_targp, dq_f->qlf_blkno,
-				dq_f->qlf_len, NULL);
+			  XFS_FSB_TO_BB(mp, dq_f->qlf_len), NULL);
 }
 
 STATIC void
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
