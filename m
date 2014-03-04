Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C84E27F4E
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 02:52:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A40BF8F8065
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 00:52:16 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FUdXLuGyTJqS7tno for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 00:52:15 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WKl4w-0006Hf-PC
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WKl4w-000709-OS
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/13] xfs_db: Use EFSBADCRC for CRC validity indication
Date: Tue,  4 Mar 2014 19:51:56 +1100
Message-Id: <1393923117-9559-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1393923117-9559-1-git-send-email-david@fromorbit.com>
References: <1393923117-9559-1-git-send-email-david@fromorbit.com>
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

xfs_db currently gives indication as to whether a buffer CRC is ok
or not. Currently it does this by checking for EFSCORRUPTED in the
b_error field of the buffer. Not that we have EFSBADCRC to indicate
a bad CRC independently of structure corruption, use that instead to
drive the CRC correct/incorrect indication in the structured output.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/io.c | 5 +++--
 db/io.h | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/db/io.c b/db/io.c
index d29816c..9a787c8 100644
--- a/db/io.c
+++ b/db/io.c
@@ -521,10 +521,11 @@ set_cur(
 	}
 
 	/*
-	 * keep the buffer even if the verifier says it is corrupted.
+	 * Keep the buffer even if the verifier says it is corrupted.
 	 * We're a diagnostic tool, after all.
 	 */
-	if (!bp || (bp->b_error && bp->b_error != EFSCORRUPTED))
+	if (!bp || (bp->b_error && bp->b_error != EFSCORRUPTED &&
+				   bp->b_error != EFSBADCRC))
 		return;
 	iocur_top->buf = bp->b_addr;
 	iocur_top->bp = bp;
diff --git a/db/io.h b/db/io.h
index d8cf383..ad39bee 100644
--- a/db/io.h
+++ b/db/io.h
@@ -67,6 +67,6 @@ static inline bool
 iocur_crc_valid()
 {
 	return (iocur_top->bp &&
-		iocur_top->bp->b_error != EFSCORRUPTED &&
+		iocur_top->bp->b_error != EFSBADCRC &&
 		(!iocur_top->ino_buf || iocur_top->ino_crc_ok));
 }
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
