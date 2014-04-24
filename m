Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 03B617F5F
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 00:02:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6F78AAC014
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 22:02:54 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	B6hSo7MFmUdSMVIk for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 22:02:50 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WdBnQ-0006xs-Of
	for xfs@oss.sgi.com; Thu, 24 Apr 2014 15:02:04 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WdBnQ-0005fx-O2
	for xfs@oss.sgi.com; Thu, 24 Apr 2014 15:02:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/9] db: don't claim unchecked CRCs are correct
Date: Thu, 24 Apr 2014 15:01:54 +1000
Message-Id: <1398315722-20870-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1398315722-20870-1-git-send-email-david@fromorbit.com>
References: <1398315722-20870-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/fprint.c      | 15 ++++++++++++++-
 db/io.c          |  2 ++
 db/io.h          | 12 +++++++++---
 include/libxfs.h |  1 +
 4 files changed, 26 insertions(+), 4 deletions(-)

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
diff --git a/include/libxfs.h b/include/libxfs.h
index 6bc6c94..6b1e276 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -333,6 +333,7 @@ enum xfs_buf_flags_t {	/* b_flags bits */
 	LIBXFS_B_STALE		= 0x0004,	/* buffer marked as invalid */
 	LIBXFS_B_UPTODATE	= 0x0008,	/* buffer is sync'd to disk */
 	LIBXFS_B_DISCONTIG	= 0x0010,	/* discontiguous buffer */
+	LIBXFS_B_UNCHECKED	= 0x0020,	/* needs verification */
 };
 
 #define XFS_BUF_DADDR_NULL		((xfs_daddr_t) (-1LL))
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
