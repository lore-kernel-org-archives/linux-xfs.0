Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B43DE7F88
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 07:31:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 915998F8035
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 05:31:10 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Jpdxvt4Zd5FVbYqZ for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 05:31:09 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UFOM6-0001RZ-0m
	for xfs@oss.sgi.com; Tue, 12 Mar 2013 23:30:58 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UFOM5-0002Lg-T6
	for xfs@oss.sgi.com; Tue, 12 Mar 2013 23:30:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/21] xfs: ensure we capture IO errors correctly
Date: Tue, 12 Mar 2013 23:30:34 +1100
Message-Id: <1363091454-8852-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1363091454-8852-1-git-send-email-david@fromorbit.com>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
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

Failed buffer readahead can leave the buffer in the cache marked
with an error. Most callers that then issue a subsequent read on the
buffer do not zero the b_error field out, and so we may incorectly
detect an error during IO completion due to the stale error value
left on the buffer.

Avoid this problem by zeroing the error before IO submission. This
ensures that the only IO errors that are detected those captured
from are those captured from bio submission or completion.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 50eb603..82b70bd 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1336,6 +1336,12 @@ _xfs_buf_ioapply(
 	int		size;
 	int		i;
 
+	/*
+	 * Make sure we capture only current IO errors rather than stale errors
+	 * left over from previous use of the buffer (e.g. failed readahead).
+	 */
+	bp->b_error = 0;
+
 	if (bp->b_flags & XBF_WRITE) {
 		if (bp->b_flags & XBF_SYNCIO)
 			rw = WRITE_SYNC;
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
