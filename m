Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 51EEE7CBF
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 20:26:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 32B1A304053
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 18:25:57 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	nJWQkBz4JVMFafrM for <xfs@oss.sgi.com>;
	Tue, 26 Feb 2013 18:25:55 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UAWiQ-00007e-Bo
	for xfs@oss.sgi.com; Wed, 27 Feb 2013 13:25:54 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UAWiQ-0002tf-7O
	for xfs@oss.sgi.com; Wed, 27 Feb 2013 13:25:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: don't verify buffers after IO errors
Date: Wed, 27 Feb 2013 13:25:54 +1100
Message-Id: <1361931954-11105-1-git-send-email-david@fromorbit.com>
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

When we read a buffer, we might get an error from the underlying
block device and not the real data. Hence if we get an IO error, we
shouldn't run the verifier but instead just pass the IO error
straight through.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4e8f0df..50eb603 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1022,7 +1022,9 @@ xfs_buf_iodone_work(
 	bool			read = !!(bp->b_flags & XBF_READ);
 
 	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
-	if (read && bp->b_ops)
+
+	/* only validate buffers that were read without errors */
+	if (read && bp->b_ops && !bp->b_error && (bp->b_flags & XBF_DONE))
 		bp->b_ops->verify_read(bp);
 
 	if (bp->b_iodone)
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
