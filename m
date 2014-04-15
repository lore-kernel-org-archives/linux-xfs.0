Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0FE3B7F53
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 03:25:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CE4518F8033
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 01:25:09 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	BYFiivc1MVwsbAA4 for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 01:25:08 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WZyfv-0003WM-7D
	for xfs@oss.sgi.com; Tue, 15 Apr 2014 18:25:03 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WZyfv-0008Pk-6O
	for xfs@oss.sgi.com; Tue, 15 Apr 2014 18:25:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/9] db: don't claim unchecked CRCs are correct
Date: Tue, 15 Apr 2014 18:24:53 +1000
Message-Id: <1397550301-31883-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1397550301-31883-1-git-send-email-david@fromorbit.com>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
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

Currently xfs_db will claim the CRC on a structure is correct if the
buffer is not marked with an error. However, buffers may have been
read without a verifier, and hence have not had their CRCs
validated. in this case, we shoul dreport "unchecked" rather than
"correct". For example:

xfs_db> fsb 0x6003f
xfs_db> type dir3
xfs_db> p
dhdr.hdr.magic = 0x58444433
dhdr.hdr.crc = 0x2d0f9c9d (unchecked)
....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/fprint.c | 15 ++++++++++++++-
 db/io.c     |  2 ++
 db/io.h     | 12 +++++++++---
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/db/fprint.c b/db/fprint.c
index 435d984..52782e2 100644
--- a/db/fprint.c
+++ b/db/fprint.c
@@ -206,7 +206,20 @@ fp_crc(
 	__int64_t	val;
 	char		*ok;
 
-	ok = iocur_crc_valid() ? "correct" : "bad";
+	switch (iocur_crc_valid()) {
+	case -1:
+		ok = "unchecked";
+		break;
+	case 0:
+		ok = "bad";
+		break;
+	case 1:
+		ok = "correct";
+		break;
+	default:
+		ok = "unknown state";
+		break;
+	}
 
 	for (i = 0, bitpos = bit;
 	     i < count && !seenint();
diff --git a/db/io.c b/db/io.c
index 5eb61d9..387f171 100644
--- a/db/io.c
+++ b/db/io.c
@@ -531,6 +531,8 @@ set_cur(
 		return;
 	iocur_top->buf = bp->b_addr;
 	iocur_top->bp = bp;
+	if (!ops)
+		bp->b_flags |= LIBXFS_B_UNCHECKED;
 
 	iocur_top->bb = d;
 	iocur_top->blen = c;
diff --git a/db/io.h b/db/io.h
index ad39bee..7875119 100644
--- a/db/io.h
+++ b/db/io.h
@@ -63,10 +63,16 @@ extern void	set_cur(const struct typ *t, __int64_t d, int c, int ring_add,
 			bbmap_t *bbmap);
 extern void     ring_add(void);
 
-static inline bool
+/*
+ * returns -1 for unchecked, 0 for bad and 1 for good
+ */
+static inline int
 iocur_crc_valid()
 {
-	return (iocur_top->bp &&
-		iocur_top->bp->b_error != EFSBADCRC &&
+	if (!iocur_top->bp)
+		return -1;
+	if (iocur_top->bp->b_flags & LIBXFS_B_UNCHECKED)
+		return -1;
+	return (iocur_top->bp->b_error != EFSBADCRC &&
 		(!iocur_top->ino_buf || iocur_top->ino_crc_ok));
 }
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
