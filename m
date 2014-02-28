Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AD1D27F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 18:54:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 808BE304059
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 16:54:05 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	OQmy07w35hCfBuw7 for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 16:53:59 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WJBhx-0001eZ-QE
	for xfs@oss.sgi.com; Fri, 28 Feb 2014 11:53:45 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WJBhx-0004Ij-Ow
	for xfs@oss.sgi.com; Fri, 28 Feb 2014 11:53:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] metadump: don't verify metadata being dumped
Date: Fri, 28 Feb 2014 11:53:45 +1100
Message-Id: <1393548825-16499-1-git-send-email-david@fromorbit.com>
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

The discontiguous buffer support series added a verifier check on
the metadata buffers before they go written to the metadump image.
If this failed, it returned an error, and the restul woul dbe that
we stopped processing the metadata and exited, resulting in a
truncated dump.

xfs_metadump is supposed to dump the metadata in the filesystem
for forensic analysis purposes, which means we actually want it to
retain any corruptions it finds in the filesystem. Hence running the
verifier - even to recalculate CRCs - is the wrong thing to be
doing. And stopping the dum pwhen we come across an error is even
worse.

Therefore remove the code tha truns the verifier and causes all
these problems and replace it with a comment explaining why we don't
want to run verifiers in the metadump process.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/metadump.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 5baf83d..c10e76a 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -190,6 +190,13 @@ write_buf_segment(
 	return 0;
 }
 
+/*
+ * we want to preserve the state of the metadata in the dump - whether it is
+ * intact or corrupt, so even if the buffer has a verifier attached to it we
+ * don't want to run it prior to writing the buffer to the metadump image.
+ * Even just recalculating the CRCs is the wrong thing to do here as it can
+ * hide errors that only the CRCs were detecting.
+ */
 static int
 write_buf(
 	iocur_t		*buf)
@@ -197,22 +204,6 @@ write_buf(
 	int		i;
 	int		ret;
 
-	/*
-	 * Run the write verifier to recalculate the buffer CRCs and check
-	 * we are writing something valid to disk
-	 */
-	if (buf->bp && buf->bp->b_ops) {
-		buf->bp->b_error = 0;
-		buf->bp->b_ops->verify_write(buf->bp);
-		if (buf->bp->b_error) {
-			fprintf(stderr,
-	_("%s: write verifer failed on bno 0x%llx/0x%x\n"),
-				__func__, (long long)buf->bp->b_bn,
-				buf->bp->b_bcount);
-			return -buf->bp->b_error;
-		}
-	}
-
 	/* handle discontiguous buffers */
 	if (!buf->bbmap) {
 		ret = write_buf_segment(buf->data, buf->bb, buf->blen);
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
